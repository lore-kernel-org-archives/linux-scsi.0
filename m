Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018D3FC7
	for <linux-scsi@vger.kernel.org>; Thu,  9 Jan 2025 02:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736389126; cv=none; b=CiP855qGB6TcaGpoulHcZau+PnvyeG+gD0XWE46S6PkA/iiE+9A0sMhHjXGde7taDOqH019+OknCbKEARIuTKl/fKEBrutyVWn9Fxvo5MVRPUqPD3QSXAZLmBpUuj8iMLwv38077LCZ/pVTTSa9ymktj9VwisKbhEL3hq1qE7Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736389126; c=relaxed/simple;
	bh=blSjv22Y11SbJylCWcSMLd+PbMLZEcWCTOWjZ1C3fQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swM1BTcV4kjTeJRhrEFHbvyhD75TSNRwFwyIP+RlgzA8lchWg5gaxr6kJY9tu4adJiQA86Ai+rBPxxUogF8H3WV7VmHdUXmf+kIPl35jtmRfxbg2QN39ptQRb0BMtLOEIbeFKHKkFuekP+Du5/GZ2YBaHg+xsiWQyx1z4KVPUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=adsUcpSH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="adsUcpSH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736389123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NI/7sQZJsUB7MRKETVbNrqqCnlEl+xyWkxCJ71vt8Ik=;
	b=adsUcpSHylH5R+Q//ju75YPgYtvwVhcTB4eQfE+rOAbdlBEfEcIgN9VV1aKQyhykIpyY1O
	M4AI5iHf3kj7HEDCkC4oOWudbx2OvIfBPHvDk/uUnopLe83nWNRX9nQw87QenwV6xfDrvr
	LEBPnTFNQsGofintWtEXZ0L2hK+VbQQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-7FSoSldJMXm3ogIjfdzqow-1; Wed,
 08 Jan 2025 21:18:37 -0500
X-MC-Unique: 7FSoSldJMXm3ogIjfdzqow-1
X-Mimecast-MFC-AGG-ID: 7FSoSldJMXm3ogIjfdzqow
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3DF5195608B;
	Thu,  9 Jan 2025 02:18:34 +0000 (UTC)
Received: from fedora (unknown [10.72.116.23])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EB1419560AD;
	Thu,  9 Jan 2025 02:18:28 +0000 (UTC)
Date: Thu, 9 Jan 2025 10:18:22 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 03/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
Message-ID: <Z38x7mzrQPEiUOpv@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-4-hch@lst.de>
 <Z35T8xeLxhXe-zAS@fedora>
 <20250108152705.GA24792@lst.de>
 <a3bd231c-0568-4dad-9268-bc7edaace94b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3bd231c-0568-4dad-9268-bc7edaace94b@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Jan 09, 2025 at 09:05:49AM +0900, Damien Le Moal wrote:
> On 1/9/25 00:27, Christoph Hellwig wrote:
> > On Wed, Jan 08, 2025 at 06:31:15PM +0800, Ming Lei wrote:
> >>> -	if (!(q->limits.features & BLK_FEAT_POLL) &&
> >>> -			(bio->bi_opf & REQ_POLLED)) {
> >>> +	if ((bio->bi_opf & REQ_POLLED) && !bdev_can_poll(bdev)) {
> >>
> >> submit_bio_noacct() is called without grabbing .q_usage_counter,
> >> so tagset may be freed now, then use-after-free on q->tag_set?
> > 
> > Indeed.  That also means the previous check wasn't reliable either.
> > I think we can simple move the check into
> > blk_mq_submit_bio/__submit_bio which means we'll do a bunch more
> > checks before we eventually fail, but otherwise it'll work the
> > same.
> 
> Given that the request queue is the same for all tag sets, I do not think we

No, it isn't same.

> need to have the queue_limits_start_update()/commit_update() within the tag set
> loop in __blk_mq_update_nr_hw_queues(). So something like this should be enough
> for an initial fix, no ?
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 8ac19d4ae3c0..ac71e9cee25b 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -4986,6 +4986,7 @@ static void __blk_mq_update_nr_hw_queues(struct
> blk_mq_tag_set *set,
>                                                         int nr_hw_queues)
>  {
>         struct request_queue *q;
> +       struct queue_limits lim;
>         LIST_HEAD(head);
>         int prev_nr_hw_queues = set->nr_hw_queues;
>         int i;
> @@ -4999,8 +5000,10 @@ static void __blk_mq_update_nr_hw_queues(struct
> blk_mq_tag_set *set,
>         if (set->nr_maps == 1 && nr_hw_queues == set->nr_hw_queues)
>                 return;
> 
> +       lim = queue_limits_start_update(q);
>         list_for_each_entry(q, &set->tag_list, tag_set_list)
>                 blk_mq_freeze_queue(q);

It could be worse, since the limits_lock is connected with lots of other
subsystem's lock(debugfs, sysfs dir, ...), it may introduce new deadlock
risk.

Thanks,
Ming

