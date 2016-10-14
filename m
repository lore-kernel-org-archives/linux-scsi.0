From: Adam Manzananares <adam.manzanares@wdc.com>
Subject: Re: [PATCH v4 1/4] block: Add iocontext priority to request
Date: Fri, 14 Oct 2016 11:35:54 -0700
Message-ID: <20161014183554.GB6788@hgst.com>
References: <1476388433-2539-1-git-send-email-adam.manzanares@hgst.com>
 <1476388433-2539-2-git-send-email-adam.manzanares@hgst.com>
 <733629ac-fb98-9acf-3b2b-e1554e839346@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <733629ac-fb98-9acf-3b2b-e1554e839346@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Adam Manzanares <adam.manzanares@hgst.com>, axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The 10/14/2016 07:54, Hannes Reinecke wrote:
> On 10/13/2016 09:53 PM, Adam Manzanares wrote:
> > Patch adds an association between iocontext ioprio and the ioprio of a
> > request. This value is set in blk_rq_set_prio which takes the request and
> > the ioc as arguments. If the ioc is valid in blk_rq_set_prio then the
> > iopriority of the request is set as the iopriority of the ioc. In
> > init_request_from_bio a check is made to see if the ioprio of the bio is
> > valid and if so then the request prio comes from the bio.
> > 
> > Signed-off-by: Adam Manzananares <adam.manzanares@wdc.com>
> > ---
> >  block/blk-core.c       |  4 +++-
> >  include/linux/blkdev.h | 14 ++++++++++++++
> >  2 files changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 14d7c07..361b1b9 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -1153,6 +1153,7 @@ static struct request *__get_request(struct request_list *rl, int op,
> >  
> >  	blk_rq_init(q, rq);
> >  	blk_rq_set_rl(rq, rl);
> > +	blk_rq_set_prio(rq, ioc);
> >  	req_set_op_attrs(rq, op, op_flags | REQ_ALLOCED);
> >  
> >  	/* init elvpriv */
> > @@ -1656,7 +1657,8 @@ void init_request_from_bio(struct request *req, struct bio *bio)
> >  
> >  	req->errors = 0;
> >  	req->__sector = bio->bi_iter.bi_sector;
> > -	req->ioprio = bio_prio(bio);
> > +	if (ioprio_valid(bio_prio(bio)))
> > +		req->ioprio = bio_prio(bio);
> >  	blk_rq_bio_prep(req->q, req, bio);
> >  }
> >  
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index c47c358..9a0ceaa 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -934,6 +934,20 @@ static inline unsigned int blk_rq_count_bios(struct request *rq)
> >  }
> >  
> >  /*
> > + * blk_rq_set_prio - associate a request with prio from ioc
> > + * @rq: request of interest
> > + * @ioc: target iocontext
> > + *
> > + * Assocate request prio with ioc prio so request based drivers
> > + * can leverage priority information.
> > + */
> > +static inline void blk_rq_set_prio(struct request *rq, struct io_context *ioc)
> > +{
> > +	if (ioc)
> > +		rq->ioprio = ioc->ioprio;
> > +}
> > +
> > +/*
> >   * Request issue related functions.
> >   */
> >  extern struct request *blk_peek_request(struct request_queue *q);
> > 
> Don't you need to check for 'ioprio_valid()' here, too?

I poked around and it should be safe to not check for ioprio valid
at this point. ioprio_valid only checks to see if the ioprio is 
not IOPRIO_CLASS_NONE. The request by default has a ioprio of none
so if the ioc has ioprio of none we are not changing anything. 

The locations in the code that I found where the ioc prio is set are 
either filtered through the syscall handler, which checks for invalid 
priority combinations, or have valid priority values. 

Take care,
Adam

> 
> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG Nürnberg)
