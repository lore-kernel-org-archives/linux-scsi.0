Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF01C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Apr 2022 16:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449863AbiDVQyG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Apr 2022 12:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449853AbiDVQyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2022 12:54:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72CB35F8DB
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650646269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RP65Uj7WP6EZyZBfeufvI+9bp/deJnrcdnu1tws0K2A=;
        b=eobIQEF+JItsaZSp4OIlGcxwaJNG8KfdhJNqGfcqe/OrtmrsCMIYQZUwOUjxye+U0rM6YR
        MF+c8aZF+C6twlrdJfdzY+YvwyhSw7xzJ6oRGjbDjc7Y91MgOjRb2P618K7CJL6b9cyRNP
        j9QvJKCvVATIvgR4M7vg7Wf4duC3y8s=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-eHdD9-iRPF6dz30G4QMLFw-1; Fri, 22 Apr 2022 12:51:08 -0400
X-MC-Unique: eHdD9-iRPF6dz30G4QMLFw-1
Received: by mail-qt1-f199.google.com with SMTP id f22-20020ac840d6000000b002dd4d87de21so5348345qtm.23
        for <linux-scsi@vger.kernel.org>; Fri, 22 Apr 2022 09:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RP65Uj7WP6EZyZBfeufvI+9bp/deJnrcdnu1tws0K2A=;
        b=MeafwwuWqHxaB9euUDA6PvuwK/wB2jUfq5hMbq9ewojSVrDz2eI66bfMzE1qOjvQy8
         19ycZqY0rIZ4ZQyA8GYauOiUfNOxJZp6FBffo3bi6HSH228GuFtdobIMSH7ACw2Zf2yA
         Kx3YhtJmkKY/cpKAXS+ZUOFqlbzqY1i/h+SKRx2/JhSYm7T5vt47ueMHsvbEl3PK4dIY
         pRRLpqUI4SQC95bpNTDwvp7acGPWwrQk35riGK3ejYH3h/bF0/7s3rsqRTnjOQE9awvS
         ATShRsaWJeBGydpMPQqkXhTShdjL3dSj1AlNJVy2Rwi4vVJFfV/CL03mQ3LYaUDN9lZG
         GPiQ==
X-Gm-Message-State: AOAM530jxXGTKZ+aSYAIZgKZhKnjUPq5L+Wy8WsjfH5+zkLsgBRcvjzJ
        bWYTcgnArJ1NOU4l8VLQ2n69vp0Dqh1Bjxwy2Iqs4lnMk9HU2GlPFnDj12JJMb8qUlXRl7BUaxW
        ts8YrvFCnRIj6JawqRQiiHw==
X-Received: by 2002:a37:6181:0:b0:69e:7b8a:e72c with SMTP id v123-20020a376181000000b0069e7b8ae72cmr3255241qkb.388.1650646265968;
        Fri, 22 Apr 2022 09:51:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGjpvtzYiKxHawYsICXnZfMhkhwABbqQn0p9KPy6KU0/ydqClvRwXk3Olfd1QtTvoihYpO3g==
X-Received: by 2002:a37:6181:0:b0:69e:7b8a:e72c with SMTP id v123-20020a376181000000b0069e7b8ae72cmr3255217qkb.388.1650646265599;
        Fri, 22 Apr 2022 09:51:05 -0700 (PDT)
Received: from halaneylaptop (068-184-200-203.res.spectrum.com. [68.184.200.203])
        by smtp.gmail.com with ESMTPSA id e16-20020ac85990000000b002f33eb4523asm1542421qte.18.2022.04.22.09.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 09:51:04 -0700 (PDT)
Date:   Fri, 22 Apr 2022 11:51:01 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] scsi: ufs: qcom: Simplify handling of devm_phy_get()
Message-ID: <20220422165101.uy23jf3conuxr2iw@halaneylaptop>
References: <20220422132140.313390-1-manivannan.sadhasivam@linaro.org>
 <20220422132140.313390-3-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422132140.313390-3-manivannan.sadhasivam@linaro.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 22, 2022 at 06:51:37PM +0530, Manivannan Sadhasivam wrote:
> There is no need to call devm_phy_get() if ACPI is used, so skip it.
> The "host->generic_phy" pointer should already be NULL due to the kzalloc,
> so no need to set it NULL again.
> 
> Also, don't print the error message in case of -EPROBE_DEFER and return
> the error code directly.
> 
> While at it, also remove the comment that has no relationship with
> devm_phy_get().
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 26 +++++---------------------
>  1 file changed, 5 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 5db0fd922062..5f0a8f646eb5 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1022,28 +1022,12 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  		err = 0;
>  	}
>  
> -	/*
> -	 * voting/devoting device ref_clk source is time consuming hence
> -	 * skip devoting it during aggressive clock gating. This clock
> -	 * will still be gated off during runtime suspend.
> -	 */
> -	host->generic_phy = devm_phy_get(dev, "ufsphy");
> -
> -	if (host->generic_phy == ERR_PTR(-EPROBE_DEFER)) {
> -		/*
> -		 * UFS driver might be probed before the phy driver does.
> -		 * In that case we would like to return EPROBE_DEFER code.
> -		 */
> -		err = -EPROBE_DEFER;
> -		dev_warn(dev, "%s: required phy device. hasn't probed yet. err = %d\n",
> -			__func__, err);
> -		goto out_variant_clear;
> -	} else if (IS_ERR(host->generic_phy)) {
> -		if (has_acpi_companion(dev)) {
> -			host->generic_phy = NULL;
> -		} else {
> +	if (!has_acpi_companion(dev)) {
> +		host->generic_phy = devm_phy_get(dev, "ufsphy");
> +		if (IS_ERR(host->generic_phy)) {
>  			err = PTR_ERR(host->generic_phy);
> -			dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
> +			if (err != -EPROBE_DEFER)
> +				dev_err(dev, "Failed to get PHY: %d\n", err);

Risking sounding like a bad broken record, but I think this too could
use dev_err_probe().

Looks good to me otherwise!

>  			goto out_variant_clear;
>  		}
>  	}
> -- 
> 2.25.1
> 

