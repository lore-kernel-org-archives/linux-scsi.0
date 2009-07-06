From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: Soft lockup during device discovery on 2.6.31-rc1
Date: Mon, 6 Jul 2009 18:58:13 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A31150B@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
List-Id: linux-scsi@vger.kernel.org


Hi,

I am seeing Soft lockup during device discovery on 2.6.31-rc1. I am havin=
g 256 Volumes with 2 paths to each controller and  DM multipath configure=
d for these Volumes. As soon as device discovery starts I am seeing below=
 traces in syslog.


Regards,
Vijay

syslog snippet.
------------------------
Jul  2 16:41:55 localhost kernel: Modules linked in: dm_round_robin scsi_=
dh_rdac ipv6 autofs4 hidp rfcomm l2cap bluetooth rfkill sunrpc dm_multipa=
th scsi_dh video output sbs sbshc battery acpi_memhotplug ac parport_pc l=
p parport sr_mod cdrom joydev sg dcdbas serio_raw rtc_cmos rtc_core rtc_l=
ib button qla2xxx lpfc scsi_transport_fc ata_piix libata bnx2 pcspkr dm_s=
napshot dm_zero dm_mirror dm_region_hash dm_log dm_mod shpchp megaraid_sa=
s sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: fre=
q_table]
Jul  2 16:41:55 localhost kernel: Pid: 15631, comm: async/7 Tainted: G   =
   D    2.6.31-rc1 #1 PowerEdge R710
Jul  2 16:41:55 localhost kernel: RIP: 0010:[<ffffffff812d303d>]  [<fffff=
fff812d303d>] lock_kernel+0x24/0x39
Jul  2 16:41:55 localhost kernel: RSP: 0018:ffff88009a9fdd98  EFLAGS: 000=
00283
Jul  2 16:41:55 localhost kernel: RAX: 000000000000403e RBX: ffff8800910f=
e400 RCX: ffff88001631d2b8
Jul  2 16:41:55 localhost kernel: RDX: 0000000000000000 RSI: 000000000000=
0001 RDI: ffff88001631d1c0
Jul  2 16:41:55 localhost kernel: RBP: ffffffff8100c2ce R08: 800000000000=
0000 R09: 0410085000000010
Jul  2 16:41:55 localhost kernel: R10: 00014a511e9cd9e0 R11: ffffffff8112=
299e R12: ffff88009a9fdd10
Jul  2 16:41:55 localhost kernel: R13: ffff88009a9fddd0 R14: 000000300000=
0020 R15: ffffffff811574d5
Jul  2 16:41:55 localhost kernel: FS:  0000000000000000(0000) GS:ffff8800=
2804b000(0000) knlGS:0000000000000000
Jul  2 16:41:55 localhost kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000=
008005003b
Jul  2 16:41:55 localhost kernel: CR2: 00007f3f77c60000 CR3: 00000000aa7f=
c000 CR4: 00000000000006f0
Jul  2 16:41:55 localhost kernel: DR0: 0000000000000000 DR1: 000000000000=
0000 DR2: 0000000000000000
Jul  2 16:41:55 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff=
0ff0 DR7: 0000000000000400
Jul  2 16:41:55 localhost kernel: Call Trace:
Jul  2 16:41:55 localhost kernel:  [<ffffffff810d81c5>] ? __blkdev_get+0x=
1d/0x32a
Jul  2 16:41:55 localhost kernel:  [<ffffffff810d7d07>] ? bdget+0x105/0x1=
0d
Jul  2 16:41:55 localhost kernel:  [<ffffffff810ff7ce>] ? register_disk+0=
xaf/0x10a
Jul  2 16:41:55 localhost kernel:  [<ffffffff8114e2ba>] ? add_disk+0xaa/0=
x105
Jul  2 16:41:55 localhost kernel:  [<ffffffffa008bba6>] ? sd_probe_async+=
0x120/0x1d9 [sd_mod]
Jul  2 16:41:55 localhost kernel:  [<ffffffff81054b70>] ? async_thread+0x=
0/0x1ea
Jul  2 16:41:55 localhost kernel:  [<ffffffff81054c70>] ? async_thread+0x=
100/0x1ea
Jul  2 16:41:55 localhost kernel:  [<ffffffff810353ff>] ? default_wake_fu=
nction+0x0/0x9
Jul  2 16:41:55 localhost kernel:  [<ffffffff81050416>] ? kthread+0x84/0x=
8e
Jul  2 16:41:55 localhost kernel:  [<ffffffff8100c93a>] ? child_rip+0xa/0=
x20
Jul  2 16:41:55 localhost kernel:  [<ffffffffa005f82e>] ? scsi_request_fn=
+0x0/0x48e [scsi_mod]
Jul  2 16:41:55 localhost kernel:  [<ffffffff81050392>] ? kthread+0x0/0x8=
e
Jul  2 16:41:55 localhost kernel:  [<ffffffff8100c930>] ? child_rip+0x0/0=
x20
Jul  2 16:41:55 localhost kernel: BUG: soft lockup - CPU#1 stuck for 61s!=
 [async/33:15657]
