Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CD0C55178
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 19:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAF720665
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 19:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N93Wt0r0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgKFT0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Nov 2020 14:26:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgKFT0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Nov 2020 14:26:15 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5DBC0613CF
        for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2020 11:26:15 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id t16so2452574oie.11
        for <linux-scsi@vger.kernel.org>; Fri, 06 Nov 2020 11:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7xM8yoOSlcIp7mcJJ/rmeu6+ASz4zIP1z9+I63Srvs=;
        b=N93Wt0r0h2siiItdfO+AKk5EqlAFP7V9FIhnSvlb3kqgSpFjaI+hMNgjeMZJwjDOfg
         LqdUtCPJfi1cOjXPah/nQOjuggyiGVL/vUzm+a/1F2uLRW+uUBvp6EEnvKTT8aZ7CSBC
         MZHU934S4lwfiJNlb5kyImfvquKW8+lwtii24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7xM8yoOSlcIp7mcJJ/rmeu6+ASz4zIP1z9+I63Srvs=;
        b=sHIorTLkrh1B2sGsiPldtaPY0U94gM08vuhV2NddMX+tjScHvxdxkCmrD5FDRNVF2s
         kJFxqkTJO4NxTnQtdkRTiBoB4Q2DJL5a6pT6mCDZhE8KlfYNf8o25FHGz53U9CdXnUgY
         o/MzV3Y/KlXU5U6MMTMc2T0BxprS74yVGsB2Fardffz77r7g6Ziu+A1ct5zOfeGjr7qk
         FHt0ocknT2X3sQB4F79m6h4TXUnyzZ6765qmJ1WPm9fILolxa0aQglgY0aRkEZRTWanE
         dynhayZ/sT/a8z0zBErR68+iEr6ZDbNmXEn8ZIRm6FblCvwQEqwh4kdvslfiC7D8RxmY
         lWUA==
X-Gm-Message-State: AOAM531FrO7qM6+P9HKb0FLdnqm7jBja/L+iiwqBSodY+oe4hKsq9C6s
        ig1KNzYI+hNfeWRZgja59gZ64km1ZzIrS+QLh0Mi1Q==
X-Google-Smtp-Source: ABdhPJwoG2bMpbyMhuu4qtHq9P9HTV+YuREVlDGgbeZx7rG7Ba/QDtSpVdKZ8mBLv9hVU6+6PU4sPSaPcUbqfRIHhos=
X-Received: by 2002:aca:5886:: with SMTP id m128mr2058209oib.29.1604690774289;
 Fri, 06 Nov 2020 11:26:14 -0800 (PST)
MIME-Version: 1.0
References: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
 <1597850436-116171-18-git-send-email-john.garry@huawei.com>
 <fe3dff7dae4494e5a88caffbb4d877bbf472dceb.camel@redhat.com>
 <385d5408-6ba2-6bb6-52d3-b59c9aa9c5e5@huawei.com> <193a0440eed447209c48bda042f0e4db102355e7.camel@redhat.com>
 <519e0d58-e73e-22ce-0ddb-1be71487ba6d@huawei.com> <d8fd51b11d5d54e6ec7e4e9a4f7dcc83f1215cd3.camel@redhat.com>
 <d4f86cccccc3bffccc4eda39500ce1e1fee2109a.camel@redhat.com>
 <7624d3fe1613f19af5c3a77f4ae8fe55@mail.gmail.com> <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
In-Reply-To: <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Sat, 7 Nov 2020 00:55:48 +0530
Message-ID: <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Qian Cai <cai@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>, dgilbert@interlog.com,
        paolo.valente@linaro.org, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009dd3a005b3752f07"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000009dd3a005b3752f07
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 4, 2020 at 11:38 PM John Garry <john.garry@huawei.com> wrote:
>
> On 04/11/2020 16:07, Kashyap Desai wrote:
> >>>
> >>> v5.10-rc2 is also broken here.
> >>
> >> John, Kashyap, any update on this? If this is going to take a while to fix
> >> it
> >> proper, should I send a patch to revert this or at least disable the
> >> feature by
> >> default for megaraid_sas in the meantime, so it no longer breaks the
> >> existing
> >> systems out there?
> >
> > I am trying to get similar h/w to try out. All my current h/w works fine.
> > Give me couple of days' time.
> > If this is not obviously common issue and need time, we will go with module
> > parameter disable method.
> > I will let you know.
>
> Hi Kashyap,
>
> Please also consider just disabling for this card, so any other possible
> issues are unearthed on other cards. I don't have this card or any x86
> machine to test it unfortunately to assist.
>
> BTW, just to be clear, did you try the same .config as Qian Cai?
>
> Thanks,
> John
I am able to hit the boot hang and similar kind of stack traces as
reported by Qian with shared .config on x86 machine.
In my case the system boots after a hang of 40-45 mins. Qian, is it
true for you as well ?
With module parameter -"host_tagset_enable=0", the issue is not seen.
Below is snippet of the dmesg logs/traces which are observed during
system bootup and after wait of 40-45 mins
drives attached to megaraid_sas adapter are discovered:

