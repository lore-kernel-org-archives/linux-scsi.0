From: Grant Grundler <iod00d@hp.com>
Subject: [BUG] NULL Pointer deref in scsi_eh_6
Date: Wed, 4 Feb 2004 23:09:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205070952.GA30089@cup.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel11.hp.com ([156.153.255.246]:17542 "EHLO palrel11.hp.com")
	by vger.kernel.org with ESMTP id S263880AbUBEHIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 02:08:16 -0500
Received: from hpuxmail.cup.hp.com (hpuxmail.cup.hp.com [15.13.189.207])
	by palrel11.hp.com (Postfix) with ESMTP id 8EA351C03D0D
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2004 23:08:15 -0800 (PST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,
I was trying to "modprobe qla2300" on an ia64 with 2.6.2-rc2 kernel.
I had successfull modprobed it already with 10 FC disks out
behind a switch. I powered up another tray of disks connected
to the same FC switch which had some defective disks in it.
The error daemon oops'd on the next modprobe attempt.

I'll power off the tray tomorrow but leave it connected.
If anyone needs more info, please ask.

BTW, I'm using David Mosberger's lia64.bkbit.net/linux-ia64-2.5
source tree. I'm open to trying a different bk source tree
or patches against david's tree if something is obvious.

thanks,
grant

ps. I know about the 520-byte sector disks shown below.
    I will revert those to 512 byte sectors and use them.

pps. if someone wants the previous output, it might be in /var/log

grundler@gsyprf3:~$ dmesg
d scsi disk sdy at scsi5, channel 0, id 4, lun 0
Attached scsi generic sg24 at scsi5, channel 0, id 4, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336753FC        Rev: HP00
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.1: scsi(5:0:5:0): Enabled tagged queuing, queue depth
32.
SCSI device sdz: 71132960 512-byte hdwr sectors (36420 MB)
SCSI device sdz: drive cache: write through
 sdz: sdz1 sdz2
Attached scsi disk sdz at scsi5, channel 0, id 5, lun 0
Attached scsi generic sg25 at scsi5, channel 0, id 5, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336753FC        Rev: HP00
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.1: scsi(5:0:6:0): Enabled tagged queuing, queue depth
32.
SCSI device sdaa: 71132960 512-byte hdwr sectors (36420 MB)
SCSI device sdaa: drive cache: write through
 sdaa: sdaa1 sdaa2
Attached scsi disk sdaa at scsi5, channel 0, id 6, lun 0
Attached scsi generic sg26 at scsi5, channel 0, id 6, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336753FC        Rev: HP00
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.1: scsi(5:0:7:0): Enabled tagged queuing, queue depth
32.
SCSI device sdab: 71132960 512-byte hdwr sectors (36420 MB)
SCSI device sdab: drive cache: write through
 sdab: sdab1 sdab2
Attached scsi disk sdab at scsi5, channel 0, id 7, lun 0
Attached scsi generic sg27 at scsi5, channel 0, id 7, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336753FC        Rev: HP00
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.1: scsi(5:0:8:0): Enabled tagged queuing, queue depth
32.
SCSI device sdac: 71132960 512-byte hdwr sectors (36420 MB)
SCSI device sdac: drive cache: write through
 sdac: sdac1 sdac2
Attached scsi disk sdac at scsi5, channel 0, id 8, lun 0
Attached scsi generic sg28 at scsi5, channel 0, id 8, lun 0,  type 0
qla2300 0000:80:01.1: qla2xxx_eh_abort scsi(5:0:9:0):
cmd_timeout_in_sec=0x6.
qla2300 0000:80:01.1: scsi(5:0:9:0): DEVICE RESET ISSUED.
qla2300 0000:80:01.1: scsi(5:0:9:0): DEVICE RESET SUCCEEDED.
qla2300 0000:80:01.1: qla2xxx_eh_abort scsi(5:0:9:0):
cmd_timeout_in_sec=0x6.
qla2300 0000:80:01.1: scsi(5:0:9:0): LOOP RESET ISSUED.
qla2300 0000:80:01.1: qla2xxx_eh_bus_reset: reset failed
qla2300 0000:80:01.1: scsi(5:0:9:0): ADAPTER RESET issued.
qla2300 0000:80:01.1: Performing ISP error recovery - ha=
e0000001034d8310.
qla2300 0000:80:01.1: LIP reset occured (f8f7).
qla2300 0000:80:01.1: LOOP UP detected (2 Gbps).
qla2300 0000:80:01.1: qla2xxx_eh_host_reset: reset failed
scsi: Device offlined - not ready after error recovery: host 5 channel 0
id 9 lun 0
  Vendor: HP 36.4G  Model: ST336753FC        Rev: HP00
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.0: scsi(4:0:7:0): Enabled tagged queuing, queue depth
32.
SCSI device sdad: 71132960 512-byte hdwr sectors (36420 MB)
SCSI device sdad: drive cache: write through
 sdad: sdad1 sdad2
Attached scsi disk sdad at scsi4, channel 0, id 7, lun 0
Attached scsi generic sg29 at scsi4, channel 0, id 7, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336753FC        Rev: HP00
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.1: scsi(5:0:9:0): Enabled tagged queuing, queue depth
32.
SCSI device sdae: 71132960 512-byte hdwr sectors (36420 MB)
SCSI device sdae: drive cache: write through
 sdae: sdae1 sdae2
Attached scsi disk sdae at scsi5, channel 0, id 9, lun 0
Attached scsi generic sg30 at scsi5, channel 0, id 9, lun 0,  type 0
PCI: Found IRQ 66 for device 0000:80:01.0
IOSAPIC: vector 66 -> CPU 0x0100, enabled
qla2300 0000:80:01.0: Found an ISP2312, irq 66, iobase
0xc0000000c8041000
qla2300 0000:80:01.0: Configuring PCI space...
qla2300 0000:80:01.0: Configure NVRAM parameters...
qla2300 0000:80:01.0: Verifying loaded RISC code...
qla2300 0000:80:01.0: Waiting for LIP to complete...
qla2300 0000:80:01.0: LIP reset occured (f7f7).
qla2300 0000:80:01.0: LOOP UP detected (2 Gbps).
qla2300 0000:80:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi6 : qla2xxx
qla2300 0000:80:01.0: 
 QLogic ISP2xxx PCI/PCI-X Fibre Channel HBA Driver: 8.00.00b8
  QLogic HP A6826-60001 - 
  ISP2312: PCI-X (133 MHz) @ 0000:80:01.0 hdma+, host#=6, fw=3.02.18 TPX
  Vendor: HP 36.4G  Model: ST336704FC        Rev: HPC3
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.0: scsi(6:0:0:0): Enabled tagged queuing, queue depth
32.
sdl : unsupported sector size 520.
SCSI device sdl: 0 520-byte hdwr sectors (0 MB)
SCSI device sdl: drive cache: write through
Attached scsi disk sdl at scsi6, channel 0, id 0, lun 0
Attached scsi generic sg11 at scsi6, channel 0, id 0, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336704FC        Rev: HPC3
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.0: scsi(6:0:1:0): Enabled tagged queuing, queue depth
32.
sdm : unsupported sector size 520.
SCSI device sdm: 0 520-byte hdwr sectors (0 MB)
SCSI device sdm: drive cache: write through
Attached scsi disk sdm at scsi6, channel 0, id 1, lun 0
Attached scsi generic sg12 at scsi6, channel 0, id 1, lun 0,  type 0
  Vendor: HP 36.4G  Model: ST336704FC        Rev: HPC3
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0000:80:01.0: scsi(6:0:2:0): Enabled tagged queuing, queue depth
32.
sdn : READ CAPACITY failed.
sdn : status=0, message=00, host=1, driver=00 
sdn : sense not available. 
sdn: asking for cache data failed
sdn: assuming drive cache: write through
 sdn:SCSI error : <6 0 2 0> return code = 0x10000
end_request: I/O error, dev sdn, sector 0
Buffer I/O error on device sdn, logical block 0
SCSI error : <6 0 2 0> return code = 0x10000
end_request: I/O error, dev sdn, sector 0
Buffer I/O error on device sdn, logical block 0
SCSI error : <6 0 2 0> return code = 0x10000
end_request: I/O error, dev sdn, sector 2097120
Buffer I/O error on device sdn, logical block 65535
SCSI error : <6 0 2 0> return code = 0x10000
end_request: I/O error, dev sdn, sector 2097120
Buffer I/O error on device sdn, logical block 65535
SCSI error : <6 0 2 0> return code = 0x10000
end_request: I/O error, dev sdn, sector 0
Buffer I/O error on device sdn, logical block 0
 unable to read partition table
Attached scsi disk sdn at scsi6, channel 0, id 2, lun 0
Attached scsi generic sg13 at scsi6, channel 0, id 2, lun 0,  type 0
qla2300 0000:80:01.0: qla2xxx_eh_abort scsi(6:0:10:0):
cmd_timeout_in_sec=0x6.
Unable to handle kernel NULL pointer dereferencescsi_eh_6[750]: Oops
8813272891392 [1]

Pid: 750, CPU 0, comm:            scsi_eh_6
psr : 0000101008026018 ifs : 800000000000060f ip  : [<a000000100418100>]
Tainted: GF 
ip is at scsi_eh_bus_device_reset+0xe0/0x300
unat: 0000000000000000 pfs : 000000000000060f rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 80000000ff55a559
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100418050 b6  : a00000010027a900 b7  : a000000100010dc0
f6  : 0fffbccccccccc8c00000 f7  : 0ffe5c8cca00000000000
f8  : 1000b9ea8000000000000 f9  : 10002a000000000000000
f10 : 10007fdd9999994947c00 f11 : 1003e00000000000001fb
r1  : a0000001009a0000 r2  : 0000000000000000 r3  : e000004040020330
r8  : e000004040338d80 r9  : e000004040020308 r10 : e000000103448000
r11 : 0000000000000000 r12 : e0000001034dfd00 r13 : e0000001034d8000
r14 : 0000000000000002 r15 : e000004040020330 r16 : 0000000000000000
r17 : e0000040400203f0 r18 : e000004040020376 r19 : 0000000000000000
r20 : e0000040400203f8 r21 : e00000404002040c r22 : 0000000000002002
r23 : 0000000000002001 r24 : e0000040400203f2 r25 : e00000404002037c
r26 : 0000000000000205 r27 : e000004040020380 r28 : e000004040020400
r29 : e000004040020388 r30 : 0000000000000000 r31 : e000000103448040

Call Trace:
 [<a0000001000184a0>] show_stack+0x80/0xa0
                                sp=e0000001034df8d0 bsp=e0000001034d94a0
 [<a00000010003c790>] die+0x170/0x200
                                sp=e0000001034dfaa0 bsp=e0000001034d9468
 [<a00000010005e5e0>] ia64_do_page_fault+0x340/0x940
                                sp=e0000001034dfaa0 bsp=e0000001034d9400
 [<a000000100011520>] ia64_leave_kernel+0x0/0x260
                                sp=e0000001034dfb30 bsp=e0000001034d9400
 [<a000000100418100>] scsi_eh_bus_device_reset+0xe0/0x300
                                sp=e0000001034dfd00 bsp=e0000001034d9380
 [<a000000100419910>] scsi_eh_ready_devs+0x30/0x100
                                sp=e0000001034dfd00 bsp=e0000001034d9350
 [<a000000100419df0>] scsi_unjam_host+0x1f0/0x460
                                sp=e0000001034dfd00 bsp=e0000001034d92d8
 [<a00000010041a3b0>] scsi_error_handler+0x350/0x440
                                sp=e0000001034dfd20 bsp=e0000001034d9270
 [<a000000100019ee0>] kernel_thread+0x60/0xa0
                                sp=e0000001034dfd40 bsp=e0000001034d9238
 [<a000000100412880>] scsi_host_alloc+0x580/0x660
                                sp=e0000001034dfd40 bsp=e0000001034d91e8
 [<a00000020050eaa0>] qla2x00_probe_one+0x60/0x1120 [qla2xxx]
                                sp=e0000001034dfd80 bsp=e0000001034d9178
 [<a0000002001bc090>] qla2300_probe_one+0x30/0x60 [qla2300]
                                sp=e0000001034dfe10 bsp=e0000001034d9150
 [<a000000100284480>] pci_device_probe_static+0xc0/0x100
                                sp=e0000001034dfe10 bsp=e0000001034d9120
 [<a000000100284560>] __pci_device_probe+0xa0/0xe0
                                sp=e0000001034dfe10 bsp=e0000001034d90f8
 [<a0000001002845f0>] pci_device_probe+0x50/0xa0
                                sp=e0000001034dfe10 bsp=e0000001034d90d0
 [<a00000010039fd60>] bus_match+0xc0/0x120
                                sp=e0000001034dfe10 bsp=e0000001034d9098
 [<a0000001003a0060>] driver_attach+0x120/0x180
                                sp=e0000001034dfe10 bsp=e0000001034d9060
 [<a0000001003a0700>] bus_add_driver+0x100/0x1c0
                                sp=e0000001034dfe10 bsp=e0000001034d9028
 [<a0000001003a0fa0>] driver_register+0xc0/0xe0
                                sp=e0000001034dfe10 bsp=e0000001034d9008
 [<a000000100284b20>] pci_register_driver+0xe0/0x120
                                sp=e0000001034dfe30 bsp=e0000001034d8fd8
 [<a000000200038080>] qla2300_init+0x40/0xb0 [qla2300]
                                sp=e0000001034dfe30 bsp=e0000001034d8fb0
 [<a0000001000a9300>] sys_init_module+0x380/0x660
                                sp=e0000001034dfe30 bsp=e0000001034d8f38
 [<a0000001000113c0>] ia64_ret_from_syscall+0x0/0x20
                                sp=e0000001034dfe30 bsp=e0000001034d8f38

