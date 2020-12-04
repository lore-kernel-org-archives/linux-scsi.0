Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A439BC4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0D922519
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgLDD1D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 22:27:03 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:39327 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbgLDD1D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 22:27:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607052404; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=aiTONYRNd6Usbi2ahCG39HakveG8khxqD02yr5/luQs=;
 b=FvJOtQE1+syXeBEyoKJdiUXk8R4Pxq10TP4H+zKFR+7OkLNRmtAcECzX+pB/dmc6ghHlhZvl
 7EmriMrP+jZLiVghdQI8SNNXciBWRdxN6guLXjmMujR79W0iQdIHT9G8uMl+PvPgkgercA5X
 j15aGWKAlbAWJy/z58l/g9Geik4=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fc9ac5856444c64457f01d1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Dec 2020 03:26:16
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CF459C43465; Fri,  4 Dec 2020 03:26:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9BA1C433CA;
        Fri,  4 Dec 2020 03:26:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Dec 2020 11:26:14 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
In-Reply-To: <20201130181143.5739-3-huobean@gmail.com>
References: <20201130181143.5739-1-huobean@gmail.com>
 <20201130181143.5739-3-huobean@gmail.com>
Message-ID: <c4e810873ac9e15735369d0159fbb664@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-01 02:11, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Keep device power mode as active power mode and VCC supply only if
> fWriteBoosterBufferFlushDuringHibernate setting 1 is successful.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h    |  2 ++
>  drivers/scsi/ufs/ufshcd.c | 11 ++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index d593edb48767..311d5f7a024d 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -530,6 +530,8 @@ struct ufs_dev_info {
>  	bool f_power_on_wp_en;
>  	/* Keeps information if any of the LU is power on write protected */
>  	bool is_lu_power_on_wp;
> +	/* Indicates if flush WB buffer during hibern8 successfully enabled 
> */
> +	bool is_hibern8_wb_flush;
>  	/* Maximum number of general LU supported by the UFS device */
>  	u8 max_lu_supported;
>  	u8 wb_dedicated_lu;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 639ba9d1ccbb..eb7a2534b072 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -285,10 +285,16 @@ static inline void ufshcd_wb_config(struct 
> ufs_hba *hba)
>  		dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
>  	else
>  		dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
> +
>  	ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
> -	if (ret)
> +	if (ret) {
>  		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
>  			__func__, ret);
> +		hba->dev_info.is_hibern8_wb_flush = false;
> +	} else {
> +		hba->dev_info.is_hibern8_wb_flush = true;
> +	}
> +
>  	ufshcd_wb_toggle_flush(hba, true);
>  }
> 
> @@ -5440,6 +5446,9 @@ static bool ufshcd_wb_need_flush(struct ufs_hba 
> *hba)
> 
>  	if (!ufshcd_is_wb_allowed(hba))
>  		return false;
> +
> +	if (!hba->dev_info.is_hibern8_wb_flush)
> +		return false;

The check is in the wrong place - even if say
fWriteBoosterBufferFlushDuringHibernate is failed to be enabled,
ufshcd_wb_need_flush() still needs to reflect the fact that whether
the wb buffer needs to be flushed or not - it should not be decided
by the flag.

Thanks,

Can Guo.

>  	/*
>  	 * The ufs device needs the vcc to be ON to flush.
>  	 * With user-space reduction enabled, it's enough to enable flush
