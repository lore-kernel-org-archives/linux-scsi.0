From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
Subject: [PATCH] scsi_transport_fc: cancel scan work always before freeing
 fc_rport.
Date: Mon, 07 Dec 2015 11:00:29 +0100
Message-ID: <566558BD.4040004@open-e.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:61879 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbbLGKBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 05:01:05 -0500
Received: from [192.168.176.17] ([85.14.118.246]) by mrelayeu.kundenserver.de
 (mreue103) with ESMTPSA (Nemesis) id 0M3uUc-1aO6Av1VDe-00rZ0G for
 <linux-scsi@vger.kernel.org>; Mon, 07 Dec 2015 11:01:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

on my FC environment target machine hanged always while rebooting the=20
initiator machine. I was able to capture the following call trace:

[19236.146988]  rport-11:0-0: blocked FC remote port time out: removing=
=20
target and saving binding
[19236.157185]  rport-10:0-0: blocked FC remote port time out: removing=
=20
target and saving binding
[19236.157288] scsi scan: 37 byte inquiry failed.  Consider=20
BLIST_INQUIRY_36 for this device
[19236.157290] scsi scan: 37 byte inquiry failed.  Consider=20
BLIST_INQUIRY_36 for this device
[19236.157412] BUG: unable to handle kernel NULL pointer dereference=20
at           (null)
[19236.157416] IP: [<ffffffff8141d20f>] scsi_device_put+0xf/0x50
[19236.157423] PGD 0
[19236.157425] Oops: 0000 [#1] SMP
[19236.157427] Modules linked in: iscsi_scst(O) scst_vdisk(O)=20
qla2x00tgt(O) scst(O) sch_htb rpcsec_gss_krb5 nls_iso8859_1 nls_cp437=20
vfat fat zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O)=20
crc32c_intel sg qla2xxx(O) scsi_transport_fc mpt2sas(O) raid_class=20
scsi_transport_sas button acpi_cpufreq mperf processor ixgbe(O) igb(O)=20
ptp pps_core aufs [last unloaded: scst]
[19236.157449] CPU: 0 PID: 28914 Comm: kworker/0:0 Tainted: P          =
=20
O 3.10.92-oe64-ge331686 #15
[19236.157451] Hardware name: Supermicro X8DTS/X8DTS, BIOS 2.1 06/25/20=
12
[19236.157457] Workqueue: fc_wq_10 fc_starget_delete [scsi_transport_fc=
]
[19236.157459] task: ffff88030d8741a0 ti: ffff8802ec38e000 task.ti:=20
ffff8802ec38e000
[19236.157461] RIP: 0010:[<ffffffff8141d20f>] [<ffffffff8141d20f>]=20
scsi_device_put+0xf/0x50
[19236.157464] RSP: 0018:ffff8802ec38fdf0  EFLAGS: 00010202
[19236.157466] RAX: 0000000000000000 RBX: ffff88030be48800 RCX:=20
00000001810000ba
[19236.157467] RDX: 00000001810000bb RSI: ffff88030e4b0860 RDI:=20
ffff88030be48800
[19236.157469] RBP: ffff88032ca8d000 R08: 0000000000000000 R09:=20
ffffea000c392c00
[19236.157470] R10: ffff880332803d00 R11: ffffffff8142992c R12:=20
ffff88032b951860
[19236.157472] R13: ffff88032ca8d010 R14: ffff8802ef3e0c00 R15:=20
ffff88030be48800
[19236.157474] FS:  0000000000000000(0000) GS:ffff880332e00000(0000)=20
knlGS:0000000000000000
[19236.157475] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[19236.157477] CR2: 0000000000000000 CR3: 000000000195e000 CR4:=20
00000000000007f0
[19236.157478] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[19236.157480] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[19236.157481] Stack:
[19236.157482]  ffff88032ca8d000 ffff88032ca8d000 ffffffff81429aba=20
0000000000000286
[19236.157484]  ffff8802dd800800 ffff88032b951b08 ffff880332e11680=20
0000000000000000
[19236.157487]  ffffe8ffffa05900 0000000000000001 ffffffff8105ce4d=20
ffffffff8105a4a7
[19236.157489] Call Trace:
[19236.157494]  [<ffffffff81429aba>] ? scsi_remove_target+0x16a/0x250
[19236.157499]  [<ffffffff8105ce4d>] ? process_one_work+0x13d/0x3b0
[19236.157502]  [<ffffffff8105a4a7>] ? pwq_activate_delayed_work+0x27/0=
x40
[19236.157504]  [<ffffffff8105d7b1>] ? worker_thread+0x121/0x3d0
[19236.157507]  [<ffffffff8105d690>] ? manage_workers.isra.26+0x280/0x2=
80
[19236.157510]  [<ffffffff81062e92>] ? kthread+0xc2/0xd0
[19236.157514]  [<ffffffff81070000>] ? sched_clock_cpu+0x30/0x100
[19236.157517]  [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x1=
10
[19236.157521]  [<ffffffff8169db98>] ? ret_from_fork+0x58/0x90
[19236.157524]  [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x1=
10
[19236.157525] Code: 7d 58 4c 89 fe e8 92 a2 27 00 48 89 d8 5b 5d 41 5c=
=20
41 5d 41 5e 41 5f c3 0f 1f 40 00 55 53 48 89 fb 48 8b 07 48 8b 80 c0 00=
=20
00 00 <48> 8b 28 48 85 ed 74 0d 48 89 ef e8 71 c4 c6 ff 48 85 c0 75 14
[19236.157548] RIP  [<ffffffff8141d20f>] scsi_device_put+0xf/0x50
[19236.157551]  RSP <ffff8802ec38fdf0>
[19236.157552] CR2: 0000000000000000
[19236.157555] ---[ end trace 37bfa3906f93d93a ]---
[19236.157578] BUG: unable to handle kernel paging request at=20
ffffffffffffffd8
[19236.157580] IP: [<ffffffff810633c7>] kthread_data+0x7/0x10
[19236.157583] PGD 1961067 PUD 1963067 PMD 0
[19236.157586] Oops: 0000 [#2] SMP
[19236.157587] Modules linked in: iscsi_scst(O) scst_vdisk(O)=20
qla2x00tgt(O) scst(O) sch_htb rpcsec_gss_krb5 nls_iso8859_1 nls_cp437=20
vfat fat zfs(PO) zunicode(PO) zavl(PO) zcommon(PO) znvpair(PO) spl(O)=20
crc32c_intel sg qla2xxx(O) scsi_transport_fc mpt2sas(O) raid_class=20
scsi_transport_sas button acpi_cpufreq mperf processor ixgbe(O) igb(O)=20
ptp pps_core aufs [last unloaded: scst]
[19236.157605] CPU: 0 PID: 28914 Comm: kworker/0:0 Tainted: P D    O=20
3.10.92-oe64-ge331686 #15
[19236.157606] Hardware name: Supermicro X8DTS/X8DTS, BIOS 2.1 06/25/20=
12
[19236.157617] task: ffff88030d8741a0 ti: ffff8802ec38e000 task.ti:=20
ffff8802ec38e000
[19236.157618] RIP: 0010:[<ffffffff810633c7>] [<ffffffff810633c7>]=20
kthread_data+0x7/0x10
[19236.157621] RSP: 0018:ffff8802ec38fa48  EFLAGS: 00010002
[19236.157623] RAX: 0000000000000000 RBX: 0000000000000000 RCX:=20
0000000000000001
[19236.157624] RDX: 0000000000000000 RSI: 0000000000000000 RDI:=20
ffff88030d8741a0
[19236.157626] RBP: ffff88030d8741a0 R08: 0000000000000000 R09:=20
ffff880332803a00
[19236.157627] R10: ffff880332e14a80 R11: ffffea000b862a00 R12:=20
0000000000000000
[19236.157629] R13: ffff88030d874490 R14: ffff88030d874190 R15:=20
0000000000000246
[19236.157630] FS:  0000000000000000(0000) GS:ffff880332e00000(0000)=20
knlGS:0000000000000000
[19236.157632] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[19236.157634] CR2: 0000000000000028 CR3: 000000000195e000 CR4:=20
00000000000007f0
[19236.157635] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[19236.157637] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:=20
0000000000000400
[19236.157638] Stack:
[19236.157639]  ffffffff8105dd48 ffff880332e11e00 ffffffff816963bb=20
ffff8802ec38ffd8
[19236.157641]  ffff8802ec38ffd8 ffff8802ec38ffd8 ffff88030d8741a0=20
ffff88030d8741a0
[19236.157643]  ffff8802ec38faf8 ffff8802ec38fb00 ffff88030d874438=20
ffff88030d874440
[19236.157645] Call Trace:
[19236.157648]  [<ffffffff8105dd48>] ? wq_worker_sleeping+0x8/0x90
[19236.157653]  [<ffffffff816963bb>] ? __schedule+0x3db/0x6a0
[19236.157656]  [<ffffffff81070ddd>] ? task_cputime+0x2d/0x50
[19236.157659]  [<ffffffff81048843>] ? do_exit+0x7e3/0xa40
[19236.157662]  [<ffffffff81698837>] ? oops_end+0x97/0xe0
[19236.157666]  [<ffffffff81036c7d>] ? no_context+0xfd/0x2e0
[19236.157669]  [<ffffffff8169af9a>] ? __do_page_fault+0xea/0x510
[19236.157672]  [<ffffffff81070c44>] ? arch_vtime_task_switch+0x74/0xa0
[19236.157675]  [<ffffffff8106a9b9>] ? finish_task_switch+0x29/0xb0
[19236.157678]  [<ffffffff8169624d>] ? __schedule+0x26d/0x6a0
[19236.157680]  [<ffffffff8105c289>] ? flush_work+0x19/0x150
[19236.157682]  [<ffffffff8105c289>] ? flush_work+0x19/0x150
[19236.157687]  [<ffffffff813e6340>] ? dev_vprintk_emit+0x40/0x50
[19236.157690]  [<ffffffff8169b3e2>] ? do_page_fault+0x22/0x40
[19236.157693]  [<ffffffff81697c38>] ? page_fault+0x28/0x30
[19236.157695]  [<ffffffff8142992c>] ? scsi_remove_device+0x1c/0x30
[19236.157698]  [<ffffffff8141d20f>] ? scsi_device_put+0xf/0x50
[19236.157700]  [<ffffffff81429aba>] ? scsi_remove_target+0x16a/0x250
[19236.157703]  [<ffffffff8105ce4d>] ? process_one_work+0x13d/0x3b0
[19236.157705]  [<ffffffff8105a4a7>] ? pwq_activate_delayed_work+0x27/0=
x40
[19236.157708]  [<ffffffff8105d7b1>] ? worker_thread+0x121/0x3d0
[19236.157710]  [<ffffffff8105d690>] ? manage_workers.isra.26+0x280/0x2=
80
[19236.157713]  [<ffffffff81062e92>] ? kthread+0xc2/0xd0
[19236.157715]  [<ffffffff81070000>] ? sched_clock_cpu+0x30/0x100
[19236.157718]  [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x1=
10
[19236.157721]  [<ffffffff8169db98>] ? ret_from_fork+0x58/0x90
[19236.157724]  [<ffffffff81062dd0>] ? kthread_create_on_node+0x110/0x1=
10
[19236.157725] Code: 00 00 00 00 65 48 8b 04 25 c0 b6 00 00 48 8b 80 80=
=20
02 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 80 02=
=20
00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 08 48 8b b7 80 02 00 00 ba
[19236.157748] RIP  [<ffffffff810633c7>] kthread_data+0x7/0x10
[19236.157751]  RSP <ffff8802ec38fa48>
[19236.157752] CR2: ffffffffffffffd8
[19236.157753] ---[ end trace 37bfa3906f93d93b ]---
[19236.157755] Fixing recursive fault but reboot is needed!

This happened because of race condition between scsi_remove_target (in=20
stgt_delete_work) and scsi_probe_and_add_lun (in scan_work). I created =
a=20
patch that cancels scan_work always when it's going to schedule=20
stgt_delete_work.

Here's the patch for 3.10.93 kernel:

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_trans=
port_fc.c
index e106c27..472a16e 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3143,6 +3144,7 @@ fc_timeout_deleted_rport(struct work_struct *work=
)
                         " a FCP target, removing starget\n");
                 spin_unlock_irqrestore(shost->host_lock, flags);
                 scsi_target_unblock(&rport->dev, SDEV_TRANSPORT_OFFLIN=
E);
+               cancel_work_sync(&rport->scan_work);
                 fc_queue_work(shost, &rport->stgt_delete_work);
                 return;
         }
@@ -3227,13 +3229,19 @@ fc_timeout_deleted_rport(struct work_struct *wo=
rk)
                  * all attached scsi devices.
                  */
                 rport->flags |=3D FC_RPORT_DEVLOSS_CALLBK_DONE;
+
+               /* cancel pending scan work */
+               spin_unlock_irqrestore(shost->host_lock, flags);
+               cancel_work_sync(&rport->scan_work);
+               spin_lock_irqsave(shost->host_lock, flags);
+
                 fc_queue_work(shost, &rport->stgt_delete_work);
 =20
                 do_callback =3D 1;
         }
-
         spin_unlock_irqrestore(shost->host_lock, flags);
 =20
+
         /*
          * Notify the driver that the rport is now dead. The LLDD will
          * also guarantee that any communication to the rport is termi=
nated


--=20
Best regards
Arkadiusz Buba=C5=82a
Open-E Poland Sp. z o.o.
www.open-e.com

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
