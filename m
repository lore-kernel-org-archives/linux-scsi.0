From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] mptspi: Bug fix to prevent infinite nested
	domainvalidation
Date: Wed, 20 Sep 2006 08:42:42 -0700
Message-ID: <1158766963.27672.23.camel@markh3.pdx.osdl.net>
References: <20060920003550.GA1154@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:39896 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751650AbWITPmu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 11:42:50 -0400
In-Reply-To: <20060920003550.GA1154@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Tue, 2006-09-19 at 18:35 -0600, Eric Moore wrote:
> From host_reset, this patch will complete domain validation
> in the same context as the eh threads.  I've added passing
> the sleepFlag, which is CAN_SLEEP in the context of eh threads.
> 
> Mark pls try this with the patch that James posted earlier that
> prevents re entry to pending dv.

Something isn't working quite right.  Here is the log.  The modprobe
gets stuck.

Sep 20 08:20:37 stp4-000 Fusion MPT base driver 3.04.01
Sep 20 08:20:37 stp4-000 Copyright (c) 1999-2005 LSI Logic Corporation
Sep 20 08:20:37 stp4-000 Fusion MPT SPI Host driver 3.04.01
Sep 20 08:20:37 stp4-000 mptbase: Initiating ioc0 bringup
Sep 20 08:20:39 stp4-000 ioc0: 53C1030: Capabilities={Initiator}
Sep 20 08:20:40 stp4-000 scsi1 : ioc0: LSI53C1030, FwRev=01030a00h, Ports=1, MaxQ=222, IRQ=20
Sep 20 08:20:41 stp4-000 scsi 1:0:1:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 20 08:20:41 stp4-000 target1:0:1: Beginning Domain Validation
Sep 20 08:20:41 stp4-000 target1:0:1: Ending Domain Validation
Sep 20 08:20:41 stp4-000 target1:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 20 08:20:41 stp4-000 SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
Sep 20 08:20:41 stp4-000 sdb: Write Protect is off
Sep 20 08:20:41 stp4-000 sdb: Mode Sense: a7 00 10 08
Sep 20 08:20:41 stp4-000 SCSI device sdb: drive cache: write back w/ FUA
Sep 20 08:20:41 stp4-000 SCSI device sdb: 35566480 512-byte hdwr sectors (18210 MB)
Sep 20 08:20:41 stp4-000 sdb: Write Protect is off
Sep 20 08:20:41 stp4-000 sdb: Mode Sense: a7 00 10 08
Sep 20 08:20:41 stp4-000 SCSI device sdb: drive cache: write back w/ FUA
Sep 20 08:20:41 stp4-000 sdb: sdb1
Sep 20 08:20:41 stp4-000 sd 1:0:1:0: Attached scsi disk sdb
Sep 20 08:20:41 stp4-000 sd 1:0:1:0: Attached scsi generic sg1 type 0
Sep 20 08:20:41 stp4-000 scsi 1:0:2:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 20 08:20:41 stp4-000 target1:0:2: Beginning Domain Validation
Sep 20 08:20:41 stp4-000 target1:0:2: Ending Domain Validation
Sep 20 08:20:41 stp4-000 target1:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 20 08:20:41 stp4-000 SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
Sep 20 08:20:42 stp4-000 sdc: Write Protect is off
Sep 20 08:20:42 stp4-000 sdc: Mode Sense: a7 00 10 08
Sep 20 08:20:42 stp4-000 SCSI device sdc: drive cache: write back w/ FUA
Sep 20 08:20:42 stp4-000 SCSI device sdc: 35566480 512-byte hdwr sectors (18210 MB)
Sep 20 08:20:42 stp4-000 sdc: Write Protect is off
Sep 20 08:20:42 stp4-000 sdc: Mode Sense: a7 00 10 08
Sep 20 08:20:42 stp4-000 SCSI device sdc: drive cache: write back w/ FUA
Sep 20 08:20:42 stp4-000 sdc: unknown partition table
Sep 20 08:20:42 stp4-000 sd 1:0:2:0: Attached scsi disk sdc
Sep 20 08:20:42 stp4-000 sd 1:0:2:0: Attached scsi generic sg2 type 0
Sep 20 08:20:42 stp4-000 scsi 1:0:3:0: Direct access     HP       18.2GB C 80-H008 H008 PQ: 0 ANSI: 2
Sep 20 08:20:42 stp4-000 target1:0:3: Beginning Domain Validation
Sep 20 08:20:42 stp4-000 target1:0:3: Ending Domain Validation
Sep 20 08:20:42 stp4-000 target1:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT RTI WRFLOW PCOMP (12.5 ns, offset 126)
Sep 20 08:20:42 stp4-000 SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
Sep 20 08:20:42 stp4-000 sdd: Write Protect is off
Sep 20 08:20:42 stp4-000 sdd: Mode Sense: a7 00 10 08
Sep 20 08:20:42 stp4-000 SCSI device sdd: drive cache: write back w/ FUA
Sep 20 08:20:42 stp4-000 SCSI device sdd: 35566480 512-byte hdwr sectors (18210 MB)
Sep 20 08:20:42 stp4-000 sdd: Write Protect is off
Sep 20 08:20:42 stp4-000 sdd: Mode Sense: a7 00 10 08
Sep 20 08:20:42 stp4-000 SCSI device sdd: drive cache: write back w/ FUA
Sep 20 08:20:42 stp4-000 sdd: unknown partition table
Sep 20 08:20:42 stp4-000 sd 1:0:3:0: Attached scsi disk sdd
Sep 20 08:20:42 stp4-000 sd 1:0:3:0: Attached scsi generic sg3 type 0
Sep 20 08:20:42 stp4-000 scsi 1:0:5:0: Processor         HP       D5989C           1.06 PQ: 0 ANSI: 2
Sep 20 08:20:42 stp4-000 target1:0:5: Beginning Domain Validation
Sep 20 08:20:42 stp4-000 target1:0:5: Ending Domain Validation
Sep 20 08:20:42 stp4-000 target1:0:5: asynchronous
Sep 20 08:20:42 stp4-000 scsi 1:0:5:0: Attached scsi generic sg4 type 3
Sep 20 08:20:42 stp4-000 scsi 1:0:8:0: Direct access     HP 18.2G MAP3367NC#HJ     HPC6 PQ: 0 ANSI: 3
Sep 20 08:20:42 stp4-000 target1:0:8: Beginning Domain Validation
Sep 20 08:20:52 stp4-000 mptscsih: ioc0: attempting task abort! (sc=d4c2be60)
Sep 20 08:20:52 stp4-000 scsi 1:0:8:0:
Sep 20 08:20:52 stp4-000 command: cdb[0]=0x12: 12 00 00 00 60 00
Sep 20 08:20:54 stp4-000 mptbase: Initiating ioc0 recovery
Sep 20 08:21:19 stp4-000 target1:0:1: Beginning Domain Validation



> 
-- 
Mark Haverkamp <markh@osdl.org>

