Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151CACCA47C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 09:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbiGLJHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 05:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGLJHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 05:07:10 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC08132B91;
        Tue, 12 Jul 2022 02:07:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id l124so6952428pfl.8;
        Tue, 12 Jul 2022 02:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=faNUdVwfi83DLJgtsRVpRUnKNkRdra8kpC3G7WPuHGY=;
        b=odLvA5ycaJvyOtSwCtCCcoft1Z7PwBN4qlM59/l1W/1omkTACPBpDBw8HX7xmqfBnf
         wR7o92smwaJnFLifdaF4pDX4QQtOvLYem2RPQpsKOC4shlWh+8LpIiHVyH/sE8NYeyM9
         HTilfzdvFrLsbuVWGPz51WY8fCZn8z48KuZnsJtEaJ8zbNi5Ktl5ecPj+6NhkFUqcn3E
         pFm7qbOKZxpnby02ClrF3ZJKNsCGAu72Qo22634Gc4j7f9RU/SRdrFE7T7kBirEKHNGI
         yWnIV1GSA2/rYdNePTsDMUvf/UF5iphIA+KtjO03T8zmAsIWl2JbG0O3igERfaX4GLCP
         O38A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=faNUdVwfi83DLJgtsRVpRUnKNkRdra8kpC3G7WPuHGY=;
        b=b13jxKN8tkHMTjanZ6EzS4djCGd4bZayD0yeuSajYcAyYuKmB4rBwav2bcZEbvb1ry
         X2+n12F3tElFa1jrmx7hfPpoGuUs6nwRPuFVirjI1icOkRyOLjpB+Q4AEwK9yO5qBOaP
         SdPZcXODG0YhHLZLjWZIIDEM3J4YtLyEBh5HqcLRChONESk/5dUWw11o8PhDvkt7Gald
         w1bRtn+b3nj03W86PqB9FovutwAl9bt3ZpHfN45YKAPgrPhx7Dq84xuc6lYKJi82Bk72
         2gV+D3kl5hmdj2zDXUa6Mfir8ph/KonA8dyFGFZE3glb8Yz/ot0f3LPwoeQqylROu3tA
         6NRA==
X-Gm-Message-State: AJIora/413/WF1hdpa7jtnkUD/UrB0cMO4ygT3mob9hDhlC/9qnx8F+9
        WHo9ciCIuDsKzy/MONGg4MKl4toIMyc=
X-Google-Smtp-Source: AGRyM1u/6z3Si73nX/j2hIjzQZlX4Mm1+euIQQwpYBoPogK1zCXJO4TEdGfFyRAm4gfiq1TwTfWQMQ==
X-Received: by 2002:a63:4d0e:0:b0:412:1877:9820 with SMTP id a14-20020a634d0e000000b0041218779820mr19694397pgb.177.1657616829430;
        Tue, 12 Jul 2022 02:07:09 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id pi4-20020a17090b1e4400b001df264610c4sm2313292pjb.0.2022.07.12.02.07.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jul 2022 02:07:09 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] m68k - set up platform device for mvme147_scsi
To:     Arnd Bergmann <arnd@kernel.org>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
 <20220712075832.23793-3-schmitzmic@gmail.com>
 <CAK8P3a2ptjH3VyCjuwQROw8GuOs8CxuhX8dMBxMa5m-Q93yZ_g@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <7b652abd-3094-e0c8-d8fb-087c60c51fa2@gmail.com>
Date:   Tue, 12 Jul 2022 21:07:04 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2ptjH3VyCjuwQROw8GuOs8CxuhX8dMBxMa5m-Q93yZ_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

Am 12.07.2022 um 20:12 schrieb Arnd Bergmann:
> On Tue, Jul 12, 2022 at 9:58 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> +
>> +static const struct resource mvme147_scsi_rsrc[] __initconst = {
>> +       DEFINE_RES_MEM(MVME147_SCSI_BASE, 0xff),
>
> Still the wrong size?

Too true - forgot to fix that, sorry.

>
>> +       DEFINE_RES_IRQ(MVME147_IRQ_SCSI_PORT),
>> +};
>> +
>> +int __init mvme147_platform_init(void)
>> +{
>> +       struct platform_device *pdev;
>> +       int rv = 0;
>> +
>> +       pdev = platform_device_register_simple("mvme147-scsi", -1,
>> +               mvme147_scsi_rsrc, ARRAY_SIZE(mvme147_scsi_rsrc));
>
> I think you actually have to use platform_device_register_full() to pass
> a DMA mask here: As I understand it, the dma_set_mask_and_coherent()
> call in the driver fails if the device is not already marked as dma
> capable by having an initial mask set.

I'll take a look at that - if true, this requires the amiga-a3000-scsi 
platform device set-up be changed in the same way (the gvp11 and a2091 
drivers inherit the DMA mask from the Zorro bus default, so ought to 
work OK).

Cheers,

	Michael

> The way this normally works is that the device gets created with a mask
> that reflects the capabilities of the bus, while the driver sets a mask
> based on what it wants to program into the device, and the dma-mapping
> interfaces ensure that we only use the intersection of those.
>
>         Arnd
>
