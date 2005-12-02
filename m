From: Michael Reed <mdr@sgi.com>
Subject: Re: 2.6.15-rc4 error messages with multiple qla2300 hba ports on
 fabric
Date: Fri, 02 Dec 2005 10:41:59 -0600
Message-ID: <43907957.70402@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD98D@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:22921 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S1750816AbVLBQoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2005 11:44:14 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0012AD98D@AVEXCH02.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org



Andrew Vasquez wrote:
> 
>> From: Michael Reed [mailto:mdr@sgi.com]
>>
> 
> Sidenote:  I'm on the east-coast until hopefully tonight -- won't
> have a chance to look at debugging this for a couple of days...
> 
>> I've been testing with the qla2300 driver with 2.6.14.3 and 2.6.15-rc4.
>> I've observed two sets of error messages which are not present with
>> 2.6.14.3.
>>
>> First, the qla2300 driver is generating soft lockups.
> 
> Have a backtrace?

In the previously attached dmesg file, extracted below.  Is the driver polling
for mailbox interrupt?

QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0002:01:04.0[A]: no GSI
qla2300 0002:01:04.0: Found an ISP2312, irq 74, iobase 0xc00000080fd00000
qla2300 0002:01:04.0: Configuring PCI space...
PCI: slot 0002:01:04.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.0: Configure NVRAM parameters...
qla2300 0002:01:04.0: Verifying loaded RISC code...
qla2300 0002:01:04.0: Waiting for LIP to complete...
qla2300 0002:01:04.0: LIP reset occured (f800).
qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.0: Topology - (F_Port), Host Loop address 0xffff
BUG: soft lockup detected on CPU#0!
Modules linked in:

Pid: 1, CPU 0, comm:              swapper
psr : 00001010081a6018 ifs : 8000000000000a98 ip  : [<a000000100580380>]    Not tainted
ip is at qla2x00_mailbox_command+0x860/0xc40
unat: 0000000000000000 pfs : 0000000000000a98 rsc : 0000000000000003
rnat: aaaaa665556a9a55 bsps: a000000100589470 pr  : aaaaa655556a5555
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001005802f0 b6  : e0000030023e5490 b7  : a000000100589260
f6  : 0fff6fffffffff0000000 f7  : 1003e0000000000002710
f8  : 1003e00000000000003e8 f9  : 100078000000000000000
f10 : 10000bffffffff4000000 f11 : 1003e0000000000000003
r1  : a000000100c5a350 r2  : 0000000000000001 r3  : e00000b07bb20db0
r8  : 0000000000000001 r9  : 0000000000004000 r10 : 0000000000000000
r11 : 0000000000000002 r12 : e00000b07bb27af0 r13 : e00000b07bb20000
r14 : 0000000000000012 r15 : 0000000000002710 r16 : 0000000c610edd5d
r17 : 0000000000000001 r18 : 0000000000000002 r19 : 0000000000000000
r20 : 0000000000000000 r21 : ffffffffffff0028 r22 : e000003003104234
r23 : e000003003104231 r24 : e0000034f79183f8 r25 : 000000000000000d
r26 : 0000000c610edd6a r27 : 00000000000003e8 r28 : a0000001007b8ec0
r29 : 00000000000001fb r30 : 0000000c610edf7e r31 : a000000100a5aa58

Call Trace:
 [<a000000100013760>] show_stack+0x80/0xa0
                                sp=e00000b07bb27730 bsp=e00000b07bb21788
 [<a000000100013fd0>] show_regs+0x850/0x880
                                sp=e00000b07bb27900 bsp=e00000b07bb21728
 [<a000000100104600>] softlockup_tick+0x160/0x180
                                sp=e00000b07bb27910 bsp=e00000b07bb216f8
 [<a0000001000cb0c0>] do_timer+0x6a0/0x9a0
                                sp=e00000b07bb27920 bsp=e00000b07bb21688
 [<a000000100037100>] timer_interrupt+0x260/0x3e0
                                sp=e00000b07bb27920 bsp=e00000b07bb21638
 [<a0000001001047b0>] handle_IRQ_event+0x90/0x120
                                sp=e00000b07bb27920 bsp=e00000b07bb215f0
 [<a000000100104930>] __do_IRQ+0xf0/0x360
                                sp=e00000b07bb27920 bsp=e00000b07bb21598
 [<a000000100010400>] ia64_handle_irq+0xc0/0x160
                                sp=e00000b07bb27920 bsp=e00000b07bb21558
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
                                sp=e00000b07bb27920 bsp=e00000b07bb21558
 [<a000000100580380>] qla2x00_mailbox_command+0x860/0xc40
                                sp=e00000b07bb27af0 bsp=e00000b07bb21498
 [<a000000100581070>] qla2x00_login_fabric+0x150/0x260
                                sp=e00000b07bb27b40 bsp=e00000b07bb21440
 [<a000000100575580>] qla2x00_fabric_login+0xc0/0x3a0
                                sp=e00000b07bb27ba0 bsp=e00000b07bb21388
 [<a0000001005761f0>] qla2x00_fabric_dev_login+0x30/0x180
                                sp=e00000b07bb27be0 bsp=e00000b07bb21358
 [<a000000100578ac0>] qla2x00_configure_loop+0x2280/0x2a80
                                sp=e00000b07bb27be0 bsp=e00000b07bb21258
 [<a00000010057a320>] qla2x00_initialize_adapter+0x440/0x6c0
                                sp=e00000b07bb27ca0 bsp=e00000b07bb211c8
 [<a00000010056f4e0>] qla2x00_probe_one+0x1200/0x1fc0
                                sp=e00000b07bb27ca0 bsp=e00000b07bb21078
 [<a0000001005a15f0>] qla2300_probe_one+0x30/0x60
                                sp=e00000b07bb27d50 bsp=e00000b07bb21050
 [<a000000100420c70>] pci_device_probe+0x2d0/0x4a0
                                sp=e00000b07bb27d50 bsp=e00000b07bb21008
 [<a0000001004d05d0>] driver_probe_device+0xb0/0x1a0
                                sp=e00000b07bb27da0 bsp=e00000b07bb20fc8
 [<a0000001004d0730>] __driver_attach+0x70/0xc0
                                sp=e00000b07bb27da0 bsp=e00000b07bb20f98
 [<a0000001004cf880>] bus_for_each_dev+0xc0/0x140
                                sp=e00000b07bb27da0 bsp=e00000b07bb20f58
 [<a0000001004d02b0>] driver_attach+0x30/0x60
                                sp=e00000b07bb27dc0 bsp=e00000b07bb20f38
 [<a0000001004cec70>] bus_add_driver+0xf0/0x300
                                sp=e00000b07bb27dc0 bsp=e00000b07bb20ef8
 [<a0000001004d0940>] driver_register+0xa0/0xc0
                                sp=e00000b07bb27dc0 bsp=e00000b07bb20ed8
 [<a000000100420640>] __pci_register_driver+0x140/0x1e0
                                sp=e00000b07bb27dd0 bsp=e00000b07bb20ea8
 [<a000000100870fd0>] qla2300_init+0x30/0x60
                                sp=e00000b07bb27de0 bsp=e00000b07bb20e90
 [<a000000100009730>] init+0x470/0x920
                                sp=e00000b07bb27de0 bsp=e00000b07bb20e28
 [<a0000001000119e0>] kernel_thread_helper+0xe0/0x100
                                sp=e00000b07bb27e30 bsp=e00000b07bb20e00
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e00000b07bb27e30 bsp=e00000b07bb20e00
