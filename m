From: Al Viro <viro@ftp.linux.org.uk>
Subject: trivial annotations in arcmsr
Date: Mon, 29 Oct 2007 05:08:28 +0000
Message-ID: <E1ImMrU-0003S9-PC@ZenIV.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXJ2FIc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 01:08:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: nick.cheng@areca.com.tw, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


driver still has serious portability problems

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/arcmsr/arcmsr.h      |   32 ++++---
 drivers/scsi/arcmsr/arcmsr_attr.c |    6 +-
 drivers/scsi/arcmsr/arcmsr_hba.c  |  170 ++++++++++++++++++-------------------
 3 files changed, 103 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
index ace7a15..3c38cd8 100644
--- a/drivers/scsi/arcmsr/arcmsr.h
+++ b/drivers/scsi/arcmsr/arcmsr.h
@@ -141,14 +141,14 @@ struct CMD_MESSAGE_FIELD
 #define IS_SG64_ADDR                0x01000000 /* bit24 */
 struct  SG32ENTRY
 {
-	uint32_t					length;
-	uint32_t					address;
+	__le32					length;
+	__le32					address;
 };
 struct  SG64ENTRY
 {
- 	uint32_t					length;
- 	uint32_t					address;
- 	uint32_t					addresshigh;
+	__le32					length;
+	__le32					address;
+	__le32					addresshigh;
 };
 struct SGENTRY_UNION
 {
@@ -339,13 +339,13 @@ struct MessageUnit_B
 	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
 	uint32_t	postq_index;
 	uint32_t	doneq_index;
-	uint32_t	*drv2iop_doorbell_reg;
-	uint32_t	*drv2iop_doorbell_mask_reg;
-	uint32_t	*iop2drv_doorbell_reg;
-	uint32_t	*iop2drv_doorbell_mask_reg;
-	uint32_t	*msgcode_rwbuffer_reg;
-	uint32_t	*ioctl_wbuffer_reg;
-	uint32_t	*ioctl_rbuffer_reg;
+	uint32_t	__iomem *drv2iop_doorbell_reg;
+	uint32_t	__iomem *drv2iop_doorbell_mask_reg;
+	uint32_t	__iomem *iop2drv_doorbell_reg;
+	uint32_t	__iomem *iop2drv_doorbell_mask_reg;
+	uint32_t	__iomem *msgcode_rwbuffer_reg;
+	uint32_t	__iomem *ioctl_wbuffer_reg;
+	uint32_t	__iomem *ioctl_rbuffer_reg;
 };
 
 struct MessageUnit
@@ -374,7 +374,11 @@ struct AdapterControlBlock
 	/* Offset is used in making arc cdb physical to virtual calculations */
 	uint32_t			outbound_int_enable;
 
-	struct MessageUnit *			pmu;
+	union {
+		struct MessageUnit *		pmu;
+		struct MessageUnit_A __iomem *	pmuA;
+		struct MessageUnit_B *		pmuB;
+	};
 	/* message unit ATU inbound base address0 */
 
 	uint32_t			acb_flags;
@@ -558,7 +562,7 @@ struct SENSE_DATA
 
 extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);
 extern void arcmsr_iop_message_read(struct AdapterControlBlock *);
-extern struct QBUFFER *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
+extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
 extern struct class_device_attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index d04d1aa..7d7b0a5 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -85,13 +85,13 @@ static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj,
 		allxfer_len++;
 	}
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-		struct QBUFFER *prbuffer;
-		uint8_t *iop_data;
+		struct QBUFFER __iomem *prbuffer;
+		uint8_t __iomem *iop_data;
 		int32_t iop_len;
 
 		acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
 		prbuffer = arcmsr_get_iop_rqbuffer(acb);
