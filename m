Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6589B1917D7;
	Tue, 10 Sep 2024 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725984366; cv=none; b=GN+GLjW2BFShLxOKroItnQ46pSlyJYkCC6aeM3Xuj1YE3uxnV7ziAhBoVdBYGuRR6eH+GKLJ+BGxg3vXTkCMnSfkvZy6HZj8200VT29Mg8BgXS3vSkmk0uBlNKiuRjjzecRS+O6Wvim8t8ho6w8XP7WQPcJW7RP0Ci/y2Of8p2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725984366; c=relaxed/simple;
	bh=4ZbPlr+ijnXw+2VrkoF92h4BvdrZTgVjqAHEdVR1GBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5hG5tAJ+8D4YroUBX4+1SykcRTrG6BtL/O1uahsO2ooTZxvfVO/+lQTJuDgh1J9ZkFdym2rAiTwQ3cFBwcb6iDiQH7SUnlbwUs01dcnYOkZk+dsLoBGbLbhYGPQKbPUVOPyANw3ITV996odo15Uv5LopepmsTS5GWa93wTOqus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L7NSQc4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L7NSQc4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8A4C4CEC4;
	Tue, 10 Sep 2024 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725984366;
	bh=4ZbPlr+ijnXw+2VrkoF92h4BvdrZTgVjqAHEdVR1GBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L7NSQc4oJTB+s+nRW2AEwEJN7twPs4bVyJ7Nk8DbfY1y3RoNIpmBgJdaiWOyxjROI
	 TD8maMv+llxmdvkemUTn7MkFTt8TwZuWJlkmB0ibzfTYn8nkApiNL1G4O3ScmUqXiN
	 g2mOz0mdaHR81zKYb6BSNrC4xosV8pG+fgfmWV9eS7baCHAokYsDI/8BB5YP/K4cF6
	 ezRXOV7+/ewVs6Zus2zuBENZFxj3yoJ5wtcPp20JQNmrbqebnaPveeVBuW6wWGJwLa
	 2rIwSF/ggXghG7avXI2CfTg7/2zVLVU8mW/WE+WjALasJAjqy68OrQUzmQCnVfG8Cc
	 vz2eE95QriuOQ==
Date: Tue, 10 Sep 2024 10:06:03 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 06/10] blk-integrity: simplify counting segments
Message-ID: <ZuBua91J2X5Yt-72@kbusch-mbp>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-7-kbusch@meta.com>
 <20240910154105.GF23805@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910154105.GF23805@lst.de>

On Tue, Sep 10, 2024 at 05:41:05PM +0200, Christoph Hellwig wrote:
> On Wed, Sep 04, 2024 at 08:26:01AM -0700, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > The segments are already packed to the queue limits when adding them to
> > the bio,
> 
> I can't really parse this.  I guess this talks about
> bio_integrity_add_page trying to append the payload to the last
> vector when possible?

Exactly. bio_integrity_add_page will use the queue's limits to decide if
it can combine pages into one vector, so appending pages through that
interface will always result in the most compact bip vector.

This patch doesn't combine merged bio's but that's unlikely to have
mergable segments.
 
> > -int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
> > +int blk_rq_count_integrity_segs(struct bio *bio)
> >  {
> > -	struct bio_vec iv, ivprv = { NULL };
> >  	unsigned int segments = 0;
> > -	unsigned int seg_size = 0;
> > -	struct bvec_iter iter;
> > -	int prev = 0;
> > -
> > -	bio_for_each_integrity_vec(iv, bio, iter) {
> >  
> > -		if (prev) {
> > -			if (!biovec_phys_mergeable(q, &ivprv, &iv))
> > -				goto new_segment;
> > -			if (seg_size + iv.bv_len > queue_max_segment_size(q))
> > -				goto new_segment;
> > -
> > -			seg_size += iv.bv_len;
> > -		} else {
> > -new_segment:
> > -			segments++;
> > -			seg_size = iv.bv_len;
> 
> Q: for the data path the caller submitted bio_vecs can be larger
> than the max segment size, and given that the metadata API tries
> to follow that in general, I'd assume we could also get metadata
> segments larger than the segment size in theory, in which case
> we'd need to split a bvec into multiple segments, similar to what
> bvec_split_segs does.  Do we need similar handling for metadata?
> Or are we going to say that metadata must e.g. always be smaller
> than PAGE_SIZE as max_segment_sizse must be >= PAGE_SIZE?

The common use cases don't add integrity data until after the bio is
already split in __bio_split_to_limits(), and it won't be split again
after integrity is added via bio_integrity_prep(). The common path
always adds integrity in a single segment, so it's always valid.

There are just a few other users that set their own bio integrity before
submitting (the nvme and scsi target drivers), and I think both can
break from possible bio splitting, but I haven't been able to test
those. 
 
> > +	for_each_bio(bio)
> > +		segments += bio->bi_integrity->bip_vcnt;
> 
> If a bio was cloned bip_vcnt isn't the correct value here,
> we'll need to use the iter to count the segments.

Darn. The common use case doesn't have integrity added until just before
it's dispatched, so the integrity cloning doesn't normally happen for
that case.

Let's just drop patches 6 and 7 from consideration for now. They are a
bit too optimistic, and doesn't really fix anything anyway.
