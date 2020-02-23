Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B41A1C35666
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 18:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A37206E0
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 18:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWSiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 13:38:10 -0500
Received: from hosting.gsystem.sk ([212.5.213.30]:52830 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSiK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Feb 2020 13:38:10 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Feb 2020 13:38:10 EST
Received: from [192.168.0.2] (unknown [188.167.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id E54DE7A00BF;
        Sun, 23 Feb 2020 19:29:03 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: NULL pointer dereference in qla24xx_abort_command, kernel 4.19.98 (Debian)
Date:   Sun, 23 Feb 2020 19:29:01 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202002231929.01662.linux@zary.sk>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,
a couple of days after upgrading a server from Debian 9 (kernel 4.9.210-1)
to 10 (kernel 4.19.98), qla2xxx crashed, along with mysql.

There is an EMC CX3 array connected through the fibre-channel adapter.
No errors are present in EMC event log.

This server was running without any problems since Debian 4.
Is this a known bug?

[979178.888922] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[979178.889160] PGD 0 P4D 0
[979178.889243] Oops: 0002 [#1] SMP PTI
[979178.889362] CPU: 6 PID: 11060 Comm: kworker/u16:2 Not tainted 4.19.0-8-amd64 #1 Debian 4.19.98-1
[979178.889617] Hardware name: Dell Inc. PowerEdge 2950/0JR815, BIOS 2.7.0 10/30/2010
[979178.889855] Workqueue: scsi_tmf_4 scmd_eh_abort_handler [scsi_mod]
[979178.890069] RIP: 0010:qla24xx_async_abort_cmd+0x1b/0x250 [qla2xxx]
[979178.890258] Code: e9 19 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 4c 8b 6f 28 4c 8b 7f 20 4c 8b 77 48 <f0> 41 ff 46 04 0f ae
 f0 41 f6 46 24 04 74 17 f0 41 ff 4e 04 bd 02
[979178.890801] RSP: 0018:ffffb1250ba83da8 EFLAGS: 00010293
[979178.890966] RAX: 0000000000000800 RBX: ffff93b89db837a8 RCX: 00000000000005f4
[979178.891178] RDX: ffff93b89e28afa8 RSI: 0000000000000001 RDI: ffff93b8a5018fc0
[979178.891389] RBP: ffff93b89ccb89c0 R08: ffffffffc0595860 R09: 0000000000000000
[979178.891600] R10: 8080808080808080 R11: 0000000000000010 R12: ffff93b89db82000
[979178.891811] R13: ffff93b89db837a8 R14: 0000000000000000 R15: ffff93b89d88a800
[979178.892023] FS:  0000000000000000(0000) GS:ffff93b8a7b80000(0000) knlGS:0000000000000000
[979178.892258] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[979178.892430] CR2: 0000000000000004 CR3: 000000021a62a000 CR4: 00000000000006e0
[979178.892642] Call Trace:
[979178.892748]  qla24xx_abort_command+0x218/0x2d0 [qla2xxx]
[979178.892911]  ? __switch_to_asm+0x41/0x70
[979178.893031]  ? __switch_to_asm+0x35/0x70
[979178.893160]  qla2xxx_eh_abort+0x117/0x310 [qla2xxx]
[979178.893323]  scmd_eh_abort_handler+0x85/0x220 [scsi_mod]
[979178.893484]  process_one_work+0x1a7/0x3a0
[979178.893611]  worker_thread+0x30/0x390
[979178.893727]  ? create_worker+0x1a0/0x1a0
[979178.893847]  kthread+0x112/0x130
[979178.893948]  ? kthread_bind+0x30/0x30
[979178.894064]  ret_from_fork+0x35/0x40
[979178.894174] Modules linked in: loop ipmi_ssif radeon ttm drm_kms_helper drm coretemp i2c_algo_bit iTCO_wdt iTCO_vendor_support ipmi_si joydev kvm sg evdev i5000_edac
ipmi_devintf pcc_cpufreq ipmi_msghandler rng_core i5k_amb irqbypass dcdbas serio_raw acpi_cpufreq button pcspkr ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb crypto
_simd cryptd glue_helper aes_x86_64 dm_service_time dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua uas usb_storage hid_generic usbhid hid sr_mod ses cdrom encl
osure sd_mod scsi_transport_sas ata_generic qla2xxx uhci_hcd ehci_pci ehci_hcd psmouse ata_piix nvme_fc libata nvme_fabrics usbcore nvme_core megaraid_sas scsi_transport_
fc scsi_mod lpc_ich mfd_core usb_common bnx2
[979178.895968] CR2: 0000000000000004
[979178.896075] ---[ end trace 4d42692cc0dc3c87 ]---
[979178.896225] RIP: 0010:qla24xx_async_abort_cmd+0x1b/0x250 [qla2xxx]
[979178.896414] Code: e9 19 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 4c 8b 6f 28 4c 8b 7f 20 4c 8b 77 48 <f0> 41 ff 46 04 0f ae
 f0 41 f6 46 24 04 74 17 f0 41 ff 4e 04 bd 02
[979178.896956] RSP: 0018:ffffb1250ba83da8 EFLAGS: 00010293
[979178.897121] RAX: 0000000000000800 RBX: ffff93b89db837a8 RCX: 00000000000005f4
[979178.897332] RDX: ffff93b89e28afa8 RSI: 0000000000000001 RDI: ffff93b8a5018fc0
[979178.897544] RBP: ffff93b89ccb89c0 R08: ffffffffc0595860 R09: 0000000000000000
[979178.908415] R10: 8080808080808080 R11: 0000000000000010 R12: ffff93b89db82000
[979178.919419] R13: ffff93b89db837a8 R14: 0000000000000000 R15: ffff93b89d88a800
[979178.930444] FS:  0000000000000000(0000) GS:ffff93b8a7b80000(0000) knlGS:0000000000000000
[979178.941366] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[979178.952142] CR2: 0000000000000004 CR3: 000000021a62a000 CR4: 00000000000006e0
[980103.072740] mysqld[2175]: segfault at 0 ip 000055bbc5cd2d93 sp 00007f2362ffb450 error 6 in mysqld[55bbc551a000+805000]
[980103.083956] Code: c7 45 00 00 00 00 00 8b 7d cc 4c 89 e2 4c 89 f6 e8 62 81 84 ff 49 89 c7 49 39 c4 0f 84 f6 00 00 00 e8 e1 1c 00 00 41 8b 4d 00 <89> 08 85 c9 74 37 49
 83 ff ff 0f 84 9d 00 00 00 f6 c3 06 75 28 4d




-- 
Ondrej Zary
