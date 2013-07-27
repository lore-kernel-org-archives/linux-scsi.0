From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.11-rc2
Date: Sat, 27 Jul 2013 08:22:58 -0700
Message-ID: <1374938578.1973.14.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51085 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051Ab3G0PXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jul 2013 11:23:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is five bug fixes, two of which fix long standing problems causing
crashes (sd and mvsas).  The remaining three are hung (isci race) or
lost (qla2xxx, isci) devices.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ewan D. Milne (1):
      sd: fix crash when UA received on DIF enabled device

James Bottomley (2):
      isci: fix breakage caused by >16byte CDB patch
      mvsas: Fix kernel panic on tile due to unaligned data access

Jeff Skirvin (1):
      isci: Fix a race condition in the SSP task management path

Saurav Kashyap (1):
      qla2xxx: Properly set the tagging for commands.

The diffstat:

 drivers/scsi/isci/request.c     |  2 +-
 drivers/scsi/isci/task.c        |  9 ++++++---
 drivers/scsi/mvsas/mv_sas.c     | 11 ++++++++---
 drivers/scsi/mvsas/mv_sas.h     |  1 +
 drivers/scsi/qla2xxx/qla_iocb.c | 11 +++++++++--
 drivers/scsi/sd.c               | 22 +++++++---------------
 6 files changed, 32 insertions(+), 24 deletions(-)

And the complete diff is attached below.

James

---

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 7b08215..99d2930 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -185,7 +185,7 @@ static void sci_io_request_build_ssp_command_iu(struct isci_request *ireq)
 	cmd_iu->_r_c = 0;
 
 	sci_swab32_cpy(&cmd_iu->cdb, task->ssp_task.cmd->cmnd,
-		       task->ssp_task.cmd->cmd_len / sizeof(u32));
+		       (task->ssp_task.cmd->cmd_len+3) / sizeof(u32));
 }
 
 static void sci_task_request_build_ssp_task_iu(struct isci_request *ireq)
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 9bb020a..0d30ca8 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -491,6 +491,7 @@ int isci_task_abort_task(struct sas_task *task)
 	struct isci_tmf           tmf;
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -505,9 +506,11 @@ int isci_task_abort_task(struct sas_task *task)
 	/* If task is already done, the request isn't valid */
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
-	    old_request)
+	    old_request) {
 		idev = isci_get_device(task->dev->lldd_dev);
-
+		target_done_already = test_bit(IREQ_COMPLETE_IN_TARGET,
+					       &old_request->flags);
+	}
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
@@ -561,7 +564,7 @@ int isci_task_abort_task(struct sas_task *task)
 
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags) ||
+	    target_done_already ||
 	    test_bit(IDEV_GONE, &idev->flags)) {
 
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f14665a..6b1b4e9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1857,11 +1857,16 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 		goto out;
 	}
 
-	/* error info record present */
-	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+	/*
+	 * error info record present; slot->response is 32 bit aligned but may
+	 * not be 64 bit aligned, so check for zero in two 32 bit reads
+	 */
+	if (unlikely((rx_desc & RXQ_ERR)
+		     && (*((u32 *)slot->response)
+			 || *(((u32 *)slot->response) + 1)))) {
 		mv_dprintk("port %d slot %d rx_desc %X has error info"
 			"%016llX.\n", slot->port->sas_port.id, slot_idx,
-			 rx_desc, (u64)(*(u64 *)slot->response));
+			 rx_desc, get_unaligned_le64(slot->response));
 		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
 		tstat->resp = SAS_TASK_COMPLETE;
 		goto out;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 60e2fb7..d6b19dc 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -39,6 +39,7 @@
 #include <linux/irq.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <asm/unaligned.h>
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42ef481..ef0a548 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -419,6 +419,8 @@ qla2x00_start_scsi(srb_t *sp)
 			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
 			break;
 		}
+	} else {
+		cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 	}
 
 	/* Load SCSI command packet. */
@@ -1307,11 +1309,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		    fcp_cmnd->task_attribute = TSK_ORDERED;
 		    break;
 		default:
-		    fcp_cmnd->task_attribute = 0;
+		    fcp_cmnd->task_attribute = TSK_SIMPLE;
 		    break;
 		}
 	} else {
-		fcp_cmnd->task_attribute = 0;
+		fcp_cmnd->task_attribute = TSK_SIMPLE;
 	}
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
@@ -1525,7 +1527,12 @@ qla24xx_start_scsi(srb_t *sp)
 		case ORDERED_QUEUE_TAG:
 			cmd_pkt->task = TSK_ORDERED;
 			break;
+		default:
+		    cmd_pkt->task = TSK_SIMPLE;
+		    break;
 		}
+	} else {
+		cmd_pkt->task = TSK_SIMPLE;
 	}
 
 	/* Load SCSI command packet. */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 80f39b8..86fcf2c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -838,10 +838,17 @@ static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
+	struct scsi_cmnd *SCpnt = rq->special;
+
 	if (rq->cmd_flags & REQ_DISCARD) {
 		free_page((unsigned long)rq->buffer);
 		rq->buffer = NULL;
 	}
+	if (SCpnt->cmnd != rq->cmd) {
+		mempool_free(SCpnt->cmnd, sd_cdb_pool);
+		SCpnt->cmnd = NULL;
+		SCpnt->cmd_len = 0;
+	}
 }
 
 /**
@@ -1720,21 +1727,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
-	if (scsi_host_dif_capable(sdkp->device->host, sdkp->protection_type)
-	    == SD_DIF_TYPE2_PROTECTION && SCpnt->cmnd != SCpnt->request->cmd) {
-
-		/* We have to print a failed command here as the
-		 * extended CDB gets freed before scsi_io_completion()
-		 * is called.
-		 */
-		if (result)
-			scsi_print_command(SCpnt);
-
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
-		SCpnt->cmnd = NULL;
-		SCpnt->cmd_len = 0;
-	}
-
 	return good_bytes;
 }
 


