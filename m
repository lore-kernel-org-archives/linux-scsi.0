From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/24] libfc: additional debugging messages
Date: Thu, 13 Oct 2016 15:10:37 +0200
Message-ID: <1476364260-12191-2-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755492AbcJMNXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:23:46 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c  | 59 +++++++++++++++++++++++++++++++++++--------
 drivers/scsi/libfc/fc_fcp.c   | 41 ++++++++++++++++++++++++------
 drivers/scsi/libfc/fc_rport.c | 25 ++++++++++++++----
 3 files changed, 101 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 16ca31a..b4bdc90 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -362,8 +362,10 @@ static inline void fc_exch_timer_set_locked(struct fc_exch *ep,
 
 	fc_exch_hold(ep);		/* hold for timer */
 	if (!queue_delayed_work(fc_exch_workqueue, &ep->timeout_work,
-				msecs_to_jiffies(timer_msec)))
+				msecs_to_jiffies(timer_msec))) {
+		FC_EXCH_DBG(ep, "Exchange already queued\n");
 		fc_exch_release(ep);
+	}
 }
 
 /**
@@ -632,9 +634,13 @@ static int fc_exch_abort_locked(struct fc_exch *ep,
 	struct fc_frame *fp;
 	int error;
 
+	FC_EXCH_DBG(ep, "exch: abort, time %d msecs\n", timer_msec);
 	if (ep->esb_stat & (ESB_ST_COMPLETE | ESB_ST_ABNORMAL) ||
-	    ep->state & (FC_EX_DONE | FC_EX_RST_CLEANUP))
+	    ep->state & (FC_EX_DONE | FC_EX_RST_CLEANUP)) {
+		FC_EXCH_DBG(ep, "exch: already completed esb %x state %x\n",
+			    ep->esb_stat, ep->state);
 		return -ENXIO;
+	}
 
 	/*
 	 * Send the abort on a new sequence if possible.
@@ -758,7 +764,7 @@ static void fc_exch_timeout(struct work_struct *work)
 	u32 e_stat;
 	int rc = 1;
 
-	FC_EXCH_DBG(ep, "Exchange timed out\n");
+	FC_EXCH_DBG(ep, "Exchange timed out state %x\n", ep->state);
 
 	spin_lock_bh(&ep->ex_lock);
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE))
@@ -1258,8 +1264,10 @@ static void fc_seq_send_ack(struct fc_seq *sp, const struct fc_frame *rx_fp)
 	 */
 	if (fc_sof_needs_ack(fr_sof(rx_fp))) {
 		fp = fc_frame_alloc(lport, 0);
-		if (!fp)
+		if (!fp) {
+			FC_EXCH_DBG(ep, "Drop ACK request, out of memory\n");
 			return;
+		}
 
 		fh = fc_frame_header_get(fp);
 		fh->fh_r_ctl = FC_RCTL_ACK_1;
@@ -1312,13 +1320,18 @@ static void fc_exch_send_ba_rjt(struct fc_frame *rx_fp,
 	struct fc_frame_header *rx_fh;
 	struct fc_frame_header *fh;
 	struct fc_ba_rjt *rp;
+	struct fc_seq *sp;
 	struct fc_lport *lport;
 	unsigned int f_ctl;
 
 	lport = fr_dev(rx_fp);
+	sp = fr_seq(rx_fp);
 	fp = fc_frame_alloc(lport, sizeof(*rp));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(fc_seq_exch(sp),
+			     "Drop BA_RJT request, out of memory\n");
 		return;
+	}
 	fh = fc_frame_header_get(fp);
 	rx_fh = fc_frame_header_get(rx_fp);
 
@@ -1383,14 +1396,17 @@ static void fc_exch_recv_abts(struct fc_exch *ep, struct fc_frame *rx_fp)
 	if (!ep)
 		goto reject;
 
+	FC_EXCH_DBG(ep, "exch: ABTS received\n");
 	fp = fc_frame_alloc(ep->lp, sizeof(*ap));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(ep, "Drop ABTS request, out of memory\n");
 		goto free;
+	}
 
 	spin_lock_bh(&ep->ex_lock);
 	if (ep->esb_stat & ESB_ST_COMPLETE) {
 		spin_unlock_bh(&ep->ex_lock);
-
+		FC_EXCH_DBG(ep, "exch: ABTS rejected, exchange complete\n");
 		fc_frame_free(fp);
 		goto reject;
 	}
