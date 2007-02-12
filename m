From: Mark Haverkamp <markh@linux-foundation.org>
Subject: RE: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Mon, 12 Feb 2007 15:00:04 -0800
Message-ID: <1171321204.23143.20.camel@markh3.pdx.osdl.net>
References: <20070207235140.GA20920@lsil.com>
	 <1171296886.23143.6.camel@markh3.pdx.osdl.net>
	 <1171316725.3690.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030453AbXBLXAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Feb 2007 18:00:14 -0500
In-Reply-To: <1171316725.3690.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric Moore <eric.moore@lsi.com>, linux-scsi@vger.kernel.org

On Mon, 2007-02-12 at 15:45 -0600, James Bottomley wrote:
> On Mon, 2007-02-12 at 08:14 -0800, Mark Haverkamp wrote:
> > This patch fixed my looping DV problem.
> 
> As far as I can tell, this is identical to Eric's patch, but is done
> using the existing dv_in_progress flag ... can you test it out and see
> if it actually works?

No, it still loops doing dv.  I think that the problem is that I have
two devices that won't run at advertised speeds.  Target 0 and Target 8.
When Target 0 causes a reset,  there is no problem yet.  Later when
Target 8 causes a reset and dv is re-scheduled on Targets 0-8 is when
the problem starts.  Target 0 is no longer pending so it will start dv
and fail causing a reset scheduling another round of dv.  Then 8 will
fail again since by this time it isn't pending anymore, etc..

Here is a section of the messages file. The machine is still looping.

