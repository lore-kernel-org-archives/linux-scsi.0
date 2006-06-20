From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] scsi_transport_sas: introduce a sas_port entity
Date: Tue, 20 Jun 2006 13:11:41 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7019A05F@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10933 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750807AbWFTTLo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 15:11:44 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tuesday, June 20, 2006 11:45 AM, James Bottomley wrote:

> 
> On Tue, 2006-06-20 at 11:37 -0600, Moore, Eric wrote:
> > The scsi-misc-2.6 patch with todays date in your kernel.org
> > home folder has all the wide port API changes backed out?  
> > Is that on purpose, and what is your plans for your 2.6.18
> > push to Linus having this?
> 
> I plan to push the current SCSI misc and hopefully follow on with the
> wide port API before the 2.6.18 merge window closes.  I 
> suspect the next
> round of kernel releases will be Andrew's requested stability ones, so
> if we don't get something in before 1 July, it will likely be 
> 2.6.20 (or
> four to six months) before we can get this API in.

Well, lets not rush this in till all the panics are fix'd.

Here's one of the issues:
Try compile the driver as a module.  Load -> unload -> load -> panic.
I suspect that in the scsi_transport_sas.c, the sas_remove_host is
not cleaning up the wide ports. My setup is one controller
with one expander attached. No end devices.

Here is my trace:

< LOAD DRIVER >

Jun 20 12:41:29 emoore-test6 kernel: Fusion MPT base driver 3.03.10
Jun 20 12:41:29 emoore-test6 kernel: Copyright (c) 1999-2005 LSI Logic
Corporation
Jun 20 12:41:29 emoore-test6 kernel: Fusion MPT SAS Host driver 3.03.10
Jun 20 12:41:29 emoore-test6 kernel: GSI 20 sharing vector 0xC9 and IRQ
20
Jun 20 12:41:29 emoore-test6 kernel: ACPI: PCI Interrupt 0000:09:02.0[A]
-> GSI 72 (level, low) -> IRQ 201
Jun 20 12:41:29 emoore-test6 kernel: mptbase: Initiating ioc0 bringup
Jun 20 12:41:30 emoore-test6 kernel: ioc0: SAS1068:
Capabilities={Initiator}
Jun 20 12:41:36 emoore-test6 kernel: mptbase: ioc0: MPT event:(0Ah) :
Events(ON) Change
Jun 20 12:41:36 emoore-test6 kernel: scsi2 : ioc0: LSISAS1068,
FwRev=00070f00h, Ports=1, MaxQ=511, IRQ=201

< UNLOAD DRIVER >

< LOAD DRIVER >

Jun 20 12:42:28 emoore-test6 kernel: Fusion MPT base driver 3.03.10
Jun 20 12:42:28 emoore-test6 kernel: Copyright (c) 1999-2005 LSI Logic
Corporation
Jun 20 12:42:28 emoore-test6 kernel: Fusion MPT SAS Host driver 3.03.10
Jun 20 12:42:28 emoore-test6 kernel: PCI: Enabling device 0000:09:02.0
(0156 -> 0157)
Jun 20 12:42:28 emoore-test6 kernel: ACPI: PCI Interrupt 0000:09:02.0[A]
-> GSI 72 (level, low) -> IRQ 201
Jun 20 12:42:28 emoore-test6 kernel: mptbase: Initiating ioc0 bringup
Jun 20 12:42:28 emoore-test6 kernel: ioc0: SAS1068:
Capabilities={Initiator}
Jun 20 12:42:35 emoore-test6 kergeneral protection fault: 0000 [1] Snel:
mptbase: ioMP c0: MPT event:(0
Ah) : Events(ON)last sysfs file: /class/scsi_host/host3/proc_name
 C
Entering kdb (current=0xffff81001e111040, pid 7313) on processor 1 Oops:
<NULL>
due to oops @ 0xffffffff802645cc
     r15 = 0x0000000000000000      r14 = 0xffff8100041c1450 
     r13 = 0xffffffff802647b1      r12 = 0xffff8100041c11d8 
     rbp = 0xffff8100041c1000      rbx = 0xffff81001f182700 
     r11 = 0x00000000000081a4      r10 = 0xffff81000e06c488 
      r9 = 0xffff81001fddccd0       r8 = 0xffff81000e06c488 
     rax = 0xffff81000927b000      rcx = 0xffff81000e06c488 
     rdx = 0x0000000000000000      rsi = 0xffff8100041c11d8 
     rdi = 0xffff81001f182700 orig_rax = 0xffffffffffffffff 
     rip = 0xffffffff802645cc       cs = 0x0000000000000010 
  eflags = 0x0000000000010283      rsp = 0xffff810006e61b60 
      ss = 0xffff810006e60000 &regs = 0xffff810006e61ac8
[1]kdb> b[1]kdb> bt[1]kdb> bt

Stack traceback for pid 7313
0xffff81001e111040     7313     7300  1    1   R  0xffff81001e111370
*insmod
RSP           RIP                Function (args)
0xffff810006e61b60 0xffffffff802645cc
attribute_container_device_trigger+0x49 (0xffff81000e06c488,
0xffff81000927b8c0, 0xffff81000e06c4e0)
0xffff810006e61b78 0xffffffff802645cf
attribute_container_device_trigger+0x4c (0xffff8100041c11d8,
0xffff8100041c11d8, 0xffff8100041c1000, 0x0, 0xffff8100041c11d8)
0xffff810006e61b98 0xffffffff802643a0
attribute_container_add_device+0x57 (0xffffffffffffffff,
0xffffffffffffffff, 0xffff81001e4f1090, 0xffff81001e4f0ed0,
0xffffffff88279238)
0xffff810006e61cb8 0xffffffff80203e87 pci_device_probe+0xf7
(0xffff81001e4f1090, 0xffff81001e4f0ed0, 0xffff81001e4fc638)
0xffff810006e61cf8 0xffffffff802614c0 driver_probe_device+0x52 (0x0,
0x0, 0xffffffff88279238, 0xffffffff80261593, 0xffffffff88279238)
0xffff810006e61d18 0xffffffff80261621 __driver_attach+0x8e
(0xffffffff80385ac8, 0xffffffff80385ae0, 0xffff81001e4f0fa8,
0xffffffff803858e0, 0xffffffff88279680)
0xffff810006e61d48 0xffffffff80260ea2 bus_for_each_dev+0x43
(0xffffffff88279238)
0xffff810006e61d98 0xffffffff802613fb driver_attach+0x1c (0xd0,
0xffffffff88279238, 0xffffffff88279680, 0xffffffff80370fa0,
0xffffffff88279680)
0xffff810006e61da8 0xffffffff80260b15 bus_add_driver+0x7e
(0xdead4ead00000001, 0xffffffff, 0xffffffffffffffff, 0xffffffff)
0xffff810006e61de8 0xffffffff80261927 driver_register+0xae
(0xdead4ead00000001, 0xffffffff, 0xffffffffffffffff, 0xffffffff8823b794,
0xffffffff8014a56e)
0xffff810006e61e18 0xffffffff8020409d __pci_register_driver+0x8e
(0xffffffff80370fa0)
0xffff810006e61e58 0xffffffff880970d4 [mptsas]mptsas_init+0xd4
0xffff810006e61e68 0xffffffff8014ce34 sys_init_module+0x162f
[1]kdb>
