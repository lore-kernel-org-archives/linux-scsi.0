From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 5/17] scsi: arcmsr: replace constant ARCMSR_MAX_FREECCB_NUM
 by variable
Date: Tue, 05 Dec 2017 09:44:23 +0800
Message-ID: <1512438263.4577.45.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, sfr@canb.auug.org.au
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

replace constant ARCMSR_MAX_FREECCB_NUM by variable acb->maxFreeCCB that was got from firmware

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:24:16.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-12-05 15:25:06.000000000 +0800
@@ -831,6 +831,7 @@ struct AdapterControlBlock
 	atomic_t			ante_token_value;
 	uint32_t	maxOutstanding;
 	int		vector_count;
+	uint32_t		maxFreeCCB;
 	uint32_t		doneq_index;
 	uint32_t		ccbsize;
 	uint32_t		in_doorbell;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:47:16.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-12-05 11:47:04.000000000 +0800
@@ -688,7 +688,7 @@ static int arcmsr_alloc_ccb_pool(struct 
 	acb->host->max_sectors = max_xfer_len/512;
 	acb->host->sg_tablesize = max_sg_entrys;
 	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) + (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
+	acb->uncache_size = roundup_ccbsize * acb->maxFreeCCB;
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
 	if(!dma_coherent){
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n", acb->host->host_no);
@@ -700,7 +700,7 @@ static int arcmsr_alloc_ccb_pool(struct 
 	acb->ccbsize = roundup_ccbsize;
 	ccb_tmp = dma_coherent;
 	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned long)dma_coherent_handle;
-	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
+	for(i = 0; i < acb->maxFreeCCB; i++){
 		cdb_phyaddr = dma_coherent_handle + offsetof(struct CommandControlBlock, arcmsr_cdb);
 		switch (acb->adapter_type) {
 		case ACB_ADAPTER_TYPE_A:
@@ -1427,7 +1427,7 @@ static void arcmsr_remove(struct pci_dev
 
 		arcmsr_abort_allcmd(acb);
 		arcmsr_done4abort_postqueue(acb);
-		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		for (i = 0; i < acb->maxFreeCCB; i++) {
 			struct CommandControlBlock *ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				ccb->startdone = ARCMSR_CCB_ABORTED;
@@ -3239,6 +3239,9 @@ static bool arcmsr_get_firmware_spec(str
 	else
 		acb->maxOutstanding = acb->firm_numbers_queue - 1;
 	acb->host->can_queue = acb->maxOutstanding;
+	acb->maxFreeCCB = acb->host->can_queue;
+	if (acb->maxFreeCCB < ARCMSR_MAX_FREECCB_NUM)
+		acb->maxFreeCCB += 64;
 	return rtn;
 }
 
@@ -4261,7 +4264,7 @@ static uint8_t arcmsr_iop_reset(struct A
 		rtnval = arcmsr_abort_allcmd(acb);
 		/* clear all outbound posted Q */
 		arcmsr_done4abort_postqueue(acb);
-		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		for (i = 0; i < acb->maxFreeCCB; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				scsi_dma_unmap(ccb->pcmd);
@@ -4369,7 +4372,7 @@ static int arcmsr_abort(struct scsi_cmnd
 	}
 
 	intmask_org = arcmsr_disable_outbound_ints(acb);
-	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+	for (i = 0; i < acb->maxFreeCCB; i++) {
 		struct CommandControlBlock *ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
 			ccb->startdone = ARCMSR_CCB_ABORTED;
