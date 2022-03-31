Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E9AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 23:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbiCaXoL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 19:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243114AbiCaXoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 19:44:10 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9131F24A75D
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:42:22 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-d39f741ba0so945339fac.13
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 16:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xt8JBNfpv1eA+03reeYiWzwi8ZXzovmxkkjAwNIyliU=;
        b=Hgp63FmIzN4yZBl04X9FYkJftBPFIpU5gbv0hmtTjZVV8nr+2LSlNKebWvDnunst1Q
         inOvcEjX28F4DQkLUb1ZeiBDPdD2k+lYk2i7t5b2udDMnRAGKf6/yzY8Kon/nP6sa9SM
         In6q+GZBTdcJVFtTD+dyh4B8Gon2WwQdFW5RFkFP4v/16nk0A3Pq+CM4zTma4hb9zWD5
         o89rVULQBc53X/aH2J+x+Jizn7Yc2wx8dl8g4wgM+R29t5u2G7XwHpGUc3I07UuosLEp
         vWo2vukFOEpF+Gq4p2hYRxM6DW1nn/KWuUxvA3O/8o+Q4ZDyG+UARFgpAxI/W8s5FKfN
         p1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xt8JBNfpv1eA+03reeYiWzwi8ZXzovmxkkjAwNIyliU=;
        b=4+DlXyUYlIjgxODNq4uzYc5330mNiRtgl8Mtf0mjDFkScTLih8miw54Y7Wfmtrha0u
         jXUwb0B54Ok10vYmdNSopST3FvBCp5IkrbMH2cOTjpLQspfYP4sHdPbRX1ZKvZabSnkQ
         q8/N6RBkpawJ5D7tJDorehvJeZ+F319X6JxyB+xtjwSmaYpArRTcGSJNdCJwAprgh6ei
         vDO/gLjIV6xgcpEZcpAeOdSm8NDL7bO5fUMYXYgiCtSKXzuMmZls1/q9Z3+h0bTZVqkf
         7hgdCAY8wHHHcOV2FVWfzKgdaZI0OGskYnIyQSfXrSa7IKhCgPX2jeOrfTDO/HPwvcHV
         5H7A==
X-Gm-Message-State: AOAM530zcIX30b5lH8ySOMxBf9WCLIzOP8ufrF8HM0OzaC3KZRl3i5mM
        fWsgP86VjREUk94jkpmbhaLqFA==
X-Google-Smtp-Source: ABdhPJwmvzD5Uo6DA2VwH1E+JeAGMZ2YepTpWP18OaPQy3Ks29J7mazh+SaQHXttQbO7EtQ1hQumww==
X-Received: by 2002:a05:6870:f14d:b0:de:d05c:474f with SMTP id l13-20020a056870f14d00b000ded05c474fmr3801127oac.2.1648770141354;
        Thu, 31 Mar 2022 16:42:21 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id 21-20020a056870121500b000ddb064e097sm373412oan.31.2022.03.31.16.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 16:42:20 -0700 (PDT)
Date:   Thu, 31 Mar 2022 16:44:50 -0700
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
Subject: Re: [PATCH 02/29] scsi: ufs: Remove superfluous boolean conversions
Message-ID: <YkY88lHdTiiaBcB7@ripper>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220331223424.1054715-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu 31 Mar 15:33 PDT 2022, Bart Van Assche wrote:

> Remove "? true : false" if the preceding expression yields a boolean or if
> the result of the expression is assigned to a boolean since in these two
> cases the "? true : false" part is superfluous.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> ---
>  drivers/scsi/ufs/ufs-qcom.c | 3 +--
>  drivers/scsi/ufs/ufshcd.c   | 9 ++++-----
>  drivers/scsi/ufs/ufshcd.h   | 2 +-
>  3 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 0d2e950d0865..808b677f6083 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -299,8 +299,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	struct phy *phy = host->generic_phy;
>  	int ret = 0;
> -	bool is_rate_B = (UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B)
> -							? true : false;
> +	bool is_rate_B = UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B;

UFS_QCOM_LIMIT_HS_RATE is defined as PA_HS_MODE_B. I wonder if this is
expected to change at some point, or if we could clean this up further
(in a future change).

Regards,
Bjorn

>  
>  	/* Reset UFS Host Controller and PHY */
>  	ret = ufs_qcom_host_reset(hba);
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dbf50b50870b..983fac14b7cd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -712,8 +712,7 @@ static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
>   */
>  static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
>  {
> -	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> -						DEVICE_PRESENT) ? true : false;
> +	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & DEVICE_PRESENT;
>  }
>  
>  /**
> @@ -840,7 +839,7 @@ ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
>  static inline bool ufshcd_is_exception_event(struct utp_upiu_rsp *ucd_rsp_ptr)
>  {
>  	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
> -			MASK_RSP_EXCEPTION_EVENT ? true : false;
> +			MASK_RSP_EXCEPTION_EVENT;
>  }
>  
>  /**
> @@ -1350,7 +1349,7 @@ static int ufshcd_devfreq_target(struct device *dev,
>  	}
>  
>  	/* Decide based on the rounded-off frequency and update */
> -	scale_up = (*freq == clki->max_freq) ? true : false;
> +	scale_up = *freq == clki->max_freq;
>  	if (!scale_up)
>  		*freq = clki->min_freq;
>  	/* Update the frequency */
> @@ -2800,7 +2799,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  	lrbp->sense_buffer = cmd->sense_buffer;
>  	lrbp->task_tag = tag;
>  	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
> -	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
> +	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
>  
>  	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
>  
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 949427714d0e..b2740b51a546 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -985,7 +985,7 @@ static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
>  
>  static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
>  {
> -	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) ? true : false;
> +	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit);
>  }
>  
>  static inline bool ufshcd_is_wb_allowed(struct ufs_hba *hba)
