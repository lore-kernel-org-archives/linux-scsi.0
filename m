Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B480CC3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 07:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AE182146E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 07:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RppPDfWt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLSHhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 02:37:51 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50584 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfLSHhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 02:37:51 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so2098204pjb.0;
        Wed, 18 Dec 2019 23:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0nx8L7SUVUpwZ2hHI379dkMfkYdwVJx/h+xm8bvbJTk=;
        b=RppPDfWtAF2/78ZaqvoheL1TQLs+e51ZH1gVEgdKQIpkiez/5Q8Wr/YF9Ffs87OlWh
         +0QTXE9zrmiP10IM+/vBzP1urUkk0hgLRFQp3+Nnaj6QroNO2EMUYcRJfuq4sGLNZwBM
         flUyjTnsuqI5WEoOsW33M3wGm0x3jYpNr1RfUZTcP97rDyfpOvjJ6CorymapkR/GJp+p
         Qd4cAYqeyMiW0sGir5FaaYfgSRomJ6wCCkenp1i7P+l6zTQ0E6RkMe6PpZjE8pdZW845
         Q8aq5GwowoxjemsBR0ZbmGJYQrj5mhD5jIXnD25lPeoU38JYt+BipmcK6VEylZouupzG
         sv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0nx8L7SUVUpwZ2hHI379dkMfkYdwVJx/h+xm8bvbJTk=;
        b=Em1vPcc7BTxmQU8woXy20JfdqqScdU2Ob8EgiU/BFrrCqUjxDlzPg/NOusa+DV9xi1
         dhqhFk4UB0BzIyGh64WKf6wwB3I90Ww98K7DWIIDBba74Y4NJO/Zl45NC9hGN/v6XM0m
         sZPqp6v3SMAXc2SYxfYR8kaFZRsszMI1ALWZYT4WxTgObWu+pu17yl+N8f6RuaOMpu6e
         ZwVmrLNSCktytUhgr81L0cE/KHn8sKVy3fYczYzYBgnaYlrGXhOxe+4i7AOQXt89bhfK
         di63812aaReZgGcFxzSYL3/pUVDytV8EUl6xgdZeXNGNPqdevYWJT0HwAmmd1lSA7fUF
         n8AA==
X-Gm-Message-State: APjAAAU2EaRF6Q0kMhomLCdO8hhqFCZ30v5GAsHg1FGHbRFykuCpAL1k
        qEkO7gRiCjPaaWFkklk8lnO3GKTH
X-Google-Smtp-Source: APXvYqy6Zi45dKUBsN0A3zZlJRUeD/RU79k4wl44YxSfuWyLsO/jzk8oOCtvuT8Isz69mo20xLT4ZA==
X-Received: by 2002:a17:90a:94c1:: with SMTP id j1mr8181360pjw.2.1576741070618;
        Wed, 18 Dec 2019 23:37:50 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i22sm4714674pfd.19.2019.12.18.23.37.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2019 23:37:48 -0800 (PST)
Subject: Re: [PATCH v2] hwmon: Driver for temperature sensors on SATA drives
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
References: <20191215174509.1847-1-linux@roeck-us.net>
 <20191215174509.1847-2-linux@roeck-us.net> <yq1r211dvck.fsf@oracle.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <f2b90347-66db-16f9-44b1-b6c7df319331@roeck-us.net>
Date:   Wed, 18 Dec 2019 23:37:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <yq1r211dvck.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 12/18/19 4:15 PM, Martin K. Petersen wrote:
> 
> Guenter,
> 
>> This driver solves this problem by adding support for reading the
>> temperature of SATA drives from the kernel using the hwmon API and
>> by adding a temperature zone for each drive.
> 
> My working tree is available here:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=5.6/drivetemp
> 

I had a quick look at the patch. Looks good overall. I think you should be able
to use the buffer allocated in struct drivetemp_data (named smartdata). Maybe
rename it to something more generic. If it needs to be dma-aligned, maybe we
can use kzalloc() to allocate it. Only reason I didn't use it for vpd was because
that needed 1024 bytes.

> A few notes:
> 
>   - Before applying your patch I did s/satatemp/drivetemp/
> 
>   - I get a crash in the driver core during probe if the drivetemp module
>     is loaded prior to loading ahci or a SCSI HBA driver. This crash is
>     unrelated to my changes. Haven't had time to debug.
> 
Definitely something we'll need to look into. Do you have a traceback ?

Thanks,
Guenter

>   - I tweaked your ATA detection heuristics and now use the cached VPD
>     page 0x89 instead of fetching one from the device.
> 
>   - I also added support for reading the temperature log page on SCSI
>     drives.
> 
>   - Tested with a mixed bag of about 40 SCSI and SATA drives attached.
> 
>   - I still think sensor naming needs work. How and where are the
>     "drivetemp-scsi-8-140" names generated?
> 
> I'll tinker some more but thought I'd share what I have for now.
> 

