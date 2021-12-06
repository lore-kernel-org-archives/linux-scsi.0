Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2FAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Dec 2021 22:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351254AbhLFWpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 17:45:51 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:62399 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359520AbhLFWp0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 17:45:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638830517; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=LJZSWapBIZLhgFvIVvGnR5Ybs8OKtx8dHiUW5wkwBQk=; b=oRpAGy1Y/2kzuo/RTC+XpyxU0seyE1kXFwVa2Wp3oFlgt0gfKxa+Mta1YxU5yjST/Hbg7AFq
 JKh6mUT0uRP/IrCWNvOvSPKGorR//CQm8gRB6J+5T3Kbtu8Zbj8/XN+O23EJQfplnDGKRgNw
 bh6f7OfnIt1Pk1kz+U7RVsG748I=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 61ae91b403b7c5d147c6d80f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 06 Dec 2021 22:41:56
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 616D1C14934; Mon,  6 Dec 2021 22:41:56 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 782BFC4162C;
        Mon,  6 Dec 2021 22:41:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 782BFC4162C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <0ba5c50f-3e79-2cae-c502-59f70812cca3@codeaurora.org>
Date:   Mon, 6 Dec 2021 14:41:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <20211203231950.193369-17-bvanassche@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211203231950.193369-17-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/2021 3:19 PM, Bart Van Assche wrote:
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. Instead check the SCSI device budget bitmaps in
> the code that waits for ongoing ufshcd_queuecommand() calls. A bit is
> set in sdev->budget_map just before scsi_queue_rq() is called and a bit
> is cleared from that bitmap if scsi_queue_rq() does not submit the
> request or after the request has finished. See also the
> blk_mq_{get,put}_dispatch_budget() calls in the block layer.
> 
> There is no risk for a livelock since the block layer delays queue
> reruns if queueing a request fails because the SCSI host has been
> blocked.
> 
> Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++++----------
>   drivers/scsi/ufs/ufshcd.h |  1 +
>   2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9f0a1f637030..650dddf960c2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1070,13 +1070,31 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>   	return false;
>   }
>   
> +/*
> + * Determine the number of pending commands by counting the bits in the SCSI
> + * device budget maps. This approach has been selected because a bit is set in
> + * the budget map before scsi_host_queue_ready() checks the host_self_blocked
> + * flag. The host_self_blocked flag can be modified by calling
> + * scsi_block_requests() or scsi_unblock_requests().
> + */
> +static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
> +{
> +	struct scsi_device *sdev;
> +	u32 pending = 0;
> +
> +	shost_for_each_device(sdev, hba->host)
> +		pending += sbitmap_weight(&sdev->budget_map);
> +
> +	return pending;
> +}
> +
>   static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>   					u64 wait_timeout_us)
>   {
>   	unsigned long flags;
>   	int ret = 0;
>   	u32 tm_doorbell;
> -	u32 tr_doorbell;
> +	u32 tr_pending;
>   	bool timeout = false, do_last_check = false;
>   	ktime_t start;
>   
> @@ -1094,8 +1112,8 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>   		}
>   
>   		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -		if (!tm_doorbell && !tr_doorbell) {
> +		tr_pending = ufshcd_pending_cmds(hba);
> +		if (!tm_doorbell && !tr_pending) {
>   			timeout = false;
>   			break;
>   		} else if (do_last_check) {
> @@ -1115,12 +1133,12 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>   			do_last_check = true;
>   		}
>   		spin_lock_irqsave(hba->host->host_lock, flags);
> -	} while (tm_doorbell || tr_doorbell);
> +	} while (tm_doorbell || tr_pending);
>   
>   	if (timeout) {
>   		dev_err(hba->dev,
>   			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
> -			__func__, tm_doorbell, tr_doorbell);
> +			__func__, tm_doorbell, tr_pending);
>   		ret = -EBUSY;
>   	}
>   out:
> @@ -2681,9 +2699,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>   
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> -
>   	/*
>   	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
>   	 * calls.
> @@ -2772,8 +2787,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   out:
>   	rcu_read_unlock();
>   
> -	up_read(&hba->clk_scaling_lock);
> -
>   	if (ufs_trigger_eh()) {
>   		unsigned long flags;
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 8e942762e668..88c20f3608c2 100644
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
