Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C16EE49A0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Aug 2023 03:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjHWDTA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 23:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjHWDS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 23:18:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D25CD6
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 20:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692760689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gPPC+4I80FZSXByCGFoIo8BosdPQoyHkCmUbzTAsc+g=;
        b=YwzZBwbEPz0KGYeIwdk0fGBLi/FcQLaqNnXmDXjttt1XnVASzzgApHgwV6jjSaPM3Lu4/n
        QbBrLbmLL1WMUCn6PJxEEBMIUAll/sKU3RS8W73f5ll/deJpLKeyuSjRIA8nrmzjKxt+8F
        njH2V6QqGhYGEGi3279WMFZvgALALbs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-mtvJBpj5OJSiq1104KCPNQ-1; Tue, 22 Aug 2023 23:18:08 -0400
X-MC-Unique: mtvJBpj5OJSiq1104KCPNQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-76dbe1865c1so34875685a.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 20:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692760687; x=1693365487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPPC+4I80FZSXByCGFoIo8BosdPQoyHkCmUbzTAsc+g=;
        b=APdFlQomFyGbffEe7a/fmEper0BSi8hzvmAHsrRiR/6RQlZadXHk815R1/hHSAR+EJ
         25OiyLsftgTym7Vab6/7D+Sr3Q2w2GaQ7olvHjqLPTTRj1lw0HXqOHFgKs4/4OlEj462
         GllY7F7gPhb7xgb9Obutjr9USw/MZZfrVJDxBZuapX3gijCMt00MPV0jLBmgVQ/cW3z/
         SUeIRhkHT8oSReWjRoRN2OdUa6SNQTAjwCtQoJQRoJrWNAJC+H/6uN2trKz7wrHY8tMd
         xaz8JmtGFxyFRyYYjkiebtieD+MckG0EeCq7UewHJaPQ8OxgCc2hgKObf1I8mB+5J/2h
         DO+w==
X-Gm-Message-State: AOJu0YzHTQgFEFWIcCo+uxjVGZxhUy05zgTNnVaWEnVOcZnOYAcV/4Fd
        F9XTtSSa6tgyKfvlVr8gzjjdX8PHdOBz0SrJfoLPRaIAnA/UWexUewL6+qnEko8aiz3XwuQPpVL
        /ZNpxmYOx1cvEu3F76f1w0XxGV7p5l6I5w29DmjNyJd4GJFkuPJE=
X-Received: by 2002:a05:620a:25cc:b0:76d:b119:c60d with SMTP id y12-20020a05620a25cc00b0076db119c60dmr4512203qko.36.1692760687177;
        Tue, 22 Aug 2023 20:18:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYmRWw6op0HNd8qKTWWwC00NQ5oB8oIdloDee6KsYAPr9LOXh6d04EPiKHcUijlz3qcyJjGFwMSqfISYxpLTA=
X-Received: by 2002:a05:620a:25cc:b0:76d:b119:c60d with SMTP id
 y12-20020a05620a25cc00b0076db119c60dmr4512188qko.36.1692760686914; Tue, 22
 Aug 2023 20:18:06 -0700 (PDT)
MIME-Version: 1.0
From:   Changhui Zhong <czhong@redhat.com>
Date:   Wed, 23 Aug 2023 11:17:55 +0800
Message-ID: <CAGVVp+W0gP38YMCPyaepmSLjeHLDOP7hkfsvuiaRXtn19JBqTA@mail.gmail.com>
Subject: [bug report] WARNING: CPU: 121 PID: 93233 at fs/dcache.c:365 __dentry_kill+0x214/0x278
To:     linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

triggered below warning issue with branch
"
Tree: mainline.kernel.org-clang
Repository: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.=
git
@ master
Commit Hash: 89bf6209cad66214d3774dac86b6bbf2aec6a30d
Commit Name: v6.5-rc7-18-g89bf6209cad6
Kernel information:
Commit message: Merge tag 'devicetree-fixes-for-6.5-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
"
for more detail=EF=BC=8Cplease check
https://datawarehouse.cki-project.org/kcidb/tests/9232643

#modprobe scsi_debug virtual_gb=3D128
#echo none > /sys/block/sdb/queue/scheduler
#fio --bs=3D4k --ioengine=3Dlibaio --iodepth=3D1 --numjobs=3D4 --rw=3Drandr=
w
--name=3Dsdb-libaio-randrw-4k --filename=3D/dev/sdb --direct=3D1 --size=3D6=
0G
--runtime=3D60

[ 3056.092761] Device: sdb  Engine: libaio Sched: none Pattern: randrw
 Direct: 1 Depth: 1  Block size: 4K Size: 60G
