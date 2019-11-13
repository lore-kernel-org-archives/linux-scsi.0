Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 564B9C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 00:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 205222196E
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 00:11:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UvI38DDL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UGc03Wdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKMALg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 19:11:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44186 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbfKMALg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 19:11:36 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 23F446078F; Wed, 13 Nov 2019 00:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573603895;
        bh=oyxH/dC6pgsEGDaB+104nVw9jyny1694Gg5kqtyjstk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UvI38DDLIbWjJnu8zMQ9e5w3qgapp0hTOKOz2WRkb4pcSpdmYrZAj/BJlhDnbuSFy
         GF7b7u35pTRnb3qZv4pqqJIFGBEqkcndY5gM5JnC3MhtxoEMEcgvmhmQaZO3Nl9zLw
         fccC1lVxYFUiLSRmTayUm2IOePGt1jacsElbLODQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 4C560602C8;
        Wed, 13 Nov 2019 00:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573603892;
        bh=oyxH/dC6pgsEGDaB+104nVw9jyny1694Gg5kqtyjstk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UGc03WdnlMFChwN94BNjgmybRILikVw9op7foLPBpirXJL26k3f113pCASIg85hH3
         CaTGgXLFTyi8Gq+mj+43Cw/TGmB3rwVLgWbELYM91gjCJloGDNY8g4LHze+PT1b502
         m0uwGvquZeX1eXphtiD6FKyw4ftCoLEylUYwCUxo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Nov 2019 08:11:32 +0800
From:   cang@codeaurora.org
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH v5 4/4] ufs: Simplify the clock scaling mechanism
 implementation
In-Reply-To: <20191112173743.141503-5-bvanassche@acm.org>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
Message-ID: <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-13 01:37, Bart Van Assche wrote:
> Scaling the clock is only safe while no commands are in progress. Use
> blk_mq_{un,}freeze_queue() to block submission of new commands and to
> wait for ongoing commands to complete. Remove "_scsi" from the name of
> the functions that block and unblock requests since these functions
> now block both SCSI commands and non-SCSI commands.
> 
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 141 +++++++++++++-------------------------
>  drivers/scsi/ufs/ufshcd.h |   3 -
>  2 files changed, 46 insertions(+), 98 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 810b997f55fc..717ba24a2d40 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -290,16 +290,50 @@ static inline void ufshcd_disable_irq(struct 
> ufs_hba *hba)
>  	}
>  }
> 
> -static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
> +static void ufshcd_unblock_requests(struct ufs_hba *hba)
>  {
> -	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
> -		scsi_unblock_requests(hba->host);
> +	struct scsi_device *sdev;
> +
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue(sdev->request_queue);
>  }
> 
> -static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
> +static int ufshcd_block_requests(struct ufs_hba *hba, unsigned long 
> timeout)
>  {
> -	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
> -		scsi_block_requests(hba->host);
> +	struct scsi_device *sdev;
> +	unsigned long deadline = jiffies + timeout;
> +
> +	if (timeout == ULONG_MAX) {
> +		shost_for_each_device(sdev, hba->host)
> +			blk_mq_freeze_queue(sdev->request_queue);
> +		blk_mq_freeze_queue(hba->cmd_queue);
> +		blk_mq_freeze_queue(hba->tmf_queue);
> +		return 0;
> +	}
> +
> +	shost_for_each_device(sdev, hba->host)
> +		blk_freeze_queue_start(sdev->request_queue);
> +	blk_freeze_queue_start(hba->cmd_queue);
> +	blk_freeze_queue_start(hba->tmf_queue);
> +	shost_for_each_device(sdev, hba->host) {
> +		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue,
> +				max_t(long, 0, deadline - jiffies)) <= 0) {
> +			goto err;
> +		}
> +	}
> +	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
> +				max_t(long, 0, deadline - jiffies)) <= 0)
> +		goto err;
> +	if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
> +				max_t(long, 0, deadline - jiffies)) <= 0)
> +		goto err;
> +	return 0;
> +
> +err:
> +	ufshcd_unblock_requests(hba);
> +	return -ETIMEDOUT;
>  }
> 
>  static void ufshcd_add_cmd_upiu_trace(struct ufs_hba *hba, unsigned 
> int tag,
> @@ -971,65 +1005,6 @@ static bool
> ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>  	return false;
>  }
> 
> -static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
> -					u64 wait_timeout_us)
> -{
> -	unsigned long flags;
> -	int ret = 0;
> -	u32 tm_doorbell;
> -	u32 tr_doorbell;
> -	bool timeout = false, do_last_check = false;
> -	ktime_t start;
> -
> -	ufshcd_hold(hba, false);
> -	spin_lock_irqsave(hba->host->host_lock, flags);
> -	/*
> -	 * Wait for all the outstanding tasks/transfer requests.
> -	 * Verify by checking the doorbell registers are clear.
> -	 */
> -	start = ktime_get();
> -	do {
> -		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
> -			ret = -EBUSY;
> -			goto out;
> -		}
> -
> -		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -		if (!tm_doorbell && !tr_doorbell) {
> -			timeout = false;
> -			break;
> -		} else if (do_last_check) {
> -			break;
> -		}
> -
> -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> -		schedule();
> -		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
> -		    wait_timeout_us) {
> -			timeout = true;
> -			/*
> -			 * We might have scheduled out for long time so make
> -			 * sure to check if doorbells are cleared by this time
> -			 * or not.
> -			 */
> -			do_last_check = true;
> -		}
> -		spin_lock_irqsave(hba->host->host_lock, flags);
> -	} while (tm_doorbell || tr_doorbell);
> -
> -	if (timeout) {
> -		dev_err(hba->dev,
> -			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
> -			__func__, tm_doorbell, tr_doorbell);
> -		ret = -EBUSY;
> -	}
> -out:
> -	spin_unlock_irqrestore(hba->host->host_lock, flags);
> -	ufshcd_release(hba);
> -	return ret;
> -}
> -
>  /**
>   * ufshcd_scale_gear - scale up/down UFS gear
>   * @hba: per adapter instance
> @@ -1079,27 +1054,16 @@ static int ufshcd_scale_gear(struct ufs_hba
> *hba, bool scale_up)
> 
>  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>  {
> -	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
> -	int ret = 0;
>  	/*
>  	 * make sure that there are no outstanding requests when
>  	 * clock scaling is in progress
>  	 */
> -	ufshcd_scsi_block_requests(hba);
> -	down_write(&hba->clk_scaling_lock);
> -	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> -		ret = -EBUSY;
> -		up_write(&hba->clk_scaling_lock);
> -		ufshcd_scsi_unblock_requests(hba);
> -	}
> -
> -	return ret;
> +	return ufshcd_block_requests(hba, HZ);
>  }
> 
>  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>  {
> -	up_write(&hba->clk_scaling_lock);
> -	ufshcd_scsi_unblock_requests(hba);
> +	ufshcd_unblock_requests(hba);
>  }
> 
>  /**
> @@ -1471,7 +1435,7 @@ static void ufshcd_ungate_work(struct work_struct 
> *work)
>  		hba->clk_gating.is_suspended = false;
>  	}
>  unblock_reqs:
> -	ufshcd_scsi_unblock_requests(hba);
> +	ufshcd_unblock_requests(hba);
>  }
> 
>  /**
> @@ -1528,7 +1492,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  		 */
>  		/* fallthrough */
>  	case CLKS_OFF:
> -		ufshcd_scsi_block_requests(hba);
> +		ufshcd_block_requests(hba, ULONG_MAX);

