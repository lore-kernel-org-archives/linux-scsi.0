Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE28C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 21:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F40DF610E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 21:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhDHVpV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 17:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhDHVpV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 17:45:21 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7CDC061760;
        Thu,  8 Apr 2021 14:45:09 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id t23-20020a0568301e37b02901b65ab30024so3791654otr.4;
        Thu, 08 Apr 2021 14:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qogi5TMemVGk/z0LzSSxu+TKT9xxwVg71a4qN0R6ZTM=;
        b=ln3u/reC3AHXfTDxFD3SLkzLUnTrtnp27eIrCPnLb0aToAWYf1oYEjBpHvE0DrFXPa
         Nz4qmA4fDDE7iWAxHg6SOA+3sOIOXf1oyAdW1yMfHI/LD8JtwGdK+KK/z6S+gDb8aNc+
         Kv/xbu+SSZEl5hto0M0JfCaNgjm2c+UV2q77LNl4Dbbb83ePFEq6tSyiYajWrv4Xm7/r
         abIzbvqBlk96rSWu+CiveWNoV2TADVVKoh5eDuYsNe/dYFoGJXloSmybShgf4E94PkYf
         TOsJUIfWkF9uaNXO7XEU4VVk2bVTe45OCQ0ZAikcesBpyAU7K6Z7vy/rAOg7uMtWSoMT
         VaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qogi5TMemVGk/z0LzSSxu+TKT9xxwVg71a4qN0R6ZTM=;
        b=mAP091dfH09/jO/R8NHmDOMjAzr734DEqHF4D3aPkD9uhvJK5yNLxcWQkxdGvgnFVf
         nNZ1fthl6Tv/yH/mAIF1JGbOOQ0ha+uXOEJcPaf30Mc+m+VWVJelveqPF4fvEbrFAifA
         dU3khs0U6MBMKb0wehE6CS9mf0MfdxsfwNO6eYXw08B12P66G2sd5gZias1WZGE6ZTTf
         Qud2c3kNuZr2ZpAsAGU5uCrVsoYnt0pkfftjvmRDM+nXjwwyox+fg09CuXhRpJFlqvec
         wd6rIbXEs5fLm0aUHF+LH7xgvQZISyp6fP0mdYq/TspysVcvZSno9a6vQtLQPJ9tRk8J
         oXmw==
X-Gm-Message-State: AOAM531iC8vFxxXSDoQDr7kbL0rMX4FQgO+GD4cDeFarB9Of28mluoJl
        0JL6OIUb2qbiDo1iczVgfzQ=
X-Google-Smtp-Source: ABdhPJzj52YuFxFnH2W4Oh+kQyEeihMWdCj2F0d7c8oQ6OUoQQtprV2tQ3CnI8WbphC6U5YPHfE/cg==
X-Received: by 2002:a05:6830:210e:: with SMTP id i14mr9546248otc.229.1617918308524;
        Thu, 08 Apr 2021 14:45:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l81sm145858oif.31.2021.04.08.14.45.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Apr 2021 14:45:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 8 Apr 2021 14:45:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] block: stop calling blk_queue_bounce for passthrough
 requests
Message-ID: <20210408214506.GA184625@roeck-us.net>
References: <20210331073001.46776-1-hch@lst.de>
 <20210331073001.46776-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331073001.46776-9-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 31, 2021 at 09:30:01AM +0200, Christoph Hellwig wrote:
> Instead of overloading the passthrough fast path with the deprecated
> block layer bounce buffering let the users that combine an old
> undermaintained driver with a highmem system pay the price by always
> falling back to copies in that case.
> 

Hmm, that price is pretty high. When trying to boot sh images from usb,
it results in a traceback, followed by an i/o error, and the drive
fails to open.

WARNING: CPU: 0 PID: 5 at block/blk-map.c:488 blk_rq_append_bio+0xdc/0xf4
Modules linked in:

CPU: 0 PID: 5 Comm: kworker/u2:0 Not tainted 5.12.0-rc6-next-20210408 #1
Workqueue: events_unbound async_run_entry_fn
PC is at blk_rq_append_bio+0xdc/0xf4
PR is at blk_rq_map_kern+0x154/0x2d4
PC  : 8c16b7bc SP  : 8c82bcd8 SR  : 40008000 TEA : c00d9fe0
R0  : 000002bc R1  : 00000001 R2  : 00000020 R3  : 00000020
R4  : 8ca58000 R5  : 8ca3bc80 R6  : 8ff93c20 R7  : 00000000
R8  : 00000000 R9  : 8ca5c800 R10 : 8ca5c808 R11 : 8ca3bc80
R12 : 8ca1ae78 R13 : 00000008 R14 : 00000c00
MACH: 0000aac5 MACL: 2fff92b5 GBR : 00000000 PR  : 8c16b9b0

