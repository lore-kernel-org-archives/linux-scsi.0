Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E77EC47088
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Dec 2022 07:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiLBHkg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Dec 2022 02:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiLBHkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2022 02:40:35 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE53B0B75
        for <linux-scsi@vger.kernel.org>; Thu,  1 Dec 2022 23:40:34 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s196so3753744pgs.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Dec 2022 23:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nDu6wdj2BavaJhgV2+IGABHC/KEWWb+4yyQcwbwd+rA=;
        b=vGIxaz68/q/F+Cc79hSj1Yrfct0QR+YaiyK5BQ4C6hiZyHx/8iu6y8E1PtRzXKEnzd
         s9nXKon0twvku4AZQbm055w40EBHnDL6JPYOlxUbIjUIXCKtG+4oo18baBM7adk7YXDd
         bAjOjJkst88dSaFg7cIdCItKVRFr1McJ6Q7rPs/U6W7ROvkGJ7oQyoGeQlWnH0dEDMn5
         2/OzC6HJQ47VwY9YtMb46EGL7qkqD8qEEMtUroNW33oXC1dZotRDcZJ+sQi0+ERv9Noz
         OL/BwIz8fRqvvb11QAIxCyGvhfs53+UOdgk0e3LxwwIEytbmELTBaAgUACZH2kBEQqbd
         HOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nDu6wdj2BavaJhgV2+IGABHC/KEWWb+4yyQcwbwd+rA=;
        b=2RKtSczYRTikgrysuTjAzvYv8wSrhP2b+t9gS2GaHtMd/cSKujG1hIGp0TnrlIUM2S
         0MoaBS5J/yNnmjSHXtQarMYuNGAzpdDIAW1rrdT089Qu4711HwzLflziU5hI/vKWR/ZN
         LxFdF2U+rZyjiEfy66kFZIZK6p9gdU9W1e1ltL/fpIfVdpooBMLsBSyrvzDpGUFn/Woz
         UROSNurUxTjrpX44h67yHgqi8tYI+pizk0S1Hzi8phEogolp2QN0/EYI1GbCCltCJ8mk
         aojzXIhOOFJ3luHIWje8Bg44xxqTZB5/pN7MdX1YR/eXhwIq0qS0jDp3eJDOD37fT8Lg
         4eWA==
X-Gm-Message-State: ANoB5pkZJB/HoCePfhss/FutlBPLsm9LvaDzHQoPwaqP9XlzNkospAh0
        I10XTmEl4Sj+T2okLAknl6H5asulvy2kA8A=
X-Google-Smtp-Source: AA0mqf5Ag5+BnQmSsuOlhiMDTVxXCd5381jopnyR1FNdrsNyFJE6Wo2Z9eXE7MXXIb3+AkYNm36GHw==
X-Received: by 2002:a63:ec07:0:b0:470:90f1:6216 with SMTP id j7-20020a63ec07000000b0047090f16216mr62174034pgh.42.1669966833731;
        Thu, 01 Dec 2022 23:40:33 -0800 (PST)
Received: from thinkpad ([27.111.75.154])
        by smtp.gmail.com with ESMTPSA id z15-20020a655a4f000000b0046faefad8a1sm3630828pgs.79.2022.12.01.23.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 23:40:32 -0800 (PST)
Date:   Fri, 2 Dec 2022 13:10:25 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     andersson@kernel.org, agross@kernel.org, konrad.dybcio@linaro.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        p.zabel@pengutronix.de, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] scsi: ufs: ufs-qcom: Use dev_err() where possible
Message-ID: <20221202074025.GE5356@thinkpad>
References: <20221201230810.1019834-1-ahalaney@redhat.com>
 <20221201230810.1019834-5-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221201230810.1019834-5-ahalaney@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 01, 2022 at 05:08:10PM -0600, Andrew Halaney wrote:
> dev_err() statements are better to use than pr_err(), so switch to
> those.
> 
> In a similar vein, the check on the dev_req_params pointer here is
> not needed, the two places this function is called never pass in a
> NULL pointer, so instead of using dev_err() there just remove it.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Thanks,
Mani

> ---
>  drivers/ufs/host/ufs-qcom.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index b1fcff1fad0c..4350c44a6fc7 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -680,12 +680,6 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  	struct ufs_dev_params ufs_qcom_cap;
>  	int ret = 0;
>  
> -	if (!dev_req_params) {
> -		pr_err("%s: incoming dev_req_params is NULL\n", __func__);
> -		ret = -EINVAL;
> -		goto out;
> -	}
> -
>  	switch (status) {
>  	case PRE_CHANGE:
>  		ufshcd_init_pwr_dev_param(&ufs_qcom_cap);
> @@ -709,7 +703,7 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  					       dev_max_params,
>  					       dev_req_params);
>  		if (ret) {
> -			pr_err("%s: failed to determine capabilities\n",
> +			dev_err(hba->dev, "%s: failed to determine capabilities\n",
>  					__func__);
>  			goto out;
>  		}
> -- 
> 2.38.1
> 

-- 
மணிவண்ணன் சதாசிவம்
