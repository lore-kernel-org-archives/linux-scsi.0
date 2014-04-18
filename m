From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 2/3] fnic:Failing to queue aborts due to Q full cause terminate driver timeout
Date: Fri, 18 Apr 2014 12:28:18 -0700
Message-ID: <1397849299-10029-2-git-send-email-hishah@cisco.com>
References: <1397849299-10029-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-4.cisco.com ([173.36.130.15]:64129 "EHLO
	mtv-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaDRTmk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2014 15:42:40 -0400
In-Reply-To: <1397849299-10029-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>

In fnic abort handler, abort queuing can be failed when hardware queue is full.
The command state is left as abort queued. The command with abort queued state
will never be queued next time for abort or termiantion.
Fix restores the command state in above case.

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0521436..ea28b5c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1312,8 +1312,9 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 
 cleanup_scsi_cmd:
 		sc->result = DID_TRANSPORT_DISRUPTED << 16;
-		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "fnic_cleanup_io:"
-			      " DID_TRANSPORT_DISRUPTED\n");
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			      "%s: sc duration = %lu DID_TRANSPORT_DISRUPTED\n",
+			      __func__, (jiffies - start_time));
 
 		if (atomic64_read(&fnic->io_cmpl_skip))
 			atomic64_dec(&fnic->io_cmpl_skip);
@@ -1733,6 +1734,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	struct fnic_stats *fnic_stats;
 	struct abort_stats *abts_stats;
 	struct terminate_stats *term_stats;
+	enum fnic_ioreq_state old_ioreq_state;
 	int tag;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
@@ -1793,6 +1795,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	 * the completion wont be done till mid-layer, since abort
 	 * has already started.
 	 */
+	old_ioreq_state = CMD_STATE(sc);
 	CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
 	CMD_ABTS_STATUS(sc) = FCPIO_INVALID_CODE;
 
@@ -1816,6 +1819,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	if (fnic_queue_abort_io_req(fnic, sc->request->tag, task_req,
 				    fc_lun.scsi_lun, io_req)) {
 		spin_lock_irqsave(io_lock, flags);
+		if (CMD_STATE(sc) == FNIC_IOREQ_ABTS_PENDING)
+			CMD_STATE(sc) = old_ioreq_state;
 		io_req = (struct fnic_io_req *)CMD_SP(sc);
 		if (io_req)
 			io_req->abts_done = NULL;
@@ -1859,12 +1864,8 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	if (CMD_ABTS_STATUS(sc) == FCPIO_INVALID_CODE) {
 		spin_unlock_irqrestore(io_lock, flags);
 		if (task_req == FCPIO_ITMF_ABT_TASK) {
-			FNIC_SCSI_DBG(KERN_INFO,
-				fnic->lport->host, "Abort Driver Timeout\n");
 			atomic64_inc(&abts_stats->abort_drv_timeouts);
 		} else {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host,
-				"Terminate Driver Timeout\n");
 			atomic64_inc(&term_stats->terminate_drv_timeouts);
 		}
 		CMD_FLAGS(sc) |= FNIC_IO_ABT_TERM_TIMED_OUT;
-- 
1.8.5.4

