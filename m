From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/10] libfc: Move the port_id into lport
Date: Fri, 07 May 2010 15:18:41 -0700
Message-ID: <20100507221841.14971.47162.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0EGWSm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:42 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This patch creates a port_id member in struct fc_lport.
This allows libfc to just deal with fc_lport instances
instead of calling into the fc_host to get the port_id.

This change helps in only using symbols necessary for
operation from the libfc structures. libfc still needs
to change the fc_host_port_id() if the port_id changes
so the presentation layer (scsi_transport_fc) can provide
the user with the correct value, but libfc shouldn't
rely on the presentation layer for operational values.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c   |    9 ++++-----
 drivers/scsi/libfc/fc_disc.c  |    2 +-
 drivers/scsi/libfc/fc_elsct.c |    2 +-
 drivers/scsi/libfc/fc_exch.c  |    2 +-
 drivers/scsi/libfc/fc_fcp.c   |   14 +++++++-------
 drivers/scsi/libfc/fc_libfc.h |    2 +-
 drivers/scsi/libfc/fc_lport.c |   16 ++++++++++------
 drivers/scsi/libfc/fc_npiv.c  |    4 ++--
 include/scsi/fc_encode.h      |   18 +++++++-----------
 include/scsi/libfc.h          |    2 ++
 10 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index ec4c88c..948364a 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -343,7 +343,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 
 	fcf = fip->sel_fcf;
 	lp = fip->lp;
-	if (!fcf || !fc_host_port_id(lp->host))
+	if (!fcf || !lp->port_id)
 		return;
 
 	len = sizeof(*kal) + ports * sizeof(*vn);
@@ -374,7 +374,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 		vn->fd_desc.fip_dtype = FIP_DT_VN_ID;
 		vn->fd_desc.fip_dlen = sizeof(*vn) / FIP_BPW;
 		memcpy(vn->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
-		hton24(vn->fd_fc_id, fc_host_port_id(lp->host));
+		hton24(vn->fd_fc_id, lp->port_id);
 		put_unaligned_be64(lp->wwpn, &vn->fd_wwpn);
 	}
 	skb_put(skb, len);
@@ -949,7 +949,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
 
