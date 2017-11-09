From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 6/13] scsi: arcmsr: replace constant
 ARCMSR_MAX_OUTSTANDING_CMD by variable acb->maxOutstanding that was
 determined by user
Date: Thu, 09 Nov 2017 08:05:57 +0800
Message-ID: <1510185957.4523.77.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:55085 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdKIIGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 03:06:05 -0500
Received: by mail-it0-f46.google.com with SMTP id 72so9713037itk.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 00:06:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

replace constant ARCMSR_MAX_OUTSTANDING_CMD by variable acb->maxOutstanding that was determined by user

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:51:20.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:52:04.000000000 +0800
@@ -1319,7 +1319,7 @@ static void arcmsr_done4abort_postqueue(
 		/*clear and abort all outbound posted Q*/
 		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
 		while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
-				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+				&& (i++ < acb->maxOutstanding)) {
 			pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
 			pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
 			error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
@@ -1349,7 +1349,7 @@ static void arcmsr_done4abort_postqueue(
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C __iomem *reg = acb->pmuC;
-		while ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+		while ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < acb->maxOutstanding)) {
 			/*need to do*/
 			flag_ccb = readl(&reg->outbound_queueport_low);
 			ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
@@ -1425,7 +1425,7 @@ static void arcmsr_remove(struct pci_dev
 	acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
 	acb->acb_flags &= ~ACB_F_IOP_INITED;
 
-	for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD; poll_count++){
+	for (poll_count = 0; poll_count < acb->maxOutstanding; poll_count++){
 		if (!atomic_read(&acb->ccboutstandingcount))
 			break;
 		arcmsr_interrupt(acb);/* FIXME: need spinlock */
