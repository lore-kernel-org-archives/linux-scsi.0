From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/8] lpfc 8.3.43: Fixed invalid fcp_rsp length fir FCP_ICMND
Date: Thu, 10 Oct 2013 12:22:38 -0400
Message-ID: <1381422158.20248.21.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5445 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab3JJQWk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:22:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed invalid fcp_rsp length fir FCP_ICMND


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h |   24 +++++++++++++++++++++---
 lpfc_sli.c |   19 ++++++++++++++-----
 2 files changed, 35 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2013-10-09 10:39:20.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2013-10-09 17:25:37.026650720 -0400
@@ -3584,7 +3584,13 @@ struct abort_cmd_wqe {
 
 struct fcp_iwrite64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t payload_offset_len;
+	uint32_t word3;
+#define	cmd_buff_len_SHIFT  16
+#define	cmd_buff_len_MASK  0x00000ffff
+#define	cmd_buff_len_WORD  word3
+#define payload_offset_len_SHIFT 0
+#define payload_offset_len_MASK 0x0000ffff
+#define payload_offset_len_WORD word3
 	uint32_t total_xfer_len;
 	uint32_t initial_xfer_len;
 	struct wqe_common wqe_com;     /* words 6-11 */
@@ -3594,7 +3600,13 @@ struct fcp_iwrite64_wqe {
 
 struct fcp_iread64_wqe {
 	struct ulp_bde64 bde;
-	uint32_t payload_offset_len;   /* word 3 */
+	uint32_t word3;
+#define	cmd_buff_len_SHIFT  16
+#define	cmd_buff_len_MASK  0x00000ffff
+#define	cmd_buff_len_WORD  word3
+#define payload_offset_len_SHIFT 0
+#define payload_offset_len_MASK 0x0000ffff
+#define payload_offset_len_WORD word3
 	uint32_t total_xfer_len;       /* word 4 */
 	uint32_t rsrvd5;               /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
@@ -3604,7 +3616,13 @@ struct fcp_iread64_wqe {
 
 struct fcp_icmnd64_wqe {
 	struct ulp_bde64 bde;          /* words 0-2 */
-	uint32_t rsrvd3;               /* word 3 */
+	uint32_t word3;
+#define	cmd_buff_len_SHIFT  16
+#define	cmd_buff_len_MASK  0x00000ffff
+#define	cmd_buff_len_WORD  word3
+#define payload_offset_len_SHIFT 0
+#define payload_offset_len_MASK 0x0000ffff
+#define payload_offset_len_WORD word3
 	uint32_t rsrvd4;               /* word 4 */
 	uint32_t rsrvd5;               /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:35.740650691 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:37.030650720 -0400
@@ -8232,8 +8232,10 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		command_type = FCP_COMMAND_DATA_OUT;
 		/* word3 iocb=iotag wqe=payload_offset_len */
 		/* Add the FCP_CMD and FCP_RSP sizes to get the offset */
-		wqe->fcp_iwrite.payload_offset_len =
-			xmit_len + sizeof(struct fcp_rsp);
+		bf_set(payload_offset_len, &wqe->fcp_iwrite,
+		       xmit_len + sizeof(struct fcp_rsp));
+		bf_set(cmd_buff_len, &wqe->fcp_iwrite,
+		       0);
 		/* word4 iocb=parameter wqe=total_xfer_length memcpy */
 		/* word5 iocb=initial_xfer_len wqe=initial_xfer_len memcpy */
 		bf_set(wqe_erp, &wqe->fcp_iwrite.wqe_com,
@@ -8251,8 +8253,10 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	case CMD_FCP_IREAD64_CR:
 		/* word3 iocb=iotag wqe=payload_offset_len */
 		/* Add the FCP_CMD and FCP_RSP sizes to get the offset */
-		wqe->fcp_iread.payload_offset_len =
-			xmit_len + sizeof(struct fcp_rsp);
+		bf_set(payload_offset_len, &wqe->fcp_iread,
+		       xmit_len + sizeof(struct fcp_rsp));
+		bf_set(cmd_buff_len, &wqe->fcp_iread,
+		       0);
 		/* word4 iocb=parameter wqe=total_xfer_length memcpy */
 		/* word5 iocb=initial_xfer_len wqe=initial_xfer_len memcpy */
 		bf_set(wqe_erp, &wqe->fcp_iread.wqe_com,
@@ -8268,8 +8272,13 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 1);
 		break;
 	case CMD_FCP_ICMND64_CR:
+		/* word3 iocb=iotag wqe=payload_offset_len */
+		/* Add the FCP_CMD and FCP_RSP sizes to get the offset */
+		bf_set(payload_offset_len, &wqe->fcp_icmd,
+		       xmit_len + sizeof(struct fcp_rsp));
+		bf_set(cmd_buff_len, &wqe->fcp_icmd,
+		       0);
 		/* word3 iocb=IO_TAG wqe=reserved */
-		wqe->fcp_icmd.rsrvd3 = 0;
 		bf_set(wqe_pu, &wqe->fcp_icmd.wqe_com, 0);
 		/* Always open the exchange */
 		bf_set(wqe_xc, &wqe->fcp_icmd.wqe_com, 0);



