From: Olaf Hering <olh@suse.de>
Subject: oops in ibmvstgt, in __scsi_alloc_queue
Date: Fri, 29 Feb 2008 16:58:25 +0100
Message-ID: <20080229155825.GA25293@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:51549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbYB2P62 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 10:58:28 -0500
Received: from Relay1.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 21D8432870
	for <linux-scsi@vger.kernel.org>; Fri, 29 Feb 2008 16:58:26 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


loading ibmvstgt in 2.6.25-rc3 gives the oops below.
loading it in 2.6.24 works.
This is an 8 cpu pseries IBM,9133-55A, 6gb ram, firmware SF235_185.

....
IBM eServer i/pSeries Virtual SCSI Target Driver
vio_register_driver: driver ibmvscsis registering
Unable to handle kernel paging request for data at address 0x000001c0
Faulting instruction address: 0xd00000000009ed80
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in: ibmvstgt(+) ses(+) e1000(+) enclosure libsrp scsi_transport_srp scsi_tgt sg sd_mod pata_pdc2027x ipr libata scsi_mod firmware_class
NIP: d00000000009ed80 LR: d00000000009ed7c CTR: c000000000219874
REGS: c00000017c397270 TRAP: 0300   Tainted: G        N  (2.6.25-rc3-20080228160715-ppc64)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24022484  XER: 00000010
DAR: 00000000000001c0, DSISR: 0000000040000000
TASK = c00000017c84aa60[660] 'modprobe' THREAD: c00000017c394000 CPU: 6
GPR00: d00000000009ed7c c00000017c3974f0 d0000000000daff8 c00000017c7a4810 
GPR04: 00000000ffffffff 0000000000000000 c00000017cd7b200 c0000000006a9228 
GPR08: 0000000000000002 c00000000085d300 0000000000000071 c000000000219874 
GPR12: d0000000000a84e0 c0000000006c0f00 d00000000011ee70 d000000000145d50 
GPR16: c00000017c397cc0 000000000000008f 0000000000000007 d00000000011e670 
GPR20: 0000000000000000 0000000000000124 000000000000001e d000000000117000 
GPR24: c00000017cdfbdf8 c00000017cdfb000 c00000017c5f5c00 d000000000145b78 
GPR28: 0000000000000000 c00000017cdfb000 d0000000000d90b8 c00000017c7a4810 
NIP [d00000000009ed80] .__scsi_alloc_queue+0xa4/0x130 [scsi_mod]
LR [d00000000009ed7c] .__scsi_alloc_queue+0xa0/0x130 [scsi_mod]
Call Trace:
[c00000017c3974f0] [d00000000009ed7c] .__scsi_alloc_queue+0xa0/0x130 [scsi_mod] (unreliable)
[c00000017c397580] [d0000000000305b0] .scsi_tgt_alloc_queue+0x2c/0xf0 [scsi_tgt]
[c00000017c397610] [d000000000141a94] .ibmvstgt_probe+0x84/0x3c4 [ibmvstgt]
[c00000017c3976d0] [c000000000022588] .vio_bus_probe+0x60/0x84
[c00000017c397760] [c0000000002ed0d4] .driver_probe_device+0x114/0x1fc
[c00000017c397800] [c0000000002ed26c] .__driver_attach+0xb0/0x134
[c00000017c397890] [c0000000002ec550] .bus_for_each_dev+0x7c/0xdc
[c00000017c397950] [c0000000002ece60] .driver_attach+0x28/0x40
[c00000017c3979d0] [c0000000002ebb34] .bus_add_driver+0xd0/0x284
[c00000017c397a70] [c0000000002ed580] .driver_register+0x94/0x16c
[c00000017c397b20] [c000000000022ab4] .vio_register_driver+0x44/0x60
[c00000017c397bb0] [d000000000141ff4] .ibmvstgt_init+0x154/0x1a4 [ibmvstgt]
[c00000017c397c40] [c0000000000a99c8] .sys_init_module+0x1a50/0x1bc8
[c00000017c397e30] [c000000000008748] syscall_exit+0x0/0x40
Instruction dump:
78091fe1 40820010 e93e8000 e8090000 780464e4 7fe3fb78 4800a169 e8410028 
7fe3fb78 e89d0110 48009769 e8410028 <e93c01c0> e81d0110 2fa90000 419e0008 
---[ end trace 490d9aacf75eeba4 ]---
....

full dmesg:

Crash kernel location must be 0x2000000
Reserving 0MB of memory at 32MB for crashkernel (System RAM: 6144MB)
Using pSeries machine description
Page orders: linear mapping = 24, virtual = 12, io = 12
Found initrd at 0xc000000002b00000:0xc000000002d7f000
console [udbg-1] enabled
Partition configured for 8 cpus.
CPU maps initialized for 2 threads per core
 (thread shift is 1)
