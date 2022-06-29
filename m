Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 266AECCA47C
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 20:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiF2U26 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiF2U24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 16:28:56 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4B919C24;
        Wed, 29 Jun 2022 13:28:55 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so593140pjj.3;
        Wed, 29 Jun 2022 13:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cIf5YRDLW2UKGotAIZtK+pIan4QCm/weESGa7VA1cH0=;
        b=OuKEmQ94Uys/QPcM/MjYAeIgPT8nSqOOdXlvlP04EFzcYhc/cA57nIKV0fE8usIcLj
         M7jQeAJQxYYOkn+ut1/S2Ve3PrM9QjG/5+hq4npajME1P/RTiMwZczG9a0MH9NaiYUBr
         sGLkHxxuSIwwKq6RCJn5sVf+imCflSuHNmVR9fw0gDEiuxZLDhxIOHQhi0ColepUVv7T
         m5UdTUYlFa9vLzx6oPxLOOUXsZQVkt6XYXX1fRFshVDVdJ1kp/2zmBXkgQvPhsgvJiSd
         ZInJahcjTa9MsD4GvqvdSHfmZhGQILtdyNiJcRZSHDDz1CeDRZzV3bHGlJkFKhXNpAts
         +Sag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cIf5YRDLW2UKGotAIZtK+pIan4QCm/weESGa7VA1cH0=;
        b=ufa/s5qAxX7uCZHSwDtPoi9cE7FiKNtIltMBqRXToGFMjX00yzFB/j7YPMtV/WrwBr
         XeLz2Hj6stJVLIb2IsmK9MVHqZG1iIqx3y/cHu9DBIQXlW1WpTAPGQnZl7lJjyiIw3Pv
         gZKwyznTC9+HKkk6afDzo9TJQ+1KWXgeOLzCRID0+0ghYBG8tNi22IC9OPFlGKJMRF/B
         iCo0QpIZb5njEKmzIu7p/num2uM552KxQTHA/66gP1uZFvpLqtIwxxmLOmi+df5+mK+0
         e9vtKjuSg7dbZmTY8WsCDxJxj3KKF/+ZgJNd47XoUg6Ba9VkAVE7PUF4VOIu+GXAOzTa
         2r+g==
X-Gm-Message-State: AJIora8aZyh63v65VwXMeZSNcvK6pT5CpZ4XHM3ZCdfGdR1RZqmiK1qr
        1XldGnh0X7haO97qL8CNWdugaR4ZQEAHfA==
X-Google-Smtp-Source: AGRyM1vU33u4QdilyN4qJ+Y8lUFzP5Uh1HhCDXrHbizR0xh1m2/+GaVKmASYnMmZBLWKMaCEiOPGiQ==
X-Received: by 2002:a17:903:41c1:b0:16a:55ef:3688 with SMTP id u1-20020a17090341c100b0016a55ef3688mr10945287ple.161.1656534534533;
        Wed, 29 Jun 2022 13:28:54 -0700 (PDT)
Received: from ?IPV6:2001:df0:0:200c:b411:35d2:9458:bbe5? ([2001:df0:0:200c:b411:35d2:9458:bbe5])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090a7e8400b001ec98cc43e4sm2575112pjl.49.2022.06.29.13.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 13:28:54 -0700 (PDT)
Message-ID: <ccdf0461-5d4a-0e6b-030f-f2578e02fd93@gmail.com>
Date:   Thu, 30 Jun 2022 08:28:44 +1200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 0/3] Converting m68k WD33C93 drivers to DMA API
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
 <CAK8P3a2hQWF8vY7HPF=6QMW+Ts8fpcwcwmBskbrMLGNgK08hSw@mail.gmail.com>
 <5e57e1e1-2b06-e58c-9081-3b2cce11b5ce@gmail.com>
 <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
In-Reply-To: <CAK8P3a3uTpSmzaRbeWp3Y9FZYx8js5pvgjNpLj79wAFFGp4Vhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

On 29/06/22 20:20, Arnd Bergmann wrote:
>
>>> To clarify, the dma-mapping API has two ways of dealing with this:
>>>
>>> - the streaming API (dma_map/unmap_...) uses explicit cache flushes
>>>
>>> - the coherent API (dma_alloc_coherent etc) uses page protections
>>>    to prevent caching.
>>>
>>> These three drivers use the streaming API because they operate on
>>> data passed in from the outside, so the non-cacheable protection bits
>>> are not used here.
>> I had feared you'd say something along these lines ...
>>
>> Now that throws up a possible problem for the gvp11 driver: due to the
>> need to first map an allocated chunk, then possibly discard that and try
>> another allocation strategy, copying of data to the bounce buffer is
>> deferred until after the final mapping has been successful. This means
>> for writes, we have done the cache flushing before we have actually
>> written any data to the buffer.
>>
>> I don't think it is safe to omit the explicit cache flush for writes in
>> this case.
> I think it's fine as long as you do things in the correct order: the
> copy into the bounce buffer has to be done before the
> dma_map_single() here, and conversely, the copy out of the
> bounce buffer must happen after the dma_unmap_single().

Ah - I had missed the latter (due to dma_setup previously doing all 
cache management, and I had expected dma_map_single to do the same, i.e. 
invalidate the affected cache lines at time of mapping). Will fix.

The former is possible to do, but may incur an extra memcpy on gvp11 
(filling a bounce buffer that we may then discard because 
dma_map_single() returns a DMA handle outside our DMA range). The driver 
does switch to only allocating bounce buffers from chip RAM once a 
kmalloc allocation failed to yield DMA-able RAM, so the performance 
impact ought to be minimal.

> Regarding the amiga_chip_alloc(), I don't know what this means
> for caching. If chip memory is cache-coherent (either uncached
> or by snooping), then there should not be any
> dma_map()/dma_unmap() for that case, but instead the
> amiga_chip_alloc() function should return both the pointer
> and the dma_addr_t token.

amiga_chip_alloc() is used in many places around the kernel, I'd rather 
not change all that (or more precisely. I'd rather Geert does change 
amiga_chip_alloc() if need be).

I'll drop use of dma_map_single() on chip RAM and will rely on that 
having been mapped non-cacheable.

Cheers,

     Michael

>
>           Arnd
