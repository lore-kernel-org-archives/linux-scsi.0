Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59ACC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 07:37:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiF2HhB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiF2HhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 03:37:00 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F2735A9D;
        Wed, 29 Jun 2022 00:36:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a15so14263370pfv.13;
        Wed, 29 Jun 2022 00:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=yo9MuBJCTtyDqGRGrOTl12Biymn+yCnqsPIXboo8MP8=;
        b=J7UL3K80EdR+wrKQGZW1ugKK+hUUTxptCuPRTBGtD+2V8+RF2BjlD3OGgSKagmFGdQ
         jTXQQSQD75knCT1HR8mSHDkEWpZZ3AN6YLeWGkm907zoI52XUklQ5kp/wfljZOHcNfYO
         4cAWEOjqTrRYb2naFBHVnODWDZb0PH17nYUpaD4Ij2UDUElyb7f820fkCAt0bgBAKL8O
         ZrAevCZDB7QrZkE1YGHygeK8ILBkoG2itNzXMtU3jifT090f4eNW1PdtbGXdX/qUZn45
         Db5TZESJ/uXwib1BxjpVnXCNuadBGB1Ds35auxkYG1pVh2pK4mtSyU6TGvf5lrUEOsam
         OKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=yo9MuBJCTtyDqGRGrOTl12Biymn+yCnqsPIXboo8MP8=;
        b=Mtgmz8q/GSV6qEEA+9i+nK8RQzVXIrHgplmkzSk23oUiNDXpt1gVFm8zvwzqGY4i7P
         33ycfCoylMO/l/yaCUOCYeXE/Aa+w08DuSFRkr3LrUl/5zoQ8TXEnYx4Eu8v5uhI7jTb
         wzO+K4JGqBDdIhwSyzcgoP13w9Jca9HQyAMbPvUBpaWB+EIy3fAOSM0K26/ARdgn2Aqu
         X/uCoc8QCFMmLXU1htG1ol7+gFLZUILbMSHZRwhR0Bhe8ggTfaThePwczlKZuMEAk3R9
         Cv7a6I4Tupi1oK2seSX7KdyjdckmLt8XgZyeiNibiTjPfzjy0kXxZw45qElyUD8V5A5D
         lSDw==
X-Gm-Message-State: AJIora+jrsaIq0pUw/umypUcznn3GGJK/7Gvgsq61gQFh3GCAZ+vNIuI
        Q/rWmx2PAN4kOZuL59J26YKtp/2VwJqXsA==
X-Google-Smtp-Source: AGRyM1u1Na9TyzVCQppQB49a35y4wJ1s9D5Q3prQfi9dd89rJT4ztwp1A00bKsINqpMsavawJW8zMA==
X-Received: by 2002:a05:6a00:1901:b0:518:916e:4a85 with SMTP id y1-20020a056a00190100b00518916e4a85mr8871260pfi.65.1656488219229;
        Wed, 29 Jun 2022 00:36:59 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id 132-20020a62198a000000b0051bc5f4df1csm10694147pfz.154.2022.06.29.00.36.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 00:36:58 -0700 (PDT)
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
To:     Arnd Bergmann <arnd@kernel.org>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
 <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com>
Date:   Wed, 29 Jun 2022 19:36:52 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

Am 29.06.2022 um 18:19 schrieb Arnd Bergmann:
> On Wed, Jun 29, 2022 at 3:16 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>>
>> V1 of a patch series to convert m68k Amiga WD33C93 drivers to the
>> DMA API.
>>
>> This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
>> m68k WD33C93 still used virt_to_bus to convert virtual addresses to
>> physical addresses suitable for the DMA engines (note m68k does not
>> have an IOMMU and uses a direct mapping for DMA addresses).
>>
>> Arnd suggested to use dma_map_single() to set up dma mappings instead
>> of open-coding much the same in every driver dma_setup() function.
>>
>> It appears that m68k (MMU, except for coldfire) will set up pages for
>> DMA transfers as non-cacheable, thus obviating the need for explicit
>> cache management.
>
> To clarify, the dma-mapping API has two ways of dealing with this:
>
> - the streaming API (dma_map/unmap_...) uses explicit cache flushes
>
> - the coherent API (dma_alloc_coherent etc) uses page protections
>   to prevent caching.
>
> These three drivers use the streaming API because they operate on
> data passed in from the outside, so the non-cacheable protection bits
> are not used here.

I had feared you'd say something along these lines ...

Now that throws up a possible problem for the gvp11 driver: due to the 
need to first map an allocated chunk, then possibly discard that and try 
another allocation strategy, copying of data to the bounce buffer is 
deferred until after the final mapping has been successful. This means 
for writes, we have done the cache flushing before we have actually 
written any data to the buffer.

I don't think it is safe to omit the explicit cache flush for writes in 
this case.

>> DMA setup on a3000 host adapters can be simplified to skip bounce
>> buffer use (assuming SCSI buffers passed to the driver are cache> Thanks, and Cheers,
>>
>>    Michael
>>
>
>> line aligned; a safe bet except for maybe sg.c input).
>>
>> On gvp11 and a2091 host adapters, only the lowest 16 MB of physical
>> memory can be directy addressed by DMA, and bounce buffers from that
>> space must still be used (possibly allocated from chip RAM using the
>> custom allocator) if buffers are located in the higher memory regions.
>>
>> The m68k VME mvme147 driver has no DMA addressing or alignment
>> restrictions and can be converted in the same way as the Amiga a3000
>> one, but will require conversion to a platform device driver first.
>
> Right, it seems that the old hack of passing a NULL device pointer
> no longer works, and that is probably for the better.
>
> If you want an easy way out, the driver can just call
> platform_device_register_full() to create its own device with a
> dma_mask set up, and use that device for the DMA API, but
> not actually match the device to a driver.

I'll leave it to Geert to decide whether he prefers setting up a 
platform device in arch/m68k/mvme147/config.c or use the shortcut. I've 
used platform_device_register_simple() in a few other drivers so don't 
mind that much.

Cheers,

	Michael

>
>> Only compile tested so far, and hardware testing might be hard to do.
>> I'd appreciate someone giving this a thorough review.
>
> Looks all good to me.
>
>         Arnd
>
