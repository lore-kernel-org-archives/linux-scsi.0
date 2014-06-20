From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 20 Jun 2014 21:36:44 +0000
Message-ID: <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
	 <1401901323.17510.23.camel@dabdike>
	 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
	 <53911A35.7010805@cs.wisc.edu>
	 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
	 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <539206FA.1020001@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <jbottomley@parallels.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "apw@canonical.com" <apw@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Friday, June 6, 2014 11:23 AM
> To: James Bottomley; michaelc@cs.wisc.edu
> Cc: linux-kernel@vger.kernel.org; hch@infradead.org;
> devel@linuxdriverproject.org; apw@canonical.com; KY Srinivasan; linux-
> scsi@vger.kernel.org; ohering@suse.com; gregkh@linuxfoundation.org;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
> from the basic I/O timeout
> 
> On 2014-06-06 11:52, James Bottomley wrote:
> > On Fri, 2014-06-06 at 12:18 -0500, Mike Christie wrote:
> >> On 6/5/14, 9:53 PM, KY Srinivasan wrote:
> >>>
> >>>
> >>>> -----Original Message-----
> >>>> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> >>>> Sent: Thursday, June 5, 2014 6:33 PM
> >>>> To: KY Srinivasan
> >>>> Cc: James Bottomley; linux-kernel@vger.kernel.org;
> >>>> apw@canonical.com; devel@linuxdriverproject.org;
> hch@infradead.org;
> >>>> linux- scsi@vger.kernel.org; ohering@suse.com;
> >>>> gregkh@linuxfoundation.org; jasowang@redhat.com
> >>>> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> >>>> FLUSH_TIMEOUT from the basic I/O timeout
> >>>>
> >>>> On 06/04/2014 12:15 PM, KY Srinivasan wrote:
> >>>>>
> >>>>>
> >>>>>> -----Original Message-----
> >>>>>> From: James Bottomley [mailto:jbottomley@parallels.com]
> >>>>>> Sent: Wednesday, June 4, 2014 10:02 AM
> >>>>>> To: KY Srinivasan
> >>>>>> Cc: linux-kernel@vger.kernel.org; apw@canonical.com;
> >>>>>> devel@linuxdriverproject.org; hch@infradead.org; linux-
> >>>>>> scsi@vger.kernel.org; ohering@suse.com;
> >>>>>> gregkh@linuxfoundation.org; jasowang@redhat.com
> >>>>>> Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the
> >>>>>> FLUSH_TIMEOUT from the basic I/O timeout
> >>>>>>
> >>>>>> On Wed, 2014-06-04 at 09:33 -0700, K. Y. Srinivasan wrote:
> >>>>>>> Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added
> code
> >>>>>>> to derive the FLUSH_TIMEOUT from the basic I/O timeout.
> However,
> >>>>>>> this patch did not use the basic I/O timeout of the device. Fix this
> bug.
> >>>>>>>
> >>>>>>> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >>>>>>> ---
> >>>>>>>    drivers/scsi/sd.c |    4 +++-
> >>>>>>>    1 files changed, 3 insertions(+), 1 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c index
> >>>>>>> e9689d5..54150b1 100644
> >>>>>>> --- a/drivers/scsi/sd.c
> >>>>>>> +++ b/drivers/scsi/sd.c
> >>>>>>> @@ -832,7 +832,9 @@ static int
> sd_setup_write_same_cmnd(struct
> >>>>>>> scsi_device *sdp, struct request *rq)
> >>>>>>>
> >>>>>>>    static int scsi_setup_flush_cmnd(struct scsi_device *sdp,
> >>>>>>> struct request *rq)  {
> >>>>>>> -	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> >>>>>>> +	int timeout = sdp->request_queue->rq_timeout;
> >>>>>>> +
> >>>>>>> +	rq->timeout = (timeout *
> SD_FLUSH_TIMEOUT_MULTIPLIER);
> >>>>>>
> >>>>>> Could you share where you found this to be a problem?  It looks
> >>>>>> like a bug in block because all inbound requests being prepared
> >>>>>> should have a timeout set, so block would be the place to fix it.
> >>>>>
> >>>>> Perhaps; what I found was that the value in rq->timeout was 0
> >>>>> coming into this function and thus multiplying obviously has no effect.
> >>>>>
> >>>>
> >>>> I think you are right. We hit this problem because we are doing:
> >>>>
> >>>> scsi_request_fn -> blk_peek_request -> sd_prep_fn ->
> >>>> scsi_setup_flush_cmnd.
> >>>>
> >>>> At this time request->timeout is zero so the multiplication does
> >>>> nothing. See how sd_setup_write_same_cmnd will set the request-
> >timeout at this time.
> >>>>
> >>>> Then in scsi_request_fn we do:
> >>>>
> >>>> scsi_request_fn -> blk_start_request -> blk_add_timer.
> >>>>
> >>>> At this time it will set the request->timeout if something like req
> >>>> block pc users (like scsi_execute() or block/scsi_ioctl.c) or the
> >>>> write same code mentioned above have not set the timeout.
> >>>
> >>> I don't think this is a recent change. Prior to this commit, we were
> >>> setting the timeout value in this function; it just happened to be a
> >>> different constant unrelated to the I/O timeout.
> >>>
> >>
> >> Yeah, it looks like when 7e660100d85af860e7ad763202fff717adcdaacd was
> >> merged we were supposed to initialize it like in your patch in this thread.
> >>
> >> I guess we could do your patch in this thread, or if we want the
> >> block layer to initialize the timeout before the prep_fn callout is
> >> called then we would need to have the blk-flush.c code to that when
> >> it sets up the request. If we do the latter, do we want the discard
> >> and write same code to initialize the request's timeout before the
> >> prep_fn callout is called too?
> >
> > I looked through the call chain; it seems to be intentional behaviour
> > on the part of block.  Just from an mq point of view, it would make
> > better code if we unconditionally initialised rq->timeout early and
> > allowed prep to modify it and then dumped the if(!req->timeout) in
> > blk_add_timer(), but it's a marginal if condition that would compile
> > to a conditional store on sensible architectures, so losing the
> > conditional probably isn't worth worrying about.
> >
> > Cc'd Jens for his opinion with the block patch
> 
> I just committed this one earlier today:
> 
> http://git.kernel.dk/?p=linux-
> block.git;a=commit;h=f6be4fb4bcb396fc3b1c134b7863351972de081f
> 
> since I ran into the same thing on nvme. Either approach is fine with me, as
> they both allow override of the timeout before insertion. But we've always
> done the rq->timeout = 0 init, so I think we should just reinstate that
> behavior.

James,

How is this being fixed now.

Regards,

K. Y
