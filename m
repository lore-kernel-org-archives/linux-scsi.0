Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84481C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F76923133
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbhAGH7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 02:59:43 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:24798 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGH7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 02:59:42 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610006358; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=eh6lfW3uqL1HP4IpqRvI2Eu6DOlhF/emSRVcj3uzQpU=;
 b=aLRUgeazeZGLlPqNJsDWrTsU+p8B6SB0KVHQ84JZ8Q/Jc5ATj7Pber4GPDpKa5Zkea6aeTl3
 T6lWcLLh924D81lXShsjmphRWvG7h+hECI5LoYrN/c3ovkx4YA9390N9+7i8CGUPEV7IveRN
 Z/GCmjC17rSZVUwHEoa72dvJAFM=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5ff6bf3bb95fc593269b1f1c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Jan 2021 07:58:51
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2D90FC43463; Thu,  7 Jan 2021 07:58:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 42940C433C6;
        Thu,  7 Jan 2021 07:58:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Jan 2021 15:58:50 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v4 1/2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
In-Reply-To: <20210107074710.549309-2-jaegeuk@kernel.org>
References: <20210107074710.549309-1-jaegeuk@kernel.org>
 <20210107074710.549309-2-jaegeuk@kernel.org>
Message-ID: <123c250afa715fb100ee7a482f6a15d8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-07 15:47, Jaegeuk Kim wrote:
> When gate_work/ungate_work gets an error during hibern8_enter or exit,
>  ufshcd_err_handler()
>    ufshcd_scsi_block_requests()
>    ufshcd_reset_and_restore()
>      ufshcd_clear_ua_wluns() -> stuck
>    ufshcd_scsi_unblock_requests()
> 
> In order to avoid it, ufshcd_clear_ua_wluns() can be called per 
> recovery flows
> such as suspend/resume, link_recovery, and error_handler.
> 
> Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd 
> resets")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bedb822a40a3..e6e7bdf99cd7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3996,6 +3996,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>  	if (ret)
>  		dev_err(hba->dev, "%s: link recovery failed, err %d",
>  			__func__, ret);
> +	else
> +		ufshcd_clear_ua_wluns(hba);
> 
>  	return ret;
>  }
> @@ -6003,6 +6005,9 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	ufshcd_scsi_unblock_requests(hba);
>  	ufshcd_err_handling_unprepare(hba);
>  	up(&hba->eh_sem);
> +
> +	if (!err && needs_reset)
> +		ufshcd_clear_ua_wluns(hba);
>  }
> 
>  /**
> @@ -6940,14 +6945,11 @@ static int
> ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>  	ufshcd_set_clk_freq(hba, true);
> 
>  	err = ufshcd_hba_enable(hba);
> -	if (err)
> -		goto out;
> 
>  	/* Establish the link again and restore the device */
> -	err = ufshcd_probe_hba(hba, false);
>  	if (!err)
> -		ufshcd_clear_ua_wluns(hba);
> -out:
> +		err = ufshcd_probe_hba(hba, false);
> +
>  	if (err)
>  		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
>  	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
> @@ -7718,6 +7720,8 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>  	if (ret)
>  		goto out;
> 
> +	ufshcd_clear_ua_wluns(hba);
> +
>  	/* Initialize devfreq after UFS device is detected */
>  	if (ufshcd_is_clkscaling_supported(hba)) {
>  		memcpy(&hba->clk_scaling.saved_pwr_info.info,
> @@ -7919,8 +7923,6 @@ static void ufshcd_async_scan(void *data,
> async_cookie_t cookie)
>  		pm_runtime_put_sync(hba->dev);
>  		ufshcd_exit_clk_scaling(hba);
>  		ufshcd_hba_exit(hba);
> -	} else {
> -		ufshcd_clear_ua_wluns(hba);
>  	}
>  }
> 
> @@ -8777,6 +8779,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		ufshcd_resume_clkscaling(hba);
>  	hba->clk_gating.is_suspended = false;
>  	hba->dev_info.b_rpm_dev_flush_capable = false;
> +	ufshcd_clear_ua_wluns(hba);
>  	ufshcd_release(hba);
>  out:
>  	if (hba->dev_info.b_rpm_dev_flush_capable) {
> @@ -8887,6 +8890,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
>  	}
> 
> +	ufshcd_clear_ua_wluns(hba);
> +
>  	/* Schedule clock gating in case of no access to UFS device yet */
>  	ufshcd_release(hba);

Reviewed-by: Can Guo <cang@codeaurora.org>
