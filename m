From: James.Smart@Emulex.Com
Subject: [PATCH 10/11]  lpfc 8.1.1 : Added code to adjust lun queue depth to avoid target overloading
Date: Mon, 28 Nov 2005 11:42:38 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C4E@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48629 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751298AbVK1Qmk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 11:42:40 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id jASGgds3014174
	for <linux-scsi@vger.kernel.org>; Mon, 28 Nov 2005 08:42:39 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com


Added code to adjust lun queue depth to avoid target overloading.


Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2005-11-28 10:36:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2005-11-28 11:08:23.000000000 -0500
@@ -73,6 +73,8 @@ struct lpfc_nodelist {
 	struct lpfc_hba      *nlp_phba;
 	struct lpfc_work_evt nodev_timeout_evt;
 	struct lpfc_work_evt els_retry_evt;
+	unsigned long last_ramp_up_time;        /* jiffy of last ramp up */
+	unsigned long last_q_full_time;		/* jiffy of last queue full */
 };
 
 /* Defines for nlp_flag (uint32) */
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2005-11-28 11:06:46.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2005-11-28 11:08:23.000000000 -0500
@@ -29,9 +29,10 @@ struct lpfc_sli2_slim;
 #define LPFC_LC_HBA_Q_DEPTH	1024	/* max cmds per low cost hba */
 #define LPFC_LP101_HBA_Q_DEPTH	128	/* max cmds per low cost hba */
 
-#define LPFC_CMD_PER_LUN	30	/* max outstanding cmds per lun */
+#define LPFC_CMD_PER_LUN	3	/* max outstanding cmds per lun */
 #define LPFC_SG_SEG_CNT		64	/* sg element count per scsi cmnd */
 #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
+#define LPFC_Q_RAMP_UP_INTERVAL 120     /* lun q_depth ramp up interval */
 
 /* Define macros for 64 bit support */
 #define putPaddrLow(addr)    ((uint32_t) (0xffffffff & (u64)(addr)))
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 11:06:46.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2005-11-28 11:08:23.000000000 -0500
@@ -409,6 +409,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	int result;
+	struct scsi_device *sdev, *tmp_sdev;
+	int depth = 0;
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -460,8 +463,63 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 				*lp, *(lp + 3), cmd->retries, cmd->resid);
 	}
 
+	result = cmd->result;
+	sdev = cmd->device;
 	cmd->scsi_done(cmd);
 
+	if (!result &&
+	   ((jiffies - pnode->last_ramp_up_time) >
+		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
+	   ((jiffies - pnode->last_q_full_time) >
+		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
+	   (phba->cfg_lun_queue_depth > sdev->queue_depth)) {
+		shost_for_each_device(tmp_sdev, sdev->host) {
+			if (phba->cfg_lun_queue_depth > tmp_sdev->queue_depth) {
+				if (tmp_sdev->id != sdev->id)
+					continue;
+				if (tmp_sdev->ordered_tags)
+					scsi_adjust_queue_depth(tmp_sdev,
+						MSG_ORDERED_TAG,
+						tmp_sdev->queue_depth+1);
+				else
+					scsi_adjust_queue_depth(tmp_sdev,
+						MSG_SIMPLE_TAG,
+						tmp_sdev->queue_depth+1);
+
+				pnode->last_ramp_up_time = jiffies;
+			}
+		}
+	}
+
+	/*
+	 * Check for queue full.  If the lun is reporting queue full, then
+	 * back off the lun queue depth to prevent target overloads.
+	 */
+	if (result == SAM_STAT_TASK_SET_FULL) {
+		pnode->last_q_full_time = jiffies;
+
+		shost_for_each_device(tmp_sdev, sdev->host) {
+			if (tmp_sdev->id != sdev->id)
+				continue;
+			depth = scsi_track_queue_full(tmp_sdev,
+					tmp_sdev->queue_depth - 1);
+		}
+		/*
+ 		 * The queue depth cannot be lowered any more.
+		 * Modify the returned error code to store
+		 * the final depth value set by
+		 * scsi_track_queue_full.
+		 */
+		if (depth == -1)
+			depth = sdev->host->cmd_per_lun;
+
+		if (depth) {
+			lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
+				"%d:0711 detected queue full - lun queue depth "
+				" adjusted to %d.\n", phba->brd_no, depth);
+		}
+	}
+
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
 }
 
