Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A36C77B73
	for <linux-scsi@archiver.kernel.org>; Sun, 21 May 2023 05:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjEUFnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 May 2023 01:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjEUFnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2023 01:43:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3E8B9;
        Sat, 20 May 2023 22:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1684647796; i=deller@gmx.de;
        bh=wIE6ZCVoJYmlgH2DCnr7SkehVklk/MwSINRyzHNGD7w=;
        h=X-UI-Sender-Class:Date:From:Subject:To;
        b=SmzNX1kT+AbfE+JbYzG+sdFOVDzw22ZLmP3dEc5g8vhOVesWxPs8AiqMdSSYtmEGb
         LosH0WzttfsTuycdBDGgpmg3mmhBa9XT6TsgbJvzTaNlwGTE94do02AJ+39y9d5zWw
         GpjQ+qPCNfz59VJsGcw8AS9YDsxz9FZiTjpmi6fDEl3R/pipjNowIU0EAasSlHmFSm
         r5roOZ24Hg2ty7xVMOHAaN281R7Duzu6CzqQrM5KFV1MO0B5y0a2nJSiNrLK4aQDgd
         30/v4DxsaSWTMkWttylK2770Q1P5iXRltICsXQF8lVKxMoS1z/nQjHLWZsiRWvDwBj
         axHJV0/Kd9LgA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.156.224]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mdeb5-1qZOVB23dJ-00ZjvM; Sun, 21
 May 2023 07:43:16 +0200
Message-ID: <5057d550-c3f4-be34-d3e6-390790051232@gmx.de>
Date:   Sun, 21 May 2023 07:43:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Helge Deller <deller@gmx.de>
Subject: spinlock recursion in aio_complete()
To:     Linux SCSI List <linux-scsi@vger.kernel.org>, linux-aio@kvack.org,
        linux-parisc <linux-parisc@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:FPJZS2yjUeDBltt8xHEPSeFzlBvThIgPnBywmo7B+Kh+5CSXqvl
 0+aA2ha9orGwyyaofjKnDD4Cj0r4Ou06oC6Bu17+t2ItRHDg6E7oyAWUpKnt4fQ2iB21T0c
 avlO18BLFoSBQXgkfdA/i/UrzjnTSS8f+8aQgst6Sx+sN2ZEI+5j57BoDlgop+W9LliHZUW
 MYBqa5hB831bGcT9eGYXg==
UI-OutboundReport: notjunk:1;M01:P0:eACzzXxwg2g=;TzAqyM2xNIVM+wk9woye/ytcido
 Tt+2IGOeOgp/85eOf25CYDgB4SJ1t63XlzoISXhnQXfEGzG3nK+kDmULiXQzJ3iraJK5ukxe9
 VRCG253lnZ9tIEcPb6/Lgnv0tH36kHvFKmp0ilpzE7boepwMAUy8zSwkmAwFmA7o4QSrwhhLN
 hi57xGIxhsot2nNQzN2LlZMVVcc9w/ifhTG/Y4ZdFZMhGXoNv6Qskvk9kjMEwNPrrsvcCTxw3
 mckefEnNpodh7KKAuMYxrUz4PGV0SvKgyUWBXaI++xDkPjREqdHS4+dtUIzsxhgO4AyE8P8pg
 ucSKtuiXVRqDj0tDWFMBZEH+sOFxVO/KfDY1wgWxNA8SxH8UMSMJZlbLpDTieVID5B9KxZSx2
 AthQ0TwGRkYUbu8yrTZ7Lbe59B7FMpsTeml95GaGoGiBX4Td5gSMeVLmFz9CFhi24qUXzPU5O
 LipifdKwiCHhAUmCWR/UWKD6WZSXQexC9yHxmVstPBV2r+T9ZTKDpVqdDuNhSVauneRQaVrAt
 oUivMGr0YTiETZuLHxQy02YlXsAWOduSuwIxAamnDvWXMTLw6/7u3+5XaxbNocXFgun1uiafY
 YPOQRFy3vR2r+Qb5E5kXzaJvH5iAn9RwBXvf39srCoabcUVIp7G1IIHdkkxmUioK0dABJ7Xk9
 ZS2zV/tXIBFhRerVwA4LdCOohDYTCR3nv8iKJvj3hRqtQa204DwKYdg2oK7O89FzSiZ9Yjxsu
 jY7IiBV4yJiTJPdo5R4AeW28w1S4x16oQ1rIbaBd39r5pa9YDZIlybUH0W1UpeNarc86OR+4L
 NKRs0RhWWDJSNMxibwFWfsxrNzzjiYxrl9zhQhR9S9Z9BP2vOh/2pKcdsZzJ1h6er6SMAB06h
 zq/mJBXGZWaPwz6U2swAMaJLMGgEvYIVblY+MDwEMm+uS8GHMi+aniZ0e/T4p6hRS194Z49px
 W7RcK3NMxpQsAKH4fVSwGKLouac=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On a single-CPU parisc64 machine I face the spinlock recursion below.