Starting Linux PPC64 #1 SMP 2008/02/28 16:07:15 UTC
-----------------------------------------------------
ppc64_pft_size                = 0x1b
physicalMemorySize            = 0x180000000
htab_hash_mask                = 0xfffff
-----------------------------------------------------
Linux version 2.6.25-rc3-20080228160715-ppc64 (geeko@buildhost) (gcc version 4.3.0 20080221 (prerelease) [gcc-4_3-branch revision 132521] (SUSE Linux) ) #1 SMP 2008/02/28 16:07:15 UTC
[boot]0012 Setup Arch
Entering add_active_range(0, 0, 32768) 0 entries of 256 used
Entering add_active_range(0, 32768, 36864) 1 entries of 256 used
Entering add_active_range(0, 36864, 40960) 1 entries of 256 used
Entering add_active_range(0, 40960, 45056) 1 entries of 256 used
Entering add_active_range(0, 45056, 49152) 1 entries of 256 used
Entering add_active_range(0, 49152, 53248) 1 entries of 256 used
Entering add_active_range(0, 53248, 57344) 1 entries of 256 used
Entering add_active_range(0, 57344, 61440) 1 entries of 256 used
Entering add_active_range(0, 61440, 65536) 1 entries of 256 used
Entering add_active_range(0, 65536, 69632) 1 entries of 256 used
Entering add_active_range(0, 69632, 73728) 1 entries of 256 used
Entering add_active_range(0, 73728, 77824) 1 entries of 256 used
Entering add_active_range(0, 77824, 81920) 1 entries of 256 used
Entering add_active_range(0, 81920, 86016) 1 entries of 256 used
Entering add_active_range(0, 86016, 90112) 1 entries of 256 used
Entering add_active_range(0, 90112, 94208) 1 entries of 256 used
Entering add_active_range(0, 94208, 98304) 1 entries of 256 used
Entering add_active_range(0, 98304, 102400) 1 entries of 256 used
Entering add_active_range(0, 102400, 106496) 1 entries of 256 used
Entering add_active_range(0, 106496, 110592) 1 entries of 256 used
Entering add_active_range(0, 110592, 114688) 1 entries of 256 used
Entering add_active_range(0, 114688, 118784) 1 entries of 256 used
Entering add_active_range(0, 118784, 122880) 1 entries of 256 used
Entering add_active_range(0, 122880, 126976) 1 entries of 256 used
Entering add_active_range(0, 126976, 131072) 1 entries of 256 used
Entering add_active_range(0, 131072, 135168) 1 entries of 256 used
Entering add_active_range(0, 135168, 139264) 1 entries of 256 used
Entering add_active_range(0, 139264, 143360) 1 entries of 256 used
Entering add_active_range(0, 143360, 147456) 1 entries of 256 used
Entering add_active_range(0, 147456, 151552) 1 entries of 256 used
Entering add_active_range(0, 151552, 155648) 1 entries of 256 used
Entering add_active_range(0, 155648, 159744) 1 entries of 256 used
Entering add_active_range(0, 159744, 163840) 1 entries of 256 used
Entering add_active_range(0, 163840, 167936) 1 entries of 256 used
Entering add_active_range(0, 167936, 172032) 1 entries of 256 used
Entering add_active_range(0, 172032, 176128) 1 entries of 256 used
Entering add_active_range(0, 176128, 180224) 1 entries of 256 used
Entering add_active_range(0, 180224, 184320) 1 entries of 256 used
Entering add_active_range(0, 184320, 188416) 1 entries of 256 used
Entering add_active_range(0, 188416, 192512) 1 entries of 256 used
Entering add_active_range(0, 192512, 196608) 1 entries of 256 used
Entering add_active_range(0, 196608, 200704) 1 entries of 256 used
Entering add_active_range(0, 200704, 204800) 1 entries of 256 used
Entering add_active_range(0, 204800, 208896) 1 entries of 256 used
Entering add_active_range(0, 208896, 212992) 1 entries of 256 used
Entering add_active_range(0, 212992, 217088) 1 entries of 256 used
Entering add_active_range(0, 217088, 221184) 1 entries of 256 used
Entering add_active_range(0, 221184, 225280) 1 entries of 256 used
Entering add_active_range(0, 225280, 229376) 1 entries of 256 used
Entering add_active_range(0, 229376, 233472) 1 entries of 256 used
Entering add_active_range(0, 233472, 237568) 1 entries of 256 used
Entering add_active_range(0, 237568, 241664) 1 entries of 256 used
Entering add_active_range(0, 241664, 245760) 1 entries of 256 used
Entering add_active_range(0, 245760, 249856) 1 entries of 256 used
Entering add_active_range(0, 249856, 253952) 1 entries of 256 used
Entering add_active_range(0, 253952, 258048) 1 entries of 256 used
Entering add_active_range(0, 258048, 262144) 1 entries of 256 used
Entering add_active_range(0, 262144, 266240) 1 entries of 256 used
Entering add_active_range(0, 266240, 270336) 1 entries of 256 used
Entering add_active_range(0, 270336, 274432) 1 entries of 256 used
Entering add_active_range(0, 274432, 278528) 1 entries of 256 used
Entering add_active_range(0, 278528, 282624) 1 entries of 256 used
Entering add_active_range(0, 282624, 286720) 1 entries of 256 used
Entering add_active_range(0, 286720, 290816) 1 entries of 256 used
Entering add_active_range(0, 290816, 294912) 1 entries of 256 used
Entering add_active_range(0, 294912, 299008) 1 entries of 256 used
Entering add_active_range(0, 299008, 303104) 1 entries of 256 used
Entering add_active_range(0, 303104, 307200) 1 entries of 256 used
Entering add_active_range(0, 307200, 311296) 1 entries of 256 used
Entering add_active_range(0, 311296, 315392) 1 entries of 256 used
Entering add_active_range(0, 315392, 319488) 1 entries of 256 used
Entering add_active_range(0, 319488, 323584) 1 entries of 256 used
Entering add_active_range(0, 323584, 327680) 1 entries of 256 used
Entering add_active_range(0, 327680, 331776) 1 entries of 256 used
Entering add_active_range(0, 331776, 335872) 1 entries of 256 used
Entering add_active_range(0, 335872, 339968) 1 entries of 256 used
Entering add_active_range(0, 339968, 344064) 1 entries of 256 used
Entering add_active_range(0, 344064, 348160) 1 entries of 256 used
Entering add_active_range(0, 348160, 352256) 1 entries of 256 used
Entering add_active_range(0, 352256, 356352) 1 entries of 256 used
Entering add_active_range(0, 356352, 360448) 1 entries of 256 used
Entering add_active_range(0, 360448, 364544) 1 entries of 256 used
Entering add_active_range(0, 364544, 368640) 1 entries of 256 used
Entering add_active_range(0, 368640, 372736) 1 entries of 256 used
Entering add_active_range(0, 372736, 376832) 1 entries of 256 used
Entering add_active_range(0, 376832, 380928) 1 entries of 256 used
Entering add_active_range(0, 380928, 385024) 1 entries of 256 used
Entering add_active_range(0, 385024, 389120) 1 entries of 256 used
Entering add_active_range(0, 389120, 393216) 1 entries of 256 used
Entering add_active_range(0, 393216, 397312) 1 entries of 256 used
Entering add_active_range(0, 397312, 401408) 1 entries of 256 used
Entering add_active_range(0, 401408, 405504) 1 entries of 256 used
Entering add_active_range(0, 405504, 409600) 1 entries of 256 used
Entering add_active_range(0, 409600, 413696) 1 entries of 256 used
Entering add_active_range(0, 413696, 417792) 1 entries of 256 used
Entering add_active_range(0, 417792, 421888) 1 entries of 256 used
Entering add_active_range(0, 421888, 425984) 1 entries of 256 used
Entering add_active_range(0, 425984, 430080) 1 entries of 256 used
Entering add_active_range(0, 430080, 434176) 1 entries of 256 used
Entering add_active_range(0, 434176, 438272) 1 entries of 256 used
Entering add_active_range(0, 438272, 442368) 1 entries of 256 used
Entering add_active_range(0, 442368, 446464) 1 entries of 256 used
Entering add_active_range(0, 446464, 450560) 1 entries of 256 used
Entering add_active_range(0, 450560, 454656) 1 entries of 256 used
Entering add_active_range(0, 454656, 458752) 1 entries of 256 used
Entering add_active_range(0, 458752, 462848) 1 entries of 256 used
Entering add_active_range(0, 462848, 466944) 1 entries of 256 used
Entering add_active_range(0, 466944, 471040) 1 entries of 256 used
Entering add_active_range(0, 471040, 475136) 1 entries of 256 used
Entering add_active_range(0, 475136, 479232) 1 entries of 256 used
Entering add_active_range(0, 479232, 483328) 1 entries of 256 used
Entering add_active_range(0, 483328, 487424) 1 entries of 256 used
Entering add_active_range(0, 487424, 491520) 1 entries of 256 used
Entering add_active_range(0, 491520, 495616) 1 entries of 256 used
Entering add_active_range(0, 495616, 499712) 1 entries of 256 used
Entering add_active_range(0, 499712, 503808) 1 entries of 256 used
Entering add_active_range(0, 503808, 507904) 1 entries of 256 used
Entering add_active_range(0, 507904, 512000) 1 entries of 256 used
Entering add_active_range(0, 512000, 516096) 1 entries of 256 used
Entering add_active_range(0, 516096, 520192) 1 entries of 256 used
Entering add_active_range(0, 520192, 524288) 1 entries of 256 used
Entering add_active_range(0, 524288, 528384) 1 entries of 256 used
Entering add_active_range(0, 528384, 532480) 1 entries of 256 used
Entering add_active_range(0, 532480, 536576) 1 entries of 256 used
Entering add_active_range(0, 536576, 540672) 1 entries of 256 used
Entering add_active_range(0, 540672, 544768) 1 entries of 256 used
Entering add_active_range(0, 544768, 548864) 1 entries of 256 used
Entering add_active_range(0, 548864, 552960) 1 entries of 256 used
Entering add_active_range(0, 552960, 557056) 1 entries of 256 used
Entering add_active_range(0, 557056, 561152) 1 entries of 256 used
Entering add_active_range(0, 561152, 565248) 1 entries of 256 used
Entering add_active_range(0, 565248, 569344) 1 entries of 256 used
Entering add_active_range(0, 569344, 573440) 1 entries of 256 used
Entering add_active_range(0, 573440, 577536) 1 entries of 256 used
Entering add_active_range(0, 577536, 581632) 1 entries of 256 used
Entering add_active_range(0, 581632, 585728) 1 entries of 256 used
Entering add_active_range(0, 585728, 589824) 1 entries of 256 used
Entering add_active_range(0, 589824, 593920) 1 entries of 256 used
Entering add_active_range(0, 593920, 598016) 1 entries of 256 used
Entering add_active_range(0, 598016, 602112) 1 entries of 256 used
Entering add_active_range(0, 602112, 606208) 1 entries of 256 used
Entering add_active_range(0, 606208, 610304) 1 entries of 256 used
Entering add_active_range(0, 610304, 614400) 1 entries of 256 used
Entering add_active_range(0, 614400, 618496) 1 entries of 256 used
Entering add_active_range(0, 618496, 622592) 1 entries of 256 used
Entering add_active_range(0, 622592, 626688) 1 entries of 256 used
Entering add_active_range(0, 626688, 630784) 1 entries of 256 used
Entering add_active_range(0, 630784, 634880) 1 entries of 256 used
Entering add_active_range(0, 634880, 638976) 1 entries of 256 used
Entering add_active_range(0, 638976, 643072) 1 entries of 256 used
Entering add_active_range(0, 643072, 647168) 1 entries of 256 used
Entering add_active_range(0, 647168, 651264) 1 entries of 256 used
Entering add_active_range(0, 651264, 655360) 1 entries of 256 used
Entering add_active_range(0, 655360, 659456) 1 entries of 256 used
Entering add_active_range(0, 659456, 663552) 1 entries of 256 used
Entering add_active_range(0, 663552, 667648) 1 entries of 256 used
Entering add_active_range(0, 667648, 671744) 1 entries of 256 used
Entering add_active_range(0, 671744, 675840) 1 entries of 256 used
Entering add_active_range(0, 675840, 679936) 1 entries of 256 used
Entering add_active_range(0, 679936, 684032) 1 entries of 256 used
Entering add_active_range(0, 684032, 688128) 1 entries of 256 used
Entering add_active_range(0, 688128, 692224) 1 entries of 256 used
Entering add_active_range(0, 692224, 696320) 1 entries of 256 used
Entering add_active_range(0, 696320, 700416) 1 entries of 256 used
Entering add_active_range(0, 700416, 704512) 1 entries of 256 used
Entering add_active_range(0, 704512, 708608) 1 entries of 256 used
Entering add_active_range(0, 708608, 712704) 1 entries of 256 used
Entering add_active_range(0, 712704, 716800) 1 entries of 256 used
Entering add_active_range(0, 716800, 720896) 1 entries of 256 used
Entering add_active_range(0, 720896, 724992) 1 entries of 256 used
Entering add_active_range(0, 724992, 729088) 1 entries of 256 used
Entering add_active_range(0, 729088, 733184) 1 entries of 256 used
Entering add_active_range(0, 733184, 737280) 1 entries of 256 used
Entering add_active_range(0, 737280, 741376) 1 entries of 256 used
Entering add_active_range(0, 741376, 745472) 1 entries of 256 used
Entering add_active_range(0, 745472, 749568) 1 entries of 256 used
Entering add_active_range(0, 749568, 753664) 1 entries of 256 used
Entering add_active_range(0, 753664, 757760) 1 entries of 256 used
Entering add_active_range(0, 757760, 761856) 1 entries of 256 used
Entering add_active_range(0, 761856, 765952) 1 entries of 256 used
Entering add_active_range(0, 765952, 770048) 1 entries of 256 used
Entering add_active_range(0, 770048, 774144) 1 entries of 256 used
Entering add_active_range(0, 774144, 778240) 1 entries of 256 used
Entering add_active_range(0, 778240, 782336) 1 entries of 256 used
Entering add_active_range(0, 782336, 786432) 1 entries of 256 used
Entering add_active_range(0, 786432, 790528) 1 entries of 256 used
Entering add_active_range(0, 790528, 794624) 1 entries of 256 used
Entering add_active_range(0, 794624, 798720) 1 entries of 256 used
Entering add_active_range(0, 798720, 802816) 1 entries of 256 used
Entering add_active_range(0, 802816, 806912) 1 entries of 256 used
Entering add_active_range(0, 806912, 811008) 1 entries of 256 used
Entering add_active_range(0, 811008, 815104) 1 entries of 256 used
Entering add_active_range(0, 815104, 819200) 1 entries of 256 used
Entering add_active_range(0, 819200, 823296) 1 entries of 256 used
Entering add_active_range(0, 823296, 827392) 1 entries of 256 used
Entering add_active_range(0, 827392, 831488) 1 entries of 256 used
Entering add_active_range(0, 831488, 835584) 1 entries of 256 used
Entering add_active_range(0, 835584, 839680) 1 entries of 256 used
Entering add_active_range(0, 839680, 843776) 1 entries of 256 used
Entering add_active_range(0, 843776, 847872) 1 entries of 256 used
Entering add_active_range(0, 847872, 851968) 1 entries of 256 used
Entering add_active_range(0, 851968, 856064) 1 entries of 256 used
Entering add_active_range(0, 856064, 860160) 1 entries of 256 used
Entering add_active_range(0, 860160, 864256) 1 entries of 256 used
Entering add_active_range(0, 864256, 868352) 1 entries of 256 used
Entering add_active_range(0, 868352, 872448) 1 entries of 256 used
Entering add_active_range(0, 872448, 876544) 1 entries of 256 used
Entering add_active_range(0, 876544, 880640) 1 entries of 256 used
Entering add_active_range(0, 880640, 884736) 1 entries of 256 used
Entering add_active_range(0, 884736, 888832) 1 entries of 256 used
Entering add_active_range(0, 888832, 892928) 1 entries of 256 used
Entering add_active_range(0, 892928, 897024) 1 entries of 256 used
Entering add_active_range(0, 897024, 901120) 1 entries of 256 used
Entering add_active_range(0, 901120, 905216) 1 entries of 256 used
Entering add_active_range(0, 905216, 909312) 1 entries of 256 used
Entering add_active_range(0, 909312, 913408) 1 entries of 256 used
Entering add_active_range(0, 913408, 917504) 1 entries of 256 used
Entering add_active_range(0, 917504, 921600) 1 entries of 256 used
Entering add_active_range(0, 921600, 925696) 1 entries of 256 used
Entering add_active_range(0, 925696, 929792) 1 entries of 256 used
Entering add_active_range(0, 929792, 933888) 1 entries of 256 used
Entering add_active_range(0, 933888, 937984) 1 entries of 256 used
Entering add_active_range(0, 937984, 942080) 1 entries of 256 used
Entering add_active_range(0, 942080, 946176) 1 entries of 256 used
Entering add_active_range(0, 946176, 950272) 1 entries of 256 used
Entering add_active_range(0, 950272, 954368) 1 entries of 256 used
Entering add_active_range(0, 954368, 958464) 1 entries of 256 used
Entering add_active_range(0, 958464, 962560) 1 entries of 256 used
Entering add_active_range(0, 962560, 966656) 1 entries of 256 used
Entering add_active_range(0, 966656, 970752) 1 entries of 256 used
Entering add_active_range(0, 970752, 974848) 1 entries of 256 used
Entering add_active_range(0, 974848, 978944) 1 entries of 256 used
Entering add_active_range(0, 978944, 983040) 1 entries of 256 used
Entering add_active_range(0, 983040, 987136) 1 entries of 256 used
Entering add_active_range(0, 987136, 991232) 1 entries of 256 used
Entering add_active_range(0, 991232, 995328) 1 entries of 256 used
Entering add_active_range(0, 995328, 999424) 1 entries of 256 used
Entering add_active_range(0, 999424, 1003520) 1 entries of 256 used
Entering add_active_range(0, 1003520, 1007616) 1 entries of 256 used
Entering add_active_range(0, 1007616, 1011712) 1 entries of 256 used
Entering add_active_range(0, 1011712, 1015808) 1 entries of 256 used
Entering add_active_range(0, 1015808, 1019904) 1 entries of 256 used
Entering add_active_range(0, 1019904, 1024000) 1 entries of 256 used
Entering add_active_range(0, 1024000, 1028096) 1 entries of 256 used
Entering add_active_range(0, 1028096, 1032192) 1 entries of 256 used
Entering add_active_range(0, 1032192, 1036288) 1 entries of 256 used
Entering add_active_range(0, 1036288, 1040384) 1 entries of 256 used
Entering add_active_range(0, 1040384, 1044480) 1 entries of 256 used
Entering add_active_range(0, 1044480, 1048576) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1052672) 1 entries of 256 used
Entering add_active_range(0, 1052672, 1056768) 1 entries of 256 used
Entering add_active_range(0, 1056768, 1060864) 1 entries of 256 used
Entering add_active_range(0, 1060864, 1064960) 1 entries of 256 used
Entering add_active_range(0, 1064960, 1069056) 1 entries of 256 used
Entering add_active_range(0, 1069056, 1073152) 1 entries of 256 used
Entering add_active_range(0, 1073152, 1077248) 1 entries of 256 used
Entering add_active_range(0, 1077248, 1081344) 1 entries of 256 used
Entering add_active_range(0, 1081344, 1085440) 1 entries of 256 used
Entering add_active_range(0, 1085440, 1089536) 1 entries of 256 used
Entering add_active_range(0, 1089536, 1093632) 1 entries of 256 used
Entering add_active_range(0, 1093632, 1097728) 1 entries of 256 used
Entering add_active_range(0, 1097728, 1101824) 1 entries of 256 used
Entering add_active_range(0, 1101824, 1105920) 1 entries of 256 used
Entering add_active_range(0, 1105920, 1110016) 1 entries of 256 used
Entering add_active_range(0, 1110016, 1114112) 1 entries of 256 used
Entering add_active_range(0, 1114112, 1118208) 1 entries of 256 used
Entering add_active_range(0, 1118208, 1122304) 1 entries of 256 used
Entering add_active_range(0, 1122304, 1126400) 1 entries of 256 used
Entering add_active_range(0, 1126400, 1130496) 1 entries of 256 used
Entering add_active_range(0, 1130496, 1134592) 1 entries of 256 used
Entering add_active_range(0, 1134592, 1138688) 1 entries of 256 used
Entering add_active_range(0, 1138688, 1142784) 1 entries of 256 used
Entering add_active_range(0, 1142784, 1146880) 1 entries of 256 used
Entering add_active_range(0, 1146880, 1150976) 1 entries of 256 used
Entering add_active_range(0, 1150976, 1155072) 1 entries of 256 used
Entering add_active_range(0, 1155072, 1159168) 1 entries of 256 used
Entering add_active_range(0, 1159168, 1163264) 1 entries of 256 used
Entering add_active_range(0, 1163264, 1167360) 1 entries of 256 used
Entering add_active_range(0, 1167360, 1171456) 1 entries of 256 used
Entering add_active_range(0, 1171456, 1175552) 1 entries of 256 used
Entering add_active_range(0, 1175552, 1179648) 1 entries of 256 used
Entering add_active_range(0, 1179648, 1183744) 1 entries of 256 used
Entering add_active_range(0, 1183744, 1187840) 1 entries of 256 used
Entering add_active_range(0, 1187840, 1191936) 1 entries of 256 used
Entering add_active_range(0, 1191936, 1196032) 1 entries of 256 used
Entering add_active_range(0, 1196032, 1200128) 1 entries of 256 used
Entering add_active_range(0, 1200128, 1204224) 1 entries of 256 used
Entering add_active_range(0, 1204224, 1208320) 1 entries of 256 used
Entering add_active_range(0, 1208320, 1212416) 1 entries of 256 used
Entering add_active_range(0, 1212416, 1216512) 1 entries of 256 used
Entering add_active_range(0, 1216512, 1220608) 1 entries of 256 used
Entering add_active_range(0, 1220608, 1224704) 1 entries of 256 used
Entering add_active_range(0, 1224704, 1228800) 1 entries of 256 used
Entering add_active_range(0, 1228800, 1232896) 1 entries of 256 used
Entering add_active_range(0, 1232896, 1236992) 1 entries of 256 used
Entering add_active_range(0, 1236992, 1241088) 1 entries of 256 used
Entering add_active_range(0, 1241088, 1245184) 1 entries of 256 used
Entering add_active_range(0, 1245184, 1249280) 1 entries of 256 used
Entering add_active_range(0, 1249280, 1253376) 1 entries of 256 used
Entering add_active_range(0, 1253376, 1257472) 1 entries of 256 used
Entering add_active_range(0, 1257472, 1261568) 1 entries of 256 used
Entering add_active_range(0, 1261568, 1265664) 1 entries of 256 used
Entering add_active_range(0, 1265664, 1269760) 1 entries of 256 used
Entering add_active_range(0, 1269760, 1273856) 1 entries of 256 used
Entering add_active_range(0, 1273856, 1277952) 1 entries of 256 used
Entering add_active_range(0, 1277952, 1282048) 1 entries of 256 used
Entering add_active_range(0, 1282048, 1286144) 1 entries of 256 used
Entering add_active_range(0, 1286144, 1290240) 1 entries of 256 used
Entering add_active_range(0, 1290240, 1294336) 1 entries of 256 used
Entering add_active_range(0, 1294336, 1298432) 1 entries of 256 used
Entering add_active_range(0, 1298432, 1302528) 1 entries of 256 used
Entering add_active_range(0, 1302528, 1306624) 1 entries of 256 used
Entering add_active_range(0, 1306624, 1310720) 1 entries of 256 used
Entering add_active_range(0, 1310720, 1314816) 1 entries of 256 used
Entering add_active_range(0, 1314816, 1318912) 1 entries of 256 used
Entering add_active_range(0, 1318912, 1323008) 1 entries of 256 used
Entering add_active_range(0, 1323008, 1327104) 1 entries of 256 used
Entering add_active_range(0, 1327104, 1331200) 1 entries of 256 used
Entering add_active_range(0, 1331200, 1335296) 1 entries of 256 used
Entering add_active_range(0, 1335296, 1339392) 1 entries of 256 used
Entering add_active_range(0, 1339392, 1343488) 1 entries of 256 used
Entering add_active_range(0, 1343488, 1347584) 1 entries of 256 used
Entering add_active_range(0, 1347584, 1351680) 1 entries of 256 used
Entering add_active_range(0, 1351680, 1355776) 1 entries of 256 used
Entering add_active_range(0, 1355776, 1359872) 1 entries of 256 used
Entering add_active_range(0, 1359872, 1363968) 1 entries of 256 used
Entering add_active_range(0, 1363968, 1368064) 1 entries of 256 used
Entering add_active_range(0, 1368064, 1372160) 1 entries of 256 used
Entering add_active_range(0, 1372160, 1376256) 1 entries of 256 used
Entering add_active_range(0, 1376256, 1380352) 1 entries of 256 used
Entering add_active_range(0, 1380352, 1384448) 1 entries of 256 used
Entering add_active_range(0, 1384448, 1388544) 1 entries of 256 used
Entering add_active_range(0, 1388544, 1392640) 1 entries of 256 used
Entering add_active_range(0, 1392640, 1396736) 1 entries of 256 used
Entering add_active_range(0, 1396736, 1400832) 1 entries of 256 used
Entering add_active_range(0, 1400832, 1404928) 1 entries of 256 used
Entering add_active_range(0, 1404928, 1409024) 1 entries of 256 used
Entering add_active_range(0, 1409024, 1413120) 1 entries of 256 used
Entering add_active_range(0, 1413120, 1417216) 1 entries of 256 used
Entering add_active_range(0, 1417216, 1421312) 1 entries of 256 used
Entering add_active_range(0, 1421312, 1425408) 1 entries of 256 used
Entering add_active_range(0, 1425408, 1429504) 1 entries of 256 used
Entering add_active_range(0, 1429504, 1433600) 1 entries of 256 used
Entering add_active_range(0, 1433600, 1437696) 1 entries of 256 used
Entering add_active_range(0, 1437696, 1441792) 1 entries of 256 used
Entering add_active_range(0, 1441792, 1445888) 1 entries of 256 used
Entering add_active_range(0, 1445888, 1449984) 1 entries of 256 used
Entering add_active_range(0, 1449984, 1454080) 1 entries of 256 used
Entering add_active_range(0, 1454080, 1458176) 1 entries of 256 used
Entering add_active_range(0, 1458176, 1462272) 1 entries of 256 used
Entering add_active_range(0, 1462272, 1466368) 1 entries of 256 used
Entering add_active_range(0, 1466368, 1470464) 1 entries of 256 used
Entering add_active_range(0, 1470464, 1474560) 1 entries of 256 used
Entering add_active_range(0, 1474560, 1478656) 1 entries of 256 used
Entering add_active_range(0, 1478656, 1482752) 1 entries of 256 used
Entering add_active_range(0, 1482752, 1486848) 1 entries of 256 used
Entering add_active_range(0, 1486848, 1490944) 1 entries of 256 used
Entering add_active_range(0, 1490944, 1495040) 1 entries of 256 used
Entering add_active_range(0, 1495040, 1499136) 1 entries of 256 used
Entering add_active_range(0, 1499136, 1503232) 1 entries of 256 used
Entering add_active_range(0, 1503232, 1507328) 1 entries of 256 used
Entering add_active_range(0, 1507328, 1511424) 1 entries of 256 used
Entering add_active_range(0, 1511424, 1515520) 1 entries of 256 used
Entering add_active_range(0, 1515520, 1519616) 1 entries of 256 used
Entering add_active_range(0, 1519616, 1523712) 1 entries of 256 used
Entering add_active_range(0, 1523712, 1527808) 1 entries of 256 used
Entering add_active_range(0, 1527808, 1531904) 1 entries of 256 used
Entering add_active_range(0, 1531904, 1536000) 1 entries of 256 used
Entering add_active_range(0, 1536000, 1540096) 1 entries of 256 used
Entering add_active_range(0, 1540096, 1544192) 1 entries of 256 used
Entering add_active_range(0, 1544192, 1548288) 1 entries of 256 used
Entering add_active_range(0, 1548288, 1552384) 1 entries of 256 used
Entering add_active_range(0, 1552384, 1556480) 1 entries of 256 used
Entering add_active_range(0, 1556480, 1560576) 1 entries of 256 used
Entering add_active_range(0, 1560576, 1564672) 1 entries of 256 used
Entering add_active_range(0, 1564672, 1568768) 1 entries of 256 used
Entering add_active_range(0, 1568768, 1572864) 1 entries of 256 used
Node 0 Memory: 0x0-0x180000000
PCI host bridge /pci@800000020000003  ranges:
  IO 0x000003fe00300000..0x000003fe003fffff -> 0x0000000000000000
 MEM 0x0000040080000000..0x00000400bfffffff -> 0x00000000c0000000 
