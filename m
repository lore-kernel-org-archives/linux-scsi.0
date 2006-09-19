From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] mptspi : Bug fix to prevent infinite nested domain
	validation
Date: Tue, 19 Sep 2006 20:50:00 +0000
Message-ID: <1158699000.2837.56.camel@markh3.pdx.osdl.net>
References: <20060918234453.GA7576@lsil.com>
	 <1158634560.6390.69.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:34717 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751108AbWISUuS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 16:50:18 -0400
In-Reply-To: <1158634560.6390.69.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric Moore <eric.moore@lsil.com>, linux-scsi@vger.kernel.org

On Mon, 2006-09-18 at 22:56 -0400, James Bottomley wrote:
> On Mon, 2006-09-18 at 17:44 -0600, Eric Moore wrote:
> > This event occurs when dv sends an inquiry to a device,
> > and the device never returns, thus timing out.
> > This results in a task_abort, followed by host_reset.
> > >From host_reset, domain validation is invoked again, and this
> > loop repeats itself forever.
> > 
> > Invoking domain validation from host_reset is required, as
> > device go to slowest speed, asyn narrow.
> > 
> > The fix I propose is to keep a bitwise flag `hd->spi_pending`
> > that keeps track of the devices that are in progress of domain
> > validation.  Then when host_reset occurs, we see if the
> > flag is non-zero, then take a different path which
> > program devices to old nego parameters, instead of calling dv
> > again.  We do nothing for the device that currently in
> > the middle of dv. When `hd->spi_pending` is zero, then
> > dv is performed on all devices.
> > 
> > Please note, we tried using the starget_data->dv_pending flag
> > from host_reset, by calling dv for devices not pending,
> > and this doesn't work.  The reason is if there is a faulty device
> > with a high id, such as 10, by the time we loop back to that id,
> > the dv_pending flag was always was zero, thus dv looped again.
> > Using the `hd->spi_pending` prevents nested dv, and at
> > the same time programs the devices back to previous nego.
> 
> Erm, but surely, since reset->dv is fairly standard, this must need a
> generic fix.
> 
> Can you check this out.  I think it does the right thing gating
> spi_dv_device() with a new flag.  The pending flag is more used to
> manage scheduled domain validations.   The original idea was that resets
> would trigger scheduled dv that would use this flag correctly (and not
> be in the direct path of DV).  For some reason the mptspi seems to
> manage to entangle DV with the reset inline.

I applied this patch (I needed to add this to get it to compile.

Index: scsi-misc-2.6/include/scsi/scsi_transport_spi.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_transport_spi.h        2006-07-10 13:33:13.000000000 -0700
+++ scsi-misc-2.6/include/scsi/scsi_transport_spi.h     2006-09-19 12:30:53.000000000 -0700
@@ -54,6 +54,7 @@
        unsigned int support_qas; /* supports quick arbitration and selection */        /* Private Fields */
        unsigned int dv_pending:1; /* Internal flag */
+       unsigned int dv_in_progress:1; /* Internal flag */
        struct mutex dv_mutex; /* semaphore to serialise dv */
 };

It does take quite a while.  It has been going for over 8 minutes and
isn't done yet.  Here is the log so far:


