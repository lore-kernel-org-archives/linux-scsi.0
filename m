From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 19 Jul 2013 21:56:02 -0700
Message-ID: <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
References: <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
	 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
	 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
	 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
	 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
	 <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
	 <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
	 <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
	 <51E83E32.9050306@cs.wisc.edu>
	 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
	 <20130719003034.GG28005@kernel.dk>
	 <1374195825.7397.997.camel@haakon3.risingtidesystems.com>
	 <1374215660.7397.1041.camel@haakon3.risingtidesystems.com>
	 <1374248000.2266.20.camel@dabdike>
	 <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1374267684.7397.1058.camel@haakon3.risingtidesystems.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Christie <michaelc@cs.wisc.edu>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-07-19 at 14:01 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2013-07-19 at 08:33 -0700, James Bottomley wrote:
> > On Thu, 2013-07-18 at 23:34 -0700, Nicholas A. Bellinger wrote:
> > > diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> > > index 0101af5..191bc15 100644
> > > --- a/drivers/ata/libata-scsi.c
> > > +++ b/drivers/ata/libata-scsi.c
> > > @@ -1144,7 +1144,11 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
> > >                         "sector_size=%u > PAGE_SIZE, PIO may malfunction\n",
> > >                         sdev->sector_size);
> > >  
> > > -       blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
> > > +       if (!q->mq_ops) {
> > > +               blk_queue_update_dma_alignment(q, sdev->sector_size - 1);
> > > +       } else {
> > > +               printk("Skipping dma_alignment for libata w/ scsi-mq\n");
> > > +       }
> > 
> > Amazingly enough there is a reason for the dma alignment, and it wasn't
> > just to annoy you, so you can't blindly do this.
> > 
> > The email thread is probably lost in the mists of time, but if I
> > remember correctly the problem is that some ahci DMA controllers barf if
> > the sector they're doing DMA on crosses a page boundary.  Some are
> > annoying enough to actually cause silent data corruption.  You won't
> > find every ahci DMA controller doing this, so the change will work for
> > some, but it will be hard to identify those it won't work for until
> > people start losing data.
> 
> Thanks for the extra background.
> 
> So at least from what I gather thus far this shouldn't be an issue for
> initial testing with scsi-mq <-> libata w/ ata_piix.
> 
> > 
> > The correct fix, obviously, is to do the bio copy on the kernel path for
> > unaligned data.  It is OK to assume that REQ_TYPE_FS data is correctly
> > aligned (because of the block to page alignment).
> > 
> 
> Indeed.  Looking into the bio_copy_kern() breakage next..
> 

OK, after further investigation the root cause is a actually a missing
bio->bio_end_io() -> bio_copy_kern_endio() -> bio_put() from the
blk_end_sync_rq() callback path that scsi-mq REQ_TYPE_BLOCK_PC is
currently using.

Including the following patch into the scsi-mq working branch now, and
reverting the libata dma_alignment=0x03 hack.

Alexander, care to give this a try..?

--nab

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 0761c89..70303d2 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -25,7 +25,10 @@ static void blk_end_sync_rq(struct request *rq, int error)
        struct completion *waiting = rq->end_io_data;
 
        rq->end_io_data = NULL;
-       if (!rq->q->mq_ops) {
+       if (rq->q->mq_ops) {
+               if (rq->bio)
+                       bio_endio(rq->bio, error);
+       } else {
                __blk_put_request(rq->q, rq);
        }

