Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C9EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 12:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CE8B61362
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 12:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhJUMXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 08:23:17 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50171 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbhJUMXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 08:23:14 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M5PVb-1meMPd2tc5-001TQ7; Thu, 21 Oct 2021 14:20:56 +0200
Received: by mail-wr1-f51.google.com with SMTP id u18so300482wrg.5;
        Thu, 21 Oct 2021 05:20:56 -0700 (PDT)
X-Gm-Message-State: AOAM533JGOF6ns2ouO1yPdioCFzTLSGlc5OAAukSX7VsNLyiYcrd8Xv1
        YvxqyKb7lE/niXbr5JLMi3e56u3ke/2oe6gpc5Q=
X-Google-Smtp-Source: ABdhPJwJOYZEntHVSFnBcY3kJm3ICu3lH/OpB0pul2wHC3aZtyh/WLsgKixyQ1gvT07T8Fw6b7nCs2vLRylHfqhAxF8=
X-Received: by 2002:adf:ab46:: with SMTP id r6mr6927135wrc.71.1634818856286;
 Thu, 21 Oct 2021 05:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvv6YsRM2Qf7AGMo3nwqkuAt_D1i+6H_ApHk3kmScyDyg@mail.gmail.com>
In-Reply-To: <CA+G9fYvv6YsRM2Qf7AGMo3nwqkuAt_D1i+6H_ApHk3kmScyDyg@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 21 Oct 2021 14:20:40 +0200
X-Gmail-Original-Message-ID: <CAK8P3a21U0jzMOUWp1rhrNrD3szxxrwo59SBYG89xpYJGXteRA@mail.gmail.com>
Message-ID: <CAK8P3a21U0jzMOUWp1rhrNrD3szxxrwo59SBYG89xpYJGXteRA@mail.gmail.com>
Subject: Re: BUG: KASAN: use-after-free in blk_mq_sched_tags_teardown
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-block <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, lkft-triage@lists.linaro.org,
        Anders Roxell <anders.roxell@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh R <vigneshr@ti.com>,
        linux-mtd <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:66P/+ev02kmBlPErcfR57m0taCBfxBrGQQXFOoqIBzD7gd1Dw+m
 0wwh9n9wZtNiXbmKWPGRvbA2dItyIPyl8irzFB1OMy/iCeloP9ttl6kleKhvZlVBXQu2npb
 jaT2Y7lgeCB46scqe3UraqgaiXDmK2JJRXHRQ6PxnM7uBMGE98ih63SenBzJPUqOmaUArLv
 9iSiOSlwsJb4E9SsBrIGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:PSTYbNgSsAk=:+oGugXyW1UMvelmOCL0YVp
 C+uE0k86LJjmW8jb6oQOlKAUYdn5GXB+rL7ion09GbZhIxv7nZHJz0gSF3wbSTl8h/mA1XjIu
 9DvckaX4sjfiX4aiWzOocTYmHNCEHUe9pNFS3qfoejK6YgmQEAzDQS8VQ1zWOB6i9E9yJLbew
 YD4UJDJ+mZ5MZpeDR9+9U1zTqv6+Pu2L9LvKJiq++5vQCiEC4TiiFKCMFa2rq95kGJLo+5j+d
 iZf1x9Voll60g+jJrp/yalVPpdb6ALiUq8uD0EgQnoEXElHtjGxBwkxbLooWU3FbThlA3R6Qs
 1DW9ok//+KjwE0kwX244OvmZB9mtNzHzIxHJwy/3GFu/Uq5JUzk7wfqEW+64PwXeOaPZMgsAv
 vOcbOhXE6SK2Z8NX/Pd3qgU3zXBBRwLt70bP9na2xLVrJJLwyz2lCQAcP5JrEEW0DrwoyNNHH
 zc9ybhi0rMZ40Vdudt9LUxgntfFLqqEBuIddvMt2rJ9fF9uzO0RmcMFkRlohD8h3IyU1p6+Ej
 8hpA55FmQrz5VhrTSVAfvvU+C/tNpVTj5/ZnhfIPi3TC4nvtOoglPivDk18dNmAf4OJtGwGy/
 7vkQtAZkEpV+wAkE2nHoVnVdBz/f68RWLsx2Sp5FsfTBuMZBAHpy0piMmjgH3WtmbDY/2TH08
 jh80rJUf9UhaVPDFw+g0XMVBA8/SAQi1W3DRTcg+s7kXslDUph0jTGv0LbFCT1PfXSCNW3IXH
 r56X8IMUKGHU+TXndwmRhwYWz/lbewaDDnQ6b4cM+9iaXug4vsZEUS+g9Q+Hmx90LD2iPkUaw
 lyQ/RXF5h6LyLqadYlyoH+0ez7in4Pg8bIQKwh6ngxbYyCWlcI=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 21, 2021 at 2:01 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Following KASAN BUG noticed on linux next 20211021 while booting qemu-arm64
