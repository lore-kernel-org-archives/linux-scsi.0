Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59869C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 20:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiGKUCN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 16:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKUCM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 16:02:12 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7986F3C8F6;
        Mon, 11 Jul 2022 13:02:09 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q82so5649553pgq.6;
        Mon, 11 Jul 2022 13:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=a1G/vcc5X+uHyL2mX9eEFhnSPk7VhRn4wrAo9EGqcMw=;
        b=oLzRAuRlXmqZDrhl9nZnFBrId3xzeyDX2ocTnMKrGXvwrAcD1xS2sh9ztPlED+9Uqg
         fhTaaGpfHUu7n29TXkbklkyYQT2X+pTgAd1cLaH1njo4wVjbllIPBqqKKOy6R54dwpVx
         /65nTYIq6AvFRKBHaHIyBlgFNeFwZg79h0ck4VdK6rKGSSF7w5CiRHHjHWsMbTQ8MGuC
         e4LhOzEGPQLCdMakBUsJZFA+cdKPcbFqfiSoid7cIy7/QIx/3fOqrbh8g52I9sI3i+Bl
         Y4CJiDvbQg8Xm0cV38AnYQzpJye6mhDvz81c9+Tu0iv27i1uvivWiXPcA68yrKwngAhU
         LA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=a1G/vcc5X+uHyL2mX9eEFhnSPk7VhRn4wrAo9EGqcMw=;
        b=CLpY9UaAxbVGIAtxLveo5iwkCZlTg/4x79vOLWUJrvi4kUpjPXL0X+KFzYH3NEnNwc
         WjMwt2w0mSbrI1/UPw2HufKWRvMbMPHC4kYfIkNp8DCzUUv/QiPgGA7a+7u6voQfSYES
         5pD9BL5JzXsexad4SeOo10qFrnInHnNLIoOjn4l5YbH6InvFQjeIKWOwO1yEJFQd7/ja
         mnh49P+zUQHxQD6B83uQxHtkHhygwm58IDJ9w9lXVyRR98jGVRZzIKq556QqllEc42Ig
         1VjMEBbkoy4CwVPdoW9Wun6cqxjv/hB2JpdKa6Qwbzuilam6GhCM746YDh+FeB4XLzcO
         4r0w==
X-Gm-Message-State: AJIora/GzST0NkoQ+VCj8dzHAAipnNGVdGGjcjoDoAnrnMzIQF3hAmG/
        V3XG3JdC7pgJYaUqLsIrZRm4qqdP7ho=
X-Google-Smtp-Source: AGRyM1uY/Xs/injKYZMi2G3ZAm6pjGfLU6GOJrpDumPQHpsq2QDqR508mA6ODMd0PP/MKRFEtBXYsw==
X-Received: by 2002:aa7:8d54:0:b0:52a:c718:ff1 with SMTP id s20-20020aa78d54000000b0052ac7180ff1mr9837127pfe.29.1657569728616;
        Mon, 11 Jul 2022 13:02:08 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id j14-20020a63594e000000b0040ced958e8fsm4631232pgm.80.2022.07.11.13.02.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jul 2022 13:02:07 -0700 (PDT)
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
 <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
 <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
 <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com>
 <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <a4a3908a-29c5-fe2e-4c58-eed59133d39f@gmail.com>
Date:   Tue, 12 Jul 2022 08:02:02 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

Am 11.07.2022 um 20:27 schrieb Geert Uytterhoeven:
> Hi Michael,
>
> On Mon, Jul 11, 2022 at 9:57 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Am 11.07.2022 um 19:16 schrieb Geert Uytterhoeven:
>>> On Sun, Jul 10, 2022 at 6:12 PM Arnd Bergmann <arnd@kernel.org> wrote:
>>>> A resource would pass a phys_addr_t token, but the driver expects a
>>>> virtual address that should be an __iomem pointer. The MMIO area
>>>> already gets mapped into virtual addresses in arch/m68k/kernel/head.S,
>>>> so it makes sense to skip the extra ioremap() and just use the address,
>>>> but then you can't pass it as an IORESOUCRE_MEM token and should
>>>> use platform_data with the pointer instead.
>>
>> OK, got it now (I had missed the physical/virtual mismatch entirely).
>
> And the __iomem is there so we can catch mistakes using sparse
> (make C=2 path/to/file/.o).

I'll need to make a habit of that ...

>>>> The alternative is to do it the normal way and pass the physical address
>>>> as a resource, that you can pass into devm_platform_ioremap_resource()
>>>> or a similar helper.
>>>
>>> I would prefer the latter.  While head.S sets up the mapping,
>>> __ioremap() does not have support for this on the mvme platform,
>>> so this has to be added first. Look at the amiga and virt platforms
>>> for examples.
>>
>> I see - doesn't look too hard to do, and should not affect any other
>> existing code.
>> Is it worth adding the same support for Atari as well?
>
> From a quick glance at arch/m68k/kernel/head.S, it seems that
> on Atari there is no identity mapping (the high I/O area is mapped
> to the virtual low area).  That means __ioremap() and iounmap()
> wouldn't be symmetrical, but it can be done.

As I read it, it's the other way: virtual 0xffxxxxxx is mapped to phys. 
0x00ffxxxx, and all hardware addresses are given in the upper window 
(Medusa/Hades use that window only, and have identity mappings there).

So returning identity mapping in the high window would work AFAICS. I'll 
give that a try sometime.

> Note that on Amiga we only use the identity shortcut for Zorro III
> memory (and only for the first half?), i.e. ioremap() on Zorro II I/O
> does add new mappings.  Hence most Zorro II drivers use ZTWO_VADDR()
> instead of ioremap().

I see ZTWO_VADDR() already returns void __iomem* ... Fixing this patch 
would sort out the m68k drivers, leaving SGI. I'll have to see whether I 
can dig up a SGI workstation with this driver; might be easier than 
getting hold of any Amgias here Dowh Under.

Cheers,

	Michael


>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
