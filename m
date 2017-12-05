From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 7/17] scsi: arcmsr: replace constant
 ARCMSR_MAX_OUTSTANDING_CMD by variable acb->maxOutstanding that was
 determined by user
Date: Tue, 05 Dec 2017 09:51:27 +0800
Message-ID: <1512438687.4577.52.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

replace constant ARCMSR_MAX_OUTSTANDING_CMD by variable acb->maxOutstanding that was determined by user

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:46:50.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:46:30.000000000 +0800
@@ -1315,7 +1315,7 @@ static void arcmsr_done4abort_postqueue(
 		/*clear and abort all outbound posted Q*/
 		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
 		while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
-				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+				&& (i++ < acb->maxOutstanding)) {
 			pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
 			pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 			error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
@@ -1345,7 +1345,7 @@ static void arcmsr_done4abort_postqueue(
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C __iomem *reg = acb->pmuC;
-		while ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+		while ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < acb->maxOutstanding)) {
 			/*need to do*/
 			flag_ccb = readl(&reg->outbound_queueport_low);
 			ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
@@ -1421,7 +1421,7 @@ static void arcmsr_remove(struct pci_dev
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
 
-	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD; poll_count++){
+	for (poll_count = 0; poll_count < acb->maxOutstanding; poll_count++){
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
 		arcmsr_interrupt(acb);/* FIXME: need spinlock */
