Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA51C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Feb 2023 07:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBFHcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Feb 2023 02:32:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjBFHcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2023 02:32:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FB91CF5B
        for <linux-scsi@vger.kernel.org>; Sun,  5 Feb 2023 23:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675668616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=3jXjjDL5J91hORH4TYi0QdQmGwZQaSssEMGf4ZeejqQ=;
        b=Wu1UI7KlJdoUvIOUktThoMvwkhA7jrG8lt858xUoSsGh9Exwbjl4EG8vOvEwRg/7ctgjug
        pMlvmaVm2fdSPj/5dICjryTScZizNEpiBAkkCRew2Og9WavO7c6OhHkOsUsG95gKvh1P+e
        tAU24CMdz5X4PByS4KE3N2Vpnh8NkWQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-141-PMCrhPPaPsat159jdAd5iQ-1; Mon, 06 Feb 2023 02:30:15 -0500
X-MC-Unique: PMCrhPPaPsat159jdAd5iQ-1
Received: by mail-pl1-f200.google.com with SMTP id z8-20020a170902834800b001990ad8de5bso1756185pln.10
        for <linux-scsi@vger.kernel.org>; Sun, 05 Feb 2023 23:30:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3jXjjDL5J91hORH4TYi0QdQmGwZQaSssEMGf4ZeejqQ=;
        b=ANXPjbV7Qj07gorD6+2oVMaOgHGwwWWgLxrwrCYKbbHEGBPyZK5fYQhf59mHQYf6kr
         2bYBY8ERHfQHaN8f4Aut6bK6Rmymis0Mn65nQSDOyV0Xcz7mjD7vcjfnwgtpUoa0Ru3s
         oN1kmw5lRDB3piuciTZzXuZVbquAyElW7FQGpVLLHoLGWUBHWdWe49Xywszn7UFXzkaF
         3QkwofZ8oz7h8iRM9t3nD/1pGEEgwM1REndo4rlb3YZPtALWKLUky8I8sbKR6Q7wQgiA
         L+pwURUmU2aLRFK8G+VUiRSzub/1Dhd96LE8+tj2ejmrJZbvrVpqi8N46ZdIoW3N+/c6
         jT5A==
X-Gm-Message-State: AO0yUKXKEqv5bUaJWRwhqISESZxOrp0zHaMkOgY+UsrS0sg2ah8co/kD
        Sj+M2WtNaAllqQQGwIv0F6gh61NOFb9PaAhp8PRk84XcTQ1LRNj9bnpBz7aaXZ9OYlnKasLcyx1
        K1qy1qQxlCAb3Guqvy36XpBPSfAuYjb0mNEElZg==
X-Received: by 2002:a05:6a00:1581:b0:590:72e0:8f60 with SMTP id u1-20020a056a00158100b0059072e08f60mr3950387pfk.16.1675668613299;
        Sun, 05 Feb 2023 23:30:13 -0800 (PST)
X-Google-Smtp-Source: AK7set+6LMsMKPsv8ZVGVMW8qv5F4LLRLb904RR+20NFbfkTDYU/VwtKwz+3oQkD0x1lWrm/gGVl2cgLOnxlOM2gLU8=
X-Received: by 2002:a05:6a00:1581:b0:590:72e0:8f60 with SMTP id
 u1-20020a056a00158100b0059072e08f60mr3950385pfk.16.1675668612990; Sun, 05 Feb
 2023 23:30:12 -0800 (PST)
MIME-Version: 1.0
From:   Yi Zhang <yi.zhang@redhat.com>
Date:   Mon, 6 Feb 2023 15:30:01 +0800
Message-ID: <CAHj4cs-jef8f4zxJQxjKirAWyZkTREycFdNPvQaGbgS-1r_Lcg@mail.gmail.com>
Subject: [bug report] WARNING at fs/proc/generic.c:376 proc_register+0x131/0x1c0
 observed with blktests scsi
To:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello
blktests scsi/ failed on the latest linux-block/for-next, pls help
check it, thanks.

linux-block.git@for-next
commit: 99bd489eac97

