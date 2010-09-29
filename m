From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.17: BSG fixes
Date: Wed, 29 Sep 2010 11:19:00 -0400
Message-ID: <1285773540.25110.11.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16094 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386Ab0I2PTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 11:19:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add support for bsg MBX_SLI4_CONFIG.
- Multiply linkup timeout in loopback test code by 100.
- Set iocb_stat to 0 in the lpfcdiag_loop_get_xri function.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-09-29 10:07:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-09-29 10:20:01.000000000 -0400
@@ -1518,7 +1518,7 @@ lpfc_bsg_diag_mode(struct fc_bsg_job *jo
 	loopback_mode = (struct diag_mode_set *)
 		job->request->rqst_data.h_vendor.vendor_cmd;
 	link_flags = loopback_mode->type;
-	timeout = loopback_mode->timeout;
+	timeout = loopback_mode->timeout * 100;
 
 	if ((phba->link_state == LPFC_HBA_ERROR) ||
 	    (psli->sli_flag & LPFC_BLOCK_MGMT_IO) ||
@@ -1732,7 +1732,7 @@ static int lpfcdiag_loop_get_xri(struct 
 	struct lpfc_sli_ct_request *ctreq = NULL;
 	int ret_val = 0;
 	int time_left;
-	int iocb_stat;
+	int iocb_stat = 0;
 	unsigned long flags;
 
 	*txxri = 0;
@@ -2473,6 +2473,17 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 			to += sizeof(MAILBOX_t);
 			size = pmboxq->u.mb.un.varWords[5];
 			memcpy(to, from, size);
+		} else if ((phba->sli_rev == LPFC_SLI_REV4) &&
+			(pmboxq->u.mb.mbxCommand == MBX_SLI4_CONFIG)) {
+			struct lpfc_mbx_nembed_cmd *nembed_sge =
+				(struct lpfc_mbx_nembed_cmd *)
+				&pmboxq->u.mb.un.varWords[0];
+
+			from = (uint8_t *)dd_data->context_un.mbox.dmp->dma.
+						virt;
+			to += sizeof(MAILBOX_t);
+			size = nembed_sge->sge[0].length;
+			memcpy(to, from, size);
 		} else if (pmboxq->u.mb.mbxCommand == MBX_READ_EVENT_LOG) {
 			from = (uint8_t *)dd_data->context_un.
 						mbox.dmp->dma.virt;
@@ -2914,6 +2925,59 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 			from += sizeof(MAILBOX_t);
 			memcpy((uint8_t *)dmp->dma.virt, from,
 				bde->tus.f.bdeSize);
+		} else if (pmb->mbxCommand == MBX_SLI4_CONFIG) {
+			struct lpfc_mbx_nembed_cmd *nembed_sge;
+			struct mbox_header *header;
+			uint32_t receive_length;
+
+			/* rebuild the command for sli4 using our own buffers
+			* like we do for biu diags
+			*/
+			header = (struct mbox_header *)&pmb->un.varWords[0];
+			nembed_sge = (struct lpfc_mbx_nembed_cmd *)
+				&pmb->un.varWords[0];
+			receive_length = nembed_sge->sge[0].length;
+
+			/* receive length cannot be greater than mailbox
+			 * extension size
+			 */
+			if ((receive_length == 0) ||
+				(receive_length > MAILBOX_EXT_SIZE)) {
+				rc = -ERANGE;
+				goto job_done;
+			}
+
+			rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+			if (!rxbmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
+			if (!rxbmp->virt) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&rxbmp->list);
+			rxbpl = (struct ulp_bde64 *) rxbmp->virt;
+			dmp = diag_cmd_data_alloc(phba, rxbpl, receive_length,
+						0);
+			if (!dmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&dmp->dma.list);
+			nembed_sge->sge[0].pa_hi = putPaddrHigh(dmp->dma.phys);
+			nembed_sge->sge[0].pa_lo = putPaddrLow(dmp->dma.phys);
+			/* copy the transmit data found in the mailbox
+			 * extension area
+			 */
+			from = (uint8_t *)mb;
+			from += sizeof(MAILBOX_t);
+			memcpy((uint8_t *)dmp->dma.virt, from,
+				header->cfg_mhdr.payload_length);
 		}
 	}
 


