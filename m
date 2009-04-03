From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 13/15] libfc: Convert debug statements in fc_fcp.c to use new
	libfc debug macros.
Date: Fri, 03 Apr 2009 14:59:10 -0700
Message-ID: <20090403215910.10856.58663.stgit@fritz>
References: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763289AbZDCV7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:59:12 -0400
In-Reply-To: <20090403215758.10856.6946.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Convert debug statements in fc_fcp.c to use new libfc
debug macros.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   95 +++++++++++++++++++++----------------------
 1 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index f21fbcc..73b549d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -47,14 +47,6 @@ unsigned int fc_debug_logging;
 module_param_named(debug_logging, fc_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
 
-static int fc_fcp_debug;
-
-#define FC_DEBUG_FCP(fmt...)			\
-	do {					\
-		if (fc_fcp_debug)		\
-			FC_DBG(fmt);		\
-	} while (0)
-
 static struct kmem_cache *scsi_pkt_cachep;
 
 /* SRB state definitions */
@@ -351,8 +343,8 @@ static void fc_fcp_recv_data(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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
@@ -415,7 +407,8 @@ crc_err:
 			stats->ErrorFrames++;
 			/* FIXME - per cpu count, not total count! */
 			if (stats->InvalidCRCCount++ < 5)
-				printk(KERN_WARNING "CRC error on data frame for port (%6x)\n",
+				printk(KERN_WARNING "libfc: CRC error on data "
+				       "frame for port (%6x)\n",
 				       fc_host_port_id(lp->host));
 			/*
 			 * Assume the frame is total garbage.
@@ -479,14 +472,14 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
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
@@ -497,7 +490,7 @@ static int fc_fcp_send_data(struct fc_fcp_pkt *fsp, struct fc_seq *seq,
 	t_blen = fsp->max_payload;
 	if (lp->seq_offload) {
 		t_blen = min(seq_blen, (size_t)lp->lso_max);
-		FC_DEBUG_FCP("fsp=%p:lso:blen=%zx lso_max=0x%x t_blen=%zx\n",
+		FC_FCP_DBG(fsp, "fsp=%p:lso:blen=%zx lso_max=0x%x t_blen=%zx\n",
 			   fsp, seq_blen, lp->lso_max, t_blen);
 	}
 
@@ -698,7 +691,7 @@ static void fc_fcp_reduce_can_queue(struct fc_lport *lp)
 	if (!can_queue)
 		can_queue = 1;
 	lp->host->can_queue = can_queue;
-	shost_printk(KERN_ERR, lp->host, "Could not allocate frame.\n"
+	shost_printk(KERN_ERR, lp->host, "libfc: Could not allocate frame.\n"
 		     "Reducing can_queue to %d.\n", can_queue);
 done:
 	spin_unlock_irqrestore(lp->host->host_lock, flags);
@@ -773,7 +766,7 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 
 		fc_fcp_resp(fsp, fp);
 	} else {
-		FC_DBG("unexpected frame.  r_ctl %x\n", r_ctl);
+		FC_FCP_DBG(fsp, "unexpected frame.  r_ctl %x\n", r_ctl);
 	}
 unlock:
 	fc_fcp_unlock_pkt(fsp);
@@ -882,17 +875,17 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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
@@ -1112,13 +1105,11 @@ static void fc_fcp_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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
@@ -1150,10 +1141,10 @@ static int fc_fcp_pkt_abort(struct fc_lport *lp, struct fc_fcp_pkt *fsp)
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
@@ -1218,7 +1209,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 	spin_unlock_bh(&fsp->scsi_pkt_lock);
 
 	if (!rc) {
-		FC_DBG("lun reset failed\n");
+		FC_SCSI_DBG(lp, "lun reset failed\n");
 		return FAILED;
 	}
 
@@ -1226,7 +1217,7 @@ static int fc_lun_reset(struct fc_lport *lp, struct fc_fcp_pkt *fsp,
 	if (fsp->cdb_status != FCP_TMF_CMPL)
 		return FAILED;
 
-	FC_DBG("lun reset to lun %u completed\n", lun);
+	FC_SCSI_DBG(lp, "lun reset to lun %u completed\n", lun);
 	fc_fcp_cleanup_each_cmd(lp, id, lun, FC_CMD_ABORTED);
 	return SUCCESS;
 }
@@ -1393,13 +1384,13 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
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
@@ -1519,8 +1510,8 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		break;
 
 	default:
-		FC_DBG("REC %p fid %x error unexpected error %d\n",
-		       fsp, fsp->rport->port_id, error);
+		FC_FCP_DBG(fsp, "REC %p fid %x error unexpected error %d\n",
+			   fsp, fsp->rport->port_id, error);
 		fsp->status_code = FC_CMD_PLOGO;
 		/* fall through */
 
@@ -1529,9 +1520,9 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
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
@@ -2016,9 +2007,11 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
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
@@ -2053,17 +2046,21 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
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
@@ -2122,7 +2119,8 @@ void fc_fcp_destroy(struct fc_lport *lp)
 	struct fc_fcp_internal *si = fc_get_scsi_internal(lp);
 
 	if (!list_empty(&si->scsi_pkt_queue))
-		printk(KERN_ERR "Leaked scsi packets.\n");
+		printk(KERN_ERR "libfc: Leaked SCSI packets when destroying "
+		       "port (%6x)\n", fc_host_port_id(lp->host));
 
 	mempool_destroy(si->scsi_pkt_pool);
 	kfree(si);
@@ -2171,7 +2169,8 @@ static int __init libfc_init(void)
 					    sizeof(struct fc_fcp_pkt),
 					    0, SLAB_HWCACHE_ALIGN, NULL);
 	if (scsi_pkt_cachep == NULL) {
-		FC_DBG("Unable to allocate SRB cache...module load failed!");
+		printk(KERN_ERR "libfc: Unable to allocate SRB cache, "
+		       "module load failed!");
 		return -ENOMEM;
 	}
 