-	if (!fcf || !fc_host_port_id(lport->host))
+	if (!fcf || !lport->port_id)
 		return;
 
 	/*
@@ -987,8 +987,7 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 			if (compare_ether_addr(vp->fd_mac,
 					       fip->get_src_addr(lport)) == 0 &&
 			    get_unaligned_be64(&vp->fd_wwpn) == lport->wwpn &&
-			    ntoh24(vp->fd_fc_id) ==
-			    fc_host_port_id(lport->host))
+			    ntoh24(vp->fd_fc_id) == lport->port_id)
 				desc_mask &= ~BIT(FIP_DT_VN_ID);
 			break;
 		default:
diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index b292272..c7985da 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -440,7 +440,7 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 		ids.port_id = ntoh24(np->fp_fid);
 		ids.port_name = ntohll(np->fp_wwpn);
 
-		if (ids.port_id != fc_host_port_id(lport->host) &&
+		if (ids.port_id != lport->port_id &&
 		    ids.port_name != lport->wwpn) {
 			rdata = lport->tt.rport_create(lport, ids.port_id);
 			if (rdata) {
diff --git a/drivers/scsi/libfc/fc_elsct.c b/drivers/scsi/libfc/fc_elsct.c
index 5374872..e9412b7 100644
--- a/drivers/scsi/libfc/fc_elsct.c
+++ b/drivers/scsi/libfc/fc_elsct.c
@@ -63,7 +63,7 @@ struct fc_seq *fc_elsct_send(struct fc_lport *lport, u32 did,
 		return NULL;
 	}
 
-	fc_fill_fc_hdr(fp, r_ctl, did, fc_host_port_id(lport->host), fh_type,
+	fc_fill_fc_hdr(fp, r_ctl, did, lport->port_id, fh_type,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
 	return lport->tt.exch_seq_send(lport, fp, resp, NULL, arg, timer_msec);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 6addbd6..104e0fb 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1927,7 +1927,7 @@ static void fc_exch_rrq(struct fc_exch *ep)
 		did = ep->sid;
 
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, did,
-		       fc_host_port_id(lport->host), FC_TYPE_ELS,
+		       lport->port_id, FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
 	if (fc_exch_seq_send(lport, fp, fc_exch_rrq_resp, NULL, ep,
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 81a7c97..ec1f66c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -490,7 +490,7 @@ crc_err:
 			if (stats->InvalidCRCCount++ < 5)
 				printk(KERN_WARNING "libfc: CRC error on data "
 				       "frame for port (%6.6x)\n",
-				       fc_host_port_id(lport->host));
+				       lport->port_id);
 			put_cpu();
 			/*
 			 * Assume the frame is total garbage.
@@ -1109,7 +1109,7 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 	rpriv = rport->dd_data;
 
 	fc_fill_fc_hdr(fp, FC_RCTL_DD_UNSOL_CMD, rport->port_id,
-		       fc_host_port_id(rpriv->local_port->host), FC_TYPE_FCP,
+		       rpriv->local_port->port_id, FC_TYPE_FCP,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
 	seq = lport->tt.exch_seq_send(lport, fp, resp, fc_fcp_pkt_destroy,
@@ -1382,7 +1382,7 @@ static void fc_fcp_rec(struct fc_fcp_pkt *fsp)
 
 	fr_seq(fp) = fsp->seq_ptr;
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS_REQ, rport->port_id,
-		       fc_host_port_id(rpriv->local_port->host), FC_TYPE_ELS,
+		       rpriv->local_port->port_id, FC_TYPE_ELS,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 	if (lport->tt.elsct_send(lport, rport->port_id, fp, ELS_REC,
 				 fc_fcp_rec_resp, fsp,
@@ -1640,7 +1640,7 @@ static void fc_fcp_srr(struct fc_fcp_pkt *fsp, enum fc_rctl r_ctl, u32 offset)
 	srr->srr_rel_off = htonl(offset);
 
 	fc_fill_fc_hdr(fp, FC_RCTL_ELS4_REQ, rport->port_id,
-		       fc_host_port_id(rpriv->local_port->host), FC_TYPE_FCP,
+		       rpriv->local_port->port_id, FC_TYPE_FCP,
 		       FC_FC_FIRST_SEQ | FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
 
 	seq = lport->tt.exch_seq_send(lport, fp, fc_fcp_srr_resp, NULL,
@@ -2101,12 +2101,12 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	if (fc_fcp_lport_queue_ready(lport)) {
 		shost_printk(KERN_INFO, shost, "libfc: Host reset succeeded "
-			     "on port (%6.6x)\n", fc_host_port_id(lport->host));
+			     "on port (%6.6x)\n", lport->port_id);
 		return SUCCESS;
 	} else {
 		shost_printk(KERN_INFO, shost, "libfc: Host reset failed, "
 			     "port (%6.6x) is not ready.\n",
-			     fc_host_port_id(lport->host));
+			     lport->port_id);
 		return FAILED;
 	}
 }
@@ -2191,7 +2191,7 @@ void fc_fcp_destroy(struct fc_lport *lport)
 
 	if (!list_empty(&si->scsi_pkt_queue))
 		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
-		       "port (%6.6x)\n", fc_host_port_id(lport->host));
+		       "port (%6.6x)\n", lport->port_id);
 
 	mempool_destroy(si->scsi_pkt_pool);
 	kfree(si);
diff --git a/drivers/scsi/libfc/fc_libfc.h b/drivers/scsi/libfc/fc_libfc.h
index efc6b3f..f5c0ca4 100644
--- a/drivers/scsi/libfc/fc_libfc.h
+++ b/drivers/scsi/libfc/fc_libfc.h
@@ -47,7 +47,7 @@ extern unsigned int fc_debug_logging;
 	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
 			 printk(KERN_INFO "host%u: lport %6.6x: " fmt,	\
 				(lport)->host->host_no,			\
-				fc_host_port_id((lport)->host), ##args))
+				(lport)->port_id, ##args))
 
 #define FC_DISC_DBG(disc, fmt, args...)				\
 	FC_CHECK_LOGGING(FC_DISC_LOGGING,			\
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 7159bcf..79c9e3c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -565,7 +565,7 @@ void __fc_linkup(struct fc_lport *lport)
 void fc_linkup(struct fc_lport *lport)
 {
 	printk(KERN_INFO "host%d: libfc: Link up on port (%6.6x)\n",
-	       lport->host->host_no, fc_host_port_id(lport->host));
+	       lport->host->host_no, lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkup(lport);
@@ -595,7 +595,7 @@ void __fc_linkdown(struct fc_lport *lport)
 void fc_linkdown(struct fc_lport *lport)
 {
 	printk(KERN_INFO "host%d: libfc: Link down on port (%6.6x)\n",
-	       lport->host->host_no, fc_host_port_id(lport->host));
+	       lport->host->host_no, lport->port_id);
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkdown(lport);
@@ -697,7 +697,7 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 	case DISC_EV_FAILED:
 		printk(KERN_ERR "host%d: libfc: "
 		       "Discovery failed for port (%6.6x)\n",
-		       lport->host->host_no, fc_host_port_id(lport->host));
+		       lport->host->host_no, lport->port_id);
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -745,7 +745,11 @@ static void fc_lport_set_port_id(struct fc_lport *lport, u32 port_id,
 		printk(KERN_INFO "host%d: Assigned Port ID %6.6x\n",
 		       lport->host->host_no, port_id);
 
+	lport->port_id = port_id;
+
+	/* Update the fc_host */
 	fc_host_port_id(lport->host) = port_id;
