From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel
	Errors
Date: 17 Dec 2003 09:24:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071671058.10878.5.camel@mulgrave>
References: <000501c3c47c$dfc05ae0$0200000a@nightsky>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:31467 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264437AbTLQOYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2003 09:24:45 -0500
In-Reply-To: <000501c3c47c$dfc05ae0$0200000a@nightsky>
List-Id: linux-scsi@vger.kernel.org
To: James Daniel <jdaniel@dakotacom.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <mikenc@us.ibm.com>

On Wed, 2003-12-17 at 04:05, James Daniel wrote:
> i91u: PCI Base=0xEC00, IRQ=12, BIOS=0xC8000, SCSI ID=7
> i91u: Reset SCSI Bus ...
> ERROR: SCSI host `INI9100U' has no error handling
> ERROR: This is not a safe way to run your SCSI host
> ERROR: The error handling must be added to this driver
> Call Trace:
>  [<c029cfd1>] scsi_host_alloc+0x291/0x2a0
>  [<c029cff1>] scsi_register+0x11/0x60
>  [<c02a4ed1>] i91u_detect+0x1d1/0x3c0
>  [<c0290e28>] ide_register_driver+0xe8/0x120
>  [<c03628b3>] init_this_scsi_driver+0x53/0x100
>  [<c035276c>] do_initcalls+0x2c/0xa0
>  [<c01050ed>] init+0x2d/0x140
>  [<c01050c0>] init+0x0/0x140
>  [<c0107329>] kernel_thread_helper+0x5/0x1c

This one's expected:  although the driver was made compilable and
converted to the new dma API, it still needs a new error handler, which
is what the complaint is about.

> It then goes on to ID the drive correctly, and loads the sd driver, which
> again IDs the drive correctly.. and we get:
> 
> SCSI device  sda: 17783240 512-byte hdwr sectors (9105 MB)
> SCSI device sda: drive cache: write back
> /dev/scsi/host0/bus0/target1/lun0: unknown partition table
> Attached scsi disk sda at scsi0, channel 0, id 1, lun 0

This one's really strange, because clearly the INQUIRY and the
READ_CAPACITY both succeeded and returned apparently good values.  The
READ10 to the DOS parition sector has failed (with no errors).

The only difference is that the READ10 is generated in the partition
code (via read_dev_sector), so it will be a sg read (probably with
scsi_device->use_sg set to 1)...I'm travelling today, so if Mike hasn't
found the problem by the tomorrow, I'll take a look.

James


