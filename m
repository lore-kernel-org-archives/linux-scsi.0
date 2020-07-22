Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C318EC433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 05:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A107220771
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 05:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xqa2/MrE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgGVFJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 01:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgGVFJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 01:09:12 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7484DC0619DC
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 22:09:12 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id gc15so2353694pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 22:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9aCd9NtKF/vghwfZSkT5vRhcwR7QYUOcY/eyczQvy2g=;
        b=xqa2/MrEV6nc1rOrErxYL+BVLXUbCYRoG/UlThvcgNe/TdO0NyaApryfTnaVst2oLL
         a7CFTr2BYQZO5jERv9jONQNnBTjrENjCDGsnplOn1V0ZAexSY/z6SX2vT26IN/pnxUAG
         mcpGIrJgXwkJ1zUkWaKJbKmczSupmGNeLDfTSiKfj+ybeoUbveBPofJznFuSqxSv4kDL
         0T9cY143+T4NLWYtpUOevYf6BOSW1uJ9dcY20hnQbClEgbEA+CTbFkttT7GSJnI4tJUr
         8yS6+lLSt0hKH111khkA5J4Kh6KFzD9tNwPOQUa3m4DOLVgdnit9T+zYbfPu+O6xj8hn
         SnvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9aCd9NtKF/vghwfZSkT5vRhcwR7QYUOcY/eyczQvy2g=;
        b=X1RmWUevfx+s5LjkPrPGRNH39CdjXJ/D29FEMbc9elOj4IpMKDyUB+cKyHxUfg5ZQx
         jFH6GX2/1uy+gYe03Fgd9MEHVKjE6YBKcKwPg6mZJV9eyZrPBF3wnQxYs+yrheq29QvU
         g3MxRE9DVToHGb9ixq1gPnRgjoz057t5HFQvLzzP+tTAXGWAEKMsKlU/wv1yrIOHjM8j
         MqoHcR0+itB70afdZiKZ/gCfE89dkBhuKRxZfWOUhL026//Hstsf9pRmhn0dE+pJVgX4
         aP1GHKkofRs1y5J755+PFKz3uNM2ogFEgK0IDyDq2KkZSRgKgevuVNKcPslY3NcfbLji
         tsnA==
X-Gm-Message-State: AOAM530mlfoJ/Ll9BJ6GVh+QvPk0UFVm965zaagNMAkdoXi9/jhwLjN5
        y4bjVXJP/cufcCYF4S/Z/oSkmKrJ2lA=
X-Google-Smtp-Source: ABdhPJzYbkFViPW7GdZ63z+fmzPml6qzx2lRBJa+fk5nmDmYVbL1SQppXLUpDaMeTaelWEg0d8ZEug==
X-Received: by 2002:a17:902:b78a:: with SMTP id e10mr25415501pls.34.1595394551656;
        Tue, 21 Jul 2020 22:09:11 -0700 (PDT)
Received: from builder.lan (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id q29sm22454694pfl.77.2020.07.21.22.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 22:09:10 -0700 (PDT)
Date:   Tue, 21 Jul 2020 22:07:17 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: Re: [PATCH v6 2/5] scsi: ufs-qcom: name the dev_ref_clk_ctrl
 registers
Message-ID: <20200722050717.GS388985@builder.lan>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710072013.177481-3-ebiggers@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri 10 Jul 00:20 PDT 2020, Eric Biggers wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> In preparation for adding another optional register range to the
> ufs-qcom driver, name the existing optional register range
> "dev_ref_clk_ctrl_mem".  This allows the driver to refer to the optional
> register ranges by name rather than index.
> 
> No device-tree files actually have to be updated due to this change,
> since none of them actually declares these registers.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 2e6ddb5cdfc2..bd0b4ed7b37a 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1275,7 +1275,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  		host->dev_ref_clk_en_mask = BIT(26);
>  	} else {
>  		/* "dev_ref_clk_ctrl_mem" is optional resource */
> -		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						   "dev_ref_clk_ctrl_mem");
>  		if (res) {
>  			host->dev_ref_clk_ctrl_mmio =
>  					devm_ioremap_resource(dev, res);
> -- 
> 2.27.0
> 