@@ -1784,11 +1800,16 @@ static void fc_seq_ls_acc(struct fc_frame *rx_fp)
 	struct fc_lport *lport;
 	struct fc_els_ls_acc *acc;
 	struct fc_frame *fp;
+	struct fc_seq *sp;
 
 	lport = fr_dev(rx_fp);
+	sp = fr_seq(rx_fp);
 	fp = fc_frame_alloc(lport, sizeof(*acc));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(fc_seq_exch(sp),
+			    "exch: drop LS_ACC, out of memory\n");
 		return;
+	}
 	acc = fc_frame_payload_get(fp, sizeof(*acc));
 	memset(acc, 0, sizeof(*acc));
 	acc->la_cmd = ELS_LS_ACC;
@@ -1811,11 +1832,16 @@ static void fc_seq_ls_rjt(struct fc_frame *rx_fp, enum fc_els_rjt_reason reason,
 	struct fc_lport *lport;
 	struct fc_els_ls_rjt *rjt;
 	struct fc_frame *fp;
+	struct fc_seq *sp;
 
 	lport = fr_dev(rx_fp);
+	sp = fr_seq(rx_fp);
 	fp = fc_frame_alloc(lport, sizeof(*rjt));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(fc_seq_exch(sp),
+			    "exch: drop LS_ACC, out of memory\n");
 		return;
+	}
 	rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 	memset(rjt, 0, sizeof(*rjt));
 	rjt->er_cmd = ELS_LS_RJT;
@@ -1975,15 +2001,23 @@ static void fc_exch_els_rec(struct fc_frame *rfp)
 	ep = fc_exch_lookup(lport,
 			    sid == fc_host_port_id(lport->host) ? oxid : rxid);
 	explan = ELS_EXPL_OXID_RXID;
-	if (!ep)
+	if (!ep) {
+		FC_LPORT_DBG(lport,
+			     "REC request from %x: rxid %x oxid %x not found\n",
+			     sid, rxid, oxid);
 		goto reject;
+	}
+	FC_EXCH_DBG(ep, "REC request from %x: rxid %x oxid %x\n",
+		    sid, rxid, oxid);
 	if (ep->oid != sid || oxid != ep->oxid)
 		goto rel;
 	if (rxid != FC_XID_UNKNOWN && rxid != ep->rxid)
 		goto rel;
 	fp = fc_frame_alloc(lport, sizeof(*acc));
-	if (!fp)
+	if (!fp) {
+		FC_EXCH_DBG(ep, "Drop REC request, out of memory\n");
 		goto out;
+	}
 
 	acc = fc_frame_payload_get(fp, sizeof(*acc));
 	memset(acc, 0, sizeof(*acc));
@@ -2176,6 +2210,7 @@ static void fc_exch_rrq(struct fc_exch *ep)
 		return;
 
 retry:
+	FC_EXCH_DBG(ep, "exch: RRQ send failed\n");
 	spin_lock_bh(&ep->ex_lock);
 	if (ep->state & (FC_EX_RST_CLEANUP | FC_EX_DONE)) {
 		spin_unlock_bh(&ep->ex_lock);
@@ -2218,6 +2253,8 @@ static void fc_exch_els_rrq(struct fc_frame *fp)
 	if (!ep)
 		goto reject;
 	spin_lock_bh(&ep->ex_lock);
+	FC_EXCH_DBG(ep, "RRQ request from %x: xid %x rxid %x oxid %x\n",
+		    sid, xid, ntohs(rp->rrq_rx_id), ntohs(rp->rrq_ox_id));
 	if (ep->oxid != ntohs(rp->rrq_ox_id))
 		goto unlock_reject;
 	if (ep->rxid != ntohs(rp->rrq_rx_id) &&
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 5121272..5c6c73a 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -764,8 +764,11 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 	fh = fc_frame_header_get(fp);
 	r_ctl = fh->fh_r_ctl;
 
-	if (lport->state != LPORT_ST_READY)
+	if (lport->state != LPORT_ST_READY) {
+		FC_FCP_DBG(fsp, "lport state %d, ignoring r_ctl %x\n",
+			   lport->state, r_ctl);
 		goto out;
+	}
 	if (fc_fcp_lock_pkt(fsp))
 		goto out;
 
@@ -774,8 +777,10 @@ static void fc_fcp_recv(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		goto unlock;
 	}
 
-	if (fsp->state & (FC_SRB_ABORTED | FC_SRB_ABORT_PENDING))
+	if (fsp->state & (FC_SRB_ABORTED | FC_SRB_ABORT_PENDING)) {
+		FC_FCP_DBG(fsp, "command aborted, ignoring r_ctl %x\n", r_ctl);
 		goto unlock;
+	}
 
 	if (r_ctl == FC_RCTL_DD_DATA_DESC) {
 		/*
@@ -910,6 +915,10 @@ static void fc_fcp_resp(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 			 * Wait a at least one jiffy to see if it is delivered.
 			 * If this expires without data, we may do SRR.
 			 */
+			FC_FCP_DBG(fsp, "tgt %6.6x xfer len %zx data underrun "
+				   "len %x, data len %x\n",
+				   fsp->rport->port_id,
+				   fsp->xfer_len, expected_len, fsp->data_len);
 			fc_fcp_timer_set(fsp, 2);
 			return;
 		}
@@ -959,8 +968,11 @@ static void fc_fcp_complete_locked(struct fc_fcp_pkt *fsp)
 		if (fsp->cdb_status == SAM_STAT_GOOD &&
 		    fsp->xfer_len < fsp->data_len && !fsp->io_status &&
 		    (!(fsp->scsi_comp_flags & FCP_RESID_UNDER) ||
-		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid))
+		     fsp->xfer_len < fsp->data_len - fsp->scsi_resid)) {
+			FC_FCP_DBG(fsp, "data underrun, xfer %zx data %x\n",
+				    fsp->xfer_len, fsp->data_len);
 			fsp->status_code = FC_DATA_UNDRUN;
+		}
 	}
 
 	seq = fsp->seq_ptr;
