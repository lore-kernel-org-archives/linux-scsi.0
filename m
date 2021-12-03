Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF197C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 15:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381850AbhLCPlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 10:41:36 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:59140 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381851AbhLCPlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 10:41:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638545891; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=+9v8SOY/VaGQsDLAFovBBgOlnkRUDdcSuH59fyLOz5U=; b=COJkmkssFT4c6vSqEyMI+QRRXJDG8p8AI3eMzk97B3iBQK5UdwAHd5SnlzSR5o8HKtepAsJ8
 T4qVzsrnhJRZZjumi3MUE4HKlVrOFp4N43SP01CorcRblQnAMQP+xnXeBHALoLCInogejjqg
 aEkr62WhMINfU4KGGuprY4Fh7GQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 61aa39e22c7dc0a764646a6e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 03 Dec 2021 15:38:10
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A1F7DC4361C; Fri,  3 Dec 2021 15:38:10 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 71D3FC4338F;
        Fri,  3 Dec 2021 15:38:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 71D3FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <a3975294-2cd2-381a-8ad6-e5ee73f41f8c@codeaurora.org>
Date:   Fri, 3 Dec 2021 07:38:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v3 16/17] scsi: ufs: Optimize the command queueing code
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
References: <20211130233324.1402448-1-bvanassche@acm.org>
 <20211130233324.1402448-17-bvanassche@acm.org>
 <1be2859c-c698-7bfd-2ed1-ea17bbeedad7@codeaurora.org>
 <1be02f4a-2ab6-63fd-f6f2-3825c28ef4e5@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <1be02f4a-2ab6-63fd-f6f2-3825c28ef4e5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/2021 10:13 AM, Bart Van Assche wrote:
> On 12/1/21 3:33 PM, Asutosh Das (asd) wrote:
>> Hi Bart,
>> Say an IO (req1) has crossed the scsi_host_queue_ready() check but 
>> hasn't yet reached ufshcd_queuecommand() and DBR is 0.
>> ufshcd_clock_scaling_prepare() is invoked and completes and scaling 
>> proceeds to change the clocks and gear.
>> I wonder if the IO (req1) would be issued while scaling is in progress.
>> If so, do you think a check should be added in ufshcd_queuecommand() 
>> to see if scaling is in progress or if host is blocked?
> 
> How about using the patch below instead of patch 16/17 from this patch
> series? The patch below should not trigger the race condition mentioned
> above.
> 
> Thanks,
> 
> Bart.
> 
Hi Bart,
This looks like it'd work.

-asd
> 
> Subject: [PATCH] scsi: ufs: Optimize the command queueing code
> 
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. Instead, wait until all budget_maps have cleared
> to wait for ongoing ufshcd_queuecommand() calls.
> 
> Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++++----------
>   drivers/scsi/ufs/ufshcd.h |  1 +
>   2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c4cf5c4b4893..be679f2a97da 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1070,13 +1070,31 @@ static bool 
> ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>       return false;
>   }
> 
> +/*
> + * Determine the number of pending commands by counting the bits in the 
> SCSI
> + * device budget maps. This approach has been selected because a bit is 
> set in
> + * the budget map before scsi_host_queue_ready() checks the 
> host_self_blocked
> + * flag. The host_self_blocked flag can be modified by calling
> + * scsi_block_requests() or scsi_unblock_requests().
> + */
> +static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
> +{
> +    struct scsi_device *sdev;
> +    u32 pending;
> +
> +    shost_for_each_device(sdev, hba->host)
> +        pending += sbitmap_weight(&sdev->budget_map);
> +
> +    return pending;
> +}
> +
>   static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>                       u64 wait_timeout_us)
>   {
>       unsigned long flags;
>       int ret = 0;
>       u32 tm_doorbell;
> -    u32 tr_doorbell;
> +    u32 tr_pending;
>       bool timeout = false, do_last_check = false;
>       ktime_t start;
> 
> @@ -1094,8 +1112,8 @@ static int ufshcd_wait_for_doorbell_clr(struct 
> ufs_hba *hba,
>           }
> 
>           tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -        tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -        if (!tm_doorbell && !tr_doorbell) {
> +        tr_pending = ufshcd_pending_cmds(hba);
> +        if (!tm_doorbell && !tr_pending) {
>               timeout = false;
>               break;
>           } else if (do_last_check) {
> @@ -1115,12 +1133,12 @@ static int ufshcd_wait_for_doorbell_clr(struct 
> ufs_hba *hba,
>               do_last_check = true;
>           }
>           spin_lock_irqsave(hba->host->host_lock, flags);
> -    } while (tm_doorbell || tr_doorbell);
> +    } while (tm_doorbell || tr_pending);
> 
>       if (timeout) {
>           dev_err(hba->dev,
>               "%s: timedout waiting for doorbell to clear (tm=0x%x, 
> tr=0x%x)\n",
> -            __func__, tm_doorbell, tr_doorbell);
> +            __func__, tm_doorbell, tr_pending);
>           ret = -EBUSY;
>       }
>   out:
> @@ -2681,9 +2699,6 @@ static int ufshcd_queuecommand(struct Scsi_Host 
> *host, struct scsi_cmnd *cmd)
> 
>       WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
> 
> -    if (!down_read_trylock(&hba->clk_scaling_lock))
> -        return SCSI_MLQUEUE_HOST_BUSY;
> -
>       /*
>        * Allows the UFS error handler to wait for prior 
> ufshcd_queuecommand()
>        * calls.
> @@ -2772,8 +2787,6 @@ static int ufshcd_queuecommand(struct Scsi_Host 
> *host, struct scsi_cmnd *cmd)
>   out:
>       rcu_read_unlock();
> 
> -    up_read(&hba->clk_scaling_lock);
> -
>       if (ufs_trigger_eh()) {
>           unsigned long flags;
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c3c2792f309f..411c6015bbfe 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -779,6 +779,7 @@ struct ufs_hba_monitor {
>    * @clk_list_head: UFS host controller clocks list node head
>    * @pwr_info: holds current power mode
>    * @max_pwr_info: keeps the device max valid pwm
> + * @clk_scaling_lock: used to serialize device commands and clock scaling
>    * @desc_size: descriptor sizes reported by device
>    * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>    * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level 
> for


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
