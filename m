From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 3/5] scsi: ufs: amend interrupt configuration
Date: Thu, 02 May 2013 16:00:00 +0900
Message-ID: <002a01ce4702$a9fa1a50$fdee4ef0$%jun@samsung.com>
References: <001f01ce4105$af6a3c20$0e3eb460$%jun@samsung.com>
 <517FB022.1060400@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:23293 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3EBHAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 03:00:02 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MM500JIGSS1XEK0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Thu, 02 May 2013 16:00:01 +0900 (KST)
In-reply-to: <517FB022.1060400@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Tuesday, April 30, 2013, Subhash Jadavani wrote:
> Patch looks good but one minor comment below.
> 
> On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
> > It makes interrupt setting more flexible especially
> > for disabling. And wrong bit mask is fixed for ver 1.0.
> > [17:16] is added for mask.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufshcd.c |   86 ++++++++++++++++++++++++++++++++-------------
> >   drivers/scsi/ufs/ufshcd.h |    4 +-
> >   drivers/scsi/ufs/ufshci.h |    5 ++-
> >   3 files changed, 66 insertions(+), 29 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b6c19b0..efe2256 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -35,6 +35,10 @@
> >
> >   #include "ufshcd.h"
> >
> > +#define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
> > +				 UTP_TASK_REQ_COMPL |\
> > +				 UFSHCD_ERROR_MASK)
> > +
> 
> I don't see any use of this macro in this patch. could you please remove
> it or move it to the patch-set where its really being used.
Good point. I'll apply it.