Happens reproduceably directly at bootup since kernel 6.2 (and ~ 6.1.5).
Kernel is built for SMP. Same kernel binary works nicely on machines with more than
one CPU, but stops on UP machines.
Any idea or patch I could try?

Helge

[   26.116568] fuse: init (API version 7.38)
[   26.338231] loop: module loaded
[   26.357390] BUG: spinlock recursion on CPU#0, systemd/1
[   26.357504]  lock: 0x4ad42618, .magic: dead4ead, .owner: systemd/1, .owner_cpu: 0
[   26.357884] CPU: 0 PID: 1 Comm: systemd Not tainted 6.3.3+ #180
[   26.357976] Hardware name: 9000/800/rp3410
[   26.361055] Backtrace:
[   26.361055]  [<000000004030c4d0>] show_stack+0x74/0xb0
[   26.361055]  [<00000000412ec758>] dump_stack_lvl+0xd8/0x128
[   26.361055]  [<00000000412ec7dc>] dump_stack+0x34/0x48
[   26.361055]  [<00000000412d6c8c>] spin_dump+0xe0/0x120
[   26.361055]  [<00000000403f026c>] do_raw_spin_lock+0x138/0x1a0
[   26.361055]  [<00000000412efcb0>] _raw_spin_lock_irqsave+0x3c/0x78
[   26.361055]  [<0000000040808b9c>] aio_complete+0x68/0x470
[   26.361055]  [<000000004080bd54>] aio_complete_rw+0x200/0x400
[   26.361055]  [<0000000040aac314>] blkdev_bio_end_io_async+0x60/0x140
[   26.361055]  [<0000000040ab0fb0>] bio_endio+0x274/0x318
[   26.361055]  [<0000000040ad0b38>] blk_update_request+0x2bc/0x600
[   26.361055]  [<0000000040e6daa4>] scsi_end_request+0x60/0x370
[   26.361055]  [<0000000040e6ef68>] scsi_io_completion+0x9c/0x8e8
[   26.361055]  [<0000000040e5d5c8>] scsi_finish_command+0x10c/0x290
[   26.361055]  [<0000000040e6e7c4>] scsi_complete+0x118/0x308
[   26.361055]  [<0000000040acd3fc>] blk_mq_complete_request+0x60/0x98
[   26.361055]  [<0000000040e6eaf0>] scsi_done_internal+0x13c/0x1c8
[   26.361055]  [<0000000040e6ebac>] scsi_done+0x30/0x60
[   26.361055]  [<0000000040e8b140>] sym_xpt_done+0x94/0xc8
[   26.361055]  [<0000000040e91588>] sym_interrupt+0x5bc/0x28e8
[   26.361055]  [<0000000040e88c1c>] sym53c8xx_intr+0x98/0x170
[   26.361055]  [<00000000403fe380>] __handle_irq_event_percpu+0xdc/0x338
[   26.361055]  [<00000000403fe618>] handle_irq_event_percpu+0x3c/0xf8
[   26.361055]  [<000000004040925c>] handle_percpu_irq+0xb8/0x110
[   26.361055]  [<00000000403fcc74>] generic_handle_irq+0x60/0xb0
[   26.361055]  [<000000004030f930>] do_cpu_irq_mask+0x304/0x508
[   26.361055]  [<0000000040303070>] intr_return+0x0/0xc
