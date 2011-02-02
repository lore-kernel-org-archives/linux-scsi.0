From: Fubo Chen <fubo.chen@gmail.com>
Subject: Re: 2.6.38-rc2+ tcm_mvsas kernel oops
Date: Wed, 2 Feb 2011 18:53:33 +0100
Message-ID: <AANLkTinBkoNxJ_CSDeOdLFjnyBTvQRyiOGVkQA=s6eVQ@mail.gmail.com>
References: <AANLkTinUu81OtTud=GZcJwGRHn1REJQ+ROoRygF4pKM1@mail.gmail.com>
	<1296423247.14831.321.camel@haakon2.linux-iscsi.org>
	<AANLkTi=j94Wj_sdsm2sfwA+XSxh1QFhOPpbFJ_fim3sL@mail.gmail.com>
	<1296507316.14831.409.camel@haakon2.linux-iscsi.org>
	<AANLkTikmvwUHzGZ3TT7Af9nyH+rV1Jrv6jNbLYKPuXtN@mail.gmail.com>
	<1296615678.902.41.camel@haakon2.linux-iscsi.org>
	<1296622003.902.57.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52024 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1BBRxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2011 12:53:35 -0500
Received: by iyj18 with SMTP id 18so195210iyj.19
        for <linux-scsi@vger.kernel.org>; Wed, 02 Feb 2011 09:53:34 -0800 (PST)
In-Reply-To: <1296622003.902.57.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>

