Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4B9C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 23:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243145AbiCaXor (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243114AbiCaXoq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 19:44:46 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942E724A75E
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:42:58 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-de48295467so1011005fac.2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QRKrQvgV5Pp+4tnkgxMv4Q7ffxuLRmO7HOTiVB6W7jo=;
        b=NqFuNZXHHDFYPlRY0x01qda9X306I+X02BBggr+iYNqw8s6EWr7hY0UbDRDahbl/kH
         PnL0NS1raO4Nr+bnMN0F7Op91DkpgVlnOrjZd0X1s5zu4xXL6gPFJ6D16H5n1f+/9XIY
         W9tIP52lqAfPAHST6fZhk7pXpDDpWkzb3nHMq8SqZh45ORIJoY5BBhCPt3z322sU4C2L
         5L4h/jtaTxTJgPaiEn4BPdY4RWF4MrYyOsDO2tURGMP4eGt53mc/QQcOc0ZUwHdhVa84
         egPNztwHlAqsELrYAFu1i1LUSC379CkBKeeEWP3coK7XTyS1ocafF04rzIxnsjJlESP0
         EfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QRKrQvgV5Pp+4tnkgxMv4Q7ffxuLRmO7HOTiVB6W7jo=;
        b=fjbI39FzXUe5dnT0ublmdBhdL6LdQ+l8QeVI2VXWcgIIK3k5KIplPVNllNei3/6kiS
         xvQa293PaMa6XvLzxoVIznRKYF+JTESXgmkwHUkAA42Uo3srkqqjNoBhtbWF1883G/Z+
         G1zBxBgRiGKAUMqKOp6wONNi5R0nb4FUi2SiuipZIkShS1o+/0nc3PtTpddsN0hLlibF
         MXDfqQr5Au0nXt9WF8OD57LEwEdXAEGZtsTuVJ3SykXOhz/XQEZSfUBMF81WEYF2OCmI
         0AFExVDf1IBPmbv21t0xCtFP7KtHqu4YwaPn7VdYMPNPzbtPWvc1y+rNqkrrazNg7EnR
         Uu+A==
X-Gm-Message-State: AOAM5326O11iO+mUmXg1vz9Yv4FStSRaqdtMK0+zOy+u4K7ss9kMkxa6
        4KVojNXNdN0flKECGoqwARmcBw==
X-Google-Smtp-Source: ABdhPJx34R8KlO1+Q/Yd7Z7k7Hlf+eVT4cIjR65jA7/7ctqVgXmhrNHmii1pijkwI6UxD4HEzLASDQ==
X-Received: by 2002:a05:6870:f29a:b0:de:eaa4:233a with SMTP id u26-20020a056870f29a00b000deeaa4233amr3803816oap.137.1648770177880;
        Thu, 31 Mar 2022 16:42:57 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id i28-20020a9d4a9c000000b005ce06a77de2sm494137otf.48.2022.03.31.16.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 16:42:57 -0700 (PDT)
Date:   Thu, 31 Mar 2022 16:45:26 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Andy Gross <agross@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH 03/29] scsi: ufs: Simplify statements that return a
 boolean
Message-ID: <YkY9Flf2mrOUyQ3j@ripper>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331223424.1054715-4-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 31 Mar 15:33 PDT 2022, Bart Van Assche wrote:

> Convert "if (expr) return true; else return false;" into "return expr;"
> if either 'expr' is a boolean expression or the return type of the
> function is 'bool'.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
>  drivers/scsi/ufs/ufs-qcom.h |  5 +----
>  drivers/scsi/ufs/ufshcd.c   | 22 +++++-----------------
>  2 files changed, 6 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
> index 8208e3a3ef59..51570224a6e2 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -239,10 +239,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host);
>  
>  static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)
>  {
> -	if (host->caps & UFS_QCOM_CAP_QUNIPRO)
> -		return true;
> -	else
> -		return false;
> +	return host->caps & UFS_QCOM_CAP_QUNIPRO;
>  }
>  
>  /* ufs-qcom-ice.c */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 983fac14b7cd..c60519372b3b 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -939,10 +939,7 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
>  	 * logic simple, we will only do manual tuning if local unipro version
>  	 * doesn't support ver1.6 or later.
>  	 */
> -	if (ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6)
> -		return true;
> -	else
> -		return false;
> +	return ufshcd_get_local_unipro_ver(hba) < UFS_UNIPRO_VER_1_6;
>  }
>  
>  /**
> @@ -2216,10 +2213,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>   */
>  static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
>  {
> -	if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY)
> -		return true;
> -	else
> -		return false;
> +	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY;
>  }
>  
>  /**
> @@ -5781,10 +5775,7 @@ static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
>  		return false;
>  	}
>  	/* Let it continue to flush when available buffer exceeds threshold */
> -	if (avail_buf < hba->vps->wb_flush_threshold)
> -		return true;
> -
> -	return false;
> +	return avail_buf < hba->vps->wb_flush_threshold;
>  }
>  
>  static void ufshcd_wb_force_disable(struct ufs_hba *hba)
> @@ -5863,11 +5854,8 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
>  		return false;
>  	}
>  
> -	if (!hba->dev_info.b_presrv_uspc_en) {
> -		if (avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10))
> -			return true;
> -		return false;
> -	}
> +	if (!hba->dev_info.b_presrv_uspc_en)
> +		return avail_buf <= UFS_WB_BUF_REMAIN_PERCENT(10);
>  
>  	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
>  }
