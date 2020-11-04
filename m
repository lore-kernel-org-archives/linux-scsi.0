Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D49CBC388F7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 08:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712EF22384
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 08:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="CAdk3LWn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKDIFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 03:05:49 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:57468 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbgKDIFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Nov 2020 03:05:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604477149; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=wxfvwASrB/f3/DWt6ENzSLU3t+7wgE52tZwlT7h02PU=;
 b=CAdk3LWnD5uq+LPuaGXFoPV2Tn/4aa70gxEjqm9Giy8pVBKHJRj7ENQknW98QaRqHDsmOmNe
 pnjEB+L1Hs07zBvCWOH3YdFIv9QRLjsCUicKLgLcK/6+r0Y5bRZxNhPTRiNcS1JkZKRJM483
 id+anj59rlawIy4DzGH3B5mV7Js=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fa260c341e7c4fae7ef0a6f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 04 Nov 2020 08:05:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5E2F2C433FF; Wed,  4 Nov 2020 08:05:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 469C8C433C8;
        Wed,  4 Nov 2020 08:05:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 04 Nov 2020 16:05:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: Re: [PATCH V4 2/2] scsi: ufs: Allow an error return value from
 ->device_reset()
In-Reply-To: <20201103141403.2142-3-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
 <20201103141403.2142-3-adrian.hunter@intel.com>
Message-ID: <fc28a4a01f1376f72df03f0ce4c254f4@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-03 22:14, Adrian Hunter wrote:
> It is simpler for drivers to provide a ->device_reset() callback
> irrespective of whether the GPIO, or firmware interface necessary to do 
> the
> reset, is discovered during probe.
> 
> Change ->device_reset() to return an error code.  Drivers that provide
> the callback, but do not do the reset operation should return 
> -EOPNOTSUPP.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufs-mediatek.c |  4 +++-
>  drivers/scsi/ufs/ufs-qcom.c     |  6 ++++--
>  drivers/scsi/ufs/ufshcd.h       | 11 +++++++----
>  3 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c 
> b/drivers/scsi/ufs/ufs-mediatek.c
> index 8df73bc2f8cb..914a827a93ee 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -743,7 +743,7 @@ static int ufs_mtk_link_startup_notify(struct 
> ufs_hba *hba,
>  	return ret;
>  }
> 
> -static void ufs_mtk_device_reset(struct ufs_hba *hba)
> +static int ufs_mtk_device_reset(struct ufs_hba *hba)
>  {
>  	struct arm_smccc_res res;
> 
> @@ -764,6 +764,8 @@ static void ufs_mtk_device_reset(struct ufs_hba 
> *hba)
>  	usleep_range(10000, 15000);
> 
>  	dev_info(hba->dev, "device reset done\n");
> +
> +	return 0;
>  }
> 
>  static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 9a19c6d15d3b..357c3b49321d 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1422,13 +1422,13 @@ static void ufs_qcom_dump_dbg_regs(struct 
> ufs_hba *hba)
>   *
>   * Toggles the (optional) reset line to reset the attached device.
>   */
> -static void ufs_qcom_device_reset(struct ufs_hba *hba)
> +static int ufs_qcom_device_reset(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> 
>  	/* reset gpio is optional */
>  	if (!host->device_reset)
> -		return;
> +		return -EOPNOTSUPP;
> 
>  	/*
>  	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
> @@ -1439,6 +1439,8 @@ static void ufs_qcom_device_reset(struct ufs_hba 
> *hba)
> 
>  	gpiod_set_value_cansleep(host->device_reset, 0);
>  	usleep_range(10, 15);
> +
> +	return 0;
>  }
> 
>  #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 213be0667b59..5191d87f6263 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -323,7 +323,7 @@ struct ufs_hba_variant_ops {
>  	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
>  	void	(*dbg_register_dump)(struct ufs_hba *hba);
>  	int	(*phy_initialization)(struct ufs_hba *);
> -	void	(*device_reset)(struct ufs_hba *hba);
> +	int	(*device_reset)(struct ufs_hba *hba);
>  	void	(*config_scaling_param)(struct ufs_hba *hba,
>  					struct devfreq_dev_profile *profile,
>  					void *data);
> @@ -1207,9 +1207,12 @@ static inline void
> ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
>  static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
>  {
>  	if (hba->vops && hba->vops->device_reset) {
> -		hba->vops->device_reset(hba);
> -		ufshcd_set_ufs_dev_active(hba);
> -		ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, 0);
> +		int err = hba->vops->device_reset(hba);
> +
> +		if (!err)
> +			ufshcd_set_ufs_dev_active(hba);
> +		if (err != -EOPNOTSUPP)
> +			ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, err);
>  	}
>  }
