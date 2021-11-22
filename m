Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D3BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 17:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbhKVRtN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:49:13 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:38902 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbhKVRtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 12:49:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637603165; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=s0R2sQQv4b+/8ApM5Z1DgPYSpACQbUFG5gF7xgQxIYY=; b=b5dLKBG/G7edmXVhMBdd6d6hPUKC5i23mRtRnSXO+cjPPnuFxPEOzBB/vXlxiSyxaNUte9jm
 5gQgodkAeWnZXw7FYlLXajW8knREX81viDHtr78GRZswhuHMKvpdXQWRukBeVd1ZmkXb43+r
 P5+r68sxfFnHiRnMyx1xn9TTsPI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 619bd75dbebfa3d4d51ac9d8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Nov 2021 17:46:05
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E2F38C4361A; Mon, 22 Nov 2021 17:46:04 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C98F2C4338F;
        Mon, 22 Nov 2021 17:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org C98F2C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
Date:   Mon, 22 Nov 2021 09:46:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v2 18/20] scsi: ufs: Optimize the command queueing code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-19-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211119195743.2817-19-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/2021 11:57 AM, Bart Van Assche wrote:
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. Freeze request queues instead of polling the
> doorbell registers to wait until pending commands have completed.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 124 +++++++++++++-------------------------
>   drivers/scsi/ufs/ufshcd.h |   1 +
>   2 files changed, 44 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a6d3f71c6b00..9cf4a22f1950 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1070,65 +1070,6 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>   	return false;
>   }
>   
[...]
>   /**
>    * ufshcd_scale_gear - scale up/down UFS gear
>    * @hba: per adapter instance
> @@ -1176,37 +1117,63 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
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
> +	 * Make sure that no commands are in progress while the clock frequency
> +	 * is being modified.
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
> -		up_write(&hba->clk_scaling_lock);
> -		ufshcd_scsi_unblock_requests(hba);
> -		goto out;
> -	}
> -
> +	if (!hba->clk_scaling.is_allowed)
> +		goto busy;
> +	blk_freeze_queue_start(hba->tmf_queue);
> +	blk_freeze_queue_start(hba->cmd_queue);
> +	shost_for_each_device(sdev, hba->host)
> +		blk_freeze_queue_start(sdev->request_queue);
This would still issue the requests present in the queue before freezing 
and that's a concern.
> +	/*
> +	 * Calling synchronize_rcu_expedited() reduces the time required to
> +	 * freeze request queues from milliseconds to microseconds.
> +	 */
> +	synchronize_rcu_expedited();
> +	shost_for_each_device(sdev, hba->host)
> +		if (blk_mq_freeze_queue_wait_timeout(sdev->request_queue, HZ)
> +		    <= 0)
> +			goto unfreeze;
> +	if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue, HZ) <= 0 ||
> +	    blk_mq_freeze_queue_wait_timeout(hba->tmf_queue, HZ / 10) <= 0)
> +		goto unfreeze;
>   	/* let's not get into low power until clock scaling is completed */
>   	ufshcd_hold(hba, false);
> +	return 0;
>   
> -out:
> -	return ret;
> +unfreeze:
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue(sdev->request_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
> +
> +busy:
> +	up_write(&hba->clk_scaling_lock);
> +	return -EBUSY;
>   }
>   
>   static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
>   {
> +	struct scsi_device *sdev;
> +
> +	shost_for_each_device(sdev, hba->host)
> +		blk_mq_unfreeze_queue(sdev->request_queue);
> +	blk_mq_unfreeze_queue(hba->cmd_queue);
> +	blk_mq_unfreeze_queue(hba->tmf_queue);
>   	if (writelock)
>   		up_write(&hba->clk_scaling_lock);
>   	else
>   		up_read(&hba->clk_scaling_lock);
> -	ufshcd_scsi_unblock_requests(hba);
>   	ufshcd_release(hba);
>   }
>   
> @@ -2699,9 +2666,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>   
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> -
>   	/*
>   	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
>   	 * calls.
> @@ -2790,8 +2754,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   out:
>   	rcu_read_unlock();
>   
> -	up_read(&hba->clk_scaling_lock);
> -
>   	if (ufs_trigger_eh()) {
>   		unsigned long flags;
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index e9bc07c69a80..7ec463c97d64 100644
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
