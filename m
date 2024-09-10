Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DB919ABCE;
	Tue, 10 Sep 2024 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725982872; cv=none; b=uJEUC5xT45poxZzRUzYV3lUvpf7U4KsTq8XykEfEFuplqf4m8ZJAkfDodmBPOdmV+a1ioBYZUMkpORmNjtOZUkYEk7KIx/GTdkJQA4xmfPsF2k8AWzAVf9IN00q1RUF0uCuRZwRtBhUFUXgfxgCWT5rMOVNrh2t/7wdNoLzrCb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725982872; c=relaxed/simple;
	bh=jdQ/Yd+SWrlrKbKdNpwCVLNgsgV1xybj3fj2HTKMVok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+UYhZxTXYEdBTU4rPKdx5NGn02pJvs/OJhdQggeInpzuI10n6923BUbFS5+B/5vcGbgyUTycX9o/nscSJu+5ziJH/yeiXFvEUqRjcdlfDpESArAv+y/+Ak/Ug6gBR0gePXZub7/9x95UsUmZc6Wd8QqvhyfidZR1L0dvqwoRlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3E429227AAE; Tue, 10 Sep 2024 17:41:06 +0200 (CEST)
Date: Tue, 10 Sep 2024 17:41:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 06/10] blk-integrity: simplify counting segments
Message-ID: <20240910154105.GF23805@lst.de>
References: <20240904152605.4055570-1-kbusch@meta.com> <20240904152605.4055570-7-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240904152605.4055570-7-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 04, 2024 at 08:26:01AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The segments are already packed to the queue limits when adding them to
> the bio,

I can't really parse this.  I guess this talks about
bio_integrity_add_page trying to append the payload to the last
vector when possible?

> -int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
> +int blk_rq_count_integrity_segs(struct bio *bio)
>  {
> -	struct bio_vec iv, ivprv = { NULL };
>  	unsigned int segments = 0;
> -	unsigned int seg_size = 0;
> -	struct bvec_iter iter;
> -	int prev = 0;
> -
> -	bio_for_each_integrity_vec(iv, bio, iter) {
>  
> -		if (prev) {
> -			if (!biovec_phys_mergeable(q, &ivprv, &iv))
> -				goto new_segment;
> -			if (seg_size + iv.bv_len > queue_max_segment_size(q))
> -				goto new_segment;
> -
> -			seg_size += iv.bv_len;
> -		} else {
> -new_segment:
> -			segments++;
> -			seg_size = iv.bv_len;

Q: for the data path the caller submitted bio_vecs can be larger
than the max segment size, and given that the metadata API tries
to follow that in general, I'd assume we could also get metadata
segments larger than the segment size in theory, in which case
we'd need to split a bvec into multiple segments, similar to what
bvec_split_segs does.  Do we need similar handling for metadata?
Or are we going to say that metadata must e.g. always be smaller
than PAGE_SIZE as max_segment_sizse must be >= PAGE_SIZE?

> +	for_each_bio(bio)
> +		segments += bio->bi_integrity->bip_vcnt;

If a bio was cloned bip_vcnt isn't the correct value here,
we'll need to use the iter to count the segments.

>  	bio->bi_next = NULL;
> -	nr_integrity_segs = blk_rq_count_integrity_sg(q, bio);
> +	nr_integrity_segs = blk_rq_count_integrity_segs(bio);
>  	bio->bi_next = next;

And instead of playing the magic with the bio chain here, I'd have
a low-level helper to count the bio segments here.

>  
>  	if (req->nr_integrity_segments + nr_integrity_segs >
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3ed5181c75610..79cc66275f1cd 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2548,7 +2548,7 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
>  	blk_rq_bio_prep(rq, bio, nr_segs);
>  #if defined(CONFIG_BLK_DEV_INTEGRITY)
>  	if (bio->bi_opf & REQ_INTEGRITY)
> -		rq->nr_integrity_segments = blk_rq_count_integrity_sg(rq->q, bio);
> +		rq->nr_integrity_segments = blk_rq_count_integrity_segs(bio);

And here I'm actually pretty sure this is always a single bio and not
a chain either.

