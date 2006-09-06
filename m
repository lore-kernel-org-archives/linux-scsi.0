From: "Chen, Justin" <justin.chen@hp.com>
Subject: MPT Fusion Crash
Date: Wed, 6 Sep 2006 16:04:42 -0500
Message-ID: <BD66F1A3AD5256419EBBAAA4925784824AF17D@G3W0068.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:59825 "EHLO
	ccerelbas03.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751461AbWIFVFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Sep 2006 17:05:14 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsil.com
Cc: "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, "Helgaas, Bjorn" <bjorn.helgaas@hp.com>

Hi,

I got a kernel crash after offlined a scsi host when the kernel boots on
an ia64 box.  The crash is seen on the current upstream kernel
(2.6.18-rc6) and several versions of old kernels back. 

Any idea what the problem is?

Thanks,

Justin

Bootlog:
------------------
Fusion MPT base driver 3.04.01
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.01
GSI 79 (level, low) -> CPU 0 (0x0c00) vector 51
ACPI: PCI Interrupt 0000:69:01.0[A] -> GSI 79 (level, low) -> IRQ 51
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01030f00h, Ports=1, MaxQ=222, IRQ=51
mptscsih: ioc0: attempting task abort! (sc=e000070083c99600)
scsi 0:0:0:0: 
        command: Inquiry: 12 00 00 00 24 00
mptscsih: ioc0: task abort: FAILED (sc=e000070083c99600)
mptscsih: ioc0: attempting target reset! (sc=e000070083c99600)
scsi 0:0:0:0: 
        command: Inquiry: 12 00 00 00 24 00
mptbase: ioc0: IOCStatus(0x0048): SCSI Task Terminated
mptscsih: ioc0: target reset: SUCCESS (sc=e000070083c99600)
mptscsih: ioc0: attempting task abort! (sc=e000070083c99600)
scsi 0:0:0:0: 
        command: Test Unit Ready: 00 00 00 00 00 00
mptscsih: ioc0: task abort: FAILED (sc=e000070083c99600)
mptscsih: ioc0: attempting bus reset! (sc=e000070083c99600)
scsi 0:0:0:0: 
        command: Inquiry: 12 00 00 00 24 00
mptbase: ioc0: IOCStatus(0x0048): SCSI Task Terminated
mptscsih: ioc0: bus reset: SUCCESS (sc=e000070083c99600)
mptscsih: ioc0: attempting task abort! (sc=e000070083c99600)
scsi 0:0:0:0: 
        command: Test Unit Ready: 00 00 00 00 00 00
mptscsih: ioc0: task abort: FAILED (sc=e000070083c99600)
mptscsih: ioc0: Attempting host reset! (sc=e000070083c99600)
mptbase: Initiating ioc0 recovery
 target0:0:0: asynchronous
mptscsih: ioc0: attempting task abort! (sc=e000070083c99600)
scsi 0:0:0:0: 
        command: Test Unit Ready: 00 00 00 00 00 00
mptscsih: ioc0: task abort: FAILED (sc=e000070083c99600)
scsi 0:0:0:0: scsi: Device offlined - not ready after error recovery
Unable to handle kernel NULL pointer dereference (address
0000000000000000)
swapper[1]: Oops 11012296146944 [1]
Modules linked in:

Pid: 1, CPU 0, comm:              swapper
psr : 00001210085a6010 ifs : 800000000000040c ip  : [<a0000001001e77e1>]
Not tainted
ip is at swiotlb_unmap_sg+0xa1/0x1e0
unat: 0000000000000000 pfs : 000000000000050e rsc : 0000000000000003
rnat: a000000100650370 bsps: 0000000000000000 pr  : 000000000000aa41
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010047b970 b6  : a0000001001dc280 b7  : a000000100481980
f6  : 1003e6db6db6db6db6db7 f7  : 0ffef97ad9cc000000000
f8  : 1003e0000000000000a80 f9  : 1003e0000000000000060
f10 : 10011bfc04cccc9020f48 f11 : 1003e000000000005fe02
r1  : a000000100b44ac0 r2  : 0000000000004000 r3  : 0000000000004000
r8  : e0000700fddec0f8 r9  : e0000700fddec0f0 r10 : ffffffffdeadbeaf
r11 : 2000000000000000 r12 : e00007008351fd90 r13 : e000070083518000
r14 : a00000010095e690 r15 : 0000000000000000 r16 : 0000000000000010
r17 : a00000010095e690 r18 : 00000000ffffffff r19 : 0000000000000060
r20 : 6db6db6db6db6db7 r21 : e0000700fddec0e8 r22 : 0000000000000000
r23 : e0000700fce60e8a r24 : e0000700fce60e80 r25 : 0000000000000000
r26 : 0000000000000000 r27 : 00000010085a6010 r28 : e00000000008328d
r29 : e000070083c996a8 r30 : e0000700fddec138 r31 : e000070083c99658