PCI host bridge /pci@800000020000004  ranges:
  IO 0x000003fe00400000..0x000003fe004fffff -> 0x0000000000000000
 MEM 0x00000400c0000000..0x00000400ffffffff -> 0x00000000c0000000 
EEH: PCI Enhanced I/O Error Handling Enabled
PPC64 nvram contains 7168 bytes
Using shared processor idle loop
Zone PFN ranges:
  DMA             0 ->  1572864
  Normal    1572864 ->  1572864
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1572864
On node 0 totalpages: 1572864
  DMA zone: 21504 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 1551360 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
[boot]0015 Setup Done
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1551360
Policy zone: DMA
Kernel command line: root=/dev/disk/by-id/scsi-SIBM_H0ST373453LC_3HW2TBBT00007530W7P4-part3  sysrq=1 quiet 
[boot]0020 XICS Init
xics: no ISA interrupt controller
[boot]0021 XICS Done
PID hash table entries: 4096 (order: 12, 32768 bytes)
time_init: decrementer frequency = 187.198000 MHz
time_init: processor frequency   = 1495.503000 MHz
clocksource: timebase mult[155e24d] shift[22] registered
clockevent: decrementer mult[2fec] shift[16] cpu[0]
Console: colour dummy device 80x25
console handover: boot [udbg-1] -> real [hvc0]
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
freeing bootmem node 0
Memory: 6158968k/6291456k available (6480k kernel code, 132488k reserved, 1104k data, 992k bss, 316k init)
Calibrating delay loop... 373.55 BogoMIPS (lpj=1867776)
Security Framework initialized
AppArmor: AppArmor initialized
AppArmor: Unable to log event (1505) to audit subsys
AppArmor: Registered secondary security module name="capability"
AppArmor: Unable to log event (1505) to audit subsys
Capability LSM initialized as secondary
Failure registering Root Plug module with the kernel
AppArmor: Unable to register %s as a secondary security module name="root_plug"
AppArmor: Unable to log event (1505) to audit subsys
Failure registering Root Plug  module with primary security module.
Mount-cache hash table entries: 256
clockevent: decrementer mult[2fec] shift[16] cpu[1]
Processor 1 found.
clockevent: decrementer mult[2fec] shift[16] cpu[2]
Processor 2 found.
clockevent: decrementer mult[2fec] shift[16] cpu[3]
Processor 3 found.
clockevent: decrementer mult[2fec] shift[16] cpu[4]
Processor 4 found.
clockevent: decrementer mult[2fec] shift[16] cpu[5]
Processor 5 found.
clockevent: decrementer mult[2fec] shift[16] cpu[6]
Processor 6 found.
clockevent: decrementer mult[2fec] shift[16] cpu[7]
Processor 7 found.
Brought up 8 CPUs
Node 0 CPUs: 0-7
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000002
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,00000003 00000000,00000000,00000000,0000000c 00000000,00000000,00000000,00000030 00000000,00000000,00000000,000000c0
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000001
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,00000003 00000000,00000000,00000000,0000000c 00000000,00000000,00000000,00000030 00000000,00000000,00000000,000000c0
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU2 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,0000000c
  groups: 00000000,00000000,00000000,00000004 00000000,00000000,00000000,00000008
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,0000000c 00000000,00000000,00000000,00000030 00000000,00000000,00000000,000000c0 00000000,00000000,00000000,00000003
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU3 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,0000000c
  groups: 00000000,00000000,00000000,00000008 00000000,00000000,00000000,00000004
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,0000000c 00000000,00000000,00000000,00000030 00000000,00000000,00000000,000000c0 00000000,00000000,00000000,00000003
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU4 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000030
  groups: 00000000,00000000,00000000,00000010 00000000,00000000,00000000,00000020
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,00000030 00000000,00000000,00000000,000000c0 00000000,00000000,00000000,00000003 00000000,00000000,00000000,0000000c
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU5 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000030
  groups: 00000000,00000000,00000000,00000020 00000000,00000000,00000000,00000010
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,00000030 00000000,00000000,00000000,000000c0 00000000,00000000,00000000,00000003 00000000,00000000,00000000,0000000c
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU6 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,000000c0
  groups: 00000000,00000000,00000000,00000040 00000000,00000000,00000000,00000080
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,000000c0 00000000,00000000,00000000,00000003 00000000,00000000,00000000,0000000c 00000000,00000000,00000000,00000030
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
CPU7 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,000000c0
  groups: 00000000,00000000,00000000,00000080 00000000,00000000,00000000,00000040
  domain 1: span 00000000,00000000,00000000,000000ff
   groups: 00000000,00000000,00000000,000000c0 00000000,00000000,00000000,00000003 00000000,00000000,00000000,0000000c 00000000,00000000,00000000,00000030
   domain 2: span 00000000,00000000,00000000,000000ff
    groups: 00000000,00000000,00000000,000000ff