[ 3117.055168] ------------[ cut here ]------------
[ 3117.059778] WARNING: CPU: 121 PID: 93233 at fs/dcache.c:365
__dentry_kill+0x214/0x278
[ 3117.067601] Modules linked in: scsi_debug nvme nvme_core
nvme_common null_blk pktcdvd ipmi_watchdog ipmi_poweroff rfkill sunrpc
vfat fat acpi_ipmi ipmi_ssif arm_spe_pmu igb ipmi_devintf
ipmi_msghandler arm_cmn arm_dmc620_pmu cppc_cpufreq arm_dsu_pmu
acpi_tad loop fuse zram xfs crct10dif_ce polyval_ce polyval_generic
ghash_ce sbsa_gwdt ast onboard_usb_hub i2c_algo_bit xgene_hwmon [last
unloaded: scsi_debug]
[ 3117.103572] CPU: 121 PID: 93233 Comm: bash Not tainted 6.5.0-rc7 #1
[ 3117.109827] Hardware name: GIGABYTE R152-P31-00/MP32-AR1-00, BIOS
F31n (SCP: 2.10.20220810) 09/30/2022
[ 3117.119119] pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[ 3117.126068] pc : __dentry_kill+0x214/0x278
[ 3117.130152] lr : __dentry_kill+0x194/0x278
[ 3117.134236] sp : ffff800084993870
[ 3117.137537] x29: ffff800084993870 x28: ffff0800830e2200 x27: 00000000000=
80400
[ 3117.144661] x26: 00000000fff7fbff x25: 0000000000000001 x24: ffff07ff884=
73198
[ 3117.151783] x23: ffff07ff884731c0 x22: ffff07ff9d033c80 x21: ffff07ff884=
731d0
[ 3117.158906] x20: ffff07ff88473198 x19: ffff07ff88473140 x18: ffffbc0d073=
9ceb4
[ 3117.166028] x17: 0000000000000000 x16: ffffbc0d073528c0 x15: ffff07ff89c=
761f8
[ 3117.173151] x14: 0000000000000002 x13: 0000000000000000 x12: 00000000000=
00001
[ 3117.180273] x11: ffff080f33fe0850 x10: ffffffffffffffff x9 : 00000001000=
00000
[ 3117.187395] x8 : ffffbc0d08aa1e98 x7 : 0000000000000000 x6 : 00000000000=
0003f
[ 3117.194518] x5 : ffff800084993a30 x4 : ffff800084993908 x3 : ffff07ff9cb=
7e210
[ 3117.201640] x2 : ffff07ff884731d0 x1 : 0000000000000000 x0 : ffff07ff884=
731f0
[ 3117.208763] Call trace:
[ 3117.211197]  __dentry_kill+0x214/0x278
[ 3117.214934]  shrink_dentry_list+0x134/0x2b0
[ 3117.219105]  prune_dcache_sb+0x64/0xa0
[ 3117.222842]  super_cache_scan+0x144/0x198
[ 3117.226841]  do_shrink_slab+0x1dc/0x420
[ 3117.230666]  shrink_slab+0x114/0x388
[ 3117.234229]  drop_slab+0xb0/0x118
[ 3117.237532]  drop_caches_sysctl_handler+0xac/0x170
[ 3117.242313]  proc_sys_call_handler+0x184/0x2d0
[ 3117.246745]  proc_sys_write+0x20/0x38
[ 3117.250396]  vfs_write+0x24c/0x368
[ 3117.253786]  ksys_write+0x84/0xf8
[ 3117.257089]  __arm64_sys_write+0x28/0x40
[ 3117.261000]  invoke_syscall+0x78/0x110
[ 3117.264739]  el0_svc_common+0xc0/0xf8
[ 3117.268390]  do_el0_svc+0x3c/0xb8
[ 3117.271693]  el0_svc+0x34/0x110
[ 3117.274825]  el0t_64_sync_handler+0x84/0x100
[ 3117.279083]  el0t_64_sync+0x194/0x198
[ 3117.282733] ---[ end trace 0000000000000000 ]---
[ 3119.372909] Device: sdb  Engine: libaio Sched: none Pattern: randrw
 Direct: 1 Depth: 1  Block size: 16K Size: 60G
