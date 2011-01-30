From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: 2.6.38-rc2+ tcm_mvsas kernel oops
Date: Sun, 30 Jan 2011 13:34:07 -0800
Message-ID: <1296423247.14831.321.camel@haakon2.linux-iscsi.org>
References: <AANLkTinUu81OtTud=GZcJwGRHn1REJQ+ROoRygF4pKM1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35432 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1A3VeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Jan 2011 16:34:11 -0500
In-Reply-To: <AANLkTinUu81OtTud=GZcJwGRHn1REJQ+ROoRygF4pKM1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2011-01-30 at 20:02 +0100, Fubo Chen wrote:
> Hello,
> 
> Today I did what I should have done before: try to load and unload
> tcm_mvsas kernel module. Surprised to see that this triggered kernel
> oops. Did I make stupid mistake ?
> 

Hi Fubo,

> What I did:
> 
> # rm -rf drivers/target/tcm_mvsas
> # cd Documentation/target
> # { echo yes; echo yes; } | ./tcm_mod_builder.py -m tcm_mvsas -p SAS
> # cd ../..
> # echo m | make oldconfig
> # make prepare

FYI, you do not need to be calling make oldconfig + prepare each time to
rebuild a single fabric module like tcm_mvsas.ko

> # make M=drivers/target/tcm_mvsas modules modules_install
> # modprobe tcm_mvsas

What happened to 'modprobe target_core_mod' before loading tcm_mvsas..?

Typically if you are running 'make oldconfig' and change your .config,
you need to be running a matched set of modules, and not something that
was potentially built from a different .config.

> # rmmod tcm_mvsas
> # rmmod target_core_mod
> Segmentation fault
> 
> >From console:
> 
> <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
> Initialized struct target_fabric_configfs: ffff880027680000 for mvsas
> <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
> TCM_MVSAS[0] - Set fabric -> tcm_mvsas_fabric_configfs
> <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
> Target_Core_ConfigFS: DEREGISTER -> Releasing tf: mvsas
> <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
> TCM_MVSAS[0] - Cleared tcm_mvsas_fabric_configfs
> general protection fault: 0000 [#1] SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-0:1.0/uevent
> CPU 0
> Modules linked in: target_core_mod(-) configfs netconsole iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi binfmt_misc psmouse
> serio_raw shpchp i2c_piix4 mptspi mptscsih mptbase scsi_transport_spi
> e1000 floppy [last unloaded: tcm_mvsas]
> 
> Pid: 2346, comm: rmmod Not tainted 2.6.38-rc2+
> RIP: 0010:[<ffffffff810946a4>]  [<ffffffff810946a4>] __lock_acquire+0x64/0x1510
> RSP: 0018:ffff8800275cdb18  EFLAGS: 00010046
> RAX: 0000000000000046 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff8800275cdbe8 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88002cb4a350
> FS:  00007f9238be4700(0000) GS:ffff88003d600000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007f92386d1fc0 CR3: 0000000027560000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process rmmod (pid: 2346, threadinfo ffff8800275cc000, task ffff88002cb4a350)
> Stack:
>  0000000000000004 ffff88002cb4a350 ffffffff82033ee0 ffffffff81010dfd
>  ffff8800275cdb68 ffffffff81ed1590 ffff8800275cdb68 0000000000000000
>  32a19d8cf067a674 ffff88002cb4ab08 ffff8800275cdc48 0000000000000002
> Call Trace:
>  [<ffffffff81010dfd>] ? save_stack_trace+0x2d/0x50
>  [<ffffffff81095bf0>] lock_acquire+0xa0/0x150
>  [<ffffffffa0146f8f>] ? detach_groups+0x2f/0x120 [configfs]
>  [<ffffffff81545a04>] ? __mutex_lock_common+0x2a4/0x3e0
>  [<ffffffffa0147004>] ? detach_groups+0xa4/0x120 [configfs]
>  [<ffffffff815472b6>] _raw_spin_lock+0x36/0x70
>  [<ffffffffa0146f8f>] ? detach_groups+0x2f/0x120 [configfs]
>  [<ffffffffa0146f8f>] detach_groups+0x2f/0x120 [configfs]
>  [<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>  [<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>  [<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>  [<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>  [<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>  [<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>  [<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>  [<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>  [<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>  [<ffffffffa0147122>] configfs_unregister_subsystem+0xa2/0x130 [configfs]
>  [<ffffffffa014fc84>] target_core_exit_configfs+0x184/0x1c0 [target_core_mod]
>  [<ffffffff810a0a32>] sys_delete_module+0x1a2/0x280
>  [<ffffffff81547019>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81002f82>] system_call_fastpath+0x16/0x1b
> Code: 8b 05 a1 64 9a 00 4c 89 75 f0 48 89 fb 41 89 d5 4c 8b 55 10 45
> 85 c0 0f 84 4a 04 00 00 8b 3d 08 96 cd 00 85 ff 0f 84 5c 04 00 00 <48>
> 81 3b 20 15 dd 81 b8 01 00 00 00 44 0f 44 e0 83 fe 01 0f 86
> RIP  [<ffffffff810946a4>] __lock_acquire+0x64/0x1510
>  RSP <ffff8800275cdb18>
> ---[ end trace f4ddfaa61a61623b ]---
> 
> 

Ok, just to verify.  I have tried a couple varitions of the following
after generating a fresh 'tcm_mvsas' fabric skeleton on
lio-core-2.6.git/linus-38-rc2:

while [ 1 ]; do modprobe target_core_mod ; sleep 1 ; modprobe
tcm_mvsas ; rmmod tcm_mvsas ; rmmod target_core_mod; done

and nothing out of the ordinary appers with .38-rc2 target code on
x86_64 VM while this runs so far..

Did something change in your .config between the running target_core_mod
and newly built tcm_mvsas.ko that could cause a GFP like this..?

Please verify your 'rmmod tcm_mvsas' test with a single set of .config
options and rebuild + reboot with:

	make clean ; make bzImage ; make modules ; make modules_install ; make install

Thanks,

--nab

