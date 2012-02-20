From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: mpt2sas: BUG: using smp_processor_id() in preemptible
Date: Mon, 20 Feb 2012 16:06:55 -0700
Message-ID: <4565AEA676113A449269C2F3A549520FB5AE22B0@cosmail03.lsi.com>
References: <4F425105.4090505@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51411 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab2BTXKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Feb 2012 18:10:05 -0500
In-Reply-To: <4F425105.4090505@jan-o-sch.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Schmidt <list.linux-scsi@jan-o-sch.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jan - the smp_processor_id() is part of NUMA support which I added over a year ago. I don't see any problem with the driver running on sles11sp2 which has btrfs support ( I'm not sure  if CONFIG_DEBUG_PREEMPT is turned on as I have not checked).   Any theory why its oopsing in smp_processor_id() ?
________________________________________
From: linux-scsi-owner@vger.kernel.org [linux-scsi-owner@vger.kernel.org] On Behalf Of Jan Schmidt [list.linux-scsi@jan-o-sch.net]
Sent: Monday, February 20, 2012 6:56 AM
To: linux-scsi@vger.kernel.org
Subject: mpt2sas: BUG: using smp_processor_id() in preemptible

Hi,

I discovered a bug when loading mpt2sas module with the current btrfs
tree (which is 3.2.0 plus current btrfs) and verified with linux
3.3.0-rc4. It hides away when I set CONFIG_DEBUG_PREEMPT=n.

