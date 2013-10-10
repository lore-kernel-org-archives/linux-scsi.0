From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/8] lpfc 8.3.43: Fixed invalid Total_Data_Placed value
 received for els and ct command responses
Date: Thu, 10 Oct 2013 12:23:10 -0400
Message-ID: <1381422190.20248.23.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49080 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3JJQXL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:23:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed invalid Total_Data_Placed value received for els and ct command responses


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h |    6 ++++--
 lpfc_sli.c |   38 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2013-10-09 17:25:37.026650720 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2013-10-09 17:25:38.119649602 -0400
@@ -3439,7 +3439,8 @@ struct els_request64_wqe {
 #define els_req64_hopcnt_SHIFT      24
 #define els_req64_hopcnt_MASK       0x000000ff
 #define els_req64_hopcnt_WORD       word13
-	uint32_t reserved[2];
+	uint32_t word14;
+	uint32_t max_response_payload_len;
 };
 
 struct xmit_els_rsp64_wqe {
@@ -3554,7 +3555,8 @@ struct gen_req64_wqe {
 	uint32_t relative_offset;
 	struct wqe_rctl_dfctl wge_ctl; /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
-	uint32_t rsvd_12_15[4];
+	uint32_t rsvd_12_14[3];
+	uint32_t max_response_payload_len;
 };
 
 struct create_xri_wqe {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:37.030650720 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-10-09 17:25:38.134650282 -0400
@@ -8188,6 +8188,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_qosd, &wqe->els_req.wqe_com, 1);
 		bf_set(wqe_lenloc, &wqe->els_req.wqe_com, LPFC_WQE_LENLOC_NONE);
 		bf_set(wqe_ebde_cnt, &wqe->els_req.wqe_com, 0);
+		wqe->els_req.max_response_payload_len = total_len - xmit_len;
 		break;
 	case CMD_XMIT_SEQUENCE64_CX:
 		bf_set(wqe_ctxt_tag, &wqe->xmit_sequence.wqe_com,
@@ -8324,6 +8325,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_qosd, &wqe->gen_req.wqe_com, 1);
 		bf_set(wqe_lenloc, &wqe->gen_req.wqe_com, LPFC_WQE_LENLOC_NONE);
 		bf_set(wqe_ebde_cnt, &wqe->gen_req.wqe_com, 0);
+		wqe->gen_req.max_response_payload_len = total_len - xmit_len;
 		command_type = OTHER_COMMAND;
 		break;
 	case CMD_XMIT_ELS_RSP64_CX:
@@ -11195,8 +11197,11 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 			      struct lpfc_iocbq *pIocbOut,
 			      struct lpfc_wcqe_complete *wcqe)
 {
+	int numBdes, i;
 	unsigned long iflags;
-	uint32_t status;
+	uint32_t status, max_response;
+	struct lpfc_dmabuf *dmabuf;
+	struct ulp_bde64 *bpl, bde;
 	size_t offset = offsetof(struct lpfc_iocbq, iocb);
 
 	memcpy((char *)pIocbIn + offset, (char *)pIocbOut + offset,
@@ -11213,7 +11218,36 @@ lpfc_sli4_iocb_param_transfer(struct lpf
 			pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
 	else {
 		pIocbIn->iocb.un.ulpWord[4] = wcqe->parameter;
-		pIocbIn->iocb.un.genreq64.bdl.bdeSize = wcqe->total_data_placed;
+		switch (pIocbOut->iocb.ulpCommand) {
+		case CMD_ELS_REQUEST64_CR:
+			dmabuf = (struct lpfc_dmabuf *)pIocbOut->context3;
+			bpl  = (struct ulp_bde64 *)dmabuf->virt;
+			bde.tus.w = le32_to_cpu(bpl[1].tus.w);
+			max_response = bde.tus.f.bdeSize;
+			break;
+		case CMD_GEN_REQUEST64_CR:
+			max_response = 0;
+			if (!pIocbOut->context3)
+				break;
+			numBdes = pIocbOut->iocb.un.genreq64.bdl.bdeSize/
+					sizeof(struct ulp_bde64);
+			dmabuf = (struct lpfc_dmabuf *)pIocbOut->context3;
+			bpl = (struct ulp_bde64 *)dmabuf->virt;
+			for (i = 0; i < numBdes; i++) {
+				bde.tus.w = le32_to_cpu(bpl[i].tus.w);
+				if (bde.tus.f.bdeFlags != BUFF_TYPE_BDE_64)
+					max_response += bde.tus.f.bdeSize;
+			}
+			break;
+		default:
+			max_response = wcqe->total_data_placed;
+			break;
+		}
+		if (max_response < wcqe->total_data_placed)
+			pIocbIn->iocb.un.genreq64.bdl.bdeSize = max_response;
+		else
+			pIocbIn->iocb.un.genreq64.bdl.bdeSize =
+				wcqe->total_data_placed;
 	}
 
 	/* Convert BG errors for completion status */



