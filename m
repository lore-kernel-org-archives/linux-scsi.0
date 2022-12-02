Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE83C4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 07:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiLBHhM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 02:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiLBHhL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 02:37:11 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7A5A6CD2
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 23:37:09 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id s7so3917050plk.5
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 23:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v8EzqfSGrKt0+PHubujBc9RugZwOBEDnIxuRQOYqgLg=;
        b=uE9e/g0Rc0U4fIPOv+rfOuxbcgl9nc6SsRSfER0ZqYqxlZgovkbPPfLSEAC0M2XoMy
         cbBNHhEB9JNt8cRSBhuoj7XmC1mC4z1TWn7Em6Pt5SKT6Gkd3G3qwcUWPviChljEUi3C
         /H8Ts8r43kbQvzhiZ6MQRgxWbknr3+J6B2HXMxfdRBsAYFwXAJaZhCBlWGJE1TCKK3J6
         V4BmBzUhgJA+tmVYkbMPlbMdxSe0MLc7Zgsc6c0D+jEZvU8SeINYoDfrqFlavgUPBk7r
         b9ozHtChTc4a4c3dktevo8QM9iai2gg+NZTHUqw5b9i1WtyT9oomTBv221K2zISaMsT5
         RX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v8EzqfSGrKt0+PHubujBc9RugZwOBEDnIxuRQOYqgLg=;
        b=A/6+sirTCFpTUq7IJk/+vskGJUMzW834bQnMHDBBW4UEGd3eeLem9478PyymIC7Dks
         yZpvYPslQEl1CiM2ZbQ27boZIi2J7JpHCvBuWqq6o6BlWiqwcryhsrx+a/63pQmBraaE
         S93T7v5wZdYjCbSZNZ8eJVjK/FHaS4AHIjIN5kOj7cVO9ixb4jKitjTF5TUwmG4LMm+O
         hHGBg4GYLOs62iBMZk5puXUa+GV8oU2seCzTdqQ0uL2TBtY9cFPc8JgoSMyFn+dKnyI2
         eZOHzd0Qb03Qxv19NgO2ijz1VVZryGBmb73cppKPF5OPCInlvIXJBeQMWG+H/cNKuMnN
         4YRQ==
X-Gm-Message-State: ANoB5plfK9XTCZHnbD8m790mUlb3jzP033ZIuzQFLYVpOpa1zlRxnxoG
        62xtDI/yQY8QF0RMLJUrIe9F
X-Google-Smtp-Source: AA0mqf5dBSPwTJGINLDmi44mhflWO6OpZpePZIaM1d9jIOH40Yc8WTnnOpaaOaH3pnPqDyHC4rOo3g==
X-Received: by 2002:a17:90a:4812:b0:219:6618:cf46 with SMTP id a18-20020a17090a481200b002196618cf46mr11922938pjh.176.1669966629041;
        Thu, 01 Dec 2022 23:37:09 -0800 (PST)
Received: from thinkpad ([27.111.75.154])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b0021358bd24b9sm6039691pjf.21.2022.12.01.23.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 23:37:08 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:06:54 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     andersson@kernel.org, agross@kernel.org, konrad.dybcio@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        p.zabel@pengutronix.de, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: ufs: ufs-qcom: Drop unnecessary NULL checks
Message-ID: <20221202073654.GB5356@thinkpad>
References: <20221201230810.1019834-1-ahalaney@redhat.com>
 <20221201230810.1019834-2-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221201230810.1019834-2-ahalaney@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 01, 2022 at 05:08:07PM -0600, Andrew Halaney wrote:
> This code path is only called through one function, and the hba
> struct is already accessed in ufshcd_vops_dbg_register_dump() prior to
> calling so there is no way for it to be NULL.
> 
> Likewise, the print_fn callback is always supplied within this driver
> and is always provided.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 8ad1415e10b6..70e25f9f8ca8 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1202,15 +1202,6 @@ static void ufs_qcom_print_hw_debug_reg_all(struct ufs_hba *hba,
>  	u32 reg;
>  	struct ufs_qcom_host *host;
>  
> -	if (unlikely(!hba)) {
> -		pr_err("%s: hba is NULL\n", __func__);
> -		return;
> -	}
> -	if (unlikely(!print_fn)) {
> -		dev_err(hba->dev, "%s: print_fn is NULL\n", __func__);
> -		return;
> -	}
> -
>  	host = ufshcd_get_variant(hba);
>  	if (!(host->dbg_print_en & UFS_QCOM_DBG_PRINT_REGS_EN))
>  		return;
> -- 
> 2.38.1
> 

-- 
மணிவண்ணன் சதாசிவம்
