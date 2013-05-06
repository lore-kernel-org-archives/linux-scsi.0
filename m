From: merez@codeaurora.org
Subject: Re: [PATCH v2 7/7] scsi: ufs: add dme control primitives
Date: Mon, 6 May 2013 03:41:04 -0700
Message-ID: <f37d5b37e4a2cf026723cb36572c9878.squirrel@www.codeaurora.org>
References: <002201ce4105$b6a26120$23e72360$%jun@samsung.com>
    <000f01ce48a3$c74d8ae0$55e8a0a0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50521 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3EFKlF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 06:41:05 -0400
In-Reply-To: <000f01ce48a3$c74d8ae0$55e8a0a0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

Tested-by: Maya Erez <merez@codeaurora.org>

> Implements to support the following operations.
> Currently, this patch doesn't introduce DME_ENABLE and DME_RESET
> because host controller's HCE enable contains these roles.
>
> DME_POWERON{OFF}, DME_HIBERNATE_ENTER{EXIT}, DME_ENDPOINTRESET.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |  133
> ++++++++++++++++++++++++++++++++++++++++++---
>  drivers/scsi/ufs/ufshcd.h |   26 +++++++++
>  drivers/scsi/ufs/ufshci.h |   15 +++++
>  3 files changed, 166 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 956041c..54cd61a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -39,6 +39,7 @@
>
>  #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
>  				 UTP_TASK_REQ_COMPL |\
> +				 UFSHCD_HIBERNATE_MASK |\
>  				 UFSHCD_ERROR_MASK)
>  /* UIC command timeout, unit: ms */
>  #define UIC_CMD_TIMEOUT	500
> @@ -203,6 +204,18 @@ static inline u32 ufshcd_get_dme_attr_val(struct
> ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_get_upmcrs - Get the power mode change request status
> + * @hba: Pointer to adapter instance
> + *
> + * This function gets the UPMCRS field of HCS register
> + * Returns value of UPMCRS field
> + */
> +static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
> +{
> +	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) >> 8) & 0x7;
> +}
> +
> +/**
>   * ufshcd_free_hba_memory - Free allocated memory for LRB, request
>   *			    and task lists
>   * @hba: Pointer to adapter instance
> @@ -1161,6 +1174,104 @@ int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32
> attr_sel,
>  EXPORT_SYMBOL_GPL(ufshcd_dme_xxx_get);
>
>  /**
> + * ufshcd_dme_power_xxx - UIC command for DME_POWERON, DME_POWEROFF
> + * @hba: per adapter instance
> + * @on: indicate wherter power_on or power_off
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_power_xxx(struct ufs_hba *hba, u8 on)
> +{
> +	struct uic_command uic_cmd = {0};
> +	static const char *const action[] = {
> +		"dme-power-off",
> +		"dme-power-on"
> +	};
> +	const char *power = action[!!on];
> +	int ret;
> +
> +	uic_cmd.command = on ?
> +		UIC_CMD_DME_POWERON : UIC_CMD_DME_POWEROFF;
> +
> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +	if (ret)
> +		dev_err(hba->dev, "%s: error code %d\n", power, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_power_xxx);
> +
> +/**
> + * ufshcd_dme_hibern8_xxx - UIC command for DME_HIBERNATE_ENTER,
> + *			    DME_HIBERNATE_EXIT
> + * @hba: per adapter instance
> + * @enter: indicate wherter hibernation enter or exit
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_hibern8_xxx(struct ufs_hba *hba, u8 enter)
> +{
> +	struct uic_command uic_cmd = {0};
> +	static const char *const action[] = {
> +		"dme-hibernate-exit",
> +		"dme-hibernate-enter"
> +	};
> +	const char *hibern8 = action[!!enter];
> +	u8 status;
> +	int ret;
> +
> +	uic_cmd.command = enter ?
> +		UIC_CMD_DME_HIBER_ENTER : UIC_CMD_DME_HIBER_EXIT;
> +
> +	mutex_lock(&hba->uic_cmd_mutex);
> +	ret = __ufshcd_send_uic_cmd(hba, &uic_cmd);
> +	if (ret) {
> +		dev_err(hba->dev, "%s: error code %d\n", hibern8, ret);
> +		goto out;
> +	}
> +
> +	init_completion(&hba->hibern8_done);
> +
> +	if (wait_for_completion_timeout(&hba->hibern8_done,
> +					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
> +		status = ufshcd_get_upmcrs(hba);
> +		if (status != PWR_LOCAL) {
> +			dev_err(hba->dev, "%s: failed, host upmcrs:%x\n",
> +				hibern8, status);
> +			ret = status;
> +		}
> +	} else {
> +		dev_err(hba->dev, "%s: timeout\n", hibern8);
> +		ret = -ETIMEDOUT;
> +	}
> +out:
> +	mutex_unlock(&hba->uic_cmd_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_hibern8_xxx);
> +
> +/**
> + * ufshcd_dme_endpt_reset - UIC command for DME_ENDPOINTRESET
> + * @hba: per adapter instance
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_endpt_reset(struct ufs_hba *hba)
> +{
> +	struct uic_command uic_cmd = {0};
> +	int ret;
> +
> +	uic_cmd.command = UIC_CMD_DME_END_PT_RST;
> +
> +	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +	if (ret)
> +		dev_err(hba->dev, "endpoint reset: error code %d\n", ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_endpt_reset);
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -1617,14 +1728,20 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  /**
>   * ufshcd_uic_cmd_compl - handle completion of uic command
>   * @hba: per adapter instance
> + * @intr_status: interrupt status generated by the controller
>   */
> -static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
> +static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>  {
> -	hba->active_uic_cmd->argument2 |=
> -		ufshcd_get_uic_cmd_result(hba);
> -	hba->active_uic_cmd->argument3 =
> -		ufshcd_get_dme_attr_val(hba);
> -	complete(&hba->active_uic_cmd->done);
> +	if (intr_status & UIC_COMMAND_COMPL) {
> +		hba->active_uic_cmd->argument2 |=
> +			ufshcd_get_uic_cmd_result(hba);
> +		hba->active_uic_cmd->argument3 =
> +			ufshcd_get_dme_attr_val(hba);
> +		complete(&hba->active_uic_cmd->done);
> +	}
> +
> +	if (intr_status & UFSHCD_HIBERNATE_MASK)
> +		complete(&hba->hibern8_done);
>  }
>
>  /**
> @@ -1726,8 +1843,8 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32
> intr_status)
>  	if (hba->errors)
>  		ufshcd_err_handler(hba);
>
> -	if (intr_status & UIC_COMMAND_COMPL)
> -		ufshcd_uic_cmd_compl(hba);
> +	if (intr_status & UFSHCD_UIC_MASK)
> +		ufshcd_uic_cmd_compl(hba, intr_status);
>
>  	if (intr_status & UTP_TASK_REQ_COMPL)
>  		ufshcd_tmc_handler(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b47de70..c60f5f1 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -156,6 +156,7 @@ struct ufs_query {
>   * @uic_cmd_mutex: mutex for uic command
>   * @ufshcd_tm_wait_queue: wait queue for task management
>   * @tm_condition: condition variable for task management
> + * @hibern8_done: completion for hibernate
>   * @ufshcd_state: UFSHCD states
>   * @intr_mask: Interrupt Mask Bits
>   * @feh_workq: Work queue for fatal controller error handling
> @@ -195,6 +196,8 @@ struct ufs_hba {
>  	wait_queue_head_t ufshcd_tm_wait_queue;
>  	unsigned long tm_condition;
>
> +	struct completion hibern8_done;
> +
>  	u32 ufshcd_state;
>  	u32 intr_mask;
>
> @@ -221,6 +224,9 @@ extern int ufshcd_dme_xxx_set(struct ufs_hba *hba, u32
> attr_sel,
>  			      u8 attr_set, u32 mib_val, u8 peer);
>  extern int ufshcd_dme_xxx_get(struct ufs_hba *hba, u32 attr_sel,
>  			      u32 *mib_val, u8 peer);
> +extern int ufshcd_dme_power_xxx(struct ufs_hba *hba, u8 on);
> +extern int ufshcd_dme_hibern8_xxx(struct ufs_hba *hba, u8 enter);
> +extern int ufshcd_dme_endpt_reset(struct ufs_hba *hba);
>
>  static inline int ufshcd_dme_set(struct ufs_hba *hba, u32 attr_sel,
>  				 u8 attr_set, u32 mib_val)
> @@ -246,4 +252,24 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba
> *hba,
>  	return ufshcd_dme_xxx_get(hba, attr_sel, mib_val, 1);
>  }
>
> +static inline int ufshcd_dme_power_on(struct ufs_hba *hba)
> +{
> +	return ufshcd_dme_power_xxx(hba, 1);
> +}
> +
> +static inline int ufshcd_dme_power_off(struct ufs_hba *hba)
> +{
> +	return ufshcd_dme_power_xxx(hba, 0);
> +}
> +
> +static inline int ufshcd_dme_hibern8_enter(struct ufs_hba *hba)
> +{
> +	return ufshcd_dme_hibern8_xxx(hba, 1);
> +}
> +
> +static inline int ufshcd_dme_hibern8_exit(struct ufs_hba *hba)
> +{
> +	return ufshcd_dme_hibern8_xxx(hba, 0);
> +}
> +
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index c7d6a1b..d60703f 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -124,6 +124,12 @@ enum {
>  #define CONTROLLER_FATAL_ERROR			UFS_BIT(16)
>  #define SYSTEM_BUS_FATAL_ERROR			UFS_BIT(17)
>
> +#define UFSHCD_HIBERNATE_MASK	(UIC_HIBERNATE_ENTER |\
> +				 UIC_HIBERNATE_EXIT)
> +
> +#define UFSHCD_UIC_MASK		(UIC_COMMAND_COMPL |\
> +				 UFSHCD_HIBERNATE_MASK)
> +
>  #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
>  				DEVICE_FATAL_ERROR |\
>  				CONTROLLER_FATAL_ERROR |\
> @@ -142,6 +148,15 @@ enum {
>  #define DEVICE_ERROR_INDICATOR			UFS_BIT(5)
>  #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK	UFS_MASK(0x7, 8)
>
> +enum {
> +	PWR_OK          = 0x0,
> +	PWR_LOCAL       = 0x01,
> +	PWR_REMOTE      = 0x02,
> +	PWR_BUSY        = 0x03,
> +	PWR_ERROR_CAP   = 0x04,
> +	PWR_FATAL_ERROR = 0x05,
> +};
> +
>  /* HCE - Host Controller Enable 34h */
>  #define CONTROLLER_ENABLE	UFS_BIT(0)
>  #define CONTROLLER_DISABLE	0x0
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

