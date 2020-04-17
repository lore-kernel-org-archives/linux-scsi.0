Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFA2C3815B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B77220771
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G3XC6I1a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730762AbgDQSUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730256AbgDQSUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Apr 2020 14:20:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89116C061A0C;
        Fri, 17 Apr 2020 11:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=JQ5dwC8H6/aiyaSgobgQiiIuDhCA2QJElFHLNREcZsU=; b=G3XC6I1aPH4y/3BSP7CGlyxMNl
        XnddDYFKR2DIsV862VDMk7ZN2xjYSaJq8YYxVfDwuRBoEQvNRZ7Hx53Xz7bXex4Q4mahdcgZhFSS8
        mP4UTEf0wT+96OmFBsuaucuVyY/+TiHLf5UKXUdaI8OWsVwBsq2HrW4Ve+elYiGSCEt106E2omVsJ
        eSvcb1UsDrnMdZIqtu8dPg3Cnqg2uDeqKCEPF7dp7TWoJFvlsRYDel3HOFMmUKg6m6Z8uMgQ5SfzY
        cLMfydzvRiTWymmAnOQwEJP4IHJ5TtjWagulgj4ahR5Rn7H+hF+HivVAIaAD4rJ6t3nCsz5ZgPu/Y
        ZFSDwr5w==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jPVbT-0001kx-2U; Fri, 17 Apr 2020 18:20:39 +0000
Subject: Re: [PATCH v6 09/10] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
To:     Alim Akhtar <alim.akhtar@samsung.com>, robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
 <CGME20200417181024epcas5p4231ae3dd2598155854e9b7ee52438bcb@epcas5p4.samsung.com>
 <20200417175944.47189-10-alim.akhtar@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c0760af4-6867-87f6-4abb-cb4079a7c982@infradead.org>
Date:   Fri, 17 Apr 2020 11:20:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200417175944.47189-10-alim.akhtar@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/20 10:59 AM, Alim Akhtar wrote:
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e2005aeddc2d..cc7e29c8c24f 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -160,3 +160,15 @@ config SCSI_UFS_BSG
>  
>  	  Select this if you need a bsg device node for your UFS controller.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_EXYNOS
> +	bool "EXYNOS specific hooks to UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_EXYNOS || COMPILE_TEST

"&&" has higher precedence than "||", so I'm thinking that line should be

+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)

> +	select PHY_SAMSUNG_UFS
> +	help
> +	  This selects the EXYNOS specific additions to UFSHCD platform driver.
> +	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with
> +	  UFS-PHY driver.
> +
> +	  Select this if you have UFS host controller on EXYNOS chipset.
> +	  If unsure, say N.


-- 
~Randy

