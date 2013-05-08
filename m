From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH v4 4/6] scsi: ufs: rework link start-up process
Date: Wed, 8 May 2013 20:50:26 +0530
Message-ID: <CALMYJDtNG2T90o4bvJy=K+2JKCJYXQ3WwHen6ROMYApTmcz+1w@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com> <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <002701ce4bc7$ecebe220$c6c3a660$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44316 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab3EHPUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 May 2013 11:20:48 -0400
Received: by mail-bk0-f52.google.com with SMTP id q16so939550bkw.25
        for <linux-scsi@vger.kernel.org>; Wed, 08 May 2013 08:20:47 -0700 (PDT)
In-Reply-To: <002701ce4bc7$ecebe220$c6c3a660$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wed, May 8, 2013 at 2:12 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Link start-up requires long time with multiphase handshakes
> between UFS host and device. This affects driver's probe time.
> This patch let link start-up run asynchronously. Link start-up
> will be executed at the end of prove separately.
> Along with this change, the following is worked.
>
> Defined completion time of uic command to avoid a permanent wait.
> Added mutex to guarantee of uic command at a time.
> Adapted some sequence of controller initialization after link statup
> according to HCI standard.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
> Tested-by: Maya Erez <merez@codeaurora.org>
> ---
> Change in v4:
> - Addressed late interrupt case (Sujit).
> - Move print message in link startup (Maya).
>
>  drivers/scsi/ufs/ufshcd.c |  295 ++++++++++++++++++++++++++++++--------------
>  drivers/scsi/ufs/ufshcd.h |   10 +-
>  2 files changed, 208 insertions(+), 97 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e04c74e..8363b92 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -33,11 +33,15 @@
>   * this program.
>   */
>
> +#include <linux/async.h>
> +
>  #include "ufshcd.h"
>
>  #define UFSHCD_ENABLE_INTRS    (UTP_TRANSFER_REQ_COMPL |\
>                                  UTP_TASK_REQ_COMPL |\
>                                  UFSHCD_ERROR_MASK)
> +/* UIC command timeout, unit: ms */
> +#define UIC_CMD_TIMEOUT        500
>
>  enum {
>         UFSHCD_MAX_CHANNEL      = 0,
> @@ -401,24 +405,122 @@ static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
>  }
>
>  /**
> - * ufshcd_send_uic_command - Send UIC commands to unipro layers
> + * ufshcd_ready_for_uic_cmd - Check if controller is ready
> + *                            to accept UIC commands
>   * @hba: per adapter instance
> - * @uic_command: UIC command
> + * Return true on success, else false
> + */
> +static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
> +{
> +       if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY)
> +               return true;
> +       else
> +               return false;
> +}
> +
> +/**
> + * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro layers
> + * @hba: per adapter instance
> + * @uic_cmd: UIC command
> + *
> + * Mutex must be held.
>   */
>  static inline void
> -ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
> +ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>  {
> +       WARN_ON(hba->active_uic_cmd);
> +
> +       hba->active_uic_cmd = uic_cmd;
> +
>         /* Write Args */
> -       ufshcd_writel(hba, uic_cmnd->argument1, REG_UIC_COMMAND_ARG_1);
> -       ufshcd_writel(hba, uic_cmnd->argument2, REG_UIC_COMMAND_ARG_2);
> -       ufshcd_writel(hba, uic_cmnd->argument3, REG_UIC_COMMAND_ARG_3);
> +       ufshcd_writel(hba, uic_cmd->argument1, REG_UIC_COMMAND_ARG_1);
> +       ufshcd_writel(hba, uic_cmd->argument2, REG_UIC_COMMAND_ARG_2);
> +       ufshcd_writel(hba, uic_cmd->argument3, REG_UIC_COMMAND_ARG_3);
>
>         /* Write UIC Cmd */
> -       ufshcd_writel(hba, uic_cmnd->command & COMMAND_OPCODE_MASK,
> +       ufshcd_writel(hba, uic_cmd->command & COMMAND_OPCODE_MASK,
>                       REG_UIC_COMMAND);
>  }
>
>  /**
> + * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
> + * @hba: per adapter instance
> + * @uic_command: UIC command
> + *
> + * Must be called with mutex held.
> + * Returns 0 only if success.
> + */
> +static int
> +ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> +{
> +       int ret;
> +       unsigned long flags;
> +
> +       if (wait_for_completion_timeout(&uic_cmd->done,
> +                                       msecs_to_jiffies(UIC_CMD_TIMEOUT)))
> +               ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
> +       else
> +               ret = -ETIMEDOUT;
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       hba->active_uic_cmd = NULL;
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       return ret;
> +}
> +
> +/**
> + * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
> + * @hba: per adapter instance
> + * @uic_cmd: UIC command
> + *
> + * Identical to ufshcd_send_uic_cmd() expect mutex. Must be called
> + * with mutex held.
> + * Returns 0 only if success.
> + */
> +static int
> +__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> +{
> +       int ret;
> +       unsigned long flags;
> +
> +       if (!ufshcd_ready_for_uic_cmd(hba)) {
> +               dev_err(hba->dev,
> +                       "Controller not ready to accept UIC commands\n");
> +               return -EIO;
> +       }
> +
> +       init_completion(&uic_cmd->done);
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +       ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
> +
> +       return ret;
> +}
> +
> +/**
> + * ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
> + * @hba: per adapter instance
> + * @uic_cmd: UIC command
> + *
> + * Returns 0 only if success.
> + */
> +static int
> +ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> +{
> +       int ret;
> +
> +       mutex_lock(&hba->uic_cmd_mutex);
> +       ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
> +       mutex_unlock(&hba->uic_cmd_mutex);
> +
> +       return ret;
> +}
> +
> +/**
>   * ufshcd_map_sg - Map scatter-gather list to prdt
>   * @lrbp - pointer to local reference block
>   *
> @@ -962,34 +1064,16 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>   */
>  static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>  {
> -       struct uic_command *uic_cmd;
> -       unsigned long flags;
> -
> -       /* check if controller is ready to accept UIC commands */
> -       if ((ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> -           UIC_COMMAND_READY) == 0x0) {
> -               dev_err(hba->dev,
> -                       "Controller not ready"
> -                       " to accept UIC commands\n");
> -               return -EIO;
> -       }
> +       struct uic_command uic_cmd = {0};
> +       int ret;
>
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> +       uic_cmd.command = UIC_CMD_DME_LINK_STARTUP;
>
> -       /* form UIC command */
> -       uic_cmd = &hba->active_uic_cmd;
> -       uic_cmd->command = UIC_CMD_DME_LINK_STARTUP;
> -       uic_cmd->argument1 = 0;
> -       uic_cmd->argument2 = 0;
> -       uic_cmd->argument3 = 0;
> -
> -       /* enable UIC related interrupts */
> -       ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> -
> -       /* sending UIC commands to controller */
> -       ufshcd_send_uic_command(hba, uic_cmd);
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       return 0;
> +       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> +       if (ret)
> +               dev_err(hba->dev,
> +                       "dme-link-startup: error code %d\n", ret);
> +       return ret;
>  }
>
>  /**
> @@ -998,9 +1082,10 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   *
>   * To bring UFS host controller to operational state,
>   * 1. Check if device is present
> - * 2. Configure run-stop-registers
> - * 3. Enable required interrupts
> - * 4. Configure interrupt aggregation
> + * 2. Enable required interrupts
> + * 3. Configure interrupt aggregation
> + * 4. Program UTRL and UTMRL base addres
> + * 5. Configure run-stop-registers
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> @@ -1017,6 +1102,22 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>                 goto out;
>         }
>
> +       /* Enable required interrupts */
> +       ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
> +
> +       /* Configure interrupt aggregation */
> +       ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
> +
> +       /* Configure UTRL and UTMRL base address registers */
> +       ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
> +                       REG_UTP_TRANSFER_REQ_LIST_BASE_L);
> +       ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
> +                       REG_UTP_TRANSFER_REQ_LIST_BASE_H);
> +       ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
> +                       REG_UTP_TASK_REQ_LIST_BASE_L);
> +       ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
> +                       REG_UTP_TASK_REQ_LIST_BASE_H);
> +
>         /*
>          * UCRDY, UTMRLDY and UTRLRDY bits must be 1
>          * DEI, HEI bits must be 0
> @@ -1030,17 +1131,11 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>                 goto out;
>         }
>
> -       /* Enable required interrupts */
> -       ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
> -
> -       /* Configure interrupt aggregation */
> -       ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
> -
>         if (hba->ufshcd_state == UFSHCD_STATE_RESET)
>                 scsi_unblock_requests(hba->host);
>
>         hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> -       scsi_scan_host(hba->host);
> +
>  out:
>         return err;
>  }
> @@ -1109,34 +1204,28 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>  }
>
>  /**
> - * ufshcd_initialize_hba - start the initialization process
> + * ufshcd_link_startup - Initialize unipro link startup
>   * @hba: per adapter instance
>   *
> - * 1. Enable the controller via ufshcd_hba_enable.
> - * 2. Program the Transfer Request List Address with the starting address of
> - * UTRDL.
> - * 3. Program the Task Management Request List Address with starting address
> - * of UTMRDL.
> - *
> - * Returns 0 on success, non-zero value on failure.
> + * Returns 0 for success, non-zero in case of failure
>   */
> -static int ufshcd_initialize_hba(struct ufs_hba *hba)
> +static int ufshcd_link_startup(struct ufs_hba *hba)
>  {
> -       if (ufshcd_hba_enable(hba))
> -               return -EIO;
> +       int ret;
>
> -       /* Configure UTRL and UTMRL base address registers */
> -       ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
> -                     REG_UTP_TRANSFER_REQ_LIST_BASE_L);
> -       ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
> -                     REG_UTP_TRANSFER_REQ_LIST_BASE_H);
> -       ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
> -                     REG_UTP_TASK_REQ_LIST_BASE_L);
> -       ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
> -                     REG_UTP_TASK_REQ_LIST_BASE_H);
> +       /* enable UIC related interrupts */
> +       ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
>
> -       /* Initialize unipro link startup procedure */
> -       return ufshcd_dme_link_startup(hba);
> +       ret = ufshcd_dme_link_startup(hba);
> +       if (ret)
> +               goto out;
> +
> +       ret = ufshcd_make_hba_operational(hba);
> +
> +out:
> +       if (ret)
> +               dev_err(hba->dev, "link startup failed %d\n", ret);
> +       return ret;
>  }
>
>  /**
> @@ -1176,12 +1265,19 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
>         hba->outstanding_reqs = 0;
>         hba->outstanding_tasks = 0;
>
> -       /* start the initialization process */
> -       if (ufshcd_initialize_hba(hba)) {
> +       /* Host controller enable */
> +       if (ufshcd_hba_enable(hba)) {
>                 dev_err(hba->dev,
>                         "Reset: Controller initialization failed\n");
>                 return FAILED;
>         }
> +
> +       if (ufshcd_link_startup(hba)) {
> +               dev_err(hba->dev,
> +                       "Reset: Link start-up failed\n");
> +               return FAILED;
> +       }
> +
>         return SUCCESS;
>  }
>
> @@ -1434,6 +1530,19 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  }
>
>  /**
> + * ufshcd_uic_cmd_compl - handle completion of uic command
> + * @hba: per adapter instance
> + */
> +static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
> +{
> +       if (hba->active_uic_cmd) {
> +               hba->active_uic_cmd->argument2 |=
> +                       ufshcd_get_uic_cmd_result(hba);
> +               complete(&hba->active_uic_cmd->done);
> +       }
> +}
> +
> +/**
>   * ufshcd_transfer_req_compl - handle SCSI and query command completion
>   * @hba: per adapter instance
>   */
> @@ -1473,28 +1582,6 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  }
>
>  /**
> - * ufshcd_uic_cc_handler - handle UIC command completion
> - * @work: pointer to a work queue structure
> - *
> - * Returns 0 on success, non-zero value on failure
> - */
> -static void ufshcd_uic_cc_handler (struct work_struct *work)
> -{
> -       struct ufs_hba *hba;
> -
> -       hba = container_of(work, struct ufs_hba, uic_workq);
> -
> -       if ((hba->active_uic_cmd.command == UIC_CMD_DME_LINK_STARTUP) &&
> -           !(ufshcd_get_uic_cmd_result(hba))) {
> -
> -               if (ufshcd_make_hba_operational(hba))
> -                       dev_err(hba->dev,
> -                               "cc: hba not operational state\n");
> -               return;
> -       }
> -}
> -
> -/**
>   * ufshcd_fatal_err_handler - handle fatal errors
>   * @hba: per adapter instance
>   */
> @@ -1555,7 +1642,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>                 ufshcd_err_handler(hba);
>
>         if (intr_status & UIC_COMMAND_COMPL)
> -               schedule_work(&hba->uic_workq);
> +               ufshcd_uic_cmd_compl(hba);
>
>         if (intr_status & UTP_TASK_REQ_COMPL)
>                 ufshcd_tmc_handler(hba);
> @@ -1778,6 +1865,21 @@ out:
>         return err;
>  }
>
> +/**
> + * ufshcd_async_scan - asynchronous execution for link startup
> + * @data: data pointer to pass to this function
> + * @cookie: cookie data
> + */
> +static void ufshcd_async_scan(void *data, async_cookie_t cookie)
> +{
> +       struct ufs_hba *hba = (struct ufs_hba *)data;
> +       int ret;
> +
> +       ret = ufshcd_link_startup(hba);
> +       if (!ret)
> +               scsi_scan_host(hba->host);
> +}
> +
>  static struct scsi_host_template ufshcd_driver_template = {
>         .module                 = THIS_MODULE,
>         .name                   = UFSHCD,
> @@ -1939,12 +2041,14 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>         init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
>
>         /* Initialize work queues */
> -       INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
>         INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
>
>         /* Initialize mutex for query requests */
>         mutex_init(&hba->query.lock_ufs_query);
>
> +       /* Initialize UIC command mutex */
> +       mutex_init(&hba->uic_cmd_mutex);
> +
>         /* IRQ registration */
>         err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
>         if (err) {
> @@ -1965,14 +2069,17 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>                 goto out_free_irq;
>         }
>
> -       /* Initialization routine */
> -       err = ufshcd_initialize_hba(hba);
> +       /* Host controller enable */
> +       err = ufshcd_hba_enable(hba);
>         if (err) {
> -               dev_err(hba->dev, "Initialization failed\n");
> +               dev_err(hba->dev, "Host controller enable failed\n");
>                 goto out_remove_scsi_host;
>         }
> +
>         *hba_handle = hba;
>
> +       async_schedule(ufshcd_async_scan, hba);
> +
>         return 0;
>
>  out_remove_scsi_host:
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index d98e046..974bd07 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -51,6 +51,7 @@
>  #include <linux/bitops.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/clk.h>
> +#include <linux/completion.h>
>
>  #include <asm/irq.h>
>  #include <asm/byteorder.h>
> @@ -76,6 +77,7 @@
>   * @argument3: UIC command argument 3
>   * @cmd_active: Indicate if UIC command is outstanding
>   * @result: UIC command result
> + * @done: UIC command completion
>   */
>  struct uic_command {
>         u32 command;
> @@ -84,6 +86,7 @@ struct uic_command {
>         u32 argument3;
>         int cmd_active;
>         int result;
> +       struct completion done;
>  };
>
>  /**
> @@ -150,11 +153,11 @@ struct ufs_query {
>   * @ufs_version: UFS Version to which controller complies
>   * @irq: Irq number of the controller
>   * @active_uic_cmd: handle of active UIC command
> + * @uic_cmd_mutex: mutex for uic command
>   * @ufshcd_tm_wait_queue: wait queue for task management
>   * @tm_condition: condition variable for task management
>   * @ufshcd_state: UFSHCD states
>   * @intr_mask: Interrupt Mask Bits
> - * @uic_workq: Work queue for UIC completion handling
>   * @feh_workq: Work queue for fatal controller error handling
>   * @errors: HBA errors
>   * @query: query request information
> @@ -186,7 +189,9 @@ struct ufs_hba {
>         u32 ufs_version;
>         unsigned int irq;
>
> -       struct uic_command active_uic_cmd;
> +       struct uic_command *active_uic_cmd;
> +       struct mutex uic_cmd_mutex;
> +
>         wait_queue_head_t ufshcd_tm_wait_queue;
>         unsigned long tm_condition;
>
> @@ -194,7 +199,6 @@ struct ufs_hba {
>         u32 intr_mask;
>
>         /* Work Queues */
> -       struct work_struct uic_workq;
>         struct work_struct feh_workq;
>
>         /* HBA Errors */
> --
> 1.7.0.4
>
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
