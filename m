Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC140C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 22:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245554AbhKZWxu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 17:53:50 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39631 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbhKZWvu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 17:51:50 -0500
Received: by mail-pf1-f178.google.com with SMTP id i12so10173251pfd.6
        for <linux-scsi@vger.kernel.org>; Fri, 26 Nov 2021 14:48:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nHieBjn1cm8ITFciLFVmXkD5CbLD4MImKR4IHkmbFrc=;
        b=MtJoGz8zeZ+SDV2UjXaKnJOnLXOcaiJ7YNehZlLdjXM35+YvdYo8wi8ppH5KtEHEA8
         DD6DmQKSAA5UYfQIcJ9h42jkkY/c1btQPTfU5JxzEqjvE+pa41InxgyOp4WTAPkpBWtu
         FQE3kAzcnl0LlfHywQqgHthEV2cRxdpSg2r8bb8Ca3a0ucZqRnd0FtK5KyQXtdg/u1iH
         cEfw+hTFXxRgsOkXZZVsnfaDusSohXqb9HIrSFBvho6001k3QIpfnaw1Zkq+mYyzsFSO
         5CeY7akY673HIFBbT8SDQLGU1Qi4LwigBxA2PPS47AcfDQTrPTI+mTPEYqMQ2vjQa9gH
         37Qg==
X-Gm-Message-State: AOAM530mANVFK/aB8n5anvOQnyQU0ntcD37LpbjBYZeIpdP+uVgpFtnB
        OwcA/YycF60v6SPODGryWUw=
X-Google-Smtp-Source: ABdhPJxL4z4hYlae/pItOskY+0lq/0Nj0IlLF6ehNyEq3hW1kqjz+fj6V50gnbkBdJdu7pAJhiuVAQ==
X-Received: by 2002:aa7:8b07:0:b0:4a4:d003:92a9 with SMTP id f7-20020aa78b07000000b004a4d00392a9mr23488942pfd.61.1637966916650;
        Fri, 26 Nov 2021 14:48:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id b32sm5701131pgl.51.2021.11.26.14.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 14:48:36 -0800 (PST)
Message-ID: <88757528-1b71-2fec-0936-edb34f1676bb@acm.org>
Date:   Fri, 26 Nov 2021 14:48:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] scsi: esp_scsi: limit build to builtin only
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211126032151.15040-1-rdunlap@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211126032151.15040-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/21 19:21, Randy Dunlap wrote:
> Fixes: f8ab27d96494 ("scsi: esp_scsi: Call scsi_done() directly")

The build robot reported link failures for many more functions than 
scsi_done() so I do not agree with the above line.

> --- linux-next-20211125.orig/drivers/scsi/Kconfig
> +++ linux-next-20211125/drivers/scsi/Kconfig
> @@ -1296,7 +1296,7 @@ source "drivers/scsi/arm/Kconfig"
>   
>   config JAZZ_ESP
>   	bool "MIPS JAZZ FAS216 SCSI support"
> -	depends on MACH_JAZZ && SCSI
> +	depends on MACH_JAZZ && SCSI=y
>   	select SCSI_SPI_ATTRS
>   	help
>   	  This is the driver for the onboard SCSI host adapter of MIPS Magnum

There are many more similar entries in drivers/scsi. Why to modify only 
one entry instead of modifying them all?

Additionally, to me it seems that the root cause is in the kbuild 
infrastructure instead of in drivers/scsi/Kconfig. From
Documentation/kbuild/kconfig-language.rst about "select <symbol>": "The 
value of the current menu symbol is used as the minimal value <symbol> 
can be set to."

The build errors are the result of the combination JAZZ_ESP=y and 
SCSI_SPI_ATTRS=m. Since that combination is not allowed according to the 
kbuild documention, I think the kbuild infrastructure should be fixed.

Thanks,

Bart.
