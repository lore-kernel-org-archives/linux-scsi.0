From: Chuck Tuffli <chuck_tuffli@pmc-sierra.com>
Subject: [RFC PATCH 1/1] libsas: Add data integrity support
Date: Wed, 9 Mar 2011 14:19:48 -0800
Message-ID: <20110309221948.GA11376@rtllnx49.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:43499 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189Ab1CIWwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2011 17:52:54 -0500
Received: from bby1mta02.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id B3B2A8E00A7
	for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2011 14:19:48 -0800 (PST)
Received: from pmc-sierra.com (rtllnx49.pmc-sierra.bc.ca [209.68.173.73])
	by bby1mta02.pmc-sierra.bc.ca (Postfix) with ESMTP id 956448E007F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2011 14:19:48 -0800 (PST)
Received: (from tufflich@localhost)
	by pmc-sierra.com (8.13.1/8.13.1/Submit) id p29MJmOS011515
	for linux-scsi@vger.kernel.org; Wed, 9 Mar 2011 14:19:48 -0800
Content-Disposition: inline; filename="libsas_dix.patch"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Chuck Tuffli <chuck_tuffli@pmc-sierra.com>

This patch adds Data Integrity support to libsas

Signed-off-by: Chuck Tuffli <chuck_tuffli@pmc-sierra.com>
---

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2119871..91c6afe 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -54,7 +54,7 @@ static void sas_scsi_task_done(struct sas_task *task)
 {
 	struct task_status_struct *ts = &task->task_status;
 	struct scsi_cmnd *sc = task->uldd_task;
-	int hs = 0, stat = 0;
+	int ds = 0, hs = 0, stat = 0;
 
 	if (unlikely(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		/* Aborted tasks will be completed by the error handler */
@@ -118,13 +118,39 @@ static void sas_scsi_task_done(struct sas_task *task)
 			       min(SCSI_SENSE_BUFFERSIZE, ts->buf_valid_size));
 			stat = SAM_STAT_CHECK_CONDITION;
 			break;
+		case SAS_DIF_ERR_GUARD_TAG:
+			BUG_ON(NULL == sc->sense_buffer);
+			scsi_build_sense_buffer(1, sc->sense_buffer,
+					ILLEGAL_REQUEST, 0x10, 0x1);
+			ds = DRIVER_SENSE;
+			hs = DID_ABORT;
+			stat = SAM_STAT_CHECK_CONDITION;
+			break;
+		case SAS_DIF_ERR_APP_TAG:
+			BUG_ON(NULL == sc->sense_buffer);
+			scsi_build_sense_buffer(1, sc->sense_buffer,
+					ILLEGAL_REQUEST, 0x10, 0x2);
+			ds = DRIVER_SENSE;
+			hs = DID_ABORT;
+			stat = SAM_STAT_CHECK_CONDITION;
+			break;
+		case SAS_DIF_ERR_REF_TAG:
+			BUG_ON(NULL == sc->sense_buffer);
+			scsi_build_sense_buffer(1, sc->sense_buffer,
+					ILLEGAL_REQUEST, 0x10, 0x3);
+			ds = DRIVER_SENSE;
+			hs = DID_ABORT;
+			stat = SAM_STAT_CHECK_CONDITION;
+			break;
 		default:
 			stat = ts->stat;
 			break;
 		}
 	}
 	ASSIGN_SAS_TASK(sc, NULL);
-	sc->result = (hs << 16) | stat;
+	sc->result = stat;
+	set_host_byte(sc, hs);
+	set_driver_byte(sc, ds);
 	list_del_init(&task->list);
 	sas_free_task(task);
 	sc->scsi_done(sc);
@@ -152,6 +178,10 @@ static struct sas_task *sas_create_task(struct scsi_cmnd *cmd,
 	task->ssp_task.task_attr = TASK_ATTR_SIMPLE;
 	memcpy(task->ssp_task.cdb, cmd->cmnd, 16);
 
+	task->prot = scsi_get_prot_op(cmd);
+	task->prot_sg = scsi_prot_sglist(cmd);
+	task->prot_num_scatter = scsi_prot_sg_count(cmd);
+
 	task->scatter = scsi_sglist(cmd);
 	task->num_scatter = scsi_sg_count(cmd);
 	task->total_xfer_len = scsi_bufflen(cmd);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8f6bb9c..04bfa42 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -441,6 +441,9 @@ enum exec_status {
 	SAS_NAK_R_ERR,
 	SAS_PENDING,
 	SAS_ABORTED_TASK,
+	SAS_DIF_ERR_APP_TAG,
+	SAS_DIF_ERR_REF_TAG,
+	SAS_DIF_ERR_GUARD_TAG,
 };
 
 /* When a task finishes with a response, the LLDD examines the
@@ -544,7 +547,10 @@ struct sas_task {
 	struct scatterlist *scatter;
 	int    num_scatter;
 	u32    total_xfer_len;
-	u8     data_dir:2;	  /* Use PCI_DMA_... */
+	struct scatterlist *prot_sg;
+	int    prot_num_scatter;
+	u8     data_dir:2,	  /* Use PCI_DMA_... */
+		   prot:3;
 
 	struct task_status_struct task_status;
 	void   (*task_done)(struct sas_task *);
