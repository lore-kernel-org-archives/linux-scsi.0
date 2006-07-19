From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: Re: [PATCH] scsi midlayer: fix sdev reuse after free
Date: Wed, 19 Jul 2006 16:04:33 +0200
Message-ID: <44BE3BF1.2090000@ext.bull.net>
References: <1151348028.5883.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:5795 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S964836AbWGSOEk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jul 2006 10:04:40 -0400
In-Reply-To: <1151348028.5883.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Smart@Emulex.Com, eric.moore@lsil.com

Hi,


James Smart wrote:
 > The conversion to execute_in_process_context() highlighted a use-after-free
 > race condition. Although the sdev was torn down, it remained in the linked
 > lists looked at by scan, and allowed scan to reuse the sdev.
 >
 > This patch removes the sdev from the lists at the point it tears down the
 > sdev.
 >


We have a soft lockup with mptspi when using the 'sdev reuse after free' patch.
All is fine when this patch isn't installed.
kernel 2.6.17.4 + MPT version 3.3.09 + following patches:

[PATCH] fix scsi process problems and clean up the target reap
http://marc.theaimsgroup.com/?l=linux-scsi&m=114072663121857&w=2													 
[PATCH Repost 0/2] Block I/O while SG reset operation in progress
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745819730&w=2		 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745830216&w=2		 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114184745819007&w=2							
[PATCH 1/1] scsi: Device scanning oops for offlined devices
http://marc.theaimsgroup.com/?l=linux-scsi&m=114607039917528&w=2													 
[PATCH 0/3] Resend: Handle PQ3 devs better
http://marc.theaimsgroup.com/?l=linux-scsi&m=114644433315961&w=2		 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114644449426313&w=2		 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114644456331953&w=2		 
http://marc.theaimsgroup.com/?l=linux-scsi&m=114644465415996&w=2							
[PATCH] fc transport: resolve scan vs delete deadlocks
http://marc.theaimsgroup.com/?l=linux-scsi&m=114736846214310&w=2			

