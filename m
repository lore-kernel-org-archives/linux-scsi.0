From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH] sym53c8xx_2: avoid data corruption when disk rejects
 commands with QUEUE FULL
Date: Mon, 9 May 2011 13:07:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105091304000.32299@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.2.00.1105082057460.15552@artax.karlin.mff.cuni.cz> <1304886595.4865.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1304886595.4865.3.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Sun, 8 May 2011, James Bottomley wrote:

> On Sun, 2011-05-08 at 21:00 +0200, Mikulas Patocka wrote:
> > [ the maintainer is not responding, so I'm sending this to other people ]
> > 
> > sym53c8xx_2: avoid data corruption when disk rejects commands with QUEUE 
> > FULL
> 
> Could you describe the corruption, with logs?

sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 01 37 9a 00 00 02 00
lost page write due to I/O error on sda1
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 01 38 10 00 00 10 00
lost page write due to I/O error on sda1
...

> The behaviour you list below should may cause disk errors to the 
> filesystem, but it shouldn't cause corruption.

It causes disk write errors, and in most filesystems, write errors result 
in data corruption --- i.e. some metadata are written, other metadata 
aren't, and the result is a corrupted filesystem.

> > When the controller encounters an error (including QUEUE FULL or BUSY 
> > status), it aborts all not yet submitted requests in the function 
> > sym_dequeue_from_squeue.
> 
> This would be a driver bug: QUEUE_FULL or BUSY should never cause aborts
> of outstanding commands.

Yes, it is a driver bug.

> > This function aborts them with DID_SOFT_ERROR.
> > 
> > If the disk has a full tag queue, the request that caused the overflow is
> > aborted with QUEUE FULL status (and the scsi midlayer properly retries it
> > until it is accepted by the disk), but other requests are aborted with
> > DID_SOFT_ERROR --- for them, the midlayer does just a few retries and then
> > signals the error up to sd.
> > 
> > The result is that disk returning QUEUE FULL causes request failures.
> > 
> > The error was reproduced on 53c895 with COMPAQ BD03685A24 disk (rebranded
> > ST336607LC) with command queue 48 or 64 tags. The disk has 64 tags, but
> > under some access patterns it return QUEUE FULL when there are less than
> > 64 pending tags. The SCSI specification allows returning QUEUE FULL
> > anytime and it is up to the host to retry.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/scsi/sym53c8xx_2/sym_hipd.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > Index: linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c
> > ===================================================================
> > --- linux-2.6.36-rc5-fast.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:25:59.000000000 +0200
> > +++ linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:26:27.000000000 +0200
> > @@ -3000,7 +3000,11 @@ sym_dequeue_from_squeue(struct sym_hcb *
> >  		if ((target == -1 || cp->target == target) &&
> >  		    (lun    == -1 || cp->lun    == lun)    &&
> >  		    (task   == -1 || cp->tag    == task)) {
> > +#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
> >  			sym_set_cam_status(cp->cmd, DID_SOFT_ERROR);
> > +#else
> > +			sym_set_cam_status(cp->cmd, DID_REQUEUE);
> > +#endif
> 
> This isn't a good idea ... that return code causes retries for ever.

If the disk returns QUEUE_FULL, we should retry forever.

> I think the correct fix is just to make the QUEUE_FULL handling in the
> driver work.

When I enabled SYM_OPT_HANDLE_DEVICE_QUEUEING, I got crashes.

> James

Mikulas
