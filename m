From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux 5.3-rc1
Date: Tue, 23 Jul 2019 09:23:34 -0700
Message-ID: <1563899014.3609.26.camel@HansenPartnership.com>
References: <CAHk-=wiVjkTqzP6OppBuLQZ+t1mpRQC4T+Ho4Wg2sBAapKd--Q@mail.gmail.com>
         <20190722222126.GA27291@roeck-us.net>
         <1563839144.2504.5.camel@HansenPartnership.com>
         <4dc6ef77-afce-1c6d-add3-8df76332e672@roeck-us.net>
         <1563859682.2504.17.camel@HansenPartnership.com>
         <1e05670d-9e28-1b1d-249d-743c736e6d63@linux.ibm.com>
         <1563895995.3609.10.camel@HansenPartnership.com>
         <20190723161918.GB9140@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190723161918.GB9140@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>
Cc: Steffen Maier <maier@linux.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-07-23 at 09:19 -0700, Guenter Roeck wrote:
> On Tue, Jul 23, 2019 at 08:33:15AM -0700, James Bottomley wrote:
> [ ... ]
> > 
> > Yes, I think so.  Can someone try this, or something like it.
> > 
> > Thanks,
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 9381171c2fc0..4715671a1537 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1793,7 +1793,8 @@ void __scsi_init_queue(struct Scsi_Host
> > *shost, struct request_queue *q)
> >  	dma_set_seg_boundary(dev, shost->dma_boundary);
> >  
> >  	blk_queue_max_segment_size(q, shost->max_segment_size);
> > -	blk_queue_virt_boundary(q, shost->virt_boundary_mask);
> > +	if (shost->virt_boundary_mask)
> > +		blk_queue_virt_boundary(q, shost-
> > >virt_boundary_mask);
> >  	dma_set_max_seg_size(dev, queue_max_segment_size(q));
> >  
> >  	/*
> 
> This fixes the problem for me.

Great, thanks!

I'm thinking this is the more correct fix:

https://lore.kernel.org/linux-block/1563896932.3609.15.camel@HansenPartnership.com/

But we'll see what Jens says.

James
