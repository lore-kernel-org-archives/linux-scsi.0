From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 01/28] blk_end_request: add new request completion
	interface (take 3)
Date: Wed, 5 Dec 2007 10:48:03 +0100
Message-ID: <20071205094802.GA4969@kernel.dk>
References: <20071130.182422.18574732.k-ueda@ct.jp.nec.com> <47555C90.2080609@panasas.com> <20071204.163749.39152828.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071204.163749.39152828.k-ueda@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 04 2007, Kiyoshi Ueda wrote:
> Hi Boaz and Jens,
> 
> On Tue, 04 Dec 2007 15:56:32 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
> > > +/**
> > > + * blk_end_request - Helper function for drivers to complete the request.
> > > + * @rq:       the request being processed
> > > + * @uptodate: 1 for success, 0 for I/O error, < 0 for specific error
> > > + * @nr_bytes: number of bytes to complete
> > > + *
> > > + * Description:
> > > + *     Ends I/O on a number of bytes attached to @rq.
> > > + *     If @rq has leftover, sets it up for the next range of segments.
> > > + *
> > > + * Return:
> > > + *     0 - we are done with this request
> > > + *     1 - still buffers pending for this request
> > > + **/
> > > +int blk_end_request(struct request *rq, int uptodate, int nr_bytes)
> > 
> > I always hated that uptodate boolean with possible negative error value.
> > I guess it was done for backward compatibility of then users of 
> > end_that_request_first(). But since you are introducing a new API then
> > this is not the case. Just have regular status int where 0 means ALL_OK
> > and negative value means error code. 
> > Just my $0.02.
> 
> Thank you for the comment.
> I think it's quite reasonable.
> By doing that, we don't need end_io_error() anymore.
> 
> 
> Jens,
> What do you think?

I agree, the uptodate usage right now is horrible.

> If you agree with the interface change above, I would prefer to
> separate the patch-set from blk_end_request patch-set like below:
>     o blk_end_request: remove end_that_request_*
>     o change interface of 'uptodate' in blk_end_request to 'error'
> It makes the purpose of blk_end_request patch-set clear
> (and also, each patch of device drivers could be smaller).
> But, it doubles your merging work.  So if you would like to get
> the changes at once, I'll merge them into blk_end_request patch-set.

Twice the merging is not an issue for me.

> As for the patch inclusion, do you push the driver changes to Linus
> all at once?  Or should I ask each maintainer to take the patch?

Lets just try to get as many maintainer acks as possible, since the
patches need to go in together.

-- 
Jens Axboe

