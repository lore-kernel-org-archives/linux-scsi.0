From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 09/19] lpfc: Allow set of maximum outstanding SCSI cmd limit for a target parameter
Date: Fri, 26 Jan 2018 11:22:29 -0800
Message-ID: <20180126192239.10727-10-jsmart2021@gmail.com>
References: <20180126192239.10727-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:45737 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752804AbeAZTXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jan 2018 14:23:05 -0500
Received: by mail-qt0-f194.google.com with SMTP id x27so3934563qtm.12
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2018 11:23:04 -0800 (PST)
In-Reply-To: <20180126192239.10727-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Make the attribute writeable.
Remove the ramp up to logic as its unnecessary, simply set depth.
Add debug message if depth changed, possibly reducing limit, yet
our outstanding count has yet to catch up with it.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  4 ++--
 drivers/scsi/lpfc/lpfc_scsi.c | 39 ++++++++++++++++++++++++++++-----------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 91df2b4e9fce..d8064e3ea0ba 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3471,8 +3471,8 @@ LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 512,
 # tgt_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per target port. Value range is [10,65535]. Default value is 65535.
 */
-LPFC_VPORT_ATTR_R(tgt_queue_depth, 65535, 10, 65535,
-		  "Max number of FCP commands we can queue to a specific target port");
+LPFC_VPORT_ATTR_RW(tgt_queue_depth, 65535, 10, 65535,
+		   "Max number of FCP commands we can queue to a specific target port");
 
 /*
 # hba_queue_depth:  This parameter is used to limit the number of outstanding
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c0cdaef4db24..dcc86936e6fc 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3926,7 +3926,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd;
-	int depth;
 	unsigned long flags;
 	struct lpfc_fast_path_event *fast_path_evt;
 	struct Scsi_Host *shost;
@@ -4132,16 +4131,11 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		}
 		spin_unlock_irqrestore(shost->host_lock, flags);
 	} else if (pnode && NLP_CHK_NODE_ACT(pnode)) {
-		if ((pnode->cmd_qdepth < vport->cfg_tgt_queue_depth) &&
-		   time_after(jiffies, pnode->last_change_time +
+		if ((pnode->cmd_qdepth != vport->cfg_tgt_queue_depth) &&
+		    time_after(jiffies, pnode->last_change_time +
 			      msecs_to_jiffies(LPFC_TGTQ_INTERVAL))) {
 			spin_lock_irqsave(shost->host_lock, flags);
-			depth = pnode->cmd_qdepth * LPFC_TGTQ_RAMPUP_PCENT
-				/ 100;
-			depth = depth ? depth : 1;
-			pnode->cmd_qdepth += depth;
-			if (pnode->cmd_qdepth > vport->cfg_tgt_queue_depth)
-				pnode->cmd_qdepth = vport->cfg_tgt_queue_depth;
+			pnode->cmd_qdepth = vport->cfg_tgt_queue_depth;
 			pnode->last_change_time = jiffies;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 		}
@@ -4564,9 +4558,32 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	 */
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
 		goto out_tgt_busy;
-	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth)
+	if (atomic_read(&ndlp->cmd_pending) >= ndlp->cmd_qdepth) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_ERROR,
+				 "3377 Target Queue Full, scsi Id:%d Qdepth:%d"
+				 " Pending command:%d"
+				 " WWNN:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x, "
+				 " WWPN:%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
+				 ndlp->nlp_sid, ndlp->cmd_qdepth,
+				 atomic_read(&ndlp->cmd_pending),
+				 ndlp->nlp_nodename.u.wwn[0],
+				 ndlp->nlp_nodename.u.wwn[1],
+				 ndlp->nlp_nodename.u.wwn[2],
+				 ndlp->nlp_nodename.u.wwn[3],
+				 ndlp->nlp_nodename.u.wwn[4],
+				 ndlp->nlp_nodename.u.wwn[5],
+				 ndlp->nlp_nodename.u.wwn[6],
+				 ndlp->nlp_nodename.u.wwn[7],
+				 ndlp->nlp_portname.u.wwn[0],
+				 ndlp->nlp_portname.u.wwn[1],
+				 ndlp->nlp_portname.u.wwn[2],
+				 ndlp->nlp_portname.u.wwn[3],
+				 ndlp->nlp_portname.u.wwn[4],
+				 ndlp->nlp_portname.u.wwn[5],
+				 ndlp->nlp_portname.u.wwn[6],
+				 ndlp->nlp_portname.u.wwn[7]);
 		goto out_tgt_busy;
-
+	}
 	lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
 	if (lpfc_cmd == NULL) {
 		lpfc_rampdown_queue_depth(phba);
-- 
2.13.1
