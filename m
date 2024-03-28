Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170512C19B;
	Thu, 28 Mar 2024 05:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711604534; cv=none; b=CFUqt6dmWTUM7Vg0aQX/oCpS6rUtOQD529Fy3wxjHSDevFQf2x1ixhKh7l5oFmTRge1eAKH+MujEhLWk1MorScyWpOnUGtYHGvZD9rx464qjdUImYRzc6yGKP8Bm3D+cB1MV3xfvYnxmEWrSHnR1N1hiw4r0bIXqFoYM2AtnQJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711604534; c=relaxed/simple;
	bh=k2cSEOBe3yuzA976u7J2e9fV+f5c49dxaQ5ooEfLtWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=urKcBAZIGZKsf9iwH+axAwexTJ5bt7om2ZCRcIAB/cNc664BZkmS0N+oFS019b3oQBvw0WOc0XL1XZDGYCPP1izZJOsTnwhwWoUj4U06qkDQqQbM6JG8tYA1Shujnr+Ry3hjaqpX7q+q/zQGMH0iaxG+uxd+fUEd41mXq6lfYvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE17D68B05; Thu, 28 Mar 2024 06:42:08 +0100 (CET)
Date: Thu, 28 Mar 2024 06:42:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
Message-ID: <20240328054208.GA16087@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-5-dlemoal@kernel.org> <20240328041457.GC13510@lst.de> <86114cba-535b-41e9-9b85-bac2fbdc1ed3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86114cba-535b-41e9-9b85-bac2fbdc1ed3@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 02:20:17PM +0900, Damien Le Moal wrote:
> I do not think that is corect. Because is_flush indicates that RQF_FLUSH_SEQ is
> set, that is, we are in the middle of a flush sequence. And flush sequence
> progression is handled at the request level, not BIOs. Once the sequence
> finishes, then and only then the BIO original endio should be done, meaning that
> we will then take this path and actually do blk_zone_update_request_bio() and
> bio_endio(). So I still think this is correct.

Well.

lk_flush_restore_request with the previous patch now restores rq->__sector,
and the blk_mq_end_request call following it will propagate it to the
original bio.  But blk_flush_restore_request grabs the sector from
rq->bio->bi_iter.bi_sector, and we need to actually get it there first,
which is done by the data I/O completion that has RQF_FLUSH_SEQ set.

I think we really need a good test case for zone append and FUA,
i.e. we need the append op for zonefs, which should exercise the
fua code if O_SYNC/O_DSYNC is set.

