Return-Path: <SRS0=MIBM=WR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E12CC3A59E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 08:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D1F02339E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Aug 2019 08:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfHUI7r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Aug 2019 04:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfHUI7r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Aug 2019 04:59:47 -0400
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7BED3B738
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2019 08:59:46 +0000 (UTC)
Received: by mail-vk1-f198.google.com with SMTP id r17so629852vkd.23
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2019 01:59:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=T0zyt8pdmUNNX5LUieDb3WOJzDsiFXIwY84UanirCHE=;
        b=gv+zJzwXeW4zcTbFdM10Pp8fIXvxrN0GxMfQWj/pCLU97HbjC24ns2x6efFsZumQUE
         gvrVPEUyTHYla6gIuyx7lWrKXrpOJlV1Gi2P0ay2rs+by3/lOm9BJI43bnVlCTjCfzxW
         BwCakRbmG7W7ET3bH/r74NnfDD0yMf/6n3O/YI0ysD6fU6P1S3tfSRaoRJC/BW8x89x5
         pifv6y8fRUsaUztyZg3+TQIN0bzfT+ljv7JnBhFh2NAhM/gKaHNwMz7F7XIWRdzGuDid
         uvws9r4aoaXlozg9VXPzuGix1noOlk0D9P3Y9gBy0JN0/d53911OBNnGyLIoqD07PxqU
         2CTw==
X-Gm-Message-State: APjAAAUC0MltKTkkvyTX7qZ9Br8tPpN+vy/rf/bNtYKeUxV4jl5DnPWX
        xWxGUD0rF/8FjUmqt+fenHm1oJpMlhOtCl2woG3nYWY062BguqpVJvSoElQkrURUX9GwRdCK+vJ
        u4BK50w3bDv85wCoWmp/70ha5+z5r4K/qFNxQbw==
X-Received: by 2002:a9f:2927:: with SMTP id t36mr1714717uat.142.1566377985793;
        Wed, 21 Aug 2019 01:59:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYQw3Dg8bUC1rAxb19kP040V1FJ472/1p8t9Oahk0Hdk0jkqDawfnX8B1JqUkBDKrSI2ayOnLrlq/NvjTsa98=
X-Received: by 2002:a9f:2927:: with SMTP id t36mr1714705uat.142.1566377985390;
 Wed, 21 Aug 2019 01:59:45 -0700 (PDT)
MIME-Version: 1.0
From:   Li Wang <liwang@redhat.com>
Date:   Wed, 21 Aug 2019 16:59:34 +0800
Message-ID: <CAEemH2f5FTS4tGvjhmz6VpethOYnhVhVcETY2AdFbSfdQ8=y9g@mail.gmail.com>
Subject: [5.3.0-rc4 Bug] WARNING: CPU: 17 PID: 25085 at lib/list_debug.c:47 __list_del_entry_valid+0x4e/0x90
To:     james.smart@broadcom.com, Arun Easi <aeasi@marvell.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi lpfc experts,

We observed these warnings during the mainline kernel-v5.3.0-rc4
testing. There is no explicit reproducer so far, if you need some more
information, plz let me know.

Test system has this device: OneConnect 10Gb FCoE Initiator (be3)

