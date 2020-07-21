Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D7DDC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 17:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED09B20792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 17:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QE8ZRoDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGUR55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgGUR54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 13:57:56 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6568C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=SaNy6x9ZowgjLJc8COtsIMw/PHpEhiDWMViB8mW7ycc=; b=QE8ZRoDsCNBUq77ltvpaJ+lFB9
        HvNQUCc5QVRiZDWzZ/E3f6xRn+vgvFX/8bPSkKcnuh0ZTV1iH6j3bmeIrEAdjgioVZ+ezXkz4FOD1
        TlqfrGPdv1g1ggmY3VcVRZUBPUAtGazgSpAL/9UCm50nwSYrWYMUBzy5ATtkZ5tBtnIZzuU9Vp+LQ
        ScMLy5k8yM1jUdpu3pM2LVIjuplVcH5P6lya61stcaKfg5aUvw6Js3lFCI444H/zGszSFe1TFt15W
        h3PQUxtFSkAkztHdehnAjeqgVsnmHTTl9FsbUii7a1HMHSjBXnSCGc4SzqUml8rDm8ub89suBum8y
        rAMRYWqw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxwWW-0005kr-S9; Tue, 21 Jul 2020 17:57:53 +0000
Subject: Re: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config
 warning
To:     Alim Akhtar <alim.akhtar@samsung.com>, martin.petersen@oracle.com
Cc:     avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        sfr@canb.auug.org.au
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com>
 <20200721172021.28922-1-alim.akhtar@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <857eba45-475e-e2ea-86ba-e495794ae74c@infradead.org>
Date:   Tue, 21 Jul 2020 10:57:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721172021.28922-1-alim.akhtar@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/20 10:20 AM, Alim Akhtar wrote:
> With !CONFIG_OF and SCSI_UFS_EXYNOS selected, the below
> warning is given:
> 
> WARNING: unmet direct dependencies detected for PHY_SAMSUNG_UFS
>   Depends on [n]: OF [=n] && (ARCH_EXYNOS || COMPILE_TEST [=y])
>   Selected by [y]:
>   - SCSI_UFS_EXYNOS [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_UFSHCD_PLATFORM [=y] && (ARCH_EXYNOS || COMPILE_TEST [=y])
> 
> Fix it by removing PHY_SAMSUNG_UFS dependency.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>

Looks good. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/scsi/ufs/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 46a4542f37eb..590768758fc6 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -164,7 +164,6 @@ config SCSI_UFS_BSG
>  config SCSI_UFS_EXYNOS
>  	tristate "EXYNOS specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
> -	select PHY_SAMSUNG_UFS
>  	help
>  	  This selects the EXYNOS specific additions to UFSHCD platform driver.
>  	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with
> 
> base-commit: ab8be66e724ecf4bffb2895c9c91bbd44fa687c7
> 


-- 
~Randy