Hi Bart,

ufshcd_hold(async == true) is used in ufshcd_queuecommand() path because
ufshcd_queuecommand() can be entered under atomic contexts.
Thus ufshcd_block_requests() here has the same risk causing scheduling 
while atomic.
FYI, it is not easy to hit above scenario in small scale of test.

Best Regards,
Can Guo.

>  		hba->clk_gating.state = REQ_CLKS_ON;
>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>  					hba->clk_gating.state);
> @@ -2395,9 +2359,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  		BUG();
>  	}
> 
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> -
>  	spin_lock_irqsave(hba->host->host_lock, flags);
>  	switch (hba->ufshcd_state) {
>  	case UFSHCD_STATE_OPERATIONAL:
> @@ -2463,7 +2424,6 @@ static int ufshcd_queuecommand(struct Scsi_Host
> *host, struct scsi_cmnd *cmd)
>  out_unlock:
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  out:
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -2617,8 +2577,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
>  	struct completion wait;
>  	unsigned long flags;
> 
> -	down_read(&hba->clk_scaling_lock);
> -
>  	/*
>  	 * Get free slot, sleep if slots are unavailable.
>  	 * Even though we use wait_event() which sleeps indefinitely,
> @@ -2654,7 +2612,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
> *hba,
> 
>  out_put_tag:
>  	blk_put_request(req);
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -5342,7 +5299,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	if (starget)
>  		scsi_target_unblock(&starget->dev, SDEV_RUNNING);
> -	ufshcd_scsi_unblock_requests(hba);
> +	scsi_unblock_requests(hba->host);
>  	ufshcd_release(hba);
>  	pm_runtime_put_sync(hba->dev);
>  }
> @@ -5466,7 +5423,7 @@ static void ufshcd_check_errors(struct ufs_hba 
> *hba)
>  		/* handle fatal errors only when link is functional */
>  		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
>  			/* block commands from scsi mid-layer */
> -			ufshcd_scsi_block_requests(hba);
> +			scsi_block_requests(hba->host);
> 
>  			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
> 
> @@ -5772,8 +5729,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	unsigned long flags;
>  	u32 upiu_flags;
> 
> -	down_read(&hba->clk_scaling_lock);
> -
>  	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
> @@ -5853,7 +5808,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>  	}
> 
>  	blk_put_request(req);
> -	up_read(&hba->clk_scaling_lock);
>  	return err;
>  }
> 
> @@ -8322,8 +8276,6 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  	/* Initialize mutex for device management commands */
>  	mutex_init(&hba->dev_cmd.lock);
> 
> -	init_rwsem(&hba->clk_scaling_lock);
> -
>  	ufshcd_init_clk_gating(hba);
> 
>  	ufshcd_init_clk_scaling(hba);
> @@ -8410,7 +8362,6 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
> 
>  	/* Hold auto suspend until async scan completes */
>  	pm_runtime_get_sync(dev);
> -	atomic_set(&hba->scsi_block_reqs_cnt, 0);
>  	/*
>  	 * We are assuming that device wasn't put in sleep/power-down
>  	 * state exclusively during the boot stage before kernel.
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 5865e16f53a6..c44bfcdb26a3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -520,7 +520,6 @@ struct ufs_stats {
>   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level 
> for
>   *  device is known or not.
> - * @scsi_block_reqs_cnt: reference counting for scsi block requests
>   */
>  struct ufs_hba {
>  	void __iomem *mmio_base;
> @@ -724,9 +723,7 @@ struct ufs_hba {
>  	enum bkops_status urgent_bkops_lvl;
>  	bool is_urgent_bkops_lvl_checked;
> 
> -	struct rw_semaphore clk_scaling_lock;
>  	struct ufs_desc_size desc_size;
> -	atomic_t scsi_block_reqs_cnt;
> 
>  	struct device		bsg_dev;
>  	struct request_queue	*bsg_queue;
