From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 2/2 REPOST] arcmsr: code cleanup and some corrections
Date: Fri, 29 Apr 2011 16:28:30 +0200
Message-ID: <4DBACB0E.5040607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab1D2O2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2011 10:28:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nick.cheng@areca.com.tw, James.Bottomley@HansenPartnership.com

This is a repost - the original mail was ack-ed by Nick Cheng - http://www.spinics.net/lists/linux-scsi/msg50594.html


Hi Nick,
I'm confused with what this code does, I think I must miss something.

	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
...
I think that the dma_alloc_coherent returns a page address with zeroes in the lowest bits 
That would mean the offset computed below is useless as the result is zero every time.
Added to that is that you then increase dma_coherent_handle by the offset,
while dma_coherent is increased by multiples of sizeof CommandControlBlock, at least it looks so
...
	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned long)dma_coherent;
	dma_coherent_handle = dma_coherent_handle + offset;
	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;

The patch below removes the offset computation.

Signed-off-by: Tomas henzl <thenzl@redhat.com>
Acked-by: Nick Cheng<nick.cheng@areca.com.tw>


diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4cd522b..da93974 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -441,10 +441,11 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	struct CommandControlBlock *ccb_tmp;
 	int i = 0, j = 0;
 	dma_addr_t cdb_phyaddr;
-	unsigned long roundup_ccbsize = 0, offset;
+	unsigned long roundup_ccbsize;
 	unsigned long max_xfer_len;
 	unsigned long max_sg_entrys;
 	uint32_t  firm_config_version;
+
 	for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
 		for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
 			acb->devstate[i][j] = ARECA_RAID_GONE;
@@ -454,12 +455,12 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	firm_config_version = acb->firm_cfg_version;
 	if((firm_config_version & 0xFF) >= 3){
 		max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version >> 8) & 0xFF)) * 1024;/* max 4M byte */
-		max_sg_entrys = (max_xfer_len/4096);	
+		max_sg_entrys = (max_xfer_len/4096);
 	}
 	acb->host->max_sectors = max_xfer_len/512;
 	acb->host->sg_tablesize = max_sg_entrys;
 	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) + (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM + 32;
+	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
 	if(!dma_coherent){
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error \n", acb->host->host_no);
@@ -468,9 +469,6 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 	acb->dma_coherent = dma_coherent;
 	acb->dma_coherent_handle = dma_coherent_handle;
 	memset(dma_coherent, 0, acb->uncache_size);
-	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned long)dma_coherent;
-	dma_coherent_handle = dma_coherent_handle + offset;
-	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;
 	ccb_tmp = dma_coherent;
 	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned long)dma_coherent_handle;
 	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


