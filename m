From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Sun, 29 Apr 2007 13:49:48 -0500
Message-ID: <1177872588.3688.79.camel@mulgrave.il.steeleye.com>
References: <46225E18.7070404@panasas.com>	<462261E8.5090005@panasas.com>
	 <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp>
	 <4634BE6B.3000808@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4634BE6B.3000808@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <tomof@acm.org>, jens.axboe@oracle.com, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bhalevy@panasas.com
List-Id: linux-scsi@vger.kernel.org

On Sun, 2007-04-29 at 18:48 +0300, Boaz Harrosh wrote:
> FUJITA Tomonori wrote:
> > From: Boaz Harrosh <bharrosh@panasas.com>
> > Subject: [PATCH 4/4] bidi support: bidirectional request
> > Date: Sun, 15 Apr 2007 20:33:28 +0300
> > 
> >> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> >> index 645d24b..16a02ee 100644
> >> --- a/include/linux/blkdev.h
> >> +++ b/include/linux/blkdev.h
> >> @@ -322,6 +322,7 @@ struct request {
> >>      void *end_io_data;
> >>
> >>      struct request_io_part uni;
> >> +    struct request_io_part bidi_read;
> >>  };
> > 
> > Would be more straightforward to have:
> > 
> > struct request_io_part in;
> > struct request_io_part out;
> > 
> 
> Yes I wish I could do that. For bidi supporting drivers this is the most logical.
> But for the 99.9% of uni-directional drivers, calling rq_uni(), and being some what on
> the hotish paths, this means we will need a pointer to a uni request_io_part.
> This is bad because:
> 1st- There is no defined stage in a request life where to definitely set that pointer,
>      specially in the preparation stages.
> 2nd- hacks like scsi_error.c/scsi_send_eh_cmnd() will not work at all. Now this is a
>      very bad spot already, and I have a short term fix for it in the SCSI-bidi patches
>      (not sent yet) but a more long term solution is needed. Once such hacks are
>      cleaned up we can do what you say. This is exactly why I use the access functions
>      rq_uni/rq_io/rq_in/rq_out and not open code access.

I'm still not really convinced about this approach.  The primary job of
the block layer is to manage and merge READ and WRITE requests.  It
serves a beautiful secondary function of queueing for arbitrary requests
it doesn't understand (REQ_TYPE_BLOCK_PC or REQ_TYPE_SPECIAL ... or
indeed any non REQ_TYPE_FS).

bidirectional requests fall into the latter category (there's nothing
really we can do to merge them ... they're just transported by the block
layer).  The only unusual feature is that they carry two bios.  I think
the drivers that actually support bidirectional will be a rarity, so it
might even be advisable to add it to the queue capability (refuse
bidirectional requests at the top rather than perturbing all the drivers
to process them).

So, what about REQ_TYPE_BIDIRECTIONAL rather than REQ_BIDI?  That will
remove it from the standard path and put it on the special command type
path where we can process it specially.  Additionally, if you take this
approach, you can probably simply chain the second bio through
req->special as an additional request in the stream.  The only thing
that would then need modification would be the dequeue of the block
driver (it would have to dequeue both requests and prepare them) and
that needs to be done only for drivers handling bidirectional requests.

James


