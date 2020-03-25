Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F50C2D0E6
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD93120774
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbgCYSGo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:06:44 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:43372 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgCYSGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 14:06:44 -0400
Received: from [192.168.0.2] (188-167-68-178.dynamic.chello.sk [188.167.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 80D267A0255;
        Wed, 25 Mar 2020 19:06:43 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     hmadhani@marvell.com
Subject: NULL pointer dereference in qla24xx_abort_command
Date:   Wed, 25 Mar 2020 19:06:40 +0100
User-Agent: KMail/1.9.10
Cc:     linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202003251906.40982.linux@zary.sk>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himanshu,
could you please look into this bug?
https://www.spinics.net/lists/linux-scsi/msg138637.html

[2076301.849762] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[2076301.850021] PGD 0 P4D 0
[2076301.850109] Oops: 0002 [#1] SMP PTI
[2076301.850219] CPU: 4 PID: 18992 Comm: kworker/u16:1 Not tainted 4.19.0-8-amd64 #1 Debian 4.19.98-1
[2076301.850478] Hardware name: Dell Inc. PowerEdge 2950/0JR815, BIOS 2.7.0 10/30/2010
[2076301.850720] Workqueue: scsi_tmf_4 scmd_eh_abort_handler [scsi_mod]
[2076301.850936] RIP: 0010:qla24xx_async_abort_cmd+0x1b/0x250 [qla2xxx]
[2076301.851130] Code: e9 19 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 4c 8b 6f 28 4c 8b 7f 20 4c 8b 77 48 <f0> 41 ff 46 04 0f a
e f0 41 f6 46 24 04 74 17 f0 41 ff 4e 04 bd 02
[2076301.851663] RSP: 0018:ffffa10f8bbe7da8 EFLAGS: 00010293
[2076301.851820] RAX: 0000000000000800 RBX: ffff8ab8ddd197a8 RCX: 0000000000000070
[2076301.852036] RDX: ffff8ab8de4a8388 RSI: 0000000000000001 RDI: ffff8ab8799b8c40
[2076301.852253] RBP: ffff8ab8dc96c480 R08: ffffffffc03b7860 R09: 0000000000000000
[2076301.852469] R10: 8080808080808080 R11: 0000000000000010 R12: ffff8ab8dea00000
[2076301.852686] R13: ffff8ab8ddd197a8 R14: 0000000000000000 R15: ffff8ab8dd632000
[2076301.852902] FS:  0000000000000000(0000) GS:ffff8ab8e7b00000(0000) knlGS:0000000000000000
[2076301.853142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2076301.853320] CR2: 0000000000000004 CR3: 00000002203dc000 CR4: 00000000000006e0
[2076301.853536] Call Trace:
[2076301.853632]  qla24xx_abort_command+0x218/0x2d0 [qla2xxx]
[2076301.853799]  ? __switch_to_asm+0x41/0x70
[2076301.853924]  ? __switch_to_asm+0x35/0x70
[2076301.854056]  qla2xxx_eh_abort+0x117/0x310 [qla2xxx]
[2076301.854209]  scmd_eh_abort_handler+0x85/0x220 [scsi_mod]
[2076301.854375]  process_one_work+0x1a7/0x3a0
[2076301.854506]  worker_thread+0x30/0x390
[2076301.854628]  ? create_worker+0x1a0/0x1a0
[2076301.854753]  kthread+0x112/0x130
[2076301.854859]  ? kthread_bind+0x30/0x30
[2076301.854980]  ret_from_fork+0x35/0x40
[2076301.855095] Modules linked in: loop ipmi_ssif radeon coretemp ttm drm_kms_helper drm kvm i2c_algo_bit i5000_edac iTCO_wdt sg iTCO_vendor_support irqbypass evdev i5k_
amb serio_raw joydev ipmi_si rng_core pcc_cpufreq dcdbas pcspkr ipmi_devintf acpi_cpufreq ipmi_msghandler button ext4 crc16 mbcache jbd2 crc32c_generic fscrypto ecb crypt
o_simd cryptd glue_helper aes_x86_64 dm_service_time dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua uas usb_storage hid_generic usbhid hid sr_mod cdrom ses enc
losure sd_mod scsi_transport_sas ata_generic qla2xxx ata_piix nvme_fc ehci_pci nvme_fabrics libata uhci_hcd psmouse ehci_hcd nvme_core megaraid_sas usbcore scsi_transport
_fc lpc_ich mfd_core scsi_mod usb_common bnx2
[2076301.856887] CR2: 0000000000000004
[2076301.856999] ---[ end trace e9083db8fb76e126 ]---
[2076301.857151] RIP: 0010:qla24xx_async_abort_cmd+0x1b/0x250 [qla2xxx]
[2076301.857345] Code: e9 19 ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 41 57 41 56 41 55 41 54 55 53 4c 8b 6f 28 4c 8b 7f 20 4c 8b 77 48 <f0> 41 ff 46 04 0f a
e f0 41 f6 46 24 04 74 17 f0 41 ff 4e 04 bd 02
[2076301.857878] RSP: 0018:ffffa10f8bbe7da8 EFLAGS: 00010293
[2076301.858035] RAX: 0000000000000800 RBX: ffff8ab8ddd197a8 RCX: 0000000000000070
[2076301.858251] RDX: ffff8ab8de4a8388 RSI: 0000000000000001 RDI: ffff8ab8799b8c40
[2076301.858467] RBP: ffff8ab8dc96c480 R08: ffffffffc03b7860 R09: 0000000000000000
[2076301.869384] R10: 8080808080808080 R11: 0000000000000010 R12: ffff8ab8dea00000
[2076301.880412] R13: ffff8ab8ddd197a8 R14: 0000000000000000 R15: ffff8ab8dd632000
[2076301.891483] FS:  0000000000000000(0000) GS:ffff8ab8e7b00000(0000) knlGS:0000000000000000
[2076301.902490] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[2076301.913344] CR2: 0000000000000004 CR3: 00000002203dc000 CR4: 00000000000006e0
[2077225.259348] mysqld[2155]: segfault at 0 ip 000056409366ad93 sp 00007fa049514450 error 6 in mysqld[564092eb2000+805000]
[2077225.270564] Code: c7 45 00 00 00 00 00 8b 7d cc 4c 89 e2 4c 89 f6 e8 62 81 84 ff 49 89 c7 49 39 c4 0f 84 f6 00 00 00 e8 e1 1c 00 00 41 8b 4d 00 <89> 08 85 c9 74 37 4
9 83 ff ff 0f 84 9d 00 00 00 f6 c3 06 75 28 4d


-- 
Ondrej Zary
