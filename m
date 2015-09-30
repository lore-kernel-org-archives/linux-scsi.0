From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi device
Date: Wed, 30 Sep 2015 00:35:50 +0000
Message-ID: <20150930003549.GA4857@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:51691 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbbI3AiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2015 20:38:25 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id t8U0cOQm023316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 09:38:24 +0900 (JST)
Content-Language: ja-JP
Content-ID: <25A4FEFD6BBB6F49A0C000330A3F6532@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

With v4.3-rc3, stress testing of SCSI device addition/removal quickly
trigger random crash in memory allocator (e.g. __kmalloc).  I found that
a commit 086b91d052eb ("scsi_dh: integrate into the core SCSI code")
moved the call of scsi_dh->detach() to very early part of sdev tear down
process (scsi_remove_device()). As a result, related data structure such
as alua_dh_data can be freed while rtpg/stpg are still in-flight.

Here is an example of crash log.  You can see strange rtpg log
'port group 25a43100' for 514:0:0:0 after 'Detached':

>> [  170.518427] sd 517:0:0:0: [sdd] Attached SCSI disk
>> [  170.528681] sd 514:0:0:0: alua: Detached
>> [  170.528720] sd 517:0:0:0: alua: Detached
>> [  170.528827] sd 515:0:0:0: alua: Detached
>> [  170.528922] sd 514:0:0:0: alua: port group 25a43100 state A non-preferred supports tolusna
>> [  170.528924] device-mapper: multipath: Failing path 8:16.
>> [  170.529059] device-mapper: table: 253:0: multipath: error getting device
>> [  170.529060] device-mapper: ioctl: error adding target to table
>> [  170.529212] device-mapper: multipath: Failing path 8:0.
>> [  170.540498] sd 516:0:0:0: alua: Detached
>> [  170.540543] sd 515:0:0:0: [sdb] Synchronizing SCSI cache
>> [  170.541849] sd 517:0:0:0: [sdd] Synchronizing SCSI cache
>> [  170.542393] sd 514:0:0:0: [sda] Synchronizing SCSI cache
>> [  170.546836] BUG: unable to handle kernel paging request at 0000001028000000
>> [  170.548499] IP: [<ffffffff811dce0a>] kmem_cache_alloc_trace+0x7a/0x1f0
>> [  170.550069] sd 516:0:0:0: [sdc] Synchronizing SCSI cache
>> [  170.551540] PGD 0 
>> [  170.552686] Oops: 0000 [#1] SMP 
>> [  170.553946] Modules linked in: dm_queue_length sd_mod iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi nls_utf8 isofs cirrus ttm drm_kms_helper syscopyarea crct10dif_pclmul sysfillrect crc32_pclmul sys imgblt ghash_clmulni_intel fb_sys_fops aesni_intel drm lrw gf128mul virtio_console glue_helper ablk_helper ppdev cryptd parport_pc i2c_piix4 serio_raw pcspkr parport i2c_core virtio_balloon acpi_cpufreq xfs l ibcrc32c sr_mod cdrom ata_generic pata_acpi virtio_blk virtio_net crc32c_intel floppy ata_piix virtio_pci libata virtio_ring virtio sunrpc dm_mirror dm_region_hash dm_log dm_multipath dm_mod
>> [  170.564500] CPU: 2 PID: 2255 Comm: systemd-udevd Not tainted 4.3.0-rc3 #1
>> [  170.566078] Hardware name: 
>> [  170.567655] task: ffff88002c729580 ti: ffff8802212e8000 task.ti: ffff8802212e8000
>> [  170.569320] RIP: 0010:[<ffffffff811dce0a>]  [<ffffffff811dce0a>] kmem_cache_alloc_trace+0x7a/0x1f0
>> [  170.571208] RSP: 0018:ffff8802212ebe40  EFLAGS: 00010282
>> [  170.572715] RAX: 0000000000000000 RBX: 00000000000080d0 RCX:
>> 0000000000017622
>> [  170.574461] RDX: 0000000000017621 RSI: 00000000000080d0 RDI:
>> ffff880237001800
>> [  170.576148] RBP: ffff8802212ebe78 R08: 000000000001a160 R09:
>> ffff8800afda5460
>> [  170.577902] R10: ffffffff81206740 R11: 0000000000000202 R12:
>> 00000000000080d0
>> [  170.579530] R13: ffff880237001800 R14: 0000001028000000 R15:
>> ffff880237001800
>> [  170.581276] FS:  00007fd7236ae880(0000) GS:ffff88023fd00000(0000)
>> knlGS:0000000000000000
>> [  170.583110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  170.584596] CR2: 0000001028000000 CR3: 0000000225199000 CR4:
>> 00000000001406e0
>> [  170.586320] Stack:
>> [  170.587495]  ffffffff81206740 0000000000000088 ffff8800bb1cec60
>> ffff8802212ebf28
>> [  170.589280]  0000000000000800 ffff8802212ebf20 0000558c20687b50
>> ffff8802212ebe90
>> [  170.591131]  ffffffff81206740 ffff8800bb1cec60 ffff8802212ebed8
>> ffffffff81206c56
>> [  170.592929] Call Trace:
>> [  170.594228]  [<ffffffff81206740>] ? alloc_pipe_info+0x20/0xb0
>> [  170.595895]  [<ffffffff81206740>] alloc_pipe_info+0x20/0xb0
>> [  170.597637]  [<ffffffff81206c56>] create_pipe_files+0x56/0x230
>> [  170.599337]  [<ffffffff8112408f>] ? __audit_syscall_entry+0xaf/0x100
>> [  170.601071]  [<ffffffff81206e64>] __do_pipe_flags+0x34/0xe0
>> [  170.602688]  [<ffffffff81206faf>] SyS_pipe2+0x2f/0xb0
>> [  170.604215]  [<ffffffff816859ae>] entry_SYSCALL_64_fastpath+0x12/0x71
>> [  170.605863] Code: 4c 03 05 2a d3 e2 7e 4d 8b 30 49 8b 40 10 4d 85 f6 0f 84 22 01 00 00 48 85 c0 0f 84 19 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49> 8b 1c 06 4c 89 f0 65 49 0f c7 08 0f 94 c0 84 c0 74 b9 49 63 
>> [  170.610895] RIP  [<ffffffff811dce0a>] kmem_cache_alloc_trace+0x7a/0x1f0
>> [  170.612728]  RSP <ffff8802212ebe40>
>> [  170.614244] CR2: 0000001028000000
>> [  170.615745] ---[ end trace 02faa1e1a864f6bd ]---
>> [  170.617351] Kernel panic - not syncing: Fatal exception
>> [  170.619462] Kernel Offset: disabled
>> [  170.620946] ---[ end Kernel panic - not syncing: Fatal exception


Attached below is a sample reproducer for ALUA capable storage.

--- cut here --
#!/bin/bash

# Set appropriate values for your storage
hostno=2
host=host${hostno}
dev=${hostno}:0:0:0

service multipathd stop
multipath -F

n=1
while true; do
	echo "== loop $n ==" > /dev/kmsg

	echo "-- scan $host --" > /dev/kmsg
	echo '- - -' > /sys/class/scsi_host/${host}/scan

	echo "-- activate $dev --" > /dev/kmsg
	echo activate > /sys/class/scsi_device/${dev}/device/dh_state &

	echo "-- delete $dev --" > /dev/kmsg
	echo 1 > /sys/class/scsi_device/${dev}/device/delete

	n=$((n + 1))
done
--- cut here --

# lsscsi
[0:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     1.5.  /dev/sr0 
[2:0:0:0]    disk    LIO-ORG  VirtioDisk       4.0   /dev/sda 
# ./a.sh

<system crash>

-- 
Jun'ichi Nomura, NEC Corporation