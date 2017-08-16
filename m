From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.13-rc4
Date: Wed, 16 Aug 2017 15:13:25 -0700
Message-ID: <1502921605.3589.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A couple of minor fixes (st, ses) and some bigger driver fixes for
qla2xxx (crash triggered by fw dump) and ipr (lockdep problems with
mq).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bodo Stroesser (1):
      scsi: st: fix blk_get_queue usage

Brian King (2):
      scsi: ses: Fix wrong page error
      scsi: ipr: Fix scsi-mq lockdep issue

Michael Hernandez (1):
      scsi: qla2xxx: Fix system crash while triggering FW dump

And the diffstat:

 drivers/scsi/ipr.c              | 33 +++++++++++++++++++--------------
 drivers/scsi/ipr.h              |  2 ++
 drivers/scsi/qla2xxx/qla_tmpl.c | 12 ------------
 drivers/scsi/ses.c              |  2 +-
 drivers/scsi/st.c               |  4 ++--
 5 files changed, 24 insertions(+), 29 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0c68d24db01..da5bdbdcce52 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3351,6 +3351,16 @@ static void ipr_worker_thread(struct work_struct *work)
 		return;
 	}
 
+	if (ioa_cfg->scsi_unblock) {
+		ioa_cfg->scsi_unblock = 0;
+		ioa_cfg->scsi_blocked = 0;
+		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
+		scsi_unblock_requests(ioa_cfg->host);
+		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
+		if (ioa_cfg->scsi_blocked)
+			scsi_block_requests(ioa_cfg->host);
+	}
+
 	if (!ioa_cfg->scan_enabled) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return;
@@ -7211,9 +7221,8 @@ static int ipr_ioa_bringdown_done(struct ipr_cmnd *ipr_cmd)
 	ENTER;
 	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
 		ipr_trace;
-		spin_unlock_irq(ioa_cfg->host->host_lock);
-		scsi_unblock_requests(ioa_cfg->host);
-		spin_lock_irq(ioa_cfg->host->host_lock);
+		ioa_cfg->scsi_unblock = 1;
+		schedule_work(&ioa_cfg->work_q);
 	}
 
 	ioa_cfg->in_reset_reload = 0;
@@ -7287,13 +7296,7 @@ static int ipr_ioa_reset_done(struct ipr_cmnd *ipr_cmd)
 	list_add_tail(&ipr_cmd->queue, &ipr_cmd->hrrq->hrrq_free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
 
-	spin_unlock(ioa_cfg->host->host_lock);
-	scsi_unblock_requests(ioa_cfg->host);
-	spin_lock(ioa_cfg->host->host_lock);
-
-	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].allow_cmds)
-		scsi_block_requests(ioa_cfg->host);
-
+	ioa_cfg->scsi_unblock = 1;
 	schedule_work(&ioa_cfg->work_q);
 	LEAVE;
 	return IPR_RC_JOB_RETURN;
@@ -9249,8 +9252,11 @@ static void _ipr_initiate_ioa_reset(struct ipr_ioa_cfg *ioa_cfg,
 		spin_unlock(&ioa_cfg->hrrq[i]._lock);
 	}
 	wmb();
-	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa)
+	if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
+		ioa_cfg->scsi_unblock = 0;
+		ioa_cfg->scsi_blocked = 1;
 		scsi_block_requests(ioa_cfg->host);
+	}
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioa_cfg->reset_cmd = ipr_cmd;
@@ -9306,9 +9312,8 @@ static void ipr_initiate_ioa_reset(struct ipr_ioa_cfg *ioa_cfg,
 			wake_up_all(&ioa_cfg->reset_wait_q);
 
 			if (!ioa_cfg->hrrq[IPR_INIT_HRRQ].removing_ioa) {
-				spin_unlock_irq(ioa_cfg->host->host_lock);
-				scsi_unblock_requests(ioa_cfg->host);
-				spin_lock_irq(ioa_cfg->host->host_lock);
+				ioa_cfg->scsi_unblock = 1;
+				schedule_work(&ioa_cfg->work_q);
 			}
 			return;
 		} else {
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index e98a87a65335..c7f0e9e3cd7d 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1488,6 +1488,8 @@ struct ipr_ioa_cfg {
 	u8 cfg_locked:1;
 	u8 clear_isr:1;
 	u8 probe_done:1;
+	u8 scsi_unblock:1;
+	u8 scsi_blocked:1;
 
 	u8 revid;
 
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 33142610882f..b18646d6057f 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -401,9 +401,6 @@ qla27xx_fwdt_entry_t263(struct scsi_qla_host *vha,
 		for (i = 0; i < vha->hw->max_req_queues; i++) {
 			struct req_que *req = vha->hw->req_q_map[i];
 
-			if (!test_bit(i, vha->hw->req_qid_map))
-				continue;
-
 			if (req || !buf) {
 				length = req ?
 				    req->length : REQUEST_ENTRY_CNT_24XX;
@@ -418,9 +415,6 @@ qla27xx_fwdt_entry_t263(struct scsi_qla_host *vha,
 		for (i = 0; i < vha->hw->max_rsp_queues; i++) {
 			struct rsp_que *rsp = vha->hw->rsp_q_map[i];
 
-			if (!test_bit(i, vha->hw->rsp_qid_map))
-				continue;
-
 			if (rsp || !buf) {
 				length = rsp ?
 				    rsp->length : RESPONSE_ENTRY_CNT_MQ;
@@ -660,9 +654,6 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 		for (i = 0; i < vha->hw->max_req_queues; i++) {
 			struct req_que *req = vha->hw->req_q_map[i];
 
-			if (!test_bit(i, vha->hw->req_qid_map))
-				continue;
-
 			if (req || !buf) {
 				qla27xx_insert16(i, buf, len);
 				qla27xx_insert16(1, buf, len);
@@ -675,9 +666,6 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 		for (i = 0; i < vha->hw->max_rsp_queues; i++) {
 			struct rsp_que *rsp = vha->hw->rsp_q_map[i];
 
-			if (!test_bit(i, vha->hw->rsp_qid_map))
-				continue;
-
 			if (rsp || !buf) {
 				qla27xx_insert16(i, buf, len);
 				qla27xx_insert16(1, buf, len);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index f1cdf32d7514..8927f9f54ad9 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -99,7 +99,7 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 
 	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
 				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
-	if (unlikely(!ret))
+	if (unlikely(ret))
 		return ret;
 
 	recv_page_code = ((unsigned char *)buf)[0];
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8e5013d9cad4..94e402ed30f6 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4299,11 +4299,11 @@ static int st_probe(struct device *dev)
 	kref_init(&tpnt->kref);
 	tpnt->disk = disk;
 	disk->private_data = &tpnt->driver;
-	disk->queue = SDp->request_queue;
 	/* SCSI tape doesn't register this gendisk via add_disk().  Manually
 	 * take queue reference that release_disk() expects. */
-	if (!blk_get_queue(disk->queue))
+	if (!blk_get_queue(SDp->request_queue))
 		goto out_put_disk;
+	disk->queue = SDp->request_queue;
 	tpnt->driver = &st_template;
 
 	tpnt->device = SDp;