Sep 19 13:40:08 stp4-000 Fusion MPT base driver 3.04.01
Sep 19 13:40:08 stp4-000 Copyright (c) 1999-2005 LSI Logic Corporation
Sep 19 13:40:08 stp4-000 Fusion MPT SPI Host driver 3.04.01
Sep 19 13:40:08 stp4-000 mptbase: Initiating ioc0 bringup
Sep 19 13:40:09 stp4-000 ioc0: 53C1030: Capabilities={Initiator}
Sep 19 13:40:10 stp4-000 scsi1 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=20
Sep 19 13:40:12 stp4-000 scsi 1:0:1:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:40:12 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:12 stp4-000 SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:12 stp4-000 sdb: Write Protect is off
Sep 19 13:40:12 stp4-000 sdb: Mode Sense: a7 00 10 08
Sep 19 13:40:12 stp4-000 SCSI device sdb: drive cache: write back w/ FUA
Sep 19 13:40:12 stp4-000 SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:12 stp4-000 sdb: Write Protect is off
Sep 19 13:40:12 stp4-000 sdb: Mode Sense: a7 00 10 08
Sep 19 13:40:12 stp4-000 SCSI device sdb: drive cache: write back w/ FUA
Sep 19 13:40:12 stp4-000 sdb: sdb1
Sep 19 13:40:12 stp4-000 sd 1:0:1:0: Attached scsi disk sdb
Sep 19 13:40:12 stp4-000 sd 1:0:1:0: Attached scsi generic sg1 type 0
Sep 19 13:40:12 stp4-000 scsi 1:0:2:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:40:12 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:12 stp4-000 SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:12 stp4-000 sdc: Write Protect is off
Sep 19 13:40:12 stp4-000 sdc: Mode Sense: a7 00 10 08
Sep 19 13:40:12 stp4-000 SCSI device sdc: drive cache: write back w/ FUA
Sep 19 13:40:12 stp4-000 SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:12 stp4-000 sdc: Write Protect is off
Sep 19 13:40:12 stp4-000 sdc: Mode Sense: a7 00 10 08
Sep 19 13:40:12 stp4-000 SCSI device sdc: drive cache: write back w/ FUA
Sep 19 13:40:12 stp4-000 sdc: unknown partition table
Sep 19 13:40:12 stp4-000 sd 1:0:2:0: Attached scsi disk sdc
Sep 19 13:40:12 stp4-000 sd 1:0:2:0: Attached scsi generic sg2 type 0
Sep 19 13:40:12 stp4-000 scsi 1:0:3:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:40:12 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:12 stp4-000 SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:12 stp4-000 sdd: Write Protect is off
Sep 19 13:40:12 stp4-000 sdd: Mode Sense: a7 00 10 08
Sep 19 13:40:12 stp4-000 SCSI device sdd: drive cache: write back w/ FUA
Sep 19 13:40:12 stp4-000 SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:12 stp4-000 sdd: Write Protect is off
Sep 19 13:40:12 stp4-000 sdd: Mode Sense: a7 00 10 08
Sep 19 13:40:12 stp4-000 SCSI device sdd: drive cache: write back w/ FUA
Sep 19 13:40:12 stp4-000 sdd: unknown partition table
Sep 19 13:40:12 stp4-000 sd 1:0:3:0: Attached scsi disk sdd
Sep 19 13:40:12 stp4-000 sd 1:0:3:0: Attached scsi generic sg3 type 0
Sep 19 13:40:12 stp4-000 scsi 1:0:5:0: Processor         HP       D5989C           1.06 PQ: 0 ANSI: 2
Sep 19 13:40:12 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:40:12 stp4-000 target1:0:5: asynchronous
Sep 19 13:40:12 stp4-000 scsi 1:0:5:0: Attached scsi generic sg4 type 3
Sep 19 13:40:13 stp4-000 scsi 1:0:8:0: Direct access     HP 18.2G MAP3367NC#HJ     HPC6 PQ: 0 ANSI: 3
Sep 19 13:40:13 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:40:23 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f7f2d180)
Sep 19 13:40:23 stp4-000 scsi 1:0:8:0:
Sep 19 13:40:23 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:40:25 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:40:50 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f7f2d180)
Sep 19 13:40:50 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:40:50 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:40:50 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:8: asynchronous
Sep 19 13:40:50 stp4-000 SCSI device sde: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:50 stp4-000 sde: Write Protect is off
Sep 19 13:40:50 stp4-000 sde: Mode Sense: cf 00 10 08
Sep 19 13:40:50 stp4-000 SCSI device sde: drive cache: write through w/ FUA
Sep 19 13:40:50 stp4-000 SCSI device sde: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:50 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:50 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:40:50 stp4-000 sde: Write Protect is off
Sep 19 13:40:50 stp4-000 sde: Mode Sense: cf 00 10 08
Sep 19 13:40:50 stp4-000 SCSI device sde: drive cache: write through w/ FUA
Sep 19 13:40:50 stp4-000 sde:<6> target1:0:2: Ending Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:50 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:40:50 stp4-000 unknown partition table
Sep 19 13:40:50 stp4-000 sd 1:0:8:0: Attached scsi disk sde
Sep 19 13:40:50 stp4-000 sd 1:0:8:0: Attached scsi generic sg5 type 0
Sep 19 13:40:50 stp4-000 scsi 1:0:9:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:40:50 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:50 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:5: asynchronous
Sep 19 13:40:50 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:40:50 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:40:50 stp4-000 SCSI device sdf: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:40:56 stp4-000 udevd-event[4719]: wait_for_sysfs: waiting for '/sys/devices/pci0000:01/0000:01:02.0/host1/target1:0:9/1:0:9:0/ioerr_cnt' failed
Sep 19 13:41:20 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:41:20 stp4-000 sd 1:0:8:0:
Sep 19 13:41:20 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:41:22 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:41:46 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:41:46 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:41:46 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:41:46 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:41:46 stp4-000 target1:0:8: asynchronous
Sep 19 13:41:47 stp4-000 sdf: Write Protect is off
Sep 19 13:41:47 stp4-000 sdf: Mode Sense: a7 00 10 08
Sep 19 13:41:47 stp4-000 SCSI device sdf: drive cache: write back w/ FUA
Sep 19 13:41:47 stp4-000 SCSI device sdf: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:41:47 stp4-000 sdf: Write Protect is off
Sep 19 13:41:47 stp4-000 sdf: Mode Sense: a7 00 10 08
Sep 19 13:41:47 stp4-000 SCSI device sdf: drive cache: write back w/ FUA
Sep 19 13:41:47 stp4-000 sdf:<6> target1:0:9: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:41:47 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 unknown partition table
Sep 19 13:41:47 stp4-000 sd 1:0:9:0: Attached scsi disk sdf
Sep 19 13:41:47 stp4-000 sd 1:0:9:0: Attached scsi generic sg6 type 0
Sep 19 13:41:47 stp4-000 scsi 1:0:10:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:41:47 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:41:47 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:41:47 stp4-000 SCSI device sdg: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:41:47 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:41:47 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:41:47 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:41:47 stp4-000 target1:0:5: asynchronous
Sep 19 13:41:47 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:41:47 stp4-000 sdg: Write Protect is off
Sep 19 13:41:47 stp4-000 sdg: Mode Sense: a7 00 10 08
Sep 19 13:41:47 stp4-000 SCSI device sdg: drive cache: write through w/ FUA
Sep 19 13:41:47 stp4-000 SCSI device sdg: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:41:47 stp4-000 sdg: Write Protect is off
Sep 19 13:41:47 stp4-000 sdg: Mode Sense: a7 00 10 08
Sep 19 13:41:51 stp4-000 udevd-event[4725]: wait_for_sysfs: waiting for '/sys/devices/pci0000:01/0000:01:02.0/host1/target1:0:10/1:0:10:0/ioerr_cnt' failedSep 19 13:42:17 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f7f2d180)
Sep 19 13:42:17 stp4-000 sd 1:0:8:0:
Sep 19 13:42:17 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:42:19 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:42:44 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f7f2d180)
Sep 19 13:42:44 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:42:44 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:42:44 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:8: asynchronous
Sep 19 13:42:44 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:42:44 stp4-000 SCSI device sdg: drive cache: write through w/ FUA
Sep 19 13:42:44 stp4-000 sdg:<6> target1:0:10: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:42:44 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 unknown partition table
Sep 19 13:42:44 stp4-000 sd 1:0:10:0: Attached scsi disk sdg
Sep 19 13:42:44 stp4-000 sd 1:0:10:0: Attached scsi generic sg7 type 0
Sep 19 13:42:44 stp4-000 scsi 1:0:11:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:42:44 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:42:44 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:42:44 stp4-000 SCSI device sdh: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:42:44 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:42:44 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:42:44 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 sdh: Write Protect is off
Sep 19 13:42:44 stp4-000 sdh: Mode Sense: a7 00 10 08
Sep 19 13:42:44 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:42:44 stp4-000 target1:0:5: asynchronous
Sep 19 13:42:44 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:42:44 stp4-000 SCSI device sdh: drive cache: write back w/ FUA
Sep 19 13:42:44 stp4-000 SCSI device sdh: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:42:44 stp4-000 sdh: Write Protect is off
Sep 19 13:42:44 stp4-000 sdh: Mode Sense: a7 00 10 08
Sep 19 13:42:50 stp4-000 udevd-event[4731]: wait_for_sysfs: waiting for '/sys/devices/pci0000:01/0000:01:02.0/host1/target1:0:11/1:0:11:0/ioerr_cnt' failedSep 19 13:43:14 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f7f2d180)
Sep 19 13:43:14 stp4-000 sd 1:0:8:0:
Sep 19 13:43:14 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:43:16 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:43:41 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f7f2d180)
Sep 19 13:43:41 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:43:41 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:43:41 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:8: asynchronous
Sep 19 13:43:41 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 SCSI device sdh: drive cache: write back w/ FUA
Sep 19 13:43:41 stp4-000 sdh: unknown partition table
Sep 19 13:43:41 stp4-000 sd 1:0:11:0: Attached scsi disk sdh
Sep 19 13:43:41 stp4-000 sd 1:0:11:0: Attached scsi generic sg8 type 0
Sep 19 13:43:41 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 scsi 1:0:12:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:43:41 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 SCSI device sdi: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:43:41 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:43:41 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 sdi: Write Protect is off
Sep 19 13:43:41 stp4-000 sdi: Mode Sense: a7 00 10 08
Sep 19 13:43:41 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:43:41 stp4-000 target1:0:5: asynchronous
Sep 19 13:43:41 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:43:41 stp4-000 SCSI device sdi: drive cache: write back w/ FUA
Sep 19 13:43:41 stp4-000 SCSI device sdi: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:43:41 stp4-000 sdi: Write Protect is off
Sep 19 13:43:41 stp4-000 sdi: Mode Sense: a7 00 10 08
Sep 19 13:43:41 stp4-000 SCSI device sdi: drive cache: write back w/ FUA
Sep 19 13:43:45 stp4-000 udevd-event[4737]: wait_for_sysfs: waiting for '/sys/devices/pci0000:01/0000:01:02.0/host1/target1:0:12/1:0:12:0/ioerr_cnt' failedSep 19 13:44:11 stp4-000 sdi:<4>mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:44:11 stp4-000 sd 1:0:8:0:
Sep 19 13:44:11 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:44:13 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:44:38 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:44:38 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:44:38 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:44:38 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:8: asynchronous
Sep 19 13:44:38 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 sdi1
Sep 19 13:44:38 stp4-000 sd 1:0:12:0: Attached scsi disk sdi
Sep 19 13:44:38 stp4-000 sd 1:0:12:0: Attached scsi generic sg9 type 0
Sep 19 13:44:38 stp4-000 scsi 1:0:13:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:44:38 stp4-000 target1:0:13: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 SCSI device sdj: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:44:38 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 sdj: Write Protect is off
Sep 19 13:44:38 stp4-000 sdj: Mode Sense: a7 00 10 08
Sep 19 13:44:38 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 SCSI device sdj: drive cache: write back w/ FUA
Sep 19 13:44:38 stp4-000 SCSI device sdj: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:44:38 stp4-000 sdj: Write Protect is off
Sep 19 13:44:38 stp4-000 sdj: Mode Sense: a7 00 10 08
Sep 19 13:44:38 stp4-000 SCSI device sdj: drive cache: write back w/ FUA
Sep 19 13:44:38 stp4-000 sdj:<6> target1:0:13: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 unknown partition table
Sep 19 13:44:38 stp4-000 sd 1:0:13:0: Attached scsi disk sdj
Sep 19 13:44:38 stp4-000 sd 1:0:13:0: Attached scsi generic sg10 type 0
Sep 19 13:44:38 stp4-000 scsi 1:0:14:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:44:38 stp4-000 target1:0:14: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:14: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 SCSI device sdk: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:44:38 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:44:38 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 sdk: Write Protect is off
Sep 19 13:44:38 stp4-000 sdk: Mode Sense: a7 00 10 08
Sep 19 13:44:38 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:44:38 stp4-000 target1:0:5: asynchronous
Sep 19 13:44:38 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:44:38 stp4-000 SCSI device sdk: drive cache: write back w/ FUA
Sep 19 13:44:38 stp4-000 SCSI device sdk: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:44:38 stp4-000 sdk: Write Protect is off
Sep 19 13:44:38 stp4-000 sdk: Mode Sense: a7 00 10 08
Sep 19 13:44:44 stp4-000 udevd-event[4752]: wait_for_sysfs: waiting for '/sys/devices/pci0000:01/0000:01:02.0/host1/target1:0:14/1:0:14:0/ioerr_cnt' failedSep 19 13:45:08 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:45:08 stp4-000 sd 1:0:8:0:
Sep 19 13:45:08 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:45:10 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:45:35 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:45:35 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:45:35 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:45:35 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:8: asynchronous
Sep 19 13:45:35 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 SCSI device sdk: drive cache: write back w/ FUA
Sep 19 13:45:35 stp4-000 sdk: sdk1
Sep 19 13:45:35 stp4-000 sd 1:0:14:0: Attached scsi disk sdk
Sep 19 13:45:35 stp4-000 sd 1:0:14:0: Attached scsi generic sg11 type 0
Sep 19 13:45:35 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 scsi 1:0:15:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 19 13:45:35 stp4-000 target1:0:15: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:15: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 SCSI device sdl: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:45:35 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 target1:0:13: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 target1:0:14: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 sdl: Write Protect is off
Sep 19 13:45:35 stp4-000 sdl: Mode Sense: a7 00 10 08
Sep 19 13:45:35 stp4-000 SCSI device sdl: drive cache: write through w/ FUA
Sep 19 13:45:35 stp4-000 SCSI device sdl: 35566480 512-byte hdwr sectors (18210 MB)
Sep 19 13:45:35 stp4-000 target1:0:14: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 sdl: Write Protect is off
Sep 19 13:45:35 stp4-000 sdl: Mode Sense: a7 00 10 08
Sep 19 13:45:35 stp4-000 SCSI device sdl: drive cache: write through w/ FUA
Sep 19 13:45:35 stp4-000 sdl:<6> target1:0:15: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:15: Ending Domain Validation
Sep 19 13:45:35 stp4-000 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:35 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:45:35 stp4-000 unknown partition table
Sep 19 13:45:35 stp4-000 sd 1:0:15:0: Attached scsi disk sdl
Sep 19 13:45:35 stp4-000 sd 1:0:15:0: Attached scsi generic sg12 type 0
Sep 19 13:45:35 stp4-000 mptbase: Initiating ioc1 bringup
Sep 19 13:45:36 stp4-000 ioc1: 53C1030: Capabilities={Initiator}
Sep 19 13:45:37 stp4-000 scsi2 : ioc1: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=21
Sep 19 13:45:37 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:37 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:37 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:45:37 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:45:37 stp4-000 target1:0:5: asynchronous
Sep 19 13:45:37 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:45:47 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:45:47 stp4-000 sd 1:0:8:0:
Sep 19 13:45:47 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:45:50 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:46:16 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:46:16 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:46:16 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:46:16 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:8: asynchronous
Sep 19 13:46:16 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:13: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:14: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:14: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:15: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:15: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:16 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:46:16 stp4-000 target1:0:5: asynchronous
Sep 19 13:46:16 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:46:26 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:46:26 stp4-000 sd 1:0:8:0:
Sep 19 13:46:26 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:46:28 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:46:54 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:46:54 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:46:54 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:46:54 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:8: asynchronous
Sep 19 13:46:54 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:13: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:14: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:14: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:15: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:15: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:46:54 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:46:54 stp4-000 target1:0:5: asynchronous
Sep 19 13:46:54 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:47:04 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:47:04 stp4-000 sd 1:0:8:0:
Sep 19 13:47:04 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:47:07 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:47:33 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:47:33 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:47:33 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:47:33 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:8: asynchronous
Sep 19 13:47:33 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:13: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:14: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:14: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:15: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:15: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:47:33 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:47:33 stp4-000 target1:0:5: asynchronous
Sep 19 13:47:33 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:47:43 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:47:43 stp4-000 sd 1:0:8:0:
Sep 19 13:47:43 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:47:45 stp4-000 mptbase: Initiating ioc0 recovery
Sep 19 13:48:11 stp4-000 mptscsih: ioc0: task abort: SUCCESS (sc=f6c981c0)
Sep 19 13:48:11 stp4-000 target1:0:8: Domain Validation detected failure, dropping back
Sep 19 13:48:11 stp4-000 target1:0:8: Domain Validation skipping write tests
Sep 19 13:48:11 stp4-000 target1:0:8: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:8: asynchronous
Sep 19 13:48:11 stp4-000 target1:0:9: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:9: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:9: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:10: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:10: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:10: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:11: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:11: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:11: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:12: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:12: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:12: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:13: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:13: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:13: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:14: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:14: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:14: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:15: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:15: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:15: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:1: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:1: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:2: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:2: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:3: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:3: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 19 13:48:11 stp4-000 target1:0:5: Beginning Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:5: Ending Domain Validation
Sep 19 13:48:11 stp4-000 target1:0:5: asynchronous
Sep 19 13:48:11 stp4-000 target1:0:8: Beginning Domain Validation
Sep 19 13:48:21 stp4-000 mptscsih: ioc0: attempting task abort! (sc=f6c981c0)
Sep 19 13:48:21 stp4-000 sd 1:0:8:0:
Sep 19 13:48:21 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 19 13:48:24 stp4-000 mptbase: Initiating ioc0 recovery



