From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/9] lpfc 8.1.11 :  Adjust LOG_FCP logging
Date: Sat, 02 Dec 2006 13:34:42 -0500
Message-ID: <1165084483.27443.25.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56279 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1163044AbWLBQHF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:05 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71aj009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adjust LOG_FCP logging to be more meaningful.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 11:57:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2006-12-02 12:06:36.000000000 -0500
@@ -806,7 +806,7 @@ static CLASS_DEVICE_ATTR(lpfc_devloss_tm
 # LOG_NODE                      0x80       Node table events
 # LOG_MISC                      0x400      Miscellaneous events
 # LOG_SLI                       0x800      SLI events
-# LOG_CHK_COND                  0x1000     FCP Check condition flag
+# LOG_FCP_ERROR                 0x1000     Only log FCP errors
 # LOG_LIBDFC                    0x2000     LIBDFC events
 # LOG_ALL_MSG                   0xffff     LOG all messages
 */
diff -upNr a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
--- a/drivers/scsi/lpfc/lpfc_logmsg.h	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h	2006-12-02 12:06:36.000000000 -0500
@@ -28,7 +28,7 @@
 #define LOG_NODE                      0x80	/* Node table events */
 #define LOG_MISC                      0x400	/* Miscellaneous events */
 #define LOG_SLI                       0x800	/* SLI events */
-#define LOG_CHK_COND                  0x1000	/* FCP Check condition flag */
+#define LOG_FCP_ERROR                 0x1000	/* log errors, not underruns */
 #define LOG_LIBDFC                    0x2000	/* Libdfc events */
 #define LOG_ALL_MSG                   0xffff	/* LOG all messages */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2006-12-01 12:13:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2006-12-02 12:06:36.000000000 -0500
@@ -297,8 +297,10 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 	uint32_t fcpi_parm = lpfc_cmd->cur_iocbq.iocb.un.fcpi.fcpi_parm;
 	uint32_t resp_info = fcprsp->rspStatus2;
 	uint32_t scsi_status = fcprsp->rspStatus3;
+	uint32_t *lp;
 	uint32_t host_status = DID_OK;
 	uint32_t rsplen = 0;
+	uint32_t logit = LOG_FCP | LOG_FCP_ERROR;
 
 	/*
 	 *  If this is a task management command, there is no
@@ -310,10 +312,25 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 		goto out;
 	}
 
-	lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
-			"%d:0730 FCP command failed: RSP "
-			"Data: x%x x%x x%x x%x x%x x%x\n",
-			phba->brd_no, resp_info, scsi_status,
+	if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen) {
+		uint32_t snslen = be32_to_cpu(fcprsp->rspSnsLen);
+		if (snslen > SCSI_SENSE_BUFFERSIZE)
+			snslen = SCSI_SENSE_BUFFERSIZE;
+
+		if (resp_info & RSP_LEN_VALID)
+		  rsplen = be32_to_cpu(fcprsp->rspRspLen);
+		memcpy(cmnd->sense_buffer, &fcprsp->rspInfo0 + rsplen, snslen);
+	}
+	lp = (uint32_t *)cmnd->sense_buffer;
+
+	if (!scsi_status && (resp_info & RESID_UNDER))
+		logit = LOG_FCP;
+
+	lpfc_printf_log(phba, KERN_WARNING, logit,
+			"%d:0730 FCP command x%x failed: x%x SNS x%x x%x "
+			"Data: x%x x%x x%x x%x x%x\n",
+			phba->brd_no, cmnd->cmnd[0], scsi_status,
+			be32_to_cpu(*lp), be32_to_cpu(*(lp + 3)), resp_info,
 			be32_to_cpu(fcprsp->rspResId),
 			be32_to_cpu(fcprsp->rspSnsLen),
 			be32_to_cpu(fcprsp->rspRspLen),
@@ -328,14 +345,6 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 		}
 	}
 
-	if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen) {
-		uint32_t snslen = be32_to_cpu(fcprsp->rspSnsLen);
-		if (snslen > SCSI_SENSE_BUFFERSIZE)
-			snslen = SCSI_SENSE_BUFFERSIZE;
-
-		memcpy(cmnd->sense_buffer, &fcprsp->rspInfo0 + rsplen, snslen);
-	}
-
 	cmnd->resid = 0;
 	if (resp_info & RESID_UNDER) {
 		cmnd->resid = be32_to_cpu(fcprsp->rspResId);
@@ -378,7 +387,7 @@ lpfc_handle_fcp_err(struct lpfc_scsi_buf
 	 */
 	} else if ((scsi_status == SAM_STAT_GOOD) && fcpi_parm &&
 			(cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
-		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
+		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
 			"%d:0734 FCP Read Check Error Data: "
 			"x%x x%x x%x x%x\n", phba->brd_no,
 			be32_to_cpu(fcpcmd->fcpDl),