+
 	if (lport->tt.lport_set_port_id)
 		lport->tt.lport_set_port_id(lport, port_id, fp);
 }
@@ -950,7 +954,7 @@ static void fc_lport_reset_locked(struct fc_lport *lport)
 	lport->tt.exch_mgr_reset(lport, 0, 0);
 	fc_host_fabric_name(lport->host) = 0;
 
-	if (fc_host_port_id(lport->host))
+	if (lport->port_id)
 		fc_lport_set_port_id(lport, 0, NULL);
 }
 
@@ -1695,7 +1699,7 @@ static int fc_lport_els_request(struct fc_bsg_job *job,
 	fh = fc_frame_header_get(fp);
 	fh->fh_r_ctl = FC_RCTL_ELS_REQ;
 	hton24(fh->fh_d_id, did);
-	hton24(fh->fh_s_id, fc_host_port_id(lport->host));
+	hton24(fh->fh_s_id, lport->port_id);
 	fh->fh_type = FC_TYPE_ELS;
 	hton24(fh->fh_f_ctl, FC_FC_FIRST_SEQ |
 	       FC_FC_END_SEQ | FC_FC_SEQ_INIT);
@@ -1755,7 +1759,7 @@ static int fc_lport_ct_request(struct fc_bsg_job *job,
 	fh = fc_frame_header_get(fp);
 	fh->fh_r_ctl = FC_RCTL_DD_UNSOL_CTL;
 	hton24(fh->fh_d_id, did);
-	hton24(fh->fh_s_id, fc_host_port_id(lport->host));
+	hton24(fh->fh_s_id, lport->port_id);
 	fh->fh_type = FC_TYPE_CT;
 	hton24(fh->fh_f_ctl, FC_FC_FIRST_SEQ |
 	       FC_FC_END_SEQ | FC_FC_SEQ_INIT);
diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index 45b6f1e..dd2b43b 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -69,7 +69,7 @@ struct fc_lport *fc_vport_id_lookup(struct fc_lport *n_port, u32 port_id)
 	struct fc_lport *lport = NULL;
 	struct fc_lport *vn_port;
 
-	if (fc_host_port_id(n_port->host) == port_id)
+	if (n_port->port_id == port_id)
 		return n_port;
 
 	if (port_id == FC_FID_FLOGI)
@@ -77,7 +77,7 @@ struct fc_lport *fc_vport_id_lookup(struct fc_lport *n_port, u32 port_id)
 
 	mutex_lock(&n_port->lp_mutex);
 	list_for_each_entry(vn_port, &n_port->vports, list) {
-		if (fc_host_port_id(vn_port->host) == port_id) {
+		if (vn_port->port_id == port_id) {
 			lport = vn_port;
 			break;
 		}
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 8eb0a0f..9b4867c 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -74,7 +74,7 @@ static inline void fc_adisc_fill(struct fc_lport *lport, struct fc_frame *fp)
 	adisc->adisc_cmd = ELS_ADISC;
 	put_unaligned_be64(lport->wwpn, &adisc->adisc_wwpn);
 	put_unaligned_be64(lport->wwnn, &adisc->adisc_wwnn);
-	hton24(adisc->adisc_port_id, fc_host_port_id(lport->host));
+	hton24(adisc->adisc_port_id, lport->port_id);
 }
 
 /**
@@ -127,15 +127,13 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 
 	case FC_NS_RFT_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rft));
-		hton24(ct->payload.rft.fid.fp_fid,
-		       fc_host_port_id(lport->host));
+		hton24(ct->payload.rft.fid.fp_fid, lport->port_id);
 		ct->payload.rft.fts = lport->fcts;
 		break;
 
 	case FC_NS_RFF_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rff_id));
-		hton24(ct->payload.rff.fr_fid.fp_fid,
-		       fc_host_port_id(lport->host));
+		hton24(ct->payload.rff.fr_fid.fp_fid, lport->port_id);
 		ct->payload.rff.fr_type = FC_TYPE_FCP;
 		if (lport->service_params & FCP_SPPF_INIT_FCN)
 			ct->payload.rff.fr_feat = FCP_FEAT_INIT;
@@ -145,16 +143,14 @@ static inline int fc_ct_fill(struct fc_lport *lport,
 
 	case FC_NS_RNN_ID:
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rn_id));
-		hton24(ct->payload.rn.fr_fid.fp_fid,
-		       fc_host_port_id(lport->host));
+		hton24(ct->payload.rn.fr_fid.fp_fid, lport->port_id);
 		put_unaligned_be64(lport->wwnn, &ct->payload.rn.fr_wwn);
 		break;
 
 	case FC_NS_RSPN_ID:
 		len = strnlen(fc_host_symbolic_name(lport->host), 255);
 		ct = fc_ct_hdr_fill(fp, op, sizeof(struct fc_ns_rspn) + len);
-		hton24(ct->payload.spn.fr_fid.fp_fid,
-		       fc_host_port_id(lport->host));
+		hton24(ct->payload.spn.fr_fid.fp_fid, lport->port_id);
 		strncpy(ct->payload.spn.fr_name,
 			fc_host_symbolic_name(lport->host), len);
 		ct->payload.spn.fr_name_len = len;
@@ -268,7 +264,7 @@ static inline void fc_logo_fill(struct fc_lport *lport, struct fc_frame *fp)
 	logo = fc_frame_payload_get(fp, sizeof(*logo));
 	memset(logo, 0, sizeof(*logo));
 	logo->fl_cmd = ELS_LOGO;
-	hton24(logo->fl_n_port_id, fc_host_port_id(lport->host));
+	hton24(logo->fl_n_port_id, lport->port_id);
 	logo->fl_n_port_wwn = htonll(lport->wwpn);
 }
 
@@ -295,7 +291,7 @@ static inline void fc_rec_fill(struct fc_lport *lport, struct fc_frame *fp)
 	rec = fc_frame_payload_get(fp, sizeof(*rec));
 	memset(rec, 0, sizeof(*rec));
 	rec->rec_cmd = ELS_REC;
-	hton24(rec->rec_s_id, fc_host_port_id(lport->host));
+	hton24(rec->rec_s_id, lport->port_id);
 	rec->rec_ox_id = htons(ep->oxid);
 	rec->rec_rx_id = htons(ep->rxid);
 }
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 1755fa7..7495c0b 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -780,6 +780,7 @@ struct fc_disc {
  * @dev_stats:             FCoE device stats (TODO: libfc should not be
  *                         FCoE aware)
  * @retry_count:           Number of retries in the current state
+ * @port_id:               FC Port ID
  * @wwpn:                  World Wide Port Name
  * @wwnn:                  World Wide Node Name
  * @service_params:        Common service parameters
@@ -826,6 +827,7 @@ struct fc_lport {
 	u8			       retry_count;
 
 	/* Fabric information */
+	u32                            port_id;
 	u64			       wwpn;
 	u64			       wwnn;
 	unsigned int		       service_params;

