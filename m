From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Re: [PATCH 6/7]MVSAS: Enhanced hot plug handling
Date: Wed, 23 Dec 2009 13:13:30 +0100 (CET)
Message-ID: <26273.87.210.74.220.1261570410.squirrel@ketsers.dhs.org>
References: <26320.87.210.74.220.1261057483.squirrel@ketsers.dhs.org>
    <e938503f0912201737r1296c47k4518fbeecd48ff00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:51514 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbZLWMNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2009 07:13:32 -0500
In-Reply-To: <e938503f0912201737r1296c47k4518fbeecd48ff00@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andy yan <andyysj@gmail.com>
Cc: linux-scsi@vger.kernel.org

After further testing:

When using ONLY SAS disks, the hotplugging seems to be much more stable
and only sometimes results in a kernel panic.
When mixing with SATA disks the amount of kernel panics after hotplugging
a disk seem to explode. Almost every hotplug action results in a kernel
panic.

Kind regards,
Caspar


> Caspar,
>         Please apply patchs(1-6) at least, the each patch doesn't work
> well
> independently.
>
> Andy Yan
>
> On Thu, Dec 17, 2009 at 9:44 PM, Caspar Smit <c.smit@truebit.nl> wrote:
>
>>
>>
>> Hi Andy,
>>
>> After apllying this patch (and 1-5) to the 2.6.32
>> vanilla kernel I still get lots and lots of kernel panics when
>> hotplugging a disk.
>>
>> ps. And I posted a mvsas related bug that
>> causes an
>> instant kernel panic at boot when using 3 Marvell 6480
>> controllers in one machine. Any news on that?
>>
>>  Kind regards,
>>  Caspar Smit
>>
>> ---
>>
>> [  222.575814] BUG: unable
>> to handle kernel
>> NULL pointer dereference at 0000000000000118
>> [  222.575999] IP:
>> [<ffffffffa013beb1>]
>> mvs_int_port+0x1d3/0x4ef [mvsas]
>> [
>> 222.576001] PGD
>> 7f0ea067 PUD 0
>> [  222.576001] Oops: 0000 [#1]
>> SMP
>> [  222.576001] last sysfs file:
>> /sys/devices/platform/coretemp.3/temp1_input
>> [  222.576001]
>> CPU
>> 3
>> [  222.576001] Modules linked in: iscsi_trgt crc32c
>> nfsd
>> lockd nfs_acl auth_rpcgss sunrpc exportfs ib_iser rdma_cm ib_cm
>> iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi
>> scsi_transport_iscsi bonding coretemp w83627hf w83793 hwmon_vid loop
>> netconsole configfs rng_core i5k_amb evdev snd_pcm snd_timer snd
>> soundcore
>> snd_page_alloc i2c_i801 i2c_core pcspkr uhci_hcd ehci_hcd ioatdma
>> i5000_edac edac_core floppy parport_pc parport container button
>> processor shpchp pci_hotplug dm_mirror dm_region_hash dm_log dm_snapshot
>> dm_mod raid456 async_raid6_recov async_pq raid6_pq async_xor xor
>> async_memcpy async_tx raid10 md_mod thermal fan thermal_sys mvsas
>> libsas
>> scsi_transport_sas sata_mv e1000e igb dca ext3 jbd mbcache
>> sd_mod
>> crc_t10dif ata_piix libata scsi_mod
>> [  222.576001]
>> Pid: 0, comm:
>> swapper Not tainted 2.6.32 #1 X7DB8
>> [
>> 222.576001] RIP:
>> 0010:[<ffffffffa013beb1>]
>> [<ffffffffa013beb1>]
>> mvs_int_port+0x1d3/0x4ef [mvsas]
>> [  222.576001] RSP:
>> 0018:ffff880001983e58  EFLAGS:
>> 00010246
>> [  222.576001] RAX:
>> 0000000000000000 RBX:
>> 0000000000000000 RCX: ffff88007f095e98
>> [
>> 222.576001] RDX:
>> 0000000000000873 RSI: ffffffffa0141ccd RDI:
>> ffffffffa0141fab
>> [  222.576001] RBP: ffff88007d840000 R08:
>> 0000000000000000
>> R09: ffffffff810531c2
>> [  222.576001] R10:
>> 0000000000000092
>> R11: 0000000000000400 R12: ffff88007d8408b8
>> [
>> 222.576001]
>> R13: 0000000000000003 R14: 0000000000000001 R15:
>> 0000000000000003
>> [  222.576001] FS:  0000000000000000(0000)
>> GS:ffff880001980000(0000) knlGS:0000000000000000
>> [
>> 222.576001]
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> [
>> 222.576001] CR2: 0000000000000118 CR3: 000000007eba3000
>> CR4:
>> 00000000000406e0
>> [  222.576001] DR0: 0000000000000000
>> DR1:
>> 0000000000000000 DR2: 0000000000000000
>> [  222.576001]
>> DR3:
>> 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [
>> 222.576001] Process swapper (pid: 0, threadinfo
>> ffff88007f084000, task ffff88007f066780)
>> [  222.576001]
>> Stack:
>> [
>> 222.576001]  ffffffff8105983c
>> 0000000000000003 ffff88007d840000
>> 0000000000000800
>> [
>> 222.576001] <0> ffffc90001b20150
>> 0000000000000001
>> 0000000000000000 ffffffffa013e863
>> [
>> 222.576001] <0>
>> ffff88007dcf2f18 ffff88007d840000 0000000000000001 ffff88007d840008
>> [  222.576001] Call Trace:
>> [
>> 222.576001]
>> <IRQ>
>> [  222.576001]
>> [<ffffffff8105983c>] ? run_timer_softirq+0x4c/0x268
>> [
>> 222.576001]  [<ffffffffa013e863>] ?
>> mvs_int_full+0x42/0x88
>> [mvsas]
>> [  222.576001]
>> [<ffffffffa013e8da>] ?
>> mvs_64xx_isr+0x31/0x40 [mvsas]
>> [  222.576001]
>> [<ffffffffa013a0da>] ?
>> mvs_interrupt+0x61/0x78 [mvsas]
>> [
>> 222.576001]
>> [<ffffffff81092554>] ?
>> handle_IRQ_event+0x58/0x126
>> [
>> 222.576001]
>> [<ffffffff81093e26>] ?
>> handle_fasteoi_irq+0x7d/0xb5
>> [
>> 222.576001]
>> [<ffffffff81013817>] ? handle_irq+0x17/0x1d
>> [
>> 222.576001]  [<ffffffff81012e71>] ?
>> do_IRQ+0x57/0xb6
>> [  222.576001]  [<ffffffff81011393>]
>> ?
>> ret_from_intr+0x0/0x11
>> [  222.576001]  <EOI>
>> [  222.576001]  [<ffffffff81017cdd>] ?
>> mwait_idle+0x72/0x7d
>> [  222.576001]
>> [<ffffffff81017c8d>] ? mwait_idle+0x22/0x7d
>> [
>> 222.576001]  [<ffffffff8100fdf3>] ? cpu_idle+0x59/0x91
>> [  222.576001] Code: a0 00 00 00 ba 73 08 00 00 48 c7 c6 cd 1c
>> 14
>> a0 48 c7 c7 ab 1f 14 a0 44 8b 40 04 49 8b 84 24 b8 02 00 00 44 0f
>> af 85 40 24 00 00 <8b> 88 18 01 00 00 31 c0 47 8d 44 05 00 e8 fc 56
>> 1b e1 41 83 e6
>> [  222.576001] RIP
>> [<ffffffffa013beb1>]
>> mvs_int_port+0x1d3/0x4ef [mvsas]
>> [  222.576001]  RSP
>> <ffff880001983e58>
>> [
>> 222.576001] CR2: 0000000000000118
>> [  222.593420] ---[ end trace
>> f9b64cadb09cc87c ]---
>> [
>> 222.593489] Kernel panic - not
>> syncing: Fatal exception in interrupt [  222.593561] Pid: 0, comm:
>> swapper Tainted:
>> G      D
>> 2.6.32 #1
>> [
>> 222.593631] Call Trace:
>> [
>> 222.593694]  <IRQ>
>> [<ffffffff812f1504>] ?
>> panic+0x86/0x141
>> [
>> 222.593820]
>> [<ffffffff81011533>] ?
>> apic_timer_interrupt+0x13/0x20
>> [  222.593896]
>> [<ffffffff810148e7>] ?
>> oops_end+0x64/0xb4
>> [
>> 222.593968]
>> [<ffffffff8101492a>] ? oops_end+0xa7/0xb4
>>
>

