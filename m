Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB71C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 04:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 463FC2250E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 04:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgLUEZu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 23:25:50 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:20211 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgLUEZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 23:25:50 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608524729; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=En2K2o4SNOWEm5Xvdc5IP6FiohNN1iBzFuGQTffyEi8=;
 b=IHK3U7fOUte+uC+Rx53zoTZErTYYtOorVvviT4bclDUpACTwHpP+UibWw80UZkIAyPXqtaaP
 z8fvLam0i2lOm6qORuMbEpxRcdivLjtdHfvZFXsVqxURzgurwLoCw8wAYoPuxMnMOwMOfjNE
 Vn5cfkXUP8Ch+ZLoJTdRLjvcmro=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fe0239ff5e9af65f83da20f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 21 Dec 2020 04:25:03
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE036C43464; Mon, 21 Dec 2020 04:25:02 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2FA8CC433C6;
        Mon, 21 Dec 2020 04:25:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Dec 2020 12:25:02 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
In-Reply-To: <20201218033131.2624065-1-jaegeuk@kernel.org>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
Message-ID: <153e563a381c580f76447a12df9f4138@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-18 11:31, Jaegeuk Kim wrote:
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
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e221add25a7e..e711def829cd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3963,6 +3963,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>  	if (ret)
>  		dev_err(hba->dev, "%s: link recovery failed, err %d",
>  			__func__, ret);
> +	else
> +		ufshcd_clear_ua_wluns(hba);
> 
>  	return ret;
>  }
> @@ -5968,6 +5970,8 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	ufshcd_scsi_unblock_requests(hba);
>  	ufshcd_err_handling_unprepare(hba);
>  	up(&hba->eh_sem);
> +

Maybe add a check like if (!err && needs_reset) as error handler
also handles non-fatal errors which do not require a full reset
and restore?

> +	ufshcd_clear_ua_wluns(hba);
>  }
> 
>  /**
> @@ -6908,14 +6912,11 @@ static int
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
> @@ -8745,6 +8746,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		ufshcd_resume_clkscaling(hba);
>  	hba->clk_gating.is_suspended = false;
>  	hba->dev_info.b_rpm_dev_flush_capable = false;
> +	ufshcd_clear_ua_wluns(hba);
>  	ufshcd_release(hba);
>  out:
>  	if (hba->dev_info.b_rpm_dev_flush_capable) {
> @@ -8855,6 +8857,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
>  	}
> 
> +	ufshcd_clear_ua_wluns(hba);
> +
>  	/* Schedule clock gating in case of no access to UFS device yet */
>  	ufshcd_release(hba);
