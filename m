From: Olaf Hering <olh@suse.de>
Subject: bogus error handling in qla2x00_iospace_config
Date: Fri, 11 Aug 2006 19:44:25 +0200
Message-ID: <20060811174425.GA32639@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:37325 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932393AbWHKRoc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 13:44:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org


Andrew,

the oops below was reported from a user with a qla card in an Apple
Xserve G5. I have to check if the request_region() is obsolete with
current kernels, but the qla driver should not crash either way.



https://bugzilla.novell.com/show_bug.cgi?id=195931
.
.
.
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected Apple U3H chipset
agpgart: configuring for size idx: 64
agpgart: AGP aperture is 256M @ 0x0
QLogic Fibre Channel HBA Driver
PCI: Enabling device: (0001:06:02.0), cmd 7
PCI: Unable to reserve I/O region #1:100@0 for device 0001:06:02.0
qla2xxx 0001:06:02.0: Failed to reserve PIO/MMIO regions (0001:06:02.0)
Unable to handle kernel paging request for data at address 0x00000000
Faulting instruction address: 0xd0000000004e163c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=128 NUMA POWERMAC 
Modules linked in: qla2xxx scsi_transport_fc uninorth_agp agpgart firmware_class
 tg3 snd_powermac snd_pcm snd_page_alloc snd_timer snd soundcore sbp2 ohci1394
sg ieee1394 sata_svw libata sd_mod scsi_mod
NIP: D0000000004E163C LR: D0000000004C16AC CTR: 0000000000000001
REGS: c00000000f43f220 TRAP: 0300   Not tainted  (2.6.16.20-2-ppc64)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24222422  XER: 00000000
DAR: 0000000000000000, DSISR: 0000000040000000
TASK = c00000000f8a6f50[1622] 'modprobe' THREAD: c00000000f43c000 CPU: 1
GPR00: 0000000000000000 C00000000F43F4A0 D000000000503688 C00000007E0DC458 
GPR04: 9000000000009032 FFFFFFFFFFFFFFFF C00000000F43F5F8 C0000000004B9B38 
GPR08: 000000000007FFFF 0000000000000000 FFFFFFFFFFFFFFFF C00000007E0DE670 
GPR12: D0000000004E5658 C00000000048B080 D0000000004A78F0 0000000000000000 
GPR16: D0000000004A78B0 00000000000002D4 D0000000004A6D3F C000000002FA1800 
GPR20: C00000000F43C000 000000000000002A FFFFFFFFFFFFFFF4 C00000007E0DC000 
GPR24: 000000000000002A 0000000000000000 0000000000000020 0000000000000000 
GPR28: C00000007E0DC458 C00000007E0DF130 D000000000501300 C00000007E0DF138 
NIP [D0000000004E163C] .qla2x00_cancel_io_descriptors+0xcc/0x15c [qla2xxx]
LR [D0000000004C16AC] .qla2x00_free_device+0x38/0x18c [qla2xxx]
Call Trace:
[C00000000F43F4A0] [C00000000F43C000] 0xc00000000f43c000 (unreliable)
[C00000000F43F540] [D0000000004C16AC] .qla2x00_free_device+0x38/0x18c [qla2xxx]
[C00000000F43F5C0] [D0000000004C3064] .qla2x00_probe_one+0x1198/0x11f8 [qla2xxx]
[C00000000F43F720] [C0000000001D06F0] .pci_device_probe+0xd0/0x164
[C00000000F43F7D0] [C000000000252B20] .driver_probe_device+0xa0/0x15c
[C00000000F43F870] [C000000000252D78] .__driver_attach+0xb4/0x138
[C00000000F43F900] [C000000000252284] .bus_for_each_dev+0x7c/0xd4
[C00000000F43F9C0] [C0000000002529C4] .driver_attach+0x28/0x40
[C00000000F43FA40] [C000000000251D24] .bus_add_driver+0x90/0x170
[C00000000F43FAE0] [C00000000025315C] .driver_register+0xbc/0xd8
[C00000000F43FB70] [C0000000001D047C] .__pci_register_driver+0x8c/0xd8
[C00000000F43FC10] [D0000000004E52E0] .qla2x00_module_init+0xac/0x24c4 [qla2xxx]
[C00000000F43FCA0] [C000000000083EC0] .sys_init_module+0x187c/0x1b88
[C00000000F43FE30] [C00000000000871C] syscall_exit+0x0/0x40
Instruction dump:
381bffff 393a0001 781b0420 793a0420 2fbb0000 409eff94 e93c2218 397c2218 
3940ffff 4800000c b1490048 7c090378 <e8090000> 2fa00000 419e0008 7c00022c 
 <6>device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
dm-netlink version 0.0.2 loaded
.
