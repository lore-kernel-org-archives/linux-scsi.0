Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC77DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 04:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhLNEDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 23:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhLNEDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 23:03:38 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E79C061574
        for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2021 20:03:38 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id o4so25837853oia.10
        for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2021 20:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i32icve8673k720YVo1tKB1l/xkhbldeyR+7P4jn/Qs=;
        b=jm8bh1arndyqhAZcdKJ+tHUAoPq4qNPxV90AMeD+23/Cf+bG9wb2opLubaAAYigwYs
         m9s06OBJVDsw9mc7vFQG2Vcgae83SfbosyuCqyFDKaKQHhKwjMsA4zzi5xdwjC6j76Bt
         3W5qZWqp8kvHtKyAO/7yNjaSkIBlS0vASLdYHe+DDXdIofgBo4p9bD0k913WloqPuJ3m
         MtJZ4OnHgApKuX+mUHoVodI+kP7NqqHNxpETkcyEay55QFA/3xkCbImY2OYh7Qr6tAI+
         3YQNP+MUt14qXl5U2bxKYsiZaUB2iS+gqSDK4N4/oAcc976ftY/svIputZ88t9YjKA3G
         8XUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i32icve8673k720YVo1tKB1l/xkhbldeyR+7P4jn/Qs=;
        b=EyFg8z12Qzg42mmmd1GNcR+lmDEypSkWWVKmZU2Vf0IvtiT63i6Dmokg1YCPJLWssR
         K7FFEWrkIV5/oN+WRcV3Vh/1Abjglxo/7BcXJ7CNugpILzyt4XaQ5I4/vFPQdnIM/NII
         8VN1F4LaCrgmbWmiRT09MFd9H2D8Oq9h1FNpFFiuer+BzC23K2k10066IEMVZuXVakfT
         +yxIK+WqUuzjyBpi0nq0t5wHJNQk9b+Jh+0pMGe+wmQJ/eh9M7uiZZ3/b7hMSOI7KiV3
         GOK9keu0rRrZLOvQbYaWrFbuDqP+eEZv5vFOLIiN4QwJ3DllaEnulmowhUP5ZE7vNDFc
         +Ikg==
X-Gm-Message-State: AOAM531NKGOLz7TrWbcIpOay2bS2PkvmuCd1fK66ZKGu5zmx/185pCaR
        US/FvC7vKqn537fXFxMlUKI0Pg==
X-Google-Smtp-Source: ABdhPJwZmgx7IoMGORd9bjU+cMDyFXOOVlvH2QlSqRcUWEiYEhTMuHrcsKToT+9ZGF2//Sxd8LJ55Q==
X-Received: by 2002:a05:6808:1589:: with SMTP id t9mr31767818oiw.108.1639454617839;
        Mon, 13 Dec 2021 20:03:37 -0800 (PST)
Received: from ripper (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id l24sm2500229oou.20.2021.12.13.20.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 20:03:37 -0800 (PST)
Date:   Mon, 13 Dec 2021 20:04:54 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: Re: [PATCH v4 16/17] scsi: ufs: Optimize the command queueing code
Message-ID: <YbgX5qZ4VFXPqnnr@ripper>
References: <20211203231950.193369-1-bvanassche@acm.org>
 <20211203231950.193369-17-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211203231950.193369-17-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri 03 Dec 15:19 PST 2021, Bart Van Assche wrote:

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

This patch landed between next-20211203 and today's (20211210)
linux-next/master and prevents all Qualcomm boards I've tested to boot.

Sometimes it locks up right around probe, sometimes I actually get some
partitions, but attempts to then access the storage media (e.g. fdisk
-l) results in one or more of my CPUs to be unresponsive.

> Cc: Asutosh Das (asd) <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++++++----------
>  drivers/scsi/ufs/ufshcd.h |  1 +
>  2 files changed, 24 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9f0a1f637030..650dddf960c2 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1070,13 +1070,31 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
>  	return false;
>  }
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

As far as I can tell, this will crab walk across hba->host->__devices,
while grabbing:

        spin_lock_irqsave(shost->host_lock, flags);

which afaict is:

        spin_lock_irqsave(hba->host->host_lock, flags);



> +		pending += sbitmap_weight(&sdev->budget_map);
> +
> +	return pending;
> +}
> +
>  static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>  					u64 wait_timeout_us)
>  {
>  	unsigned long flags;
>  	int ret = 0;
>  	u32 tm_doorbell;
> -	u32 tr_doorbell;
> +	u32 tr_pending;
>  	bool timeout = false, do_last_check = false;
>  	ktime_t start;
>  
> @@ -1094,8 +1112,8 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,

But just before entering this loop you do:

        spin_lock_irqsave(hba->host->host_lock, flags);

In other words, you're taking the same spinlock twice, while being in
ufshcd_scsi_block_requests(). To me this seems that if we ever enter
this code path (i.e. try to do clock scaling) we will deadlock one CPU.

Can you please help me understand what I'm missing? Or how you tested
this?

Thanks,
Bjorn

>  		}
>  
>  		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> -		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> -		if (!tm_doorbell && !tr_doorbell) {
> +		tr_pending = ufshcd_pending_cmds(hba);
> +		if (!tm_doorbell && !tr_pending) {
>  			timeout = false;
>  			break;
>  		} else if (do_last_check) {
> @@ -1115,12 +1133,12 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
>  			do_last_check = true;
>  		}
>  		spin_lock_irqsave(hba->host->host_lock, flags);
> -	} while (tm_doorbell || tr_doorbell);
> +	} while (tm_doorbell || tr_pending);
>  
>  	if (timeout) {
>  		dev_err(hba->dev,
>  			"%s: timedout waiting for doorbell to clear (tm=0x%x, tr=0x%x)\n",
> -			__func__, tm_doorbell, tr_doorbell);
> +			__func__, tm_doorbell, tr_pending);
>  		ret = -EBUSY;
>  	}
>  out:
> @@ -2681,9 +2699,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  
>  	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
>  
> -	if (!down_read_trylock(&hba->clk_scaling_lock))
> -		return SCSI_MLQUEUE_HOST_BUSY;
> -
>  	/*
>  	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
>  	 * calls.
> @@ -2772,8 +2787,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  out:
>  	rcu_read_unlock();
>  
> -	up_read(&hba->clk_scaling_lock);
> -
>  	if (ufs_trigger_eh()) {
>  		unsigned long flags;
>  
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 8e942762e668..88c20f3608c2 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -778,6 +778,7 @@ struct ufs_hba_monitor {
>   * @clk_list_head: UFS host controller clocks list node head
>   * @pwr_info: holds current power mode
>   * @max_pwr_info: keeps the device max valid pwm
> + * @clk_scaling_lock: used to serialize device commands and clock scaling
>   * @desc_size: descriptor sizes reported by device
>   * @urgent_bkops_lvl: keeps track of urgent bkops level for device
>   * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
> 