[  211.080240] lpfc 0000:47:00.3: 1:2505 EQ_DESTROY mailbox failed
with status x5 add_status x0, mbx status x10
[  211.129399] ------------[ cut here ]------------
[  211.153700] list_del corruption, ffff97b9bb58b470->next is
LIST_POISON1 (dead000000000100)
[  211.199179] WARNING: CPU: 17 PID: 25085 at lib/list_debug.c:47
__list_del_entry_valid+0x4e/0x90
[  211.246981] Modules linked in: sunrpc amd64_edac_mod edac_mce_amd
kvm_amd ccp kvm ipmi_ssif irqbypass crct10dif_pclmul crc32_pclmul
sp5100_tco hpwdt joydev pcspkr ipmi_si ghash_clmulni_intel i2c_piix4
sg fam15h_power k10temp ipmi_devintf hpilo ipmi_msghandler
acpi_power_meter xfs libcrc32c radeon i2c_algo_bit lpfc drm_kms_helper
sd_mod nvmet_fc syscopyarea sysfillrect sysimgblt nvmet fb_sys_fops
ttm nvme_fc nvme_fabrics drm nvme_core ahci libahci ata_generic
scsi_transport_fc crc32c_intel serio_raw netxen_nic libata hpsa
scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[  211.512759] CPU: 17 PID: 25085 Comm: reboot Not tainted 5.3.0-rc4+ #1
[  211.546757] Hardware name: HP ProLiant DL585 G7, BIOS A16 06/04/2013
[  211.577666] RIP: 0010:__list_del_entry_valid+0x4e/0x90
[  211.605776] Code: 2e 48 8b 32 48 39 fe 75 3a 48 8b 50 08 48 39 f2
75 48 b8 01 00 00 00 c3 48 89 fe 48 89 c2 48 c7 c7 90 7c 70 89 e8 4b
31 c7 ff <0f> 0b 31 c0 c3 48 89 fe 48 c7 c7 c8 7c 70 89 e8 37 31 c7 ff
0f 0b
[  211.700384] RSP: 0018:ffffa5cfd9f1fcf0 EFLAGS: 00010286
[  211.730407] RAX: 0000000000000000 RBX: 0000000000000028 RCX: ffffffff89858d08
[  211.770165] RDX: 0000000000000001 RSI: 0000000000000092 RDI: ffffffff8a0452ac
[  211.809284] RBP: ffff97b9bb58b400 R08: 000000000000071b R09: 0000000000000011
[  211.848165] R10: 0000000000000000 R11: ffffa5cfd9f1fb98 R12: ffff97b9bb58b450
[  211.887273] R13: 0000000000000002 R14: 000000000000000e R15: ffff989407d38000
[  211.924806] FS:  00007fa6614fb380(0000) GS:ffff97f73fb00000(0000)
knlGS:0000000000000000
[  211.964734] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  211.994813] CR2: 0000563ca3983ae0 CR3: 0000005fbeec8000 CR4: 00000000000406e0
[  212.029859] Call Trace:
[  212.043832]  lpfc_sli4_queue_free+0xfb/0x140 [lpfc]
[  212.068662]  lpfc_sli4_queue_destroy+0x11a/0x390 [lpfc]
[  212.093783]  lpfc_pci_remove_one+0x7d6/0x970 [lpfc]
[  212.120727]  pci_device_shutdown+0x34/0x60
[  212.140789]  device_shutdown+0x160/0x1c0
[  212.159573]  kernel_restart+0xe/0x30
[  212.179305]  __do_sys_reboot+0x1cf/0x210
[  212.200663]  ? __fput+0x168/0x250
[  212.217031]  ? syscall_trace_enter+0x198/0x2c0
[  212.238690]  ? __audit_syscall_exit+0x249/0x2a0
[  212.263835]  do_syscall_64+0x59/0x1e0
[  212.284258]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  212.311343] RIP: 0033:0x7fa660744427
[  212.331477] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00
00 00 90 f3 0f 1e fa 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 31 9a 2c 00 f7 d8 64 89
02 b8
[  212.431882] RSP: 002b:00007fff7cdde998 EFLAGS: 00000246 ORIG_RAX:
00000000000000a9
[  212.468850] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa660744427
[  212.506676] RDX: 0000000001234567 RSI: 0000000028121969 RDI: 00000000fee1dead
[  212.541728] RBP: 00007fff7cdde9e0 R08: 0000000000000002 R09: 0000000000000000
[  212.578997] R10: 000000000000004b R11: 0000000000000246 R12: 0000000000000001
[  212.614302] R13: 00000000fffffffe R14: 0000000000000006 R15: 0000000000000000
[  212.651285] ---[ end trace 791103fd1685648d ]---


