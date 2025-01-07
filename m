Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B889C13B58F;
	Tue,  7 Jan 2025 08:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736238192; cv=none; b=stt9Tqf17HdOkCbTVDYUdkikzeFk+RnZtUB1bLCuWPZAWGaBZFnpO0Ri0q1CPls3hMtTkKK8FerdJShd4Mwl/nQj+HvF8xaJmN0eyj5Rx/nUWQi5kzdPxhe22y6fCcjYF/w5s1VppLPd8a5R6BBF3JoBRw8ixgDfD1gsuFjG2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736238192; c=relaxed/simple;
	bh=DKVUPuzooLeO+nCjVHlF9LWeGK2PJMbHt+80iu8TUks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5GW0WzvHeZdAsq9DRt156Lfkgom7F6JpD3r4K6i7xuM1+5Zgr/1mqs74ZLbTCIxJNkqwA3A/TAyi/eBzEsdH/6KImhQcMMFC/Wlf3jVHgnxXkTkLHTtg5lJz2gRR9e1pYzNI65X+GSWwt4tUg52QyvB3P69OOv54LXrS90w5+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1282468AFE; Tue,  7 Jan 2025 09:23:07 +0100 (CET)
Date: Tue, 7 Jan 2025 09:23:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 4/8] block: add a store_limit operations for sysfs
 entries
Message-ID: <20250107082306.GC15960@lst.de>
References: <20250107063120.1011593-1-hch@lst.de> <20250107063120.1011593-5-hch@lst.de> <Z3zXANbFk6GBZg_z@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3zXANbFk6GBZg_z@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

Hi Ming,

this is a friendly reminder to reply without quoting the entire mail.
I did not find any content after scrolling half a dozend page of
full quote and gave up.

> > +	.attr		= { .name = _name, .mode = 0644 },	\
> > +	.show		= _prefix##_show,			\
> > +	.store_limit	= _prefix##_store,			\
> > +}
> > +
> >  #define QUEUE_RW_LOAD_MODULE_ENTRY(_prefix, _name)		\
> >  static struct queue_sysfs_entry _prefix##_entry = {		\
> >  	.attr		= { .name = _name, .mode = 0644 },	\
> > @@ -441,7 +422,7 @@ static struct queue_sysfs_entry _prefix##_entry = {		\
> >  
> >  QUEUE_RW_ENTRY(queue_requests, "nr_requests");
> >  QUEUE_RW_ENTRY(queue_ra, "read_ahead_kb");
> > -QUEUE_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
> > +QUEUE_LIM_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
> >  QUEUE_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_kb");
> >  QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
> >  QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
> > @@ -457,7 +438,7 @@ QUEUE_RO_ENTRY(queue_io_opt, "optimal_io_size");
> >  QUEUE_RO_ENTRY(queue_max_discard_segments, "max_discard_segments");
> >  QUEUE_RO_ENTRY(queue_discard_granularity, "discard_granularity");
> >  QUEUE_RO_ENTRY(queue_max_hw_discard_sectors, "discard_max_hw_bytes");
> > -QUEUE_RW_ENTRY(queue_max_discard_sectors, "discard_max_bytes");
> > +QUEUE_LIM_RW_ENTRY(queue_max_discard_sectors, "discard_max_bytes");
> >  QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
> >  
> >  QUEUE_RO_ENTRY(queue_atomic_write_max_sectors, "atomic_write_max_bytes");
> > @@ -477,11 +458,11 @@ QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
> >  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
> >  
> >  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
> > -QUEUE_RW_ENTRY(queue_iostats_passthrough, "iostats_passthrough");
> > +QUEUE_LIM_RW_ENTRY(queue_iostats_passthrough, "iostats_passthrough");
> >  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
> >  QUEUE_RW_ENTRY(queue_poll, "io_poll");
> >  QUEUE_RW_ENTRY(queue_poll_delay, "io_poll_delay");
> > -QUEUE_RW_ENTRY(queue_wc, "write_cache");
> > +QUEUE_LIM_RW_ENTRY(queue_wc, "write_cache");
> >  QUEUE_RO_ENTRY(queue_fua, "fua");
> >  QUEUE_RO_ENTRY(queue_dax, "dax");
> >  QUEUE_RW_ENTRY(queue_io_timeout, "io_timeout");
> > @@ -494,10 +475,10 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
> >  	.show = queue_logical_block_size_show,
> >  };
> >  
> > -QUEUE_RW_ENTRY(queue_rotational, "rotational");
> > -QUEUE_RW_ENTRY(queue_iostats, "iostats");
> > -QUEUE_RW_ENTRY(queue_add_random, "add_random");
> > -QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
> > +QUEUE_LIM_RW_ENTRY(queue_rotational, "rotational");
> > +QUEUE_LIM_RW_ENTRY(queue_iostats, "iostats");
> > +QUEUE_LIM_RW_ENTRY(queue_add_random, "add_random");
> > +QUEUE_LIM_RW_ENTRY(queue_stable_writes, "stable_writes");
> >  
> >  #ifdef CONFIG_BLK_WBT
> >  static ssize_t queue_var_store64(s64 *var, const char *page)
> > @@ -695,7 +676,7 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
> >  	struct request_queue *q = disk->queue;
> >  	ssize_t res;
> >  
> > -	if (!entry->store)
> > +	if (!entry->store_limit && !entry->store)
> >  		return -EIO;
> >  
> >  	/*
> > @@ -706,11 +687,24 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
> >  	if (entry->load_module)
> >  		entry->load_module(disk, page, length);
> >  
> > -	blk_mq_freeze_queue(q);
> >  	mutex_lock(&q->sysfs_lock);
> > -	res = entry->store(disk, page, length);
> > -	mutex_unlock(&q->sysfs_lock);
> > +	blk_mq_freeze_queue(q);
> 
> Order between freeze and ->sysfs_lock is changed, and it may cause new
> lockdep warning because we may freeze queue first before acquiring
> ->sysfs_lock in del_gendisk().
> 
> 
> thanks,
> Ming
---end quoted text---