[  341.448821] run blktests scsi/004 at 2023-02-06 02:18:22
[  341.479128] ------------[ cut here ]------------
[  341.483794] proc_dir_entry 'scsi/scsi_debug' already registered
[  341.489753] WARNING: CPU: 81 PID: 24655 at fs/proc/generic.c:376
proc_register+0x131/0x1c0
[  341.498058] Modules linked in: scsi_debug(+) nvme_core nvme_common
rfkill intel_rapl_msr intel_rapl_common intel_uncore_frequency
intel_uncore_frequency_common intel_ifs sunrpc i10nm_edac nfit
libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
irqbypass rapl iTCO_wdt ipmi_ssif pmt_telemetry pmt_crashlog vfat
intel_pmc_bxt intel_cstate dell_smbios iTCO_vendor_support fat
pmt_class intel_sdsi mei_me intel_th_gth dcdbas intel_uncore pcspkr
intel_th_pci idxd isst_if_mbox_pci isst_if_mmio acpi_ipmi i2c_i801
dell_wmi_descriptor wmi_bmof isst_if_common intel_vsec idxd_bus
intel_th i2c_smbus tg3 mei i2c_ismt ipmi_si ipmi_devintf
ipmi_msghandler acpi_power_meter loop fuse zram xfs crct10dif_pclmul
crc32_pclmul crc32c_intel polyval_clmulni polyval_generic qat_4xxx
ghash_clmulni_intel sha512_ssse3 mpi3mr intel_qat scsi_transport_sas
crc8 mgag200 wmi pinctrl_emmitsburg [last unloaded: nvmet]
[  341.577657] CPU: 81 PID: 24655 Comm: modprobe Not tainted 6.2.0-rc6 #1
[  341.584210] Hardware name: Dell Inc. PowerEdge R660/0M1CC5, BIOS
0.2.28 09/23/2022
[  341.591802] RIP: 0010:proc_register+0x131/0x1c0
[  341.596359] Code: e8 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3
cc cc cc cc 49 8b b5 a0 00 00 00 4c 89 fa 48 c7 c7 b0 04 8b af e8 4a
d7 9c 00 <0f> 0b 48 c7 c7 a8 23 ee b0 e8 21 3d a5 00 8b 45 5c 48 c7 c7
d0 d9
[  341.615124] RSP: 0018:ff4c574d85c73b28 EFLAGS: 00010282
[  341.620376] RAX: 0000000000000033 RBX: ff49ee2778524148 RCX: 0000000000000000
[  341.627532] RDX: 0000000000000002 RSI: ffffffffaf8d93ce RDI: 00000000ffffffff
[  341.634685] RBP: ff49ee2783a9e840 R08: 0000000000000000 R09: ff4c574d85c739d8
[  341.641836] R10: 0000000000000003 R11: ff49ee2abfcc88a8 R12: 000000000000000a
[  341.648991] R13: ff49ee2744080300 R14: 000000000000000a R15: ff49ee2783a9e8ec
[  341.656140] FS:  00007fa98ee36740(0000) GS:ff49ee2aafc40000(0000)
knlGS:0000000000000000
[  341.664246] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  341.670010] CR2: 00007fa98e8e1c00 CR3: 00000001314b0002 CR4: 0000000000771ee0
[  341.677167] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  341.684319] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  341.691468] PKRU: 55555554
[  341.694200] Call Trace:
[  341.696671]  <TASK>
[  341.698807]  scsi_proc_hostdir_add+0x9e/0x120
[  341.703194]  scsi_host_alloc+0x342/0x3a0
[  341.707149]  sdebug_driver_probe+0x48/0x250 [scsi_debug]
[  341.712503]  really_probe+0xdb/0x380
[  341.716107]  ? pm_runtime_barrier+0x50/0x90
[  341.720319]  __driver_probe_device+0x78/0x170
[  341.724706]  driver_probe_device+0x1f/0x90
[  341.728832]  __device_attach_driver+0x85/0x110
[  341.733303]  ? __pfx___device_attach_driver+0x10/0x10
[  341.738381]  bus_for_each_drv+0x74/0xb0
[  341.742239]  __device_attach+0xae/0x1d0
[  341.746105]  bus_probe_device+0x8e/0xb0
[  341.749969]  device_add+0x41e/0x9a0
[  341.753488]  ? complete_all+0x20/0x90
[  341.757180]  sdebug_add_host_helper+0x138/0x2a0 [scsi_debug]
[  341.762876]  scsi_debug_init+0x5e2/0xff0 [scsi_debug]
[  341.767962]  ? __pfx_init_module+0x10/0x10 [scsi_debug]
[  341.773223]  do_one_initcall+0x56/0x230
[  341.777088]  do_init_module+0x4a/0x200
[  341.780867]  __do_sys_finit_module+0x93/0xf0
[  341.785167]  do_syscall_64+0x58/0x80
[  341.788770]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  341.793860] RIP: 0033:0x7fa98e907d2d
[  341.797488] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 f3 0f 1e
fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ab a0 0c 00 f7 d8 64 89
01 48
[  341.816252] RSP: 002b:00007ffec05faeb8 EFLAGS: 00000246 ORIG_RAX:
0000000000000139
[  341.823842] RAX: ffffffffffffffda RBX: 0000561087d12ce0 RCX: 00007fa98e907d2d
[  341.830992] RDX: 0000000000000000 RSI: 0000561087d12da0 RDI: 0000000000000003
[  341.838146] RBP: 00007ffec05faf70 R08: 0000000000000000 R09: 0000000000000000
[  341.845302] R10: 0000000000000003 R11: 0000000000000246 R12: 0000561087d12da0
[  341.852451] R13: 0000000000040000 R14: 0000561087d12ea0 R15: 0000561087d12da0
[  341.859606]  </TASK>
[  341.861821] ---[ end trace 0000000000000000 ]---
[  341.866459] scsi_proc_hostdir_add: proc_mkdir failed for scsi_debug
[  341.883579] scsi_debug:sdebug_driver_probe: scsi_host_alloc failed


-- 
Best Regards,
  Yi Zhang

