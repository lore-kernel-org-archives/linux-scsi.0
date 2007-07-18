From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 22:32:58 +0200
Message-ID: <200707182232.58961.bzolnier@gmail.com>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org> <200707180243.13368.bzolnier@gmail.com> <1184767917.3464.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:48969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXGRVHK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 17:07:10 -0400
Received: by ug-out-1314.google.com with SMTP id j3so325086ugf
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 14:07:09 -0700 (PDT)
In-Reply-To: <1184767917.3464.13.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


Hi,

On Wednesday 18 July 2007, James Bottomley wrote:
> On Wed, 2007-07-18 at 02:43 +0200, Bartlomiej Zolnierkiewicz wrote:
> > [ James, please remeber to cc: linux-ide on IDE patches, thanks. ]
> 
> Blame Andrew ... I assumed he'd be reporting the problem to the relevant
> lists, so I just did a reply all ...

No need to blame anybody, especially since it seems that one more person
forgot about adding linux-ide ML.  ;)

> > On Wednesday 18 July 2007, Jeff Garzik wrote:
> > > James Bottomley wrote:
> > > > @@ -1052,9 +1054,10 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
> > > >  	int err, (*setfunc)(ide_drive_t *, int);
> > > >  	u8 *val;
> > > >  
> > > > -	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > > > -	if (err != -ENOTTY)
> > > > -		return err;
> > > > +	switch (cmd) {
> > > > +	case SG_IO:
> > > > +		return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > > > +	}
> > > >  
> > > >  	switch (cmd) {
> > > >  	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
> > > 
> > > 
> > > At that point you might as well use an 'if'.
> > > 
> > > But overall -- agreed.  ACK.
> > 
> > James/Jeff thanks for following the issue but NAK. ;)
> > 
> > Causes regression wrt ide-floppy CDROMEJECT/CDROMCLOSETRAY support when
> > compared to 2.6.22 and SG_IO is not supported by ide-{disk,scsi,tape}.
> 
> Well ... that was why I put the case statement in ... I was sure there
> would be other ioctls I missed.

The thing is that ide-{disk,scsi,tape} really don't support
REQ_TYPE_BLOCK_PC type requests so ide.c::generic_ide_ioctl()
is not the best place to add handling of SG_IO.

Patch attached.

> > Luckily Linus has already fixed the issue properly.
> 
> Actually, no, that's just a reversion.  I think we need the attached to
> complete all of this.
> 
> > BTW cmd == 1 IOCTL is not defined/used by IDE driver.
> 
> Andrew's trace clearly shows that something is sending cmd == 1 down, so

I still haven't got the trace.  Andrew, please (re)send it in PM, thanks.

> I'm nearly positive at one time this was a legitimate ioctl for IDE.

Could be...

> Anyway it's probably time to kill this deprecated ioctl in SCSI.

Fully agreed.

Thanks,
Bart


[PATCH] ide: add support for SCSI ioctls to ide-floppy

Now that ide-floppy supports SG_IO we can add support for SCSI ioctls
(except deprecated SCSI_IOCTL_SEND_COMMAND and legacy CDROM_SEND_PACKET
ones - we can add them later iff really needed).

While at it remove handling of CDROMEJECT and CDROMCLOSETRAY ioctls from
generic_ide_ioctl():

- This prevents ide-{disk,tape,scsi} device drivers from obtaining
  REQ_TYPE_BLOCK_PC type requests which are currently unsupported by
  these drivers and which are potentially harmful (as reported by Andrew).

- There is no functionality loss since aforementioned ioctls will now be
  handled by idefloppy_ioctl()->scsi_cmd_ioctl() (for devices using
  ide-floppy driver) and by idecd_ioctl->cdrom_ioctl()->scsi_cmd_ioctl()
  (for devices using ide-cd driver).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-floppy.c |   18 +++++++++++++++++-
 drivers/ide/ide.c        |    4 ----
 2 files changed, 17 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -99,6 +99,8 @@
 #include <linux/bitops.h>
 #include <linux/mutex.h>
 
+#include <scsi/scsi_ioctl.h>
+
 #include <asm/byteorder.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -2099,7 +2101,21 @@ static int idefloppy_ioctl(struct inode 
 	case IDEFLOPPY_IOCTL_FORMAT_GET_PROGRESS:
 		return idefloppy_get_format_progress(drive, argp);
 	}
-	return generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+	/*
+	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
+	 * and CDROM_SEND_PACKET (legacy) ioctls
+	 */
+	if (cmd != CDROM_SEND_PACKET && cmd != SCSI_IOCTL_SEND_COMMAND)
+		err = scsi_cmd_ioctl(file, bdev->bd_disk->queue,
+					bdev->bd_disk, cmd, argp);
+	else
+		err = -ENOTTY;
+
+	if (err == -ENOTTY)
+		err = generic_ide_ioctl(drive, file, bdev, cmd, arg);
+
+	return err;
 }
 
 static int idefloppy_media_changed(struct gendisk *disk)
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1171,10 +1171,6 @@ int generic_ide_ioctl(ide_drive_t *drive
 			return 0;
 		}
 
-		case CDROMEJECT:
-		case CDROMCLOSETRAY:
-			return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
-
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
 				return -EACCES;
