From: John Drescher <drescherjm@gmail.com>
Subject: Re: Possible mptsas regression post 3.5.0
Date: Mon, 27 Aug 2012 12:13:02 -0400
Message-ID: <CAEhu1-7zGeZ-A0hkJ0=PqJart8f1zGyapWo-DP0fORuNTpj0sg@mail.gmail.com>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
	<CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
	<CAEhu1-5sHQOTZ=KRxkpiAeBFC5BReR+svUGpp=9tk3drqJNg0A@mail.gmail.com>
	<CAD9gYJJQ+vsv12+-0e_nMtgs71Snvt4j2s48-HnwkrV2yOiwLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45010 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2H0QNF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Aug 2012 12:13:05 -0400
In-Reply-To: <CAD9gYJJQ+vsv12+-0e_nMtgs71Snvt4j2s48-HnwkrV2yOiwLQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?546L6YeR5rWm?= <jinpuwang@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, djbw@fb.com, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

>> I have bisected it down to the following patch:
>>
>> Bisecting: 0 revisions left to test after this (roughly 0 steps)
>> [10f8d5b86743b33d841a175303e2bf67fd620f42] SCSI: fix hot unplug vs
>> async scan race
>>
>> It appears this patch caused the bad behavior although I have not
>> tested that yet. I am rebuilding the array (takes ~2 hours) from the
>> previous good bisect.
>>

Confirmed. This patch appears to cause the bug in my test setup.

[  291.808375] netpoll: netconsole: local IP 192.168.2.91
[  291.808614] console [netcon0] enabled
[  291.808614] netconsole: network logging started
[  308.643881] mptbase: ioc1: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00) cb_idx mptbase_reply
[  312.882907] sd 1:0:2:0: [sdj] Synchronizing SCSI cache
[  312.883044] sd 1:0:2:0: [sdj]
[  312.883088] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  312.887098] md/raid1:md0: Disk failure on sdj1, disabling device.
[  312.887098] md/raid1:md0: Operation continuing on 9 devices.
[  312.887226] md/raid:md1: Disk failure on sdj2, disabling device.
[  312.887226] md/raid:md1: Operation continuing on 11 devices.
[  339.406778] BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
[  339.406876] Modules linked in: netconsole configfs w83627ehf
hwmon_vid autofs4 coretemp hwmon kvm_intel kvm i2c_i801 i2c_core
microcode pcspkr lpc_ich mfd_core e1000e video button xts gf128mul
aes_x86_64 aes_generic cbc sha256_generic e1000 nfs lockd fscache
auth_rpcgss nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid
dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log scsi_wait_scan
sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd megaraid_sas
megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod sata_mv
ata_piix ahci libahci pata_marvell pata_mpiix libata
[  339.409581] CPU 2
[  339.409621] Modules linked in:[  339.409745]  netconsole configfs
w83627ehf hwmon_vid autofs4 coretemp hwmon kvm_intel kvm i2c_i801
i2c_core microcode pcspkr lpc_ich mfd_core e1000e video button xts
gf128mul aes_x86_64 aes_generic cbc sha256_generic e1000 nfs lockd
fscache auth_rpcgss nfs_acl sunrpc reiserfs multipath linear raid0
dm_raid dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd
megaraid_sas megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod
sata_mv ata_piix ahci libahci pata_marvell pata_mpiix libata

[  339.412474] Pid: 2202, comm: kworker/u:8 Not tainted
3.5.0-bisect-7-00014-g10f8d5b #8 To be filled by O.E.M. To be filled
by O.E.M./P8B-X series
[  339.412739] RIP: 0010:[<ffffffff815c8282>]  [<ffffffff815c8282>]
_raw_spin_unlock_irqrestore+0x32/0x40
[  339.412928] RSP: 0018:ffff880222267aa0  EFLAGS: 00000282
[  339.413022] RAX: 0000000000000002 RBX: ffff880222267a50 RCX: 000000000000b828
[  339.413120] RDX: 0000000000002e40 RSI: ffff880226a00000 RDI: ffff8802233f2090
[  339.413218] RBP: ffff880222267ab0 R08: 0000000000000001 R09: 0000000000000000
[  339.413317] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88021ea94460
[  339.413418] R13: 0000000000000082 R14: ffff880222267a20 R15: ffff8802233f20a8
[  339.413519] FS:  0000000000000000(0000) GS:ffff880226a00000(0000)
knlGS:0000000000000000
[  339.413672] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  339.413769] CR2: 00007feeee723ea0 CR3: 0000000001a0b000 CR4: 00000000000407e0
[  339.413870] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  339.413970] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  339.414069] Process kworker/u:8 (pid: 2202, threadinfo
ffff880222266000, task ffff88021ea94460)
[  339.414219] Stack:
[  339.414306]  ffff880222c3d000 ffff8802233f1ff0 ffff880222267b00
ffffffff8141782a
[  339.414593]  0000000000000282 ffff8802233f2000 0000000000000046
ffff880222c3b800
[  339.414884]  0000000000000008 ffff8802233865c0 ffff8802233d2000
1221000004000000
[  339.415175] Call Trace:
[  339.415268]  [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
[  339.415368]  [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
[  339.415463]  [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
[  339.415561]  [<ffffffff81421e35>] sas_port_delete+0x25/0x160
[  339.415660]  [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270
[  339.415757]  [<ffffffff81458e5c>] mptsas_hotplug_work+0x1ec/0x920
[  339.415854]  [<ffffffff814530eb>] ? mptsas_free_fw_event+0x6b/0xb0
[  339.415952]  [<ffffffff81061e95>] ? sched_clock_cpu+0xc5/0x120
[  339.416047]  [<ffffffff8145a650>] mptsas_firmware_event_work+0xbc0/0xfa0
[  339.416147]  [<ffffffff81080d0f>] ? __lock_acquire.isra.27+0x29f/0xb30
[  339.416244]  [<ffffffff81459a90>] ? mptsas_expander_add+0x140/0x140
[  339.416342]  [<ffffffff81459a90>] ? mptsas_expander_add+0x140/0x140
[  339.416442]  [<ffffffff8104c474>] process_one_work+0x184/0x460
[  339.416541]  [<ffffffff8104c416>] ? process_one_work+0x126/0x460
[  339.416641]  [<ffffffff8104cd4e>] worker_thread+0x15e/0x350
[  339.416739]  [<ffffffff8104cbf0>] ? manage_workers.isra.31+0x220/0x220
[  339.416841]  [<ffffffff81051f9d>] kthread+0x9d/0xb0
[  339.416939]  [<ffffffff815cfcd4>] kernel_thread_helper+0x4/0x10
[  339.417035]  [<ffffffff81051f00>] ? __init_kthread_worker+0x70/0x70
[  339.417133]  [<ffffffff815cfcd0>] ? gs_change+0xb/0xb
[  339.417229] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49 89 fc 48 8d 7f 18 e8 68 a8 ab ff 4c 89 e7 e8 d0 8f
