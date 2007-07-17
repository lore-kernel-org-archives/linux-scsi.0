From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 13:22:33 -0700
Message-ID: <20070717132233.ed11362c.akpm@linux-foundation.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<20070717063810.GY5195@kernel.dk>
	<20070717121821.3212cd60.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757146AbXGQUXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 16:23:07 -0400
In-Reply-To: <20070717121821.3212cd60.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 17 Jul 2007 12:18:21 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 17 Jul 2007 08:38:11 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > In terms of presentation: this code hit the tree as base patch plus what
> > > appear to be 20 bugfixes, none of which are really interesting or relevant
> > > to mainline.  Personally I think it would be nicer if all that out-of-tree
> > > development work was cleaned up and the new code goes in as a single hit.
> > > 
> > > This makes it a lot easier to find out "wtf does this code all do".  One
> > > finds the first commit and reads the changlog.  But this algorithm yields:
> > > 
> > >     bsg: support for full generic block layer SG v3
> > > 
> > > which is not helpful.
> > 
> > I agree, I did consider rebasing the merging all patches into a single
> > commit prior to submission. In retrospect that would have been better,
> > the bug fixes commits prior to inclusion is not that interesting.
> 
> I'm doing a git-bisect and....
> 
> block/bsg.c: In function 'bsg_register_queue':
> block/bsg.c:1014: error: 'struct kobject' has no member named 'dentry'
> 
> That's easily fixable in config, but it's another reason for doing
> that consolidation prior to merging.

So this rather painful and compiler-errorful bisection session ended up at:

commit 3d6392cfbd7dc11f23058e3493683afab4ac13a3
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Mon Jul 9 12:38:05 2007 +0200

    bsg: support for full generic block layer SG v3                                 


What is happening is that my old dual-PIII IDE-PIIX box running
hacked-about FC1 is locking up early in initscripts, just after "Finding
module dependencies".

Config is http://userweb.kernel.org/~akpm/config-vmm.txt with CONFIG_SCSI=n.

Occasionally I'll get an NMI watchdog timeout, but it's a rather
uninteresting one: the stack trace just points up into the idle task.

This:

--- a/drivers/ide/ide.c~a
+++ a/drivers/ide/ide.c
@@ -1052,9 +1052,9 @@ int generic_ide_ioctl(ide_drive_t *drive
 	int err, (*setfunc)(ide_drive_t *, int);
 	u8 *val;
 
-	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
-	if (err != -ENOTTY)
-		return err;
+//	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
+//	if (err != -ENOTTY)
+//		return err;
 
 	switch (cmd) {
 	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
_

fixes it.


I added this:

--- a/drivers/ide/ide.c~a
+++ a/drivers/ide/ide.c
@@ -1052,7 +1052,9 @@ int generic_ide_ioctl(ide_drive_t *drive
 	int err, (*setfunc)(ide_drive_t *, int);
 	u8 *val;
 
+	printk("%s: cmd=%d\n", __FUNCTION__, cmd);
 	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
+	printk("%s: err=%d\n", __FUNCTION__, err);
 	if (err != -ENOTTY)
 		return err;
 
_


and got:

default.hotplug used greatest stack depth: 6448 bytes left
hotplug used greatest stack depth: 6396 bytes left
hotplug used greatest stack depth: 5540 bytes left
EXT3 FS on hdc2, internal journal
Adding 1020116k swap on /dev/hdc3.  Priority:-1 extents:1 across:1020116k
generic_ide_ioctl: cmd=21382
generic_ide_ioctl: err=0
generic_ide_ioctl: cmd=1
program scsi_unique_id is using a deprecated SCSI ioctl, please convert it to SG_IO
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

<20000 lines removed>

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 
ide_do_rw_disk - bad command: dev hdc: type=2, flags=104c8

sector 1515870810, nr/cnr 0/0
bio f73714f8, biotail f73714f8, buffer 00000000, data 00000000, len 96
cdb: 12 01 80 00 60 00 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 


and there it all stopped.

