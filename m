From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Mon, 30 Apr 2007 13:59:17 +0200
Message-ID: <20070430115917.GK21015@kernel.dk>
References: <46225E18.7070404@panasas.com> <462261E8.5090005@panasas.com> <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp> <4634BE6B.3000808@panasas.com> <1177872588.3688.79.camel@mulgrave.il.steeleye.com> <20070430111157.GI21015@kernel.dk> <4635D89D.4000500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4635D89D.4000500@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <tomof@acm.org>, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 30 2007, Benny Halevy wrote:
> Jens Axboe wrote:
> > On Sun, Apr 29 2007, James Bottomley wrote:
> >> On Sun, 2007-04-29 at 18:48 +0300, Boaz Harrosh wrote:
> >>> FUJITA Tomonori wrote:
> >>>> From: Boaz Harrosh <bharrosh@panasas.com>
> >>>> Subject: [PATCH 4/4] bidi support: bidirectional request
> >>>> Date: Sun, 15 Apr 2007 20:33:28 +0300
> >>>>
> >>>>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >>>>> index 645d24b..16a02ee 100644
> >>>>> --- a/include/linux/blkdev.h
> >>>>> +++ b/include/linux/blkdev.h
> >>>>> @@ -322,6 +322,7 @@ struct request {
> >>>>>      void *end_io_data;
> >>>>>
> >>>>>      struct request_io_part uni;
> >>>>> +    struct request_io_part bidi_read;
> >>>>>  };
> >>>> Would be more straightforward to have:
> >>>>
> >>>> struct request_io_part in;
> >>>> struct request_io_part out;
> >>>>
> >>> Yes I wish I could do that. For bidi supporting drivers this is the most logical.
> >>> But for the 99.9% of uni-directional drivers, calling rq_uni(), and being some what on
> >>> the hotish paths, this means we will need a pointer to a uni request_io_part.
> >>> This is bad because:
> >>> 1st- There is no defined stage in a request life where to definitely set that pointer,
> >>>      specially in the preparation stages.
> >>> 2nd- hacks like scsi_error.c/scsi_send_eh_cmnd() will not work at all. Now this is a
> >>>      very bad spot already, and I have a short term fix for it in the SCSI-bidi patches
> >>>      (not sent yet) but a more long term solution is needed. Once such hacks are
> >>>      cleaned up we can do what you say. This is exactly why I use the access functions
> >>>      rq_uni/rq_io/rq_in/rq_out and not open code access.
> >> I'm still not really convinced about this approach.  The primary job of
> >> the block layer is to manage and merge READ and WRITE requests.  It
> >> serves a beautiful secondary function of queueing for arbitrary requests
> >> it doesn't understand (REQ_TYPE_BLOCK_PC or REQ_TYPE_SPECIAL ... or
> >> indeed any non REQ_TYPE_FS).
> >>
> >> bidirectional requests fall into the latter category (there's nothing
> >> really we can do to merge them ... they're just transported by the block
> >> layer).  The only unusual feature is that they carry two bios.  I think
> >> the drivers that actually support bidirectional will be a rarity, so it
> >> might even be advisable to add it to the queue capability (refuse
> >> bidirectional requests at the top rather than perturbing all the drivers
> >> to process them).
> >>
> >> So, what about REQ_TYPE_BIDIRECTIONAL rather than REQ_BIDI?  That will
> >> remove it from the standard path and put it on the special command type
> >> path where we can process it specially.  Additionally, if you take this
> >> approach, you can probably simply chain the second bio through
> >> req->special as an additional request in the stream.  The only thing
> >> that would then need modification would be the dequeue of the block
> >> driver (it would have to dequeue both requests and prepare them) and
> >> that needs to be done only for drivers handling bidirectional requests.
> > 
> > I agree, I'm really not crazy about shuffling the entire request setup
> > around just for something as exotic as bidirection commands. How about
> > just keeping it simple - have a second request linked off the first one
> > for the second data phase? So keep it completely seperate, not just
> > overload ->special for 2nd bio list.
> > 
> > So basically just add a struct request pointer, so you can do rq =
> > rq->next_rq or something for the next data phase. I bet this would be a
> > LOT less invasive as well, and we can get by with a few helpers to
> > support it.
> > 
> > And it should definitely be a request type.
> > 
> 
> I'm a bit confused since what you both suggest is very similar to what we've
> proposed back in October 2006 and the impression we got was that it will be
> better to support bidirectional block requests natively (yet to be honest,
> James, you wanted a linked request all along).

It still has to be implemented natively at the block layer, just
differently like described above. So instead of messing all over the
block layer adding rq_uni() stuff, just add that struct request pointer
to the request structure for the 2nd data phase. You can relatively easy
then modify the block layer helpers to support mapping and setup of such
requests.

> Before we go on that route again, how do you see the support for bidi
> at the scsi mid-layer done?  Again, we prefer to support that officially
> using two struct scsi_cmnd_buff instances in struct scsi_cmnd and not as
> a one-off feature, using special-purpose state and logic (e.g. a linked
> struct scsi_cmd for the bidi_read sg list).

The SCSI part is up to James, that can be done as either inside a single
scsi command, or as linked scsi commands as well. I don't care too much
about that bit, just the block layer parts :-). And the proposed block
layer design can be used both ways by the scsi layer.

-- 
Jens Axboe