On Wed, Feb 2, 2011 at 5:46 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Tue, 2011-02-01 at 19:01 -0800, Nicholas A. Bellinger wrote:
>> On Tue, 2011-02-01 at 18:55 +0100, Fubo Chen wrote:
>> > On Mon, Jan 31, 2011 at 9:55 PM, Nicholas A. Bellinger
>> > <nab@linux-iscsi.org> wrote:
>> > > [ ... ]
>> > >
>> > > Hmmm, I don't see how this would make a difference, and FYI the =
above
>> > > test loops for 'rmmod tcm_mvsas' where running with slub_debug=3D=
=46Z w/o
>> > > issue.
>> > >
>> > > Well, if you are certain things are working fine on .37-FINAL, y=
ou can
>> > > try using 'git bisect' from a known working LIO .37 commit and b=
uild
>> > > +test until you locate an offending commit.
>> > >
>> > > But again, this appears to be working in lio-core-2.6.git/linus-=
38-rc2,
>> > > please verify this is what is being tested..?
>> >
>> > Thanks for looking at this. This is what I get with v2.6.38-rc2,
>> > tcm_mvsas and slub poisoning:
>> >
>> > # cat /proc/cmdline
>> > BOOT_IMAGE=3D/boot/vmlinuz-2.6.38-rc2
>> > root=3DUUID=3Dc2d91556-8ed3-4a2a-95d9-50d0203bcfcc ro quiet splash
>> > slub_debug=3DFPUZ
>> > # modprobe tcm_mvsas
>> > # rmmod tcm_mvsas
>> > # rmmod target_core_mod
>> > Segmentation fault
>> >
>>
>> Thanks for this info.. =A0I am now able to reproduce w/ .38-rc2 usin=
g
>> slub_debug=3DFPUZ.. =A0(More below)
>>
>> > and on the console:
>> >
>> > <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> > Initialized struct target_fabric_configfs: ffff880025e09090 for mv=
sas
>> > <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> > TCM_MVSAS[0] - Set fabric -> tcm_mvsas_fabric_configfs
>> > <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> > Target_Core_ConfigFS: DEREGISTER -> Releasing tf: mvsas
>> > <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
>> > TCM_MVSAS[0] - Cleared tcm_mvsas_fabric_configfs
>> > general protection fault: 0000 [#1] SMP
>> > last sysfs file:
>> > /sys/devices/pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-0:1.0/uev=
ent
>> > CPU 0
>> > Modules linked in: target_core_mod(-) configfs netconsole iscsi_tc=
p
>> > libiscsi_tcp libiscsi scsi_transport_iscsi binfmt_misc psmouse
>> > serio_raw i2c_piix4 shpchp mptspi mptscsih e1000 mptbase
>> > scsi_transport_spi floppy [last unloaded: tcm_mvsas]
>> >
>> > Pid: 1432, comm: rmmod Not tainted 2.6.38-rc2 #4 440BX Desktop
>> > Reference Platform/VMware Virtual Platform
>> > RIP: 0010:[<ffffffff81094684>] =A0[<ffffffff81094684>] __lock_acqu=
ire+0x64/0x1510
>> > RSP: 0018:ffff880022697b18 =A0EFLAGS: 00010046
>> > RAX: 0000000000000046 RBX: 6b6b6b6b6b6b6be3 RCX: 0000000000000000
>> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>> > RBP: ffff880022697be8 R08: 0000000000000001 R09: 0000000000000000
>> > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
>> > R13: 0000000000000000 R14: 0000000000000000 R15: ffff88002a1a2350
>> > FS: =A000007f844069c700(0000) GS:ffff88003d600000(0000) knlGS:0000=
000000000000
>> > CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> > CR2: 00007f8440189fc0 CR3: 0000000025d67000 CR4: 00000000000006f0
>> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> > Process rmmod (pid: 1432, threadinfo ffff880022696000, task ffff88=
002a1a2350)
>> > Stack:
>> > =A00000000000000004 ffff88002a1a2350 ffffffff82030820 ffffffff8101=
0dfd
>> > =A0ffff880022697b68 ffffffff81ed0590 ffff880022697b68 000000000000=
0000
>> > =A03161938ca065261c ffff88002a1a2b08 ffff880022697c48 000000000000=
0002
>> > Call Trace:
>> > =A0[<ffffffff81010dfd>] ? save_stack_trace+0x2d/0x50
>> > =A0[<ffffffff81095bd0>] lock_acquire+0xa0/0x150
>> > =A0[<ffffffffa00e5f7f>] ? detach_groups+0x2f/0x120 [configfs]
>> > =A0[<ffffffff81540f44>] ? __mutex_lock_common+0x2a4/0x3e0
>> > =A0[<ffffffffa00e5ff4>] ? detach_groups+0xa4/0x120 [configfs]
>> > =A0[<ffffffff815427f6>] _raw_spin_lock+0x36/0x70
>> > =A0[<ffffffffa00e5f7f>] ? detach_groups+0x2f/0x120 [configfs]
>> > =A0[<ffffffffa00e5f7f>] detach_groups+0x2f/0x120 [configfs]
>> > =A0[<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
>> > =A0[<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
>> > =A0[<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
>> > =A0[<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
>> > =A0[<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
>> > =A0[<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
>> > =A0[<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
>> > =A0[<ffffffffa00e6002>] detach_groups+0xb2/0x120 [configfs]
>> > =A0[<ffffffffa00e5f36>] configfs_detach_group+0x16/0x30 [configfs]
>> > =A0[<ffffffffa00e6112>] configfs_unregister_subsystem+0xa2/0x130 [=
configfs]
>> > =A0[<ffffffffa00efc84>] target_core_exit_configfs+0x184/0x1c0 [tar=
get_core_mod]
>> > =A0[<ffffffff810a0a12>] sys_delete_module+0x1a2/0x280
>> > =A0[<ffffffff81542559>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>> > =A0[<ffffffff81002f82>] system_call_fastpath+0x16/0x1b
>> > Code: 8b 05 c1 64 9a 00 4c 89 75 f0 48 89 fb 41 89 d5 4c 8b 55 10 =
45
>> > 85 c0 0f 84 4a 04 00 00 8b 3d 28 86 cd 00 85 ff 0f 84 5c 04 00 00 =
<48>
>> > 81 3b 20 05 dd 81 b8 01 00 00 00 44 0f 44 e0 83 fe 01 0f 86
>> > RIP =A0[<ffffffff81094684>] __lock_acquire+0x64/0x1510
>> > =A0RSP <ffff880022697b18>
>> > ---[ end trace 4abcf014267c1c85 ]---
>> > --
>>
>> So this is coming from target_core_exit_configfs() ->
>> configfs_unregister_system() from a simple 'modprobe target_core_mo =
;
>> rmmod target_core_mod' with slub_debug=3DFPUZ..
>>
>> It appears to be related to the TCM top level struct
>> configfs_subsystem->su_group->default_groups[], which we setup in
>> target_core_init_configfs() and from which are released individually=
 in
>> target_core_exit_configfs() before calling configfs_unregister_syste=
m().
>>
>> Note that target_core_exit_configfs() is following the same logic as
>> default_groups for non struct configfs_subsystem backed groups, so I=
 am
>> thinking this is going to be the root culprit.
>>
>> After a quick test w/o the above subsys->su_group.default_groups
>> allocation/release (and the rest of the top level cg->default_groups=
[]
>> disabled), the GFP no longer appears. =A0They appear to be coming mo=
re
>> than a single stale struct configfs_dirent->s_children from the top
>> level TCM default groups attached fs/configfs/dir.c:detach_groups().
>> (jlbec CC'ed)
>>
>> I am still looking at what is the expected way to handle multiple
>> default_groups (including a default_group with children) with struct
>> configfs_subsystem deregister() in fs/configfs/dir.c code, and will =
send
>> a followup later this evening.
>>
>> Thanks again for your report,
>>
>
> Ok, after some more research and testing there appears to be two issu=
es
> in target_core_exit_configfs() wrt to default groups. =A0First, the c=
all
> to configfs_unregister_subsystem() is expected to drain top level str=
uct
> configfs_subsystem->su_group.default_groups[] in fs/configfs/dir.c:
> configfs_unregister_subsystem() -> unlink_group(), and not directly b=
y
> the configfs consumer.
>
> These second issue is core_alua_free_lu_gp(se_global->default_lu_gp)
> releasing default_lu_gp->lun_group before lu_gp_cg->default_groups is
> drained.
>
> Here the change that is now resolving the issue on my end with .38-rc=
2
> using slub_debug=3DFPUZ, and I will send out a proper patch for
> lio-core-2.6.git/linus-38-rc2 shortly.. =A0Please verify this works f=
or
> you.

yes, this works forme. Thank you !

=46ubo.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
