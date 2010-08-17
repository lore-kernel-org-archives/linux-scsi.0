From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Tue, 17 Aug 2010 15:19:15 +0200
Message-ID: <20100817131915.GB2963@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100813114858.GA31937@lst.de> <4C654D4B.1030507@kernel.org> <20100813143820.GA7931@lst.de> <4C655BE5.4070809@kernel.org> <20100814103654.GA13292@lst.de> <4C6A5D8A.4010205@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:49129 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0HQNTo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2010 09:19:44 -0400
Content-Disposition: inline
In-Reply-To: <4C6A5D8A.4010205@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

On Tue, Aug 17, 2010 at 11:59:38AM +0200, Tejun Heo wrote:
> I'm not really convinced that would help much.  If bisecting can point
> to the conversion as the culprit for whatever kind of failure,
> wouldn't that be enough?  No matter what we do the conversion will be
> a single step thing.  If we make the filesystems enforce the ordering
> first and then relax ordering in the block layer, bisection would
> still just point at the later patch.  The same goes for md/dm, the
> best we can find out would be whether the conversion is correct or not
> anyway.

The filesystems already enforce the ordering, except reiserfs which
opts out if the barrier options is set. 

> I'm not against restructuring the patchset if it makes more sense but
> it just feels like it would be a bit pointless effort (and one which
> would require much tighter coordination among different trees) at this
> point.  Am I missing something?

What other trees do you mean?  The conversions of the 8 filesystems
that actually support barriers need to go through this tree anyway
if we want to be able to test it.  Also the changes in the filesystem
are absolutely minimal - it's basically just
s/WRITE_BARRIER/WRITE_FUA_FLUSH/ after my initial patch kill BH_Orderd,
and removing about 10 lines of code in reiserfs.

> > We only need the special md_flush_request handling for
> > empty REQ_FLUSH requests.  REQ_WRITE | REQ_FLUSH just need the
> > flag propagated to the underlying devices.
> 
> Hmm, not really, the WRITE should happen after all the data in cache
> are committed to NV media, meaning that empty FLUSH should already
> have finished by the time the WRITE starts.

You're right.

> >>  	while ((bio = bio_list_pop(writes))) {
> >> -		if (unlikely(bio_empty_barrier(bio))) {
> >> +		if ((bio->bi_rw & REQ_FLUSH) && !bio_has_data(bio)) {
> > 
> > I kept bio_empty_barrier as bio_empty_flush, which actually is a quite
> > useful macro for the bio based drivers.
> 
> Hmm... maybe.  The reason why I removed bio_empty_flush() was that
> except for the front-most sequencer (block layer for all the request
> based ones and the front-most make_request for bio based ones), it
> doesn't make sense to see REQ_FLUSH + data bios.  They should be
> sequenced at the front-most stage anyway, so I didn't have much use
> for them.  Those code paths couldn't deal with REQ_FLUSH + data bios
> anyway.

The current bio_empty_barrier is only used in dm, and indeed only makes
sense for make_request-based drivers.  But I think it's a rather useful
helper for them.  Either way, it's not a big issue and either way is
fine with me.

> >> +		if (bio->bi_rw & REQ_FLUSH) {
> >>  			/*
> >> -			 * There can be just one barrier request so we use
> >> +			 * There can be just one flush request so we use
> >>  			 * a per-device variable for error reporting.
> >>  			 * Note that you can't touch the bio after end_io_acct
> >>  			 */
> >> -			if (!md->barrier_error && io_error != -EOPNOTSUPP)
> >> -				md->barrier_error = io_error;
> >> +			if (!md->flush_error)
> >> +				md->flush_error = io_error;
> > 
> > And we certainly do not need any special casing here.  See my patch.
> 
> I wasn't sure about that part.  You removed store_flush_error(), but
> DM_ENDIO_REQUEUE should still have higher priority than other
> failures, no?

Which priority?

> >> +static void process_flush(struct mapped_device *md, struct bio *bio)
> >>  {
> >> +	md->flush_error = 0;
> >> +
> >> +	/* handle REQ_FLUSH */
> >>  	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
> >>
> >> -	bio_init(&md->barrier_bio);
> >> -	md->barrier_bio.bi_bdev = md->bdev;
> >> -	md->barrier_bio.bi_rw = WRITE_BARRIER;
> >> -	__split_and_process_bio(md, &md->barrier_bio);
> >> +	bio_init(&md->flush_bio);
> >> +	md->flush_bio.bi_bdev = md->bdev;
> >> +	md->flush_bio.bi_rw = WRITE_FLUSH;
> >> +	__split_and_process_bio(md, &md->flush_bio);
> > 
> > There's not need to use a separate flush_bio here.
> > __split_and_process_bio does the right thing for empty REQ_FLUSH
> > requests.  See my patch for how to do this differenty.  And yeah,
> > my version has been tested.
> 
> But how do you make sure REQ_FLUSHes for preflush finish before
> starting the write?

Hmm, okay.  I see how the special flush_bio makes the waiting easier,
let's see if Mike or other in the DM team have a better idea.