-		iop_data = (uint8_t *)prbuffer->data;
+		iop_data = prbuffer->data;
 		iop_len = readl(&prbuffer->data_len);
 		while (iop_len > 0) {
 			acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f7a2528..aaee028 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -236,8 +236,8 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		uint32_t intmask_org;
 		int i, j;
 
-		acb->pmu = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
-		if (!acb->pmu) {
+		acb->pmuA = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+		if (!acb->pmuA) {
 			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
 							acb->host->host_no);
 		}
@@ -287,7 +287,7 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 
 		struct pci_dev *pdev = acb->pdev;
 		struct MessageUnit_B *reg;
-		void *mem_base0, *mem_base1;
+		void __iomem *mem_base0, *mem_base1;
 		void *dma_coherent;
 		dma_addr_t dma_coherent_handle, dma_addr;
 		uint32_t intmask_org;
@@ -328,25 +328,20 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 
 		reg = (struct MessageUnit_B *)(dma_coherent +
 		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));
-		acb->pmu = (struct MessageUnit *)reg;
+		acb->pmuB = reg;
 		mem_base0 = ioremap(pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0));
 		mem_base1 = ioremap(pci_resource_start(pdev, 2),
 					pci_resource_len(pdev, 2));
-		reg->drv2iop_doorbell_reg = (uint32_t *)((char *)mem_base0 +
-						ARCMSR_DRV2IOP_DOORBELL);
-		reg->drv2iop_doorbell_mask_reg = (uint32_t *)((char *)mem_base0 +
-						ARCMSR_DRV2IOP_DOORBELL_MASK);
-		reg->iop2drv_doorbell_reg = (uint32_t *)((char *)mem_base0 +
-							ARCMSR_IOP2DRV_DOORBELL);
-		reg->iop2drv_doorbell_mask_reg = (uint32_t *)((char *)mem_base0 +
-						ARCMSR_IOP2DRV_DOORBELL_MASK);
-		reg->ioctl_wbuffer_reg = (uint32_t *)((char *)mem_base1 +
-							ARCMSR_IOCTL_WBUFFER);
-		reg->ioctl_rbuffer_reg = (uint32_t *)((char *)mem_base1 +
-							ARCMSR_IOCTL_RBUFFER);
-		reg->msgcode_rwbuffer_reg = (uint32_t *)((char *)mem_base1 +
-							ARCMSR_MSGCODE_RWBUFFER);
+		reg->drv2iop_doorbell_reg = mem_base0 + ARCMSR_DRV2IOP_DOORBELL;
+		reg->drv2iop_doorbell_mask_reg = mem_base0 +
+						ARCMSR_DRV2IOP_DOORBELL_MASK;
+		reg->iop2drv_doorbell_reg = mem_base0 + ARCMSR_IOP2DRV_DOORBELL;
+		reg->iop2drv_doorbell_mask_reg = mem_base0 +
+						ARCMSR_IOP2DRV_DOORBELL_MASK;
+		reg->ioctl_wbuffer_reg = mem_base1 + ARCMSR_IOCTL_WBUFFER;
+		reg->ioctl_rbuffer_reg = mem_base1 + ARCMSR_IOCTL_RBUFFER;
+		reg->msgcode_rwbuffer_reg = mem_base1 + ARCMSR_MSGCODE_RWBUFFER;
 
 		acb->vir2phy_offset = (unsigned long)ccb_tmp -(unsigned long)dma_addr;
 		for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
@@ -467,7 +462,7 @@ static int arcmsr_probe(struct pci_dev *pdev,
 
 static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	uint32_t Index;
 	uint8_t Retries = 0x00;
 
@@ -488,7 +483,7 @@ static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
 
 static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 	uint32_t Index;
 	uint8_t Retries = 0x00;
 
@@ -509,7 +504,7 @@ static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
 
 static void arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb))
@@ -520,7 +515,7 @@ static void arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
 
 static void arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 
 	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb))
@@ -566,7 +561,7 @@ static void arcmsr_ccb_complete(struct CommandControlBlock *ccb, int stand_flag)
 
 static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	int retry_count = 30;
 
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
@@ -583,7 +578,7 @@ static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
 
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 	int retry_count = 30;
 
 	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell_reg);
