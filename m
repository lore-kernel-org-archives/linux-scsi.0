From: ching <ching2048@areca.com.tw>
Subject: [PATCH v1.0 12/16] arcmsr: revise alloction of second
 dma_coherent_handle for type B adapter
Date: Wed, 30 Apr 2014 19:30:29 +0800
Message-ID: <1398857429.6930.51.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:40956 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbaD3Lag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2014 07:30:36 -0400
Received: by mail-vc0-f169.google.com with SMTP id im17so1959745vcb.14
        for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2014 04:30:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From: Ching<ching2048@areca.com.tw>

Revise allocation of second dma_coherent_handle for type_B adapter.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2014-04-29 12:38:44.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2014-04-29 15:50:42.000000000 +0800
@@ -507,6 +507,7 @@ struct AdapterControlBlock
 	#define ACB_ADAPTER_TYPE_B            0x00000002	/* hbb M IOP */
 	#define ACB_ADAPTER_TYPE_C            0x00000004	/* hbc P IOP */
 	#define ACB_ADAPTER_TYPE_D            0x00000008	/* hbd A IOP */
+	u32				roundup_ccbsize;
 	struct pci_dev *		pdev;
 	struct Scsi_Host *		host;
 	unsigned long			vir2phy_offset;
@@ -563,6 +564,7 @@ struct AdapterControlBlock
 	dma_addr_t			dma_coherent_handle;
 	/* dma_coherent_handle used for memory free */
 	dma_addr_t				dma_coherent_handle2;
+	void				*dma_coherent2;
 	unsigned int				uncache_size;
 	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
 	/* data collection buffer for read from 80331 */
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:13:36.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:13:48.000000000 +0800
@@ -183,13 +183,10 @@ static struct pci_driver arcmsr_pci_driv
 static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
-	case ACB_ADAPTER_TYPE_A:
-	case ACB_ADAPTER_TYPE_C:
-		break;
 	case ACB_ADAPTER_TYPE_B:{
-		dma_free_coherent(&acb->pdev->dev,
-			sizeof(struct MessageUnit_B),
-			acb->pmuB, acb->dma_coherent_handle2);
+		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+			acb->dma_coherent2, acb->dma_coherent_handle2);
+		break;
 	}
 	}
 }
@@ -2300,12 +2297,15 @@ static bool arcmsr_hbaB_get_config(struc
 	char __iomem *iop_device_map;
 	/*firm_version,21,84-99*/
 	int count;
-	dma_coherent = dma_alloc_coherent(&pdev->dev, sizeof(struct MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);
+
+	acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_B), 32);
+	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize, &dma_coherent_handle, GFP_KERNEL);
 	if (!dma_coherent){
 		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb mu\n", acb->host->host_no);
 		return false;
 	}
 	acb->dma_coherent_handle2 = dma_coherent_handle;
+	acb->dma_coherent2 = dma_coherent;
 	reg = (struct MessageUnit_B *)dma_coherent;
 	acb->pmuB = reg;
 	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
@@ -2651,6 +2651,7 @@ static int arcmsr_polling_ccbdone(struct
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
 	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
+	dma_addr_t dma_coherent_handle;
 
 	/*
 	********************************************************************
@@ -2658,8 +2659,16 @@ static int arcmsr_iop_confirm(struct Ada
 	** if freeccb.HighPart is not zero
 	********************************************************************
 	*/
-	cdb_phyaddr = lower_32_bits(acb->dma_coherent_handle);
-	cdb_phyaddr_hi32 = upper_32_bits(acb->dma_coherent_handle);
+	switch (acb->adapter_type) {
+		case ACB_ADAPTER_TYPE_B:
+			dma_coherent_handle = acb->dma_coherent_handle2;
+			break;
+		default:
+			dma_coherent_handle = acb->dma_coherent_handle;
+			break;
+	}
+	cdb_phyaddr = lower_32_bits(dma_coherent_handle);
+	cdb_phyaddr_hi32 = upper_32_bits(dma_coherent_handle);
 	acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
 	/*
 	***********************************************************************
@@ -2687,7 +2696,6 @@ static int arcmsr_iop_confirm(struct Ada
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		unsigned long post_queue_phyaddr;
 		uint32_t __iomem *rwbuffer;
 
 		struct MessageUnit_B *reg = acb->pmuB;
@@ -2699,16 +2707,15 @@ static int arcmsr_iop_confirm(struct Ada
 				acb->host->host_no);
 			return 1;
 		}
-		post_queue_phyaddr = acb->dma_coherent_handle2;
 		rwbuffer = reg->message_rwbuffer;
 		/* driver "set config" signature */
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
 		/* normal should be zero */
 		writel(cdb_phyaddr_hi32, rwbuffer++);
 		/* postQ size (256 + 8)*4	 */
-		writel(post_queue_phyaddr, rwbuffer++);
+		writel(cdb_phyaddr, rwbuffer++);
 		/* doneQ size (256 + 8)*4	 */
-		writel(post_queue_phyaddr + 1056, rwbuffer++);
+		writel(cdb_phyaddr + 1056, rwbuffer++);
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/
 		writel(1056, rwbuffer);
 


