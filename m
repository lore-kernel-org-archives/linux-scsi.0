From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/3] arcmsr: Split dma resource allocation to a new
 function
Date: Fri, 27 Nov 2015 10:58:48 +0800
Message-ID: <1448593128.4834.5.camel@Centos6.3-64>
References: <1448538075.10768.47.camel@Centos6.3-64>
	 <1448567174.18647.19.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35761 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbbK0C6x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2015 21:58:53 -0500
Received: by pacej9 with SMTP id ej9so100701839pac.2
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2015 18:58:52 -0800 (PST)
In-Reply-To: <1448567174.18647.19.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, jthumshirn@suse.de, hch@lst.de

On Thu, 2015-11-26 at 11:46 -0800, Joe Perches wrote:
> On Thu, 2015-11-26 at 19:41 +0800, Ching Huang wrote:
> > split dma resource allocation and io register assignment from get_config to a new function arcmsr_alloc_io_queue.
> 
> trivia:
> 
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> []
> > +static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
> > +{
> []
> > +		dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
> > +			&dma_coherent_handle, GFP_KERNEL);
> > +		if (!dma_coherent){
> > +			pr_notice("arcmsr%d: DMA allocation failed.\n", acb->host->host_no);
> > +			return false;
> > +		}
> > +		memset(dma_coherent, 0, acb->roundup_ccbsize);
> > 
> 
> There is a dma_zalloc_coherent
> 
> (and even more trivially)
> 
> Most all of your error messages don't use periods.
Thanks Joe.
Revised as below.

Signed-of-by: Ching Huang <ching2048@areca.com.tw>

---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-26 15:52:54.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-27 10:30:09.299131000 +0800
@@ -498,6 +498,90 @@ static void arcmsr_flush_adapter_cache(s
 	}
 }
 
+static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
+{
+	bool rtn = true;
+	void *dma_coherent;
+	dma_addr_t dma_coherent_handle;
+	struct pci_dev *pdev = acb->pdev;
+
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_B: {
+		struct MessageUnit_B *reg;
+		acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_B), 32);
+		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+			&dma_coherent_handle, GFP_KERNEL);
+		if (!dma_coherent){
+			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+			return false;
+		}
+		acb->dma_coherent_handle2 = dma_coherent_handle;
+		acb->dma_coherent2 = dma_coherent;
+		reg = (struct MessageUnit_B *)dma_coherent;
+		acb->pmuB = reg;
+		if (acb->pdev->device == PCI_DEVICE_ID_ARECA_1203) {
+			reg->drv2iop_doorbell = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
+			reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
+			reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
+			reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
+		} else {
+			reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
+			reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
+			reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
+			reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
+		}
+		reg->message_wbuffer = MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
+		reg->message_rbuffer =  MEM_BASE1(ARCMSR_MESSAGE_RBUFFER);
+		reg->message_rwbuffer = MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
+		}
+		break;
+	case ACB_ADAPTER_TYPE_D: {
+		struct MessageUnit_D *reg;
+		acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_D), 32);
+		dma_coherent = dma_zalloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+			&dma_coherent_handle, GFP_KERNEL);
+		if (!dma_coherent) {
+			pr_notice("arcmsr%d: DMA allocation failed\n", acb->host->host_no);
+			return false;
+		}
+		acb->dma_coherent_handle2 = dma_coherent_handle;
+		acb->dma_coherent2 = dma_coherent;
+		reg = (struct MessageUnit_D *)dma_coherent;
+		acb->pmuD = reg;
+		reg->chip_id = MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
+		reg->cpu_mem_config = MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
+		reg->i2o_host_interrupt_mask = MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+		reg->sample_at_reset = MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
+		reg->reset_request = MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
+		reg->host_int_status = MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
+		reg->pcief0_int_enable = MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+		reg->inbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0);
+		reg->inbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1);
+		reg->outbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
+		reg->outbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
+		reg->inbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL);
+		reg->outbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
+		reg->outbound_doorbell_enable = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+		reg->inboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+		reg->inboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+		reg->inboundlist_write_pointer = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+		reg->outboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+		reg->outboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+		reg->outboundlist_copy_pointer = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+		reg->outboundlist_read_pointer = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+		reg->outboundlist_interrupt_cause = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+		reg->outboundlist_interrupt_enable = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+		reg->message_wbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
+		reg->message_rbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
+		reg->msgcode_rwbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
+		}
+		break;
+	default:
+		break;
+	}
+	return rtn;
+}
+
 static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
 	struct pci_dev *pdev = acb->pdev;