net_namespace: 1024 bytes
NET: Registered protocol family 16
IBM eBus Device Driver
PCI: Probing PCI hardware
IOMMU table initialized, virtual merging enabled
PCI: Probing PCI hardware done
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
Time: timebase clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 7
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 2556k freed
RTAS daemon started
RTAS: event: 76, Type: Platform Information Event, Severity: 2
audit: initializing netlink socket (disabled)
type=2000 audit(1204293474.710:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
vio_register_driver: driver hvc_console registering
HVSI: registered 0 devices
Generic RTC Driver v1.07
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
input: Macintosh mouse button emulation as /devices/virtual/input/input0
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
mice: PS/2 mouse device common for all mice
EDAC MC: Ver: 2.1.0 Feb 28 2008
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
registered taskstats version 1
Freeing unused kernel memory: 316k freed
mount used greatest stack depth: 11792 bytes left
cat used greatest stack depth: 11200 bytes left
showconsole used greatest stack depth: 10976 bytes left
showconsole used greatest stack depth: 9984 bytes left
SCSI subsystem initialized
libata version 3.00 loaded.
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
ipr 0000:c0:01.0: Found IOA with IRQ: 321
ipr 0000:c0:01.0: Starting IOA initialization sequence.
ipr 0000:c0:01.0: Adapter firmware version: 020A004E
ipr 0000:c0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
scsi 0:0:3:0: Direct-Access     IBM   H0 ST373453LC       C51C PQ: 0 ANSI: 3
scsi 0:0:4:0: Direct-Access     IBM      HUS151473VL3800  S37A PQ: 0 ANSI: 4
scsi 0:0:5:0: Direct-Access     IBM   H0 HUS151473VL3800  S37A PQ: 0 ANSI: 4
scsi 0:0:8:0: Direct-Access     IBM   H0 HUS151473VL3800  S37A PQ: 0 ANSI: 4
scsi 0:0:15:0: Enclosure         IBM      VSBPD4E1  U4SCSI 4770 PQ: 0 ANSI: 2
scsi: unknown device type 31
scsi 0:255:255:255: No Device         IBM      570B001          0150 PQ: 0 ANSI: 0
modprobe used greatest stack depth: 7520 bytes left
pata_pdc2027x 0000:d0:01.0: version 1.0
PCI: Enabling device 0000:d0:01.0 (0002 -> 0003)
pata_pdc2027x 0000:d0:01.0: PLL input clock 32766 kHz
scsi1 : pata_pdc2027x
scsi2 : pata_pdc2027x
ata1: PATA max UDMA/133 mmio m16384@0x400b0000000 cmd 0x400b00017c0 irq 325
ata2: PATA max UDMA/133 mmio m16384@0x400b0000000 cmd 0x400b00015c0 irq 325
ata1.00: ATAPI: IBM     DROM00205J1   H0, PQ24, max UDMA/66
ata1.00: configured for UDMA/66
scsi 1:0:0:0: CD-ROM            IBM      DROM00205J1   H0 PQ24 PQ: 0 ANSI: 2
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:3:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:3:0: [sda] Write Protect is off
sd 0:0:3:0: [sda] Mode Sense: cb 00 10 08
sd 0:0:3:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:3:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:3:0: [sda] Write Protect is off
sd 0:0:3:0: [sda] Mode Sense: cb 00 10 08
sd 0:0:3:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3
sd 0:0:3:0: [sda] Attached SCSI disk
sd 0:0:4:0: [sdb] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:4:0: [sdb] Write Protect is off
sd 0:0:4:0: [sdb] Mode Sense: cb 00 10 08
sd 0:0:4:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:4:0: [sdb] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:4:0: [sdb] Write Protect is off
sd 0:0:4:0: [sdb] Mode Sense: cb 00 10 08
sd 0:0:4:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 0:0:4:0: [sdb] Attached SCSI disk
sd 0:0:5:0: [sdc] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:5:0: [sdc] Write Protect is off
sd 0:0:5:0: [sdc] Mode Sense: cb 00 10 08
sd 0:0:5:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:5:0: [sdc] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:5:0: [sdc] Write Protect is off
sd 0:0:5:0: [sdc] Mode Sense: cb 00 10 08
sd 0:0:5:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdc: sdc1
sd 0:0:5:0: [sdc] Attached SCSI disk
sd 0:0:8:0: [sdd] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:8:0: [sdd] Write Protect is off
sd 0:0:8:0: [sdd] Mode Sense: cb 00 10 08
sd 0:0:8:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 0:0:8:0: [sdd] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:8:0: [sdd] Write Protect is off
sd 0:0:8:0: [sdd] Mode Sense: cb 00 10 08
sd 0:0:8:0: [sdd] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdd: unknown partition table
sd 0:0:8:0: [sdd] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
mount used greatest stack depth: 7312 bytes left
sd 0:0:3:0: Attached scsi generic sg0 type 0
sd 0:0:4:0: Attached scsi generic sg1 type 0
sd 0:0:5:0: Attached scsi generic sg2 type 0
sd 0:0:8:0: Attached scsi generic sg3 type 0
scsi 0:0:15:0: Attached scsi generic sg4 type 13
scsi 0:255:255:255: Attached scsi generic sg5 type 31
scsi 1:0:0:0: Attached scsi generic sg6 type 5
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
PCI: Enabling device 0001:c0:01.0 (0000 -> 0003)
IBM eServer i/pSeries Virtual SCSI Target Driver
vio_register_driver: driver ibmvscsis registering
Unable to handle kernel paging request for data at address 0x000001c0
Faulting instruction address: 0xd00000000009ed80
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA pSeries
Modules linked in: ibmvstgt(+) ses(+) e1000(+) enclosure libsrp scsi_transport_srp scsi_tgt sg sd_mod pata_pdc2027x ipr libata scsi_mod firmware_class
NIP: d00000000009ed80 LR: d00000000009ed7c CTR: c000000000219874
REGS: c00000017c397270 TRAP: 0300   Tainted: G        N  (2.6.25-rc3-20080228160715-ppc64)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24022484  XER: 00000010
DAR: 00000000000001c0, DSISR: 0000000040000000
TASK = c00000017c84aa60[660] 'modprobe' THREAD: c00000017c394000 CPU: 6
GPR00: d00000000009ed7c c00000017c3974f0 d0000000000daff8 c00000017c7a4810 
GPR04: 00000000ffffffff 0000000000000000 c00000017cd7b200 c0000000006a9228 
GPR08: 0000000000000002 c00000000085d300 0000000000000071 c000000000219874 
GPR12: d0000000000a84e0 c0000000006c0f00 d00000000011ee70 d000000000145d50 
GPR16: c00000017c397cc0 000000000000008f 0000000000000007 d00000000011e670 
GPR20: 0000000000000000 0000000000000124 000000000000001e d000000000117000 
GPR24: c00000017cdfbdf8 c00000017cdfb000 c00000017c5f5c00 d000000000145b78 
GPR28: 0000000000000000 c00000017cdfb000 d0000000000d90b8 c00000017c7a4810 
NIP [d00000000009ed80] .__scsi_alloc_queue+0xa4/0x130 [scsi_mod]
LR [d00000000009ed7c] .__scsi_alloc_queue+0xa0/0x130 [scsi_mod]
Call Trace:
[c00000017c3974f0] [d00000000009ed7c] .__scsi_alloc_queue+0xa0/0x130 [scsi_mod] (unreliable)
[c00000017c397580] [d0000000000305b0] .scsi_tgt_alloc_queue+0x2c/0xf0 [scsi_tgt]
[c00000017c397610] [d000000000141a94] .ibmvstgt_probe+0x84/0x3c4 [ibmvstgt]
[c00000017c3976d0] [c000000000022588] .vio_bus_probe+0x60/0x84
[c00000017c397760] [c0000000002ed0d4] .driver_probe_device+0x114/0x1fc
[c00000017c397800] [c0000000002ed26c] .__driver_attach+0xb0/0x134
[c00000017c397890] [c0000000002ec550] .bus_for_each_dev+0x7c/0xdc
[c00000017c397950] [c0000000002ece60] .driver_attach+0x28/0x40
[c00000017c3979d0] [c0000000002ebb34] .bus_add_driver+0xd0/0x284
[c00000017c397a70] [c0000000002ed580] .driver_register+0x94/0x16c
[c00000017c397b20] [c000000000022ab4] .vio_register_driver+0x44/0x60
[c00000017c397bb0] [d000000000141ff4] .ibmvstgt_init+0x154/0x1a4 [ibmvstgt]
[c00000017c397c40] [c0000000000a99c8] .sys_init_module+0x1a50/0x1bc8
[c00000017c397e30] [c000000000008748] syscall_exit+0x0/0x40
Instruction dump:
78091fe1 40820010 e93e8000 e8090000 780464e4 7fe3fb78 4800a169 e8410028 
7fe3fb78 e89d0110 48009769 e8410028 <e93c01c0> e81d0110 2fa90000 419e0008 
---[ end trace 490d9aacf75eeba4 ]---
scsi 0:0:15:0: Resetting device
scsi 0:0:15:0: Resetting device
scsi 0:0:15:0: Resetting device
scsi 0:0:15:0: Resetting device
e1000: 0001:c0:01.0: e1000_probe: (PCI-X:133MHz:64-bit) 00:0d:60:4d:22:86
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
PCI: Enabling device 0001:c0:01.1 (0000 -> 0003)
Driver 'ses' needs updating - please use bus_type methods
ses 0:0:15:0: Attached Enclosure device
e1000: 0001:c0:01.1: e1000_probe: (PCI-X:133MHz:64-bit) 00:0d:60:4d:22:87
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
RTAS: event: 77, Type: Platform Information Event, Severity: 2
Adding 2096472k swap on /dev/sda2.  Priority:-1 extents:1 across:2096472k
md: md0 stopped.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
md: bind<sdc1>
md: bind<sdb1>
md: raid0 personality registered for level 0
md0: setting max_sectors to 64, segment boundary to 16383
raid0: looking at sdb1
raid0:   comparing sdb1(71686016) with sdb1(71686016)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at sdc1
raid0:   comparing sdc1(71686016) with sdb1(71686016)
raid0:   EQUAL
raid0: FINAL 1 zones
raid0: done.
raid0 : md_size is 143372032 blocks.
raid0 : conf->hash_spacing is 143372032 blocks.
raid0 : nb_zone is 1.
raid0 : Allocating 8 bytes for hash.
loop: module loaded
mv used greatest stack depth: 6784 bytes left
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ioctl32(mouseemu:1453): Unknown cmd fd(5) cmd(80045564){t:'U';sz:4} arg(00000001) on /dev/input/uinput
ioctl32(mouseemu:1453): Unknown cmd fd(5) cmd(80045564){t:'U';sz:4} arg(00000014) on /dev/input/uinput
ioctl32(mouseemu:1453): Unknown cmd fd(5) cmd(80045565){t:'U';sz:4} arg(00000000) on /dev/input/uinput
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
fgrep used greatest stack depth: 6512 bytes left
cp used greatest stack depth: 6480 bytes left
cat used greatest stack depth: 6416 bytes left
rpm used greatest stack depth: 6320 bytes left
