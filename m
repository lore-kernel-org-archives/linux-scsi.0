Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF27AC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 13:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiFJNPf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 09:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239847AbiFJNPe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 09:15:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1488962F2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 06:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654866929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eq/KcIGhfLYEFZAaboSIAIpzEGjta9is5s9WrEf2d44=;
        b=MAho/YUcwvW5cFfcmJ+iKSbdsglwV+j40LIc8VTxJU558EMuNk4EeMGMBmQOdSGLKgwRtK
        FqwJ1Rz09bdgeGPo1hqvYm4N02qvBwYFsd6DBEEPr+0GJe9d4eE21DWtR+AlH5VDn5hDvW
        HGlhou3vunCsjsrxaPTyA0tQRjVUCjs=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-FDuHHD_MODSfK6fUQ_2FFQ-1; Fri, 10 Jun 2022 09:15:28 -0400
X-MC-Unique: FDuHHD_MODSfK6fUQ_2FFQ-1
Received: by mail-pg1-f200.google.com with SMTP id w185-20020a6382c2000000b003fe372578c2so4038094pgd.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 06:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eq/KcIGhfLYEFZAaboSIAIpzEGjta9is5s9WrEf2d44=;
        b=vIMpp8mw2EIkyge7XDCrpgrJmOdpml3KeoPEk2wxt+tPqELQb6goKhmyrGfkU4xw2J
         D20zZN9ibfOk1jVZNxAEsvb8hdCniJ6ClywHN2K4mSD7huVRbjF/YJtRz7C+VtKe9JPV
         C3Mle32JPHvReHyQ/PrBAfLtMgemoFZeg986ZiFpNNX/YSwtTPQLmdSWXwBiL0gJtT6X
         LHrkRvl5VOVk8IhDmR9L/CWRS4eb/zcxhtpihbqZEw9VFls67v3xF1G45EYhuDbME/LY
         GRSd8m7Ef9unDtDqEpIMsmAaBYppc4YEADw/xcaRD06vu+8ZS+/5EU8J5PDJ9EclJ0eA
         44LQ==
X-Gm-Message-State: AOAM531LF7Xz0doT1AZjo6gGntxIMjF7FBIVr7c1xKW54PSBgenEerD+
        TgrK9rrHyisGH3YsRDbEFI7gEnQTHBUVN8HHFZQw+BxzJKISGNotMc552U59elPBR7CEb6r/oLR
        X6rzpkoUTt9YAcq/NoZcv3SxCqovnQWS6uAF5+A==
X-Received: by 2002:a17:902:7783:b0:167:8245:ea04 with SMTP id o3-20020a170902778300b001678245ea04mr24925170pll.95.1654866926129;
        Fri, 10 Jun 2022 06:15:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3CPyfbOOocNlDqH+bkmHUAS6rBIFxls5fwECM4kU4xbjXkpK/6UHYpYf62gaWn0zQxD5vAR4ZdFj1ecfoxSo=
X-Received: by 2002:a17:902:7783:b0:167:8245:ea04 with SMTP id
 o3-20020a170902778300b001678245ea04mr24925136pll.95.1654866925696; Fri, 10
 Jun 2022 06:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220609235329.4jbz4wr3eg2nmzqa@shindev> <717734c9-c633-fb48-499e-7e3e15113020@nvidia.com>
 <19d09611-42cc-5a81-d676-c5375865c14c@nvidia.com> <20220610122517.6pt5y63hcosk5mes@shindev>
In-Reply-To: <20220610122517.6pt5y63hcosk5mes@shindev>
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Fri, 10 Jun 2022 21:15:13 +0800
Message-ID: <CAHj4cs82j+_UbbDvMzcR8R_k3EovyZt2pAJwc6L8fUhq6EBWhA@mail.gmail.com>
Subject: Re: blktests failures with v5.19-rc1
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 10, 2022 at 8:26 PM Shinichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> On Jun 10, 2022 / 09:32, Chaitanya Kulkarni wrote:
> > Shinichiro,
> >
> > >
> > >> #6: nvme/032: Failed at the first run after system reboot.
> > >>                 Used QEMU NVME device as TEST_DEV.
> > >>
> >
> > ofcourse we need to fix this issue but can you also
> > try it with the real H/W ?
>
> Hi Chaitanya, thank you for looking into the failures. I have just run the test
> case nvme/032 with real NVME device and observed the exactly same symptom as
> QEMU NVME device.
>
> FYI, here I quote the kernel WARNING with the real HW.

