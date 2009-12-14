From: "Caspar Smit" <c.smit@truebit.nl>
Subject: mvsas: Using 3 controllers causes kernel panic.
Date: Mon, 14 Dec 2009 14:51:37 +0100 (CET)
Message-ID: <25998.87.210.74.220.1260798697.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:51369 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263AbZLNNvl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 08:51:41 -0500
Received: from ns1.emsolutions.nl (www-data@localhost.localdomain [127.0.0.1])
	by ns1.emsolutions.nl (8.13.8/8.13.8/Debian-3) with ESMTP id nBEDpdsJ002996
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2009 14:51:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Hi,

I'm using 3x SuperMicro AOC-SASLP-MV8 controllers using the
marvell 6480 Chipset.

I'm running vanilla kernel 2.6.32
(including the recent patches by Andy Yan, except patch 7)

When
I use 3 controllers in one machine I get the following kernel panic dur=
ing
boot:

[=A0 136.816010] BUG: unable to handle kernel NULL
pointer dereference at 0000000000000118
[=A0 136.816010] IP:
[<ffffffffa0111eb1>] mvs_int_port+0x1d3/0x4ef [mvsas]
[=A0
136.816010] PGD 1264e2067 PUD 1264c7067 PMD 0=20
[=A0 136.816010]
Oops: 0000 [#1] SMP=20
[=A0 136.816010] last sysfs file:
/sys/devices/platform/coretemp.3/temp1_input
[=A0 136.816010] CPU
3=20
[=A0 136.816010] Modules linked in: iscsi_trgt crc32c nfsd
lockd nfs_acl auth_rpcgss sunrpc exportfs coretemp w83627hf w83793
hwmon_vid loop netconsole configfs snd_pcm snd_timer evdev snd soundcor=
e
snd_page_alloc i2c_i801 i2c_core pcspkr rng_core ioatdma ehci_hcd uhci_=
hcd
i5k_amb i5400_edac edac_core container shpchp pci_hotplug button proces=
sor
dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456
async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx
raid10 md_mod thermal fan thermal_sys mvsas libsas scsi_transport_sas
sata_mv e1000e igb dca ext3 jbd mbcache sd_mod crc_t10dif ata_piix liba=
ta
scsi_mod
[=A0 136.816010] Pid: 0, comm: swapper Not tainted 2.6.32
#1 X7DWU
[=A0 136.816010] RIP:
0010:[<ffffffffa0111eb1>]=A0 [<ffffffffa0111eb1>]
mvs_int_port+0x1d3/0x4ef [mvsas]
[=A0 136.816010] RSP:
0018:ffff880028383e58=A0 EFLAGS: 00010246
[=A0 136.816010] RAX:
0000000000000000 RBX: 0000000000000000 RCX: ffff88012fb9de98
[=A0
136.816010] RDX: 0000000000000873 RSI: ffffffffa0117ccd RDI:
ffffffffa0117fab
[=A0 136.816010] RBP: ffff88012c500000 R08:
0000000000000000 R09: ffffffff810531c2
[=A0 136.816010] R10:
0000000000000092 R11: ffffffff81184689 R12: ffff88012c5008b8
[=A0
136.816010] R13: 0000000000000003 R14: 0000000000000001 R15:
0000000000000003
[=A0 136.816010] FS:=A0 0000000000000000(0000)
GS:ffff880028380000(0000) knlGS:0000000000000000
[=A0 136.816010]
CS:=A0 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[=A0
136.816010] CR2: 0000000000000118 CR3: 00000001264db000 CR4:
00000000000406e0
[=A0 136.816010] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
[=A0 136.816010] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[=A0
136.816010] Process swapper (pid: 0, threadinfo ffff88012fb8c000, task
ffff88012fb6c780)
[=A0 136.816010] Stack:
[=A0
136.816010]=A0 ffffffff81059a12 0000000000000003 ffff88012c500000
0000000000000800
[=A0 136.816010] <0> ffffc90002360150
0000000000000001 0000000000000000 ffffffffa0114863
[=A0
136.816010] <0> ffff88012fb65020 ffff88012c500000 0000000000000001
ffff88012c500008
[=A0 136.816010] Call Trace:
[=A0
136.816010]=A0 <IRQ>=20
[=A0 136.816010]=A0
[<ffffffff81059a12>] ? run_timer_softirq+0x222/0x268
[=A0
136.816010]=A0 [<ffffffffa0114863>] ? mvs_int_full+0x42/0x88
[mvsas]
[=A0 136.816010]=A0 [<ffffffffa01148da>] ?
mvs_64xx_isr+0x31/0x40 [mvsas]
[=A0 136.816010]=A0
[<ffffffffa01100da>] ? mvs_interrupt+0x61/0x78 [mvsas]
[=A0
136.816010]=A0 [<ffffffff81092554>] ?
handle_IRQ_event+0x58/0x126
[=A0 136.816010]=A0
[<ffffffff81093e26>] ? handle_fasteoi_irq+0x7d/0xb5
[=A0
136.816010]=A0 [<ffffffff81013817>] ? handle_irq+0x17/0x1d
[=A0 136.816010]=A0 [<ffffffff81012e71>] ?
do_IRQ+0x57/0xb6
[=A0 136.816010]=A0 [<ffffffff81011393>]
? ret_from_intr+0x0/0x11
[=A0 136.816010]=A0 <EOI>=20
[=A0 136.816010]=A0 [<ffffffff81017cdd>] ?
mwait_idle+0x72/0x7d
[=A0 136.816010]=A0
[<ffffffff81017c8d>] ? mwait_idle+0x22/0x7d
[=A0
136.816010]=A0 [<ffffffff8100fdf3>] ? cpu_idle+0x59/0x91
[=A0 136.816010] Code: a0 00 00 00 ba 73 08 00 00 48 c7 c6 cd 7c 11
a0 48 c7 c7 ab 7f 11 a0 44 8b 40 04 49 8b 84 24 b8 02 00 00 44 0f af 85=
 40
24 00 00 <8b> 88 18 01 00 00 31 c0 47 8d 44 05 00 e8 fc f6 1d e1 41
83 e6=20
[=A0 136.816010] RIP=A0 [<ffffffffa0111eb1>]
mvs_int_port+0x1d3/0x4ef [mvsas]
[=A0 136.816010]=A0 RSP
<ffff880028383e58>
[=A0 136.816010] CR2: 0000000000000118
[=A0 136.816010] ---[ end trace b9a85c9adff5d27d ]---
[=A0
136.816010] Kernel panic - not syncing: Fatal exception in interrupt
[=A0 136.816010] Pid: 0, comm: swapper Tainted:
G=A0=A0=A0=A0=A0 D=A0=A0=A0 2.6.32 #1
[=A0
136.816010] Call Trace:
[=A0 136.816010]=A0 <IRQ>=A0
[<ffffffff812f1504>] ? panic+0x86/0x141
[=A0
136.816010]=A0 [<ffffffff81011393>] ? ret_from_intr+0x0/0x11
[=A0 136.816010]=A0 [<ffffffff810148e7>] ?
oops_end+0x64/0xb4
[=A0 136.816010]=A0
[<ffffffff8101492a>] ? oops_end+0xa7/0xb4
[=A0
136.816010]=A0 [<ffffffff81032204>] ? no_context+0x1e9/0x1f8
[=A0 136.816010]=A0 [<ffffffff810323b9>] ?
__bad_area_nosemaphore+0x1a6/0x1ca
[=A0 136.816010]=A0
[<ffffffff81041875>] ? enqueue_task_fair+0x24/0x69
[=A0
136.816010]=A0 [<ffffffff8103a29b>] ? enqueue_task+0x5c/0x65
[=A0 136.816010]=A0 [<ffffffff8103a38b>] ?
activate_task+0x20/0x26
[=A0 136.816010]=A0
[<ffffffff81049d8c>] ? try_to_wake_up+0x1fb/0x20a
[=A0
136.816010]=A0 [<ffffffff810531c2>] ? irq_exit+0x48/0x76
[=A0 136.816010]=A0 [<ffffffff812f3635>] ?
page_fault+0x25/0x30
[=A0 136.816010]=A0
[<ffffffff81184689>] ? delay_tsc+0x0/0x73
[=A0
136.816010]=A0 [<ffffffff810531c2>] ? irq_exit+0x48/0x76
[=A0 136.816010]=A0 [<ffffffffa0111eb1>] ?
mvs_int_port+0x1d3/0x4ef [mvsas]
[=A0 136.816010]=A0
[<ffffffffa0111e7d>] ? mvs_int_port+0x19f/0x4ef [mvsas]
[=A0
136.816010]=A0 [<ffffffff81059a12>] ?
run_timer_softirq+0x222/0x268
[=A0 136.816010]=A0
[<ffffffffa0114863>] ? mvs_int_full+0x42/0x88 [mvsas]
[=A0
136.816010]=A0 [<ffffffffa01148da>] ? mvs_64xx_isr+0x31/0x40
[mvsas]
[=A0 136.816010]=A0 [<ffffffffa01100da>] ?
mvs_interrupt+0x61/0x78 [mvsas]
[=A0 136.816010]=A0
[<ffffffff81092554>] ? handle_IRQ_event+0x58/0x126
[=A0
136.816010]=A0 [<ffffffff81093e26>] ?
handle_fasteoi_irq+0x7d/0xb5
[=A0 136.816010]=A0
[<ffffffff81013817>] ? handle_irq+0x17/0x1d
[=A0
136.816010]=A0 [<ffffffff81012e71>] ? do_IRQ+0x57/0xb6
[=A0 136.816010]=A0 [<ffffffff81011393>] ?
ret_from_intr+0x0/0x11
[=A0 136.816010]=A0 <EOI>=A0
[<ffffffff81017cdd>] ? mwait_idle+0x72/0x7d
[=A0
136.816010]=A0 [<ffffffff81017c8d>] ? mwait_idle+0x22/0x7d
[=A0 136.816010]=A0 [<ffffffff8100fdf3>] ?
cpu_idle+0x59/0x91

When booting with 3 controllers and having
NO disks in the third controller works and doesn't give a kernel panic =
at
boot, but hotplugging a disk after boot triggers the same kernel panic.

The funny thing is that the third controller also ISN"T seen
by the BIOS, I used an official Marvell driver before and the third
controller worked (unstable, but it worked).

Kind regards,
Caspar Smit

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
