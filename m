Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DCA2C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 22:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIVWEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 18:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIVWEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 18:04:49 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686B1222B2;
        Thu, 22 Sep 2022 15:04:44 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so3549298pjh.3;
        Thu, 22 Sep 2022 15:04:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=h5AeR2Bv8Dmhp1ZsnQsoCSdDP4WCc012K56hRvRjwgo=;
        b=g9xpnNhFMqFVg60cu7rBMD7xF4hPLXzbAiJ59mzWWABdXSPMVUYj26h3tqj+V4Vtu8
         /6/XBkLMkrMw6QriCh4/FjIjlMPtGMDiTYVG/c9Smz8d2t1Tdy0LEGw5vllWPpLtL6T3
         Vkak6r0US98QWC83s6oftEXw8oFVaYKfvKCssuLXImsQQmNSfPcyeGar7hzycjEp/AAM
         8sXodsyZPa3WacKZPUH7RsmwVhtOGQm88n+Bu30P7M3iTakVVoinYSzWKrNpDuTJcWhv
         3dCuYC0XX3TJb164rUbgXXnLgxZUwVAYl4nCY3QbofIdvUGwd7I3Y7ZjheNp/bFEf4nw
         r/xw==
X-Gm-Message-State: ACrzQf1BFwmoRKDQ/+6WF/fv4A3Jmb3xPUrEaraCkKgIPgReFvit2Gj2
        c5ZSiDyd/CdnWzyIlnMHMW4LQNPkmUw=
X-Google-Smtp-Source: AMsMyM6o1fHJUmnqzIYecrS7jtpvJ5Gy8wrnm+ZMJIpWig/k2WyUboNIQ9/eXx411rHD09XTWDSgiA==
X-Received: by 2002:a17:903:284:b0:178:2a94:9b6a with SMTP id j4-20020a170903028400b001782a949b6amr5433156plr.135.1663884283829;
        Thu, 22 Sep 2022 15:04:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7c7b:f882:f26a:23ca? ([2620:15c:211:201:7c7b:f882:f26a:23ca])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b001780e4e1a0fsm4650634plg.125.2022.09.22.15.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 15:04:42 -0700 (PDT)
Message-ID: <f69110ac-0be6-7e87-bf27-1d9544038910@acm.org>
Date:   Thu, 22 Sep 2022 15:04:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] scsi: make SCSI_MOD depend on BLOCK for cleaner .config
 files
Content-Language: en-US
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220919060112.24802-1-lukas.bulwahn@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220919060112.24802-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/22 23:01, Lukas Bulwahn wrote:
> SCSI_MOD is a helper config symbol for configuring RAID_ATTRS properly,
> i.e., RAID_ATTRS needs to be m when SCSI=m.
> 
> This helper config symbol SCSI_MOD still shows up even in kernel
> configurations that do not select the block subsystem and where SCSI is
> not even a configuration option mentioned and selectable.
> 
> Make this SCSI_MOD depend on BLOCK, so that it only shows up when it is
> slightly relevant in the kernel configuration.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
>   drivers/scsi/Kconfig | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 955cb69a5418..03e71e3d5e5b 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -2,9 +2,10 @@
>   menu "SCSI device support"
>   
>   config SCSI_MOD
> -       tristate
> -       default y if SCSI=n || SCSI=y
> -       default m if SCSI=m
> +	tristate
> +	default y if SCSI=n || SCSI=y
> +	default m if SCSI=m
> +	depends on BLOCK

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
