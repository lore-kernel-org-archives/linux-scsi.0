From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND v2] block: modify __bio_add_page check to accept
 pages that don't start a new segment
Date: Mon, 25 Mar 2013 13:40:09 -0600
Message-ID: <20130325194009.GL5401@kernel.dk>
References: <51505AC1.60809@redhat.com>
 <20130325142457.GD5401@kernel.dk>
 <51506EBA.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51506EBA.8060708@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Vesely <jvesely@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, fujita.tomonori@lab.ntt.co.jp, Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 25 2013, Jan Vesely wrote:
>  51506edc5741209311913
> 
> On Mon 25 Mar 2013 15:24:57 CET, Jens Axboe wrote:
> > On Mon, Mar 25 2013, Jan Vesely wrote:
> >> v2: changed a comment
> >>
> >> The original behavior was to refuse all pages after the maximum number of
> >> segments has been reached. However, some drivers (like st) craft their buffers
> >> to potentially require exactly max segments and multiple pages in the last
> >> segment. This patch modifies the check to allow pages that can be merged into
> >> the last segment.
> >>
> >> Fixes EBUSY failures when using large tape block size in high
> >> memory fragmentation condition.
> >> This regression was introduced by commit
> >>  46081b166415acb66d4b3150ecefcd9460bb48a1
> >>  st: Increase success probability in driver buffer allocation
> >>
> >> Signed-off-by: Jan Vesely <jvesely@redhat.com>
> >>
> >> CC: Alexander Viro <viro@zeniv.linux.org.uk>
> >> CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >> CC: Kai Makisara <kai.makisara@kolumbus.fi>
> >> CC: James Bottomley <james.bottomley@hansenpartnership.com>
> >> CC: Jens Axboe <axboe@kernel.dk>
> >> CC: stable@vger.kernel.org
> >> ---
> >>  fs/bio.c | 27 +++++++++++++++++----------
> >>  1 file changed, 17 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/bio.c b/fs/bio.c
> >> index bb5768f..bc6af71 100644
> >> --- a/fs/bio.c
> >> +++ b/fs/bio.c
> >> @@ -500,7 +500,6 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
> >>  			  *page, unsigned int len, unsigned int offset,
> >>  			  unsigned short max_sectors)
> >>  {
> >> -	int retried_segments = 0;
> >>  	struct bio_vec *bvec;
> >>
> >>  	/*
> >> @@ -551,18 +550,13 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
> >>  		return 0;
> >>
> >>  	/*
> >> -	 * we might lose a segment or two here, but rather that than
> >> -	 * make this too complex.
> >> +	 * The first part of the segment count check,
> >> +	 * reduce segment count if possible
> >>  	 */
> >>
> >> -	while (bio->bi_phys_segments >= queue_max_segments(q)) {
> >> -
> >> -		if (retried_segments)
> >> -			return 0;
> >> -
> >> -		retried_segments = 1;
> >> +	if (bio->bi_phys_segments >= queue_max_segments(q))
> >>  		blk_recount_segments(q, bio);
> >> -	}
> >> +
> >>
> >>  	/*
> >>  	 * setup the new entry, we might clear it again later if we
> >> @@ -572,6 +566,19 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
> >>  	bvec->bv_page = page;
> >>  	bvec->bv_len = len;
> >>  	bvec->bv_offset = offset;
> >> +	
> >> +	/*
> >> +	 * the other part of the segment count check, allow mergeable pages
> >> +	 */
> >> +	if ((bio->bi_phys_segments > queue_max_segments(q)) ||
> >> +		( (bio->bi_phys_segments == queue_max_segments(q)) &&
> >> +		!BIOVEC_PHYS_MERGEABLE(bvec - 1, bvec))) {
> >> +			bvec->bv_page = NULL;
> >> +			bvec->bv_len = 0;
> >> +			bvec->bv_offset = 0;
> >> +			return 0;
> >> +	}
> >> +
> >
> > This is a bit messy, I think. bi_phys_segments should never be allowed
> > to go beyond queue_ma_segments(), so the > test does not look right.
> > Maybe it's an artifact of when we fall through with this patch, we bump
> > bi_phys_segments even if the segments are physicall contig and
> > mergeable.
> 
> yeah. it is messy, I tried to go for the least invasive changes.
> 
> I took the '>' test from the original while loop '>='. The original
> behavior guaranteed bio->bi_phys_segments <= max_segments, if the bio
> satisfied this condition to begin with.  I did not find any guarantees
> that the 'bio' parameter of this function has to satisfy this
> condition in general.
> 
> My understanding is that if a caller of this function (or one of the
> two that call this one) provides an invalid (segment-count-wise) bio,
> it will fail (return 0 added length), and let the caller handle the
> situation.  I admit, I did not check all the call paths that use these
> functions.

Yes, that is how it works. So that should be fine.

> > What happens when the segment is physically mergeable, but the resulting
> > merged segment is too large (bigger than q->limits.max_segment_size)?
> >
> 
> ah, yes. I guess I need a check that follows __blk_recalc_rq_segments
> more closely.  We know that at this point all pages are merged into
> segments, so a helper function that would be used by both
> __blk_recalc_rq_segments and this check is possible.
> 
> 
> I still assume that a temporary increase of bi_phys_segments above
> max_segments is ok.  If we want to avoid this situation we would need
> to merge tail pages right away. That's imo uglier.

Yes, it's OK if we just ensure that we clear the valid segment flag. At
least that would be the best sort of solution, to ensure that it's
recalculated properly when someone checks it.

-- 
Jens Axboe