Feb 20 13:53:04 zarzz kernel: [    3.834047] Freeing unused kernel
memory: 868k freed
Feb 20 13:53:04 zarzz kernel: [    3.835019] Freeing unused kernel
memory: 192k freed
Feb 20 13:53:04 zarzz kernel: [    3.917143] modprobe used greatest
stack depth: 4488 bytes left
Feb 20 13:53:04 zarzz kernel: [    3.942538] mpt2sas version
12.100.00.00 loaded
Feb 20 13:53:04 zarzz kernel: [    3.942994] scsi6 : Fusion MPT SAS Host
Feb 20 13:53:04 zarzz kernel: [    3.946028] mpt2sas0: 64 BIT PCI BUS
DMA ADDRESSING SUPPORTED, total mem (16399548 kB)
Feb 20 13:53:04 zarzz kernel: [    3.946179] mpt2sas 0000:01:00.0: irq
57 for MSI/MSI-X
Feb 20 13:53:04 zarzz kernel: [    3.946238] mpt2sas0-msix0: PCI-MSI-X
enabled: IRQ 57
Feb 20 13:53:04 zarzz kernel: [    3.946241] mpt2sas0:
iomem(0x00000000fb43c000), mapped(0xffffc90001860000), size(16384)
Feb 20 13:53:04 zarzz kernel: [    3.946245] mpt2sas0:
ioport(0x000000000000c000), size(256)
Feb 20 13:53:04 zarzz kernel: [    3.962802] ata_id used greatest stack
depth: 3904 bytes left
Feb 20 13:53:04 zarzz kernel: [    4.018627] mpt2sas0: sending message
unit reset !!
Feb 20 13:53:04 zarzz kernel: [    4.020616] mpt2sas0: message unit
reset: SUCCESS
Feb 20 13:53:04 zarzz kernel: [    4.087887] mpt2sas0: Allocated
physical memory: size(8027 kB)
Feb 20 13:53:04 zarzz kernel: [    4.087890] mpt2sas0: Current
Controller Queue Depth(3577), Max Controller Queue Depth(3712)
Feb 20 13:53:04 zarzz kernel: [    4.087892] mpt2sas0: Scatter Gather
Elements per IO(128)
Feb 20 13:53:04 zarzz kernel: [    4.146377] BUG: using
smp_processor_id() in preemptible [00000000] code: modprobe/1330
Feb 20 13:53:04 zarzz kernel: [    4.242064] caller is
mpt2sas_base_put_smid_default+0x2f/0x80 [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242067] Pid: 1330, comm: modprobe
Not tainted 3.3.0-rc4 #43
Feb 20 13:53:04 zarzz kernel: [    4.242069] Call Trace:
Feb 20 13:53:04 zarzz kernel: [    4.242076]  [<ffffffff81436972>]
debug_smp_processor_id+0xd2/0xf0
Feb 20 13:53:04 zarzz kernel: [    4.242084]  [<ffffffffa00152af>]
mpt2sas_base_put_smid_default+0x2f/0x80 [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242094]  [<ffffffffa0015436>]
_base_event_notification+0x136/0x280 [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242104]  [<ffffffffa0015a79>]
_base_make_ioc_operational+0x469/0x10e0 [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242111]  [<ffffffff810e6b0b>] ?
is_module_address+0x2b/0x60
Feb 20 13:53:04 zarzz kernel: [    4.242118]  [<ffffffff810d73c4>] ?
static_obj+0x44/0x60
Feb 20 13:53:04 zarzz kernel: [    4.242123]  [<ffffffff810d89cb>] ?
lockdep_init_map+0x5b/0x150
Feb 20 13:53:04 zarzz kernel: [    4.242129]  [<ffffffff810d5f96>] ?
debug_mutex_init+0x36/0x50
Feb 20 13:53:04 zarzz kernel: [    4.242138]  [<ffffffffa001ac29>]
mpt2sas_base_attach+0x10b9/0x15a0 [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242147]  [<ffffffffa00201d6>]
_scsih_probe+0x3d6/0x610 [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242151]  [<ffffffff810b0eb1>] ?
get_parent_ip+0x11/0x50
Feb 20 13:53:04 zarzz kernel: [    4.242155]  [<ffffffff819198a5>] ?
sub_preempt_count+0x95/0xd0
Feb 20 13:53:04 zarzz kernel: [    4.242158]  [<ffffffff81916000>] ?
_raw_spin_unlock+0x30/0x60
Feb 20 13:53:04 zarzz kernel: [    4.242164]  [<ffffffff8144cb32>]
local_pci_probe+0x12/0x20
Feb 20 13:53:04 zarzz kernel: [    4.242167]  [<ffffffff8144dbf9>]
pci_device_probe+0xf9/0x120
Feb 20 13:53:04 zarzz kernel: [    4.242171]  [<ffffffff8155a78a>] ?
driver_sysfs_add+0x7a/0xb0
Feb 20 13:53:04 zarzz kernel: [    4.242174]  [<ffffffff8155a91b>]
driver_probe_device+0x8b/0x2e0
Feb 20 13:53:04 zarzz kernel: [    4.242177]  [<ffffffff8155ac03>]
__driver_attach+0x93/0xa0
Feb 20 13:53:04 zarzz kernel: [    4.242180]  [<ffffffff8155ab70>] ?
driver_probe_device+0x2e0/0x2e0
Feb 20 13:53:04 zarzz kernel: [    4.242184]  [<ffffffff81558e38>]
bus_for_each_dev+0x68/0x90
Feb 20 13:53:04 zarzz kernel: [    4.242187]  [<ffffffff8155a6b9>]
driver_attach+0x19/0x20
Feb 20 13:53:04 zarzz kernel: [    4.242190]  [<ffffffff8155a378>]
bus_add_driver+0x208/0x2b0
Feb 20 13:53:04 zarzz kernel: [    4.242195]  [<ffffffffa0041000>] ?
0xffffffffa0040fff
Feb 20 13:53:04 zarzz kernel: [    4.242199]  [<ffffffff8155b248>]
driver_register+0x78/0x140
Feb 20 13:53:04 zarzz kernel: [    4.242204]  [<ffffffff814366e6>] ?
__raw_spin_lock_init+0x36/0x60
Feb 20 13:53:04 zarzz kernel: [    4.242208]  [<ffffffffa0041000>] ?
0xffffffffa0040fff
Feb 20 13:53:04 zarzz kernel: [    4.242213]  [<ffffffff8144deb1>]
__pci_register_driver+0x61/0xe0
Feb 20 13:53:04 zarzz kernel: [    4.242217]  [<ffffffffa0041000>] ?
0xffffffffa0040fff
Feb 20 13:53:04 zarzz kernel: [    4.242226]  [<ffffffffa004116a>]
_scsih_init+0x16a/0x18e [mpt2sas]
Feb 20 13:53:04 zarzz kernel: [    4.242233]  [<ffffffff810001cd>]
do_one_initcall+0x3d/0x170
Feb 20 13:53:04 zarzz kernel: [    4.242238]  [<ffffffff810ea67a>]
sys_init_module+0x8a/0x1e0
Feb 20 13:53:04 zarzz kernel: [    4.242242]  [<ffffffff8191d122>]
system_call_fastpath+0x16/0x1b

-Jan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