Thanks,
Seungwon Jeon
> 
> >   enum {
> >   	UFSHCD_MAX_CHANNEL	= 0,
> >   	UFSHCD_MAX_ID		= 1,
> > @@ -64,6 +68,20 @@ enum {
> >   };
> >
> >   /**
> > + * ufshcd_get_intr_mask - Get the interrupt bit mask
> > + * @hba - Pointer to adapter instance
> > + *
> > + * Returns interrupt bit mask per version
> > + */
> > +static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
> > +{
> > +	if (hba->ufs_version == UFSHCI_VERSION_10)
> > +		return INTERRUPT_MASK_ALL_VER_10;
> > +	else
> > +		return INTERRUPT_MASK_ALL_VER_11;
> > +}
> > +
> > +/**
> >    * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
> >    * @hba - Pointer to adapter instance
> >    *
> > @@ -397,25 +415,45 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
> >   }
> >
> >   /**
> > - * ufshcd_int_config - enable/disable interrupts
> > + * ufshcd_enable_intr - enable interrupts
> >    * @hba: per adapter instance
> > - * @option: interrupt option
> > + * @intrs: interrupt bits
> >    */
> > -static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
> > +static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
> >   {
> > -	switch (option) {
> > -	case UFSHCD_INT_ENABLE:
> > -		ufshcd_writel(hba, REG_INTERRUPT_ENABLE, hba->int_enable_mask);
> > -		break;
> > -	case UFSHCD_INT_DISABLE:
> > -		if (hba->ufs_version == UFSHCI_VERSION_10)
> > -			ufshcd_writel(hba, REG_INTERRUPT_ENABLE,
> > -				      INTERRUPT_DISABLE_MASK_10);
> > -		else
> > -			ufshcd_writel(hba, REG_INTERRUPT_ENABLE,
> > -				      INTERRUPT_DISABLE_MASK_11);
> > -		break;
> > +	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> > +
> > +	if (hba->ufs_version == UFSHCI_VERSION_10) {
> > +		u32 rw;
> > +		rw = set & INTERRUPT_MASK_RW_VER_10;
> > +		set = rw | ((set ^ intrs) & intrs);
> > +	} else {
> > +		set |= intrs;
> > +	}
> > +
> > +	ufshcd_writel(hba, REG_INTERRUPT_ENABLE, set);
> > +}
> > +
> > +/**
> > + * ufshcd_disable_intr - disable interrupts
> > + * @hba: per adapter instance
> > + * @intrs: interrupt bits
> > + */
> > +static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
> > +{
> > +	u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> > +
> > +	if (hba->ufs_version == UFSHCI_VERSION_10) {
> > +		u32 rw;
> > +		rw = (set & INTERRUPT_MASK_RW_VER_10) &
> > +			~(intrs & INTERRUPT_MASK_RW_VER_10);
> > +		set = rw | ((set & intrs) & ~INTERRUPT_MASK_RW_VER_10);
> > +
> > +	} else {
> > +		set &= ~intrs;
> >   	}
> > +
> > +	ufshcd_writel(hba, REG_INTERRUPT_ENABLE, set);
> >   }
> >
> >   /**
> > @@ -717,8 +755,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
> >   	uic_cmd->argument3 = 0;
> >
> >   	/* enable UIC related interrupts */
> > -	hba->int_enable_mask |= UIC_COMMAND_COMPL;
> > -	ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
> > +	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> >
> >   	/* sending UIC commands to controller */
> >   	ufshcd_send_uic_command(hba, uic_cmd);
> > @@ -765,13 +802,9 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
> >   	}
> >
> >   	/* Enable required interrupts */
> > -	hba->int_enable_mask |= (UTP_TRANSFER_REQ_COMPL |
> > -				 UIC_ERROR |
> > -				 UTP_TASK_REQ_COMPL |
> > -				 DEVICE_FATAL_ERROR |
> > -				 CONTROLLER_FATAL_ERROR |
> > -				 SYSTEM_BUS_FATAL_ERROR);
> > -	ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
> > +	ufshcd_enable_intr(hba, UTP_TRANSFER_REQ_COMPL | UIC_ERROR |
> > +			   UTP_TASK_REQ_COMPL | DEVICE_FATAL_ERROR |
> > +			   CONTROLLER_FATAL_ERROR | SYSTEM_BUS_FATAL_ERROR);
> >
> >   	/* Configure interrupt aggregation */
> >   	ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
> > @@ -1578,7 +1611,7 @@ static void ufshcd_hba_free(struct ufs_hba *hba)
> >   void ufshcd_remove(struct ufs_hba *hba)
> >   {
> >   	/* disable interrupts */
> > -	ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
> > +	ufshcd_disable_intr(hba, hba->intr_mask);
> >
> >   	ufshcd_hba_stop(hba);
> >   	ufshcd_hba_free(hba);
> > @@ -1636,6 +1669,9 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
> >   	/* Get UFS version supported by the controller */
> >   	hba->ufs_version = ufshcd_get_ufs_version(hba);
> >
> > +	/* Get Interrupt bit mask per version */
> > +	hba->intr_mask = ufshcd_get_intr_mask(hba);
> > +
> >   	/* Allocate memory for host memory space */
> >   	err = ufshcd_memory_alloc(hba);
> >   	if (err) {
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 6728450..87d5a94 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -139,7 +139,7 @@ struct ufshcd_lrb {
> >    * @ufshcd_tm_wait_queue: wait queue for task management
> >    * @tm_condition: condition variable for task management
> >    * @ufshcd_state: UFSHCD states
> > - * @int_enable_mask: Interrupt Mask Bits
> > + * @intr_mask: Interrupt Mask Bits
> >    * @uic_workq: Work queue for UIC completion handling
> >    * @feh_workq: Work queue for fatal controller error handling
> >    * @errors: HBA errors
> > @@ -176,7 +176,7 @@ struct ufs_hba {
> >   	unsigned long tm_condition;
> >
> >   	u32 ufshcd_state;
> > -	u32 int_enable_mask;
> > +	u32 intr_mask;
> >
> >   	/* Work Queues */
> >   	struct work_struct uic_workq;
> > diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> > index 0c16484..d5c5f14 100644
> > --- a/drivers/scsi/ufs/ufshci.h
> > +++ b/drivers/scsi/ufs/ufshci.h
> > @@ -232,10 +232,11 @@ enum {
> >   /* Interrupt disable masks */
> >   enum {
> >   	/* Interrupt disable mask for UFSHCI v1.0 */
> > -	INTERRUPT_DISABLE_MASK_10	= 0xFFFF,
> > +	INTERRUPT_MASK_ALL_VER_10	= 0x30FFF,
> > +	INTERRUPT_MASK_RW_VER_10	= 0x30000,
> >
> >   	/* Interrupt disable mask for UFSHCI v1.1 */
> > -	INTERRUPT_DISABLE_MASK_11	= 0x0,
> > +	INTERRUPT_MASK_ALL_VER_11	= 0x31FFF,
> >   };
> >
> >   /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

