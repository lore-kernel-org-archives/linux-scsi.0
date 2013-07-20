From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Sat, 20 Jul 2013 15:14:23 -0700
Message-ID: <1374358463.7397.1124.camel@haakon3.risingtidesystems.com>
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
	 <1374296162.7397.1098.camel@haakon3.risingtidesystems.com>
	 <51EAA33C.9010405@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <51EAA33C.9010405@fusionio.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Christie <mchristie@fusionio.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-07-20 at 09:48 -0500, Mike Christie wrote:
> On 07/19/2013 11:56 PM, Nicholas A. Bellinger wrote:
> > On Fri, 2013-07-19 at 14:01 -0700, Nicholas A. Bellinger wrote:
> >> On Fri, 2013-07-19 at 08:33 -0700, James Bottomley wrote:

<SNIP>

> >>
> >> Indeed.  Looking into the bio_copy_kern() breakage next..
> >>
> > 
> > OK, after further investigation the root cause is a actually a missing
> > bio->bio_end_io() -> bio_copy_kern_endio() -> bio_put() from the
> > blk_end_sync_rq() callback path that scsi-mq REQ_TYPE_BLOCK_PC is
> > currently using.
> > 
> > Including the following patch into the scsi-mq working branch now, and
> > reverting the libata dma_alignment=0x03 hack.
> > 
> > Alexander, care to give this a try..?
> > 
> > --nab
> > 
> > diff --git a/block/blk-exec.c b/block/blk-exec.c
> > index 0761c89..70303d2 100644
> > --- a/block/blk-exec.c
> > +++ b/block/blk-exec.c
> > @@ -25,7 +25,10 @@ static void blk_end_sync_rq(struct request *rq, int error)
> >         struct completion *waiting = rq->end_io_data;
> >  
> >         rq->end_io_data = NULL;
> > -       if (!rq->q->mq_ops) {
> > +       if (rq->q->mq_ops) {
> > +               if (rq->bio)
> > +                       bio_endio(rq->bio, error);
> > +       } else {
> >                 __blk_put_request(rq->q, rq);
> >         }
> > 
> 
> 
> This does not handle requests with multiple bios, and for the mq stye
> passthrough insertion completions you actually want to call
> blk_mq_finish_request in scsi_execute. Same for all the other
> passthrough code in your scsi mq tree. That is your root bug. Instead of
> doing that though I think we want to have the block layer free the bios
> like before.
> 
> For the non mq calls, blk_end_request type of calls will complete the
> bios when blk_finish_request is called from that path. It will then call
> the rq end_io callback.
> 
> I think the blk mq code assumes if the end_io callack is set that the
> end_io function will do the bio cleanup. See __blk_mq_end_io. Also see
> how blk_mq_execute_rq calls blk_mq_finish_request for an example of how
> rq passthrough execution and cleanup is being done in the mq paths.
> 
> Now with the scsi mq changes, when blk_execute_rq_nowait calls
> blk_mq_insert_request it calls it with a old non mq style of end io
> function that does not complete the bios.
> 
> What about the attached only compile tested patch. The patch has the mq
> block code work like the non mq code for bio cleanups.
> 
> 

OK, so with your blk-mq patch in place to always call
blk_mq_finish_request() in blk_mq_complete_request() regardless of
rq->end_io, the preceding scsi_mq_end_request() can now simply call
blk_mq_end_io() for both BLOCK_RQ and FS request types.

diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
index 81b2633..f1d4789 100644
--- a/drivers/scsi/scsi-mq.c
+++ b/drivers/scsi/scsi-mq.c
@@ -93,19 +93,7 @@ struct scsi_cmnd *scsi_mq_end_request(struct scsi_cmnd *sc, int error,
 #endif
 
 //FIXME: Add proper blk_mq_end_io residual bytes + requeue
-       if (rq->end_io) {
-#if 0
-               printk("scsi_mq_end_request: Calling rq->end_io BLOCK_PC for"
-                       " CDB: 0x%02x\n", sc->cmnd[0]);
-#endif
-               rq->end_io(rq, error);
-       } else {
-#if 0
-               printk("scsi_mq_end_request: Calling blk_mq_end_io for CDB: 0x%02x\n",
-                               sc->cmnd[0]);
-#endif
-               blk_mq_end_io(rq, error);
-       }
+       blk_mq_end_io(rq, error);
 //FIXME: Need to do equiv of scsi_next_command to kick hctx..?
 
        return NULL;

Thanks for fixing up that bit of ugliness.  ;)

Jens, care to review+include Mike's change into your working branch..?

--nab