> 
> James
> 
> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
> index 29a9a53..92e2bfc 100644
> --- a/drivers/scsi/scsi_transport_spi.c
> +++ b/drivers/scsi/scsi_transport_spi.c
> @@ -47,6 +47,7 @@ #define DV_RETRIES	3	/* should only need
>  
>  /* Private data accessors (keep these out of the header file) */
>  #define spi_dv_pending(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_pending)
> +#define spi_dv_in_progress(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_in_progress)
>  #define spi_dv_mutex(x) (((struct spi_transport_attrs *)&(x)->starget_data)->dv_mutex)
>  
>  struct spi_internal {
> @@ -240,6 +241,7 @@ static int spi_setup_transport_attrs(str
>  	spi_pcomp_en(starget) = 0;
>  	spi_hold_mcs(starget) = 0;
>  	spi_dv_pending(starget) = 0;
> +	spi_dv_in_progress(starget) = 0;
>  	spi_initial_dv(starget) = 0;
>  	mutex_init(&spi_dv_mutex(starget));
>  
> @@ -907,6 +909,10 @@ spi_dv_device(struct scsi_device *sdev)
>  	if (unlikely(scsi_device_get(sdev)))
>  		return;
>  
> +	if (unlikely(spi_dv_in_progress(starget)))
> +		return;
> +	spi_dv_in_progress(starget) = 1;
> +
>  	buffer = kzalloc(len, GFP_KERNEL);
>  
>  	if (unlikely(!buffer))
> @@ -938,6 +944,7 @@ spi_dv_device(struct scsi_device *sdev)
>   out_free:
>  	kfree(buffer);
>   out_put:
> +	spi_dv_in_progress(starget) = 0;
>  	scsi_device_put(sdev);
>  }
>  EXPORT_SYMBOL(spi_dv_device);
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Mark Haverkamp <markh@osdl.org>

