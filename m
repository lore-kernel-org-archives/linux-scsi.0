From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: modify __bio_add_page check to accept pages that
 don't start a new segment
Date: Mon, 25 Mar 2013 07:31:13 -0600
Message-ID: <20130325133113.GB5401@kernel.dk>
References: <5125DB22.7020901@redhat.com>
 <513878A1.3020701@redhat.com>
 <51504C96.8040002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51504C96.8040002@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Vesely <jvesely@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, James Bottomley <james.bottomley@hansenpartnership.com>, Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, fujita.tomonori@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 25 2013, Jan Vesely wrote:
> On Thu 07 Mar 2013 12:23:13 CET, Jan Vesely wrote:
> 
> > On Thu 21 Feb 2013 09:30:26 CET, Jan Vesely wrote:
> >> The original behavior was to refuse all pages after the maximum number of
> >> segments has been reached. However, some drivers (like st) craft their buffers
> >> to potentially require exactly max segments and multiple pages in the last
> >> segment. This patch modifies the check to allow pages that can be merged into
> >> the last segment.
> >>
> >> This change fixes EBUSY failures when using large (1mb) tape block size in high
> >> memory fragmentation condition.
> >>
> >> Signed-off-by: Jan Vesely <jvesely@redhat.com>
> >> ---
> >>  fs/bio.c |   26 ++++++++++++++++----------
> >>  1 files changed, 16 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/bio.c b/fs/bio.c
> >> index b96fc6c..02efbd5 100644
> >> --- a/fs/bio.c
> >> +++ b/fs/bio.c
> >> @@ -500,7 +500,6 @@ static int __bio_add_page(struct request_queue *q, struct
> >> bio *bio, struct page
> >>                *page, unsigned int len, unsigned int offset,
> >>                unsigned short max_sectors)
> >>  {
> >> -    int retried_segments = 0;
> >>      struct bio_vec *bvec;
> >>
> >>      /*
> >> @@ -551,18 +550,12 @@ static int __bio_add_page(struct request_queue *q,
> >> struct bio *bio, struct page
> >>          return 0;
> >>
> >>      /*
> >> -     * we might lose a segment or two here, but rather that than
> >> -     * make this too complex.
> >> +     * prepare segment count check, reduce segment count if possible
> >>       */
> >>
> >> -    while (bio->bi_phys_segments >= queue_max_segments(q)) {
> >> -
> >> -        if (retried_segments)
> >> -            return 0;
> >> -
> >> -        retried_segments = 1;
> >> +    if (bio->bi_phys_segments >= queue_max_segments(q))
> >>          blk_recount_segments(q, bio);
> >> -    }
> >> +
> >>
> >>      /*
> >>       * setup the new entry, we might clear it again later if we
> >> @@ -572,6 +565,19 @@ static int __bio_add_page(struct request_queue *q, struct
> >> bio *bio, struct page
> >>      bvec->bv_page = page;
> >>      bvec->bv_len = len;
> >>      bvec->bv_offset = offset;
> >> +
> >> +    /*
> >> +     * the other part of the segment count check, allow mergeable pages
> >> +     */
> >> +    if ((bio->bi_phys_segments > queue_max_segments(q)) ||
> >> +        ( (bio->bi_phys_segments == queue_max_segments(q)) &&
> >> +        !BIOVEC_PHYS_MERGEABLE(bvec - 1, bvec))) {
> >> +            bvec->bv_page = NULL;
> >> +            bvec->bv_len = 0;
> >> +            bvec->bv_offset = 0;
> >> +            return 0;
> >> +    }
> >> +
> >>
> >>      /*
> >>       * if queue has other restrictions (eg varying max sector size
> 
> ping?
> 
> The described failure is a regression introduced in
>     46081b166415acb66d4b3150ecefcd9460bb48a1
>     st: Increase success probability in driver buffer allocation
> 
> I have added the signers to cc. I can resend the patch if it is 
> necessary

Can you resend the patch? The above is mangled for me.

-- 
Jens Axboe
