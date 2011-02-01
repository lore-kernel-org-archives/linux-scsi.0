From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: 2.6.38-rc2+ tcm_mvsas kernel oops
Date: Tue, 1 Feb 2011 18:55:01 +0100
Message-ID: <AANLkTikmvwUHzGZ3TT7Af9nyH+rV1Jrv6jNbLYKPuXtN@mail.gmail.com>
References: <AANLkTinUu81OtTud=GZcJwGRHn1REJQ+ROoRygF4pKM1@mail.gmail.com>
	<1296423247.14831.321.camel@haakon2.linux-iscsi.org>
	<AANLkTi=j94Wj_sdsm2sfwA+XSxh1QFhOPpbFJ_fim3sL@mail.gmail.com>
	<1296507316.14831.409.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42810 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1BARzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2011 12:55:01 -0500
Received: by iyj18 with SMTP id 18so6193756iyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 01 Feb 2011 09:55:01 -0800 (PST)
In-Reply-To: <1296507316.14831.409.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jan 31, 2011 at 9:55 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> [ ... ]
>
> Hmmm, I don't see how this would make a difference, and FYI the above
> test loops for 'rmmod tcm_mvsas' where running with slub_debug=FZ w/o
> issue.
>
> Well, if you are certain things are working fine on .37-FINAL, you can
> try using 'git bisect' from a known working LIO .37 commit and build
> +test until you locate an offending commit.
>
> But again, this appears to be working in lio-core-2.6.git/linus-38-rc2,
> please verify this is what is being tested..?

Thanks for looking at this. This is what I get with v2.6.38-rc2,
tcm_mvsas and slub poisoning:

# cat /proc/cmdline
BOOT_IMAGE=/boot/vmlinuz-2.6.38-rc2
root=UUID=c2d91556-8ed3-4a2a-95d9-50d0203bcfcc ro quiet splash
slub_debug=FPUZ
# modprobe tcm_mvsas
# rmmod tcm_mvsas
# rmmod target_core_mod
Segmentation fault

and on the console:

<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Initialized struct target_fabric_configfs: ffff880025e09090 for mvsas
<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
TCM_MVSAS[0] - Set fabric -> tcm_mvsas_fabric_configfs
<<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
Target_Core_ConfigFS: DEREGISTER -> Releasing tf: mvsas
<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
TCM_MVSAS[0] - Cleared tcm_mvsas_fabric_configfs
general protection fault: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-0:1.0/uevent
CPU 0
Modules linked in: target_core_mod(-) configfs netconsole iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi binfmt_misc psmouse
serio_raw i2c_piix4 shpchp mptspi mptscsih e1000 mptbase
scsi_transport_spi floppy [last unloaded: tcm_mvsas]

Pid: 1432, comm: rmmod Not tainted 2.6.38-rc2 #4 440BX Desktop
Reference Platform/VMware Virtual Platform
RIP: 0010:[<ffffffff81094684>]  [<ffffffff81094684>] __lock_acquire+0x64/0x1510
RSP: 0018:ffff880022697b18  EFLAGS: 00010046
RAX: 0000000000000046 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff880022697be8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88002a1a2350
FS:  00007f844069c700(0000) GS:ffff88003d600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f8440189fc0 CR3: 0000000025d67000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rmmod (pid: 1432, threadinfo ffff880022696000, task ffff88002a1a2350)
Stack:
 0000000000000004 ffff88002a1a2350 ffffffff82030820 ffffffff81010dfd
 ffff880022697b68 ffffffff81ed0590 ffff880022697b68 0000000000000000
 3161938ca065261c ffff88002a1a2b08 ffff880022697c48 0000000000000002
Call Trace:
 [<ffffffff81010dfd>] ? save_stack_trace+0x2d/0x50
 [<ffffffff81095bd0>] lock_acquire+0xa0/0x150
 [<ffffffffa00e5f7f>] ? detach_groups+0x2f/0x120 [configfs]
 [<ffffffff81540f44>] ? __mutex_lock_common+0x2a4/0x3e0
 [<ffffffffa00e5ff4>] ? detach_groups+0xa4/0x120 [configfs]
 [<ffffffff815427f6>] _raw_spin_lock+0x36/0x70
 [<ffffffffa00e5f7f>] ? detach_groups+0x2f/0x120 [configfs]
 [<ffffffffa00e5f7f>] detach_groups+0x2f/0x120 [configfs]
 [<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
 [<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
 [<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
 [<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
 [<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
 [<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
 [<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
 [<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
 [<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
 [<ffffffffa00e6112>] configfs_unregister_subsystem+0xa2/0x130 [configfs]
 [<ffffffffa00efc84>] target_core_exit_configfs+0x184/0x1c0 [target_core_mod]
 [<ffffffff810a0a12>] sys_delete_module+0x1a2/0x280
 [<ffffffff81542559>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81002f82>] system_call_fastpath+0x16/0x1b
Code: 8b 05 c1 64 9a 00 4c 89 75 f0 48 89 fb 41 89 d5 4c 8b 55 10 45
85 c0 0f 84 4a 04 00 00 8b 3d 28 86 cd 00 85 ff 0f 84 5c 04 00 00 <48>
81 3b 20 05 dd 81 b8 01 00 00 00 44 0f 44 e0 83 fe 01 0f 86
RIP  [<ffffffff81094684>] __lock_acquire+0x64/0x1510
 RSP <ffff880022697b18>
---[ end trace 4abcf014267c1c85 ]---