I also reproduced this issue recently with NVMe disk:

[  702.253121] run blktests nvme/032 at 2022-06-07 02:52:26
[  707.422212] pcieport 0000:40:03.1: bridge window [io
0x1000-0x0fff] to [bus 42] add_size 1000
[  707.422266] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  707.422271] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  707.422326] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  707.422328] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  708.164329] run blktests nvme/032 at 2022-06-07 02:52:32
[  713.565934] nvme nvme1: Shutdown timeout set to 16 seconds
[  713.675800] nvme nvme1: 16/0/0 default/read/poll queues

[  714.661347] ======================================================
[  714.661349] WARNING: possible circular locking dependency detected
[  714.661351] 5.19.0-rc1+ #1 Not tainted
[  714.661355] ------------------------------------------------------
[  714.661356] check/2028 is trying to acquire lock:
[  714.661359] ffff888106c270e8 (kn->active#378){++++}-{0:0}, at:
kernfs_remove_by_name_ns+0x96/0xe0
[  714.661379]
               but task is already holding lock:
[  714.661380] ffffffff89c6f010 (pci_rescan_remove_lock){+.+.}-{3:3},
at: pci_stop_and_remove_bus_device_locked+0xe/0x30
[  714.661392]
               which lock already depends on the new lock.

[  714.661393]
               the existing dependency chain (in reverse order) is:
[  714.661395]
               -> #1 (pci_rescan_remove_lock){+.+.}-{3:3}:
[  714.661402]        lock_acquire+0x1d2/0x600
[  714.661407]        __mutex_lock+0x14c/0x2350
[  714.661413]        dev_rescan_store+0xb1/0xf0
[  714.661417]        kernfs_fop_write_iter+0x2d3/0x490
[  714.661422]        new_sync_write+0x33d/0x550
[  714.661427]        vfs_write+0x617/0x910
[  714.661431]        ksys_write+0xf1/0x1c0
[  714.661435]        do_syscall_64+0x3a/0x80
[  714.661440]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  714.661444]
               -> #0 (kn->active#378){++++}-{0:0}:
[  714.661451]        check_prevs_add+0x3fd/0x2960
[  714.661455]        __lock_acquire+0x2c87/0x3f40
[  714.661459]        lock_acquire+0x1d2/0x600
[  714.661462]        __kernfs_remove+0x68f/0x880
[  714.661466]        kernfs_remove_by_name_ns+0x96/0xe0
[  714.661470]        remove_files.isra.1+0x6c/0x170
[  714.661474]        sysfs_remove_group+0x9b/0x170
[  714.661478]        sysfs_remove_groups+0x4f/0x90
[  714.661482]        device_remove_attrs+0x1ae/0x260
[  714.661488]        device_del+0x542/0xd10
[  714.661491]        pci_remove_bus_device+0x132/0x350
[  714.661494]        pci_stop_and_remove_bus_device_locked+0x1e/0x30
[  714.661499]        remove_store+0xca/0xe0
[  714.661503]        kernfs_fop_write_iter+0x2d3/0x490
[  714.661507]        new_sync_write+0x33d/0x550
[  714.661510]        vfs_write+0x617/0x910
[  714.661514]        ksys_write+0xf1/0x1c0
[  714.661518]        do_syscall_64+0x3a/0x80
[  714.661522]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  714.661526]
               other info that might help us debug this:

[  714.661528]  Possible unsafe locking scenario:

