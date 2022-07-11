Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF86BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 07:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiGKH5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 03:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiGKH5Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 03:57:24 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3502D1CB1B;
        Mon, 11 Jul 2022 00:57:24 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f11so3212860pgj.7;
        Mon, 11 Jul 2022 00:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=34bOJ2fP/uYBYyAbZ0stgeBIJfEsYjM4pZ3bfoUMP6Y=;
        b=l4YhHKQZiF0KlPdQ+Wic9WspXpwEA16UHm5563z76OhC4J6fRvq4P/8WB1P50P/1Xp
         dzAZssJwS/WkiXPqrLmzp4odNDXjrtOE4HNDh1SQEm82X/GlXCxszcRUXJuGiNJbgMHO
         /6a5OkU63iXEmzgja5YeQAX4cikhSmYxgoWm0TP+oOPA/X39vwaVs977bcWZK4wqnNC7
         GJuG3ITT+qabOJQCvORiRCFG/j1TKX0qFmUFGGn7NE+GVmk5hUKsBFwsdlqzs8KmQQCx
         xS7ypsI61vzoP9v71n85a05hbgU6QSfONTHWY3XZnzfDAGOC+gN76J0aMm9+XT1F0jXu
         VVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=34bOJ2fP/uYBYyAbZ0stgeBIJfEsYjM4pZ3bfoUMP6Y=;
        b=0br3ukaUAcZtQ3jNSRD1BjisS9l6r+aDUiOCg+Lp+UgbowLmQeBbnFlx6UYQKJJm7U
         wEF3XFX0mqyrEbVe4vyzVlP5h1E0kNaz7gh+WO09HRT9sxZlIBrc2ice6efXahbNBs1b
         oEIOfzqtgqzThgpulFqlKPHb3/bD5hREcHW3BPXt/nusco3Hgpc90zD1ViaJjgAj4Ytn
         8NBJmqdyP4WpSqb/O8tGQMgzJ8ibNEnRogIFx2TocokSes9BnUxVuCL3TmGEslGbJwcq
         LuevmBdNJL8jOmYitQMohE4B+fdi1HwCVGm9/EUQK61eMqjKRHu9mkE5sJdZ5+AzUdk7
         hY4Q==
X-Gm-Message-State: AJIora/eg3hxZdIJdyuJFnzpjEqHso7IDzK1fcht4gzGxHjWUZBfiXrD
        iSpoFhqcOidZER4o6tBPqBmS+T/H8PI=
X-Google-Smtp-Source: AGRyM1srZgukuwFiWnqTkLSEl9HCrHkpHkszshv5AKuyJsTCJYP88qJd5WLSagv7jZXIPO1dHBVEPg==
X-Received: by 2002:a05:6a00:148d:b0:528:3d32:f111 with SMTP id v13-20020a056a00148d00b005283d32f111mr16704675pfu.31.1657526243544;
        Mon, 11 Jul 2022 00:57:23 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902768c00b0016bdeb58609sm3974360pll.238.2022.07.11.00.57.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jul 2022 00:57:22 -0700 (PDT)
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@kernel.org>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
 <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
 <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com>
Date:   Mon, 11 Jul 2022 19:57:17 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

Am 11.07.2022 um 19:16 schrieb Geert Uytterhoeven:
> On Sun, Jul 10, 2022 at 6:12 PM Arnd Bergmann <arnd@kernel.org> wrote:
>> On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>>> Convert the mvme147_scsi driver to a platform device driver.
>>> This is required for conversion of the driver to the DMA API.
>>>
>>> CC: linux-scsi@vger.kernel.org
>>> Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
>>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>>
>> The patch looks correct to me, but the type cast for the address doesn't
>> seem right:
>>
>>> -       regs.SASR = (volatile unsigned char *)0xfffe4000;
>>> -       regs.SCMD = (volatile unsigned char *)0xfffe4001;
>>>
>>> -       hdata = shost_priv(mvme147_shost);
>>> +       mvme147_inst->base = mres->start;
>>> +       mvme147_inst->irq = ires->start;
>>> +
>>> +       regs.SASR = (volatile unsigned char *)mres->start;
>>> +       regs.SCMD = (volatile unsigned char *)(mres->start)+0x1;
>>
>> A resource would pass a phys_addr_t token, but the driver expects a
>> virtual address that should be an __iomem pointer. The MMIO area
>> already gets mapped into virtual addresses in arch/m68k/kernel/head.S,
>> so it makes sense to skip the extra ioremap() and just use the address,
>> but then you can't pass it as an IORESOUCRE_MEM token and should
>> use platform_data with the pointer instead.

OK, got it now (I had missed the physical/virtual mismatch entirely).

>>
>> The alternative is to do it the normal way and pass the physical address
>> as a resource, that you can pass into devm_platform_ioremap_resource()
>> or a similar helper.
>
> I would prefer the latter.  While head.S sets up the mapping,
> __ioremap() does not have support for this on the mvme platform,
> so this has to be added first. Look at the amiga and virt platforms
> for examples.

I see - doesn't look too hard to do, and should not affect any other 
existing code.
Is it worth adding the same support for Atari as well?

> If you do want to pass the virtual address as platform data (for now
> ;-), please provide the physical memory resource too, so we don't
> have to go through another synchronization step with the m68k and
> scsi trees later.

That's what I had intended to do, but I'd rather get this sorted once 
and for all.

Cheers,

	Michael


>
> Thanks!
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
