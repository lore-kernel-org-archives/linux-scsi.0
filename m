From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 62/64] libfc: send GPN_ID in reaction to single-port RSCNs.
Date: Tue, 25 Aug 2009 14:03:58 -0700
Message-ID: <20090825210357.1553.1237.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:25643 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231AbZHYVD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 17:03:56 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

When an RSCN indicates changes to individual remote ports,
don't blindly log them out and then back in.  Instead, determine
whether they're still in the directory, by doing GPN_ID.

If that is successful, call login, which will send ADISC and reverify,
otherwise, call logoff.  Perhaps we should just delete the rport,
not send LOGO, but it seems safer.

Also, fix a possible issue where if a mix of records in the RSCN
cause us to queue disc_ports for disc_single and then we decide
to do full rediscovery, we leak memory for those disc_ports queued.

So, go through the list of disc_ports even if doing full discovery.
Free the disc_ports in any case.  If any of the disc_single() calls
return error, do a full discovery.

The ability to fill in GPN_ID requests was added to fc_ct_fill().
For this, it needs the FC_ID to be passed in as an arg.
The did parameter for fc_elsct_send() is used for that, since the
actual D_DID will always be 0xfffffc for all CT requests so far.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |  137 ++++++++++++++++++++++++++++++++++-------
 drivers/scsi/libfc/fc_elsct.c |    2 -
 include/scsi/fc_encode.h      |   16 ++++-
 3 files changed, 128 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4242894..c48799e 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -47,7 +47,7 @@ static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static void fc_disc_done(struct fc_disc *, enum fc_disc_event);
 static void fc_disc_timeout(struct work_struct *);
-static void fc_disc_single(struct fc_disc *, struct fc_disc_port *);
+static int fc_disc_single(struct fc_lport *, struct fc_disc_port *);
 static void fc_disc_restart(struct fc_disc *);
 
 /**
@@ -83,7 +83,6 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 				  struct fc_disc *disc)
 {
 	struct fc_lport *lport;
-	struct fc_rport_priv *rdata;
 	struct fc_els_rscn *rp;
 	struct fc_els_rscn_page *pp;
 	struct fc_seq_els_data rjt_data;
@@ -150,6 +149,19 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		}
 	}
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
+
+	/*
+	 * If not doing a complete rediscovery, do GPN_ID on
+	 * the individual ports mentioned in the list.
+	 * If any of these get an error, do a full rediscovery.
+	 * In any case, go through the list and free the entries.
+	 */
+	list_for_each_entry_safe(dp, next, &disc_ports, peers) {
+		list_del(&dp->peers);
+		if (!redisc)
+			redisc = fc_disc_single(lport, dp);
+		kfree(dp);
+	}
 	if (redisc) {
 		FC_DISC_DBG(disc, "RSCN received: rediscovering\n");
 		fc_disc_restart(disc);
@@ -157,14 +169,6 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		FC_DISC_DBG(disc, "RSCN received: not rediscovering. "
 			    "redisc %d state %d in_prog %d\n",
 			    redisc, lport->state, disc->pending);
-		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
-			list_del(&dp->peers);
-			rdata = lport->tt.rport_lookup(lport, dp->port_id);
-			if (rdata) {
-				lport->tt.rport_logoff(rdata);
-			}
-			fc_disc_single(disc, dp);
-		}
 	}
 	fc_frame_free(fp);
 	return;
@@ -562,32 +566,117 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 }
 
 /**
- * fc_disc_single() - Discover the directory information for a single target
- * @lport: FC local port
- * @dp: The port to rediscover
+ * fc_disc_gpn_id_resp() - Handle a response frame from Get Port Names (GPN_ID)
+ * @sp: exchange sequence
+ * @fp: response frame
+ * @rdata_arg: remote port private data
  *
- * Locking Note: This function expects that the disc_mutex is locked
- *		 before it is called.
+ * Locking Note: This function is called without disc mutex held.
  */
