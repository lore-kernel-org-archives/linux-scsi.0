From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/3] arcmsr: Split dma resource allocation to a new
 function
Date: Tue, 01 Dec 2015 14:41:36 +0100
Message-ID: <1448977296.3103.31.camel@suse.de>
References: <1448538075.10768.47.camel@Centos6.3-64>
	 <1448567174.18647.19.camel@perches.com>
	 <1448593128.4834.5.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984AbbLANli (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 08:41:38 -0500
In-Reply-To: <1448593128.4834.5.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, Joe Perches <joe@perches.com>
Cc: thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de, hch@lst.de

On Fri, 2015-11-27 at 10:58 +0800, Ching Huang wrote:
> On Thu, 2015-11-26 at 11:46 -0800, Joe Perches wrote:
> > On Thu, 2015-11-26 at 19:41 +0800, Ching Huang wrote:
> > > split dma resource allocation and io register assignment from get=
_config
> > > to a new function arcmsr_alloc_io_queue.
> >=20
> > trivia:
> >=20
> > > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> > > b/drivers/scsi/arcmsr/arcmsr_hba.c
> > []
> > > +static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *ac=
b)
> > > +{
> > []
> > > +		dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb-
> > > >roundup_ccbsize,
> > > +			&dma_coherent_handle, GFP_KERNEL);
> > > +		if (!dma_coherent){
> > > +			pr_notice("arcmsr%d: DMA allocation failed.\n",
> > > acb->host->host_no);
> > > +			return false;
> > > +		}
> > > +		memset(dma_coherent, 0, acb->roundup_ccbsize);
> > >=20
> >=20
> > There is a dma_zalloc_coherent
> >=20
> > (and even more trivially)
> >=20
> > Most all of your error messages don't use periods.
> Thanks Joe.
> Revised as below.
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-26 15:52:54.000000000
> +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-27 10:30:09.299131000
> +0800
> @@ -498,6 +498,90 @@ static void arcmsr_flush_adapter_cache(s
> =C2=A0	}
> =C2=A0}
> =C2=A0
> +static bool arcmsr_alloc_io_queue(struct AdapterControlBlock *acb)
> +{
> +	bool rtn =3D true;
> +	void *dma_coherent;
> +	dma_addr_t dma_coherent_handle;
> +	struct pci_dev *pdev =3D acb->pdev;
> +
> +	switch (acb->adapter_type) {
> +	case ACB_ADAPTER_TYPE_B: {
> +		struct MessageUnit_B *reg;
> +		acb->roundup_ccbsize =3D roundup(sizeof(struct MessageUnit_B),
> 32);
> +		dma_coherent =3D dma_zalloc_coherent(&pdev->dev, acb-
> >roundup_ccbsize,
> +			&dma_coherent_handle, GFP_KERNEL);
> +		if (!dma_coherent){
> +			pr_notice("arcmsr%d: DMA allocation failed\n", acb-
> >host->host_no);
> +			return false;
> +		}
> +		acb->dma_coherent_handle2 =3D dma_coherent_handle;
> +		acb->dma_coherent2 =3D dma_coherent;
> +		reg =3D (struct MessageUnit_B *)dma_coherent;
> +		acb->pmuB =3D reg;
> +		if (acb->pdev->device =3D=3D PCI_DEVICE_ID_ARECA_1203) {
> +			reg->drv2iop_doorbell =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
> +			reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
> +			reg->iop2drv_doorbell =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
> +			reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
> +		} else {
> +			reg->drv2iop_doorbell=3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
> +			reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
> +			reg->iop2drv_doorbell =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
> +			reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
> +		}
> +		reg->message_wbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
> +		reg->message_rbuffer =3D=C2=A0=C2=A0MEM_BASE1(ARCMSR_MESSAGE_RBUFF=
ER);
> +		reg->message_rwbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
> +		}
> +		break;
> +	case ACB_ADAPTER_TYPE_D: {
> +		struct MessageUnit_D *reg;
> +		acb->roundup_ccbsize =3D roundup(sizeof(struct MessageUnit_D),
> 32);
> +		dma_coherent =3D dma_zalloc_coherent(&pdev->dev, acb-
> >roundup_ccbsize,
> +			&dma_coherent_handle, GFP_KERNEL);
> +		if (!dma_coherent) {
> +			pr_notice("arcmsr%d: DMA allocation failed\n", acb-
> >host->host_no);
> +			return false;
> +		}
> +		acb->dma_coherent_handle2 =3D dma_coherent_handle;
> +		acb->dma_coherent2 =3D dma_coherent;
> +		reg =3D (struct MessageUnit_D *)dma_coherent;
> +		acb->pmuD =3D reg;
> +		reg->chip_id =3D MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
> +		reg->cpu_mem_config =3D
> MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
> +		reg->i2o_host_interrupt_mask =3D
> MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
> +		reg->sample_at_reset =3D
> MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
> +		reg->reset_request =3D
> MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
> +		reg->host_int_status =3D
> MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
> +		reg->pcief0_int_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
> +		reg->inbound_msgaddr0 =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0);
> +		reg->inbound_msgaddr1 =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1);
> +		reg->outbound_msgaddr0 =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
> +		reg->outbound_msgaddr1 =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
> +		reg->inbound_doorbell =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL);
> +		reg->outbound_doorbell =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
> +		reg->outbound_doorbell_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
> +		reg->inboundlist_base_low =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
> +		reg->inboundlist_base_high =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
> +		reg->inboundlist_write_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
> +		reg->outboundlist_base_low =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
> +		reg->outboundlist_base_high =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
> +		reg->outboundlist_copy_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
> +		reg->outboundlist_read_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
> +		reg->outboundlist_interrupt_cause =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
> +		reg->outboundlist_interrupt_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
> +		reg->message_wbuffer =3D
> MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
> +		reg->message_rbuffer =3D
> MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
> +		reg->msgcode_rwbuffer =3D
> MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER);
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +	return rtn;
> +}
> +
> =C2=A0static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *ac=
b)
> =C2=A0{
> =C2=A0	struct pci_dev *pdev =3D acb->pdev;
> @@ -742,9 +826,12 @@ static int arcmsr_probe(struct pci_dev *
> =C2=A0	if(!error){
> =C2=A0		goto pci_release_regs;
> =C2=A0	}
> +	error =3D arcmsr_alloc_io_queue(acb);
> +	if (!error)
> +		goto unmap_pci_region;
> =C2=A0	error =3D arcmsr_get_firmware_spec(acb);
> =C2=A0	if(!error){
> -		goto unmap_pci_region;
> +		goto free_hbb_mu;
> =C2=A0	}
> =C2=A0	error =3D arcmsr_alloc_ccb_pool(acb);
> =C2=A0	if(error){
> @@ -2624,10 +2711,7 @@ static bool arcmsr_hbaA_get_config(struc
> =C2=A0}
> =C2=A0static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *=
acb)
> =C2=A0{
> -	struct MessageUnit_B *reg;
> -	struct pci_dev *pdev =3D acb->pdev;
> -	void *dma_coherent;
> -	dma_addr_t dma_coherent_handle;
> +	struct MessageUnit_B *reg =3D acb->pmuB;
> =C2=A0	char *acb_firm_model =3D acb->firm_model;
> =C2=A0	char *acb_firm_version =3D acb->firm_version;
> =C2=A0	char *acb_device_map =3D acb->device_map;
> @@ -2639,33 +2723,6 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	/*firm_version,21,84-99*/
> =C2=A0	int count;
> =C2=A0
> -	acb->roundup_ccbsize =3D roundup(sizeof(struct MessageUnit_B), 32);
> -	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsiz=
e,
> -			&dma_coherent_handle, GFP_KERNEL);
> -	if (!dma_coherent){
> -		printk(KERN_NOTICE
> -			"arcmsr%d: dma_alloc_coherent got error for hbb
> mu\n",
> -			acb->host->host_no);
> -		return false;
> -	}
> -	acb->dma_coherent_handle2 =3D dma_coherent_handle;
> -	acb->dma_coherent2 =3D dma_coherent;
> -	reg =3D (struct MessageUnit_B *)dma_coherent;
> -	acb->pmuB =3D reg;
> -	if (acb->pdev->device =3D=3D PCI_DEVICE_ID_ARECA_1203) {
> -		reg->drv2iop_doorbell =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
> -		reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
> -		reg->iop2drv_doorbell =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
> -		reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
> -	} else {
> -		reg->drv2iop_doorbell=3D MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
> -		reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
> -		reg->iop2drv_doorbell =3D MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
> -		reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
> -	}
> -	reg->message_wbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
> -	reg->message_rbuffer =3D=C2=A0=C2=A0MEM_BASE1(ARCMSR_MESSAGE_RBUFFE=
R);
> -	reg->message_rwbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
> =C2=A0	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]=
);=09
> /*firm_model,15,60-67*/
> =C2=A0	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[1=
7]);=09
> /*firm_version,17,68-83*/
> =C2=A0	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]=
);=09
> /*firm_version,21,84-99*/
> @@ -2674,13 +2731,13 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell=
);
> =C2=A0	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> =C2=A0		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb-
> >host->host_no);
> -		goto err_free_dma;
> +		return false;
> =C2=A0	}
> =C2=A0	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
> =C2=A0	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> =C2=A0		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
> =C2=A0			miscellaneous data' timeout \n", acb->host-
> >host_no);
> -		goto err_free_dma;
> +		return false;
> =C2=A0	}
> =C2=A0	count =3D 8;
> =C2=A0	while (count){
> @@ -2723,10 +2780,6 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	acb->firm_cfg_version =3D readl(&reg-
> >message_rwbuffer[25]);=C2=A0=C2=A0/*firm_cfg_version,25,100-103*/
> =C2=A0	/*firm_ide_channels,4,16-19*/
> =C2=A0	return true;
> -err_free_dma:
> -	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> -			acb->dma_coherent2, acb->dma_coherent_handle2);
> -	return false;
> =C2=A0}
> =C2=A0
> =C2=A0static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *=
pACB)
> @@ -2797,49 +2850,8 @@ static bool arcmsr_hbaD_get_config(struc
> =C2=A0	char __iomem *iop_firm_version;
> =C2=A0	char __iomem *iop_device_map;
> =C2=A0	u32 count;
> -	struct MessageUnit_D *reg;
> -	void *dma_coherent2;
> -	dma_addr_t dma_coherent_handle2;
> -	struct pci_dev *pdev =3D acb->pdev;
> +	struct MessageUnit_D *reg =3D acb->pmuD;
> =C2=A0
> -	acb->roundup_ccbsize =3D roundup(sizeof(struct MessageUnit_D), 32);
> -	dma_coherent2 =3D dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsi=
ze,
> -		&dma_coherent_handle2, GFP_KERNEL);
> -	if (!dma_coherent2) {
> -		pr_notice("DMA allocation failed...\n");
> -		return false;
> -	}
> -	memset(dma_coherent2, 0, acb->roundup_ccbsize);
> -	acb->dma_coherent_handle2 =3D dma_coherent_handle2;
> -	acb->dma_coherent2 =3D dma_coherent2;
> -	reg =3D (struct MessageUnit_D *)dma_coherent2;
> -	acb->pmuD =3D reg;
> -	reg->chip_id =3D MEM_BASE0(ARCMSR_ARC1214_CHIP_ID);
> -	reg->cpu_mem_config =3D
> MEM_BASE0(ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
> -	reg->i2o_host_interrupt_mask =3D
> MEM_BASE0(ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
> -	reg->sample_at_reset =3D MEM_BASE0(ARCMSR_ARC1214_SAMPLE_RESET);
> -	reg->reset_request =3D MEM_BASE0(ARCMSR_ARC1214_RESET_REQUEST);
> -	reg->host_int_status =3D
> MEM_BASE0(ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
> -	reg->pcief0_int_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
> -	reg->inbound_msgaddr0 =3D MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE0=
);
> -	reg->inbound_msgaddr1 =3D MEM_BASE0(ARCMSR_ARC1214_INBOUND_MESSAGE1=
);
> -	reg->outbound_msgaddr0 =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
> -	reg->outbound_msgaddr1 =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
> -	reg->inbound_doorbell =3D MEM_BASE0(ARCMSR_ARC1214_INBOUND_DOORBELL=
);
> -	reg->outbound_doorbell =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL);
> -	reg->outbound_doorbell_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
> -	reg->inboundlist_base_low =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
> -	reg->inboundlist_base_high =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
> -	reg->inboundlist_write_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
> -	reg->outboundlist_base_low =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
> -	reg->outboundlist_base_high =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
> -	reg->outboundlist_copy_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
> -	reg->outboundlist_read_pointer =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
> -	reg->outboundlist_interrupt_cause =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
> -	reg->outboundlist_interrupt_enable =3D
> MEM_BASE0(ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
> -	reg->message_wbuffer =3D MEM_BASE0(ARCMSR_ARC1214_MESSAGE_WBUFFER);
> -	reg->message_rbuffer =3D MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RBUFFER);
> -	reg->msgcode_rwbuffer =3D MEM_BASE0(ARCMSR_ARC1214_MESSAGE_RWBUFFER=
);
> =C2=A0	iop_firm_model =3D (char __iomem *)(&reg->msgcode_rwbuffer[15]=
);
> =C2=A0	iop_firm_version =3D (char __iomem *)(&reg->msgcode_rwbuffer[1=
7]);
> =C2=A0	iop_device_map =3D (char __iomem *)(&reg->msgcode_rwbuffer[21]=
);
> @@ -2854,8 +2866,6 @@ static bool arcmsr_hbaD_get_config(struc
> =C2=A0	if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
> =C2=A0		pr_notice("arcmsr%d: wait get adapter firmware "
> =C2=A0			"miscellaneous data timeout\n", acb->host->host_no);
> -		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> -			acb->dma_coherent2, acb->dma_coherent_handle2);
> =C2=A0		return false;
> =C2=A0	}
> =C2=A0	count =3D 8;
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
