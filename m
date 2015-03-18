From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/7] aacraid: MSI-x support
Date: Wed, 18 Mar 2015 12:18:44 +0100
Message-ID: <55095F14.8070102@suse.de>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com> <1425458313-1956-5-git-send-email-Mahesh.Rajashekhara@pmcs.com> <307F48E420013C4E85C75C93E532197AB8092042@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520AbbCRLSr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 07:18:47 -0400
In-Reply-To: <307F48E420013C4E85C75C93E532197AB8092042@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Achim Leubner <Achim.Leubner@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/17/2015 04:27 PM, Achim Leubner wrote:
> Reviewed-by: Achim Leubner <Achim.Leubner@pmcs.com>
>=20
>=20
> -----Original Message-----
> From: Mahesh Rajashekhara=20
> Sent: Wednesday, March 4, 2015 9:39 AM
> To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
> Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pa=
ndurangan; Rich Bono; Mahesh Rajashekhara
> Subject: [PATCH 4/7] aacraid: MSI-x support
>=20
> Add MSI-x interrupt mode support.
>=20
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
> ---
>  drivers/scsi/aacraid/aachba.c   |    6 +-
>  drivers/scsi/aacraid/aacraid.h  |   79 ++++++++-
>  drivers/scsi/aacraid/comminit.c |   86 +++++++++-
>  drivers/scsi/aacraid/commsup.c  |   19 ++-
>  drivers/scsi/aacraid/dpcsup.c   |    9 +-
>  drivers/scsi/aacraid/linit.c    |   18 ++-
>  drivers/scsi/aacraid/src.c      |  365 +++++++++++++++++++++++++++++=
----------
>  7 files changed, 473 insertions(+), 109 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c index 0819644..eb524e6 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -473,7 +473,7 @@ static void get_container_name_callback(void *con=
text, struct fib * fibptr)
>  	if ((le32_to_cpu(get_name_reply->status) =3D=3D CT_OK)
>  	 && (get_name_reply->data[0] !=3D '\0')) {
>  		char *sp =3D get_name_reply->data;
> -		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)-1] =3D '\0';
> +		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] =3D '\0';
>  		while (*sp =3D=3D ' ')
>  			++sp;
>  		if (*sp) {
> @@ -613,7 +613,9 @@ static void _aac_probe_container1(void * context,=
 struct fib * fibptr)
>  	int status;
> =20
>  	dresp =3D (struct aac_mount *) fib_data(fibptr);
> -	dresp->mnt[0].capacityhigh =3D 0;
> +	if (!(fibptr->dev->supplement_adapter_info.SupportedOptions2 &
> +	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
> +		dresp->mnt[0].capacityhigh =3D 0;
>  	if ((le32_to_cpu(dresp->status) !=3D ST_OK) ||
>  	    (le32_to_cpu(dresp->mnt[0].vol) !=3D CT_NONE)) {
>  		_aac_probe_container2(context, fibptr); diff --git a/drivers/scsi/=
aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index 93579f3..c162a=
65 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -6,11 +6,61 @@
>  #define nblank(x) _nblank(x)[0]
> =20
>  #include <linux/interrupt.h>
> +#include <linux/pci.h>
> =20
>  /*------------------------------------------------------------------=
------------
>   *              D E F I N E S
>   *------------------------------------------------------------------=
----------*/
> =20
> +#define AAC_MAX_MSIX		32	/* vectors */
> +#define AAC_PCI_MSI_ENABLE	0x8000
> +
> +enum {
> +	AAC_ENABLE_INTERRUPT	=3D 0x0,
> +	AAC_DISABLE_INTERRUPT,
> +	AAC_ENABLE_MSIX,
> +	AAC_DISABLE_MSIX,
> +	AAC_CLEAR_AIF_BIT,
> +	AAC_CLEAR_SYNC_BIT,
> +	AAC_ENABLE_INTX
> +};
> +
> +#define AAC_INT_MODE_INTX		(1<<0)
> +#define AAC_INT_MODE_MSI		(1<<1)
> +#define AAC_INT_MODE_AIF		(1<<2)
> +#define AAC_INT_MODE_SYNC		(1<<3)
> +
> +#define AAC_INT_ENABLE_TYPE1_INTX	0xfffffffb
> +#define AAC_INT_ENABLE_TYPE1_MSIX	0xfffffffa
> +#define AAC_INT_DISABLE_ALL		0xffffffff
> +
> +/* Bit definitions in IOA->Host Interrupt Register */
> +#define PMC_TRANSITION_TO_OPERATIONAL	(0x80000000 >> 0)
> +#define PMC_IOARCB_TRANSFER_FAILED	(0x80000000 >> 3)
> +#define PMC_IOA_UNIT_CHECK		(0x80000000 >> 4)
> +#define PMC_NO_HOST_RRQ_FOR_CMD_RESPONSE (0x80000000 >> 5)
> +#define PMC_CRITICAL_IOA_OP_IN_PROGRESS	(0x80000000 >> 6)
> +#define PMC_IOARRIN_LOST		(0x80000000 >> 27)
> +#define PMC_SYSTEM_BUS_MMIO_ERROR	(0x80000000 >> 28)
> +#define PMC_IOA_PROCESSOR_IN_ERROR_STATE (0x80000000 >> 29)
> +#define PMC_HOST_RRQ_VALID		(0x80000000 >> 30)
> +#define PMC_OPERATIONAL_STATUS		(0x80000000 >> 0)
> +#define PMC_ALLOW_MSIX_VECTOR0		(0x80000000 >> 31)
> +
How positively curious.
Typically you define a git mask by shifting _left_, not right.

> +#define PMC_IOA_ERROR_INTERRUPTS	(PMC_IOARCB_TRANSFER_FAILED | \
> +					 PMC_IOA_UNIT_CHECK | \
> +					 PMC_NO_HOST_RRQ_FOR_CMD_RESPONSE | \
> +					 PMC_IOARRIN_LOST | \
> +					 PMC_SYSTEM_BUS_MMIO_ERROR | \
> +					 PMC_IOA_PROCESSOR_IN_ERROR_STATE)
> +
> +#define PMC_ALL_INTERRUPT_BITS		(PMC_IOA_ERROR_INTERRUPTS | \
> +					 PMC_HOST_RRQ_VALID | \
> +					 PMC_TRANSITION_TO_OPERATIONAL | \
> +					 PMC_ALLOW_MSIX_VECTOR0)
> +#define	PMC_GLOBAL_INT_BIT2		0x00000004
> +#define	PMC_GLOBAL_INT_BIT0		0x00000001
> +
>  #ifndef AAC_DRIVER_BUILD
>  # define AAC_DRIVER_BUILD 30300
>  # define AAC_DRIVER_BRANCH "-ms"
> @@ -36,6 +86,7 @@
>  #define CONTAINER_TO_ID(cont)		(cont)
>  #define CONTAINER_TO_LUN(cont)		(0)
> =20
> +#define PMC_DEVICE_S6	0x28b
>  #define PMC_DEVICE_S7	0x28c
>  #define PMC_DEVICE_S8	0x28d
>  #define PMC_DEVICE_S9	0x28f
> @@ -434,7 +485,7 @@ enum fib_xfer_state {  struct aac_init  {
>  	__le32	InitStructRevision;
> -	__le32	MiniPortRevision;
> +	__le32	NoOfMSIXVectors;
>  	__le32	fsrev;
>  	__le32	CommHeaderAddress;
>  	__le32	FastIoCommAreaAddress;
> @@ -755,7 +806,8 @@ struct rkt_registers {
> =20
>  struct src_mu_registers {
>  				/*	PCI*| Name */
> -	__le32	reserved0[8];	/*	00h | Reserved */
> +	__le32	reserved0[6];	/*	00h | Reserved */
> +	__le32	IOAR[2];	/*	18h | IOA->host interrupt register */
>  	__le32	IDR;		/*	20h | Inbound Doorbell Register */
>  	__le32	IISR;		/*	24h | Inbound Int. Status Register */
>  	__le32	reserved1[3];	/*	28h | Reserved */
> @@ -767,17 +819,18 @@ struct src_mu_registers {
>  	__le32	OMR;		/*	bch | Outbound Message Register */
>  	__le32	IQ_L;		/*  c0h | Inbound Queue (Low address) */
>  	__le32	IQ_H;		/*  c4h | Inbound Queue (High address) */
> +	__le32	ODR_MSI;	/*  c8h | MSI register for sync./AIF */
>  };
> =20
>  struct src_registers {
> -	struct src_mu_registers MUnit;	/* 00h - c7h */
> +	struct src_mu_registers MUnit;	/* 00h - cbh */
>  	union {
>  		struct {
> -			__le32 reserved1[130790];	/* c8h - 7fc5fh */
> +			__le32 reserved1[130789];	/* cch - 7fc5fh */
>  			struct src_inbound IndexRegs;	/* 7fc60h */
>  		} tupelo;
>  		struct {
> -			__le32 reserved1[974];		/* c8h - fffh */
> +			__le32 reserved1[973];		/* cch - fffh */
>  			struct src_inbound IndexRegs;	/* 1000h */
>  		} denali;
>  	} u;
> @@ -1028,6 +1081,11 @@ struct aac_bus_info_response {
>  #define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
>  #define AAC_OPT_NEW_COMM_TYPE4		cpu_to_le32(1<<31)
> =20
> +/* MSIX context */
> +struct aac_msix_ctx {
> +	int		vector_no;
> +	struct aac_dev	*dev;
> +};
> =20
>  struct aac_dev
>  {
> @@ -1083,8 +1141,9 @@ struct aac_dev
>  						 * if AAC_COMM_MESSAGE_TYPE1 */
> =20
>  	dma_addr_t		host_rrq_pa;	/* phys. address */
> -	u32			host_rrq_idx;	/* index into rrq buffer */
> -
> +	u32			host_rrq_idx[AAC_MAX_MSIX];	/* index into rrq buffer */
> +	atomic_t		rrq_outstanding[AAC_MAX_MSIX];
> +	u32			fibs_pushed_no;
>  	struct pci_dev		*pdev;		/* Our PCI interface */
>  	void *			printfbuf;	/* pointer to buffer used for printf's from the=
 adapter */
>  	void *			comm_addr;	/* Base address of Comm area */
> @@ -1153,6 +1212,11 @@ struct aac_dev
>  	int			sync_mode;
>  	struct fib		*sync_fib;
>  	struct list_head	sync_fib_list;
> +	u32			max_msix;	/* max. MSI-X vectors */
> +	u32			vector_cap;	/* MSI-X vector capab.*/
> +	int			msi_enabled;	/* MSI/MSI-X enabled */
> +	struct msix_entry	msixentry[AAC_MAX_MSIX];
> +	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
>  };
> =20
>  #define aac_adapter_interrupt(dev) \
> @@ -2035,6 +2099,7 @@ void aac_consumer_free(struct aac_dev * dev, st=
ruct aac_queue * q, u32 qnum);  int aac_fib_complete(struct fib * conte=
xt);  #define fib_data(fibctx) ((void *)(fibctx)->hw_fib_va->data)  str=
uct aac_dev *aac_init_adapter(struct aac_dev *dev);
> +void aac_src_access_devreg(struct aac_dev *dev, int mode);
>  int aac_get_config_status(struct aac_dev *dev, int commit_flag);  in=
t aac_get_containers(struct aac_dev *dev);  int aac_scsi_cmd(struct scs=
i_cmnd *cmd); diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/sc=
si/aacraid/comminit.c index 177b094..29c35c8 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -43,6 +43,8 @@
> =20
>  #include "aacraid.h"
> =20
> +static void aac_define_int_mode(struct aac_dev *dev);
> +
>  struct aac_common aac_config =3D {
>  	.irq_mod =3D 1
>  };
> @@ -91,7 +93,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void=
 **commaddr, unsigned long co
>  	init->InitStructRevision =3D cpu_to_le32(ADAPTER_INIT_STRUCT_REVISI=
ON);
>  	if (dev->max_fib_size !=3D sizeof(struct hw_fib))
>  		init->InitStructRevision =3D cpu_to_le32(ADAPTER_INIT_STRUCT_REVIS=
ION_4);
> -	init->MiniPortRevision =3D cpu_to_le32(Sa_MINIPORT_REVISION);
> +	init->NoOfMSIXVectors =3D cpu_to_le32(Sa_MINIPORT_REVISION);
>  	init->fsrev =3D cpu_to_le32(dev->fsrev);
> =20
>  	/*
Now that you switched the field definition from 'MiniPortRevision'
to 'NoOfMSIXVectors', shouldn't you rather introduce a
'Sa_MSIXVECTORS' here instead of using the old definitions?

> @@ -140,7 +142,7 @@ static int aac_alloc_comm(struct aac_dev *dev, vo=
id **commaddr, unsigned long co
>  			INITFLAGS_NEW_COMM_TYPE2_SUPPORTED | INITFLAGS_FAST_JBOD_SUPPORTE=
D);
>  		init->HostRRQ_AddrHigh =3D cpu_to_le32((u32)((u64)dev->host_rrq_pa=
 >> 32));
>  		init->HostRRQ_AddrLow =3D cpu_to_le32((u32)(dev->host_rrq_pa & 0xf=
fffffff));
> -		init->MiniPortRevision =3D cpu_to_le32(0L);		/* number of MSI-X */
> +		init->NoOfMSIXVectors =3D cpu_to_le32(dev->max_msix);	/* number of=
 MSI-X */
>  		dprintk((KERN_WARNING"aacraid: New Comm Interface type2 enabled\n"=
));
>  	}
> =20
> @@ -228,6 +230,11 @@ int aac_send_shutdown(struct aac_dev * dev)
>  	/* FIB should be freed only after getting the response from the F/W=
 */
>  	if (status !=3D -ERESTARTSYS)
>  		aac_fib_free(fibctx);
> +	if ((dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
> +	     dev->pdev->device =3D=3D PMC_DEVICE_S8 ||
> +	     dev->pdev->device =3D=3D PMC_DEVICE_S9) &&
> +	     dev->msi_enabled)
> +		aac_src_access_devreg(dev, AAC_ENABLE_INTX);
>  	return status;
>  }
> =20
> @@ -388,6 +395,8 @@ struct aac_dev *aac_init_adapter(struct aac_dev *=
dev)
>  			}
>  		}
>  	}
> +	dev->max_msix =3D 0;
> +	dev->msi_enabled =3D 0;
>  	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
>  	  0, 0, 0, 0, 0, 0,
>  	  status+0, status+1, status+2, status+3, status+4)) @@ -461,6 +470=
,11 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
>  	if (host->can_queue > AAC_NUM_IO_FIB)
>  		host->can_queue =3D AAC_NUM_IO_FIB;
> =20
> +	if (dev->pdev->device =3D=3D PMC_DEVICE_S6 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S7 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S8 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S9)
> +		aac_define_int_mode(dev);
>  	/*
>  	 *	Ok now init the communication subsystem
>  	 */
> @@ -489,4 +503,70 @@ struct aac_dev *aac_init_adapter(struct aac_dev =
*dev)
>  	return dev;
>  }
> =20
> -   =20
> +static void aac_define_int_mode(struct aac_dev *dev) {
> +
> +	int i, msi_count;
> +
> +	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
> +	if (dev->max_msix =3D=3D 0 ||
> +	    dev->pdev->device =3D=3D PMC_DEVICE_S6 ||
> +	    dev->sync_mode) {
> +		dev->max_msix =3D 1;
> +		dev->vector_cap =3D dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FI=
B;
> +		return;
> +	}
> +
> +	msi_count =3D min(dev->max_msix,
> +		(unsigned int)num_online_cpus());
> +
> +	dev->max_msix =3D msi_count;
> +
> +	if (msi_count > AAC_MAX_MSIX)
> +		msi_count =3D AAC_MAX_MSIX;
> +
> +	for (i =3D 0; i < msi_count; i++)
> +		dev->msixentry[i].entry =3D i;
> +
> +	if (msi_count > 1 && pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX=
))=20
> +{
> +
Braces should be at the same line as the condition.

> +		i =3D pci_enable_msix(dev->pdev, dev->msixentry, msi_count);
> +		 /* Check how many MSIX vectors are allocated */
> +		if (i >=3D 0) {
> +			dev->msi_enabled =3D 1;
> +			if (i) {
> +				msi_count =3D i;
> +				if (pci_enable_msix(dev->pdev, dev->msixentry, msi_count)) {
> +					dev->msi_enabled =3D 0;
> +					printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\=
n",
> +							dev->name, dev->id, i);
> +				}
> +			}
> +		} else {
> +			dev->msi_enabled =3D 0;
> +			printk(KERN_ERR "%s%d: MSIX not supported!! Will try MSI 0x%x.\n"=
,
> +					dev->name, dev->id, i);
> +		}
> +	}
> +
> +	if (!dev->msi_enabled) {
> +		msi_count =3D 1;
> +		i =3D !pci_enable_msi(dev->pdev);
> +

Yikes. Please don't do that; use (!i) in the condition instead.

> +		if (i) {
> +			dev->msi_enabled =3D 1;
> +			dev->msi =3D 1;
> +		} else {
> +			printk(KERN_ERR "%s%d: MSI not supported!! Will try INTx 0x%x.\n"=
,
> +					dev->name, dev->id, i);
> +		}
> +	}
> +
> +	if (!dev->msi_enabled)
> +		dev->max_msix =3D msi_count =3D 1;
> +	else {
> +		if (dev->max_msix > msi_count)
> +			dev->max_msix =3D msi_count;
> +	}
> +	dev->vector_cap =3D (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FI=
B) /=20
> +msi_count; }
Closing braces should be on an individual line.

Also here: please remember to run checkpatch before submitting.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
