From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v2 2/3] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Wed, 25 Nov 2015 17:48:06 +0800
Message-ID: <1448444886.4670.16.camel@Centos6.3-64>
References: <1448421927.4698.22.camel@Centos6.3-64>
	 <1448441037.2877.41.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34943 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbKYJsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2015 04:48:13 -0500
Received: by pacej9 with SMTP id ej9so52596372pac.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2015 01:48:12 -0800 (PST)
In-Reply-To: <1448441037.2877.41.camel@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: hch@lst.de, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de

On Wed, 2015-11-25 at 09:43 +0100, Johannes Thumshirn wrote:
> On Wed, 2015-11-25 at 11:25 +0800, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> > 
> > Support areca new PCIe to SATA RAID adapter ARC1203
> > 
> > Signed-of-by: Ching Huang<ching2048@areca.com.tw>
> > 
> > ---
> > 
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> > --- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 10:52:16.286470000 +0800
> > +++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 10:52:13.334470000 +0800
> > @@ -74,6 +74,9 @@ struct device_attribute;
> >  #ifndef PCI_DEVICE_ID_ARECA_1214
> >  	#define PCI_DEVICE_ID_ARECA_1214	0x1214
> >  #endif
> > +#ifndef PCI_DEVICE_ID_ARECA_1203
> > +	#define PCI_DEVICE_ID_ARECA_1203	0x1203
> > +#endif
> >  /*
> >  ****************************************************************************
> > ******
> >  **
> > @@ -245,6 +248,12 @@ struct FIRMWARE_INFO
> >  /* window of "instruction flags" from iop to driver */
> >  #define ARCMSR_IOP2DRV_DOORBELL                       0x00020408
> >  #define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C
> > +/* window of "instruction flags" from iop to driver */
> > +#define ARCMSR_IOP2DRV_DOORBELL_1203                  0x00021870
> > +#define ARCMSR_IOP2DRV_DOORBELL_MASK_1203             0x00021874
> > +/* window of "instruction flags" from driver to iop */
> > +#define ARCMSR_DRV2IOP_DOORBELL_1203                  0x00021878
> > +#define ARCMSR_DRV2IOP_DOORBELL_MASK_1203             0x0002187C
> >  /* ARECA FLAG LANGUAGE */
> >  /* ioctl transfer */
> >  #define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> > b/drivers/scsi/arcmsr/arcmsr_hba.c
> > --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000
> > +0800
> > +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 18:58:40.640226000
> > +0800
> > @@ -114,6 +114,7 @@ static void arcmsr_hardware_reset(struct
> >  static const char *arcmsr_info(struct Scsi_Host *);
> >  static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
> >  static void arcmsr_free_irq(struct pci_dev *, struct AdapterControlBlock *);
> > +static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb);
> >  static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev, int
> > queue_depth)
> >  {
> >  	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
> > @@ -157,6 +158,8 @@ static struct pci_device_id arcmsr_devic
> >  		.driver_data = ACB_ADAPTER_TYPE_B},
> >  	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202),
> >  		.driver_data = ACB_ADAPTER_TYPE_B},
> > +	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1203),
> > +		.driver_data = ACB_ADAPTER_TYPE_B},
> >  	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210),
> >  		.driver_data = ACB_ADAPTER_TYPE_A},
> >  	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214),
> > @@ -2621,7 +2624,7 @@ static bool arcmsr_hbaA_get_config(struc
> >  }
> >  static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
> >  {
> > -	struct MessageUnit_B *reg = acb->pmuB;
> > +	struct MessageUnit_B *reg;
> >  	struct pci_dev *pdev = acb->pdev;
> >  	void *dma_coherent;
> >  	dma_addr_t dma_coherent_handle;
> > @@ -2649,10 +2652,17 @@ static bool arcmsr_hbaB_get_config(struc
> >  	acb->dma_coherent2 = dma_coherent;
> >  	reg = (struct MessageUnit_B *)dma_coherent;
> >  	acb->pmuB = reg;
> > -	reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned long)acb-
> > >mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
> > -	reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
> > -	reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned long)acb-
> > >mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
> > -	reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
> > +	if (acb->pdev->device == PCI_DEVICE_ID_ARECA_1203) {
> > +		reg->drv2iop_doorbell = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_1203);
> > +		reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
> > +		reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_1203);
> > +		reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
> > +	} else {
> > +		reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
> > +		reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
> > +		reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
> > +		reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
> > long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
> > +	}
> 
> 
> This isn't quite readable IMHO. Can't you do:
> 
> #define MEM_BASE0(x) (u32 __iomem *)((unsigned long)acb->mem_base0 + (x))
> #define MEM_BASE1(x) (u32 __iomem *)((unsigned long)acb->mem_base1 + (x))
> 
> and then 
> 
> reg->drv2iop_doorbell= MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
> reg->drv2iop_doorbell_mask = MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
> reg->iop2drv_doorbell = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
> reg->iop2drv_doorbell_mask = MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
> reg->message_wbuffer =  MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
> reg->message_rbuffer =  MEM_BASE1(ARCMSR_MESSAGE_RBUFFER);
> reg->message_rwbuffer =  MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
> 
> 
> (Note this hunk is made without your patch. And not tested)
> 
Thanks Johannes' advice.
I will revise it.
> >  	reg->message_wbuffer = (uint32_t __iomem *)((unsigned long)acb-
> > >mem_base1 + ARCMSR_MESSAGE_WBUFFER);
> >  	reg->message_rbuffer =  (uint32_t __iomem *)((unsigned long)acb-
> > >mem_base1 + ARCMSR_MESSAGE_RBUFFER);
> >  	reg->message_rwbuffer = (uint32_t __iomem *)((unsigned long)acb-
> > >mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
> > @@ -2660,11 +2670,17 @@ static bool arcmsr_hbaB_get_config(struc
> >  	iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);	
> > /*firm_version,17,68-83*/
> >  	iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);	
> > /*firm_version,21,84-99*/
> >  
> > +	arcmsr_wait_firmware_ready(acb);
> > +	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
> > +	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> > +		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb-
> > >host->host_no);
> > +		goto err_free_dma;
> > +	}
> >  	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
> >  	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> >  		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
> >  			miscellaneous data' timeout \n", acb->host-
> > >host_no);
> > -		return false;
> > +		goto err_free_dma;
> >  	}
> >  	count = 8;
> >  	while (count){
> > @@ -2707,6 +2723,10 @@ static bool arcmsr_hbaB_get_config(struc
> >  	acb->firm_cfg_version = readl(&reg-
> > >message_rwbuffer[25]);  /*firm_cfg_version,25,100-103*/
> >  	/*firm_ide_channels,4,16-19*/
> >  	return true;
> > +err_free_dma:
> > +	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> > +			acb->dma_coherent2, acb->dma_coherent_handle2);
> > +	return false;
> >  }
> >  
> >  static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
> > @@ -3998,6 +4018,7 @@ static const char *arcmsr_info(struct Sc
> >  	case PCI_DEVICE_ID_ARECA_1160:
> >  	case PCI_DEVICE_ID_ARECA_1170:
> >  	case PCI_DEVICE_ID_ARECA_1201:
> > +	case PCI_DEVICE_ID_ARECA_1203:
> >  	case PCI_DEVICE_ID_ARECA_1220:
> >  	case PCI_DEVICE_ID_ARECA_1230:
> >  	case PCI_DEVICE_ID_ARECA_1260:
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


