Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4575FC54E8F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 03:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2559E208E4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 03:13:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FWCfXFoF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgEKDNO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 23:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEKDNN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 23:13:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8DFC061A0C;
        Sun, 10 May 2020 20:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=F8LV7KfEX6gF+p15zdl3JPzohKhz2bL8kbvxawtZGio=; b=FWCfXFoFFMlrl2qXVyz9bKX5qq
        yfPNsmn9pKW3iOtJsvq1PoluVfyc+J50fKQC6tVMFuUL3wXcb9RPM2T7Nc/mzQ703m4CU8AIwDRxA
        JWsTaZC6iaQVCDWhxtpdbSVlt+zvEzlpZfA4UF1fVbt5vBhjNIJ6dhpapmbDorSfn8WJAqd/dK2mQ
        H19SMBref3payLuB5/tvXB+hu9lRA3Utr+GWBbvYEN3YDL2AaNOjL7MQBahNFvp4ZzKdyrJ0USjJq
        9H/uamPHOujNAgDpHH0zOMBPYySK13DrTWK+cWX1XA1379bFM2e4yDIO9f4PA7LOAO9xihoUN93x2
        mbxX3ymA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXysN-0000Bd-BT; Mon, 11 May 2020 03:13:07 +0000
Subject: Re: [PATCH v8 09/10] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
To:     Alim Akhtar <alim.akhtar@samsung.com>, robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
 <CGME20200511021409epcas5p3b78fe59669f13ffae481b57a944da675@epcas5p3.samsung.com>
 <20200511020031.25730-10-alim.akhtar@samsung.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <80a387eb-2325-caab-6754-6d94daeeabac@infradead.org>
Date:   Sun, 10 May 2020 20:13:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200511020031.25730-10-alim.akhtar@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 7:00 PM, Alim Akhtar wrote:
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

Since && has higher precedence than ||, I am thinking that this should be

	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)

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

