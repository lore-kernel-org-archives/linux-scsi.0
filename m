From: John Drescher <drescherjm@gmail.com>
Subject: Re: Possible mptsas regression post 3.5.0
Date: Tue, 28 Aug 2012 10:03:27 -0400
Message-ID: <CAEhu1-6nKpX=tqES95AsPn-yFioS8-5+mcU1maSYh0AozVT5PA@mail.gmail.com>
References: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
	<CAEhu1-5VLuFsZomDZ1yxixqD7oLEhoXs+N698_VBkdGz5trK8g@mail.gmail.com>
	<CAEhu1-5sHQOTZ=KRxkpiAeBFC5BReR+svUGpp=9tk3drqJNg0A@mail.gmail.com>
	<CAD9gYJJQ+vsv12+-0e_nMtgs71Snvt4j2s48-HnwkrV2yOiwLQ@mail.gmail.com>
	<CAEhu1-7zGeZ-A0hkJ0=PqJart8f1zGyapWo-DP0fORuNTpj0sg@mail.gmail.com>
	<1346132253.12384.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63265 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab2H1OD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 10:03:29 -0400
In-Reply-To: <1346132253.12384.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

> I wonder if we are preventing scsi_device_dev_release_usercontext() from
> making forward progress?
>
> ...the attached patch should confirm this or give more info otherwise.
>

[  148.960318] console [netcon0] enabled
[  148.960363] netconsole: network logging started
[  170.415487] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00) cb_idx mptbase_reply
[  174.739904] mptbase: ioc0: LogInfo(0x31110d00): Originator={PL},
Code={Reset}, SubCode(0x0d00) cb_idx mptscsih_io_done
[  174.747449] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  174.747520] sd 0:0:0:0: [sda] Unhandled error code
[  174.747566] sd 0:0:0:0: [sda]
[  174.747586] sd 0:0:0:0: [sda]
[  174.747587] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  174.747746] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[  174.747841] scsi 0:0:0:0: [sda] CDB:
[  174.747931] Read(10): 28 00 00 20 ec 08 00 00 08 00
[  174.748375] end_request: I/O error, dev sda, sector 2157576
[  174.751387] md/raid1:md0: Disk failure on sda1, disabling device.
[  174.751387] md/raid1:md0: Operation continuing on 9 devices.
[  174.751448] md/raid:md1: Disk failure on sda2, disabling device.
[  174.751448] md/raid:md1: Operation continuing on 11 devices.
[  174.758218] scsi_remove_target[0]: reap 0:0 state: 2 reap: 1 dev_del: 1
[  199.724758] BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
[  199.724855] Modules linked in: netconsole configfs w83627ehf
hwmon_vid autofs4 coretemp hwmon kvm_intel kvm i2c_i801 i2c_core
pcspkr e1000e microcode lpc_ich mfd_core video button xts gf128mul
aes_x86_64 aes_generic cbc sha256_generic e1000 nfs lockd fscache
auth_rpcgss nfs_acl sunrpc reiserfs multipath linear raid0 dm_raid
dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log scsi_wait_scan
sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd megaraid_sas
megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod sata_mv
ata_piix ahci libahci pata_marvell pata_mpiix libata
[  199.727536] CPU 2
[  199.727576] Modules linked in:[  199.727699]  netconsole configfs
w83627ehf hwmon_vid autofs4 coretemp hwmon kvm_intel kvm i2c_i801
i2c_core pcspkr e1000e microcode lpc_ich mfd_core video button xts
gf128mul aes_x86_64 aes_generic cbc sha256_generic e1000 nfs lockd
fscache auth_rpcgss nfs_acl sunrpc reiserfs multipath linear raid0
dm_raid dm_snapshot dm_crypt dm_mirror dm_region_hash dm_log
scsi_wait_scan sl811_hcd ohci_hcd uhci_hcd usb_storage ehci_hcd
megaraid_sas megaraid_mbox megaraid_mm megaraid sr_mod cdrom sd_mod
sata_mv ata_piix ahci libahci[  199.731316] R10: 0000000000000001 R11:
0000000000000000 R12: ffff8802222bc460
 ffff8802230e0400 ffff8802232df010
[  199.732875]  ffff880222defb00 ffffffff81417974 ffff880200000001
ffff880200000001
[  199.733164] Call Trace:
[  199.733255]  [<ffffffff8141503d>] scsi_target_reap+0x7d/0x100
[  199.733355]  [<ffffffff81417974>] scsi_remove_target+0x224/0x300
[  199.733455]  [<ffffffff81421ef5>] sas_rphy_remove+0x55/0x60
[  199.733554]  [<ffffffff81421f11>] sas_rphy_delete+0x11/0x20
[  199.733652]  [<ffffffff81421f45>] sas_port_delete+0x25/0x160
[  199.733749]  [<ffffffff81454ab3>] mptsas_del_end_device+0x183/0x270
[  199.733848]  [<ffffffff81458f6c>] mptsas_hotplug_work+0x1ec/0x920
[  199.733945]  [<ffffffff814531fb>] ? mptsas_free_fw_event+0x6b/0xb0
[  199.734042]  [<ffffffff81061e95>] ? sched_clock_cpu+0xc5/0x120
[  199.734138]  [<ffffffff8145a760>] mptsas_firmware_event_work+0xbc0/0xfa0
[  199.734238]  [<ffffffff81080d0f>] ? __lock_acquire.isra.27+0x29f/0xb30
[  199.734335]  [<ffffffff81459ba0>] ? mptsas_expander_add+0x140/0x140
[  199.734433]  [<ffffffff81459ba0>] ? mptsas_expander_add+0x140/0x140
[  199.734534]  [<ffffffff8104c474>] process_one_work+0x184/0x460
[  199.734632]  [<ffffffff8104c416>] ? process_one_work+0x126/0x460
[  199.734731]  [<ffffffff8104cd4e>] worker_thread+0x15e/0x350
[  199.734830]  [<ffffffff8104cbf0>] ? manage_workers.isra.31+0x220/0x220
[  199.734930]  [<ffffffff81051f9d>] kthread+0x9d/0xb0
[  199.735028]  [<ffffffff815cfdd4>] kernel_thread_helper+0x4/0x10
[  199.735127]  [<ffffffff81051f00>] ? __init_kthread_worker+0x70/0x70
[  199.735224]  [<ffffffff815cfdd0>] ? gs_change+0xb/0xb
[  199.735317] Code: 10 48 8b 55 08 48 89 5d f0 48 89 f3 4c 89 65 f8
be 01 00 00 00 49