[ 3144.068984] watchdog: BUG: soft lockup - CPU#97 stuck for 26s! [fio:9377=
7]
[ 3144.069984] watchdog: BUG: soft lockup - CPU#99 stuck for 26s!
[systemd-udevd:1680]
[ 3144.075849] Modules linked in: scsi_debug nvme
[ 3144.083493] Modules linked in:
[ 3144.087924]  nvme_core nvme_common null_blk pktcdvd
[ 3144.090967]  scsi_debug
[ 3144.090968]  ipmi_watchdog ipmi_poweroff rfkill
[ 3144.098267]  nvme
[ 3144.098267]  sunrpc vfat fat
[ 3144.102785]  nvme_core
[ 3144.104698]  acpi_ipmi
[ 3144.107566]  nvme_common
[ 3144.109912]  ipmi_ssif
[ 3144.112259]  null_blk
[ 3144.114779]  arm_spe_pmu
[ 3144.117126]  pktcdvd
[ 3144.119385]  igb ipmi_devintf
[ 3144.121905]  ipmi_watchdog
[ 3144.124078]  ipmi_msghandler
[ 3144.127033]  ipmi_poweroff
[ 3144.129728]  arm_cmn
[ 3144.132596]  rfkill
[ 3144.135289]  arm_dmc620_pmu
[ 3144.137462]  sunrpc
[ 3144.139548]  cppc_cpufreq
[ 3144.142329]  vfat
[ 3144.144415]  arm_dsu_pmu
[ 3144.147022]  fat
[ 3144.148934]  acpi_tad loop
[ 3144.151455]  acpi_ipmi
[ 3144.153280]  fuse
[ 3144.155974]  ipmi_ssif
[ 3144.158320]  zram
[ 3144.160233]  arm_spe_pmu
[ 3144.162579]  xfs
[ 3144.164493]  igb
[ 3144.167012]  crct10dif_ce
[ 3144.168838]  ipmi_devintf
[ 3144.170664]  polyval_ce
[ 3144.173271]  ipmi_msghandler
[ 3144.175877]  polyval_generic
[ 3144.178312]  arm_cmn
[ 3144.181178]  ghash_ce
[ 3144.184047]  arm_dmc620_pmu
[ 3144.186219]  sbsa_gwdt
[ 3144.188479]  cppc_cpufreq
[ 3144.191259]  ast
[ 3144.193606]  arm_dsu_pmu
[ 3144.196213]  onboard_usb_hub
[ 3144.198039]  acpi_tad
[ 3144.200559]  i2c_algo_bit
[ 3144.203427]  loop
[ 3144.205686]  xgene_hwmon
[ 3144.208294]  fuse
[ 3144.210206]  [last unloaded: scsi_debug]
[ 3144.212726]  zram
[ 3144.214638]
[ 3144.214640] CPU: 97 PID: 93777 Comm: fio Tainted: G        W
  6.5.0-rc7 #1
