Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F61CCA480
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 08:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiGKI2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 04:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiGKI1v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 04:27:51 -0400
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3911F2C2;
        Mon, 11 Jul 2022 01:27:48 -0700 (PDT)
Received: by mail-qk1-f169.google.com with SMTP id l26so3311657qkl.10;
        Mon, 11 Jul 2022 01:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d/Kz56y4ozdFdCcmQ6PKeOtaCX8/z4HkE/bk91SNay4=;
        b=EEBaAfhgN2YX+xG1WDclerQfCYbGlEc7AkWHEhD1UpBcmqvNpuh8J12PIYDOPYDKUC
         rK5cDX4mWIQuSSB1CCX5l0/LUAEIMVMssnDlmEKdql85friQJFnylGpBaKqnIiaXvlmQ
         UuEZRBeoBOlaDVXRRBpXHCNONHpyZ/sYD/ZxIui/UjVc5kXKfGZ8UJB5BMDKpOWPo3IP
         /w+CEdW1P9FJ8CTMMj77W2uV147A87NNevw8XZ32Alr6X28coSRNNhTM6qh2pl0nOfEr
         m+FIzXkFB2k3cegvCNhJGCXhNe1N7PF4V40zri8R0BTNOEDSXIcpHshCOlZtD7pMO7AA
         c9aw==
X-Gm-Message-State: AJIora9SthxRBemcwWavorcTx/B5dqx7vuHG4IuC7AHsx/ZHiN5mpszu
        qBl5H1B/QWMtRnlBP/Uw8w0gUDeBx0QjxA==
X-Google-Smtp-Source: AGRyM1sRer6bfMBIxXumoxS55B69taLDvFH8DFvMBWIxo4OFCDwnXIgKO9ODFGqcyz6Ak5OE5Eoq5g==
X-Received: by 2002:a05:620a:bc9:b0:6a6:5d5a:4306 with SMTP id s9-20020a05620a0bc900b006a65d5a4306mr10606301qki.391.1657528067062;
        Mon, 11 Jul 2022 01:27:47 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id e8-20020ac86708000000b0031ea76e90c0sm4854483qtp.22.2022.07.11.01.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 01:27:46 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id 64so7529675ybt.12;
        Mon, 11 Jul 2022 01:27:46 -0700 (PDT)
X-Received: by 2002:a25:bc8e:0:b0:66e:fe43:645c with SMTP id
 e14-20020a25bc8e000000b0066efe43645cmr8716617ybk.202.1657528066536; Mon, 11
 Jul 2022 01:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-4-schmitzmic@gmail.com>
 <CAK8P3a0FndsCkCrgXdai8=2oX5yWrMLArDHN5mA90AL4N7pmRw@mail.gmail.com>
 <CAMuHMdXapPSOBzSNTLy_RJV=RLq-6hcf-XFtvfSe-g=PrcAhEw@mail.gmail.com> <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com>
In-Reply-To: <fb5f0f5d-e144-3f5b-9e46-6e22d8a3ca60@gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 11 Jul 2022 10:27:35 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
Message-ID: <CAMuHMdVYpQCVhti34y-bNwn-nOFaN7w-xM-SBZbHh+oDwbRndw@mail.gmail.com>
Subject: Re: [PATCH v1 3/4] scsi - convert mvme146_scsi.c to platform device
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

On Mon, Jul 11, 2022 at 9:57 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Am 11.07.2022 um 19:16 schrieb Geert Uytterhoeven:
> > On Sun, Jul 10, 2022 at 6:12 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >> A resource would pass a phys_addr_t token, but the driver expects a
> >> virtual address that should be an __iomem pointer. The MMIO area
> >> already gets mapped into virtual addresses in arch/m68k/kernel/head.S,
> >> so it makes sense to skip the extra ioremap() and just use the address,
> >> but then you can't pass it as an IORESOUCRE_MEM token and should
> >> use platform_data with the pointer instead.
>
> OK, got it now (I had missed the physical/virtual mismatch entirely).

And the __iomem is there so we can catch mistakes using sparse
(make C=2 path/to/file/.o).

> >> The alternative is to do it the normal way and pass the physical address
> >> as a resource, that you can pass into devm_platform_ioremap_resource()
> >> or a similar helper.
> >
> > I would prefer the latter.  While head.S sets up the mapping,
> > __ioremap() does not have support for this on the mvme platform,
> > so this has to be added first. Look at the amiga and virt platforms
> > for examples.
>
> I see - doesn't look too hard to do, and should not affect any other
> existing code.
> Is it worth adding the same support for Atari as well?

From a quick glance at arch/m68k/kernel/head.S, it seems that
on Atari there is no identity mapping (the high I/O area is mapped
to the virtual low area).  That means __ioremap() and iounmap()
wouldn't be symmetrical, but it can be done.

Note that on Amiga we only use the identity shortcut for Zorro III
memory (and only for the first half?), i.e. ioremap() on Zorro II I/O
does add new mappings.  Hence most Zorro II drivers use ZTWO_VADDR()
instead of ioremap().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
