From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 7/9] lpfc: Fix scsi task management error message.
Date: Fri, 22 May 2015 10:42:41 -0400
Message-ID: <555f4061.JF1uAXJ3MNmJF4W9%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33860 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237AbbEVOmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 10:42:55 -0400
Received: by qgez61 with SMTP id z61so9107701qge.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 May 2015 07:42:55 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id e104sm1409727qgd.29.2015.05.22.07.42.54
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Fri, 22 May 2015 07:42:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix scsi task management error message.

TMF's were getting error messages on FCP_RSP errors (underrun). Underruns
aren't meaningful in the scenario. Change the error message to filter out
these response check errors, and don't unconditionally mark the cmd as
in error.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index b3b195f..e5eb40d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5011,13 +5011,16 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if ((status != IOCB_SUCCESS) ||
 	    (iocbqrsp->iocb.ulpStatus != IOSTAT_SUCCESS)) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0727 TMF %s to TGT %d LUN %llu failed (%d, %d) "
-			 "iocb_flag x%x\n",
-			 lpfc_taskmgmt_name(task_mgmt_cmd),
-			 tgt_id, lun_id, iocbqrsp->iocb.ulpStatus,
-			 iocbqrsp->iocb.un.ulpWord[4],
-			 iocbq->iocb_flag);
+		if (status != IOCB_SUCCESS ||
+		    iocbqrsp->iocb.ulpStatus != IOSTAT_FCP_RSP_ERROR)
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+					 "0727 TMF %s to TGT %d LUN %llu "
+					 "failed (%d, %d) iocb_flag x%x\n",
+					 lpfc_taskmgmt_name(task_mgmt_cmd),
+					 tgt_id, lun_id,
+					 iocbqrsp->iocb.ulpStatus,
+					 iocbqrsp->iocb.un.ulpWord[4],
+					 iocbq->iocb_flag);
 		/* if ulpStatus != IOCB_SUCCESS, then status == IOCB_SUCCESS */
 		if (status == IOCB_SUCCESS) {
 			if (iocbqrsp->iocb.ulpStatus == IOSTAT_FCP_RSP_ERROR)
@@ -5031,7 +5034,6 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 		} else {
 			ret = FAILED;
 		}
-		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 	} else
 		ret = SUCCESS;
 
-- 
1.7.11.7