-static void fc_disc_single(struct fc_disc *disc, struct fc_disc_port *dp)
+static void fc_disc_gpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
+				void *rdata_arg)
 {
+	struct fc_rport_priv *rdata = rdata_arg;
+	struct fc_rport_priv *new_rdata;
 	struct fc_lport *lport;
-	struct fc_rport_priv *rdata;
+	struct fc_disc *disc;
+	struct fc_ct_hdr *cp;
+	struct fc_ns_gid_pn *pn;
+	u64 port_name;
 
-	lport = disc->lport;
+	lport = rdata->local_port;
+	disc = &lport->disc;
 
-	if (dp->port_id == fc_host_port_id(lport->host))
+	mutex_lock(&disc->disc_mutex);
+	if (PTR_ERR(fp) == -FC_EX_CLOSED)
 		goto out;
+	if (IS_ERR(fp))
+		goto redisc;
+
+	cp = fc_frame_payload_get(fp, sizeof(*cp));
+	if (!cp)
+		goto redisc;
+	if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
+		if (fr_len(fp) < sizeof(struct fc_frame_header) +
+		    sizeof(*cp) + sizeof(*pn))
+			goto redisc;
+		pn = (struct fc_ns_gid_pn *)(cp + 1);
+		port_name = get_unaligned_be64(&pn->fn_wwpn);
+		if (rdata->ids.port_name == -1)
+			rdata->ids.port_name = port_name;
+		else if (rdata->ids.port_name != port_name) {
+			FC_DISC_DBG(disc, "GPN_ID accepted.  WWPN changed. "
+				    "Port-id %x wwpn %llx\n",
+				    rdata->ids.port_id, port_name);
+			lport->tt.rport_logoff(rdata);
 
-	rdata = lport->tt.rport_create(lport, dp->port_id);
-	if (rdata) {
+			new_rdata = lport->tt.rport_create(lport,
+							   rdata->ids.port_id);
+			if (new_rdata) {
+				new_rdata->disc_id = disc->disc_id;
+				lport->tt.rport_login(new_rdata);
+			}
+			goto out;
+		}
 		rdata->disc_id = disc->disc_id;
-		kfree(dp);
 		lport->tt.rport_login(rdata);
+	} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
+		FC_DISC_DBG(disc, "GPN_ID rejected reason %x exp %x\n",
+			    cp->ct_reason, cp->ct_explan);
+		lport->tt.rport_logoff(rdata);
+	} else {
+		FC_DISC_DBG(disc, "GPN_ID unexpected response code %x\n",
+			    ntohs(cp->ct_cmd));
+redisc:
+		fc_disc_restart(disc);
 	}
-	return;
 out:
-	kfree(dp);
+	mutex_unlock(&disc->disc_mutex);
+	kref_put(&rdata->kref, lport->tt.rport_destroy);
+}
+
+/**
+ * fc_disc_gpn_id_req() - Send Get Port Names by ID (GPN_ID) request
+ * @lport: local port
+ * @rdata: remote port private data
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ * On failure, an error code is returned.
+ */
+static int fc_disc_gpn_id_req(struct fc_lport *lport,
+			      struct fc_rport_priv *rdata)
+{
+	struct fc_frame *fp;
+
+	fp = fc_frame_alloc(lport, sizeof(struct fc_ct_hdr) +
+			    sizeof(struct fc_ns_fid));
+	if (!fp)
+		return -ENOMEM;
+	if (!lport->tt.elsct_send(lport, rdata->ids.port_id, fp, FC_NS_GPN_ID,
+				 fc_disc_gpn_id_resp, rdata, lport->e_d_tov))
+		return -ENOMEM;
+	kref_get(&rdata->kref);
+	return 0;
+}
+
+/**
+ * fc_disc_single() - Discover the directory information for a single target
+ * @lport: local port
+ * @dp: The port to rediscover
+ *
+ * Locking Note: This function expects that the disc_mutex is locked
+ *		 before it is called.
+ */
+static int fc_disc_single(struct fc_lport *lport, struct fc_disc_port *dp)
+{
+	struct fc_rport_priv *rdata;
+
+	rdata = lport->tt.rport_create(lport, dp->port_id);
+	if (!rdata)
+		return -ENOMEM;
+	rdata->disc_id = 0;
+	return fc_disc_gpn_id_req(lport, rdata);
 }
 
 /**
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index d655924..5cfa687 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -49,7 +49,7 @@ static struct fc_seq *fc_elsct_send(struct fc_lport *lport,
 		rc = fc_els_fill(lport, did, fp, op, &r_ctl, &fh_type);
 	else {
 		/* CT requests */
-		rc = fc_ct_fill(lport, fp, op, &r_ctl, &fh_type);
+		rc = fc_ct_fill(lport, did, fp, op, &r_ctl, &fh_type);
 		did = FC_FID_DIR_SERV;
 	}
 
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index c5ee6bb..27dad70 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -32,6 +32,7 @@ struct fc_ct_req {
 		struct fc_ns_gid_ft gid;
 		struct fc_ns_rn_id  rn;
 		struct fc_ns_rft rft;
+		struct fc_ns_fid fid;
 	} payload;
 };
 
@@ -94,10 +95,16 @@ static inline struct fc_ct_req *fc_ct_hdr_fill(const struct fc_frame *fp,
 }
 
 /**
- * fc_ct_fill - Fill in a name service request frame
+ * fc_ct_fill() - Fill in a name service request frame
+ * @lport: local port.
+ * @fc_id: FC_ID of non-destination rport for GPN_ID and similar inquiries.
+ * @fp: frame to contain payload.
+ * @op: CT opcode.
+ * @r_ctl: pointer to FC header R_CTL.
+ * @fh_type: pointer to FC-4 type.
  */
 static inline int fc_ct_fill(struct fc_lport *lport,
-		      struct fc_frame *fp,
+		      u32 fc_id, struct fc_frame *fp,
 		      unsigned int op, enum fc_rctl *r_ctl,
 		      enum fc_fh_type *fh_type)
 {
@@ -109,6 +116,11 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 		ct->payload.gid.fn_fc4_type = FC_TYPE_FCP;
 		break;
 
+	case FC_NS_GPN_ID:
+		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_fid));
+		hton24(ct->payload.fid.fp_fid, fc_id);
+		break;
+
 	case FC_NS_RFT_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rft));
 		hton24(ct->payload.rft.fid.fp_fid,