Feb 12 14:12:26 odt2-006 kernel: SCSI subsystem initialized
Feb 12 14:12:27 odt2-006 kernel: Fusion MPT base driver 3.04.04
Feb 12 14:12:27 odt2-006 kernel: Copyright (c) 1999-2007 LSI Logic Corporation
Feb 12 14:12:27 odt2-006 kernel: Fusion MPT misc device (ioctl) driver 3.04.04
Feb 12 14:12:27 odt2-006 kernel: mptctl: Registered with Fusion MPT base driver
Feb 12 14:12:27 odt2-006 kernel: mptctl: /dev/mptctl @ (major,minor=10,220)
Feb 12 14:12:38 odt2-006 kernel: Fusion MPT SPI Host driver 3.04.04
Feb 12 14:12:38 odt2-006 kernel: ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 27 (level, low) -> IRQ 27
Feb 12 14:12:38 odt2-006 kernel: mptbase: Initiating ioc0 bringup
Feb 12 14:12:38 odt2-006 kernel: ioc0: 53C1030: Capabilities={Initiator}
Feb 12 14:12:39 odt2-006 kernel: scsi0 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=27
Feb 12 14:12:40 odt2-006 kernel: scsi 0:0:0:0: Direct-Access     HP 18.2G MAP3367NC#HJ     HPC6 PQ: 0 ANSI: 3
Feb 12 14:12:40 odt2-006 kernel:  target0:0:0: Beginning Domain Validation
Feb 12 14:12:50 odt2-006 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810076871b00)
Feb 12 14:12:50 odt2-006 kernel: scsi 0:0:0:0: 
Feb 12 14:12:50 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:12:52 odt2-006 kernel: mptbase: Initiating ioc0 recovery
Feb 12 14:13:16 odt2-006 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:13:16 odt2-006 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810076871b00)
Feb 12 14:13:16 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076871b00)
Feb 12 14:13:16 odt2-006 kernel: scsi 0:0:0:0: 
Feb 12 14:13:16 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:13:16 odt2-006 kernel:  target0:0:0: asynchronous
Feb 12 14:13:16 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076871b00)
Feb 12 14:13:26 odt2-006 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810076871b00)
Feb 12 14:13:26 odt2-006 kernel: scsi 0:0:0:0: 
Feb 12 14:13:26 odt2-006 kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Feb 12 14:13:28 odt2-006 kernel: mptbase: Initiating ioc0 recovery
Feb 12 14:13:51 odt2-006 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:13:51 odt2-006 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810076871b00)
Feb 12 14:13:51 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076871b00)
Feb 12 14:13:51 odt2-006 kernel: scsi 0:0:0:0: 
Feb 12 14:13:51 odt2-006 kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Feb 12 14:13:51 odt2-006 kernel:  target0:0:0: asynchronous
Feb 12 14:13:51 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076871b00)
Feb 12 14:13:51 odt2-006 kernel: mptscsih: ioc0: attempting bus reset! (sc=ffff810076871b00)
Feb 12 14:13:51 odt2-006 kernel: scsi 0:0:0:0: 
Feb 12 14:13:51 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:13:52 odt2-006 kernel: mptscsih: ioc0: bus reset: SUCCESS (sc=ffff810076871b00)
Feb 12 14:14:02 odt2-006 kernel:  target0:0:0: Domain Validation detected failure, dropping back
Feb 12 14:14:02 odt2-006 kernel:  target0:0:0: Domain Validation skipping write tests
Feb 12 14:14:02 odt2-006 kernel:  target0:0:0: Ending Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:0: asynchronous
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:1:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:14:02 odt2-006 kernel:  target0:0:1: Beginning Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:1: Ending Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:2:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:14:02 odt2-006 kernel:  target0:0:2: Beginning Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:2: Ending Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:0:0: Attached scsi generic sg0 type 0
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:1:0: Attached scsi generic sg1 type 0
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:2:0: Attached scsi generic sg2 type 0
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:3:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:14:02 odt2-006 kernel:  target0:0:3: Beginning Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:3: Ending Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:3:0: Attached scsi generic sg3 type 0
Feb 12 14:14:02 odt2-006 kernel: SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:5:0: Processor         HP       D5989C           1.06 PQ: 0 ANSI: 2
Feb 12 14:14:02 odt2-006 kernel:  target0:0:5: Beginning Domain Validation
Feb 12 14:14:02 odt2-006 kernel: sda: Write Protect is off
Feb 12 14:14:02 odt2-006 kernel:  target0:0:5: Ending Domain Validation
Feb 12 14:14:02 odt2-006 kernel:  target0:0:5: asynchronous
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:5:0: Attached scsi generic sg4 type 3
Feb 12 14:14:02 odt2-006 kernel: SCSI device sda: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:14:02 odt2-006 kernel: SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:14:02 odt2-006 kernel: scsi 0:0:8:0: Direct-Access     HP 18.2G MAP3367NC#HJ     HPC6 PQ: 0 ANSI: 3
Feb 12 14:14:02 odt2-006 kernel:  target0:0:8: Beginning Domain Validation
Feb 12 14:14:02 odt2-006 kernel: sda: Write Protect is off
Feb 12 14:14:02 odt2-006 kernel: SCSI device sda: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:15:09 odt2-006 kernel:  sda:<4>mptscsih: ioc0: attempting task abort! (sc=ffff810076871b00)
Feb 12 14:15:09 odt2-006 kernel: scsi 0:0:8:0: 
Feb 12 14:15:09 odt2-006 kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Feb 12 14:15:11 odt2-006 kernel: mptbase: Initiating ioc0 recovery
Feb 12 14:15:34 odt2-006 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:15:34 odt2-006 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810076871b00)
Feb 12 14:15:34 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076871b00)
Feb 12 14:15:34 odt2-006 kernel: scsi 0:0:8:0: 
Feb 12 14:15:34 odt2-006 kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Feb 12 14:15:34 odt2-006 kernel:  target0:0:0: Beginning Domain Validation
Feb 12 14:15:35 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076871b00)
Feb 12 14:15:35 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076871b00)
Feb 12 14:15:35 odt2-006 kernel: scsi 0:0:8:0: 
Feb 12 14:15:35 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:15:35 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076871b00)
Feb 12 14:15:35 odt2-006 kernel:  target0:0:8: Domain Validation detected failure, dropping back
Feb 12 14:15:35 odt2-006 kernel:  target0:0:8: Domain Validation skipping write tests
Feb 12 14:15:35 odt2-006 kernel:  target0:0:8: Ending Domain Validation
Feb 12 14:15:35 odt2-006 kernel:  target0:0:8: asynchronous
Feb 12 14:15:35 odt2-006 kernel: scsi 0:0:8:0: Attached scsi generic sg5 type 0
Feb 12 14:15:35 odt2-006 kernel: scsi 0:0:9:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:15:35 odt2-006 kernel:  target0:0:9: Beginning Domain Validation
Feb 12 14:15:35 odt2-006 kernel:  sda1
Feb 12 14:15:35 odt2-006 kernel: sd 0:0:0:0: Attached scsi disk sda
Feb 12 14:15:35 odt2-006 kernel: SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:16:05 odt2-006 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810076871940)
Feb 12 14:16:05 odt2-006 kernel: sd 0:0:0:0: 
Feb 12 14:16:05 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:16:07 odt2-006 kernel: mptbase: Initiating ioc0 recovery
Feb 12 14:16:30 odt2-006 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:16:30 odt2-006 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810076871940)
Feb 12 14:16:30 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076871940)
Feb 12 14:16:30 odt2-006 kernel: sd 0:0:0:0: 
Feb 12 14:16:30 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:16:30 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076871940)
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:9:0: Write Buffer failure 80000
Feb 12 14:16:30 odt2-006 kernel:  target0:0:0: Domain Validation detected failure, dropping back
Feb 12 14:16:30 odt2-006 kernel:  target0:0:9: Domain Validation detected failure, dropping back
Feb 12 14:16:30 odt2-006 kernel:  target0:0:0: Domain Validation skipping write tests
Feb 12 14:16:30 odt2-006 kernel:  target0:0:0: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:0: asynchronous
Feb 12 14:16:30 odt2-006 kernel:  target0:0:9: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:9: asynchronous
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:9:0: Attached scsi generic sg6 type 0
Feb 12 14:16:30 odt2-006 kernel: sdb: Write Protect is off
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:10:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:16:30 odt2-006 kernel:  target0:0:10: Beginning Domain Validation
Feb 12 14:16:30 odt2-006 kernel: SCSI device sdb: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:16:30 odt2-006 kernel: SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:16:30 odt2-006 kernel: sdb: Write Protect is off
Feb 12 14:16:30 odt2-006 kernel: SCSI device sdb: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:16:30 odt2-006 kernel:  sdb:<6> target0:0:10: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:10:0: Attached scsi generic sg7 type 0
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:11:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:16:30 odt2-006 kernel:  target0:0:11: Beginning Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:11: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:11:0: Attached scsi generic sg8 type 0
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:12:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:16:30 odt2-006 kernel:  target0:0:12: Beginning Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:12: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:12:0: Attached scsi generic sg9 type 0
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:13:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:16:30 odt2-006 kernel:  target0:0:13: Beginning Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:13: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:13:0: Attached scsi generic sg10 type 0
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:14:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:16:30 odt2-006 kernel:  target0:0:14: Beginning Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:14: Ending Domain Validation
Feb 12 14:16:30 odt2-006 kernel:  target0:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:14:0: Attached scsi generic sg11 type 0
Feb 12 14:16:30 odt2-006 kernel: scsi 0:0:15:0: Direct-Access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Feb 12 14:16:30 odt2-006 kernel:  target0:0:15: Beginning Domain Validation
Feb 12 14:16:31 odt2-006 kernel:  target0:0:15: Ending Domain Validation
Feb 12 14:16:31 odt2-006 kernel:  target0:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:31 odt2-006 kernel: scsi 0:0:15:0: Attached scsi generic sg12 type 0
Feb 12 14:16:31 odt2-006 kernel: ACPI: PCI Interrupt 0000:03:03.1[B] -> GSI 24 (level, low) -> IRQ 24
Feb 12 14:16:31 odt2-006 kernel: mptbase: Initiating ioc1 bringup
Feb 12 14:16:31 odt2-006 kernel:  target0:0:1: Beginning Domain Validation
Feb 12 14:16:31 odt2-006 kernel:  target0:0:1: mpt_config failed
Feb 12 14:16:31 odt2-006 kernel:  target0:0:1: mpt_config failed
Feb 12 14:16:31 odt2-006 kernel: ioc1: 53C1030: Capabilities={Initiator}
Feb 12 14:16:32 odt2-006 kernel: scsi1 : ioc1: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=24
Feb 12 14:16:32 odt2-006 kernel:  target0:0:1: Ending Domain Validation
Feb 12 14:16:32 odt2-006 kernel:  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:32 odt2-006 kernel:  target0:0:2: Beginning Domain Validation
Feb 12 14:16:32 odt2-006 kernel:  sdb1
Feb 12 14:16:32 odt2-006 kernel: sd 0:0:1:0: Attached scsi disk sdb
Feb 12 14:16:32 odt2-006 kernel: SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:16:32 odt2-006 kernel: sdc: Write Protect is off
Feb 12 14:16:32 odt2-006 kernel: SCSI device sdc: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:16:32 odt2-006 kernel: SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:16:32 odt2-006 kernel: sdc: Write Protect is off
Feb 12 14:16:32 odt2-006 kernel: SCSI device sdc: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:16:32 odt2-006 kernel:  sdc:<6> target0:0:2: Ending Domain Validation
Feb 12 14:16:32 odt2-006 kernel:  target0:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:32 odt2-006 kernel:  target0:0:3: Beginning Domain Validation
Feb 12 14:16:32 odt2-006 kernel:  sdc1
Feb 12 14:16:32 odt2-006 kernel: sd 0:0:2:0: Attached scsi disk sdc
Feb 12 14:16:32 odt2-006 kernel: SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:16:33 odt2-006 kernel: sdd: Write Protect is off
Feb 12 14:16:33 odt2-006 kernel:  target0:0:3: Ending Domain Validation
Feb 12 14:16:33 odt2-006 kernel:  target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:16:33 odt2-006 kernel:  target0:0:5: Beginning Domain Validation
Feb 12 14:16:33 odt2-006 kernel: SCSI device sdd: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:16:33 odt2-006 kernel: SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:16:33 odt2-006 kernel:  target0:0:5: Ending Domain Validation
Feb 12 14:16:33 odt2-006 kernel:  target0:0:5: asynchronous
Feb 12 14:16:33 odt2-006 kernel:  target0:0:8: Beginning Domain Validation
Feb 12 14:16:33 odt2-006 kernel: sdd: Write Protect is off
Feb 12 14:16:33 odt2-006 kernel: SCSI device sdd: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:16:33 odt2-006 kernel:  sdd: sdd1
Feb 12 14:16:33 odt2-006 kernel: sd 0:0:3:0: Attached scsi disk sdd
Feb 12 14:16:37 odt2-006 kernel: ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 29 (level, low) -> IRQ 29
Feb 12 14:16:37 odt2-006 kernel: mptbase: Initiating ioc2 bringup
Feb 12 14:16:37 odt2-006 kernel: ioc2: 53C1030: Capabilities={Initiator}
Feb 12 14:16:38 odt2-006 kernel: scsi2 : ioc2: LSI53C1030, FwRev=01030600h, Ports=1, MaxQ=255, IRQ=29
Feb 12 14:16:42 odt2-006 kernel: ACPI: PCI Interrupt 0000:02:01.1[B] -> GSI 30 (level, low) -> IRQ 30
Feb 12 14:16:42 odt2-006 kernel: mptbase: Initiating ioc3 bringup
Feb 12 14:16:42 odt2-006 kernel: ioc3: 53C1030: Capabilities={Initiator}
Feb 12 14:16:43 odt2-006 kernel: scsi3 : ioc3: LSI53C1030, FwRev=01030600h, Ports=1, MaxQ=255, IRQ=30
Feb 12 14:17:33 odt2-006 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810076f66b40)
Feb 12 14:17:33 odt2-006 kernel: sd 0:0:3:0: 
Feb 12 14:17:33 odt2-006 kernel:         command: Inquiry: 12 01 00 00 fe 00
Feb 12 14:17:35 odt2-006 kernel: mptbase: Initiating ioc0 recovery
Feb 12 14:17:59 odt2-006 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:17:59 odt2-006 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810076f66b40)
Feb 12 14:17:59 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076f66b40)
Feb 12 14:17:59 odt2-006 kernel: sd 0:0:3:0: 
Feb 12 14:17:59 odt2-006 kernel:         command: Inquiry: 12 01 00 00 fe 00
Feb 12 14:17:59 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076f66b40)
Feb 12 14:17:59 odt2-006 kernel:  target0:0:8: Domain Validation detected failure, dropping back
Feb 12 14:17:59 odt2-006 kernel: SCSI device sde: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:17:59 odt2-006 kernel: sde: Write Protect is off
Feb 12 14:17:59 odt2-006 kernel:  target0:0:8: Domain Validation skipping write tests
Feb 12 14:17:59 odt2-006 kernel:  target0:0:8: Ending Domain Validation
Feb 12 14:17:59 odt2-006 kernel:  target0:0:8: asynchronous
Feb 12 14:17:59 odt2-006 kernel:  target0:0:9: Beginning Domain Validation
Feb 12 14:17:59 odt2-006 kernel: SCSI device sde: write cache: disabled, read cache: enabled, supports DPO and FUA
Feb 12 14:17:59 odt2-006 kernel: SCSI device sde: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:17:59 odt2-006 kernel: sde: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel: SCSI device sde: write cache: disabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel:  sde:<6> target0:0:9: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:10: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  sde1
Feb 12 14:18:00 odt2-006 kernel: sd 0:0:8:0: Attached scsi disk sde
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdf: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:10: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:11: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel: sdf: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdf: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdf: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel: sdf: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel:  target0:0:11: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:12: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdf: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel:  sdf: sdf1
Feb 12 14:18:00 odt2-006 kernel: sd 0:0:9:0: Attached scsi disk sdf
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdg: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel: sdg: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdg: write cache: disabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdg: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:12: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:13: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel: sdg: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdg: write cache: disabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel:  sdg: sdg1
Feb 12 14:18:00 odt2-006 kernel: sd 0:0:10:0: Attached scsi disk sdg
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdh: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel: sdh: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdh: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdh: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel: sdh: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel:  target0:0:13: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:14: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdh: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel:  sdh: sdh1
Feb 12 14:18:00 odt2-006 kernel: sd 0:0:11:0: Attached scsi disk sdh
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdi: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:14: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:15: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel: sdi: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel:  target0:0:15: Ending Domain Validation
Feb 12 14:18:00 odt2-006 kernel:  target0:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 126)
Feb 12 14:18:00 odt2-006 kernel:  target0:0:0: Beginning Domain Validation
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdi: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdi: 35566480 512-byte hdwr sectors (18210 MB)
Feb 12 14:18:00 odt2-006 kernel: sdi: Write Protect is off
Feb 12 14:18:00 odt2-006 kernel: SCSI device sdi: write cache: enabled, read cache: enabled, supports DPO and FUA
Feb 12 14:19:10 odt2-006 kernel:  sdi:<4>mptscsih: ioc0: attempting task abort! (sc=ffff810076f66d00)
Feb 12 14:19:10 odt2-006 kernel: sd 0:0:0:0: 
Feb 12 14:19:10 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:19:12 odt2-006 kernel: mptbase: Initiating ioc0 recovery
Feb 12 14:19:36 odt2-006 kernel: mptscsih: ioc0: Issue of TaskMgmt failed!
Feb 12 14:19:36 odt2-006 kernel: mptscsih: ioc0: task abort: FAILED (sc=ffff810076f66d00)
Feb 12 14:19:36 odt2-006 kernel:  target0:0:0: asynchronous
Feb 12 14:19:36 odt2-006 kernel:  target0:0:1: Beginning Domain Validation
Feb 12 14:19:36 odt2-006 kernel: mptscsih: ioc0: attempting target reset! (sc=ffff810076f66d00)
Feb 12 14:19:36 odt2-006 kernel: sd 0:0:0:0: 
Feb 12 14:19:36 odt2-006 kernel:         command: Inquiry: 12 00 00 00 60 00
Feb 12 14:19:36 odt2-006 kernel: mptscsih: ioc0: target reset: SUCCESS (sc=ffff810076f66d00)
Feb 12 14:19:46 odt2-006 kernel: mptscsih: ioc0: attempting task abort! (sc=ffff810076f66d00)
Feb 12 14:19:46 odt2-006 kernel: sd 0:0:0:0: 
Feb 12 14:19:46 odt2-006 kernel:         command: Test Unit Ready: 00 00 00 00 00 00
Feb 12 14:19:48 odt2-006 kernel: mptbase: Initiating ioc0 recovery

