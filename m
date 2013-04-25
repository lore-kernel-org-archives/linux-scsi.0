From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 4/5] scsi: ufs: rework link start-up process
Date: Thu, 25 Apr 2013 10:35:03 +0530
Message-ID: <5178B97F.3060405@codeaurora.org>
References: <002101ce4105$b184dec0$148e9c40$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24242 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab3DYFFH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Apr 2013 01:05:07 -0400
In-Reply-To: <002101ce4105$b184dec0$148e9c40$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
> Link start-up requires long time with multiphase handshakes
> between UFS host and device. This affects driver's probe time.
> This patch let link start-up run asynchronously.
> And completion time of uic command is defined to avoid a
> permanent wait.

I have similar patch posted few days back "scsi: ufs: Generalize UFS 
Interconnect Layer (UIC) command support" which does a bit more (mutex, 
error handling) than what is done here. Can that be used/improved?

>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>   drivers/scsi/ufs/ufshcd.c |  114 +++++++++++++++++++++++++++++++++-----------
>   drivers/scsi/ufs/ufshcd.h |    6 ++-
>   2 files changed, 89 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index efe2256..76ff332 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -38,6 +38,7 @@
>   #define UFSHCD_ENABLE_INTRS	(UTP_TRANSFER_REQ_COMPL |\
>   				 UTP_TASK_REQ_COMPL |\
>   				 UFSHCD_ERROR_MASK)
> +#define UIC_CMD_TIMEOUT	100
>
>   enum {
>   	UFSHCD_MAX_CHANNEL	= 0,
> @@ -357,13 +358,15 @@ static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
>   }
>
>   /**
> - * ufshcd_send_uic_command - Send UIC commands to unipro layers
> + * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro layers
>    * @hba: per adapter instance
>    * @uic_command: UIC command
>    */
>   static inline void
> -ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
> +ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>   {
> +	init_completion(&uic_cmnd->done);
> +
>   	/* Write Args */
>   	ufshcd_writel(hba, REG_UIC_COMMAND_ARG_1, uic_cmnd->argument1);
>   	ufshcd_writel(hba, REG_UIC_COMMAND_ARG_2, uic_cmnd->argument2);
> @@ -375,6 +378,45 @@ ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>   }
>
>   /**
> + * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
> + * @hba: per adapter instance
> + * @uic_command: UIC command
> + *
> + * Returns 0 only if success.
> + */
> +static int ufshcd_wait_for_uic_cmd(struct ufs_hba *hba)
> +{
> +	struct uic_command *uic_cmd = &hba->active_uic_cmd;
> +	int ret;
> +
> +	if (wait_for_completion_timeout(&uic_cmd->done,
> +					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
> +		ret = ufshcd_get_uic_cmd_result(hba);
> +	else
> +		ret = -ETIMEDOUT;
> +
> +	return ret;
> +}
> +
> +/**
> + * ufshcd_ready_uic_cmd - Check if controller is ready
> + *                        to accept UIC commands
> + * @hba: per adapter instance
> + * Return true on success, else false
> + */
> +static inline bool ufshcd_ready_uic_cmd(struct ufs_hba *hba)
> +{
> +	if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY) {
> +		return true;
> +	} else {
> +		dev_err(hba->dev,
> +				"Controller not ready"
> +				" to accept UIC commands\n");
> +		return false;
> +	}
> +}
> +
> +/**
>    * ufshcd_map_sg - Map scatter-gather list to prdt
>    * @lrbp - pointer to local reference block
>    *
> @@ -735,15 +777,10 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   {
>   	struct uic_command *uic_cmd;
>   	unsigned long flags;
> +	int ret;
>
> -	/* check if controller is ready to accept UIC commands */
> -	if (((ufshcd_readl(hba, REG_CONTROLLER_STATUS)) &
> -	    UIC_COMMAND_READY) == 0x0) {
> -		dev_err(hba->dev,
> -			"Controller not ready"
> -			" to accept UIC commands\n");
> +	if (!ufshcd_ready_uic_cmd(hba))
>   		return -EIO;
> -	}
>
>   	spin_lock_irqsave(hba->host->host_lock, flags);
>
> @@ -754,13 +791,16 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   	uic_cmd->argument2 = 0;
>   	uic_cmd->argument3 = 0;
>
> -	/* enable UIC related interrupts */
> -	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> +	/* Dispatching UIC commands to controller */
> +	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
>
> -	/* sending UIC commands to controller */
> -	ufshcd_send_uic_command(hba, uic_cmd);
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	return 0;
> +
> +	ret = ufshcd_wait_for_uic_cmd(hba);
> +	if (ret)
> +		dev_err(hba->dev, "link startup: error code %d returned\n", ret);
> +
> +	return ret;
>   }
>
>   /**
> @@ -898,6 +938,9 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
>   	if (ufshcd_hba_enable(hba))
>   		return -EIO;
>
> +	/* enable UIC related interrupts */
> +	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL | UIC_ERROR);
> +
>   	/* Configure UTRL and UTMRL base address registers */
>   	ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_LIST_BASE_L,
>   		      lower_32_bits(hba->utrdl_dma_addr));
> @@ -909,7 +952,9 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
>   		      upper_32_bits(hba->utmrdl_dma_addr));
>
>   	/* Initialize unipro link startup procedure */
> -	return ufshcd_dme_link_startup(hba);
> +	schedule_work(&hba->link_startup_wq);
> +
> +	return 0;
>   }
>
>   /**
> @@ -1186,6 +1231,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   }
>
>   /**
> + * ufshcd_uic_cmd_compl - handle completion of uic command
> + * @hba: per adapter instance
> + */
> +static void ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
> +{
> +	if (intr_status & UIC_COMMAND_COMPL)
> +		complete(&hba->active_uic_cmd.done);
> +}
> +
> +/**
>    * ufshcd_transfer_req_compl - handle SCSI and query command completion
>    * @hba: per adapter instance
>    */
> @@ -1225,25 +1280,26 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>   }
>
>   /**
> - * ufshcd_uic_cc_handler - handle UIC command completion
> + * ufshcd_link_startup - link initialization
>    * @work: pointer to a work queue structure
> - *
> - * Returns 0 on success, non-zero value on failure
>    */
> -static void ufshcd_uic_cc_handler (struct work_struct *work)
> +static void ufshcd_link_startup(struct work_struct *work)
>   {
>   	struct ufs_hba *hba;
> +	int ret;
>
> -	hba = container_of(work, struct ufs_hba, uic_workq);
> +	hba = container_of(work, struct ufs_hba, link_startup_wq);
>
> -	if ((hba->active_uic_cmd.command == UIC_CMD_DME_LINK_STARTUP) &&
> -	    !(ufshcd_get_uic_cmd_result(hba))) {
> +	ret = ufshcd_dme_link_startup(hba);
> +	if (ret)
> +		goto out;
>
> -		if (ufshcd_make_hba_operational(hba))
> -			dev_err(hba->dev,
> -				"cc: hba not operational state\n");
> -		return;
> -	}
> +	ret = ufshcd_make_hba_operational(hba);
> +	if (ret)
> +		goto out;
> +	return;
> +out:
> +	dev_err(hba->dev, "link startup failed %d\n", ret);
>   }
>
>   /**
> @@ -1307,7 +1363,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>   		ufshcd_err_handler(hba);
>
>   	if (intr_status & UIC_COMMAND_COMPL)
> -		schedule_work(&hba->uic_workq);
> +		ufshcd_uic_cmd_compl(hba, intr_status);
>
>   	if (intr_status & UTP_TASK_REQ_COMPL)
>   		ufshcd_tmc_handler(hba);
> @@ -1694,7 +1750,7 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>   	init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
>
>   	/* Initialize work queues */
> -	INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
> +	INIT_WORK(&hba->link_startup_wq, ufshcd_link_startup);
>   	INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
>
>   	/* IRQ registration */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 87d5a94..2fb4d94 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -51,6 +51,7 @@
>   #include <linux/bitops.h>
>   #include <linux/pm_runtime.h>
>   #include <linux/clk.h>
> +#include <linux/completion.h>
>
>   #include <asm/irq.h>
>   #include <asm/byteorder.h>
> @@ -83,6 +84,7 @@ struct uic_command {
>   	u32 argument3;
>   	int cmd_active;
>   	int result;
> +	struct completion done;
>   };
>
>   /**
> @@ -140,7 +142,7 @@ struct ufshcd_lrb {
>    * @tm_condition: condition variable for task management
>    * @ufshcd_state: UFSHCD states
>    * @intr_mask: Interrupt Mask Bits
> - * @uic_workq: Work queue for UIC completion handling
> + * @link_startup_wq: Work queue for link start-up
>    * @feh_workq: Work queue for fatal controller error handling
>    * @errors: HBA errors
>    */
> @@ -179,7 +181,7 @@ struct ufs_hba {
>   	u32 intr_mask;
>
>   	/* Work Queues */
> -	struct work_struct uic_workq;
> +	struct work_struct link_startup_wq;
>   	struct work_struct feh_workq;
>
>   	/* HBA Errors */
>

-- 
Regards,
Sujit
