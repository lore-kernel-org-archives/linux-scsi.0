Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2012DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 18:24:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbhKWS10 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 13:27:26 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:48182 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhKWS10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 13:27:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637691858; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=kaODoVl8ogW2xM/bLvPJNTJ+LzYWP4PCfGjVEIJk8Ik=; b=TMGpwzPHUiTI1oP85Q7TIzhPtUGmLdWvpIEPzsKpuR27iTCbTTqMPoGreQ3kVq2pBwg5JqO8
 1tVleSg1zcXSJc12Z7K8tYx0Kjq0edgTPeUK4rBohFcY9HTzMFyTLho+TYFCqvyINjE10bsR
 6QuOfLxDXmc08ucH03hXRGVIruM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 619d31cde7d68470af3ae28a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Nov 2021 18:24:13
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 97DE7C43616; Tue, 23 Nov 2021 18:24:12 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6C654C4338F;
        Tue, 23 Nov 2021 18:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 6C654C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <b3d2764a-8dd3-1c4e-675d-c43039d28850@codeaurora.org>
Date:   Tue, 23 Nov 2021 10:24:05 -0800
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
 <a2599b2c-208c-3333-61f0-d61a269b53d4@codeaurora.org>
 <f6eb1b4c-ef73-7e34-cecd-fa0c9ce07a2f@acm.org>
 <2071f69b-885f-e0c5-3ded-9f0c39eb38ae@codeaurora.org>
 <6dea2d9c-c04a-20a5-4292-e48badf89ba2@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <6dea2d9c-c04a-20a5-4292-e48badf89ba2@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/2021 3:48 PM, Bart Van Assche wrote:
> On 11/22/21 3:02 PM, Asutosh Das (asd) wrote:
>> Current code waits for the already issued requests to complete. It 
>> doesn't issue the yet-to-be issued requests. Wouldn't freezing the 
>> queue issue the requests in the context of scaling_{up/down}?
>> If yes, I don't think the current code is doing that.
> 
> Hi Asutosh,
> 
> How about the patch below that preserves most of the existing code for
> preparing for clock scaling?
> 
> Thanks,
> 
> Bart.
> 
Hi Bart,
This looks good to me. Please push a change and I can test it out.

-asd

> 
> Subject: [PATCH] scsi: ufs: Optimize the command queueing code
> 
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. Instead, use synchronize_rcu_expedited() to wait
> for ongoing ufshcd_queuecommand() calls.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>   drivers/scsi/ufs/ufshcd.h |  1 +
>   2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5d214456bf82..1d929c28efaf 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1196,6 +1196,13 @@ static int ufshcd_clock_scaling_prepare(struct 
> ufs_hba *hba)
>       /* let's not get into low power until clock scaling is completed */
>       ufshcd_hold(hba, false);
> 
> +    /*
> +     * Wait for ongoing ufshcd_queuecommand() calls. Calling
> +     * synchronize_rcu_expedited() instead of synchronize_rcu() reduces 
> the
> +     * waiting time from milliseconds to microseconds.
> +     */
> +    synchronize_rcu_expedited();
> +
>   out:
>       return ret;
>   }
> @@ -2699,9 +2706,6 @@ static int ufshcd_queuecommand(struct Scsi_Host 
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
> @@ -2790,8 +2794,6 @@ static int ufshcd_queuecommand(struct Scsi_Host 
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
> index c13ae56fbff8..695bede14dac 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -777,6 +777,7 @@ struct ufs_hba_monitor {
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