@@ -637,7 +632,7 @@ static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A : {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		orig_mask = readl(&reg->outbound_intmask)|\
 				ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE;
 		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
@@ -646,7 +641,7 @@ static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
 		break;
 
 	case ACB_ADAPTER_TYPE_B : {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		orig_mask = readl(reg->iop2drv_doorbell_mask_reg) & \
 					(~ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
 		writel(0, reg->iop2drv_doorbell_mask_reg);
@@ -748,14 +743,13 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A __iomem *reg = \
-			(struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		uint32_t outbound_intstatus;
-		outbound_intstatus = readl(&reg->outbound_intstatus) & \
+		outbound_intstatus = readl(&reg->outbound_intstatus) &
 					acb->outbound_int_enable;
 		/*clear and abort all outbound posted Q*/
 		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
-		while (((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) \
+		while (((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
 				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
 			arcmsr_drain_donequeue(acb, flag_ccb);
 		}
@@ -763,7 +757,7 @@ static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		/*clear all outbound posted Q*/
 		for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
 			if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
@@ -859,7 +853,7 @@ static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb, \
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A : {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		mask = intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
 			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE);
 		writel(mask, &reg->outbound_intmask);
@@ -868,7 +862,7 @@ static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb, \
 		break;
 
 	case ACB_ADAPTER_TYPE_B : {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK | \
 			ARCMSR_IOP2DRV_DATA_READ_OK | ARCMSR_IOP2DRV_CDB_DONE);
 		writel(mask, reg->iop2drv_doorbell_mask_reg);
@@ -882,7 +876,7 @@ static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
 {
 	struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
 	int8_t *psge = (int8_t *)&arcmsr_cdb->u;
-	uint32_t address_lo, address_hi;
+	__le32 address_lo, address_hi;
 	int arccdbsize = 0x30;
 	int nseg;
 
@@ -900,7 +894,8 @@ static void arcmsr_build_ccb(struct AdapterControlBlock *acb,
 	BUG_ON(nseg < 0);
 
 	if (nseg) {
-		int length, i, cdb_sgcount = 0;
+		__le32 length;
+		int i, cdb_sgcount = 0;
 		struct scatterlist *sg;
 
 		/* map stor port SG list to our iop SG List. */
@@ -947,7 +942,7 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
 			writel(cdb_shifted_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
@@ -959,7 +954,7 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		uint32_t ending_index, index = reg->postq_index;
 
 		ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
@@ -982,7 +977,7 @@ static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct CommandContr
 
 static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
 
@@ -995,7 +990,7 @@ static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
 
 static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell_reg);
 
@@ -1033,13 +1028,13 @@ void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);
 		}
 		break;
@@ -1050,7 +1045,7 @@ static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		/*
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
@@ -1060,7 +1055,7 @@ static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		/*
 		** push inbound doorbell tell iop, driver data write ok
 		** and wait reply on next hwinterrupt for next Qbuffer post
@@ -1071,41 +1066,41 @@ static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 	}
 }
 
-struct QBUFFER *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
+struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 {
-	static struct QBUFFER *qbuffer;
+	static struct QBUFFER __iomem *qbuffer;
 
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
-		qbuffer = (struct QBUFFER __iomem *) &reg->message_rbuffer;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
+		qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
-		qbuffer = (struct QBUFFER __iomem *) reg->ioctl_rbuffer_reg;
+		struct MessageUnit_B *reg = acb->pmuB;
+		qbuffer = (struct QBUFFER __iomem *)reg->ioctl_rbuffer_reg;
 		}
 		break;
 	}
 	return qbuffer;
 }
 
-static struct QBUFFER *arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
+static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
 {
-	static struct QBUFFER *pqbuffer;
+	static struct QBUFFER __iomem *pqbuffer;
 
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
-		pqbuffer = (struct QBUFFER *) &reg->message_wbuffer;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
+		pqbuffer = (struct QBUFFER __iomem *) &reg->message_wbuffer;
 		}
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B  *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B  *reg = acb->pmuB;
 		pqbuffer = (struct QBUFFER __iomem *)reg->ioctl_wbuffer_reg;
 		}
 		break;
@@ -1115,15 +1110,15 @@ static struct QBUFFER *arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
 
 static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
 {
-	struct QBUFFER *prbuffer;
+	struct QBUFFER __iomem *prbuffer;
 	struct QBUFFER *pQbuffer;
-	uint8_t *iop_data;
+	uint8_t __iomem *iop_data;
 	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
 
 	rqbuf_lastindex = acb->rqbuf_lastindex;
 	rqbuf_firstindex = acb->rqbuf_firstindex;
 	prbuffer = arcmsr_get_iop_rqbuffer(acb);
-	iop_data = (uint8_t *)prbuffer->data;
+	iop_data = (uint8_t __iomem *)prbuffer->data;
 	iop_len = prbuffer->data_len;
 	my_empty_len = (rqbuf_firstindex - rqbuf_lastindex -1)&(ARCMSR_MAX_QBUFFER -1);
 
@@ -1151,8 +1146,8 @@ static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
 	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
 	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
 		uint8_t *pQbuffer;
-		struct QBUFFER *pwbuffer;
-		uint8_t *iop_data;
+		struct QBUFFER __iomem *pwbuffer;
+		uint8_t __iomem *iop_data;
 		int32_t allxfer_len = 0;
 
 		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
@@ -1181,7 +1176,7 @@ static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
 static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 	outbound_doorbell = readl(&reg->outbound_doorbell);
 	writel(outbound_doorbell, &reg->outbound_doorbell);
@@ -1197,7 +1192,7 @@ static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
 static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t flag_ccb;
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 	while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
 		arcmsr_drain_donequeue(acb, flag_ccb);
@@ -1208,7 +1203,7 @@ static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t index;
 	uint32_t flag_ccb;
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 
 	index = reg->doneq_index;
 
@@ -1224,7 +1219,7 @@ static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
 static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_intstatus;
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 
 	outbound_intstatus = readl(&reg->outbound_intstatus) & \
 							acb->outbound_int_enable;
@@ -1244,7 +1239,7 @@ static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
 static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)
 {
 	uint32_t outbound_doorbell;
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 
 	outbound_doorbell = readl(reg->iop2drv_doorbell_reg) & \
 							acb->outbound_int_enable;
@@ -1305,8 +1300,8 @@ void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
 {
 	int32_t wqbuf_firstindex, wqbuf_lastindex;
 	uint8_t *pQbuffer;
-	struct QBUFFER *pwbuffer;
-	uint8_t *iop_data;
+	struct QBUFFER __iomem *pwbuffer;
+	uint8_t __iomem *iop_data;
 	int32_t allxfer_len = 0;
 
 	pwbuffer = arcmsr_get_iop_wqbuffer(acb);
@@ -1380,13 +1375,13 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 		}
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
 
-			struct QBUFFER *prbuffer;
-			uint8_t *iop_data;
+			struct QBUFFER __iomem *prbuffer;
+			uint8_t __iomem *iop_data;
 			int32_t iop_len;
 
 			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
 			prbuffer = arcmsr_get_iop_rqbuffer(acb);
-			iop_data = (uint8_t *)prbuffer->data;
+			iop_data = prbuffer->data;
 			iop_len = readl(&prbuffer->data_len);
 			while (iop_len > 0) {
 				acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
@@ -1669,11 +1664,11 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
 
 static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
-	char *iop_firm_model = (char *) (&reg->message_rwbuffer[15]);
-	char *iop_firm_version = (char *) (&reg->message_rwbuffer[17]);
+	char __iomem *iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
+	char __iomem *iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
 	int count;
 
 	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
@@ -1710,13 +1705,13 @@ static void arcmsr_get_hba_config(struct AdapterControlBlock *acb)
 
 static void arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
-	uint32_t *lrwbuffer = reg->msgcode_rwbuffer_reg;
+	struct MessageUnit_B *reg = acb->pmuB;
+	uint32_t __iomem *lrwbuffer = reg->msgcode_rwbuffer_reg;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
-	char *iop_firm_model = (char *) (&lrwbuffer[15]);
+	char __iomem *iop_firm_model = (char __iomem *)(&lrwbuffer[15]);
 	/*firm_model,15,60-67*/
-	char *iop_firm_version = (char *) (&lrwbuffer[17]);
+	char __iomem *iop_firm_version = (char __iomem *)(&lrwbuffer[17]);
 	/*firm_version,17,68-83*/
 	int count;
 
@@ -1777,7 +1772,7 @@ static void arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 	struct CommandControlBlock *poll_ccb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	struct CommandControlBlock *ccb;
 	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;
 
@@ -1826,7 +1821,7 @@ static void arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
 static void arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb, \
 					struct CommandControlBlock *poll_ccb)
 {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		struct CommandControlBlock *ccb;
 		uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
 		int index;
@@ -1918,8 +1913,7 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 
 	case ACB_ADAPTER_TYPE_A: {
 		if (ccb_phyaddr_hi32 != 0) {
-			struct MessageUnit_A __iomem *reg = \
-					(struct MessageUnit_A *)acb->pmu;
+			struct MessageUnit_A __iomem *reg = acb->pmuA;
 			uint32_t intmask_org;
 			intmask_org = arcmsr_disable_outbound_ints(acb);
 			writel(ARCMSR_SIGNATURE_SET_CONFIG, \
@@ -1940,9 +1934,9 @@ static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 
 	case ACB_ADAPTER_TYPE_B: {
 		unsigned long post_queue_phyaddr;
-		uint32_t *rwbuffer;
+		uint32_t __iomem *rwbuffer;
 
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		uint32_t intmask_org;
 		intmask_org = arcmsr_disable_outbound_ints(acb);
 		reg->postq_index = 0;
@@ -1994,7 +1988,7 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 	switch (acb->adapter_type) {
 
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		do {
 			firmware_state = readl(&reg->outbound_msgaddr1);
 		} while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
@@ -2002,7 +1996,7 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		do {
 			firmware_state = readl(reg->iop2drv_doorbell_reg);
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);
@@ -2013,7 +2007,7 @@ static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 
 static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_A __iomem *reg = (struct MessageUnit_A *)acb->pmu;
+	struct MessageUnit_A __iomem *reg = acb->pmuA;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
 	if (arcmsr_hba_wait_msgint_ready(acb)) {
@@ -2024,7 +2018,7 @@ static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
 
 static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+	struct MessageUnit_B *reg = acb->pmuB;
 	acb->acb_flags |= ACB_F_MSG_START_BGRB;
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell_reg);
 	if (arcmsr_hbb_wait_msgint_ready(acb)) {
@@ -2049,7 +2043,7 @@ static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
 {
 	switch (acb->adapter_type) {
 	case ACB_ADAPTER_TYPE_A: {
-		struct MessageUnit_A *reg = (struct MessageUnit_A *)acb->pmu;
+		struct MessageUnit_A __iomem *reg = acb->pmuA;
 		uint32_t outbound_doorbell;
 		/* empty doorbell Qbuffer if door bell ringed */
 		outbound_doorbell = readl(&reg->outbound_doorbell);
@@ -2060,7 +2054,7 @@ static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
 		break;
 
 	case ACB_ADAPTER_TYPE_B: {
-		struct MessageUnit_B *reg = (struct MessageUnit_B *)acb->pmu;
+		struct MessageUnit_B *reg = acb->pmuB;
 		/*clear interrupt and message state*/
 		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell_reg);
 		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell_reg);
-- 
1.5.3.GIT


