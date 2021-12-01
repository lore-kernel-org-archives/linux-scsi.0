Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97D2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 23:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353795AbhLAXgl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 18:36:41 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:17197 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343755AbhLAXgj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 18:36:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1638401597; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=Y54jBmLO9M4LrIMP/clt2t2OC3TCLw7TUdgOAfIh+pE=; b=f1dAVi27K2bzPFEf6adoLYFn15EIlsnxLx7CSb57YZSLPY4cfNN5MAYxHb1d815enXY2R/Ot
 D+vVhfV9ClBCJvOAELATiTovzV5Cck2lPHTcf4lKKORPgTiPRWppOjggAWZ2OYEUtHBjqWUu
 cKnaROIecZbUP1vRKplPbyFN4sI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 61a8063de7d68470afdb6798 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 01 Dec 2021 23:33:17
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4A66C43616; Wed,  1 Dec 2021 23:33:16 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF634C4338F;
        Wed,  1 Dec 2021 23:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org AF634C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <1be2859c-c698-7bfd-2ed1-ea17bbeedad7@codeaurora.org>
Date:   Wed, 1 Dec 2021 15:33:13 -0800
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
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211130233324.1402448-17-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/2021 3:33 PM, Bart Van Assche wrote:
> Remove the clock scaling lock from ufshcd_queuecommand() since it is a
> performance bottleneck. Instead, use synchronize_rcu_expedited() to wait
> for ongoing ufshcd_queuecommand() calls.
> 
> Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ufs/ufshcd.c | 12 +++++++-----
>   drivers/scsi/ufs/ufshcd.h |  1 +
>   2 files changed, 8 insertions(+), 5 deletions(-)
> 
Hi Bart,
Say an IO (req1) has crossed the scsi_host_queue_ready() check but 
hasn't yet reached ufshcd_queuecommand() and DBR is 0.
ufshcd_clock_scaling_prepare() is invoked and completes and scaling 
proceeds to change the clocks and gear.
I wonder if the IO (req1) would be issued while scaling is in progress.
If so, do you think a check should be added in ufshcd_queuecommand() to 
see if scaling is in progress or if host is blocked?

> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c4cf5c4b4893..3e4c62c6f9d2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1196,6 +1196,13 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>   	/* let's not get into low power until clock scaling is completed */
>   	ufshcd_hold(hba, false);
>   
> +	/*
> +	 * Wait for ongoing ufshcd_queuecommand() calls. Calling
> +	 * synchronize_rcu_expedited() instead of synchronize_rcu() reduces the
> +	 * waiting time from milliseconds to microseconds.
> +	 */
> +	synchronize_rcu_expedited();
> +
>   out:
>   	return ret;
>   }
> @@ -2681,9 +2688,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>   
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> - >   	/*
>   	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
>   	 * calls.
> @@ -2772,8 +2776,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   out:
>   	rcu_read_unlock();
>   
> -	up_read(&hba->clk_scaling_lock);
> -
>   	if (ufs_trigger_eh()) {
>   		unsigned long flags;
>   
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index c3c2792f309f..411c6015bbfe 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -779,6 +779,7 @@ struct ufs_hba_monitor {
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
