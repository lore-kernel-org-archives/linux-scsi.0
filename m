From: "NickCheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH 2/2] arcmsr: code cleanup and some corrections
Date: Fri, 11 Feb 2011 09:44:07 +0800
Message-ID: <6BCF37FA033449599C8CB43E2D84A0B6@arecaaebe11fae>
References: <4D53F4B7.2030806@redhat.com> <4D53F7EF.70003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63732 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab1BKBpq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2011 20:45:46 -0500
Received: by vxb37 with SMTP id 37so1077003vxb.19
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2011 17:45:45 -0800 (PST)
In-Reply-To: <4D53F7EF.70003@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Tomas Henzl' <thenzl@redhat.com>, linux-scsi@vger.kernel.org

Hi Tomas,
As you said, the dma_alloc_coherent should return a page address with zeroes
in the lowest bits, but I have 100% confidence in that.
Therefore, I try to round it up if not. Otherwise, it will lead the
controller panic.
The code over there is just in case.

-----Original Message-----
From: Tomas Henzl [mailto:thenzl@redhat.com] 
Sent: Thursday, February 10, 2011 10:37 PM
To: 'linux-scsi@vger.kernel.org'
Cc: nick.cheng@areca.com.tw
Subject: [PATCH 2/2] arcmsr: code cleanup and some corrections

Hi Nick,
I'm confused with what this code does, I think I must miss something.

	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
&dma_coherent_handle, GFP_KERNEL);
...
I think that the dma_alloc_coherent returns a page address with zeroes in
the lowest bits 
That would mean the offset computed below is useless as the result is zero
every time.
Added to that is that you then increase dma_coherent_handle by the offset,
while dma_coherent is increased by multiples of sizeof CommandControlBlock,
at least it looks so
...
	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned
long)dma_coherent;
	dma_coherent_handle = dma_coherent_handle + offset;
	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;

The patch below removes the offset computation.

Signed-off-by: Tomas henzl <thenzl@redhat.com>


diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c
b/drivers/scsi/arcmsr/arcmsr_hba.c
index 4cd522b..da93974 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -441,10 +441,11 @@ static int arcmsr_alloc_ccb_pool(struct
AdapterControlBlock *acb)
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
@@ -454,12 +455,12 @@ static int arcmsr_alloc_ccb_pool(struct
AdapterControlBlock *acb)
 	firm_config_version = acb->firm_cfg_version;
 	if((firm_config_version & 0xFF) >= 3){
 		max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 4M byte */
-		max_sg_entrys = (max_xfer_len/4096);	
+		max_sg_entrys = (max_xfer_len/4096);
 	}
 	acb->host->max_sectors = max_xfer_len/512;
 	acb->host->sg_tablesize = max_sg_entrys;
 	roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
-	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM + 32;
+	acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
&dma_coherent_handle, GFP_KERNEL);
 	if(!dma_coherent){
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error
\n", acb->host->host_no);
@@ -468,9 +469,6 @@ static int arcmsr_alloc_ccb_pool(struct
AdapterControlBlock *acb)
 	acb->dma_coherent = dma_coherent;
 	acb->dma_coherent_handle = dma_coherent_handle;
 	memset(dma_coherent, 0, acb->uncache_size);
-	offset = roundup((unsigned long)dma_coherent, 32) - (unsigned
long)dma_coherent;
-	dma_coherent_handle = dma_coherent_handle + offset;
-	dma_coherent = (struct CommandControlBlock *)dma_coherent + offset;
 	ccb_tmp = dma_coherent;
 	acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
long)dma_coherent_handle;
 	for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){


