From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 16:32:46 -0500
Message-ID: <1184794366.3464.67.camel@localhost.localdomain>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	 <200707180243.13368.bzolnier@gmail.com>
	 <1184767917.3464.13.camel@localhost.localdomain>
	 <200707182232.58961.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200707182232.58961.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-07-18 at 22:32 +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 18 July 2007, James Bottomley wrote:
> > On Wed, 2007-07-18 at 02:43 +0200, Bartlomiej Zolnierkiewicz wrote:
> > > [ James, please remeber to cc: linux-ide on IDE patches, thanks. ]
> > 
> > Blame Andrew ... I assumed he'd be reporting the problem to the relevant
> > lists, so I just did a reply all ...
> 
> No need to blame anybody, especially since it seems that one more person
> forgot about adding linux-ide ML.  ;)
> 
> > > On Wednesday 18 July 2007, Jeff Garzik wrote:
> > > > James Bottomley wrote:
> > > > > @@ -1052,9 +1054,10 @@ int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device
> > > > >  	int err, (*setfunc)(ide_drive_t *, int);
> > > > >  	u8 *val;
> > > > >  
> > > > > -	err = scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > > > > -	if (err != -ENOTTY)
> > > > > -		return err;
> > > > > +	switch (cmd) {
> > > > > +	case SG_IO:
> > > > > +		return scsi_cmd_ioctl(file, bdev->bd_disk->queue, bdev->bd_disk, cmd, p);
> > > > > +	}
> > > > >  
> > > > >  	switch (cmd) {
> > > > >  	case HDIO_GET_32BIT:	    val = &drive->io_32bit;	 goto read_val;
> > > > 
> > > > 
> > > > At that point you might as well use an 'if'.
> > > > 
> > > > But overall -- agreed.  ACK.
> > > 
> > > James/Jeff thanks for following the issue but NAK. ;)
> > > 
> > > Causes regression wrt ide-floppy CDROMEJECT/CDROMCLOSETRAY support when
> > > compared to 2.6.22 and SG_IO is not supported by ide-{disk,scsi,tape}.
> > 
> > Well ... that was why I put the case statement in ... I was sure there
> > would be other ioctls I missed.
> 
> The thing is that ide-{disk,scsi,tape} really don't support
> REQ_TYPE_BLOCK_PC type requests so ide.c::generic_ide_ioctl()
> is not the best place to add handling of SG_IO.

SG_IO has become a general packet request ioctl, so I think the idea is
to allow it to send taskfiles down ... I'll let Jens speak to where the
actual pieces to do this currently stand.

> Patch attached.
> 
> > > Luckily Linus has already fixed the issue properly.
> > 
> > Actually, no, that's just a reversion.  I think we need the attached to
> > complete all of this.
> > 
> > > BTW cmd == 1 IOCTL is not defined/used by IDE driver.
> > 
> > Andrew's trace clearly shows that something is sending cmd == 1 down, so
> 
> I still haven't got the trace.  Andrew, please (re)send it in PM, thanks.

http://marc.info/?l=linux-scsi&m=118470384305607

James


