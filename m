Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8FEC32772
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Aug 2022 19:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiHWTZq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Aug 2022 15:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbiHWTZR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Aug 2022 15:25:17 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E0513A529
        for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2022 11:10:41 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so17999740pjj.4
        for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2022 11:10:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=BgTyYUlweJZgux/lp3ya54RGYC3ZvAVJrJaVrVtaUJU=;
        b=oAlRdZEEAfGSxC4N3lyW+c3qamsjh9AWcx+RXKXZIJhb/+dFRFXiONjAx+EdCeMN85
         wrYMnJPZKFIUip4xwkysOf7eq/iO+PZf2gXvddhJrFVzhLBA8Cbwbf/2pOfTTW3vI/nx
         FCfCEldxk0cCCEFgl22lbhxatba0n8tFwSqMBXaJ4y2dGMtpMfw1cazIrDnFid74Pde+
         W81TO7Sd4SfPGoExrsDuMphAoN+pjf11LTgBFVvgjjIubhDLx+SPshZ93Ea0PAvkdLS3
         SIJCLQa64gY4TlwfT7gxizqNZrYEW8LcpvazyrlHUah+wF/addBkfYGDExZgjCLdz0ER
         WVqg==
X-Gm-Message-State: ACgBeo0EJZseE2Ozn58N1H8Dim7zlE0LAHI1fFXeuRiV+BMQLTkggdNF
        flsqqFj0f4fT50cqYR3XROk=
X-Google-Smtp-Source: AA6agR5TYpZdsIh4QsG8aRpYYR8fmj/b24tHoq7IhM9wZEBPYpaXsB3SxGp0ydHj9mnC1MB/eQLWjw==
X-Received: by 2002:a17:902:6b47:b0:172:9b8b:a3fe with SMTP id g7-20020a1709026b4700b001729b8ba3femr25108572plt.13.1661278240082;
        Tue, 23 Aug 2022 11:10:40 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:7a86:fe9e:3984:50b8? ([2620:15c:211:201:7a86:fe9e:3984:50b8])
        by smtp.gmail.com with ESMTPSA id mh1-20020a17090b4ac100b001fac5c53e4esm10519308pjb.38.2022.08.23.11.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 11:10:39 -0700 (PDT)
Message-ID: <026ad7cc-5be9-e90b-8c95-0649caf68779@acm.org>
Date:   Tue, 23 Aug 2022 11:10:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, gzhqyz@gmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220816172638.538734-1-bvanassche@acm.org>
 <decc1ef4-ec85-d947-ec81-ebeaa982f53f@redhat.com>
 <CAMuHMdVDWrLs_KusG8vXA_1z8ORdPnpfxzNqw4jCG_G0D-fn+A@mail.gmail.com>
 <ecf878dc-905b-f714-4c44-6c90e81f8391@acm.org>
 <CAMuHMdW0WzgQjR33hz9om7ahE5StbDCLozVnZzYAS1WEzStR0w@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAMuHMdW0WzgQjR33hz9om7ahE5StbDCLozVnZzYAS1WEzStR0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/22/22 23:41, Geert Uytterhoeven wrote:
> A lock-up (magic sysrq does not work) during s2idle.
> I tried bisecting it yesterday, but failed.
> On v6.0-rc1 (and rc2) it happens ca. 25% of the time, but the closer
> I get to v5.19, the less likely it is to happen. Apparently 100
> successful s2idle cycles was not enough to declare a kernel good...
> 
>      Freezing ...
>      Filesystems sync: 0.001 seconds
>      Freezing user space processes ... (elapsed 0.001 seconds) done.
>      OOM killer disabled.
>      Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
>      sd 0:0:0:0: [sda] Synchronizing SCSI cache
>      sd 0:0:0:0: [sda] Stopping disk
> 
> ---> hangs here if it happens
> 
>      ravb e6800000.ethernet eth0: Link is Down
>      sd 0:0:0:0: [sda] Starting disk
>      Micrel KSZ9031 Gigabit PHY e6800000.ethernet-ffffffff:00: attached
> PHY driver (mii_bus:phy_addr=e6800000.ethernet-ffffffff:00, irq=186)
>      ata1: link resume succeeded after 1 retries
>      ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>      ata1.00: configured for UDMA/133
>      OOM killer enabled.
>      Restarting tasks ... done.
>      random: crng reseeded on system resumption
>      PM: suspend exit
>      ravb e6800000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off

Hi Geert,

I'm not sure that is enough information to find the root cause. How 
about enabling the tp_printk boot option and to enable tracing for 
suspend/resume operations, e.g. as follows?

cd /sys/kernel/tracing &&
echo 256 > /sys/kernel/tracing/buffer_size_kb &&
echo nop > current_tracer &&
echo > trace &&
echo 1 > events/power/device_pm_callback_start/enable &&
echo 1 > events/power/device_pm_callback_end/enable &&
echo 1 > events/power/suspend_resume/enable &&
echo 1 > tracing_on

Thanks,

Bart.
