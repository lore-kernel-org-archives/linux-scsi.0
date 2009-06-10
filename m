From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/3] libfc: Add runtime debugging with debug_logging module
	parameter
Date: Wed, 10 Jun 2009 15:31:10 -0700
Message-ID: <20090610223110.11663.56716.stgit@fritz>
References: <20090610223054.11663.26451.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26844 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697AbZFJWbI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 18:31:08 -0400
In-Reply-To: <20090610223054.11663.26451.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This patch adds the /sys/module/libfc/parameters/debug_logging
file to sysfs as a module parameter. It accepts an integer
bitmask for logging. Currently it supports:

   bit
LSB 0 = general libfc debugging
    1 = lport debugging
    2 = disc debugging
    3 = rport debugging
    4 = fcp debugging
    5 = EM debugging
    6 = exch/seq debugging
    7 = scsi logging (mostly error handling)

the other bits are not used at this time.

The patch converts all of the libfc source files to use
these new macros and removes the old FC_DBG macro.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_disc.c  |   83 +++++++++-------------
 drivers/scsi/libfc/fc_exch.c  |   58 +++++++--------
 drivers/scsi/libfc/fc_fcp.c   |   97 +++++++++++++------------
 drivers/scsi/libfc/fc_lport.c |  156 ++++++++++++++++++++---------------------
 drivers/scsi/libfc/fc_rport.c |  120 +++++++++++++-------------------
 include/scsi/fc_encode.h      |    2 -
 include/scsi/libfc.h          |   77 +++++++++++++++++---
 7 files changed, 301 insertions(+), 292 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 4c88065..6fabf66 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -45,14 +45,6 @@
 
 #define	FC_DISC_DELAY		3
 