[  714.661529]        CPU0                    CPU1
[  714.661530]        ----                    ----
[  714.661531]   lock(pci_rescan_remove_lock);
[  714.661534]                                lock(kn->active#378);
[  714.661538]                                lock(pci_rescan_remove_lock);
[  714.661541]   lock(kn->active#378);
[  714.661544]
                *** DEADLOCK ***

[  714.661545] 3 locks held by check/2028:
[  714.661548]  #0: ffff888268b1c470 (sb_writers#4){.+.+}-{0:0}, at:
ksys_write+0xf1/0x1c0
[  714.661559]  #1: ffff88826b9b6490 (&of->mutex){+.+.}-{3:3}, at:
kernfs_fop_write_iter+0x220/0x490
[  714.661567]  #2: ffffffff89c6f010
(pci_rescan_remove_lock){+.+.}-{3:3}, at:
pci_stop_and_remove_bus_device_locked+0xe/0x30
[  714.661577]
               stack backtrace:
[  714.661579] CPU: 10 PID: 2028 Comm: check Kdump: loaded Not tainted
5.19.0-rc1+ #1
[  714.661584] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS
2.3.6 07/06/2021
[  714.661587] Call Trace:
[  714.661589]  <TASK>
[  714.661592]  dump_stack_lvl+0x44/0x57
[  714.661600]  check_noncircular+0x280/0x320
[  714.661606]  ? print_circular_bug.isra.44+0x430/0x430
[  714.661613]  ? mark_lock.part.49+0xa44/0x2370
[  714.661621]  ? lock_chain_count+0x20/0x20
[  714.661629]  check_prevs_add+0x3fd/0x2960
[  714.661636]  ? sched_clock_cpu+0x69/0x2e0
[  714.661641]  ? mark_lock.part.49+0x107/0x2370
[  714.661646]  ? check_irq_usage+0xe30/0xe30
[  714.661652]  ? sched_clock_cpu+0x69/0x2e0
[  714.661655]  ? sched_clock_cpu+0x69/0x2e0
[  714.661660]  __lock_acquire+0x2c87/0x3f40
[  714.661668]  ? lockdep_hardirqs_on_prepare+0x400/0x400
[  714.661672]  ? rcu_read_lock_sched_held+0xaf/0xe0
[  714.661679]  lock_acquire+0x1d2/0x600
[  714.661682]  ? kernfs_remove_by_name_ns+0x96/0xe0
[  714.661686]  ? rcu_read_lock_sched_held+0xaf/0xe0
[  714.661689]  ? rcu_read_unlock+0x50/0x50
[  714.661692]  ? rcu_read_lock_bh_held+0xc0/0xc0
[  714.661697]  ? up_write+0x15c/0x490
[  714.661702]  __kernfs_remove+0x68f/0x880
[  714.661704]  ? kernfs_remove_by_name_ns+0x96/0xe0
[  714.661711]  ? kernfs_fop_readdir+0x8c0/0x8c0
[  714.661714]  ? lock_is_held_type+0xd9/0x130
[  714.661718]  ? kernfs_name_hash+0x18/0xc0
[  714.661724]  kernfs_remove_by_name_ns+0x96/0xe0
[  714.661728]  remove_files.isra.1+0x6c/0x170
[  714.661733]  sysfs_remove_group+0x9b/0x170
[  714.661737]  sysfs_remove_groups+0x4f/0x90
[  714.661742]  device_remove_attrs+0x1ae/0x260
[  714.661746]  ? device_remove_file+0x20/0x20
[  714.661749]  ? up_write+0x15c/0x490
[  714.661755]  device_del+0x542/0xd10
[  714.661759]  ? __device_link_del+0x340/0x340
[  714.661765]  pci_remove_bus_device+0x132/0x350
[  714.661770]  pci_stop_and_remove_bus_device_locked+0x1e/0x30
[  714.661774]  remove_store+0xca/0xe0
[  714.661777]  ? subordinate_bus_number_show+0xc0/0xc0
[  714.661783]  ? sysfs_kf_write+0x3b/0x180
[  714.661787]  kernfs_fop_write_iter+0x2d3/0x490
[  714.661793]  new_sync_write+0x33d/0x550
[  714.661798]  ? new_sync_read+0x540/0x540
[  714.661806]  ? lock_is_held_type+0xd9/0x130
[  714.661813]  ? rcu_read_lock_held+0xc0/0xc0
[  714.661820]  vfs_write+0x617/0x910
[  714.661825]  ksys_write+0xf1/0x1c0
[  714.661829]  ? __ia32_sys_read+0xb0/0xb0
[  714.661832]  ? syscall_trace_enter.isra.15+0x175/0x250
[  714.661840]  do_syscall_64+0x3a/0x80
[  714.661844]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  714.661847] RIP: 0033:0x7f0b88120868
[  714.661852] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00
00 00 f3 0f 1e fa 48 8d 05 35 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89
d4 55
[  714.661855] RSP: 002b:00007fff0fceca28 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[  714.661858] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f0b88120868
[  714.661861] RDX: 0000000000000002 RSI: 000056501fc5ec60 RDI: 0000000000000001
[  714.661862] RBP: 000056501fc5ec60 R08: 000000000000000a R09: 00007f0b88180ac0
[  714.661864] R10: 000000000000000a R11: 0000000000000246 R12: 00007f0b883c16e0
[  714.661866] R13: 0000000000000002 R14: 00007f0b883bc880 R15: 0000000000000002
[  714.661873]  </TASK>
[  714.666060] pci 0000:44:00.0: Removing from iommu group 33
[  714.670580] pci 0000:44:00.0: [1e0f:0007] type 00 class 0x010802
[  714.670613] pci 0000:44:00.0: reg 0x10: [mem 0xa4900000-0xa4907fff 64bit]
[  714.776556] pci 0000:44:00.0: 31.504 Gb/s available PCIe bandwidth,
limited by 8.0 GT/s PCIe x4 link at 0000:40:03.3 (capable of 63.012
Gb/s with 16.0 GT/s PCIe x4 link)
[  714.802476] pci 0000:44:00.0: Adding to iommu group 33
[  714.802862] pcieport 0000:40:03.1: bridge window [io
0x1000-0x0fff] to [bus 42] add_size 1000
[  714.802900] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  714.802904] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  714.802939] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  714.802942] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  714.802977] pci 0000:44:00.0: BAR 0: assigned [mem
0xa4900000-0xa4907fff 64bit]
[  714.814760] nvme nvme1: pci function 0000:44:00.0
[  715.092766] nvme nvme1: Shutdown timeout set to 16 seconds
[  715.192803] nvme nvme1: 16/0/0 default/read/poll queues
[  715.238378]  nvme1n1: p1
[  722.202125] run blktests nvme/032 at 2022-06-07 02:52:46
[  727.840536] nvme nvme2: 16/0/0 default/read/poll queues
[  729.262229] pci 0000:45:00.0: Removing from iommu group 34
[  729.287030] pci 0000:45:00.0: [8086:0b60] type 00 class 0x010802
[  729.287059] pci 0000:45:00.0: reg 0x10: [mem 0xa4800000-0xa4803fff 64bit]
[  729.501326] pci 0000:45:00.0: 31.504 Gb/s available PCIe bandwidth,
limited by 8.0 GT/s PCIe x4 link at 0000:40:03.4 (capable of 63.012
Gb/s with 16.0 GT/s PCIe x4 link)
[  729.638560] pci 0000:45:00.0: Adding to iommu group 34
[  729.639120] pcieport 0000:40:03.1: bridge window [io
0x1000-0x0fff] to [bus 42] add_size 1000
[  729.639163] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  729.639167] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  729.639217] pcieport 0000:40:03.1: BAR 13: no space for [io  size 0x1000]
[  729.639219] pcieport 0000:40:03.1: BAR 13: failed to assign [io  size 0x1000]
[  729.639942] pci 0000:45:00.0: BAR 0: assigned [mem
0xa4800000-0xa4803fff 64bit]
[  729.746063] nvme nvme2: pci function 0000:45:00.0
[  729.839525] nvme nvme2: 16/0/0 default/read/poll queues
[  729.883784]  nvme2n1: p1