Call Trace:
 [<a000000100010300>] show_stack+0x40/0xa0
                                sp=e00007008351f940 bsp=e000070083519198
 [<a000000100010b90>] show_regs+0x7d0/0x800
                                sp=e00007008351fb10 bsp=e000070083519150
 [<a00000010001e080>] die+0x1c0/0x2c0
                                sp=e00007008351fb10 bsp=e000070083519108
 [<a00000010003dce0>] ia64_do_page_fault+0x680/0x780
                                sp=e00007008351fb30 bsp=e0000700835190a8
 [<a00000010000afc0>] ia64_leave_kernel+0x0/0x280
                                sp=e00007008351fbc0 bsp=e0000700835190a8
 [<a0000001001e77e0>] swiotlb_unmap_sg+0xa0/0x1e0
                                sp=e00007008351fd90 bsp=e000070083519048
 [<a00000010047b970>] mptscsih_search_running_cmds+0x210/0x340
                                sp=e00007008351fd90 bsp=e000070083518ff0
 [<a00000010047e440>] mptscsih_slave_destroy+0x60/0x140
                                sp=e00007008351fd90 bsp=e000070083518fa8
 [<a000000100481a40>] mptspi_slave_destroy+0xc0/0xe0
                                sp=e00007008351fd90 bsp=e000070083518f88
 [<a0000001003af4d0>] scsi_probe_and_add_lun+0x430/0x4a0
                                sp=e00007008351fda0 bsp=e000070083518f28
 [<a0000001003b0560>] __scsi_scan_target+0x160/0x220
                                sp=e00007008351fdb0 bsp=e000070083518ee0
 [<a0000001003b07c0>] scsi_scan_channel+0xa0/0x120
                                sp=e00007008351fdc0 bsp=e000070083518e98
 [<a0000001003b0970>] scsi_scan_host_selected+0x130/0x1e0
                                sp=e00007008351fdc0 bsp=e000070083518e50
 [<a0000001003b0a60>] scsi_scan_host+0x40/0x60
                                sp=e00007008351fdc0 bsp=e000070083518e30
 [<a000000100483710>] mptspi_probe+0x710/0x760
                                sp=e00007008351fdc0 bsp=e000070083518dd8
 [<a0000001001f1c60>] pci_call_probe+0x40/0x60
                                sp=e00007008351fdc0 bsp=e000070083518da8
 [<a0000001001f1d30>] __pci_device_probe+0xb0/0x100
                                sp=e00007008351fdc0 bsp=e000070083518d78
 [<a0000001001f1dd0>] pci_device_probe+0x50/0xa0
                                sp=e00007008351fdc0 bsp=e000070083518d50
 [<a0000001002c1220>] driver_probe_device+0x100/0x1e0
                                sp=e00007008351fdc0 bsp=e000070083518d18
 [<a0000001002c1540>] __driver_attach+0xc0/0x160
                                sp=e00007008351fdc0 bsp=e000070083518ce0
 [<a0000001002bf9d0>] bus_for_each_dev+0x90/0x120
                                sp=e00007008351fdc0 bsp=e000070083518ca0
 [<a0000001002c1610>] driver_attach+0x30/0x60
                                sp=e00007008351fde0 bsp=e000070083518c80
 [<a0000001002c0610>] bus_add_driver+0xf0/0x160
                                sp=e00007008351fde0 bsp=e000070083518c48
 [<a0000001002c2080>] driver_register+0x160/0x180
                                sp=e00007008351fde0 bsp=e000070083518c28
 [<a0000001001f24a0>] __pci_register_driver+0xa0/0xe0
                                sp=e00007008351fde0 bsp=e000070083518c00
 [<a0000001007e5a70>] mptspi_init+0x150/0x180
                                sp=e00007008351fde0 bsp=e000070083518bd8
 [<a0000001007b13b0>] do_initcalls+0x110/0x300
                                sp=e00007008351fde0 bsp=e000070083518ba0
 [<a0000001007b1600>] do_basic_setup+0x60/0x80
                                sp=e00007008351fe10 bsp=e000070083518b88
 [<a000000100009000>] init+0x100/0x340
                                sp=e00007008351fe10 bsp=e000070083518b68
 [<a0000001000122b0>] kernel_thread_helper+0x30/0x60
                                sp=e00007008351fe30 bsp=e000070083518b40
 [<a000000100008d40>] start_kernel_thread+0x20/0x40
                                sp=e00007008351fe30 bsp=e000070083518b40
 <0>Kernel panic - not syncing: Attempted to kill init!
 