========================================
[ 1969.502913] INFO: task systemd-udevd:906 can't die for more than
1720 seconds.
[ 1969.597725] task:systemd-udevd   state:D stack:13456 pid:  906
ppid:   858 flags:0x00000324
[ 1969.597730] Call Trace:
[ 1969.597734]  __schedule+0x263/0x7f0
[ 1969.597737]  ? __lock_acquire+0x576/0xaf0
[ 1969.597739]  ? wait_for_completion+0x7b/0x110
[ 1969.597741]  schedule+0x4c/0xc0
[ 1969.597743]  schedule_timeout+0x244/0x2e0
[ 1969.597745]  ? find_held_lock+0x2d/0x90
[ 1969.597748]  ? wait_for_completion+0xa6/0x110
[ 1969.597750]  ? wait_for_completion+0x7b/0x110
[ 1969.597752]  ? lockdep_hardirqs_on_prepare+0xd4/0x170
[ 1969.597753]  ? wait_for_completion+0x7b/0x110
[ 1969.597755]  wait_for_completion+0xae/0x110
[ 1969.597757]  __flush_work+0x269/0x4b0
[ 1969.597760]  ? init_pwq+0xf0/0xf0
[ 1969.597763]  work_on_cpu+0x9c/0xd0
[ 1969.597765]  ? work_is_static_object+0x10/0x10
[ 1969.597768]  ? pci_device_shutdown+0x30/0x30
[ 1969.597770]  pci_device_probe+0x197/0x1b0
[ 1969.597773]  really_probe+0xda/0x410
[ 1969.597776]  driver_probe_device+0xd9/0x140
[ 1969.597778]  device_driver_attach+0x4a/0x50
[ 1969.597780]  __driver_attach+0x83/0x140
[ 1969.597782]  ? device_driver_attach+0x50/0x50
[ 1969.597784]  ? device_driver_attach+0x50/0x50
[ 1969.597787]  bus_for_each_dev+0x74/0xc0
[ 1969.597789]  bus_add_driver+0x14b/0x1f0
[ 1969.597791]  ? 0xffffffffc04fb000
[ 1969.597793]  driver_register+0x66/0xb0
[ 1969.597795]  ? 0xffffffffc04fb000
[ 1969.597801]  megasas_init+0xe7/0x1000 [megaraid_sas]
[ 1969.597803]  do_one_initcall+0x62/0x300
[ 1969.597806]  ? do_init_module+0x1d/0x200
[ 1969.597808]  ? kmem_cache_alloc_trace+0x296/0x2d0
[ 1969.597811]  do_init_module+0x55/0x200
[ 1969.597813]  load_module+0x15f2/0x17b0
[ 1969.597816]  ? __do_sys_finit_module+0xad/0x110
[ 1969.597818]  __do_sys_finit_module+0xad/0x110
[ 1969.597820]  do_syscall_64+0x33/0x40
[ 1969.597823]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1969.597825] RIP: 0033:0x7f66340262bd
[ 1969.597827] Code: Unable to access opcode bytes at RIP 0x7f6634026293.
[ 1969.597828] RSP: 002b:00007ffca1011f48 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[ 1969.597831] RAX: ffffffffffffffda RBX: 000055f6720cf370 RCX: 00007f66340262bd
[ 1969.597833] RDX: 0000000000000000 RSI: 00007f6634b9880d RDI: 0000000000000006
[ 1969.597835] RBP: 00007f6634b9880d R08: 0000000000000000 R09: 00007ffca1012070
[ 1969.597836] R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
[ 1969.597838] R13: 000055f6720cce70 R14: 0000000000020000 R15: 0000000000000000
[ 1969.597859]
               Showing all locks held in the system:
[ 1969.597862] 2 locks held by kworker/0:0/5:
[ 1969.597863]  #0: ffff9af800194b38
((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1e6/0x5e0
[ 1969.597872]  #1: ffffbf3bc01f3e70
((kfence_timer).work){+.+.}-{0:0}, at: process_one_work+0x1e6/0x5e0
[ 1969.597890] 3 locks held by kworker/0:1/7:
[ 1969.597960] 1 lock held by khungtaskd/643:
[ 1969.597962]  #0: ffffffffa624cb60 (rcu_read_lock){....}-{1:2}, at:
rcu_lock_acquire.constprop.54+0x0/0x30
[ 1969.597982] 1 lock held by systemd-udevd/906:
[ 1969.597983]  #0: ffff9af984a1c218 (&dev->mutex){....}-{3:3}, at:
device_driver_attach+0x18/0x50

[ 1969.598010] =============================================

[ 1983.242512] random: fast init done
[ 2071.928411] sd 0:2:0:0: [sda] 1951399936 512-byte logical blocks:
(999 GB/931 GiB)
[ 2071.928480] sd 0:2:2:0: [sdc] 1756889088 512-byte logical blocks:
(900 GB/838 GiB)
[ 2071.928537] sd 0:2:1:0: [sdb] 285474816 512-byte logical blocks:
(146 GB/136 GiB)
[ 2071.928580] sd 0:2:0:0: [sda] Write Protect is off
[ 2071.928625] sd 0:2:0:0: [sda] Mode Sense: 1f 00 00 08
[ 2071.928629] sd 0:2:2:0: [sdc] Write Protect is off
[ 2071.928669] sd 0:2:1:0: [sdb] Write Protect is off
[ 2071.928706] sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
[ 2071.928844] sd 0:2:2:0: [sdc] Mode Sense: 1f 00 00 08
[ 2071.928848] sd 0:2:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA


================================

I am working on it and need some time for debugging. BTW did anyone
try "shared host tagset" patchset on some other adapter/s which are
not really multiqueue at HW level
but driver exposes multiple hardware queues(similar to megaraid_sas)
with the .config shared by Qian ?

Thanks,
Sumit

--0000000000009dd3a005b3752f07
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ql5FIoyTBHkZa1rWro6Bk4flpRMhijfSWuh6VhRFBVtOaVOIgbD40WmJ+X89nCWPOICJWbN5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUpzCt58hW
0WfI/g8raLWKyEI8BS0wDQYJKoZIhvcNAQELBQADggEBABn1D0HuSsCyUahUkmwTypjdinst+Z+S
4N5i6J49+CbquP1akYHRyf4Nd+F79uFZ42wiUHSnzifhaoecPU198OwVVGzru1s/xpRSYuoQAitN
wDioUOV/qKD32mNeLn7RthZ9BIlaWfk08+23Hpk934W/ZCJiGJdx6ueHnAnqSNBf3RLgknqrexNh
uUhYeznc3mlXj2g/lMjBSHKcYrBRlRwd8YalMCHZhPoNzKROm8YzvnaHvoqv4vDxTIsUrfXHnH/8
/UU/NrpeqcPjOcwiL+eFvfSpDBTFCZl/9unc09yTueVQr3LWJHZYf5jAmZU7nBB+5pNPCa6CF+lk
jNCOoNoxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DEcQs2KoBVoYjBv2pDANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg6lFYD5wJrkxH
9MUZQW5knuc1PuG2b71LXUkaegCSqb8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMTA2MTkyNjE0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFSr/S8jm64513HymrybVzDo6KZijIWu
s3wEyKolVYjU/8P7eB9k4EQifGBWBWXt3vE0rK9W2mr1hgJCDeoT0w7Tyt1GY3srKbKS79/kWv+k
LzizQxEZnJ8Towza40HNQ0gcQy12DGY2iw61SW4stHDk6U5n91ht8IYkfgMkUCbuRrHZN+u9bQim
hobugOrrKc6WVD3Xhoqm7LIEOeXNqnjFHM5J+4/XR7C2+s3/CYTVoEOWlp6QS+OrfQNVkbCuZDhH
zdZsGeIsFtZjrBT8EXAyUuI4ZIMLyptYefBBaraSzm1lS7X5OTMod3bBa2f2qyhi/PnG1FQEg5gj
8tf8reI=
--0000000000009dd3a005b3752f07--