Jul  2 16:41:55 localhost kernel: Modules linked in: dm_round_robin scsi_=
dh_rdac ipv6 autofs4 hidp rfcomm l2cap bluetooth rfkill sunrpc dm_multipa=
th scsi_dh video output sbs sbshc battery acpi_memhotplug ac parport_pc l=
p parport sr_mod cdrom joydev sg dcdbas serio_raw rtc_cmos rtc_core rtc_l=
ib button qla2xxx lpfc scsi_transport_fc ata_piix libata bnx2 pcspkr dm_s=
napshot dm_zero dm_mirror dm_region_hash dm_log dm_mod shpchp megaraid_sa=
s sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: fre=
q_table]
Jul  2 16:41:55 localhost kernel: CPU 1:
Jul  2 16:41:55 localhost kernel: Modules linked in: dm_round_robin scsi_=
dh_rdac ipv6 autofs4 hidp rfcomm l2cap bluetooth rfkill sunrpc dm_multipa=
th scsi_dh video output sbs sbshc battery acpi_memhotplug ac parport_pc l=
p parport sr_mod cdrom joydev sg dcdbas serio_raw rtc_cmos rtc_core rtc_l=
ib button qla2xxx lpfc scsi_transport_fc ata_piix libata bnx2 pcspkr dm_s=
napshot dm_zero dm_mirror dm_region_hash dm_log dm_mod shpchp megaraid_sa=
s sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: fre=
q_table]
Jul  2 16:41:55 localhost kernel: Pid: 15657, comm: async/33 Tainted: G  =
    D    2.6.31-rc1 #1 PowerEdge R710
