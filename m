From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: 2.6.38-rc2+ tcm_mvsas kernel oops
Date: Mon, 31 Jan 2011 18:21:35 +0100
Message-ID: <AANLkTi=j94Wj_sdsm2sfwA+XSxh1QFhOPpbFJ_fim3sL@mail.gmail.com>
References: <AANLkTinUu81OtTud=GZcJwGRHn1REJQ+ROoRygF4pKM1@mail.gmail.com>
	<1296423247.14831.321.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37194 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab1AaRVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2011 12:21:36 -0500
Received: by iwn9 with SMTP id 9so5592840iwn.19
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2011 09:21:35 -0800 (PST)
In-Reply-To: <1296423247.14831.321.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Jan 30, 2011 at 10:34 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Sun, 2011-01-30 at 20:02 +0100, Fubo Chen wrote:
>> [ ... ]
>> # make M=3Ddrivers/target/tcm_mvsas modules modules_install
>> # modprobe tcm_mvsas
>
> What happened to 'modprobe target_core_mod' before loading tcm_mvsas.=
=2E?

'modprobe tcm_mvsas' loads target_core_mod automatically as far as i kn=
ow ?

> Typically if you are running 'make oldconfig' and change your .config=
,
> you need to be running a matched set of modules, and not something th=
at
> was potentially built from a different .config.
>
>> # rmmod tcm_mvsas
>> # rmmod target_core_mod
>> Segmentation fault
>>
>> >From console:
>>
>> <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> Initialized struct target_fabric_configfs: ffff880027680000 for mvsa=
s
>> <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> TCM_MVSAS[0] - Set fabric -> tcm_mvsas_fabric_configfs
>> <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> Target_Core_ConfigFS: DEREGISTER -> Releasing tf: mvsas
>> <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> TCM_MVSAS[0] - Cleared tcm_mvsas_fabric_configfs
>> general protection fault: 0000 [#1] SMP
>> last sysfs file:
>> /sys/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-0:1.0/ueven=
t
>> CPU 0
>> Modules linked in: target_core_mod(-) configfs netconsole iscsi_tcp
>> libiscsi_tcp libiscsi scsi_transport_iscsi binfmt_misc psmouse
>> serio_raw shpchp i2c_piix4 mptspi mptscsih mptbase scsi_transport_sp=
i
>> e1000 floppy [last unloaded: tcm_mvsas]
>>
>> Pid: 2346, comm: rmmod Not tainted 2.6.38-rc2+
>> RIP: 0010:[<ffffffff810946a4>] =A0[<ffffffff810946a4>] __lock_acquir=
e+0x64/0x1510
>> RSP: 0018:ffff8800275cdb18 =A0EFLAGS: 00010046
>> RAX: 0000000000000046 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: ffff8800275cdbe8 R08: 0000000000000001 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
>> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88002cb4a350
>> FS: =A000007f9238be4700(0000) GS:ffff88003d600000(0000) knlGS:000000=
0000000000
>> CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007f92386d1fc0 CR3: 0000000027560000 CR4: 00000000000006f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process rmmod (pid: 2346, threadinfo ffff8800275cc000, task ffff8800=
2cb4a350)
>> Stack:
>> =A00000000000000004 ffff88002cb4a350 ffffffff82033ee0 ffffffff81010d=
fd
>> =A0ffff8800275cdb68 ffffffff81ed1590 ffff8800275cdb68 00000000000000=
00
>> =A032a19d8cf067a674 ffff88002cb4ab08 ffff8800275cdc48 00000000000000=
02
>> Call Trace:
>> =A0[<ffffffff81010dfd>] ? save_stack_trace+0x2d/0x50
>> =A0[<ffffffff81095bf0>] lock_acquire+0xa0/0x150
>> =A0[<ffffffffa0146f8f>] ? detach_groups+0x2f/0x120 [configfs]
>> =A0[<ffffffff81545a04>] ? __mutex_lock_common+0x2a4/0x3e0
>> =A0[<ffffffffa0147004>] ? detach_groups+0xa4/0x120 [configfs]
>> =A0[<ffffffff815472b6>] _raw_spin_lock+0x36/0x70
>> =A0[<ffffffffa0146f8f>] ? detach_groups+0x2f/0x120 [configfs]
>> =A0[<ffffffffa0146f8f>] detach_groups+0x2f/0x120 [configfs]
>> =A0[<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>> =A0[<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>> =A0[<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>> =A0[<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>> =A0[<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>> =A0[<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>> =A0[<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>> =A0[<ffffffffa0147012>] detach_groups+0xb2/0x120 [configfs]
>> =A0[<ffffffffa0146f46>] configfs_detach_group+0x16/0x30 [configfs]
>> =A0[<ffffffffa0147122>] configfs_unregister_subsystem+0xa2/0x130 [co=
nfigfs]
>> =A0[<ffffffffa014fc84>] target_core_exit_configfs+0x184/0x1c0 [targe=
t_core_mod]
>> =A0[<ffffffff810a0a32>] sys_delete_module+0x1a2/0x280
>> =A0[<ffffffff81547019>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> =A0[<ffffffff81002f82>] system_call_fastpath+0x16/0x1b
>> Code: 8b 05 a1 64 9a 00 4c 89 75 f0 48 89 fb 41 89 d5 4c 8b 55 10 45
>> 85 c0 0f 84 4a 04 00 00 8b 3d 08 96 cd 00 85 ff 0f 84 5c 04 00 00 <4=
8>
>> 81 3b 20 15 dd 81 b8 01 00 00 00 44 0f 44 e0 83 fe 01 0f 86
>> RIP =A0[<ffffffff810946a4>] __lock_acquire+0x64/0x1510
>> =A0RSP <ffff8800275cdb18>
>> ---[ end trace f4ddfaa61a61623b ]---
>>
>>
>
> Ok, just to verify. =A0I have tried a couple varitions of the followi=
ng
> after generating a fresh 'tcm_mvsas' fabric skeleton on
> lio-core-2.6.git/linus-38-rc2:
>
> while [ 1 ]; do modprobe target_core_mod ; sleep 1 ; modprobe
> tcm_mvsas ; rmmod tcm_mvsas ; rmmod target_core_mod; done
>
> and nothing out of the ordinary appers with .38-rc2 target code on
> x86_64 VM while this runs so far..
>
> Did something change in your .config between the running target_core_=
mod
> and newly built tcm_mvsas.ko that could cause a GFP like this..?
>
> Please verify your 'rmmod tcm_mvsas' test with a single set of .confi=
g
> options and rebuild + reboot with:
>
> =A0 =A0 =A0 =A0make clean ; make bzImage ; make modules ; make module=
s_install ; make install

Thanks for hint. I have rebuilt kernel but unfortunately crash still
occurs. Maybe it's because I have enabled SLUB poisoning ?

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
