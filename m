Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958F5186E58;
	Thu, 12 Sep 2024 07:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126932; cv=none; b=bUh50Vgpv7mjyYwGDtOscTMBvsY4rS85f+H8AekdL2szinx6eIyQKto7HeqPTKaZUMNjuaoe6DNTLXriX8fAN8oKfel1Gepg4HlbXKDOFCJwYwwZyDEp4HkVpS4UOF3EUhEKcwZIRm9buyHUHO43G5IScNQzeyhKkqvqPNsQEMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126932; c=relaxed/simple;
	bh=4/J+Rl88nq1mTb6agyzPTRiwOYCG7Jr3GpY/6/uABgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBfIFiR+1XCvsGc3Hit3N+3NsqYdSxBcRi6pQhqJzr6D2DPZt2g0LZUBRxb6BMs6u3QSOzQzpHr1ttgYVp5R5Ryi1tuuLvPlFez+UNOZ09gLq49Ph3ud2F2NpIBnlqDbLyFfvrPVInj3Ji52URWUI/TXcgR0UBvfN8rQfRUo/+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45A16227AAF; Thu, 12 Sep 2024 09:42:06 +0200 (CEST)
Date: Thu, 12 Sep 2024 09:42:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, sagi@grimberg.me,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 04/10] blk-integrity: consider entire bio list for
 merging
Message-ID: <20240912074205.GA8202@lst.de>
References: <20240911201240.3982856-1-kbusch@meta.com> <20240911201240.3982856-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911201240.3982856-5-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 11, 2024 at 01:12:34PM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> If a bio is merged to a request, the entire bio list is merged, so don't
> temporarily detach it from its list when counting segments. In most
> cases, bi_next will already be NULL, so detaching is usually a no-op.
> But if the bio does have a list, the current code is miscounting the
> segments for the resulting merge.

As far as I can tell we can never get here with bi_next set.  Rationale:

blk_integrity_merge_bio has two callers: ll_new_hw_segment and
blk_rq_merge_ok.

ll_new_hw_segment is called from ll_back_merge_fn and ll_front_merge_fn.

ll_back_merge_fn is called from blk_rq_append_bio and
bio_attempt_back_merge.

blk_rq_append_bio is always used for a single bio and in fact used
to build bio chains.

bio_attempt_back_merge is called from blk_attempt_bio_merge,
blk_mq_sched_try_merge and blk_zone_write_plug_init_request.

blk_attempt_bio_merge is called from blk_attempt_plug_merge and
blk_bio_list_merge.

blk_attempt_plug_merge is called from blk_mq_attempt_bio_merge,
which always operates on a single bio.

blk_bio_list_merge is called from blk_mq_sched_bio_merge,
kyber_bio_merge where the latter is just an indirect call from
the former, and blk_mq_sched_bio_merge is called from
blk_mq_attempt_bio_merge which was considered above.

blk_mq_sched_try_merge is called from bfq_bio_merge and dd_bio_merge,
both of which are implementation of the ->bio_merge elevator_mq_ops
method called from blk_mq_sched_bio_merge, which was considered above.

blk_zone_write_plug_init_request is called from blk_mq_submit_bio
and always operates on a single bio.

ll_front_merge_fn is called from bio_attempt_front_merge.

bio_attempt_front_merge is called from blk_attempt_bio_merge and
blk_mq_sched_try_merge, both of which were considered above.

blk_rq_merge_ok is called from blk_attempt_bio_merge,
blk_zone_write_plug_init_request and elv_bio_merge_ok.

blk_attempt_bio_merge and blk_zone_write_plug_init_request were
already considered above.

elv_bio_merge_ok is called from bfq_request_merge and dd_request_merge
and elv_merge.  The first two are implementations of the ->request_merge
elevator_mq_ops method called from elv_merge, which is called from
blk_mq_sched_try_merge, which was considered above.

Also it feels like the call in blk_rq_merge_ok is superflous from this.

