From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH 4/13] scsi: arcmsr: replace constant ARCMSR_MAX_FREECCB_NUM
 by variable acb->maxFreeCCB that was got from firmware
Date: Thu, 09 Nov 2017 07:57:05 +0800
Message-ID: <1510185425.4523.70.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:48548 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753035AbdKIH5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 02:57:14 -0500
Received: by mail-io0-f180.google.com with SMTP id d66so8869619ioe.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 23:57:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de, hare@suse.de, dan.carpenter@oracle.com, hch@infradead.org

From: Ching Huang <ching2048@areca.com.tw>

replace constant ARCMSR_MAX_FREECCB_NUM by variable acb->maxFreeCCB that was got from firmware

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 11:19:22.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2017-08-04 17:07:52.000000000 +0800
@@ -836,6 +836,7 @@ struct AdapterControlBlock
 	atomic_t			ante_token_value;
 	uint32_t	maxOutstanding;
 	int		vector_count;
+	uint32_t		maxFreeCCB;
 	uint32_t		doneq_index;
 	uint32_t		ccbsize;
 	uint32_t		in_doorbell;
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:48:46.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2017-11-08 18:50:28.000000000 +0800
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
@@ -1431,7 +1431,7 @@ static void arcmsr_remove(struct pci_dev
 
 		arcmsr_abort_allcmd(acb);
 		arcmsr_done4abort_postqueue(acb);
-		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		for (i = 0; i < acb->maxFreeCCB; i++) {
 			struct CommandControlBlock *ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				ccb->startdone = ARCMSR_CCB_ABORTED;
@@ -3243,6 +3243,9 @@ static bool arcmsr_get_firmware_spec(str
 	else
 		acb->maxOutstanding = acb->firm_numbers_queue - 1;
 	acb->host->can_queue = acb->maxOutstanding;
+	acb->maxFreeCCB = acb->host->can_queue;
+	if (acb->maxFreeCCB < ARCMSR_MAX_FREECCB_NUM)
+		acb->maxFreeCCB += 64;
 	return rtn;
 }
 
@@ -4265,7 +4268,7 @@ static uint8_t arcmsr_iop_reset(struct A
 		rtnval = arcmsr_abort_allcmd(acb);
 		/* clear all outbound posted Q */
 		arcmsr_done4abort_postqueue(acb);
-		for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+		for (i = 0; i < acb->maxFreeCCB; i++) {
 			ccb = acb->pccb_pool[i];
 			if (ccb->startdone == ARCMSR_CCB_START) {
 				scsi_dma_unmap(ccb->pcmd);
@@ -4373,7 +4376,7 @@ static int arcmsr_abort(struct scsi_cmnd
 	}
 
 	intmask_org = arcmsr_disable_outbound_ints(acb);
-	for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+	for (i = 0; i < acb->maxFreeCCB; i++) {
 		struct CommandControlBlock *ccb = acb->pccb_pool[i];
 		if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
 			ccb->startdone = ARCMSR_CCB_ABORTED;