[  119.322923] ------------[ cut here ]------------
[  119.347248] kernel BUG at mm/slub.c:3952!
[  119.366674] invalid opcode: 0000 [#1] SMP NOPTI
[  119.391577] CPU: 32 PID: 2944 Comm: reboot Kdump: loaded Tainted: G
       W         5.3.0-rc4+ #1
[  119.436031] Hardware name: HP ProLiant DL585 G7, BIOS A16 06/04/2013
[  119.470259] RIP: 0010:kfree+0x19e/0x1d0
[  119.488625] Code: 00 74 1f 48 8b 45 00 31 f6 a9 00 00 01 00 74 04
0f b6 75 51 5b 48 89 ef 5d 41 5c 41 5d e9 ba 78 fd ff 48 8b 45 08 a8
01 75 d9 <0f> 0b 4d 89 e9 48 89 d9 48 89 da 48 89 ee 5b 4c 89 e7 5d 41
b8 01
[  119.582912] RSP: 0018:ffffafb99a397cf0 EFLAGS: 00010246
[  119.611357] RAX: ffffdb0dfee52c08 RBX: ffff97cc79450000 RCX: ffffffff92c58d08
[  119.646037] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff97cc79450000
[  119.684937] RBP: ffffdb0dfee51400 R08: 0000000000000827 R09: 0000000000000020
[  119.723524] R10: 0000000000000000 R11: ffffafb99a397b98 R12: ffffffffc04b25ba
[  119.764290] R13: 000000000000000d R14: 000000000000000e R15: ffff97e947b0a000
[  119.803531] FS:  00007f7f70243380(0000) GS:ffff972c7fa80000(0000)
knlGS:0000000000000000
[  119.846450] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  119.873893] CR2: 0000560e85910ae0 CR3: 0000003fba9d2000 CR4: 00000000000406e0
[  119.912293] Call Trace:
[  119.924344]  lpfc_sli4_queue_destroy+0x11a/0x390 [lpfc]
[  119.949270]  lpfc_pci_remove_one+0x7d6/0x970 [lpfc]
[  119.976858]  pci_device_shutdown+0x34/0x60
[  119.996353]  device_shutdown+0x160/0x1c0
[  120.015045]  kernel_restart+0xe/0x30
[  120.033515]  __do_sys_reboot+0x1cf/0x210
[  120.054274]  ? __fput+0x168/0x250
[  120.070250]  ? syscall_trace_enter+0x198/0x2c0
[  120.091719]  ? __audit_syscall_exit+0x249/0x2a0
[  120.115046]  do_syscall_64+0x59/0x1e0
[  120.135104]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  120.158848] RIP: 0033:0x7f7f6f48c427
[  120.175870] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00
00 00 90 f3 0f 1e fa 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 31 9a 2c 00 f7 d8 64 89
02 b8
[  120.279588] RSP: 002b:00007fffe3e36288 EFLAGS: 00000246 ORIG_RAX:
00000000000000a9
[  120.321551] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7f6f48c427
[  120.361854] RDX: 0000000001234567 RSI: 0000000028121969 RDI: 00000000fee1dead
[  120.398536] RBP: 00007fffe3e362d0 R08: 0000000000000002 R09: 0000000000000000
[  120.436702] R10: 000000000000004b R11: 0000000000000246 R12: 0000000000000001
[  120.470997] R13: 00000000fffffffe R14: 0000000000000006 R15: 0000000000000000
[  120.508557] Modules linked in: sunrpc amd64_edac_mod edac_mce_amd
kvm_amd ccp kvm irqbypass ipmi_ssif crct10dif_pclmul crc32_pclmul
sp5100_tco ipmi_si joydev ghash_clmulni_intel pcspkr i2c_piix4 hpwdt
sg fam15h_power ipmi_devintf k10temp hpilo ipmi_msghandler
acpi_power_meter xfs libcrc32c radeon i2c_algo_bit drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops lpfc sd_mod ttm ahci
nvmet_fc nvmet libahci ata_generic drm nvme_fc libata nvme_fabrics
netxen_nic hpsa nvme_core crc32c_intel scsi_transport_fc serio_raw
scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod


--
Regards,
Li Wang
