Return-Path: <SRS0=199q=EK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA9DC388F7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 10:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D115221F8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Nov 2020 10:57:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMBCVAJK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729110AbgKDK5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Nov 2020 05:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKDK5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2020 05:57:06 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC23DC0613D3;
        Wed,  4 Nov 2020 02:57:05 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a15so13154388edy.1;
        Wed, 04 Nov 2020 02:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQvU7+bcG80Q/4AquaDud23EcQRtGXn4Q9ks66tD4Yc=;
        b=bMBCVAJKlqngqlvYpkHc0ttS2Q0K9RILc2FJ71Hf8x+ZzmliKeYquWjeQJuDeNcril
         YZp5ZGJ+iSiupWjNJgdQWs15z9gZEq8aHTAEgfvPbAmkxdZh2AShiPH0RmpEo+Ie5CI+
         cjXU55q5Fs6pqTWR9swoddyrxNjRid67ulbr97Ne85YtOtN1ria8diXZLMucp9Y5ivfz
         Qp8TgVHFdo9GogCiF/2n78efRmFUBP1lCtTWDXsrH3vSlhiX9n3sR5SC4vNauiGVBXvB
         QeujS0/ochZohFSNW3mLzV4j65nC/iw88u9liRpOoG2UgfnKOybWAz51hT2+y0+cb3DO
         56qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQvU7+bcG80Q/4AquaDud23EcQRtGXn4Q9ks66tD4Yc=;
        b=pF2+q169fZrERac9bol55iIMmwX+eNiEWPieVZW2FkKD8NXV+gbFNEmbnB7W9UFt4k
         1LWpQXZqvBiOUMQrKmQ3foy339AySXgiLf9LivSn7U4Uy9yLgaEoiUL6N4T4ugjGf2K5
         JJ48etZFuRffEw5mfnAlacDSgdZFelTVWpghOOiWXQWXN+i4pdV5gGy9S6lMx8RDh5tj
         N+a7Waju40UcAK1FX07eJacTQUEHpmXrxigRehsMUHnBC/dT6GECVoyYs0OPWNa8MzAS
         bB/iliN/rsL4Jbad97K1G2dxOrqkvCYvJh6IRxMK8PQpIqjs2QxSII89O2511qu5AiiB
         iAOA==
X-Gm-Message-State: AOAM532GMBlstTc2Yw+sQVuaeZv5+z9+Mae+xPiucbKncD4ZIaIx7rAL
        5z69TmAQxNkz2yU9GxKSe4A=
X-Google-Smtp-Source: ABdhPJyZuwGAgCeXfc4SNErJttWhdgnqxK3/bJPbTw68bdJPqBoOkbPv88IpEdCxhDMoXE7GG+Y3fg==
X-Received: by 2002:aa7:d843:: with SMTP id f3mr27097626eds.354.1604487424590;
        Wed, 04 Nov 2020 02:57:04 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee22.dynamic.kabel-deutschland.de. [95.91.238.34])
        by smtp.googlemail.com with ESMTPSA id ds7sm807035ejc.83.2020.11.04.02.57.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 02:57:04 -0800 (PST)
Message-ID: <d00acd2cef07c50de3e19e1b8517c996d67795b2.camel@gmail.com>
Subject: Re: [PATCH V4 1/2] scsi: ufs: Add DeepSleep feature
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Wed, 04 Nov 2020 11:57:03 +0100
In-Reply-To: <20201103141403.2142-2-adrian.hunter@intel.com>
References: <20201103141403.2142-1-adrian.hunter@intel.com>
         <20201103141403.2142-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-11-03 at 16:14 +0200, Adrian Hunter wrote:
> DeepSleep is a UFS v3.1 feature that achieves the lowest power
> consumption
> of the device, apart from power off.
> 
> In DeepSleep mode, no commands are accepted, and the only way to exit
> is
> using a hardware reset or power cycle.
> 
> This patch assumes that if a power cycle was an option, then power
> off
> would be preferable, so only exit via a hardware reset is supported.
> 
> Drivers that wish to support DeepSleep need to set a new capability
> flag
> UFSHCD_CAP_DEEPSLEEP and provide a hardware reset via the existing
>  ->device_reset() callback.
> 
> It is assumed that UFS devices with wspecversion >= 0x310 support
> DeepSleep.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 34 +++++++++++--------
>  drivers/scsi/ufs/ufs-sysfs.c               |  7 ++++
>  drivers/scsi/ufs/ufs.h                     |  1 +
>  drivers/scsi/ufs/ufshcd.c                  | 39
> ++++++++++++++++++++--
>  drivers/scsi/ufs/ufshcd.h                  | 17 +++++++++-
>  include/trace/events/ufs.h                 |  3 +-
>  6 files changed, 83 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs
> b/Documentation/ABI/testing/sysfs-driver-ufs
> index adc0d0e91607..e77fa784d6d8 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -916,21 +916,24 @@ Date:		September 2014
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		runtime power management level. The current driver
> -		implementation supports 6 levels with next target
> states:
> +		implementation supports 7 levels with next target
> states:
>  
>  		==  ===================================================
> =
> -		0   an UFS device will stay active, an UIC link will
> +		0   UFS device will stay active, UIC link will
>  		    stay active
> -		1   an UFS device will stay active, an UIC link will
> +		1   UFS device will stay active, UIC link will
>  		    hibernate
> -		2   an UFS device will moved to sleep, an UIC link will
> +		2   UFS device will be moved to sleep, UIC link will
>  		    stay active
> -		3   an UFS device will moved to sleep, an UIC link will
> +		3   UFS device will be moved to sleep, UIC link will
>  		    hibernate
> -		4   an UFS device will be powered off, an UIC link will
> +		4   UFS device will be powered off, UIC link will
>  		    hibernate
> -		5   an UFS device will be powered off, an UIC link will
> +		5   UFS device will be powered off, UIC link will
>  		    be powered off
> +		6   UFS device will be moved to deep sleep, UIC link
> +		will be powered off. Note, deep sleep might not be
> +		supported in which case this value will not be accepted
>  		==  ===================================================
> =
>  
>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_d
> ev_state
> @@ -954,21 +957,24 @@ Date:		September 2014
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		system power management level. The current driver
> -		implementation supports 6 levels with next target
> states:
> +		implementation supports 7 levels with next target
> states:
>  
>  		==  ===================================================
> =

Hi Adrian
There doesn't have these equal sign lines in the sysfs-driver-ufs.
maybe you should remove these. or add + prefix.

Thanks,
Bean