-static int fc_disc_debug;
-
-#define FC_DEBUG_DISC(fmt...)			\
-	do {					\
-		if (fc_disc_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static void fc_disc_gpn_ft_req(struct fc_disc *);
 static void fc_disc_gpn_ft_resp(struct fc_seq *, struct fc_frame *, void *);
 static int fc_disc_new_target(struct fc_disc *, struct fc_rport *,
@@ -137,8 +129,8 @@ static void fc_disc_rport_callback(struct fc_lport *lport,
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_disc *disc = &lport->disc;
 
-	FC_DEBUG_DISC("Received a %d event for port (%6x)\n", event,
-		      rport->port_id);
+	FC_DISC_DBG(disc, "Received a %d event for port (%6x)\n", event,
+		    rport->port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
@@ -191,8 +183,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 
 	lport = disc->lport;
 
-	FC_DEBUG_DISC("Received an RSCN event on port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG(disc, "Received an RSCN event\n");
 
 	/* make sure the frame contains an RSCN message */
 	rp = fc_frame_payload_get(fp, sizeof(*rp));
@@ -225,8 +216,8 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		 */
 		switch (fmt) {
 		case ELS_ADDR_FMT_PORT:
-			FC_DEBUG_DISC("Port address format for port (%6x)\n",
-				      ntoh24(pp->rscn_fid));
+			FC_DISC_DBG(disc, "Port address format for port "
+				    "(%6x)\n", ntoh24(pp->rscn_fid));
 			dp = kzalloc(sizeof(*dp), GFP_KERNEL);
 			if (!dp) {
 				redisc = 1;
@@ -243,19 +234,19 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 		case ELS_ADDR_FMT_DOM:
 		case ELS_ADDR_FMT_FAB:
 		default:
-			FC_DEBUG_DISC("Address format is (%d)\n", fmt);
+			FC_DISC_DBG(disc, "Address format is (%d)\n", fmt);
 			redisc = 1;
 			break;
 		}
 	}
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	if (redisc) {
-		FC_DEBUG_DISC("RSCN received: rediscovering\n");
+		FC_DISC_DBG(disc, "RSCN received: rediscovering\n");
 		fc_disc_restart(disc);
 	} else {
-		FC_DEBUG_DISC("RSCN received: not rediscovering. "
-			      "redisc %d state %d in_prog %d\n",
-			      redisc, lport->state, disc->pending);
+		FC_DISC_DBG(disc, "RSCN received: not rediscovering. "
+			    "redisc %d state %d in_prog %d\n",
+			    redisc, lport->state, disc->pending);
 		list_for_each_entry_safe(dp, next, &disc_ports, peers) {
 			list_del(&dp->peers);
 			rport = lport->tt.rport_lookup(lport, dp->ids.port_id);
@@ -270,7 +261,7 @@ static void fc_disc_recv_rscn_req(struct fc_seq *sp, struct fc_frame *fp,
 	fc_frame_free(fp);
 	return;
 reject:
-	FC_DEBUG_DISC("Received a bad RSCN frame\n");
+	FC_DISC_DBG(disc, "Received a bad RSCN frame\n");
 	rjt_data.fp = NULL;
 	rjt_data.reason = ELS_RJT_LOGIC;
 	rjt_data.explan = ELS_EXPL_NONE;
@@ -302,7 +293,8 @@ static void fc_disc_recv_req(struct fc_seq *sp, struct fc_frame *fp,
 		mutex_unlock(&disc->disc_mutex);
 		break;
 	default:
-		FC_DBG("Received an unsupported request. opcode (%x)\n", op);
+		FC_DISC_DBG(disc, "Received an unsupported request, "
+			    "the opcode is (%x)\n", op);
 		break;
 	}
 }
@@ -320,12 +312,10 @@ static void fc_disc_restart(struct fc_disc *disc)
 	struct fc_rport_libfc_priv *rdata, *next;
 	struct fc_lport *lport = disc->lport;
 
-	FC_DEBUG_DISC("Restarting discovery for port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG(disc, "Restarting discovery\n");
 
 	list_for_each_entry_safe(rdata, next, &disc->rports, peers) {
 		rport = PRIV_TO_RPORT(rdata);
-		FC_DEBUG_DISC("list_del(%6x)\n", rport->port_id);
 		list_del(&rdata->peers);
 		lport->tt.rport_logoff(rport);
 	}
@@ -485,8 +475,7 @@ static void fc_disc_done(struct fc_disc *disc)
 	struct fc_lport *lport = disc->lport;
 	enum fc_disc_event event;
 
-	FC_DEBUG_DISC("Discovery complete for port (%6x)\n",
-		      fc_host_port_id(lport->host));
+	FC_DISC_DBG(disc, "Discovery complete\n");
 
 	event = disc->event;
 	disc->event = DISC_EV_NONE;
@@ -510,10 +499,10 @@ static void fc_disc_error(struct fc_disc *disc, struct fc_frame *fp)
 {
 	struct fc_lport *lport = disc->lport;
 	unsigned long delay = 0;
-	if (fc_disc_debug)
-		FC_DBG("Error %ld, retries %d/%d\n",
-		       PTR_ERR(fp), disc->retry_count,
-		       FC_DISC_RETRY_LIMIT);
+
+	FC_DISC_DBG(disc, "Error %ld, retries %d/%d\n",
+		    PTR_ERR(fp), disc->retry_count,
+		    FC_DISC_RETRY_LIMIT);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
@@ -649,9 +638,9 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 					      &disc->rogue_rports);
 				lport->tt.rport_login(rport);
 			} else
-				FC_DBG("Failed to allocate memory for "
-				       "the newly discovered port (%6x)\n",
-				       dp.ids.port_id);
+				printk(KERN_WARNING "libfc: Failed to allocate "
+				       "memory for the newly discovered port "
+				       "(%6x)\n", dp.ids.port_id);
 		}
 
 		if (np->fp_flags & FC_NS_FID_LAST) {
@@ -671,9 +660,8 @@ static int fc_disc_gpn_ft_parse(struct fc_disc *disc, void *buf, size_t len)
 	 */
 	if (error == 0 && len > 0 && len < sizeof(*np)) {
 		if (np != &disc->partial_buf) {
-			FC_DEBUG_DISC("Partial buffer remains "
-				      "for discovery by (%6x)\n",
-				      fc_host_port_id(lport->host));
+			FC_DISC_DBG(disc, "Partial buffer remains "
+				    "for discovery\n");
 			memcpy(&disc->partial_buf, np, len);
 		}
 		disc->buf_len = (unsigned char) len;
@@ -721,8 +709,7 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	int error;
 
 	mutex_lock(&disc->disc_mutex);
-	FC_DEBUG_DISC("Received a GPN_FT response on port (%6x)\n",
-		      fc_host_port_id(disc->lport->host));
+	FC_DISC_DBG(disc, "Received a GPN_FT response\n");
 
 	if (IS_ERR(fp)) {
 		fc_disc_error(disc, fp);
@@ -738,30 +725,30 @@ static void fc_disc_gpn_ft_resp(struct fc_seq *sp, struct fc_frame *fp,
 	    disc->seq_count == 0) {
 		cp = fc_frame_payload_get(fp, sizeof(*cp));
 		if (!cp) {
-			FC_DBG("GPN_FT response too short, len %d\n",
-			       fr_len(fp));
+			FC_DISC_DBG(disc, "GPN_FT response too short, len %d\n",
+				    fr_len(fp));
 		} else if (ntohs(cp->ct_cmd) == FC_FS_ACC) {
 
 			/* Accepted, parse the response. */
 			buf = cp + 1;
 			len -= sizeof(*cp);
 		} else if (ntohs(cp->ct_cmd) == FC_FS_RJT) {
-			FC_DBG("GPN_FT rejected reason %x exp %x "
-			       "(check zoning)\n", cp->ct_reason,
-			       cp->ct_explan);
+			FC_DISC_DBG(disc, "GPN_FT rejected reason %x exp %x "
+				    "(check zoning)\n", cp->ct_reason,
+				    cp->ct_explan);
 			disc->event = DISC_EV_FAILED;
 			fc_disc_done(disc);
 		} else {
-			FC_DBG("GPN_FT unexpected response code %x\n",
-			       ntohs(cp->ct_cmd));
+			FC_DISC_DBG(disc, "GPN_FT unexpected response code "
+				    "%x\n", ntohs(cp->ct_cmd));
 		}
 	} else if (fr_sof(fp) == FC_SOF_N3 &&
 		   seq_cnt == disc->seq_count) {
 		buf = fh + 1;
 	} else {
-		FC_DBG("GPN_FT unexpected frame - out of sequence? "
-		       "seq_cnt %x expected %x sof %x eof %x\n",
-		       seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
+		FC_DISC_DBG(disc, "GPN_FT unexpected frame - out of sequence? "
+			    "seq_cnt %x expected %x sof %x eof %x\n",
+			    seq_cnt, disc->seq_count, fr_sof(fp), fr_eof(fp));
 	}
 	if (buf) {
 		error = fc_disc_gpn_ft_parse(disc, buf, len);
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 7af9bce..2bc22be 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -32,18 +32,7 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-/*
- * fc_exch_debug can be set in debugger or at compile time to get more logs.
- */
-static int fc_exch_debug;
-
-#define FC_DEBUG_EXCH(fmt...)			\
-	do {					\
-		if (fc_exch_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
-static struct kmem_cache *fc_em_cachep;	/* cache for exchanges */
+static struct kmem_cache *fc_em_cachep;        /* cache for exchanges */
 
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
@@ -333,8 +322,8 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
 		return;
 
-	FC_DEBUG_EXCH("Exchange (%4x) timed out, notifying the upper layer\n",
-		      ep->xid);
+	FC_EXCH_DBG(ep, "Exchange timed out, notifying the upper layer\n");
+
 	if (schedule_delayed_work(&ep->timeout_work,
 				  msecs_to_jiffies(timer_msec)))
 		fc_exch_hold(ep);		/* hold for timer */
@@ -545,7 +534,7 @@ struct fc_exch *fc_exch_alloc(struct fc_exch_mgr *mp,
 		/* alloc a new xid */
 		xid = fc_em_alloc_xid(mp, fp);
 		if (!xid) {
-			printk(KERN_ERR "fc_em_alloc_xid() failed\n");
+			printk(KERN_WARNING "libfc: Failed to allocate an exhange\n");
 			goto err;
 		}
 	}
@@ -820,8 +809,8 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp)
 	struct fc_exch *ep = fc_seq_exch(sp);
 
 	sp = fc_seq_alloc(ep, ep->seq_id++);
-	FC_DEBUG_EXCH("exch %4x f_ctl %6x seq %2x\n",
-		      ep->xid, ep->f_ctl, sp->id);
+	FC_EXCH_DBG(ep, "f_ctl %6x seq %2x\n",
+		    ep->f_ctl, sp->id);
 	return sp;
 }
 /*
@@ -901,7 +890,7 @@ void fc_seq_els_rsp_send(struct fc_seq *sp, enum fc_els_cmd els_cmd,
 		fc_exch_els_rec(sp, els_data->fp);
 		break;
 	default:
-		FC_DBG("Invalid ELS CMD:%x\n", els_cmd);
+		FC_EXCH_DBG(fc_seq_exch(sp), "Invalid ELS CMD:%x\n", els_cmd);
 	}
 }
 EXPORT_SYMBOL(fc_seq_els_rsp_send);
@@ -1134,7 +1123,7 @@ static void fc_exch_recv_req(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			lp->tt.lport_recv(lp, sp, fp);
 		fc_exch_release(ep);	/* release from lookup */
 	} else {
-		FC_DEBUG_EXCH("exch/seq lookup failed: reject %x\n", reject);
+		FC_EM_DBG(mp, "exch/seq lookup failed: reject %x\n", reject);
 		fc_frame_free(fp);
 	}
 }
@@ -1242,10 +1231,10 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
 	if (!sp) {
 		atomic_inc(&mp->stats.xid_not_found);
-		FC_DEBUG_EXCH("seq lookup failed\n");
+		FC_EM_DBG(mp, "seq lookup failed\n");
 	} else {
 		atomic_inc(&mp->stats.non_bls_resp);
-		FC_DEBUG_EXCH("non-BLS response to sequence");
+		FC_EM_DBG(mp, "non-BLS response to sequence");
 	}
 	fc_frame_free(fp);
 }
@@ -1266,8 +1255,8 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	int rc = 1, has_rec = 0;
 
 	fh = fc_frame_header_get(fp);
-	FC_DEBUG_EXCH("exch: BLS rctl %x - %s\n",
-		      fh->fh_r_ctl, fc_exch_rctl_name(fh->fh_r_ctl));
+	FC_EXCH_DBG(ep, "exch: BLS rctl %x - %s\n", fh->fh_r_ctl,
+		    fc_exch_rctl_name(fh->fh_r_ctl));
 
 	if (cancel_delayed_work_sync(&ep->timeout_work))
 		fc_exch_release(ep);	/* release from pending timer hold */
@@ -1359,9 +1348,9 @@ static void fc_exch_recv_bls(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		case FC_RCTL_ACK_0:
 			break;
 		default:
-			FC_DEBUG_EXCH("BLS rctl %x - %s received",
-				      fh->fh_r_ctl,
-				      fc_exch_rctl_name(fh->fh_r_ctl));
+			FC_EXCH_DBG(ep, "BLS rctl %x - %s received",
+				    fh->fh_r_ctl,
+				    fc_exch_rctl_name(fh->fh_r_ctl));
 			break;
 		}
 		fc_frame_free(fp);
@@ -1599,7 +1588,8 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
 			goto cleanup;
-		FC_DBG("Cannot process RRQ, because of frame error %d\n", err);
+		FC_EXCH_DBG(aborted_ep, "Cannot process RRQ, "
+			    "frame error %d\n", err);
 		return;
 	}
 
@@ -1608,12 +1598,13 @@ static void fc_exch_rrq_resp(struct fc_seq *sp, struct fc_frame *fp, void *arg)
 
 	switch (op) {
 	case ELS_LS_RJT:
-		FC_DBG("LS_RJT for RRQ");
+		FC_EXCH_DBG(aborted_ep, "LS_RJT for RRQ");
 		/* fall through */
 	case ELS_LS_ACC:
 		goto cleanup;
 	default:
-		FC_DBG("unexpected response op %x for RRQ", op);
+		FC_EXCH_DBG(aborted_ep, "unexpected response op %x "
+			    "for RRQ", op);
 		return;
 	}
 
@@ -1740,8 +1731,8 @@ struct fc_exch_mgr *fc_exch_mgr_alloc(struct fc_lport *lp,
 	size_t len;
 
 	if (max_xid <= min_xid || min_xid == 0 || max_xid == FC_XID_UNKNOWN) {
-		FC_DBG("Invalid min_xid 0x:%x and max_xid 0x:%x\n",
-		       min_xid, max_xid);
+		FC_LPORT_DBG(lp, "Invalid min_xid 0x:%x and max_xid 0x:%x\n",
+			     min_xid, max_xid);
 		return NULL;
 	}
 
@@ -1878,7 +1869,8 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 
 	/* lport lock ? */
 	if (!lp || !mp || (lp->state == LPORT_ST_NONE)) {
-		FC_DBG("fc_lport or EM is not allocated and configured");
+		FC_LPORT_DBG(lp, "Receiving frames for an lport that "
+			     "has not been initialized correctly\n");
 		fc_frame_free(fp);
 		return;
 	}
@@ -1904,7 +1896,7 @@ void fc_exch_recv(struct fc_lport *lp, struct fc_exch_mgr *mp,
 			fc_exch_recv_req(lp, mp, fp);
 		break;
 	default:
-		FC_DBG("dropping invalid frame (eof %x)", fr_eof(fp));
+		FC_EM_DBG(mp, "dropping invalid frame (eof %x)", fr_eof(fp));
 		fc_frame_free(fp);
 		break;
 	}
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ad8b747..e303e0d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -43,13 +43,9 @@ MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("libfc");
 MODULE_LICENSE("GPL v2");
 
-static int fc_fcp_debug;
-
-#define FC_DEBUG_FCP(fmt...)			\
-	do {					\
-		if (fc_fcp_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
+unsigned int fc_debug_logging;
+module_param_named(debug_logging, fc_debug_logging, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
 static struct kmem_cache *scsi_pkt_cachep;
 
@@ -347,8 +343,8 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		if ((fr_flags(fp) & FCPHF_CRC_UNCHECKED) &&
 		    fc_frame_crc_check(fp))
 			goto crc_err;
-		FC_DEBUG_FCP("data received past end. len %zx offset %zx "
-			     "data_len %x\n", len, offset, fsp->data_len);
+		FC_FCP_DBG(fsp, "data received past end. len %zx offset %zx "
+			   "data_len %x\n", len, offset, fsp->data_len);
 		fc_fcp_retry_cmd(fsp);
 		return;
 	}
@@ -411,7 +407,8 @@ crc_err:
 			stats->ErrorFrames++;
 			/* FIXME - per cpu count, not total count! */
 			if (stats->InvalidCRCCount++ < 5)
-				printk(KERN_WARNING "CRC error on data frame for port (%6x)\n",
+				printk(KERN_WARNING "libfc: CRC error on data "
+				       "frame for port (%6x)\n",
 				       fc_host_port_id(lp->host));
 			/*
 			 * Assume the frame is total garbage.
@@ -475,14 +472,14 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	WARN_ON(seq_blen <= 0);
 	if (unlikely(offset + seq_blen > fsp->data_len)) {
 		/* this should never happen */
-		FC_DEBUG_FCP("xfer-ready past end. seq_blen %zx offset %zx\n",
-			     seq_blen, offset);
+		FC_FCP_DBG(fsp, "xfer-ready past end. seq_blen %zx "
+			   "offset %zx\n", seq_blen, offset);
 		fc_fcp_send_abort(fsp);
 		return 0;
 	} else if (offset != fsp->xfer_len) {
 		/* Out of Order Data Request - no problem, but unexpected. */
-		FC_DEBUG_FCP("xfer-ready non-contiguous. "
-			     "seq_blen %zx offset %zx\n", seq_blen, offset);
+		FC_FCP_DBG(fsp, "xfer-ready non-contiguous. "
+			   "seq_blen %zx offset %zx\n", seq_blen, offset);
 	}
 
 	/*
@@ -493,7 +490,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	t_blen = fsp->max_payload;
 	if (lp->seq_offload) {
 		t_blen = min(seq_blen, (size_t)lp->lso_max);
-		FC_DEBUG_FCP("fsp=%p:lso:blen=%zx lso_max=0x%x t_blen=%zx\n",
+		FC_FCP_DBG(fsp, "fsp=%p:lso:blen=%zx lso_max=0x%x t_blen=%zx\n",
 			   fsp, seq_blen, lp->lso_max, t_blen);
 	}
 
@@ -694,7 +691,7 @@ static void fc_fcp_reduce_can_queue(struct fc_lport *lp)
 	if (!can_queue)
 		can_queue = 1;
 	lp->host->can_queue = can_queue;
-	shost_printk(KERN_ERR, lp->host, "Could not allocate frame.\n"
+	shost_printk(KERN_ERR, lp->host, "libfc: Could not allocate frame.\n"
 		     "Reducing can_queue to %d.\n", can_queue);
 done:
 	spin_unlock_irqrestore(lp->host->host_lock, flags);
@@ -768,7 +765,7 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 
 		fc_fcp_resp(fsp, fp);
 	} else {
-		FC_DBG("unexpected frame.  r_ctl %x\n", r_ctl);
+		FC_FCP_DBG(fsp, "unexpected frame.  r_ctl %x\n", r_ctl);
 	}
 unlock:
 	fc_fcp_unlock_pkt(fsp);
@@ -877,17 +874,17 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			return;
 		}
 		fsp->status_code = FC_DATA_OVRRUN;
-		FC_DBG("tgt %6x xfer len %zx greater than expected len %x. "
-		       "data len %x\n",
-		       fsp->rport->port_id,
-		       fsp->xfer_len, expected_len, fsp->data_len);
+		FC_FCP_DBG(fsp, "tgt %6x xfer len %zx greater than expected, "
+			   "len %x, data len %x\n",
+			   fsp->rport->port_id,
+			   fsp->xfer_len, expected_len, fsp->data_len);
 	}
 	fc_fcp_complete_locked(fsp);
 	return;
 
 len_err:
-	FC_DBG("short FCP response. flags 0x%x len %u respl %u snsl %u\n",
-	       flags, fr_len(fp), respl, snsl);
+	FC_FCP_DBG(fsp, "short FCP response. flags 0x%x len %u respl %u "
+		   "snsl %u\n", flags, fr_len(fp), respl, snsl);
 err:
 	fsp->status_code = FC_ERROR;
 	fc_fcp_complete_locked(fsp);
@@ -1107,13 +1104,11 @@ static void fc_fcp_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 	if (fc_fcp_lock_pkt(fsp))
 		return;
 
-	switch (error) {
-	case -FC_EX_CLOSED:
+	if (error == -FC_EX_CLOSED) {
 		fc_fcp_retry_cmd(fsp);
 		goto unlock;
-	default:
-		FC_DBG("unknown error %ld\n", PTR_ERR(fp));
 	}
+
 	/*
 	 * clear abort pending, because the lower layer
 	 * decided to force completion.
@@ -1145,10 +1140,10 @@ static int fc_fcp_pkt_abort(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
 	fsp->wait_for_comp = 0;
 
 	if (!rc) {
-		FC_DBG("target abort cmd  failed\n");
+		FC_FCP_DBG(fsp, "target abort cmd  failed\n");
 		rc = FAILED;
 	} else if (fsp->state & FC_SRB_ABORTED) {
-		FC_DBG("target abort cmd  passed\n");
+		FC_FCP_DBG(fsp, "target abort cmd  passed\n");
 		rc = SUCCESS;
 		fc_fcp_complete_locked(fsp);
 	}
@@ -1213,7 +1208,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 
 	if (!rc) {
-		FC_DBG("lun reset failed\n");
+		FC_SCSI_DBG(lp, "lun reset failed\n");
 		return FAILED;
 	}
 
@@ -1221,7 +1216,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 	if (fsp->cdb_status != FCP_TMF_CMPL)
 		return FAILED;
 
-	FC_DBG("lun reset to lun %u completed\n", lun);
+	FC_SCSI_DBG(lp, "lun reset to lun %u completed\n", lun);
 	fc_fcp_cleanup_each_cmd(lp, id, lun, FC_CMD_ABORTED);
 	return SUCCESS;
 }
@@ -1388,13 +1383,13 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		switch (rjt->er_reason) {
 		default:
-			FC_DEBUG_FCP("device %x unexpected REC reject "
-				     "reason %d expl %d\n",
-				     fsp->rport->port_id, rjt->er_reason,
-				     rjt->er_explan);
+			FC_FCP_DBG(fsp, "device %x unexpected REC reject "
+				   "reason %d expl %d\n",
+				   fsp->rport->port_id, rjt->er_reason,
+				   rjt->er_explan);
 			/* fall through */
 		case ELS_RJT_UNSUP:
-			FC_DEBUG_FCP("device does not support REC\n");
+			FC_FCP_DBG(fsp, "device does not support REC\n");
 			rp = fsp->rport->dd_data;
 			/*
 			 * if we do not spport RECs or got some bogus
@@ -1514,8 +1509,8 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		break;
 
 	default:
-		FC_DBG("REC %p fid %x error unexpected error %d\n",
-		       fsp, fsp->rport->port_id, error);
+		FC_FCP_DBG(fsp, "REC %p fid %x error unexpected error %d\n",
+			   fsp, fsp->rport->port_id, error);
 		fsp->status_code = FC_CMD_PLOGO;
 		/* fall through */
 
@@ -1524,9 +1519,9 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		 * Assume REC or LS_ACC was lost.
 		 * The exchange manager will have aborted REC, so retry.
 		 */
-		FC_DBG("REC fid %x error error %d retry %d/%d\n",
-		       fsp->rport->port_id, error, fsp->recov_retry,
-		       FC_MAX_RECOV_RETRY);
+		FC_FCP_DBG(fsp, "REC fid %x error error %d retry %d/%d\n",
+			   fsp->rport->port_id, error, fsp->recov_retry,
+			   FC_MAX_RECOV_RETRY);
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
@@ -2011,9 +2006,11 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (lp->state != LPORT_ST_READY)
 		return rc;
 
+	FC_SCSI_DBG(lp, "Resetting rport (%6x)\n", rport->port_id);
+
 	fsp = fc_fcp_pkt_alloc(lp, GFP_NOIO);
 	if (fsp == NULL) {
-		FC_DBG("could not allocate scsi_pkt\n");
+		printk(KERN_WARNING "libfc: could not allocate scsi_pkt\n");
 		sc_cmd->result = DID_NO_CONNECT << 16;
 		goto out;
 	}
@@ -2048,17 +2045,21 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 	struct fc_lport *lp = shost_priv(shost);
 	unsigned long wait_tmo;
 
+	FC_SCSI_DBG(lp, "Resetting host\n");
+
 	lp->tt.lport_reset(lp);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lp) && time_before(jiffies, wait_tmo))
 		msleep(1000);
 
 	if (fc_fcp_lport_queue_ready(lp)) {
-		shost_printk(KERN_INFO, shost, "Host reset succeeded.\n");
+		shost_printk(KERN_INFO, shost, "libfc: Host reset succeeded "
+			     "on port (%6x)\n", fc_host_port_id(lp->host));
 		return SUCCESS;
 	} else {
-		shost_printk(KERN_INFO, shost, "Host reset failed. "
-			     "lport not ready.\n");
+		shost_printk(KERN_INFO, shost, "libfc: Host reset failed, "
+			     "port (%6x) is not ready.\n",
+			     fc_host_port_id(lp->host));
 		return FAILED;
 	}
 }
@@ -2117,7 +2118,8 @@ void fc_fcp_destroy(struct fc_lport *lp)
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
 
 	if (!list_empty(&si->scsi_pkt_queue))
-		printk(KERN_ERR "Leaked scsi packets.\n");
+		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
+		       "port (%6x)\n", fc_host_port_id(lp->host));
 
 	mempool_destroy(si->scsi_pkt_pool);
 	kfree(si);
@@ -2166,7 +2168,8 @@ static int __init libfc_init(void)
 					    sizeof(struct fc_fcp_pkt),
 					    0, SLAB_HWCACHE_ALIGN, NULL);
 	if (scsi_pkt_cachep == NULL) {
-		FC_DBG("Unable to allocate SRB cache...module load failed!");
+		printk(KERN_ERR "libfc: Unable to allocate SRB cache, "
+		       "module load failed!");
 		return -ENOMEM;
 	}
 
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index e0c2477..745fa55 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -101,14 +101,6 @@
 
 #define	DNS_DELAY	      3 /* Discovery delay after RSCN (in seconds)*/
 
-static int fc_lport_debug;
-
-#define FC_DEBUG_LPORT(fmt...)			\
-	do {					\
-		if (fc_lport_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static void fc_lport_error(struct fc_lport *, struct fc_frame *);
 
 static void fc_lport_enter_reset(struct fc_lport *);
@@ -151,8 +143,8 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				    struct fc_rport *rport,
 				    enum fc_rport_event event)
 {
-	FC_DEBUG_LPORT("Received a %d event for port (%6x)\n", event,
-		       rport->port_id);
+	FC_LPORT_DBG(lport, "Received a %d event for port (%6x)\n", event,
+		     rport->port_id);
 
 	switch (event) {
 	case RPORT_EV_CREATED:
@@ -162,19 +154,19 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 				lport->dns_rp = rport;
 				fc_lport_enter_rpn_id(lport);
 			} else {
-				FC_DEBUG_LPORT("Received an CREATED event on "
-					       "port (%6x) for the directory "
-					       "server, but the lport is not "
-					       "in the DNS state, it's in the "
-					       "%d state", rport->port_id,
-					       lport->state);
+				FC_LPORT_DBG(lport, "Received an CREATED event "
+					     "on port (%6x) for the directory "
+					     "server, but the lport is not "
+					     "in the DNS state, it's in the "
+					     "%d state", rport->port_id,
+					     lport->state);
 				lport->tt.rport_logoff(rport);
 			}
 			mutex_unlock(&lport->lp_mutex);
 		} else
-			FC_DEBUG_LPORT("Received an event for port (%6x) "
-				       "which is not the directory server\n",
-				       rport->port_id);
+			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
+				     "which is not the directory server\n",
+				     rport->port_id);
 		break;
 	case RPORT_EV_LOGO:
 	case RPORT_EV_FAILED:
@@ -185,9 +177,9 @@ static void fc_lport_rport_callback(struct fc_lport *lport,
 			mutex_unlock(&lport->lp_mutex);
 
 		} else
-			FC_DEBUG_LPORT("Received an event for port (%6x) "
-				       "which is not the directory server\n",
-				       rport->port_id);
+			FC_LPORT_DBG(lport, "Received an event for port (%6x) "
+				     "which is not the directory server\n",
+				     rport->port_id);
 		break;
 	case RPORT_EV_NONE:
 		break;
@@ -363,8 +355,8 @@ static void fc_lport_add_fc4_type(struct fc_lport *lport, enum fc_fh_type type)
 static void fc_lport_recv_rlir_req(struct fc_seq *sp, struct fc_frame *fp,
 				   struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+		     fc_lport_state(lport));
 
 	lport->tt.seq_els_rsp_send(sp, ELS_LS_ACC, NULL);
 	fc_frame_free(fp);
@@ -389,8 +381,8 @@ static void fc_lport_recv_echo_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	void *dp;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received RLIR request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received RLIR request while in state %s\n",
+		     fc_lport_state(lport));
 
 	len = fr_len(in_fp) - sizeof(struct fc_frame_header);
 	pp = fc_frame_payload_get(in_fp, len);
@@ -437,8 +429,8 @@ static void fc_lport_recv_rnid_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	size_t len;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received RNID request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received RNID request while in state %s\n",
+		     fc_lport_state(lport));
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
@@ -498,8 +490,8 @@ static void fc_lport_recv_adisc_req(struct fc_seq *sp, struct fc_frame *in_fp,
 	size_t len;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received ADISC request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received ADISC request while in state %s\n",
+		     fc_lport_state(lport));
 
 	req = fc_frame_payload_get(in_fp, sizeof(*req));
 	if (!req) {
@@ -574,8 +566,8 @@ EXPORT_SYMBOL(fc_fabric_login);
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Link is up for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+	printk(KERN_INFO "libfc: Link up on port (%6x)\n",
+	       fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
 	if (!lport->link_up) {
@@ -595,8 +587,8 @@ EXPORT_SYMBOL(fc_linkup);
 void fc_linkdown(struct fc_lport *lport)
 {
 	mutex_lock(&lport->lp_mutex);
-	FC_DEBUG_LPORT("Link is down for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+	printk(KERN_INFO "libfc: Link down on port (%6x)\n",
+	       fc_host_port_id(lport->host));
 
 	if (lport->link_up) {
 		lport->link_up = 0;
@@ -701,12 +693,11 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 {
 	switch (event) {
 	case DISC_EV_SUCCESS:
-		FC_DEBUG_LPORT("Got a SUCCESS event for port (%6x)\n",
-			       fc_host_port_id(lport->host));
+		FC_LPORT_DBG(lport, "Discovery succeeded\n");
 		break;
 	case DISC_EV_FAILED:
-		FC_DEBUG_LPORT("Got a FAILED event for port (%6x)\n",
-			       fc_host_port_id(lport->host));
+		printk(KERN_ERR "libfc: Discovery failed for port (%6x)\n",
+		       fc_host_port_id(lport->host));
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -726,8 +717,8 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
  */
 static void fc_lport_enter_ready(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Port (%6x) entered Ready from state %s\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered READY from state %s\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_READY);
 
@@ -762,8 +753,8 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 	u32 local_fid;
 	u32 f_ctl;
 
-	FC_DEBUG_LPORT("Received FLOGI request while in state %s\n",
-		       fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Received FLOGI request while in state %s\n",
+		     fc_lport_state(lport));
 
 	fh = fc_frame_header_get(rx_fp);
 	remote_fid = ntoh24(fh->fh_s_id);
@@ -772,12 +763,11 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
-		FC_DBG("FLOGI from port with same WWPN %llx "
-		       "possible configuration error\n",
-		       (unsigned long long)remote_wwpn);
+		printk(KERN_WARNING "libfc: Received FLOGI from port "
+		       "with same WWPN %llx\n", remote_wwpn);
 		goto out;
 	}
-	FC_DBG("FLOGI from port WWPN %llx\n", (unsigned long long)remote_wwpn);
+	FC_LPORT_DBG(lport, "FLOGI from port WWPN %llx\n", remote_wwpn);
 
 	/*
 	 * XXX what is the right thing to do for FIDs?
@@ -909,7 +899,8 @@ static void fc_lport_recv_req(struct fc_lport *lport, struct fc_seq *sp,
 			}
 		}
 	} else {
-		FC_DBG("dropping invalid frame (eof %x)\n", fr_eof(fp));
+		FC_LPORT_DBG(lport, "dropping invalid frame (eof %x)\n",
+			     fr_eof(fp));
 		fc_frame_free(fp);
 	}
 	mutex_unlock(&lport->lp_mutex);
@@ -947,8 +938,8 @@ EXPORT_SYMBOL(fc_lport_reset);
  */
 static void fc_lport_enter_reset(struct fc_lport *lport)
 {
-	FC_DEBUG_LPORT("Port (%6x) entered RESET state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered RESET state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RESET);
 
@@ -982,9 +973,9 @@ static void fc_lport_enter_reset(struct fc_lport *lport)
 static void fc_lport_error(struct fc_lport *lport, struct fc_frame *fp)
 {
 	unsigned long delay = 0;
-	FC_DEBUG_LPORT("Error %ld in state %s, retries %d\n",
-		       PTR_ERR(fp), fc_lport_state(lport),
-		       lport->retry_count);
+	FC_LPORT_DBG(lport, "Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_lport_state(lport),
+		     lport->retry_count);
 
 	if (!fp || PTR_ERR(fp) == -FC_EX_TIMEOUT) {
 		/*
@@ -1040,11 +1031,11 @@ static void fc_lport_rft_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a RFT_ID response\n");
+	FC_LPORT_DBG(lport, "Received a RFT_ID response\n");
 
 	if (lport->state != LPORT_ST_RFT_ID) {
-		FC_DBG("Received a RFT_ID response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a RFT_ID response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1094,11 +1085,11 @@ static void fc_lport_rpn_id_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a RPN_ID response\n");
+	FC_LPORT_DBG(lport, "Received a RPN_ID response\n");
 
 	if (lport->state != LPORT_ST_RPN_ID) {
-		FC_DBG("Received a RPN_ID response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a RPN_ID response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1146,11 +1137,11 @@ static void fc_lport_scr_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a SCR response\n");
+	FC_LPORT_DBG(lport, "Received a SCR response\n");
 
 	if (lport->state != LPORT_ST_SCR) {
-		FC_DBG("Received a SCR response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a SCR response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1184,8 +1175,8 @@ static void fc_lport_enter_scr(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Port (%6x) entered SCR state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered SCR state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_SCR);
 
@@ -1213,8 +1204,8 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 	struct fc_ns_fts *lps;
 	int i;
 
-	FC_DEBUG_LPORT("Port (%6x) entered RFT_ID state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered RFT_ID state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RFT_ID);
 
@@ -1253,8 +1244,8 @@ static void fc_lport_enter_rpn_id(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Port (%6x) entered RPN_ID state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered RPN_ID state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_RPN_ID);
 
@@ -1294,8 +1285,8 @@ static void fc_lport_enter_dns(struct fc_lport *lport)
 	dp.ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	dp.lp = lport;
 
-	FC_DEBUG_LPORT("Port (%6x) entered DNS state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered DNS state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_DNS);
 
@@ -1374,11 +1365,11 @@ static void fc_lport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a LOGO response\n");
+	FC_LPORT_DBG(lport, "Received a LOGO response\n");
 
 	if (lport->state != LPORT_ST_LOGO) {
-		FC_DBG("Received a LOGO response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a LOGO response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1413,8 +1404,8 @@ static void fc_lport_enter_logo(struct fc_lport *lport)
 	struct fc_frame *fp;
 	struct fc_els_logo *logo;
 
-	FC_DEBUG_LPORT("Port (%6x) entered LOGO state from %s state\n",
-		       fc_host_port_id(lport->host), fc_lport_state(lport));
+	FC_LPORT_DBG(lport, "Entered LOGO state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_LOGO);
 
@@ -1456,11 +1447,11 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&lport->lp_mutex);
 
-	FC_DEBUG_LPORT("Received a FLOGI response\n");
+	FC_LPORT_DBG(lport, "Received a FLOGI response\n");
 
 	if (lport->state != LPORT_ST_FLOGI) {
-		FC_DBG("Received a FLOGI response, but in state %s\n",
-		       fc_lport_state(lport));
+		FC_LPORT_DBG(lport, "Received a FLOGI response, but in state "
+			     "%s\n", fc_lport_state(lport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -1475,7 +1466,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	did = ntoh24(fh->fh_d_id);
 	if (fc_frame_payload_op(fp) == ELS_LS_ACC && did != 0) {
 
-		FC_DEBUG_LPORT("Assigned fid %x\n", did);
+		printk(KERN_INFO "libfc: Assigned FID (%6x) in FLOGI response\n",
+		       did);
 		fc_host_port_id(lport->host) = did;
 
 		flp = fc_frame_payload_get(fp, sizeof(*flp));
@@ -1494,7 +1486,8 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 				if (e_d_tov > lport->e_d_tov)
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
-				FC_DBG("Point-to-Point mode\n");
+				printk(KERN_INFO "libfc: Port (%6x) entered "
+				       "point to point mode\n", did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),
@@ -1517,7 +1510,7 @@ static void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			}
 		}
 	} else {
-		FC_DBG("bad FLOGI response\n");
+		FC_LPORT_DBG(lport, "Bad FLOGI response\n");
 	}
 
 out:
@@ -1537,7 +1530,8 @@ void fc_lport_enter_flogi(struct fc_lport *lport)
 {
 	struct fc_frame *fp;
 
-	FC_DEBUG_LPORT("Processing FLOGI state\n");
+	FC_LPORT_DBG(lport, "Entered FLOGI state from %s state\n",
+		     fc_lport_state(lport));
 
 	fc_lport_state_enter(lport, LPORT_ST_FLOGI);
 
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 7bfbff7..7162385 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -55,14 +55,6 @@
 #include <scsi/libfc.h>
 #include <scsi/fc_encode.h>
 
-static int fc_rport_debug;
-
-#define FC_DEBUG_RPORT(fmt...)			\
-	do {					\
-		if (fc_rport_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 struct workqueue_struct *rport_event_queue;
 
 static void fc_rport_enter_plogi(struct fc_rport *);
@@ -97,7 +89,7 @@ static const char *fc_rport_state_names[] = {
 static void fc_rport_rogue_destroy(struct device *dev)
 {
 	struct fc_rport *rport = dev_to_rport(dev);
-	FC_DEBUG_RPORT("Destroying rogue rport (%6x)\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Destroying rogue rport\n");
 	kfree(rport);
 }
 
@@ -263,8 +255,8 @@ static void fc_rport_work(struct work_struct *work)
 
 			fc_rport_state_enter(new_rport, RPORT_ST_READY);
 		} else {
-			FC_DBG("Failed to create the rport for port "
-			       "(%6x).\n", ids.port_id);
+			printk(KERN_WARNING "libfc: Failed to allocate "
+			       " memory for rport (%6x)\n", ids.port_id);
 			event = RPORT_EV_FAILED;
 		}
 		if (rport->port_id != FC_FID_DIR_SERV)
@@ -309,7 +301,7 @@ int fc_rport_login(struct fc_rport *rport)
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Login to port (%6x)\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Login to port\n");
 
 	fc_rport_enter_plogi(rport);
 
@@ -329,16 +321,13 @@ int fc_rport_login(struct fc_rport *rport)
 int fc_rport_logoff(struct fc_rport *rport)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
-	struct fc_lport *lport = rdata->local_port;
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Remove port (%6x)\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Remove port\n");
 
 	if (rdata->rp_state == RPORT_ST_NONE) {
-		FC_DEBUG_RPORT("(%6x): Port (%6x) in NONE state,"
-			       " not removing", fc_host_port_id(lport->host),
-			       rport->port_id);
+		FC_RPORT_DBG(rport, "Port in NONE state, not removing\n");
 		mutex_unlock(&rdata->rp_mutex);
 		goto out;
 	}
@@ -379,7 +368,7 @@ static void fc_rport_enter_ready(struct fc_rport *rport)
 
 	fc_rport_state_enter(rport, RPORT_ST_READY);
 
-	FC_DEBUG_RPORT("Port (%6x) is Ready\n", rport->port_id);
+	FC_RPORT_DBG(rport, "Port is Ready\n");
 
 	rdata->event = RPORT_EV_CREATED;
 	queue_work(rport_event_queue, &rdata->event_work);
@@ -436,8 +425,8 @@ static void fc_rport_error(struct fc_rport *rport, struct fc_frame *fp)
 {
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 
-	FC_DEBUG_RPORT("Error %ld in state %s, retries %d\n",
-		       PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
+	FC_RPORT_DBG(rport, "Error %ld in state %s, retries %d\n",
+		     PTR_ERR(fp), fc_rport_state(rport), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PLOGI:
@@ -479,8 +468,8 @@ static void fc_rport_error_retry(struct fc_rport *rport, struct fc_frame *fp)
 		return fc_rport_error(rport, fp);
 
 	if (rdata->retries < rdata->local_port->max_rport_retry_count) {
-		FC_DEBUG_RPORT("Error %ld in state %s, retrying\n",
-			       PTR_ERR(fp), fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Error %ld in state %s, retrying\n",
+			     PTR_ERR(fp), fc_rport_state(rport));
 		rdata->retries++;
 		/* no additional delay on exchange timeouts */
 		if (PTR_ERR(fp) == -FC_EX_TIMEOUT)
@@ -517,12 +506,11 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a PLOGI response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a PLOGI response\n");
 
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
-		FC_DBG("Received a PLOGI response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a PLOGI response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -583,8 +571,8 @@ static void fc_rport_enter_plogi(struct fc_rport *rport)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered PLOGI state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered PLOGI state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_PLOGI);
 
@@ -628,12 +616,11 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a PRLI response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a PRLI response\n");
 
 	if (rdata->rp_state != RPORT_ST_PRLI) {
-		FC_DBG("Received a PRLI response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a PRLI response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -663,7 +650,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_rport_enter_rtv(rport);
 
 	} else {
-		FC_DBG("Bad ELS response\n");
+		FC_RPORT_DBG(rport, "Bad ELS response for PRLI command\n");
 		rdata->event = RPORT_EV_FAILED;
 		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
@@ -695,12 +682,11 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a LOGO response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a LOGO response\n");
 
 	if (rdata->rp_state != RPORT_ST_LOGO) {
-		FC_DEBUG_RPORT("Received a LOGO response, but in state %s\n",
-			       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a LOGO response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -715,7 +701,7 @@ static void fc_rport_logo_resp(struct fc_seq *sp, struct fc_frame *fp,
 	if (op == ELS_LS_ACC) {
 		fc_rport_enter_rtv(rport);
 	} else {
-		FC_DBG("Bad ELS response\n");
+		FC_RPORT_DBG(rport, "Bad ELS response for LOGO command\n");
 		rdata->event = RPORT_EV_LOGO;
 		fc_rport_state_enter(rport, RPORT_ST_NONE);
 		queue_work(rport_event_queue, &rdata->event_work);
@@ -745,8 +731,8 @@ static void fc_rport_enter_prli(struct fc_rport *rport)
 	} *pp;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered PRLI state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered PRLI state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_PRLI);
 
@@ -784,12 +770,11 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 
 	mutex_lock(&rdata->rp_mutex);
 
-	FC_DEBUG_RPORT("Received a RTV response from port (%6x)\n",
-		       rport->port_id);
+	FC_RPORT_DBG(rport, "Received a RTV response\n");
 
 	if (rdata->rp_state != RPORT_ST_RTV) {
-		FC_DBG("Received a RTV response, but in state %s\n",
-		       fc_rport_state(rport));
+		FC_RPORT_DBG(rport, "Received a RTV response, but in state "
+			     "%s\n", fc_rport_state(rport));
 		if (IS_ERR(fp))
 			goto err;
 		goto out;
@@ -844,8 +829,8 @@ static void fc_rport_enter_rtv(struct fc_rport *rport)
 	struct fc_rport_libfc_priv *rdata = rport->dd_data;
 	struct fc_lport *lport = rdata->local_port;
 
-	FC_DEBUG_RPORT("Port (%6x) entered RTV state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered RTV state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_RTV);
 
@@ -875,8 +860,8 @@ static void fc_rport_enter_logo(struct fc_rport *rport)
 	struct fc_lport *lport = rdata->local_port;
 	struct fc_frame *fp;
 
-	FC_DEBUG_RPORT("Port (%6x) entered LOGO state from %s state\n",
-		       rport->port_id, fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Port entered LOGO state from %s state\n",
+		     fc_rport_state(rport));
 
 	fc_rport_state_enter(rport, RPORT_ST_LOGO);
 
@@ -983,14 +968,13 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received PLOGI request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received PLOGI request while in state %s\n",
+		     fc_rport_state(rport));
 
 	sid = ntoh24(fh->fh_s_id);
 	pl = fc_frame_payload_get(fp, sizeof(*pl));
 	if (!pl) {
-		FC_DBG("incoming PLOGI from %x too short\n", sid);
+		FC_RPORT_DBG(rport, "Received PLOGI too short\n");
 		WARN_ON(1);
 		/* XXX TBD: send reject? */
 		fc_frame_free(fp);
@@ -1012,26 +996,26 @@ static void fc_rport_recv_plogi_req(struct fc_rport *rport,
 	 */
 	switch (rdata->rp_state) {
 	case RPORT_ST_INIT:
-		FC_DEBUG_RPORT("incoming PLOGI from %6x wwpn %llx state INIT "
-			       "- reject\n", sid, (unsigned long long)wwpn);
+		FC_RPORT_DBG(rport, "Received PLOGI, wwpn %llx state INIT "
+			     "- reject\n", (unsigned long long)wwpn);
 		reject = ELS_RJT_UNSUP;
 		break;
 	case RPORT_ST_PLOGI:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in PLOGI state %d\n",
-			       sid, rdata->rp_state);
+		FC_RPORT_DBG(rport, "Received PLOGI in PLOGI state %d\n",
+			     rdata->rp_state);
 		if (wwpn < lport->wwpn)
 			reject = ELS_RJT_INPROG;
 		break;
 	case RPORT_ST_PRLI:
 	case RPORT_ST_READY:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in logged-in state %d "
-			       "- ignored for now\n", sid, rdata->rp_state);
+		FC_RPORT_DBG(rport, "Received PLOGI in logged-in state %d "
+			     "- ignored for now\n", rdata->rp_state);
 		/* XXX TBD - should reset */
 		break;
 	case RPORT_ST_NONE:
 	default:
-		FC_DEBUG_RPORT("incoming PLOGI from %x in unexpected "
-			       "state %d\n", sid, rdata->rp_state);
+		FC_RPORT_DBG(rport, "Received PLOGI in unexpected "
+			     "state %d\n", rdata->rp_state);
 		fc_frame_free(fp);
 		return;
 		break;
@@ -1115,9 +1099,8 @@ static void fc_rport_recv_prli_req(struct fc_rport *rport,
 
 	fh = fc_frame_header_get(rx_fp);
 
-	FC_DEBUG_RPORT("Received PRLI request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received PRLI request while in state %s\n",
+		     fc_rport_state(rport));
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_PRLI:
@@ -1252,9 +1235,8 @@ static void fc_rport_recv_prlo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received PRLO request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received PRLO request while in state %s\n",
+		     fc_rport_state(rport));
 
 	if (rdata->rp_state == RPORT_ST_NONE) {
 		fc_frame_free(fp);
@@ -1286,9 +1268,8 @@ static void fc_rport_recv_logo_req(struct fc_rport *rport, struct fc_seq *sp,
 
 	fh = fc_frame_header_get(fp);
 
-	FC_DEBUG_RPORT("Received LOGO request from port (%6x) "
-		       "while in state %s\n", ntoh24(fh->fh_s_id),
-		       fc_rport_state(rport));
+	FC_RPORT_DBG(rport, "Received LOGO request while in state %s\n",
+		     fc_rport_state(rport));
 
 	if (rdata->rp_state == RPORT_ST_NONE) {
 		fc_frame_free(fp);
@@ -1308,7 +1289,6 @@ static void fc_rport_flush_queue(void)
 	flush_workqueue(rport_event_queue);
 }
 
-
 int fc_rport_init(struct fc_lport *lport)
 {
 	if (!lport->tt.rport_create)
diff --git a/include/scsi/fc_encode.h b/include/scsi/fc_encode.h
index 6300f55..a0ff61c 100644
--- a/include/scsi/fc_encode.h
+++ b/include/scsi/fc_encode.h
@@ -107,7 +107,6 @@ static inline int fc_ct_fill(struct fc_lport *lport, struct fc_frame *fp,
 		break;
 
 	default:
-		FC_DBG("Invalid op code %x \n", op);
 		return -EINVAL;
 	}
 	*r_ctl = FC_RCTL_DD_UNSOL_CTL;
@@ -298,7 +297,6 @@ static inline int fc_els_fill(struct fc_lport *lport, struct fc_rport *rport,
 		break;
 
 	default:
-		FC_DBG("Invalid op code %x \n", op);
 		return -EINVAL;
 	}
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index ebdd9f4..b92584a 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -34,17 +34,72 @@
 
 #include <scsi/fc_frame.h>
 
-#define LIBFC_DEBUG
-
-#ifdef LIBFC_DEBUG
-/* Log messages */
-#define FC_DBG(fmt, args...)						\
-	do {								\
-		printk(KERN_INFO "%s " fmt, __func__, ##args);		\
-	} while (0)
-#else
-#define FC_DBG(fmt, args...)
-#endif
+#define FC_LIBFC_LOGGING 0x01 /* General logging, not categorized */
+#define FC_LPORT_LOGGING 0x02 /* lport layer logging */
+#define FC_DISC_LOGGING  0x04 /* discovery layer logging */
+#define FC_RPORT_LOGGING 0x08 /* rport layer logging */
+#define FC_FCP_LOGGING   0x10 /* I/O path logging */
+#define FC_EM_LOGGING    0x20 /* Exchange Manager logging */
+#define FC_EXCH_LOGGING  0x40 /* Exchange/Sequence logging */
+#define FC_SCSI_LOGGING  0x80 /* SCSI logging (mostly error handling) */
+
+extern unsigned int fc_debug_logging;
+
+#define FC_CHECK_LOGGING(LEVEL, CMD)				\
+do {								\
+	if (unlikely(fc_debug_logging & LEVEL))			\
+		do {						\
+			CMD;					\
+		} while (0);					\
+} while (0);
+
+#define FC_LIBFC_DBG(fmt, args...)					\
+	FC_CHECK_LOGGING(FC_LIBFC_LOGGING,				\
+			 printk(KERN_INFO "libfc: " fmt, ##args);)
+
+#define FC_LPORT_DBG(lport, fmt, args...)				\
+	FC_CHECK_LOGGING(FC_LPORT_LOGGING,				\
+			 printk(KERN_INFO "lport: %6x: " fmt,		\
+				fc_host_port_id(lport->host), ##args);)
+
+#define FC_DISC_DBG(disc, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_DISC_LOGGING,				\
+			 printk(KERN_INFO "disc: %6x: " fmt,		\
+				fc_host_port_id(disc->lport->host),	\
+				##args);)
+
+#define FC_RPORT_DBG(rport, fmt, args...)				\
+do {									\
+	struct fc_rport_libfc_priv *rdata = rport->dd_data;		\
+	struct fc_lport *lport = rdata->local_port;			\
+	FC_CHECK_LOGGING(FC_RPORT_LOGGING,				\
+			 printk(KERN_INFO "rport: %6x: %6x: " fmt,	\
+				fc_host_port_id(lport->host),		\
+				rport->port_id, ##args);)		\
+} while (0);
+
+#define FC_FCP_DBG(pkt, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_FCP_LOGGING,				\
+			 printk(KERN_INFO "fcp: %6x: %6x: " fmt,	\
+				fc_host_port_id(pkt->lp->host),		\
+				pkt->rport->port_id, ##args);)
+
+#define FC_EM_DBG(em, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_EM_LOGGING,					\
+			 printk(KERN_INFO "em: %6x: " fmt,		\
+				fc_host_port_id(em->lp->host),		\
+				##args);)
+
+#define FC_EXCH_DBG(exch, fmt, args...)					\
+	FC_CHECK_LOGGING(FC_EXCH_LOGGING,				\
+			 printk(KERN_INFO "exch: %6x: %4x: " fmt,	\
+				fc_host_port_id(exch->lp->host),	\
+				exch->xid, ##args);)
+
+#define FC_SCSI_DBG(lport, fmt, args...)				\
+	FC_CHECK_LOGGING(FC_SCSI_LOGGING,                               \
+			 printk(KERN_INFO "scsi: %6x: " fmt,		\
+				fc_host_port_id(lport->host), ##args);)
 
 /*
  * libfc error codes

