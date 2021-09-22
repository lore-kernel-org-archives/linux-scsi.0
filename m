Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BACC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 19:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4F5611CA
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 19:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhIVT4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 15:56:51 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:45991 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhIVT4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2021 15:56:50 -0400
Received: by mail-oi1-f178.google.com with SMTP id v10so6132775oic.12;
        Wed, 22 Sep 2021 12:55:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=abOL9qzAqzalMqTfMNtbzdXg01us+Jm/OUCRBffQQyY=;
        b=VXZrTi4rJlzV3+cD/HQCibe5NImHlwaEDWOoAWxRw73T9u+JGFPbWYNOcaiuhVgZwm
         6pP7q8O6Wdfsx2f9jkaJy2Yu9/nQ0c0dIRb2hN8Z420WOy3RvWTB3Xh2FQCTPFaDqybJ
         CVOylFn7hRlq724DJipEi2gtaCHpPpzB2ChK/rMv5efKhnOUvWsY/H8Mj/qTj6ttRfM2
         dOYJDjAeRGhj8JT3+PGUHQwESpsNLudim/jH+/79mVJFwJAN/Ax3ClmjFDjeSbmzmZLB
         voyXXdlYDo5ph/99x9WDpX3yXYb2XTHlR7Mv1k6UxmlRUSOuikQXYLFQvwmXKzkrvMFr
         B05w==
X-Gm-Message-State: AOAM531hKOJ3nLLB2qzmHtXoBafTLkY/oqIMRWmjesopm/19fefBvuMp
        ohU+BjztA2e2I6e9XsRIjQ==
X-Google-Smtp-Source: ABdhPJz9c1t0vA0ltdJ5qQJa5HH58JhRz2hxffrPUkIR/OPtPDtb+zfD8kM6migi2kv9+Q9JtvyIZA==
X-Received: by 2002:a54:4e94:: with SMTP id c20mr772996oiy.57.1632340519932;
        Wed, 22 Sep 2021 12:55:19 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q13sm730428ota.17.2021.09.22.12.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 12:55:19 -0700 (PDT)
Received: (nullmailer pid 1188160 invoked by uid 1000);
        Wed, 22 Sep 2021 19:55:18 -0000
Date:   Wed, 22 Sep 2021 14:55:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Can Guo <cang@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: Re: [PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Message-ID: <YUuKJj7+wmJd7DSe@robh.at.kernel.org>
References: <20210917065436.145629-1-chanho61.park@samsung.com>
 <CGME20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10@epcas2p4.samsung.com>
 <20210917065436.145629-7-chanho61.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917065436.145629-7-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 17, 2021 at 03:54:25PM +0900, Chanho Park wrote:
> UFS_EMBD sharability register of fsys block provides "sharability"
> setting of ufs-exynos. It can be set via syscon and regmap.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Kiwoong Kim <kwmad.kim@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufs-exynos.c | 5 +++++
>  drivers/scsi/ufs/ufs-exynos.h | 1 +
>  2 files changed, 6 insertions(+)

This patch is a nop... Fold it into the patch using sysreg.

> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 8a17ba32a721..f7a1b99c823b 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> +#include <linux/mfd/syscon.h>
>  #include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  
> @@ -906,6 +907,10 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
>  		goto out;
>  	}
>  
> +	ufs->sysreg = syscon_regmap_lookup_by_phandle(np, "sysreg");
> +	if (IS_ERR(ufs->sysreg))
> +		ufs->sysreg = NULL;
> +
>  	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
>  	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
>  
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
> index 2e72aabaa673..4f93db893ce8 100644
> --- a/drivers/scsi/ufs/ufs-exynos.h
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> @@ -191,6 +191,7 @@ struct exynos_ufs {
>  	struct ufs_phy_time_cfg t_cfg;
>  	ktime_t entry_hibern8_t;
>  	const struct exynos_ufs_drv_data *drv_data;
> +	struct regmap *sysreg;
>  
>  	u32 opts;
>  #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
> -- 
> 2.33.0
> 
> 