@@ -1222,8 +1234,11 @@ static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 	int rc = FAILED;
 	unsigned long ticks_left;
 
-	if (fc_fcp_send_abort(fsp))
+	FC_FCP_DBG(fsp, "pkt abort state %x\n", fsp->state);
+	if (fc_fcp_send_abort(fsp)) {
+		FC_FCP_DBG(fsp, "failed to send abort\n");
 		return FAILED;
+	}
 
 	init_completion(&fsp->tm_done);
 	fsp->wait_for_comp = 1;
@@ -1394,6 +1409,8 @@ static void fc_fcp_timeout(unsigned long data)
 	if (fsp->cdb_cmd.fc_tm_flags)
 		goto unlock;
 
+	FC_FCP_DBG(fsp, "fcp timeout, flags %x state %x\n",
+		   rpriv->flags, fsp->state);
 	fsp->state |= FC_SRB_FCP_PROCESSING_TMO;
 
 	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
@@ -1486,8 +1503,8 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
 		switch (rjt->er_reason) {
 		default:
-			FC_FCP_DBG(fsp, "device %x unexpected REC reject "
-				   "reason %d expl %d\n",
+			FC_FCP_DBG(fsp,
+				   "device %x invalid REC reject %d/%d\n",
 				   fsp->rport->port_id, rjt->er_reason,
 				   rjt->er_explan);
 			/* fall through */
@@ -1503,6 +1520,9 @@ static void fc_fcp_rec_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
 			break;
 		case ELS_RJT_LOGIC:
 		case ELS_RJT_UNAB:
+			FC_FCP_DBG(fsp, "device %x REC reject %d/%d\n",
+				   fsp->rport->port_id, rjt->er_reason,
+				   rjt->er_explan);
 			/*
 			 * If no data transfer, the command frame got dropped
 			 * so we just retry.  If data was transferred, we
@@ -1608,6 +1628,8 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 
 	switch (error) {
 	case -FC_EX_CLOSED:
+		FC_FCP_DBG(fsp, "REC %p fid %6.6x exchange closed\n",
+			   fsp, fsp->rport->port_id);
 		fc_fcp_retry_cmd(fsp);
 		break;
 
@@ -1622,8 +1644,8 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		 * Assume REC or LS_ACC was lost.
 		 * The exchange manager will have aborted REC, so retry.
 		 */
-		FC_FCP_DBG(fsp, "REC fid %6.6x error error %d retry %d/%d\n",
-			   fsp->rport->port_id, error, fsp->recov_retry,
+		FC_FCP_DBG(fsp, "REC %p fid %6.6x exchange timeout retry %d/%d\n",
+			   fsp, fsp->rport->port_id, fsp->recov_retry,
 			   FC_MAX_RECOV_RETRY);
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
@@ -1642,6 +1664,7 @@ static void fc_fcp_rec_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
  */
 static void fc_fcp_recovery(struct fc_fcp_pkt *fsp, u8 code)
 {
+	FC_FCP_DBG(fsp, "start recovery code %x\n", code);
 	fsp->status_code = code;
 	fsp->cdb_status = 0;
 	fsp->io_status = 0;
@@ -1768,12 +1791,14 @@ static void fc_fcp_srr_error(struct fc_fcp_pkt *fsp, struct fc_frame *fp)
 		goto out;
 	switch (PTR_ERR(fp)) {
 	case -FC_EX_TIMEOUT:
+		FC_FCP_DBG(fsp, "SRR timeout, retries %d\n", fsp->recov_retry);
 		if (fsp->recov_retry++ < FC_MAX_RECOV_RETRY)
 			fc_fcp_rec(fsp);
 		else
 			fc_fcp_recovery(fsp, FC_TIMED_OUT);
 		break;
 	case -FC_EX_CLOSED:			/* e.g., link failure */
+		FC_FCP_DBG(fsp, "SRR error, exchange closed\n");
 		/* fall through */
 	default:
 		fc_fcp_retry_cmd(fsp);
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 4b9bb6d..bcd1cd3 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -287,8 +287,10 @@ static void fc_rport_work(struct work_struct *work)
 		kref_get(&rdata->kref);
 		mutex_unlock(&rdata->rp_mutex);
 
-		if (!rport)
+		if (!rport) {
+			FC_RPORT_DBG(rdata, "No rport!\n");
 			rport = fc_remote_port_add(lport->host, 0, &ids);
+		}
 		if (!rport) {
 			FC_RPORT_DBG(rdata, "Failed to add the rport\n");
 			lport->tt.rport_logoff(rdata);
@@ -389,8 +391,10 @@ static void fc_rport_work(struct work_struct *work)
 			 * Re-open for events.  Reissue READY event if ready.
 			 */
 			rdata->event = RPORT_EV_NONE;
-			if (rdata->rp_state == RPORT_ST_READY)
+			if (rdata->rp_state == RPORT_ST_READY) {
+				FC_RPORT_DBG(rdata, "work reopen\n");
 				fc_rport_enter_ready(rdata);
+			}
 			mutex_unlock(&rdata->rp_mutex);
 		}
 		break;
@@ -568,6 +572,7 @@ static void fc_rport_timeout(struct work_struct *work)
 	struct fc_lport *lport = rdata->local_port;
 
 	mutex_lock(&rdata->rp_mutex);
+	FC_RPORT_DBG(rdata, "Port timeout, state %s\n", fc_rport_state(rdata));
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_FLOGI:
@@ -1095,6 +1100,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		struct fc_els_spp spp;
 	} *pp;
 	struct fc_els_spp temp_spp;
+	struct fc_els_ls_rjt *rjt;
 	struct fc4_prov *prov;
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 	u32 fcp_parm = 0;
@@ -1167,8 +1173,10 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 		fc_rport_enter_rtv(rdata);
 
 	} else {
-		FC_RPORT_DBG(rdata, "Bad ELS response for PRLI command\n");
-		fc_rport_error_retry(rdata, fp);
+		rjt = fc_frame_payload_get(fp, sizeof(*rjt));
+		FC_RPORT_DBG(rdata, "PRLI ELS rejected, reason %x expl %x\n",
+			     rjt->er_reason, rjt->er_explan);
+		fc_rport_error_retry(rdata, NULL);
 	}
 
 out:
@@ -1602,8 +1610,12 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	struct fc_seq_els_data els_data;
 
 	rdata = lport->tt.rport_lookup(lport, fc_frame_sid(fp));
-	if (!rdata)
+	if (!rdata) {
+		FC_RPORT_ID_DBG(lport, fc_frame_sid(fp),
+				"Received ELS 0x%02x from non-logged-in port\n",
+				fc_frame_payload_op(fp));
 		goto reject;
+	}
 
 	mutex_lock(&rdata->rp_mutex);
 
@@ -1614,6 +1626,9 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 	case RPORT_ST_ADISC:
 		break;
 	default:
+		FC_RPORT_DBG(rdata,
+			     "Reject ELS 0x%02x while in state %s\n",
+			     fc_frame_payload_op(fp), fc_rport_state(rdata));
 		mutex_unlock(&rdata->rp_mutex);
 		kref_put(&rdata->kref, lport->tt.rport_destroy);
 		goto reject;
-- 
1.8.5.6

