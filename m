From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 4/5] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Wed, 25 Nov 2015 13:01:00 +0100
Message-ID: <1448452860.2877.77.camel@suse.de>
References: <1448452173.4670.44.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448452173.4670.44.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@lst.de, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-25 at 19:49 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Support areca new PCIe to SATA RAID adapter ARC1203
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcms=
r.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 19:10:21.309960000 +080=
0
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 18:25:42.926038000 +080=
0
> @@ -74,6 +74,9 @@ struct device_attribute;
> =C2=A0#ifndef PCI_DEVICE_ID_ARECA_1214
> =C2=A0	#define PCI_DEVICE_ID_ARECA_1214	0x1214
> =C2=A0#endif
> +#ifndef PCI_DEVICE_ID_ARECA_1203
> +	#define PCI_DEVICE_ID_ARECA_1203	0x1203
> +#endif
> =C2=A0/*
> =C2=A0***************************************************************=
*************
> ******
> =C2=A0**
> @@ -245,6 +248,12 @@ struct FIRMWARE_INFO
> =C2=A0/* window of "instruction flags" from iop to driver */
> =C2=A0#define ARCMSR_IOP2DRV_DOORBELL=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x00020408
> =C2=A0#define ARCMSR_IOP2DRV_DOORBELL_MASK=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00x0002040C
> +/* window of "instruction flags" from iop to driver */
> +#define ARCMSR_IOP2DRV_DOORBELL_1203=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A00x00021870
> +#define ARCMSR_IOP2DRV_DOORBELL_MASK_1203=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x00021874
> +/* window of "instruction flags" from driver to iop */
> +#define ARCMSR_DRV2IOP_DOORBELL_1203=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A00x00021878
> +#define ARCMSR_DRV2IOP_DOORBELL_MASK_1203=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x0002187C
> =C2=A0/* ARECA FLAG LANGUAGE */
> =C2=A0/* ioctl transfer */
> =C2=A0#define ARCMSR_IOP2DRV_DATA_WRITE_OK=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00x00000001
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:11:27.679958000
> +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 18:30:52.239029000
> +0800
> @@ -114,6 +114,7 @@ static void arcmsr_hardware_reset(struct
> =C2=A0static const char *arcmsr_info(struct Scsi_Host *);
> =C2=A0static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock =
*acb);
> =C2=A0static void arcmsr_free_irq(struct pci_dev *, struct AdapterCon=
trolBlock *);
> +static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *a=
cb);
> =C2=A0static int arcmsr_adjust_disk_queue_depth(struct scsi_device *s=
dev, int
> queue_depth)
> =C2=A0{
> =C2=A0	if (queue_depth > ARCMSR_MAX_CMD_PERLUN)
> @@ -157,6 +158,8 @@ static struct pci_device_id arcmsr_devic
> =C2=A0		.driver_data =3D ACB_ADAPTER_TYPE_B},
> =C2=A0	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202),
> =C2=A0		.driver_data =3D ACB_ADAPTER_TYPE_B},
> +	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1203),
> +		.driver_data =3D ACB_ADAPTER_TYPE_B},
> =C2=A0	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210),
> =C2=A0		.driver_data =3D ACB_ADAPTER_TYPE_A},
> =C2=A0	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214),
> @@ -2621,7 +2624,7 @@ static bool arcmsr_hbaA_get_config(struc
> =C2=A0}
> =C2=A0static bool arcmsr_hbaB_get_config(struct AdapterControlBlock *=
acb)
> =C2=A0{
> -	struct MessageUnit_B *reg =3D acb->pmuB;
> +	struct MessageUnit_B *reg;
> =C2=A0	struct pci_dev *pdev =3D acb->pdev;
> =C2=A0	void *dma_coherent;
> =C2=A0	dma_addr_t dma_coherent_handle;
> @@ -2649,10 +2652,17 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	acb->dma_coherent2 =3D dma_coherent;
> =C2=A0	reg =3D (struct MessageUnit_B *)dma_coherent;
> =C2=A0	acb->pmuB =3D reg;
> -	reg->drv2iop_doorbell=3D MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
> -	reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
> -	reg->iop2drv_doorbell =3D MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
> -	reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
> +	if (acb->pdev->device =3D=3D PCI_DEVICE_ID_ARECA_1203) {
> +		reg->drv2iop_doorbell =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_1203);
> +		reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK_1203);
> +		reg->iop2drv_doorbell =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_1203);
> +		reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK_1203);
> +	} else {
> +		reg->drv2iop_doorbell=3D MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
> +		reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
> +		reg->iop2drv_doorbell =3D MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
> +		reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
> +	}
> =C2=A0	reg->message_wbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
> =C2=A0	reg->message_rbuffer =3D=C2=A0=C2=A0MEM_BASE1(ARCMSR_MESSAGE_R=
BUFFER);
> =C2=A0	reg->message_rwbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
> @@ -2660,6 +2670,12 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[1=
7]);=09
> /*firm_version,17,68-83*/
> =C2=A0	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]=
);=09
> /*firm_version,21,84-99*/
> =C2=A0
> +	arcmsr_wait_firmware_ready(acb);
> +	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
> +	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> +		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb-
> >host->host_no);
> +		goto err_free_dma;
> +	}
> =C2=A0	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
> =C2=A0	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> =C2=A0		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
> @@ -4002,6 +4018,7 @@ static const char *arcmsr_info(struct Sc
> =C2=A0	case PCI_DEVICE_ID_ARECA_1160:
> =C2=A0	case PCI_DEVICE_ID_ARECA_1170:
> =C2=A0	case PCI_DEVICE_ID_ARECA_1201:
> +	case PCI_DEVICE_ID_ARECA_1203:
> =C2=A0	case PCI_DEVICE_ID_ARECA_1220:
> =C2=A0	case PCI_DEVICE_ID_ARECA_1230:
> =C2=A0	case PCI_DEVICE_ID_ARECA_1260:
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
