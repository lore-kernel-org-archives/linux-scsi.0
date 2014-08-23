From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Sat, 23 Aug 2014 20:04:10 +0000
Message-ID: <bug-81861-11613-pm2x1GNhbz@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35347 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaHWUEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Aug 2014 16:04:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E05AA201BC
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 20:04:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C42922018E
	for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 20:04:10 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #13 from linux-ide@crashplan.pro ---
It dies between printing the second and the third variable:

[   30.455440] sas: DONE DISCOVERY on port 0, pid:128, result:0
[   30.455502] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   30.455534] sas: ata6: end_device-5:0:20: dev error handler
[   30.455744] sas: ata7: end_device-5:0:21: dev error handler
[   30.456186] sas: ata8: end_device-5:0:22: dev error handler
[   30.456367] sas: ata9: end_device-5:0:23: dev error handler
[   30.611146] [0 ffff8800d8e255b8 44]
[   30.611959] [0 ffff8800d8e255b8 46]
[   30.612511] [2 ffff8800d8e25668
[   30.612537] BUG: unable to handle kernel NULL pointer dereference at
0000000000000255
[   30.613511] IP: [<ffffffffa022c872>] mvs_task_prep+0x782/0xdd0 [mvsas]
[   30.614003] PGD 0
[   30.614486] Oops: 0000 [#1] SMP
[   30.614967] Modules linked in: mvsas(OF) libsas scsi_transport_sas
x86_pkg_temp_thermal intel_powerclamp hid_generic coretemp usbhid kvm_intel
i915 kvm hid crct10dif_pclmul drm_kms_helper crc32_pclmul ghash_clmulni_intel
cryptd drm netconsole configfs i2c_algo_bit serio_raw mei_me lpc_ich mei lp
video mac_hid parport psmouse r8169 mii ahci libahci
[   30.616702] CPU: 0 PID: 6 Comm: kworker/u4:0 Tainted: GF          O
3.13.0-35-generic #62-Ubuntu
[   30.617279] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./H81
Pro BTC, BIOS P1.80 07/21/2014
[   30.617853] Workqueue: events_unbound async_run_entry_fn
[   30.618426] task: ffff8802139b0000 ti: ffff8802139ae000 task.ti:
ffff8802139ae000
[   30.619007] RIP: 0010:[<ffffffffa022c872>]  [<ffffffffa022c872>]
mvs_task_prep+0x782/0xdd0 [mvsas]
[   30.619604] RSP: 0018:ffff8802139af8c0  EFLAGS: 00010096
[   30.620188] RAX: ffff8800d8e03618 RBX: 0000000000000002 RCX:
0000000000002ace
[   30.620779] RDX: 00000000000064e6 RSI: 0000000000000046 RDI:
0000000000000046
[   30.621363] RBP: ffff8802139af958 R08: 0000000000000086 R09:
0000000000000426
[   30.621941] R10: ffff880213bf4098 R11: 0000000000000001 R12:
0000000000000001
[   30.622508] R13: ffff8800d8e00000 R14: ffff8800d8e03618 R15:
ffff88007f912500
[   30.623068] FS:  0000000000000000(0000) GS:ffff88021f200000(0000)
knlGS:0000000000000000
[   30.623649] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   30.624238] CR2: 0000000000000255 CR3: 0000000002c0e000 CR4:
00000000000407f0
[   30.624844] Stack:
[   30.625450]  ffffffff8109d415 ffff88021f314440 ffff88021f314440
ffff88021f314440
[   30.626097]  ffff88020f97064c ffff8800d8e01e38 ffff880211d6fe00
ffff8800d8e25660
[   30.626752]  ffff88007f740080 ffff8800d8e02678 0000000181098129
ffff8800d8e25668
[   30.627413] Call Trace:
[   30.628072]  [<ffffffff8109d415>] ? sched_clock_cpu+0xb5/0x100
[   30.628753]  [<ffffffffa022cf1d>] mvs_task_exec.isra.13+0x5d/0xe0 [mvsas]
[   30.629450]  [<ffffffffa022da5c>] mvs_queue_command+0x30c/0x320 [mvsas]
[   30.630155]  [<ffffffff811a2362>] ? kmem_cache_alloc+0x1b2/0x1e0
[   30.630867]  [<ffffffffa020c787>] ? sas_free_task+0x37/0x40 [libsas]
[   30.631593]  [<ffffffffa0215cab>] sas_ata_qc_issue+0x24b/0x290 [libsas]
[   30.632326]  [<ffffffff814fe742>] ata_qc_issue+0x172/0x380
[   30.633067]  [<ffffffff814fec03>] ata_exec_internal_sg+0x2b3/0x570
[   30.633817]  [<ffffffff814fef1a>] ata_exec_internal+0x5a/0xa0
[   30.634570]  [<ffffffff814ff314>] ata_dev_read_id+0x274/0x550
[   30.635332]  [<ffffffffa02158f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   30.636166]  [<ffffffff8150cbab>] ata_eh_recover+0x74b/0x1310
[   30.636938]  [<ffffffff81501cb0>] ? ata_phys_link_online+0x30/0x30
[   30.637721]  [<ffffffffa02158f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   30.638512]  [<ffffffff81501e30>] ? ata_phys_link_offline+0x30/0x30
[   30.639314]  [<ffffffffa02158f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   30.640119]  [<ffffffff81501e30>] ? ata_phys_link_offline+0x30/0x30
[   30.640933]  [<ffffffffa02158f0>] ? sas_ata_printk+0x80/0x80 [libsas]
[   30.641758]  [<ffffffff8150e299>] ata_do_eh+0x49/0xc0
[   30.642588]  [<ffffffff81501cb0>] ? ata_phys_link_online+0x30/0x30
[   30.643425]  [<ffffffff8150e34e>] ata_std_error_handler+0x3e/0x80
[   30.644271]  [<ffffffff8150ddba>] ata_scsi_port_error_handler+0x56a/0x940
[   30.645128]  [<ffffffffa02160aa>] async_sas_ata_eh+0x4a/0x80 [libsas]
[   30.645996]  [<ffffffff81091657>] async_run_entry_fn+0x37/0x130
[   30.646871]  [<ffffffff810839d2>] process_one_work+0x182/0x450
[   30.647750]  [<ffffffff810847c1>] worker_thread+0x121/0x410
[   30.648638]  [<ffffffff810846a0>] ? rescuer_thread+0x430/0x430
[   30.649534]  [<ffffffff8108b4a2>] kthread+0xd2/0xf0
[   30.650429]  [<ffffffff8108b3d0>] ? kthread_create_on_node+0x1c0/0x1c0
[   30.651321]  [<ffffffff8172ecbc>] ret_from_fork+0x7c/0xb0
[   30.652211]  [<ffffffff8108b3d0>] ? kthread_create_on_node+0x1c0/0x1c0
[   30.653102] Code: 03 47 23 a0 31 c0 e8 62 b7 4e e1 48 8b 4d c0 41 8b 45 58
48 c7 c7 07 47 23 a0 89 41 1c 48 89 ce 31 c0 e8 46 b7 4e e1 48 8b 45 d0 <41> 8b
8c 24 54 02 00 00 41 bc 00 10 00 00 41 8b 75 58 48 c7 c7
[   30.655215] RIP  [<ffffffffa022c872>] mvs_task_prep+0x782/0xdd0 [mvsas]
[   30.656195]  RSP <ffff8802139af8c0>
[   30.657163] CR2: 0000000000000255

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
