From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 3/5] arcmsr: modifies codes for more readable
Date: Wed, 25 Nov 2015 13:00:37 +0100
Message-ID: <1448452837.2877.76.camel@suse.de>
References: <1448451916.4670.39.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448451916.4670.39.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@lst.de, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-25 at 19:45 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Modifies codes for more readable
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcms=
r.h
> --- a/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 10:52:16.286470000 +080=
0
> +++ b/drivers/scsi/arcmsr/arcmsr.h	2015-11-25 19:10:21.309960000 +080=
0
> @@ -288,6 +288,9 @@ struct FIRMWARE_INFO
> =C2=A0#define ARCMSR_MESSAGE_RBUFFER			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A00x0000ff00
> =C2=A0/* iop message_rwbuffer for message command */
> =C2=A0#define ARCMSR_MESSAGE_RWBUFFER			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A00x0000fa00
> +
> +#define MEM_BASE0(x)	(u32 __iomem *)((unsigned long)acb->mem_base0 +
> x)
> +#define MEM_BASE1(x)	(u32 __iomem *)((unsigned long)acb->mem_base1 +
> x)
> =C2=A0/*=20
> =C2=A0***************************************************************=
*********
> =C2=A0**=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0SPEC. for Areca HBC adapter
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:04:44.590970000
> +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:11:27.679958000
> +0800
> @@ -2649,13 +2649,13 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	acb->dma_coherent2 =3D dma_coherent;
> =C2=A0	reg =3D (struct MessageUnit_B *)dma_coherent;
> =C2=A0	acb->pmuB =3D reg;
> -	reg->drv2iop_doorbell=3D (uint32_t __iomem *)((unsigned long)acb-
> >mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
> -	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)((unsigned
> long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
> -	reg->iop2drv_doorbell =3D (uint32_t __iomem *)((unsigned long)acb-
> >mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
> -	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)((unsigned
> long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
> -	reg->message_wbuffer =3D (uint32_t __iomem *)((unsigned long)acb-
> >mem_base1 + ARCMSR_MESSAGE_WBUFFER);
> -	reg->message_rbuffer =3D=C2=A0=C2=A0(uint32_t __iomem *)((unsigned =
long)acb-
> >mem_base1 + ARCMSR_MESSAGE_RBUFFER);
> -	reg->message_rwbuffer =3D (uint32_t __iomem *)((unsigned long)acb-
> >mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
> +	reg->drv2iop_doorbell=3D MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL);
> +	reg->drv2iop_doorbell_mask =3D
> MEM_BASE0(ARCMSR_DRV2IOP_DOORBELL_MASK);
> +	reg->iop2drv_doorbell =3D MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL);
> +	reg->iop2drv_doorbell_mask =3D
> MEM_BASE0(ARCMSR_IOP2DRV_DOORBELL_MASK);
> +	reg->message_wbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_WBUFFER);
> +	reg->message_rbuffer =3D=C2=A0=C2=A0MEM_BASE1(ARCMSR_MESSAGE_RBUFFE=
R);
> +	reg->message_rwbuffer =3D MEM_BASE1(ARCMSR_MESSAGE_RWBUFFER);
> =C2=A0	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]=
);=09
> /*firm_model,15,60-67*/
> =C2=A0	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[1=
7]);=09
> /*firm_version,17,68-83*/
> =C2=A0	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]=
);=09
> /*firm_version,21,84-99*/
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
