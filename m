Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778C8C3526D
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 05:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54007233CE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 05:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgLTFfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 00:35:08 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:59710 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726992AbgLTFfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 00:35:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608442488; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=F1NRqFZ48ZFXmbY/V7WStJ8zv3KK1BiVkBIhSrlffhA=;
 b=m3XxQDBn35gdTwfNDz3S8ezt6D6L4NQIYOQoPADIRQ4ZlAwcX8rxlZOnS+IPthCdUibqSSa8
 crOgq7vE7ylDmTRGQQrIiAnR05dKX6CIU3JZjAefWdN8avx5bXYnNZKVlaPvfy8kE2s8Gjwm
 wWX+RjAZjSYjTMZFRka8uUFvzPw=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fdee25c031793dcb4d7bca6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 20 Dec 2020 05:34:20
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3A729C43463; Sun, 20 Dec 2020 05:34:20 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E3CA2C433CA;
        Sun, 20 Dec 2020 05:34:18 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 20 Dec 2020 13:34:18 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [RFC PATCH v1] ufs: relocate turning off device power sources
In-Reply-To: <1608359248-16079-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20201219063815epcas2p1ffd277f7e53d9680abb460f55a53c599@epcas2p1.samsung.com>
 <1608359248-16079-1-git-send-email-kwmad.kim@samsung.com>
Message-ID: <3d662ee3155a56108da13e3cf12f17dc@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-19 14:27, Kiwoong Kim wrote:
> UFS specification says that while powering off the device,
> RST_n signal and REF_CLK signal should be between VSS and VCCQ.
> One of ways to make it is to drive both RST_n and REF_CLK to low.
> 
> However, the current location of turning off them doesn't
> guarantee that. ufshcd_link_state_transition make enter hibern8
> but it's not supposed to adjust the level of REF_CLK. Adding
> ufshcd_vops_device_reset isn't proper because it just drives the
> level of RST_n to low and then to high, not keep low.
> In this situation, it could make those levels be
> diverged from those proper ranges with actual hardware situations,
> especially right when the driver turns off power.
> 
> The easist way to make it is just to move the location of turning
> off because lowering the levels can be enabled through
> the callbacks named suspend and setup_clocks.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 92d433d..dab9840 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8633,8 +8633,6 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  	if (ret)
>  		goto set_dev_active;
> 
> -	ufshcd_vreg_set_lpm(hba);
> -
>  disable_clks:
>  	/*
>  	 * Call vendor specific suspend callback. As these callbacks may 
> access
> @@ -8662,6 +8660,13 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>  					hba->clk_gating.state);
>  	}
> 
> +	/*
> +	 * It should follows driving RST_n and REF_CLK
> +	 * in the range specified in UFS specification
> +	 */
> +	if (!ufshcd_is_ufs_dev_active(hba))
> +		ufshcd_vreg_set_lpm(hba);
> +
>  	/* Put the host controller in low power mode if possible */
>  	ufshcd_hba_vreg_set_lpm(hba);
>  	goto out;

Ziqi Chen has a change to totally fix the UFS power-on/off spec 
violation,
see https://lore.kernel.org/patchwork/patch/1351118/ and he is working 
on V2,
can we wait for his change?

Thanks,

Can Guo.
