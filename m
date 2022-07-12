Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B049C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 03:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiGLD1h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 23:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiGLD1f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 23:27:35 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F6B2E9EA;
        Mon, 11 Jul 2022 20:27:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id v7so4336332pfb.0;
        Mon, 11 Jul 2022 20:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=WTtjtZY6uxcl2m7Ab9A92iZ/s2opSdZnSRetncaC5VI=;
        b=UOhd/pea2MRRypd1g/okkgIjcbg3RthD1OOcD1r1rrnP10v1eSugJcIMcpAeeACccE
         mWIFS+S/cLbhb1ifMyZkXpuUcSNJ5hXpHQv1PQ60A036w/sdmQ9e2bQCIhFlpsYUC/d0
         z2VBfZj1Qa9ylGA38xjrvAiRuxRoGJPPz8j+OEBTu8LuDlQVRd7KhIXoIgYyyZt5xFFg
         EGWaXlFHejPBmN+IOecK97/BL6TFjaxDQwEIa3vUorsQOTj/QtMor5UkPru7Z2EhccwD
         fP9HbqMggYwpDwNIAsSKB2SMzU/wVO7scVdumRoMkQppF7omAZjiITAX3poHCz52E4MI
         K32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=WTtjtZY6uxcl2m7Ab9A92iZ/s2opSdZnSRetncaC5VI=;
        b=6fS4PKnz+lC4D0GXBG/o5va0255RSmn1IQwne73ZZwDZMAHlArHH5MQcT+G8cw+Got
         +qgChEIAaKZrH8Fphqzeo2xByDU7+Dvl2t9fhmd1JTQUr7v+7XecRnurOCcwIkO26JDu
         OpR+E0xZJDcrIjfWdPLWBHeN8jQ76FbURznVs62raF7WYS4AbiHmdXORs/KpCqpyD5Oh
         XtZyk9G1tHnLhhZLARqHvbIxhhXnGZ7U15cMLzr4W3G++75qSpIyJINZmjBGPbb0bFjn
         dMj6ZxQgkh7PbdQT0B0clgXXBAEv4PylWo8BZ9/1WRXgexivSWXxhNparHQk0eID9G1H
         jFlQ==
X-Gm-Message-State: AJIora9yyvGYTxc4gbMAhVB5lyVcda3BVw9g2kdbtCSkFsGztXZfEvWN
        EeFHQU5g1Mw8RWpp90DljuWOlA0FhT4=
X-Google-Smtp-Source: AGRyM1sR/jA0RDaGwhWSAy5YpG3bp+usOBehY8r4jHqGB08Px1Uf571Q8VNRlM55RzLIFm4riCyt8w==
X-Received: by 2002:a63:4d0e:0:b0:412:1877:9820 with SMTP id a14-20020a634d0e000000b0041218779820mr18769894pgb.177.1657596454206;
        Mon, 11 Jul 2022 20:27:34 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id a6-20020aa795a6000000b00528d752969esm5532098pfk.25.2022.07.11.20.27.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jul 2022 20:27:33 -0700 (PDT)
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20220709001019.11149-1-schmitzmic@gmail.com>
 <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
 <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com>
 <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com>
 <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
 <a4a3908a-29c5-fe2e-4c58-eed59133d39f@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <f565782c-6463-d962-13ce-01c5f0d160e7@gmail.com>
Date:   Tue, 12 Jul 2022 15:27:29 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <a4a3908a-29c5-fe2e-4c58-eed59133d39f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

I just realized the commit message subject for this patch needs 
correcting. Will that mess up your workflow (assuming I retain the 
subject line for the announcement mail)?

Cheers,

	Michael


Am 12.07.2022 um 08:02 schrieb Michael Schmitz:
> Hi Geert,
>
> Am 11.07.2022 um 20:27 schrieb Geert Uytterhoeven:
>> Hi Michael,
>>
>> On Mon, Jul 11, 2022 at 9:57 AM Michael Schmitz <schmitzmic@gmail.com>
>> wrote:
>>> Am 11.07.2022 um 19:16 schrieb Geert Uytterhoeven:
>>>> On Sun, Jul 10, 2022 at 6:12 PM Arnd Bergmann <arnd@kernel.org> wrote:
>>>>> A resource would pass a phys_addr_t token, but the driver expects a
>>>>> virtual address that should be an __iomem pointer. The MMIO area
>>>>> already gets mapped into virtual addresses in arch/m68k/kernel/head.S,
>>>>> so it makes sense to skip the extra ioremap() and just use the
>>>>> address,
>>>>> but then you can't pass it as an IORESOUCRE_MEM token and should
>>>>> use platform_data with the pointer instead.
>>>
>>> OK, got it now (I had missed the physical/virtual mismatch entirely).
>>
>> And the __iomem is there so we can catch mistakes using sparse
>> (make C=2 path/to/file/.o).
>
> I'll need to make a habit of that ...
>
>>>>> The alternative is to do it the normal way and pass the physical
>>>>> address
>>>>> as a resource, that you can pass into devm_platform_ioremap_resource()
>>>>> or a similar helper.
>>>>
>>>> I would prefer the latter.  While head.S sets up the mapping,
>>>> __ioremap() does not have support for this on the mvme platform,
>>>> so this has to be added first. Look at the amiga and virt platforms
>>>> for examples.
>>>
>>> I see - doesn't look too hard to do, and should not affect any other
>>> existing code.
>>> Is it worth adding the same support for Atari as well?
>>
>> From a quick glance at arch/m68k/kernel/head.S, it seems that
>> on Atari there is no identity mapping (the high I/O area is mapped
>> to the virtual low area).  That means __ioremap() and iounmap()
>> wouldn't be symmetrical, but it can be done.
>
> As I read it, it's the other way: virtual 0xffxxxxxx is mapped to phys.
> 0x00ffxxxx, and all hardware addresses are given in the upper window
> (Medusa/Hades use that window only, and have identity mappings there).
>
> So returning identity mapping in the high window would work AFAICS. I'll
> give that a try sometime.
>
>> Note that on Amiga we only use the identity shortcut for Zorro III
>> memory (and only for the first half?), i.e. ioremap() on Zorro II I/O
>> does add new mappings.  Hence most Zorro II drivers use ZTWO_VADDR()
>> instead of ioremap().
>
> I see ZTWO_VADDR() already returns void __iomem* ... Fixing this patch
> would sort out the m68k drivers, leaving SGI. I'll have to see whether I
> can dig up a SGI workstation with this driver; might be easier than
> getting hold of any Amgias here Dowh Under.
>
> Cheers,
>
>     Michael
>
>
>>
>> Gr{oetje,eeting}s,
>>
>>                         Geert
>>
>> --
>> Geert Uytterhoeven -- There's lots of Linux beyond ia32 --
>> geert@linux-m68k.org
>>
>> In personal conversations with technical people, I call myself a
>> hacker. But
>> when I'm talking to journalists I just say "programmer" or something
>> like that.
>>                                 -- Linus Torvalds
>>