Call trace:
 [<8c22d658>] __scsi_execute+0x54/0x164
 [<8c26508e>] read_capacity_10+0x7a/0x190
 [<8c1aacb4>] memset+0x0/0x8c
 [<8c22d6e4>] __scsi_execute+0xe0/0x164
 [<8c26625a>] sd_revalidate_disk+0xcc2/0x1bf0
 [<8c13819c>] internal_create_group+0x0/0x2a0
 [<8c21aa10>] device_add+0xec/0x774
 [<8c1ad8ec>] kobject_put+0x0/0xf4
 [<8c138598>] sysfs_create_groups+0x0/0x14
 [<8c1ae0a4>] kobject_set_name_vargs+0x20/0x90
 [<8c267636>] sd_probe+0x296/0x384
 [<8c265598>] sd_revalidate_disk+0x0/0x1bf0
 [<8c21e786>] really_probe+0xc2/0x320
 [<8c011ab8>] arch_local_irq_restore+0x0/0x24
 [<8c21cdac>] bus_for_each_drv+0x50/0xa0
 [<8c011ab8>] arch_local_irq_restore+0x0/0x24
 [<8c1ad4ec>] klist_next+0x0/0xf4
 [<8c21ebf8>] __device_attach_driver+0x0/0x90
 [<8c21e104>] __device_attach_async_helper+0x6c/0x94
 [<8c039cfa>] async_run_entry_fn+0x22/0xa8
 [<8c03190e>] process_one_work+0x13e/0x2b4
 [<8c0321f6>] worker_thread+0x10a/0x388
 [<8c011ab8>] arch_local_irq_restore+0x0/0x24
 [<8c0317d0>] process_one_work+0x0/0x2b4
 [<8c036e4e>] kthread+0xce/0x108
 [<8c042d30>] __init_swait_queue_head+0x0/0x8
 [<8c0320ec>] worker_thread+0x0/0x388
 [<8c0151c4>] ret_from_kernel_thread+0xc/0x14
 [<8c011ab0>] arch_local_save_flags+0x0/0x8
 [<8c011ab8>] arch_local_irq_restore+0x0/0x24
 [<8c03ceac>] schedule_tail+0x0/0x5c
 [<8c036d80>] kthread+0x0/0x108

...
blk_update_request: I/O error, dev sda, sector 2 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
EXT2-fs (sda): error: unable to read superblock
sd 1:0:0:0: [sda] tag#0 access beyond end of device
blk_update_request: I/O error, dev sda, sector 2 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
MINIX-fs: unable to read superblock
sd 1:0:0:0: [sda] tag#0 access beyond end of device
blk_update_request: I/O error, dev sda, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
FAT-fs (sda): unable to read boot sector
VFS: Cannot open root device "sda" or unknown-block(8,0): error -5

Reverting this patch fixes the problem.

Guenter

---
# bad: [6145d80cfc62e3ed8f16ff584d6287e6d88b82b9] Add linux-next specific files for 20210408
# good: [e49d033bddf5b565044e2abe4241353959bc9120] Linux 5.12-rc6
git bisect start 'HEAD' 'v5.12-rc6'
# good: [109c72558f12be32f904747573e1f221537c5f17] Merge remote-tracking branch 'crypto/master'
git bisect good 109c72558f12be32f904747573e1f221537c5f17
# bad: [379e1b0ffc22f8e0af810558ae87f742a01169c6] Merge remote-tracking branch 'ftrace/for-next'
git bisect bad 379e1b0ffc22f8e0af810558ae87f742a01169c6
# good: [8bc74be758b51ff45786c1840fd8cf405773e0c6] Merge remote-tracking branch 'sound/for-next'
git bisect good 8bc74be758b51ff45786c1840fd8cf405773e0c6
# bad: [58fea702e23f66773e1de827de44fea3087c453c] Merge remote-tracking branch 'mmc/next'
git bisect bad 58fea702e23f66773e1de827de44fea3087c453c
# good: [73935e931c945b019bde312a99f1b43a0a783fca] Merge series "ASoC: soc-core: tidyup error handling for rtd" from Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>:
git bisect good 73935e931c945b019bde312a99f1b43a0a783fca
# good: [e0956194697c0b319a71406e6c7452555820eeb5] Merge branch 'for-5.13/drivers' into for-next
git bisect good e0956194697c0b319a71406e6c7452555820eeb5
# bad: [8723f253faed6dafc718d0a0b780567f09446a8b] Merge remote-tracking branch 'block/for-next'
git bisect bad 8723f253faed6dafc718d0a0b780567f09446a8b
# good: [73e7f1732e800a88cafab31d75548c6fcfdd8c47] Input: imx_keypad - convert to a DT-only driver
git bisect good 73e7f1732e800a88cafab31d75548c6fcfdd8c47
# good: [8361c6da77b7d267707da9ff3b94458e018dd3da] Merge series "Adds SPI support" from Jiri Prchal <jiri.prchal@aksignal.cz>:
git bisect good 8361c6da77b7d267707da9ff3b94458e018dd3da
# bad: [c8872394ac388b38952dbe89da91bf2b108ce5e6] Merge branch 'for-5.13/libata' into for-next
git bisect bad c8872394ac388b38952dbe89da91bf2b108ce5e6
# good: [ce288e0535688cc3475a3c3d4d96624514c3550c] block: remove BLK_BOUNCE_ISA support
git bisect good ce288e0535688cc3475a3c3d4d96624514c3550c
# good: [7d33004d24dafeedb95b85a271a37aa33678ac0b] pata_legacy: Add `probe_mask' parameter like with ide-generic
git bisect good 7d33004d24dafeedb95b85a271a37aa33678ac0b
# bad: [393bb12e00580aaa23356504eed38d8f5571153a] block: stop calling blk_queue_bounce for passthrough requests
git bisect bad 393bb12e00580aaa23356504eed38d8f5571153a
# good: [9bb33f24abbd0fa2fadad01ec75438d7cc239189] block: refactor the bounce buffering code
git bisect good 9bb33f24abbd0fa2fadad01ec75438d7cc239189
# first bad commit: [393bb12e00580aaa23356504eed38d8f5571153a] block: stop calling blk_queue_bounce for passthrough requests
