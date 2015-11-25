From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 3/5] arcmsr: modifies codes for more readable
Date: Wed, 25 Nov 2015 19:45:16 +0800
Message-ID: <1448451916.4670.39.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Modifies codes for more readable

Signed-of-by: Ching Huang <ching2048@areca.com.tw>

---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 10:52:16.286470000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 19:10:21.309960000 +0800
@@ -288,6 +288,9 @@ struct FIRMWARE_INFO
 #define ARCMSR_MESSAGE_RBUFFER			      0x0000ff00
 /* iop message_rwbuffer for message command */
 #define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00
+
+#define MEM_BASE0(x)	(u32 __iomem *)((unsigned long)acb->mem_base0 + x)
+#define MEM_BASE1(x)	(u32 __iomem *)((unsigned long)acb->mem_base1 + x)
 /* 
 ************************************************************************
 **                SPEC. for Areca HBC adapter
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:04:44.590970000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:11:27.679958000 +0800
@@ -2649,13 +2649,13 @@ static bool arcmsr_hbaB_get_config(struc
 	acb->dma_coherent2 = dma_coherent;
 	reg = (struct MessageUnit_B *)dma_coherent;
 	acb->pmuB = reg;
-	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
-	reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
-	reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
-	reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
-	reg->message_wbuffer = (uint32_t __iomem *)((unsigned long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
-	reg->message_rbuffer =  (uint32_t __iomem *)((unsigned long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
-	reg->message_rwbuffer = (uint32_t __iomem *)((unsigned long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
+	reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
+	reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
+	reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
+	reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
+	reg->message_wbuffer = MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
+	reg->message_rbuffer =  MEM_BASE1(ARCMSR_MESSAGE_RBUFFER);
+	reg->message_rwbuffer = MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
 	iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);	/*firm_model,15,60-67*/
 	iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);	/*firm_version,17,68-83*/
 	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);	/*firm_version,21,84-99*/