[ 3144.218548]  xfs
[ 3144.220459] Hardware name: GIGABYTE R152-P31-00/MP32-AR1-00, BIOS
F31n (SCP: 2.10.20220810) 09/30/2022
[ 3144.221939]  crct10dif_ce
[ 3144.229493] pstate: 00400009 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[ 3144.231320]  polyval_ce
[ 3144.240610] pc : d_alloc_parallel+0x204/0x520
[ 3144.243218]  polyval_generic
[ 3144.250164] lr : d_alloc_parallel+0x128/0x520
[ 3144.252598]  ghash_ce
[ 3144.256940] sp : ffff800083ecb860
[ 3144.259809]  sbsa_gwdt
[ 3144.264151] x29: ffff800083ecb8b0
[ 3144.266411]  ast
[ 3144.269712]  x28: 00000000e28e44d4
[ 3144.272059]  onboard_usb_hub
[ 3144.275360]  x27: ffff0800c7e6c400
[ 3144.277186]  i2c_algo_bit
[ 3144.280574]
[ 3144.280575] x26: ffff07ff9dfb48d0
[ 3144.283442]  xgene_hwmon
[ 3144.286830]  x25: 0000000000011b30
[ 3144.289437]  [last unloaded: scsi_debug]
[ 3144.290915]  x24: ffff07ffe89be298
[ 3144.294217]
[ 3144.296737]
[ 3144.296738] x23: ffff07ffe89be240
[ 3144.300126] CPU: 99 PID: 1680 Comm: systemd-udevd Tainted: G
W          6.5.0-rc7 #1
[ 3144.304034]  x22: ffff800083ecba20 x21: ffffbc0d084e9000
[ 3144.307424] Hardware name: GIGABYTE R152-P31-00/MP32-AR1-00, BIOS
F31n (SCP: 2.10.20220810) 09/30/2022
[ 3144.308902]
[ 3144.308903] x20: ffffbc0d08aa1e98
[ 3144.310381] pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[ 3144.313682]  x19: ffff07ff9eeac918 x18: 00000000fffffffb
[ 3144.322019] pc : d_alloc_parallel+0x17c/0x520
[ 3144.327316]
[ 3144.327317] x17: ffff07ff93f1c021
[ 3144.336608] lr : d_alloc_parallel+0x128/0x520
[ 3144.338086]  x16: 636f6c622f000000 x15: fefefefeff727372
[ 3144.341388] sp : ffff8000844ab9b0
[ 3144.348335]
[ 3144.348336] x14: fefefefeff7b7b7b
[ 3144.353634] x29: ffff8000844aba00
[ 3144.357976]  x13: 0000000000000000 x12: 00000000e28e44d4
[ 3144.359456]  x28: 00000000e777e234
[ 3144.362757]
[ 3144.362757] x11: ffff080f32b00000
[ 3144.367100]  x27: ffff07ff96888000
[ 3144.372398]  x10: 0000000000000000 x9 : ffff07ff93f1c037
[ 3144.375700]
[ 3144.377178]
[ 3144.377179] x8 : 0000000000000000
[ 3144.380480] x26: ffff07ff9de47890
[ 3144.383781]  x7 : 7374736575716572
[ 3144.389080]  x25: 0000000000011b30
[ 3144.392467]  x6 : 65757165725f726e
[ 3144.393947]  x24: ffff07ff88faf618
[ 3144.397248]
[ 3144.397249] x5 : ffff07ff9dfb4883
[ 3144.400637]
[ 3144.405934]  x4 : ffff07ff93f1c042
[ 3144.407414] x23: ffff07ff88faf5c0
[ 3144.408892]  x3 : ffff07ff9dfb4bd0
[ 3144.412193]  x22: ffff8000844abb30
[ 3144.415494]
[ 3144.415495] x2 : ffff800083ecb87c
[ 3144.418883]  x21: ffffbc0d084e9000
[ 3144.422271]  x1 : ffff800083ecba20 x0 : 0000000000000000
[ 3144.425660]
[ 3144.429048]
[ 3144.429049] Call trace:
[ 3144.430527] x20: ffffbc0d08aa1e98
[ 3144.433828]  d_alloc_parallel+0x204/0x520
[ 3144.435307]  x19: 00000000000000e8
[ 3144.438695]  __lookup_slow+0x6c/0x158
[ 3144.441997]  x18: 00000000fffffffb
[ 3144.445385]  lookup_slow+0x4c/0x78
[ 3144.448774]
[ 3144.450252]  walk_component+0x10c/0x128
[ 3144.453553] x17: ffff07ff9400a021
[ 3144.456941]  path_lookupat+0x60/0x140
[ 3144.462240]  x16: 697665642f000000
[ 3144.463718]  filename_lookup+0xd8/0x1d0
[ 3144.465197]  x15: 722e6a626e6b612e
[ 3144.467629]  vfs_statx+0x90/0x220
[ 3144.470932]
[ 3144.474927]  __arm64_sys_newfstatat+0xa0/0x100
[ 3144.478316] x14: 7aff6b6b7f6b6bff
[ 3144.481964]  invoke_syscall+0x78/0x110
[ 3144.485353]  x13: 0000000000000000
[ 3144.488741]  el0_svc_common+0xc0/0xf8
[ 3144.490219]  x12: 00000000e777e234
[ 3144.494041]  do_el0_svc+0x3c/0xb8
[ 3144.497343]
[ 3144.500991]  el0_svc+0x34/0x110
[ 3144.504380] x11: ffff080f32b00000
[ 3144.508201]  el0t_64_sync_handler+0x84/0x100
[ 3144.511590]  x10: 0000000000000000
[ 3144.514891]  el0t_64_sync+0x194/0x198
[ 3144.516370]  x9 : ffff07ff9400a06b
[ 3144.564153] x8 : ffff07ff884731f1 x7 : 25732500716d016b x6 : 00000000327=
57063
[ 3144.571280] x5 : ffff07ff9de4783d x4 : ffff07ff9400a070 x3 : ffff07ff9de=
46c90
[ 3144.578407] x2 : ffff8000844ab9cc x1 : ffff8000844abb30 x0 : 00000000000=
00000
[ 3144.585534] Call trace:
[ 3144.587969]  d_alloc_parallel+0x17c/0x520
[ 3144.591971]  path_openat+0x238/0xc70
[ 3144.595539]  do_filp_open+0xc4/0x178
[ 3144.599107]  do_sys_openat2+0x90/0x100
[ 3144.602847]  __arm64_sys_openat+0x7c/0xb0
[ 3144.606848]  invoke_syscall+0x78/0x110
[ 3144.610591]  el0_svc_common+0x94/0xf8
[ 3144.614247]  do_el0_svc+0x3c/0xb8
[ 3144.617555]  el0_svc+0x34/0x110
[ 3144.620690]  el0t_64_sync_handler+0x84/0x100
[ 3144.624954]  el0t_64_sync+0x194/0x198
[ 3168.068867] watchdog: BUG: soft lockup - CPU#97 stuck for 48s! [fio:9377=
7]
[ 3168.069867] watchdog: BUG: soft lockup - CPU#99 stuck for 48s!
[systemd-udevd:1680]

Thanks=EF=BC=8C

