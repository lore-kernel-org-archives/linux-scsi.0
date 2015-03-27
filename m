From: Johannes Thumshirn <morbidrsa@gmail.com>
Subject: Re: [V2 PATCH 04/11] aacraid: MSI-x support
Date: Fri, 27 Mar 2015 14:28:36 +0100
Message-ID: <874mp6zi0r.fsf@sauron.fritz.box>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
	<1427380892-1978-5-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38623 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbbC0N2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 09:28:07 -0400
Received: by wibgn9 with SMTP id gn9so31266154wib.1
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 06:28:06 -0700 (PDT)
In-Reply-To: <1427380892-1978-5-git-send-email-Mahesh.Rajashekhara@pmcs.com>
	(Mahesh Rajashekhara's message of "Thu, 26 Mar 2015 10:41:25 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Achim.Leubner@pmcs.com

Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com> writes:

> Add MSI-x interrupt mode support.
>
> Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
> ---
>  drivers/scsi/aacraid/aacraid.h  |   80 ++++++++-
>  drivers/scsi/aacraid/comminit.c |   95 +++++++++-
>  drivers/scsi/aacraid/commsup.c  |   20 ++-
>  drivers/scsi/aacraid/dpcsup.c   |    9 +-
>  drivers/scsi/aacraid/linit.c    |   20 ++-
>  drivers/scsi/aacraid/src.c      |  388 ++++++++++++++++++++++++++++++---------
>  6 files changed, 505 insertions(+), 107 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index 9e38b20..015c341 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -6,11 +6,61 @@
>  #define nblank(x) _nblank(x)[0]
>  
>  #include <linux/interrupt.h>
> +#include <linux/pci.h>
>  
>  /*------------------------------------------------------------------------------
>   *              D E F I N E S
>   *----------------------------------------------------------------------------*/
>  
> +#define AAC_MAX_MSIX		32	/* vectors */
> +#define AAC_PCI_MSI_ENABLE	0x8000
> +
> +enum {
> +	AAC_ENABLE_INTERRUPT	= 0x0,
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
> +#define PMC_TRANSITION_TO_OPERATIONAL	(1<<31)
> +#define PMC_IOARCB_TRANSFER_FAILED	(1<<28)
> +#define PMC_IOA_UNIT_CHECK		(1<<27)
> +#define PMC_NO_HOST_RRQ_FOR_CMD_RESPONSE (1<<26)
> +#define PMC_CRITICAL_IOA_OP_IN_PROGRESS	(1<<25)
> +#define PMC_IOARRIN_LOST		(1<<4)
> +#define PMC_SYSTEM_BUS_MMIO_ERROR	(1<<3)
> +#define PMC_IOA_PROCESSOR_IN_ERROR_STATE (1<<2)
> +#define PMC_HOST_RRQ_VALID		(1<<1)
> +#define PMC_OPERATIONAL_STATUS		(1<<31)
> +#define PMC_ALLOW_MSIX_VECTOR0		(1<<0)
> +
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
>  
> +#define PMC_DEVICE_S6	0x28b
>  #define PMC_DEVICE_S7	0x28c
>  #define PMC_DEVICE_S8	0x28d
>  #define PMC_DEVICE_S9	0x28f
> @@ -434,7 +485,7 @@ enum fib_xfer_state {
>  struct aac_init
>  {
>  	__le32	InitStructRevision;
> -	__le32	MiniPortRevision;
> +	__le32	Sa_MSIXVectors;
>  	__le32	fsrev;
>  	__le32	CommHeaderAddress;
>  	__le32	FastIoCommAreaAddress;
> @@ -755,7 +806,8 @@ struct rkt_registers {
>  
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
>  
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
> @@ -1029,6 +1082,11 @@ struct aac_bus_info_response {
>  #define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
>  #define AAC_OPT_NEW_COMM_TYPE4		cpu_to_le32(1<<31)
>  
> +/* MSIX context */
> +struct aac_msix_ctx {
> +	int		vector_no;
> +	struct aac_dev	*dev;
> +};
>  
>  struct aac_dev
>  {
> @@ -1084,8 +1142,10 @@ struct aac_dev
>  						 * if AAC_COMM_MESSAGE_TYPE1 */
>  
>  	dma_addr_t		host_rrq_pa;	/* phys. address */
> -	u32			host_rrq_idx;	/* index into rrq buffer */
> -
> +	/* index into rrq buffer */
> +	u32			host_rrq_idx[AAC_MAX_MSIX];
> +	atomic_t		rrq_outstanding[AAC_MAX_MSIX];
> +	u32			fibs_pushed_no;
>  	struct pci_dev		*pdev;		/* Our PCI interface */
>  	void *			printfbuf;	/* pointer to buffer used for printf's from the adapter */
>  	void *			comm_addr;	/* Base address of Comm area */
> @@ -1154,6 +1214,11 @@ struct aac_dev
>  	int			sync_mode;
>  	struct fib		*sync_fib;
>  	struct list_head	sync_fib_list;
> +	u32			max_msix;	/* max. MSI-X vectors */
> +	u32			vector_cap;	/* MSI-X vector capab.*/
> +	int			msi_enabled;	/* MSI/MSI-X enabled */

Is there a specific reason why you're not using the msi_enabled /
msix_enabled field of struct pci_dev, or even calling
pci_dev_msi_enabled() instead of duplicating it here?

Thanks,
        Johannes

