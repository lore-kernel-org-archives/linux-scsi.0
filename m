Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B96C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36BD26121F
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhJUNhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 09:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhJUNho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 09:37:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDE4C061243
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 06:35:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 5so1337320edw.7
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 06:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mK3OqhfTR/3crHzqfGZ0OC0iJVa2/KLLqHbKu+TtMvc=;
        b=eyP5gEGuSRObkLlREcZNFYMrKz4gk+fJus5vdchUCF3pvAf5trjBlYhJ8XB3h1figc
         MtEVsVXvtKn79LsvUIIQou5H0ZjDqyrJv2S/1p81jjL2kxFQLVXXqWZU7R9bcEB3zYiD
         bzNtMqUpWqSRoHGcfF3/lGu18EApwFA7H1bpdlT9Q0VvuLCMff6Bb/wCxQ0p4w9WXqMM
         YN/SaBZfLUYyFMYIbEiCqiLxQRaaHQrL3+Id0+G/tsjaTt30FcgwA8wkV1QpBfssoUm2
         hzEYSWLo87iw6pKXAbGNX2C+zO1zM+h9BcVHuifWLHdzmc5nW7h1v4JtuTVl8I37kRJh
         qEWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mK3OqhfTR/3crHzqfGZ0OC0iJVa2/KLLqHbKu+TtMvc=;
        b=Hl87Y1mrAIbh5+CAQ+cN46G/HhVtw5sFRgbEvvaFPS8uv39Li0tC2/1PZZwKj/8nBW
         6Bfdt10O2COnl4IlTk+00ult5GkuOAbFE2CzQt3+jE472mJBfBFRqZjOqTmgKJFFHUY7
         FbmRz979x/KE1SiH1ywZibCXU9Aee1deOMeGybv9T7CFk1B2afIvdXn3MJreAsDd55qq
         tGY4AzvEK5WFCNKWbaJlBkuE9okibi+f6iV7yJ55aiaohFlnEXmwIIp0LqhyLm/IIUfs
         i6YfDsDQ0NxbiH886Y5NqxohkWEzB3P4/YSzMG0pmlII5822/9LZmQ6nc81GeYPRrys9
         QNdw==
X-Gm-Message-State: AOAM532GmqVMcZwA0l2g0zff9rVI/OrfsbLWjs9EsspUL4GlyugL2VFh
        lcmyC2hC70E717MFcfsCVZSQdljShiGnfJpxWPX44w==
X-Google-Smtp-Source: ABdhPJzVR7aQr0Mb+s6OFUQLPhmMpZxgYebrmg/iz1/DMldqo1P5pDs2rmbmTuLsNucbTmdUYkIhoui9xptPiAG5LWM=
X-Received: by 2002:aa7:df83:: with SMTP id b3mr7700838edy.294.1634823324792;
 Thu, 21 Oct 2021 06:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvv6YsRM2Qf7AGMo3nwqkuAt_D1i+6H_ApHk3kmScyDyg@mail.gmail.com>
 <788ceb78-c0b8-b1cd-b658-31c377e24711@huawei.com>
