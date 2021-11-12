Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9419DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 23:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 679C661054
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 23:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhKLXnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Nov 2021 18:43:39 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:22525 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhKLXni (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2021 18:43:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636760447; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=7EdxlT6CcEB0bXpN68cimdsH4tuOg1kDc8ab1lTFq9o=; b=Ox52LI95KmsW+lIylhskS9WYdsQr2bT84gBUlqZG0JidAmNTkpCO019KS0Rfs/pNBzRztfcS
 yTPc7oC/66YPB9XLeRJ1ibWbL/7lhyy02oV2stnAUvDvhIBnsEP+N3CeJrN/27ZkLrx3C9+J
 b8CfJhnlZoWcboMftF+YCGS27rE=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 618efb7eafd1f629a8fc68c0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 12 Nov 2021 23:40:46
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5A634C43618; Fri, 12 Nov 2021 23:40:46 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02CB1C4338F;
        Fri, 12 Nov 2021 23:40:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 02CB1C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <240aab87-3d81-755a-f412-e36868b9c430@codeaurora.org>
Date:   Fri, 12 Nov 2021 15:40:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 10/11] scsi: ufs: Optimize the command queueing code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211110004440.3389311-1-bvanassche@acm.org>
 <20211110004440.3389311-11-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211110004440.3389311-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 11/9/2021 4:44 PM, Bart Van Assche wrote:
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. As requested by Asutosh Das, change the behavior
> of ufshcd_clock_scaling_prepare() from waiting until all pending > commands have finished into quiescing request queues. Insert a

Umm, I was suggesting the following in prepare():
* The requests in the queue should not be issued - as is done now by 
ufshcd_scsi_block_requests()
* The ongoing requests in DBR should be completed i.e. DBR = 0.
* Proceed with scaling

The below code is not waiting for the ongoing requests to complete i.e. 
There's no call to wait for DBR to be 0.
I think waiting for DBR to be 0 is still needed.

> rcu_read_lock() / rcu_read_unlock() pair in ufshcd_queuecommand() and also
> in __ufshcd_issue_tm_cmd(). Use synchronize_rcu_expedited() to wait for
> ongoing command and TMF queueing.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 121 +++++++++++++-------------------------
>   drivers/scsi/ufs/ufshcd.h |   1 +
>   2 files changed, 42 insertions(+), 80 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 13848e93cda8..36df89e8a575 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1069,65 +1069,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>   	return false;
>   }
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
>   /**
>    * ufshcd_scale_gear - scale up/down UFS gear
>    * @hba: per adapter instance
> @@ -1175,37 +1116,51 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
>   
>   static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>   {
> -	#define DOORBELL_CLR_TOUT_US		(1000 * 1000) /* 1 sec */
> -	int ret = 0;
> +	struct scsi_device *sdev;
> +
>   	/*
> -	 * make sure that there are no outstanding requests when
> -	 * clock scaling is in progress
> +	 * Make sure that no commands are being queued while clock scaling
> +	 * is in progress.
> +	 *
> +	 * Since ufshcd_exec_dev_cmd() and ufshcd_issue_devman_upiu_cmd() lock
> +	 * the clk_scaling_lock before calling blk_get_request(), lock
> +	 * clk_scaling_lock before freezing the request queues to prevent lock
> +	 * inversion.
>   	 */
> -	ufshcd_scsi_block_requests(hba);
>   	down_write(&hba->clk_scaling_lock);
> -
> -	if (!hba->clk_scaling.is_allowed ||
> -	    ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
> -		ret = -EBUSY;
> +	if (!hba->clk_scaling.is_allowed) {
>   		up_write(&hba->clk_scaling_lock);
> -		ufshcd_scsi_unblock_requests(hba);
> -		goto out;
> +		return -EBUSY;
>   	}
> -
> +	blk_mq_quiesce_queue_nowait(hba->tmf_queue);
> +	blk_mq_quiesce_queue_nowait(hba->cmd_queue);
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_quiesce_queue_nowait(sdev->request_queue);
> +	/*
> +	 * Calling synchronize_rcu_expedited() reduces the time required to
> +	 * quiesce request queues from milliseconds to microseconds.
> +	 *
> +	 * See also the rcu_read_lock() and rcu_read_unlock() calls in
> +	 * ufshcd_queuecommand() and also in __ufshcd_issue_tm_cmd().
> +	 */
> +	synchronize_rcu_expedited();
>   	/* let's not get into low power until clock scaling is completed */
>   	ufshcd_hold(hba, false);
> -
> -out:
> -	return ret;
> +	return 0;
>   }
>   
>   static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>   {
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unquiesce_queue(sdev->request_queue);
> +	blk_mq_unquiesce_queue(hba->cmd_queue);
> +	blk_mq_unquiesce_queue(hba->tmf_queue);
>   	if (writelock)
>   		up_write(&hba->clk_scaling_lock);
>   	else
>   		up_read(&hba->clk_scaling_lock);
> -	ufshcd_scsi_unblock_requests(hba);
>   	ufshcd_release(hba);
>   }
>   
> @@ -2698,8 +2653,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>   
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> +	/*
> +	 * Allows ufshcd_clock_scaling_prepare() and also the UFS error handler
> +	 * to wait for prior ufshcd_queuecommand() calls.
> +	 */
> +	rcu_read_lock();
>   
>   	switch (hba->ufshcd_state) {
>   	case UFSHCD_STATE_OPERATIONAL:
> @@ -2780,7 +2738,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	ufshcd_send_command(hba, tag);
>   out:
> -	up_read(&hba->clk_scaling_lock);
> +	rcu_read_unlock();
>   
>   	if (ufs_trigger_eh()) {
>   		unsigned long flags;
> @@ -5977,8 +5935,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
>   	}
>   	ufshcd_scsi_block_requests(hba);
>   	/* Drain ufshcd_queuecommand() */
> -	down_write(&hba->clk_scaling_lock);
> -	up_write(&hba->clk_scaling_lock);
> +	synchronize_rcu();
>   	cancel_work_sync(&hba->eeh_work);
>   }
>   
> @@ -6582,6 +6539,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>   	req->end_io_data = &wait;
>   	ufshcd_hold(hba, false);
>   
> +	rcu_read_lock();
> +
>   	spin_lock_irqsave(host->host_lock, flags);
>   
>   	task_tag = req->tag;
> @@ -6600,6 +6559,8 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>   
>   	spin_unlock_irqrestore(host->host_lock, flags);
>   
> +	rcu_read_unlock();
> +
>   	ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_SEND);
>   
>   	/* wait until the task management command is completed */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 65178487adf3..7afe818ab1e3 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -778,6 +778,7 @@ struct ufs_hba_monitor {
>    * @clk_list_head: UFS host controller clocks list node head
>    * @pwr_info: holds current power mode
>    * @max_pwr_info: keeps the device max valid pwm
> + * @clk_scaling_lock: used to serialize device commands and clock scaling
>    * @desc_size: descriptor sizes reported by device
>    * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>    * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