Jul  2 16:41:55 localhost kernel: RIP: 0010:[<ffffffff8105cc16>]  [<fffff=
fff8105cc16>] smp_call_function_many+0x1a4/0x1b5
Jul  2 16:41:55 localhost kernel: RSP: 0018:ffff88000a227d10  EFLAGS: 000=
00202
Jul  2 16:41:55 localhost kernel: RAX: 00000000000000ff RBX: ffff88002807=
23a0 RCX: 0000000000000001
Jul  2 16:41:55 localhost kernel: RDX: ffff88001634d250 RSI: 000000000000=
00ff RDI: 00000000000000c0
Jul  2 16:41:55 localhost kernel: RBP: ffffffff8100c42e R08: 000000000000=
003f R09: ffffffff815e2358
Jul  2 16:41:55 localhost kernel: R10: 7fffffffffffffff R11: 000000000000=
0000 R12: ffff88001634d250
Jul  2 16:41:55 localhost kernel: R13: 0000000000000282 R14: ffff88001634=
d250 R15: 000000010000000e
Jul  2 16:41:55 localhost kernel: FS:  0000000000000000(0000) GS:ffff8800=
28065000(0000) knlGS:0000000000000000
Jul  2 16:41:55 localhost kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000=
008005003b
Jul  2 16:41:55 localhost kernel: CR2: 00007f3f77360d70 CR3: 00000000b820=
8000 CR4: 00000000000006e0
Jul  2 16:41:55 localhost kernel: DR0: 0000000000000000 DR1: 000000000000=
0000 DR2: 0000000000000000
Jul  2 16:41:55 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff=
0ff0 DR7: 0000000000000400
Jul  2 16:41:55 localhost kernel: Call Trace:
Jul  2 16:41:55 localhost kernel:  [<ffffffff810d3283>] ? invalidate_bh_l=
ru+0x0/0x41
Jul  2 16:41:55 localhost kernel:  [<ffffffff810d3283>] ? invalidate_bh_l=
ru+0x0/0x41
Jul  2 16:41:55 localhost kernel:  [<ffffffff8105cc47>] ? smp_call_functi=
on+0x20/0x24
Jul  2 16:41:55 localhost kernel:  [<ffffffff81041906>] ? on_each_cpu+0x1=
0/0x22
Jul  2 16:41:55 localhost kernel:  [<ffffffff810d76b3>] ? kill_bdev+0x1b/=
0x30
Jul  2 16:41:55 localhost kernel:  [<ffffffff810d8085>] ? __blkdev_put+0x=
54/0x151
Jul  2 16:41:55 localhost kernel:  [<ffffffff810ff7df>] ? register_disk+0=
xc0/0x10a
Jul  2 16:41:55 localhost kernel:  [<ffffffff8114e2ba>] ? add_disk+0xaa/0=
x105
Jul  2 16:41:55 localhost kernel:  [<ffffffffa008bba6>] ? sd_probe_async+=
0x120/0x1d9 [sd_mod]
Jul  2 16:41:55 localhost kernel:  [<ffffffff81054b70>] ? async_thread+0x=
0/0x1ea
Jul  2 16:41:55 localhost kernel:  [<ffffffff81054c70>] ? async_thread+0x=
100/0x1ea
Jul  2 16:41:55 localhost kernel:  [<ffffffff810353ff>] ? default_wake_fu=
nction+0x0/0x9
Jul  2 16:41:55 localhost kernel:  [<ffffffff81050416>] ? kthread+0x84/0x=
8e
Jul  2 16:41:55 localhost kernel:  [<ffffffff8100c93a>] ? child_rip+0xa/0=
x20
Jul  2 16:41:55 localhost kernel:  [<ffffffffa005f82e>] ? scsi_request_fn=
+0x0/0x48e [scsi_mod]
Jul  2 16:41:55 localhost kernel:  [<ffffffff81050392>] ? kthread+0x0/0x8=
e
Jul  2 16:41:55 localhost kernel:  [<ffffffff8100c930>] ? child_rip+0x0/0=
x20
Jul  2 16:41:55 localhost kernel: BUG: soft lockup - CPU#2 stuck for 61s!=
 [async/82:15713]
Jul  2 16:41:55 localhost kernel: Modules linked in: dm_round_robin scsi_=
dh_rdac ipv6 autofs4 hidp rfcomm l2cap bluetooth rfkill sunrpc dm_multipa=
th scsi_dh video output sbs sbshc battery acpi_memhotplug ac parport_pc l=
p parport sr_mod cdrom joydev sg dcdbas serio_raw rtc_cmos rtc_core rtc_l=
ib button qla2xxx lpfc scsi_transport_fc ata_piix libata bnx2 pcspkr dm_s=
napshot dm_zero dm_mirror dm_region_hash dm_log dm_mod shpchp megaraid_sa=
s sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: fre=
q_table]
Jul  2 16:41:55 localhost kernel: CPU 2:
Jul  2 16:41:55 localhost kernel: Modules linked in: dm_round_robin scsi_=
dh_rdac ipv6 autofs4 hidp rfcomm l2cap bluetooth rfkill sunrpc dm_multipa=
th scsi_dh video output sbs sbshc battery acpi_memhotplug ac parport_pc l=
p parport sr_mod cdrom joydev sg dcdbas serio_raw rtc_cmos rtc_core rtc_l=
ib button qla2xxx lpfc scsi_transport_fc ata_piix libata
