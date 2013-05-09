From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v4 6/6] scsi: ufs: add dme control primitives
Date: Thu, 9 May 2013 12:23:25 +0530
Message-ID: <CALMYJDsPSggSjAP-2wiHzMVTaCxRKKgAMUZnf5xNjrdto6T5FQ@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com> <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002901ce4bc8$0bdb58f0$23920ad0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53212 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3EIGxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 02:53:47 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so1280869bkc.28
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 23:53:46 -0700 (PDT)
In-Reply-To: <002901ce4bc8$0bdb58f0$23920ad0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wed, May 8, 2013 at 2:13 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Implements to support the following operations.
> Currently, this patch doesn't introduce DME_ENABLE and DME_RESET
> because host controller's HCE enable contains these roles.
>
> DME_POWERON{OFF}, DME_HIBERNATE_ENTER{EXIT}, DME_ENDPOINTRESET.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Tested-by: Maya Erez <merez@codeaurora.org>
> ---
> Change in v4:
> - Changed function names.
>
>  drivers/scsi/ufs/ufshcd.c |  123 +++++++++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.h |   26 ++++++++++
>  drivers/scsi/ufs/ufshci.h |   15 ++++++
>  3 files changed, 160 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e05eedb..45123b4 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -39,6 +39,7 @@
>
>  #define UFSHCD_ENABLE_INTRS    (UTP_TRANSFER_REQ_COMPL |\
>                                  UTP_TASK_REQ_COMPL |\
> +                                UFSHCD_HIBERNATE_MASK |\
>                                  UFSHCD_ERROR_MASK)
>  /* UIC command timeout, unit: ms */
>  #define UIC_CMD_TIMEOUT        500
> @@ -203,6 +204,18 @@ static inline u32 ufshcd_get_dme_attr_val(struct ufs_hba *hba)
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
> +       return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) >> 8) & 0x7;
> +}
> +
> +/**
>   * ufshcd_free_hba_memory - Free allocated memory for LRB, request
>   *                         and task lists
>   * @hba: Pointer to adapter instance
> @@ -1163,6 +1176,103 @@ out:
>  EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
>
>  /**
> + * ufshcd_dme_power_ctrl - UIC command for DME_POWERON, DME_POWEROFF
> + * @hba: per adapter instance
> + * @on: indicate wherter power_on or power_off
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_power_ctrl(struct ufs_hba *hba, u8 on)
> +{
> +       struct uic_command uic_cmd = {0};
> +       static const char *const action[] = {
> +               "dme-power-off",
> +               "dme-power-on"
> +       };
> +       const char *power = action[!!on];
> +       int ret;
> +
> +       uic_cmd.command = on ?
> +               UIC_CMD_DME_POWERON : UIC_CMD_DME_POWEROFF;
> +
> +       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +       if (ret)
> +               dev_err(hba->dev, "%s: error code %d\n", power, ret);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_power_ctrl);
> +
> +/**
> + * ufshcd_dme_hibern8_ctrl - UIC command for DME_HIBERNATE_ENTER,
> + *                          DME_HIBERNATE_EXIT
> + * @hba: per adapter instance
> + * @enter: indicate wherter hibernation enter or exit
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_hibern8_ctrl(struct ufs_hba *hba, u8 enter)
> +{
> +       struct uic_command uic_cmd = {0};
> +       static const char *const action[] = {
> +               "dme-hibernate-exit",
> +               "dme-hibernate-enter"
> +       };
> +       const char *hibern8 = action[!!enter];
> +       u8 status;
> +       int ret;
> +
> +       uic_cmd.command = enter ?
> +               UIC_CMD_DME_HIBER_ENTER : UIC_CMD_DME_HIBER_EXIT;
> +
> +       mutex_lock(&hba->uic_cmd_mutex);
> +       init_completion(&hba->hibern8_done);
> +       ret = __ufshcd_send_uic_cmd(hba, &uic_cmd);
> +       if (ret) {
> +               dev_err(hba->dev, "%s: error code %d\n", hibern8, ret);
> +               goto out;
> +       }
> +
> +       if (wait_for_completion_timeout(&hba->hibern8_done,
> +                                       msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
> +               status = ufshcd_get_upmcrs(hba);
> +               if (status != PWR_LOCAL) {
> +                       dev_err(hba->dev, "%s: failed, host upmcrs:0x%x\n",
> +                               hibern8, status);
> +                       ret = status;
> +               }
> +       } else {
> +               dev_err(hba->dev, "%s: timeout\n", hibern8);
> +               ret = -ETIMEDOUT;
> +       }
> +out:
> +       mutex_unlock(&hba->uic_cmd_mutex);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_hibern8_ctrl);
> +
> +/**
> + * ufshcd_dme_endpoint_reset - UIC command for DME_ENDPOINTRESET
> + * @hba: per adapter instance
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +int ufshcd_dme_endpoint_reset(struct ufs_hba *hba)
> +{
> +       struct uic_command uic_cmd = {0};
> +       int ret;
> +
> +       uic_cmd.command = UIC_CMD_DME_END_PT_RST;
> +
> +       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +       if (ret)
> +               dev_err(hba->dev, "dme-endpoint-reset: error code %d\n", ret);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_dme_endpoint_reset);
> +
> +/**
>   * ufshcd_make_hba_operational - Make UFS controller operational
>   * @hba: per adapter instance
>   *
> @@ -1618,16 +1728,21 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  /**
>   * ufshcd_uic_cmd_compl - handle completion of uic command
>   * @hba: per adapter instance
> + * @intr_status: interrupt status generated by the controller
>   */
> -static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
> +static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>  {
> -       if (hba->active_uic_cmd) {
> +       if ((intr_status & UIC_COMMAND_COMPL) &&
> +                       hba->active_uic_cmd) {
>                 hba->active_uic_cmd->argument2 |=
>                         ufshcd_get_uic_cmd_result(hba);
>                 hba->active_uic_cmd->argument3 =
>                         ufshcd_get_dme_attr_val(hba);
>                 complete(&hba->active_uic_cmd->done);
>         }
> +
> +       if (intr_status & UFSHCD_HIBERNATE_MASK)
> +               complete(&hba->hibern8_done);
>  }
>
>  /**
> @@ -1729,8 +1844,8 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>         if (hba->errors)
>                 ufshcd_err_handler(hba);
>
> -       if (intr_status & UIC_COMMAND_COMPL)
> -               ufshcd_uic_cmd_compl(hba);
> +       if (intr_status & UFSHCD_UIC_MASK)
> +               ufshcd_uic_cmd_compl(hba, intr_status);
>
>         if (intr_status & UTP_TASK_REQ_COMPL)
>                 ufshcd_tmc_handler(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index dabd29c..0465885 100644
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
>         wait_queue_head_t ufshcd_tm_wait_queue;
>         unsigned long tm_condition;
>
> +       struct completion hibern8_done;
> +
>         u32 ufshcd_state;
>         u32 intr_mask;
>
> @@ -221,6 +224,9 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>                                u8 attr_set, u32 mib_val, u8 peer);
>  extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>                                u32 *mib_val, u8 peer);
> +extern int ufshcd_dme_power_ctrl(struct ufs_hba *hba, u8 on);
> +extern int ufshcd_dme_hibern8_ctrl(struct ufs_hba *hba, u8 enter);
> +extern int ufshcd_dme_endpoint_reset(struct ufs_hba *hba);
>
>  /**
>   * ufshcd_hba_stop - Send controller to reset state
> @@ -256,4 +262,24 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
>         return ufshcd_dme_get_attr(hba, attr_sel, mib_val, 1);
>  }
>
> +static inline int ufshcd_dme_power_on(struct ufs_hba *hba)
> +{
> +       return ufshcd_dme_power_ctrl(hba, 1);
> +}
> +
> +static inline int ufshcd_dme_power_off(struct ufs_hba *hba)
> +{
> +       return ufshcd_dme_power_ctrl(hba, 0);
> +}
> +
> +static inline int ufshcd_dme_hibern8_enter(struct ufs_hba *hba)
> +{
> +       return ufshcd_dme_hibern8_ctrl(hba, 1);
> +}
> +
> +static inline int ufshcd_dme_hibern8_exit(struct ufs_hba *hba)
> +{
> +       return ufshcd_dme_hibern8_ctrl(hba, 0);
> +}
> +
>  #endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index edb4d87..8ddecaa 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -124,6 +124,12 @@ enum {
>  #define CONTROLLER_FATAL_ERROR                 UFS_BIT(16)
>  #define SYSTEM_BUS_FATAL_ERROR                 UFS_BIT(17)
>
> +#define UFSHCD_HIBERNATE_MASK  (UIC_HIBERNATE_ENTER |\
> +                                UIC_HIBERNATE_EXIT)
> +
> +#define UFSHCD_UIC_MASK                (UIC_COMMAND_COMPL |\
> +                                UFSHCD_HIBERNATE_MASK)
> +
>  #define UFSHCD_ERROR_MASK      (UIC_ERROR |\
>                                 DEVICE_FATAL_ERROR |\
>                                 CONTROLLER_FATAL_ERROR |\
> @@ -142,6 +148,15 @@ enum {
>  #define DEVICE_ERROR_INDICATOR                 UFS_BIT(5)
>  #define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK  UFS_MASK(0x7, 8)
>
> +enum {
> +       PWR_OK          = 0x0,
> +       PWR_LOCAL       = 0x01,
> +       PWR_REMOTE      = 0x02,
> +       PWR_BUSY        = 0x03,
> +       PWR_ERROR_CAP   = 0x04,
> +       PWR_FATAL_ERROR = 0x05,
> +};
> +
>  /* HCE - Host Controller Enable 34h */
>  #define CONTROLLER_ENABLE      UFS_BIT(0)
>  #define CONTROLLER_DISABLE     0x0
> --
> 1.7.0.4
>
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