In-Reply-To: <788ceb78-c0b8-b1cd-b658-31c377e24711@huawei.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Thu, 21 Oct 2021 15:35:13 +0200
Message-ID: <CADYN=9KqNsJL4PSdZYM89RRW6qwNGLrJd_+evXFO6XHSfAqYfA@mail.gmail.com>
Subject: Re: BUG: KASAN: use-after-free in blk_mq_sched_tags_teardown
To:     John Garry <john.garry@huawei.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-block <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Oct 2021 at 14:17, John Garry <john.garry@huawei.com> wrote:
>
> On 21/10/2021 13:01, Naresh Kamboju wrote:
> > Following KASAN BUG noticed on linux next 20211021 while booting qemu-arm64
> > with allmodconfig.
>
> Thanks for the report.
>
> I can't read comments and have broken the same thing twice ... please
> try this change:
>
> ---8<---
>
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index e85b7556b096..6a9444848e3a 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -541,7 +541,7 @@ static void blk_mq_sched_tags_teardown(struct
> request_queue *q, unsigned int fla
>
>          queue_for_each_hw_ctx(q, hctx, i) {
>                  if (hctx->sched_tags) {
> -                       if (!blk_mq_is_shared_tags(q->tag_set->flags))
> +                       if (!blk_mq_is_shared_tags(flags))
>                                  blk_mq_free_rq_map(hctx->sched_tags);
>                          hctx->sched_tags = NULL;
>                  }

That fixed this issue.

Tested-by: Anders Roxell <anders.roxell@linaro.org>

Cheers,
Anders

>
>
> --- >8 ---
>
> thanks
>
> >
> > [   77.613151][    T5] BUG: KASAN: use-after-free in
> > blk_mq_sched_tags_teardown+0x54/0x140
> > [   77.616733][    T5] Read of size 4 at addr ffff000010d9b258 by task
> > kworker/0:0/5
> > [   77.620107][    T5]
> > [   77.621306][    T5] CPU: 0 PID: 5 Comm: kworker/0:0 Tainted: G
> >    W       T 5.15.0-rc6-next-20211021 #1
> > 4d661763b10b5f85042868a82a033ba2fc3e45c4
> > [   77.626986][    T5] Hardware name: linux,dummy-virt (DT)
> > [   77.629480][    T5] Workqueue: events kobject_delayed_cleanup
> > [   77.632269][    T5] Call trace:
> > [   77.633853][    T5]  dump_backtrace+0x0/0x340
> > [   77.635938][    T5]  show_stack+0x34/0x80
> > [   77.637934][    T5]  dump_stack_lvl+0x88/0xd8
> > [   77.640070][    T5]  print_address_description.constprop.0+0x38/0x340
> > [   77.643034][    T5]  __kasan_report+0x160/0x200
> > [   77.645227][    T5]  kasan_report+0x5c/0x180
> > [   77.647312][    T5]  __asan_load4+0xc8/0x100
> > [   77.649391][    T5]  blk_mq_sched_tags_teardown+0x54/0x140
> > [   77.651984][    T5]  blk_mq_exit_sched+0x128/0x180
> > [   77.654299][    T5]  __elevator_exit+0x44/0x80
> > [   77.656415][    T5]  blk_release_queue+0x138/0x200
> > [   77.658710][    T5]  kobject_cleanup+0x144/0x200
> > [   77.660971][    T5]  kobject_delayed_cleanup+0x1c/0x40
> > [   77.663404][    T5]  process_one_work+0x50c/0x880
> > [   77.665684][    T5]  worker_thread+0x3ec/0x740
> > [   77.667838][    T5]  kthread+0x220/0x240
> > [   77.669740][    T5]  ret_from_fork+0x10/0x20
> > [   77.671778][    T5]
> > [   77.672974][    T5] Allocated by task 1:
> > [   77.674888][    T5]  kasan_save_stack+0x30/0x80
> > [   77.677082][    T5]  __kasan_kmalloc+0x78/0x100
> > [   77.679235][    T5]  kmem_cache_alloc_trace+0x360/0x400
> > [   77.681707][    T5]  add_mtd_blktrans_dev+0x274/0x6c0
> > [   77.684079][    T5]  mtdblock_add_mtd+0x110/0x180
> > [   77.686333][    T5]  blktrans_notify_add+0x68/0xc0
> > [   77.688521][    T5]  add_mtd_device+0x4e8/0x6c0
> > [   77.690659][    T5]  mtd_device_parse_register+0x13c/0x3c0
> > [   77.693258][    T5]  physmap_flash_probe+0x83c/0x8c0
> > [   77.695630][    T5]  platform_probe+0x98/0x140
> > [   77.697776][    T5]  really_probe+0x234/0x6c0
> > [   77.699913][    T5]  __driver_probe_device+0x144/0x240
> > [   77.702307][    T5]  driver_probe_device+0x68/0x140
> > [   77.704502][    T5]  __driver_attach+0x1f0/0x280
> > [   77.706598][    T5]  bus_for_each_dev+0xdc/0x1c0
> > [   77.708669][    T5]  driver_attach+0x40/0x80
> > [   77.710621][    T5]  bus_add_driver+0x1c0/0x300
> > [   77.712660][    T5]  driver_register+0x170/0x200
> > [   77.714749][    T5]  __platform_driver_register+0x50/0x80
> > [   77.717148][    T5]  physmap_init+0x5c/0xfc
> > [   77.719074][    T5]  do_one_initcall+0xb0/0x2c0
> > [   77.721127][    T5]  do_initcalls+0x17c/0x244
> > [   77.723109][    T5]  kernel_init_freeable+0x2d4/0x378
> > [   77.725376][    T5]  kernel_init+0x34/0x180
> > [   77.727304][    T5]  ret_from_fork+0x10/0x20
> > [   77.729261][    T5]
> > [   77.730367][    T5] Freed by task 1:
> > [   77.732009][    T5]  kasan_save_stack+0x30/0x80
> > [   77.734083][    T5]  kasan_set_track+0x30/0x80
> > [   77.736085][    T5]  kasan_set_free_info+0x34/0x80
> > [   77.738261][    T5]  ____kasan_slab_free+0xfc/0x1c0
> > [   77.740433][    T5]  __kasan_slab_free+0x3c/0x80
> > [   77.742518][    T5]  slab_free_freelist_hook+0x1d4/0x2c0
> > [   77.744892][    T5]  kfree+0x160/0x300
> > [   77.746618][    T5]  blktrans_dev_release+0x64/0x100
> > [   77.748821][    T5]  del_mtd_blktrans_dev+0x1c0/0x240
> > [   77.751079][    T5]  mtdblock_remove_dev+0x28/0x80
> > [   77.753246][    T5]  blktrans_notify_remove+0xa4/0x140
> > [   77.755507][    T5]  del_mtd_device+0x84/0x1c0
> > [   77.757541][    T5]  mtd_device_unregister+0x90/0xc0
> > [   77.759764][    T5]  physmap_flash_remove+0x58/0x180
> > [   77.762012][    T5]  platform_remove+0x48/0xc0
> > [   77.764032][    T5]  __device_release_driver+0x1dc/0x340
> > [   77.766393][    T5]  driver_detach+0x138/0x200
> > [   77.768396][    T5]  bus_remove_driver+0x100/0x180
> > [   77.770554][    T5]  driver_unregister+0x64/0xc0
> > [   77.772633][    T5]  platform_driver_unregister+0x28/0x80
> > [   77.775042][    T5]  physmap_init+0xc4/0xfc
> > [   77.776994][    T5]  do_one_initcall+0xb0/0x2c0
> > [   77.779028][    T5]  do_initcalls+0x17c/0x244
> > [   77.781023][    T5]  kernel_init_freeable+0x2d4/0x378
> > [   77.783269][    T5]  kernel_init+0x34/0x180
> > [   77.785196][    T5]  ret_from_fork+0x10/0x20
> > [   77.787135][    T5]
> > [   77.788230][    T5] The buggy address belongs to the object at
> > ffff000010d9b200
> > [   77.788230][    T5]  which belongs to the cache kmalloc-512 of size 512
> > [   77.793866][    T5] The buggy address is located 88 bytes inside of
> > [   77.793866][    T5]  512-byte region [ffff000010d9b200, ffff000010d9b400)
> > [   77.799169][    T5] The buggy address belongs to the page:
> > [   77.801555][    T5] page:fffffc0000436600 refcount:1 mapcount:0
> > mapping:0000000000000000 index:0x0 pfn:0x50d98
> > [   77.805683][    T5] head:fffffc0000436600 order:2
> > compound_mapcount:0 compound_pincount:0
> > [   77.809109][    T5] flags:
> > 0x1fffe0000010200(slab|head|node=0|zone=0|lastcpupid=0xffff)
> > [   77.812496][    T5] raw: 01fffe0000010200 fffffc0000436408
> > fffffc0000436908 ffff000006c03080
> > [   77.816037][    T5] raw: 0000000000000000 00000000000a000a
> > 00000001ffffffff 0000000000000000
> > [   77.819566][    T5] page dumped because: kasan: bad access detected
> > [   77.822255][    T5]
> > [   77.823357][    T5] Memory state around the buggy address:
> > [   77.825747][    T5]  ffff000010d9b100: fc fc fc fc fc fc fc fc fc
> > fc fc fc fc fc fc fc
> > [   77.829081][    T5]  ffff000010d9b180: fc fc fc fc fc fc fc fc fc
> > fc fc fc fc fc fc fc
> > [   77.832393][    T5] >ffff000010d9b200: fa fb fb fb fb fb fb fb fb
> > fb fb fb fb fb fb fb
> > [   77.835714][    T5]                                                     ^
> > [   77.838602][    T5]  ffff000010d9b280: fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb fb fb
> > [   77.841936][    T5]  ffff000010d9b300: fb fb fb fb fb fb fb fb fb
> > fb fb fb fb fb fb fb
> >
> > full boot log link,
> > https://pastebin.com/xL5MYSD6
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
> >
>