[REPOST #2][PATCH] update max sdev block limit
http://marc.theaimsgroup.com/?l=linux-scsi&m=114781033210150&w=2													 
[PATCH] scsi_scan.c: bug fix: starget use after free issue
http://marc.theaimsgroup.com/?l=linux-scsi&m=115039057504409&w=2			

[REPOST][PATCH] fc transport: bug fix: correct references
http://marc.theaimsgroup.com/?l=linux-scsi&m=115134614426385&w=2							
[PATCH 2/2] fusion : mpi header update
http://marc.theaimsgroup.com/?l=linux-scsi&m=115144149031481&w=2			

[PATCH] mptbase: mpt_interrupt should return IRQ_NONE
http://marc.theaimsgroup.com/?l=linux-scsi&m=115162519427446&w=2
	
[PATCH 3/9] mptfusion: mptctl panic when loading
http://marc.theaimsgroup.com/?l=linux-scsi&m=115266208332038&w=2																				



Here's the console output including the stack trace:
==========================================
Loading scsi_mod.ko module
SCSI subsystem initialized
Loading sd_mod.ko module
Loading mptbase.ko module
Fusion MPT base driver 3.03.09
Copyright (c) 1999-2005 LSI Logic Corporation
Loading mptscsih.ko module
Loading scsi_transport_spi.ko module
Loading mptspi.ko module
Fusion MPT SPI Host driver 3.03.09
GSI 48 (level, low) -> CPU 0 (0x0100) vector 48
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 48 (level, low) -> IRQ 48
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=48
GSI 49 (level, low) -> CPU 1 (0x0000) vector 49
ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 49 (level, low) -> IRQ 49
mptbase: Initiating ioc1 bringup
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
  target0:0:0: mpt_config failed
ioc1: 53C1030: Capabilities={Initiator}
scsi1 : ioc1: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=49
   Vendor: MAXTOR    Model: ATLAS10K4_73SCA   Rev: DFV0
   Type:   Direct-Access                      ANSI SCSI revision: 03
  target1:0:0: Beginning Domain Validation
  target1:0:0: Ending Domain Validation
  target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI (6.25 ns, offset
127)
SCSI device sda: 143666192 512-byte hdwr sectors (73557 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 143666192 512-byte hdwr sectors (73557 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
  sda: sda1 sda2 sda3
sd 1:0:0:0: Attached scsi disk sda
   Vendor: ESG-SHV   Model: SCA HSBP M24      Rev: 1.0D
   Type:   Processor                          ANSI SCSI revision: 02
BUG: soft lockup detected on CPU#1!

Call Trace:
  [<a000000100010b40>] show_stack+0x80/0xa0
                                 sp=e0000001fdbdf970 bsp=e0000001fdbd18c0
  [<a000000100010b90>] dump_stack+0x30/0x60
                                 sp=e0000001fdbdfb40 bsp=e0000001fdbd18a8
  [<a0000001000cbf00>] softlockup_tick+0x1e0/0x240
                                 sp=e0000001fdbdfb40 bsp=e0000001fdbd1860
  [<a00000010008cf30>] run_local_timers+0x30/0x60
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd1848
  [<a00000010008d050>] update_process_times+0xf0/0x160
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd1818
  [<a0000001000362b0>] timer_interrupt+0x110/0x360
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd17b8
  [<a0000001000cc430>] handle_IRQ_event+0x90/0x120
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd1778
  [<a0000001000cc680>] __do_IRQ+0x1c0/0x440
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd1720
  [<a000000100010120>] ia64_handle_irq+0xa0/0x140
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd16e8
  [<a00000010000b7c0>] ia64_leave_kernel+0x0/0x280
                                 sp=e0000001fdbdfb50 bsp=e0000001fdbd16e8
  [<a000000100280a20>] kobject_put+0x0/0x60
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd16e0
  [<a00000010037c670>] put_device+0x30/0x60
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd16c0
  [<a0000002018c4790>] scsi_device_put+0xb0/0x120 [scsi_mod]
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd16a0
  [<a0000002018c4920>] __scsi_iterate_devices+0x120/0x160 [scsi_mod]
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd1650
  [<a0000002018c4b10>] starget_for_each_device+0x1b0/0x200 [scsi_mod]
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd1608
  [<a0000002018d5b90>] scsi_target_quiesce+0x30/0x60 [scsi_mod]
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd15e0
  [<a000000201955530>] spi_dv_device+0xd0/0xee0 [scsi_transport_spi]
                                 sp=e0000001fdbdfd20 bsp=e0000001fdbd1558
  [<a000000201971060>] mptspi_dv_device+0xa0/0x2e0 [mptspi]
                                 sp=e0000001fdbdfd40 bsp=e0000001fdbd1518
  [<a0000002019715b0>] mptspi_slave_configure+0x130/0x140 [mptspi]
                                 sp=e0000001fdbdfd40 bsp=e0000001fdbd14f8
  [<a0000002018d8ad0>] scsi_probe_and_add_lun+0x1550/0x1ae0 [scsi_mod]
                                 sp=e0000001fdbdfd40 bsp=e0000001fdbd1418
  [<a0000002018d9750>] __scsi_scan_target+0x1f0/0x1000 [scsi_mod]
                                 sp=e0000001fdbdfda0 bsp=e0000001fdbd1370
  [<a0000002018da7f0>] scsi_scan_channel+0xf0/0x180 [scsi_mod]
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd1320
  [<a0000002018daa00>] scsi_scan_host_selected+0x180/0x2c0 [scsi_mod]
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd12d0
  [<a0000002018dab80>] scsi_scan_host+0x40/0x60 [scsi_mod]
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd12b0
  [<a000000201973ba0>] mptspi_probe+0x800/0x860 [mptspi]
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd1250
  [<a00000010029e130>] pci_device_probe+0x210/0x2c0
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd1210
  [<a000000100381070>] driver_probe_device+0x170/0x200
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd11d0
  [<a000000100381370>] __driver_attach+0xd0/0x180
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd1198
  [<a00000010037f6b0>] bus_for_each_dev+0xb0/0x140
                                 sp=e0000001fdbdfe10 bsp=e0000001fdbd1158
  [<a000000100381460>] driver_attach+0x40/0x60
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd1138
  [<a000000100380270>] bus_add_driver+0xf0/0x2e0
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd10f8
  [<a000000100381f70>] driver_register+0x170/0x1e0
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd10d8
  [<a00000010029dac0>] __pci_register_driver+0xa0/0x140
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd10b0
  [<a000000201990250>] mptspi_init+0x190/0x1c0 [mptspi]
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd1090
  [<a0000001000bc600>] sys_init_module+0x2a0/0x420
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd1020
  [<a00000010000b640>] ia64_ret_from_syscall+0x0/0x20
                                 sp=e0000001fdbdfe30 bsp=e0000001fdbd1020
==========================================


Any idea ?


-- 
Frederic TEMPORELLI