>
> [  170.567809] run blktests nvme/032 at 2022-06-10 21:19:03
> [  175.771062] nvme nvme0: 8/0/0 default/read/poll queues
>
> [  176.017635] ======================================================
> [  176.017637] WARNING: possible circular locking dependency detected
> [  176.017639] 5.19.0-rc1+ #1 Not tainted
> [  176.017643] ------------------------------------------------------
> [  176.017645] check/1147 is trying to acquire lock:
> [  176.017651] ffff888107010cb8 (kn->active#256){++++}-{0:0}, at: kernfs_remove_by_name_ns+0x90/0xe0
> [  176.017683]
>                but task is already holding lock:
> [  176.017685] ffffffff859bbcc8 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_stop_and_remove_bus_device_locked+0xe/0x30
> [  176.017701]
>                which lock already depends on the new lock.
>
> [  176.017702]
>                the existing dependency chain (in reverse order) is:
> [  176.017704]
>                -> #1 (pci_rescan_remove_lock){+.+.}-{3:3}:
> [  176.017712]        __mutex_lock+0x14c/0x12b0
> [  176.017720]        dev_rescan_store+0x93/0xd0
> [  176.017727]        kernfs_fop_write_iter+0x351/0x520
> [  176.017732]        new_sync_write+0x2cd/0x500
> [  176.017737]        vfs_write+0x62c/0x980
> [  176.017742]        ksys_write+0xe7/0x1a0
> [  176.017746]        do_syscall_64+0x3a/0x80
> [  176.017755]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  176.017762]
>                -> #0 (kn->active#256){++++}-{0:0}:
> [  176.017770]        __lock_acquire+0x2874/0x5510
> [  176.017778]        lock_acquire+0x194/0x4f0
> [  176.017782]        __kernfs_remove+0x6f2/0x910
> [  176.017786]        kernfs_remove_by_name_ns+0x90/0xe0
> [  176.017791]        remove_files+0x8c/0x1a0
> [  176.017797]        sysfs_remove_group+0x77/0x150
> [  176.017802]        sysfs_remove_groups+0x4f/0x90
> [  176.017807]        device_remove_attrs+0x19e/0x240
> [  176.017812]        device_del+0x492/0xb60
> [  176.017816]        pci_remove_bus_device+0x12c/0x350
> [  176.017821]        pci_stop_and_remove_bus_device_locked+0x1e/0x30
> [  176.017826]        remove_store+0xab/0xc0
> [  176.017831]        kernfs_fop_write_iter+0x351/0x520
> [  176.017836]        new_sync_write+0x2cd/0x500
> [  176.017839]        vfs_write+0x62c/0x980
> [  176.017844]        ksys_write+0xe7/0x1a0
> [  176.017848]        do_syscall_64+0x3a/0x80
> [  176.017854]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  176.017861]
>                other info that might help us debug this:
>
> [  176.017862]  Possible unsafe locking scenario:
>
> [  176.017864]        CPU0                    CPU1
> [  176.017865]        ----                    ----
> [  176.017866]   lock(pci_rescan_remove_lock);
> [  176.017870]                                lock(kn->active#256);
> [  176.017875]                                lock(pci_rescan_remove_lock);
> [  176.017879]   lock(kn->active#256);
> [  176.017883]
>                 *** DEADLOCK ***
>
> [  176.017884] 3 locks held by check/1147:
> [  176.017888]  #0: ffff888119ad8460 (sb_writers#3){.+.+}-{0:0}, at: ksys_write+0xe7/0x1a0
> [  176.017902]  #1: ffff8881241b1888 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x215/0x520
> [  176.017914]  #2: ffffffff859bbcc8 (pci_rescan_remove_lock){+.+.}-{3:3}, at: pci_stop_and_remove_bus_device_locked+0xe/0x30
> [  176.017927]
>                stack backtrace:
> [  176.017929] CPU: 7 PID: 1147 Comm: check Not tainted 5.19.0-rc1+ #1
> [  176.017935] Hardware name: Supermicro Super Server/X10SRL-F, BIOS 3.2 11/22/2019
> [  176.017938] Call Trace:
> [  176.017941]  <TASK>
> [  176.017945]  dump_stack_lvl+0x5b/0x73
> [  176.017953]  check_noncircular+0x23e/0x2e0
> [  176.017959]  ? lock_chain_count+0x20/0x20
> [  176.017966]  ? print_circular_bug+0x1e0/0x1e0
> [  176.017973]  ? mark_lock+0xee/0x1600
> [  176.017983]  ? lockdep_lock+0xb8/0x1a0
> [  176.017989]  ? call_rcu_zapped+0xb0/0xb0
> [  176.017997]  __lock_acquire+0x2874/0x5510
> [  176.018012]  ? lockdep_hardirqs_on_prepare+0x410/0x410
> [  176.018023]  lock_acquire+0x194/0x4f0
> [  176.018029]  ? kernfs_remove_by_name_ns+0x90/0xe0
> [  176.018037]  ? lock_downgrade+0x6b0/0x6b0
> [  176.018048]  ? up_write+0x14d/0x460
> [  176.018055]  __kernfs_remove+0x6f2/0x910
> [  176.018060]  ? kernfs_remove_by_name_ns+0x90/0xe0
> [  176.018071]  ? kernfs_next_descendant_post+0x280/0x280
> [  176.018078]  ? lock_is_held_type+0xe3/0x140
> [  176.018085]  ? kernfs_name_hash+0x16/0xc0
> [  176.018092]  ? kernfs_find_ns+0x1e3/0x320
> [  176.018100]  kernfs_remove_by_name_ns+0x90/0xe0
> [  176.018107]  remove_files+0x8c/0x1a0
> [  176.018115]  sysfs_remove_group+0x77/0x150
> [  176.018123]  sysfs_remove_groups+0x4f/0x90
> [  176.018131]  device_remove_attrs+0x19e/0x240
> [  176.018137]  ? device_remove_file+0x20/0x20
> [  176.018146]  device_del+0x492/0xb60
> [  176.018154]  ? __device_link_del+0x350/0x350
> [  176.018159]  ? kfree+0xc5/0x340
> [  176.018171]  pci_remove_bus_device+0x12c/0x350
> [  176.018179]  pci_stop_and_remove_bus_device_locked+0x1e/0x30
> [  176.018186]  remove_store+0xab/0xc0
> [  176.018192]  ? subordinate_bus_number_show+0xa0/0xa0
> [  176.018199]  ? sysfs_kf_write+0x3d/0x170
> [  176.018207]  kernfs_fop_write_iter+0x351/0x520
> [  176.018216]  new_sync_write+0x2cd/0x500
> [  176.018223]  ? new_sync_read+0x500/0x500
> [  176.018230]  ? perf_callchain_user+0x810/0xa90
> [  176.018238]  ? lock_downgrade+0x6b0/0x6b0
> [  176.018244]  ? inode_security+0x54/0xf0
> [  176.018254]  ? lock_is_held_type+0xe3/0x140
> [  176.018264]  vfs_write+0x62c/0x980
> [  176.018273]  ksys_write+0xe7/0x1a0
> [  176.018279]  ? __ia32_sys_read+0xa0/0xa0
> [  176.018285]  ? syscall_enter_from_user_mode+0x20/0x70
> [  176.018294]  do_syscall_64+0x3a/0x80
> [  176.018303]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> [  176.018310] RIP: 0033:0x7fd59a901c17
> [  176.018317] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
> [  176.018322] RSP: 002b:00007fffe29bbe98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [  176.018328] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fd59a901c17
> [  176.018333] RDX: 0000000000000002 RSI: 0000555e68a93c20 RDI: 0000000000000001
> [  176.018336] RBP: 0000555e68a93c20 R08: 0000000000000000 R09: 0000000000000073
> [  176.018339] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> [  176.018342] R13: 00007fd59a9f8780 R14: 0000000000000002 R15: 00007fd59a9f39e0
> [  176.018356]  </TASK>
> [  176.057966] pci 0000:04:00.0: [15b7:5002] type 00 class 0x010802
> [  176.058006] pci 0000:04:00.0: reg 0x10: [mem 0xfb600000-0xfb603fff 64bit]
> [  176.058059] pci 0000:04:00.0: reg 0x20: [mem 0xfb604000-0xfb6040ff 64bit]
> [  176.060129] pci 0000:04:00.0: BAR 0: assigned [mem 0xfb600000-0xfb603fff 64bit]
> [  176.060152] pci 0000:04:00.0: BAR 4: assigned [mem 0xfb604000-0xfb6040ff 64bit]
> [  176.061638] nvme nvme0: pci function 0000:04:00.0
> [  176.074114] nvme nvme0: 8/0/0 default/read/poll queues
>
> --
> Shin'ichiro Kawasaki
>


-- 
Best Regards,
  Yi Zhang

