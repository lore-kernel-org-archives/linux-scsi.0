Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5818C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A658C20671
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 15:33:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fYMX3i2c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgEOPd2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 11:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726438AbgEOPd1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 May 2020 11:33:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79561C061A0C;
        Fri, 15 May 2020 08:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=1RN5PKNNkon+9cLMhdGB7yGTCqGbH26WhuWNkEgICvk=; b=fYMX3i2cYeMChsVRxIsb/vGbDG
        zjJ9PHGhkouzpEhqjnhvqvQp2LITvYJ0LfeRhMToS3OrJZEH8i06kios/s3YCE8AGDs7vQkQp0vv5
        xjlebxEysK+dI/sAeVddxYKEFEXxg1B7oOVVeUSTDHnAmZQqhhnxxiuBEpK/DQUDXPt9PZXSX7zsF
        r8DABDNonX/xxEv7L3csQG/LxBYGeKVBBla67cdf4XqzvyiJmqktnHIQOLzP1lcaJaJ6PQJsDOmTv
        ttkx/Wr73h3xuDoXDYo/sima3MY8Uw7KedI/amKQ9+e4hsv8H8L1Wfgw9y2WEAwjs0UioQ2TS1/DE
        Faxz1eqQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jZcKp-0003U8-Tg; Fri, 15 May 2020 15:33:15 +0000
Subject: Re: [RFC PATCH 02/13] scsi: ufshpb: Init part I - Read HPB config
To:     Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5d867abf-7ea5-9097-c588-53dd73f004d4@infradead.org>
Date:   Fri, 15 May 2020 08:33:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589538614-24048-3-git-send-email-avri.altman@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi--

On 5/15/20 3:30 AM, Avri Altman wrote:
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e2005ae..a540919 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -160,3 +160,15 @@ config SCSI_UFS_BSG
>  
>  	  Select this if you need a bsg device node for your UFS controller.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_HPB
> +	bool "Support UFS Host Performance Booster (HPB)"
> +        depends on SCSI_UFSHCD
> +        help
> +	  A UFS feature targeted to improve random read performance.  It uses
> +	  the host’s system memory as a cache for L2P map data, so that both
> +	  physical block address (PBA) and logical block address (LBA) can be
> +	  delivered in HPB read command.
> +
> +          Select this to enable this feature.
> +          If unsure, say N.

Please follow Documentation/process/coding-style.rst for Kconfig files:

Lines under a ``config`` definition are indented with
one tab, while help text is indented an additional two spaces.

I.e., not a mixture.

thanks.
-- 
~Randy

