From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: Re: [PATCH 2/5] scsi: ufs: wrap the i/o access operations
Date: Thu, 25 Apr 2013 10:19:13 +0530
Message-ID: <5178B5C9.90000@codeaurora.org>
References: <002001ce4105$afbcf000$0f36d000$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34287 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3DYEtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Apr 2013 00:49:18 -0400
In-Reply-To: <002001ce4105$afbcf000$0f36d000$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
> Simplify operations with hiding mmio_base.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>   drivers/scsi/ufs/ufshcd.c |  106 +++++++++++++++++++--------------------------
>   drivers/scsi/ufs/ufshcd.h |    5 ++
>   2 files changed, 49 insertions(+), 62 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 41b9639..b6c19b0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -71,7 +71,7 @@ enum {
>    */
>   static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
>   {
> -	return readl(hba->mmio_base + REG_UFS_VERSION);
> +	return ufshcd_readl(hba, REG_UFS_VERSION);
>   }
>
>   /**
> @@ -130,8 +130,7 @@ static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
>    */
>   static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>   {
> -	writel(~(1 << pos),
> -		(hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_CLEAR));
> +	ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_LIST_CLEAR, ~(1 << pos));
>   }
>
>   /**
> @@ -165,7 +164,7 @@ static inline int ufshcd_get_lists_status(u32 reg)
>    */
>   static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
>   {
> -	return readl(hba->mmio_base + REG_UIC_COMMAND_ARG_2) &
> +	return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
>   	       MASK_UIC_COMMAND_RESULT;
>   }
>
> @@ -243,18 +242,14 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
>   {
>   	switch (option) {
>   	case INT_AGGR_RESET:
> -		writel((INT_AGGR_ENABLE |
> -			INT_AGGR_COUNTER_AND_TIMER_RESET),
> -			(hba->mmio_base +
> -			 REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
> +		ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL,
> +			      INT_AGGR_ENABLE | INT_AGGR_COUNTER_AND_TIMER_RESET);
>   		break;
>   	case INT_AGGR_CONFIG:
> -		writel((INT_AGGR_ENABLE |
> -			INT_AGGR_PARAM_WRITE |
> -			INT_AGGR_COUNTER_THRESHOLD_VALUE |
> -			INT_AGGR_TIMEOUT_VALUE),
> -			(hba->mmio_base +
> -			 REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
> +		ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL,
> +			      INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
> +			      INT_AGGR_COUNTER_THRESHOLD_VALUE |
> +			      INT_AGGR_TIMEOUT_VALUE);
>   		break;
>   	}
>   }
> @@ -267,12 +262,10 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
>    */
>   static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
>   {
> -	writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
> -	       (hba->mmio_base +
> -		REG_UTP_TASK_REQ_LIST_RUN_STOP));
> -	writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
> -	       (hba->mmio_base +
> -		REG_UTP_TRANSFER_REQ_LIST_RUN_STOP));
> +	ufshcd_writel(hba, REG_UTP_TASK_REQ_LIST_RUN_STOP,
> +		      UTP_TASK_REQ_LIST_RUN_STOP_BIT);
> +	ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_LIST_RUN_STOP,
> +		      UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT);
>   }
>
>   /**
> @@ -281,7 +274,7 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
>    */
>   static inline void ufshcd_hba_start(struct ufs_hba *hba)
>   {
> -	writel(CONTROLLER_ENABLE , (hba->mmio_base + REG_CONTROLLER_ENABLE));
> +	ufshcd_writel(hba, REG_CONTROLLER_ENABLE, CONTROLLER_ENABLE);
>   }
>
>   /**
> @@ -290,7 +283,7 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
>    */
>   static inline void ufshcd_hba_stop(struct ufs_hba *hba)
>   {
> -	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> +	ufshcd_writel(hba, REG_CONTROLLER_ENABLE, CONTROLLER_DISABLE);
>   }
>
>   /**
> @@ -301,7 +294,7 @@ static inline void ufshcd_hba_stop(struct ufs_hba *hba)
>    */
>   static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
>   {
> -	return (readl(hba->mmio_base + REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
> +	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
>   }
>
>   /**
> @@ -313,8 +306,7 @@ static inline
>   void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>   {
>   	__set_bit(task_tag, &hba->outstanding_reqs);
> -	writel((1 << task_tag),
> -	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL));
> +	ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL, 1 << task_tag);
>   }
>
>   /**
> @@ -338,8 +330,7 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
>    */
>   static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
>   {
> -	hba->capabilities =
> -		readl(hba->mmio_base + REG_CONTROLLER_CAPABILITIES);
> +	hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
>
>   	/* nutrs and nutmrs are 0 based values */
>   	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> @@ -356,16 +347,13 @@ static inline void
>   ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>   {
>   	/* Write Args */
> -	writel(uic_cmnd->argument1,
> -	      (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
> -	writel(uic_cmnd->argument2,
> -	      (hba->mmio_base + REG_UIC_COMMAND_ARG_2));
> -	writel(uic_cmnd->argument3,
> -	      (hba->mmio_base + REG_UIC_COMMAND_ARG_3));
> +	ufshcd_writel(hba, REG_UIC_COMMAND_ARG_1, uic_cmnd->argument1);
> +	ufshcd_writel(hba, REG_UIC_COMMAND_ARG_2, uic_cmnd->argument2);
> +	ufshcd_writel(hba, REG_UIC_COMMAND_ARG_3, uic_cmnd->argument3);
>
>   	/* Write UIC Cmd */
> -	writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
> -	       (hba->mmio_base + REG_UIC_COMMAND));
> +	ufshcd_writel(hba, REG_UIC_COMMAND,
> +		      uic_cmnd->command & COMMAND_OPCODE_MASK);
>   }
>
>   /**
> @@ -417,16 +405,15 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
>   {
>   	switch (option) {
>   	case UFSHCD_INT_ENABLE:
> -		writel(hba->int_enable_mask,
> -		      (hba->mmio_base + REG_INTERRUPT_ENABLE));
> +		ufshcd_writel(hba, REG_INTERRUPT_ENABLE, hba->int_enable_mask);
>   		break;
>   	case UFSHCD_INT_DISABLE:
>   		if (hba->ufs_version == UFSHCI_VERSION_10)
> -			writel(INTERRUPT_DISABLE_MASK_10,
> -			      (hba->mmio_base + REG_INTERRUPT_ENABLE));
> +			ufshcd_writel(hba, REG_INTERRUPT_ENABLE,
> +				      INTERRUPT_DISABLE_MASK_10);
>   		else
> -			writel(INTERRUPT_DISABLE_MASK_11,
> -			       (hba->mmio_base + REG_INTERRUPT_ENABLE));
> +			ufshcd_writel(hba, REG_INTERRUPT_ENABLE,
> +				      INTERRUPT_DISABLE_MASK_11);
>   		break;
>   	}
>   }
> @@ -712,7 +699,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   	unsigned long flags;
>
>   	/* check if controller is ready to accept UIC commands */
> -	if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
> +	if (((ufshcd_readl(hba, REG_CONTROLLER_STATUS)) &
redundant bracket

>   	    UIC_COMMAND_READY) == 0x0) {
>   		dev_err(hba->dev,
>   			"Controller not ready"
> @@ -757,7 +744,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>   	u32 reg;
>
>   	/* check if device present */
> -	reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
> +	reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
>   	if (!ufshcd_is_device_present(reg)) {
>   		dev_err(hba->dev, "cc: Device not present\n");
>   		err = -ENXIO;
> @@ -879,14 +866,14 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
>   		return -EIO;
>
>   	/* Configure UTRL and UTMRL base address registers */
> -	writel(lower_32_bits(hba->utrdl_dma_addr),
> -	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
> -	writel(upper_32_bits(hba->utrdl_dma_addr),
> -	       (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
> -	writel(lower_32_bits(hba->utmrdl_dma_addr),
> -	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
> -	writel(upper_32_bits(hba->utmrdl_dma_addr),
> -	       (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
> +	ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_LIST_BASE_L,
> +		      lower_32_bits(hba->utrdl_dma_addr));
> +	ufshcd_writel(hba, REG_UTP_TRANSFER_REQ_LIST_BASE_H,
> +		      upper_32_bits(hba->utrdl_dma_addr));
> +	ufshcd_writel(hba, REG_UTP_TASK_REQ_LIST_BASE_L,
> +		      lower_32_bits(hba->utmrdl_dma_addr));
> +	ufshcd_writel(hba, REG_UTP_TASK_REQ_LIST_BASE_H,
> +		      upper_32_bits(hba->utmrdl_dma_addr));
>
>   	/* Initialize unipro link startup procedure */
>   	return ufshcd_dme_link_startup(hba);
> @@ -1178,8 +1165,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>   	int index;
>
>   	lrb = hba->lrb;
> -	tr_doorbell =
> -		readl(hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
>   	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
>
>   	for (index = 0; index < hba->nutrs; index++) {
> @@ -1253,9 +1239,7 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
>   		goto fatal_eh;
>
>   	if (hba->errors & UIC_ERROR) {
> -
> -		reg = readl(hba->mmio_base +
> -			    REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
> +		reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
>   		if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
>   			goto fatal_eh;
>   	}
> @@ -1273,7 +1257,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
>   {
>   	u32 tm_doorbell;
>
> -	tm_doorbell = readl(hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL);
> +	tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
>   	hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
>   	wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
>   }
> @@ -1314,15 +1298,14 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>   	struct ufs_hba *hba = __hba;
>
>   	spin_lock(hba->host->host_lock);
> -	intr_status = readl(hba->mmio_base + REG_INTERRUPT_STATUS);
> +	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>
>   	if (intr_status) {
>   		ufshcd_sl_intr(hba, intr_status);
>
>   		/* If UFSHCI 1.0 then clear interrupt status register */
>   		if (hba->ufs_version == UFSHCI_VERSION_10)
> -			writel(intr_status,
> -			       (hba->mmio_base + REG_INTERRUPT_STATUS));
> +			ufshcd_writel(hba, REG_INTERRUPT_STATUS, intr_status);
>   		retval = IRQ_HANDLED;
>   	}
>   	spin_unlock(hba->host->host_lock);
> @@ -1387,8 +1370,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>
>   	/* send command to the controller */
>   	__set_bit(free_slot, &hba->outstanding_tasks);
> -	writel((1 << free_slot),
> -	       (hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL));
> +	ufshcd_writel(hba, REG_UTP_TASK_REQ_DOOR_BELL, 1 << free_slot);
>
>   	spin_unlock_irqrestore(host->host_lock, flags);
>
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 1680394..6728450 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -190,4 +190,9 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
>   			unsigned int);
>   void ufshcd_remove(struct ufs_hba *);
>
> +#define ufshcd_writel(hba, reg, val)	\

Let this be consistent with writel() arguments - "val" as second arg and 
"reg" as third?

> +	writel((val), (hba)->mmio_base + (reg))
> +#define ufshcd_readl(hba, reg)	\
> +	readl((hba)->mmio_base + (reg))
> +
>   #endif /* End of Header */
>

-- 
Regards,
Sujit
