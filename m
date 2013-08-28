From: "Yaniv Gardi" <ygardi@codeaurora.org>
Subject: RE: [PATCH v3 5/6] scsi: ufs: add operation for the uic power mode change
Date: Wed, 28 Aug 2013 15:45:20 +0300
Message-ID: <009d01cea3ec$77b716a0$672543e0$@codeaurora.org>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com> <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com> <003a01cea26a$46905420$d3b0fc60$%jun@samsung.com> <521C770F.4020300@codeaurora.org> <000f01cea318$7d901420$78b03c60$%jun@samsung.com> <521C91ED.5000702@codeaurora.org> <001101cea31c$b958a810$2c09f830$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48651 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab3H1Mp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 08:45:28 -0400
In-Reply-To: <001101cea31c$b958a810$2c09f830$%jun@samsung.com>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Seungwon Jeon' <tgih.jun@samsung.com>, 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

Tested-by: Yaniv Gardi <ygardi@codeaurora.org>

QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


= > -----Original Message-----
= > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
= > owner@vger.kernel.org] On Behalf Of Seungwon Jeon
= > Sent: Tuesday, August 27, 2013 2:58 PM
= > To: 'Subhash Jadavani'
= > Cc: linux-scsi@vger.kernel.org; 'Vinayak Holikatti'; 'Santosh Y'; 'James E.J.
= > Bottomley'
= > Subject: RE: [PATCH v3 5/6] scsi: ufs: add operation for the uic power
= > mode change
= > 
= > On Tue, August 27, 2013, Subhash Jadavani wrote:
= > > On 8/27/2013 4:58 PM, Seungwon Jeon wrote:
= > > > On Tue, August 27, 2013, Subhash Jadavani wrote:
= > > >> On 8/26/2013 8:10 PM, Seungwon Jeon wrote:
= > > >>> Setting PA_PWRMode using DME_SET triggers the power mode
= > change.
= > > >>> And then the result will be given by the HCS.UPMCRS.
= > > >>> This operation should be done atomically.
= > > >>>
= > > >>> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
= > > >>> ---
= > > >>>    drivers/scsi/ufs/ufshcd.c |   84
= > ++++++++++++++++++++++++++++++++++++++++++--
= > > >>>    drivers/scsi/ufs/ufshcd.h |    3 ++
= > > >>>    drivers/scsi/ufs/ufshci.h |   12 ++++++
= > > >>>    3 files changed, 95 insertions(+), 4 deletions(-)
= > > >>>
= > > >>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
= > > >>> index 00bfc1a..c67118d 100644
= > > >>> --- a/drivers/scsi/ufs/ufshcd.c
= > > >>> +++ b/drivers/scsi/ufs/ufshcd.c
= > > >>> @@ -36,9 +36,11 @@
= > > >>>    #include <linux/async.h>
= > > >>>
= > > >>>    #include "ufshcd.h"
= > > >>> +#include "unipro.h"
= > > >>>
= > > >>>    #define UFSHCD_ENABLE_INTRS
= > 	(UTP_TRANSFER_REQ_COMPL |\
= > > >>>    				 UTP_TASK_REQ_COMPL |\
= > > >>> +				 UIC_POWER_MODE |\
= > > >>>    				 UFSHCD_ERROR_MASK)
= > > >>>    /* UIC command timeout, unit: ms */
= > > >>>    #define UIC_CMD_TIMEOUT	500
= > > >>> @@ -520,6 +522,18 @@ static inline bool
= > ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
= > > >>>    }
= > > >>>
= > > >>>    /**
= > > >>> + * ufshcd_get_upmcrs - Get the power mode change request status
= > > >>> + * @hba: Pointer to adapter instance
= > > >>> + *
= > > >>> + * This function gets the UPMCRS field of HCS register
= > > >>> + * Returns value of UPMCRS field
= > > >>> + */
= > > >>> +static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba) {
= > > >>> +	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) >> 8) & 0x7;
= > }
= > > >>> +
= > > >>> +/**
= > > >>>     * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro
= > layers
= > > >>>     * @hba: per adapter instance
= > > >>>     * @uic_cmd: UIC command
= > > >>> @@ -1526,6 +1540,64 @@ out:
= > > >>>    EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
= > > >>>
= > > >>>    /**
= > > >>> + * ufshcd_uic_change_pwr_mode - Perform the UIC power mode
= > chage
= > > >>> + *				using DME_SET primitives.
= > > >>> + * @hba: per adapter instance
= > > >>> + * @mode: powr mode value
= > > >>> + *
= > > >>> + * Returns 0 on success, non-zero value on failure  */ int
= > > >>> +ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode) {
= > > >>> +	struct uic_command uic_cmd = {0};
= > > >>> +	struct completion pwr_done;
= > > >>> +	unsigned long flags;
= > > >>> +	u8 status;
= > > >>> +	int ret;
= > > >>> +
= > > >>> +	uic_cmd.command = UIC_CMD_DME_SET;
= > > >>> +	uic_cmd.argument1 = UIC_ARG_MIB(PA_PWRMODE);
= > > >>> +	uic_cmd.argument3 = mode;
= > > >>> +	init_completion(&pwr_done);
= > > >>> +
= > > >>> +	mutex_lock(&hba->uic_cmd_mutex);
= > > >>> +
= > > >>> +	spin_lock_irqsave(hba->host->host_lock, flags);
= > > >>> +	hba->pwr_done = &pwr_done;
= > > >>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > >>> +	ret = __ufshcd_send_uic_cmd(hba, &uic_cmd);
= > > >>> +	if (ret) {
= > > >>> +		dev_err(hba->dev,
= > > >>> +			"pwr mode change with mode 0x%x uic error
= > %d\n",
= > > >>> +			mode, ret);
= > > >>> +		goto out;
= > > >>> +	}
= > > >>> +
= > > >>> +	if (!wait_for_completion_timeout(hba->pwr_done,
= > > >>> +
= > msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
= > > >>> +		dev_err(hba->dev,
= > > >>> +			"pwr mode change with mode 0x%x completion
= > timeout\n",
= > > >>> +			mode);
= > > >>> +		ret = -ETIMEDOUT;
= > > >>> +		goto out;
= > > >>> +	}
= > > >>> +
= > > >>> +	status = ufshcd_get_upmcrs(hba);
= > > >> I have a doubt on the relation between UIC Power Mode Status
= > (UPMS)
= > > >> bit & UIC Power Mode Change Request Status (UPMCRS) field.
= > > >>
= > > >> Once we send the DME_SET(PA_PWRMODE) command, we will get
= > the UIC
= > > >> command completion interrupt (with IS.UCCS bit set) which just
= > > >> indicate that the attribute is written but power mode change
= > > >> procedure will complete only after some delay which is indicated
= > > >> via IS.UPMS status bit and then we would read the HCS.UPMCRS field
= > > >> to know the status of power mode change.
= > > >>
= > > >> This is my exact doubt: Currently UFSHCD driver first clears the
= > > >> IS.UPMS bit (ufshcd_intr() first clears the current interrupts in
= > > >> REG_INTERRUPT_STATUS and then calls the ufshcd_sl_intr() handler,
= > > >> and in your current patch we are anyway not reading the UPMCRS
= > > >> field from interrupt contex ) and then read the HCS.UPMCRS field.
= > > >> Will HCS.UPMCRS field retain its status value even after IS.UPMS
= > > >> bit is cleared? UFSHCI specification doesn't clearly mention this
= > > >> so either we have to get the clarity from JEDEC or from your ufs
= > > >> host controller vendor on the behaviour. I am checking with our ufs
= > > >> host controller vendor as well and will let you know what is the
= > > >> expected behaviour. BTW, i guess you might have already tested this
= > patch to be working on your UFS host controller?
= > > > Hi Subhash,
= > > >
= > > > Yes, It's already tested and works fine.
= > > > IS.UPMS is a indication to inform the result of 'power mode
= > change'(UPMCRS).
= > > > So clearing the interrupt would not affect this result.
= > > Thanks for clarifying.
= > >
= > > > Generally it seems not common idea.
= > >
= > > Infact on SDHCi controller, there is a case where "auto-cmd error
= > > status" register fields are only valid when the "auto-cmd error"
= > > interrupt bit is set in interrupt status register. Clearing status bit
= > > also clears the "auto-cmd error status" register fields automatically.
= > > So i was in doubt whether similar could be the case here or not.
= > 
= > It's interesting thing to me.
= > 
= > >
= > > > Anyway, if your host has different behavior, please let me know.
= > >
= > > Sure, checking on this. Would let you know soon. BTW, UFSHCI
= > > specification doesn't mention it clearly so it could be implementation
= > > dependent as well and if it is the case, we might have to change it
= > > later to accomodate the different implementation. So for now, you have
= > > my Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
= > 
= > Thank you for review.
= > 
= > Seungwon Jeon
= > 
= > >
= > > >
= > > > Thanks,
= > > > Seungwon Jeon
= > > >
= > > >>> +	if (status != PWR_LOCAL) {
= > > >>> +		dev_err(hba->dev,
= > > >>> +			"pwr mode change failed, host umpcrs:0x%x\n",
= > > >>> +			status);
= > > >>> +		ret = (status != PWR_OK) ? status : -1;
= > > >>> +	}
= > > >>> +out:
= > > >>> +	spin_lock_irqsave(hba->host->host_lock, flags);
= > > >>> +	hba->pwr_done = NULL;
= > > >>> +	spin_unlock_irqrestore(hba->host->host_lock, flags);
= > > >>> +	mutex_unlock(&hba->uic_cmd_mutex);
= > > >>> +	return ret;
= > > >>> +}
= > > >>> +
= > > >>> +/**
= > > >>>     * ufshcd_complete_dev_init() - checks device readiness
= > > >>>     * hba: per-adapter instance
= > > >>>     *
= > > >>> @@ -1992,16 +2064,20 @@ ufshcd_transfer_rsp_status(struct
= > ufs_hba *hba, struct ufshcd_lrb *lrbp)
= > > >>>    /**
= > > >>>     * ufshcd_uic_cmd_compl - handle completion of uic command
= > > >>>     * @hba: per adapter instance
= > > >>> + * @intr_status: interrupt status generated by the controller
= > > >>>     */
= > > >>> -static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
= > > >>> +static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32
= > > >>> +intr_status)
= > > >>>    {
= > > >>> -	if (hba->active_uic_cmd) {
= > > >>> +	if ((intr_status & UIC_COMMAND_COMPL) && hba-
= > >active_uic_cmd) {
= > > >>>    		hba->active_uic_cmd->argument2 |=
= > > >>>    			ufshcd_get_uic_cmd_result(hba);
= > > >>>    		hba->active_uic_cmd->argument3 =
= > > >>>    			ufshcd_get_dme_attr_val(hba);
= > > >>>    		complete(&hba->active_uic_cmd->done);
= > > >>>    	}
= > > >>> +
= > > >>> +	if ((intr_status & UIC_POWER_MODE) && hba->pwr_done)
= > > >>> +		complete(hba->pwr_done);
= > > >>>    }
= > > >>>
= > > >>>    /**
= > > >>> @@ -2451,8 +2527,8 @@ static void ufshcd_sl_intr(struct ufs_hba
= > *hba, u32 intr_status)
= > > >>>    	if (hba->errors)
= > > >>>    		ufshcd_check_errors(hba);
= > > >>>
= > > >>> -	if (intr_status & UIC_COMMAND_COMPL)
= > > >>> -		ufshcd_uic_cmd_compl(hba);
= > > >>> +	if (intr_status & UFSHCD_UIC_MASK)
= > > >>> +		ufshcd_uic_cmd_compl(hba, intr_status);
= > > >>>
= > > >>>    	if (intr_status & UTP_TASK_REQ_COMPL)
= > > >>>    		ufshcd_tmc_handler(hba);
= > > >>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
= > > >>> index ab1518d..ecff83d 100644
= > > >>> --- a/drivers/scsi/ufs/ufshcd.h
= > > >>> +++ b/drivers/scsi/ufs/ufshcd.h
= > > >>> @@ -178,6 +178,7 @@ struct ufs_dev_cmd {
= > > >>>     * @tm_tag_wq: wait queue for free task management slots
= > > >>>     * @tm_condition: condition variable for task management
= > > >>>     * @tm_slots_in_use: bit map of task management request slots
= > > >>> in use
= > > >>> + * @pwr_done: completion for power mode change
= > > >>>     * @ufshcd_state: UFSHCD states
= > > >>>     * @eh_flags: Error handling flags
= > > >>>     * @intr_mask: Interrupt Mask Bits @@ -227,6 +228,8 @@ struct
= > > >>> ufs_hba {
= > > >>>    	unsigned long tm_condition;
= > > >>>    	unsigned long tm_slots_in_use;
= > > >>>
= > > >>> +	struct completion *pwr_done;
= > > >>> +
= > > >>>    	u32 ufshcd_state;
= > > >>>    	u32 eh_flags;
= > > >>>    	u32 intr_mask;
= > > >>> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
= > > >>> index 1e1fe26..0475c66 100644
= > > >>> --- a/drivers/scsi/ufs/ufshci.h
= > > >>> +++ b/drivers/scsi/ufs/ufshci.h
= > > >>> @@ -124,6 +124,9 @@ enum {
= > > >>>    #define CONTROLLER_FATAL_ERROR
= > 	UFS_BIT(16)
= > > >>>    #define SYSTEM_BUS_FATAL_ERROR
= > 	UFS_BIT(17)
= > > >>>
= > > >>> +#define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL
= > |\
= > > >>> +				 UIC_POWER_MODE)
= > > >>> +
= > > >>>    #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
= > > >>>    				DEVICE_FATAL_ERROR |\
= > > >>>    				CONTROLLER_FATAL_ERROR |\
= > > >>> @@ -142,6 +145,15 @@ enum {
= > > >>>    #define DEVICE_ERROR_INDICATOR			UFS_BIT(5)
= > > >>>    #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK
= > 	UFS_MASK(0x7, 8)
= > > >>>
= > > >>> +enum {
= > > >>> +	PWR_OK		= 0x0,
= > > >>> +	PWR_LOCAL	= 0x01,
= > > >>> +	PWR_REMOTE	= 0x02,
= > > >>> +	PWR_BUSY	= 0x03,
= > > >>> +	PWR_ERROR_CAP	= 0x04,
= > > >>> +	PWR_FATAL_ERROR	= 0x05,
= > > >>> +};
= > > >>> +
= > > >>>    /* HCE - Host Controller Enable 34h */
= > > >>>    #define CONTROLLER_ENABLE	UFS_BIT(0)
= > > >>>    #define CONTROLLER_DISABLE	0x0
= > > >> --
= > > >> To unsubscribe from this list: send the line "unsubscribe
= > > >> linux-scsi" in the body of a message to majordomo@vger.kernel.org
= > > >> More majordomo info at  http://vger.kernel.org/majordomo-
= > info.html
= > > > --
= > > > To unsubscribe from this list: send the line "unsubscribe
= > > > linux-scsi" in the body of a message to majordomo@vger.kernel.org
= > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
= > >
= > > --
= > > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
= > > in the body of a message to majordomo@vger.kernel.org More
= > majordomo
= > > info at  http://vger.kernel.org/majordomo-info.html
= > 
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html