> 
> Thanks,
> 
> James
> Index: linux-2.6/drivers/scsi/scsi_transport_spi.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi_transport_spi.c	2007-02-11 14:16:51.000000000 -0600
> +++ linux-2.6/drivers/scsi/scsi_transport_spi.c	2007-02-12 15:20:59.000000000 -0600
> @@ -787,6 +787,7 @@ spi_dv_device_internal(struct scsi_devic
>  	struct scsi_target *starget = sdev->sdev_target;
>  	struct Scsi_Host *shost = sdev->host;
>  	int len = sdev->inquiry_len;
> +
>  	/* first set us up for narrow async */
>  	DV_SET(offset, 0);
>  	DV_SET(width, 0);
> @@ -917,8 +918,25 @@ spi_dv_device(struct scsi_device *sdev)
>  	if (unlikely(scsi_device_get(sdev)))
>  		return;
>  
> -	if (unlikely(spi_dv_in_progress(starget)))
> +	if (unlikely(spi_dv_in_progress(starget))) {
> +		/*
> +		 * If DV is already pending, just make sure the device
> +		 * has all the parameters set (in case this is the
> +		 * result of a reset during the in progress DV)
> +		 */
> +		DV_SET(dt, spi_dt(starget));
> +		DV_SET(iu, spi_iu(starget));
> +		DV_SET(width, spi_width(starget));
> +		DV_SET(offset, spi_offset(starget));
> +		DV_SET(period, spi_period(starget));
> +		DV_SET(qas, spi_qas(starget));
> +		DV_SET(rd_strm, spi_rd_strm(starget));
> +		DV_SET(wr_flow, spi_wr_flow(starget));
> +		DV_SET(rti, spi_rti(starget));
> +		DV_SET(pcomp_en, spi_pcomp_en(starget));
> +		scsi_device_put(sdev);
>  		return;
> +	}
>  	spi_dv_in_progress(starget) = 1;
>  
>  	buffer = kzalloc(len, GFP_KERNEL);
> 
> 
-- 
Mark Haverkamp <markh@linux-foundation.org>