> with allmodconfig.

> [   77.730367][    T5] Freed by task 1:
> [   77.732009][    T5]  kasan_save_stack+0x30/0x80
> [   77.734083][    T5]  kasan_set_track+0x30/0x80
> [   77.736085][    T5]  kasan_set_free_info+0x34/0x80
> [   77.738261][    T5]  ____kasan_slab_free+0xfc/0x1c0
> [   77.740433][    T5]  __kasan_slab_free+0x3c/0x80
> [   77.742518][    T5]  slab_free_freelist_hook+0x1d4/0x2c0
> [   77.744892][    T5]  kfree+0x160/0x300
> [   77.746618][    T5]  blktrans_dev_release+0x64/0x100
> [   77.748821][    T5]  del_mtd_blktrans_dev+0x1c0/0x240
> [   77.751079][    T5]  mtdblock_remove_dev+0x28/0x80
> [   77.753246][    T5]  blktrans_notify_remove+0xa4/0x140
> [   77.755507][    T5]  del_mtd_device+0x84/0x1c0
> [   77.757541][    T5]  mtd_device_unregister+0x90/0xc0
> [   77.759764][    T5]  physmap_flash_remove+0x58/0x180
> [   77.762012][    T5]  platform_remove+0x48/0xc0
> [   77.764032][    T5]  __device_release_driver+0x1dc/0x340
> [   77.766393][    T5]  driver_detach+0x138/0x200
> [   77.768396][    T5]  bus_remove_driver+0x100/0x180
> [   77.770554][    T5]  driver_unregister+0x64/0xc0
> [   77.772633][    T5]  platform_driver_unregister+0x28/0x80
> [   77.775042][    T5]  physmap_init+0xc4/0xfc
> [   77.776994][    T5]  do_one_initcall+0xb0/0x2c0
> [   77.779028][    T5]  do_initcalls+0x17c/0x244
> [   77.781023][    T5]  kernel_init_freeable+0x2d4/0x378
> [   77.783269][    T5]  kernel_init+0x34/0x180
> [   77.785196][    T5]  ret_from_fork+0x10/0x20
> [   77.787135][    T5]
> ...
> full boot log link,
> https://pastebin.com/xL5MYSD6

I think this is related to an earlier bug that Anders reported a while ago,
see [1]. I had looked at it originally, and found that this probably a
device that gets probed from CONFIG_MTD_PHYSMAP_COMPAT
and then freed again immediately after we find the device does not
exist, starting with commit dcb3e137ce9b ("[MTD] physmap: make
physmap compat explicit").

It's not really the fault of CONFIG_MTD_PHYSMAP_COMPAT
describing a nonexisting device, but instead it's something in the
cleanup path.

        Arnd

[1] https://lore.kernel.org/linux-mtd/CADYN=9Kjw_3cDGAvh9=+nNwdYof1kUPKG-SUOP5FsQhZ+gz62Q@mail.gmail.com/