@@ -742,9 +826,12 @@ static int arcmsr_probe(struct pci_dev *
 	if(!error){
 		goto pci_release_regs;
 	}
+	error = arcmsr_alloc_io_queue(acb);
+	if (!error)
+		goto unmap_pci_region;
 	error = arcmsr_get_firmware_spec(acb);
 	if(!error){
-		goto unmap_pci_region;
+		goto free_hbb_mu;
 	}
 	error = arcmsr_alloc_ccb_pool(acb);
 	if(error){
@@ -2624,10 +2711,7 @@ static bool arcmsr_hbaA_get_config(struc
 }
 static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 {
-	struct MessageUnit_B *reg;
-	struct pci_dev *pdev = acb->pdev;
-	void *dma_coherent;
-	dma_addr_t dma_coherent_handle;
+	struct MessageUnit_B *reg = acb->pmuB;
 	char *acb_firm_model = acb->firm_model;
 	char *acb_firm_version = acb->firm_version;
 	char *acb_device_map = acb->device_map;
@@ -2639,33 +2723,6 @@ static bool arcmsr_hbaB_get_config(struc
 	/*firm_version,21,84-99*/
 	int count;
 
-	acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_B), 32);
-	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
-			&dma_coherent_handle, GFP_KERNEL);
-	if (!dma_coherent){
-		printk(KERN_NOTICE
-			"arcmsr%d: dma_alloc_coherent got error for hbb mu\n",
-			acb->host->host_no);
-		return false;
-	}
-	acb->dma_coherent_handle2 = dma_coherent_handle;
-	acb->dma_coherent2 = dma_coherent;
-	reg = (struct MessageUnit_B *)dma_coherent;
-	acb->pmuB = reg;
-	if (acb->pdev->device == PCI_DEVICE_ID_ARECA_1203) {
-		reg->drv2iop_doorbell = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
-		reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
-		reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
-		reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
-	} else {
-		reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
-		reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
-		reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
-		reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
-	}
-	reg->message_wbuffer = MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
-	reg->message_rbuffer =  MEM_BASE1(ARCMSR_MESSAGE_RBUFFER);
-	reg->message_rwbuffer = MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
 	iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);	/*firm_model,15,60-67*/
 	iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);	/*firm_version,17,68-83*/
 	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);	/*firm_version,21,84-99*/
@@ -2674,13 +2731,13 @@ static bool arcmsr_hbaB_get_config(struc
 	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb->host->host_no);
-		goto err_free_dma;
+		return false;
 	}
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
 	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
 		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
 			miscellaneous data' timeout \n", acb->host->host_no);
-		goto err_free_dma;
+		return false;
 	}
 	count = 8;
 	while (count){
@@ -2723,10 +2780,6 @@ static bool arcmsr_hbaB_get_config(struc
 	acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
 	/*firm_ide_channels,4,16-19*/
 	return true;
-err_free_dma:
-	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
-			acb->dma_coherent2, acb->dma_coherent_handle2);
-	return false;
 }
 
 static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
@@ -2797,49 +2850,8 @@ static bool arcmsr_hbaD_get_config(struc
 	char __iomem *iop_firm_version;
 	char __iomem *iop_device_map;
 	u32 count;
-	struct MessageUnit_D *reg;
-	void *dma_coherent2;
-	dma_addr_t dma_coherent_handle2;
-	struct pci_dev *pdev = acb->pdev;
+	struct MessageUnit_D *reg = acb->pmuD;
 
-	acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_D), 32);
-	dma_coherent2 = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
-		&dma_coherent_handle2, GFP_KERNEL);
-	if (!dma_coherent2) {
-		pr_notice("DMA allocation failed...\n");
-		return false;
-	}
-	memset(dma_coherent2, 0, acb->roundup_ccbsize);
-	acb->dma_coherent_handle2 = dma_coherent_handle2;
-	acb->dma_coherent2 = dma_coherent2;
-	reg = (struct MessageUnit_D *)dma_coherent2;
-	acb->pmuD = reg;
-	reg->chip_id = MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
-	reg->cpu_mem_config = MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
-	reg->i2o_host_interrupt_mask = MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
-	reg->sample_at_reset = MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
-	reg->reset_request = MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
-	reg->host_int_status = MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
-	reg->pcief0_int_enable = MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
-	reg->inbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0);
-	reg->inbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1);
-	reg->outbound_msgaddr0 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
-	reg->outbound_msgaddr1 = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
-	reg->inbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL);
-	reg->outbound_doorbell = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
-	reg->outbound_doorbell_enable = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
-	reg->inboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
-	reg->inboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
-	reg->inboundlist_write_pointer = MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
-	reg->outboundlist_base_low = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
-	reg->outboundlist_base_high = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
-	reg->outboundlist_copy_pointer = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
-	reg->outboundlist_read_pointer = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
-	reg->outboundlist_interrupt_cause = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
-	reg->outboundlist_interrupt_enable = MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
-	reg->message_wbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
-	reg->message_rbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
-	reg->msgcode_rwbuffer = MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
 	iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
 	iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
 	iop_device_map = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
@@ -2854,8 +2866,6 @@ static bool arcmsr_hbaD_get_config(struc
 	if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
 		pr_notice("arcmsr%d: wait get adapter firmware "
 			"miscellaneous data timeout\n", acb->host->host_no);
-		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
-			acb->dma_coherent2, acb->dma_coherent_handle2);
 		return false;
 	}
 	count = 8;


