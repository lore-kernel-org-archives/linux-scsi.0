Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDFE17C9E8
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jan 2025 07:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736234775; cv=none; b=s4Us5Dt5xsWWA59CQi37lRejwDtrZg7yeQ+cY9rjcclpp+i41lqcNv+cng1Pp1m1DVJ6pw2uITyfg3U8+X4e5ud8K8ZkZKmNXUv6fpph+CrpA+8Oys1c6M0549/H1ZicDr7nHVjZAz3nWI0TcE67KSEAjWH+FAoujJiJfFEGbeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736234775; c=relaxed/simple;
	bh=0rjaLMvrt9c6yUNrnDaoE5cP4gz6KMuAgrdj9N7AigA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PHlLK4njF196gUAX2dZEmiFFamfmgDcODI97RxoBvm7neqNl00aUY6oYrUfuYD/hv0bZlxzu6WlhozWgwFmKxzHLm+Kvkj6S+H343yqysH6WA4jhEimpN9Gllc7LS+zuGig3BvyNMTUM9Ftku3YDh/Ulqflsfg3yZ0FqOiHXX04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PYceXJEJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYceXJEJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736234768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UOvyykKvJvcd0j86+e+g5Cu3cDJgu/cjQCFZGvsexYo=;
	b=PYceXJEJsoQ0wXeW6bssdejk/Fz8w1n0p+65q2eNyN4th9BVFUG6IZ26OxULGxmLPk3Pa5
	Np39hZen62Kp6ac/WdhrXs2KShv+5ltbiZFEEyNaMlPVlTTgd4MRiGJXsWr8s5I6SGXvmD
	uYcd8ylvkRUIdbKz7LcqrrhQmqUm6nU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-6-mNkTtYXLOMy42irdAbcchw-1; Tue,
 07 Jan 2025 02:26:07 -0500
X-MC-Unique: mNkTtYXLOMy42irdAbcchw-1
X-Mimecast-MFC-AGG-ID: mNkTtYXLOMy42irdAbcchw
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDDA21956056;
	Tue,  7 Jan 2025 07:26:04 +0000 (UTC)
Received: from fedora (unknown [10.72.116.128])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6989C3000197;
	Tue,  7 Jan 2025 07:25:56 +0000 (UTC)
Date: Tue, 7 Jan 2025 15:25:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 4/8] block: add a store_limit operations for sysfs entries
Message-ID: <Z3zXANbFk6GBZg_z@fedora>
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107063120.1011593-5-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Jan 07, 2025 at 07:30:36AM +0100, Christoph Hellwig wrote:
> De-duplicate the code for updating queue limits by adding a store_limit
> method that allows having common code handle the actual queue limits
> update.
> 
> Note that this is a pure refactoring patch and does not address the
> existing freeze vs limits lock order problem in the refactored code,
> which will be addressed next.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-sysfs.c | 128 ++++++++++++++++++++++------------------------
>  1 file changed, 61 insertions(+), 67 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 767598e719ab..8d69315e986d 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -24,6 +24,8 @@ struct queue_sysfs_entry {
>  	struct attribute attr;
>  	ssize_t (*show)(struct gendisk *disk, char *page);
>  	ssize_t (*store)(struct gendisk *disk, const char *page, size_t count);
> +	int (*store_limit)(struct gendisk *disk, const char *page,
> +			size_t count, struct queue_limits *lim);
>  	void (*load_module)(struct gendisk *disk, const char *page, size_t count);
>  };
>  
> @@ -153,13 +155,11 @@ QUEUE_SYSFS_SHOW_CONST(discard_zeroes_data, 0)
>  QUEUE_SYSFS_SHOW_CONST(write_same_max, 0)
>  QUEUE_SYSFS_SHOW_CONST(poll_delay, -1)
>  
> -static ssize_t queue_max_discard_sectors_store(struct gendisk *disk,
> -		const char *page, size_t count)
> +static int queue_max_discard_sectors_store(struct gendisk *disk,
> +		const char *page, size_t count, struct queue_limits *lim)
>  {
>  	unsigned long max_discard_bytes;
> -	struct queue_limits lim;
>  	ssize_t ret;
> -	int err;
>  
>  	ret = queue_var_store(&max_discard_bytes, page, count);
>  	if (ret < 0)
> @@ -171,38 +171,28 @@ static ssize_t queue_max_discard_sectors_store(struct gendisk *disk,
>  	if ((max_discard_bytes >> SECTOR_SHIFT) > UINT_MAX)
>  		return -EINVAL;
>  
> -	lim = queue_limits_start_update(disk->queue);
> -	lim.max_user_discard_sectors = max_discard_bytes >> SECTOR_SHIFT;
> -	err = queue_limits_commit_update(disk->queue, &lim);
> -	if (err)
> -		return err;
> -	return ret;
> +	lim->max_user_discard_sectors = max_discard_bytes >> SECTOR_SHIFT;
> +	return 0;
>  }
>  
> -static ssize_t
> -queue_max_sectors_store(struct gendisk *disk, const char *page, size_t count)
> +static int
> +queue_max_sectors_store(struct gendisk *disk, const char *page, size_t count,
> +		struct queue_limits *lim)
>  {
>  	unsigned long max_sectors_kb;
> -	struct queue_limits lim;
>  	ssize_t ret;
> -	int err;
>  
>  	ret = queue_var_store(&max_sectors_kb, page, count);
>  	if (ret < 0)
>  		return ret;
>  
> -	lim = queue_limits_start_update(disk->queue);
> -	lim.max_user_sectors = max_sectors_kb << 1;
> -	err = queue_limits_commit_update(disk->queue, &lim);
> -	if (err)
> -		return err;
> -	return ret;
> +	lim->max_user_sectors = max_sectors_kb << 1;
> +	return 0;
>  }
>  
>  static ssize_t queue_feature_store(struct gendisk *disk, const char *page,
> -		size_t count, blk_features_t feature)
> +		size_t count, struct queue_limits *lim, blk_features_t feature)
>  {
> -	struct queue_limits lim;
>  	unsigned long val;
>  	ssize_t ret;
>  
> @@ -210,15 +200,11 @@ static ssize_t queue_feature_store(struct gendisk *disk, const char *page,
>  	if (ret < 0)
>  		return ret;
>  
> -	lim = queue_limits_start_update(disk->queue);
>  	if (val)
> -		lim.features |= feature;
> +		lim->features |= feature;
>  	else
> -		lim.features &= ~feature;
> -	ret = queue_limits_commit_update(disk->queue, &lim);
> -	if (ret)
> -		return ret;
> -	return count;
> +		lim->features &= ~feature;
> +	return 0;
>  }
>  
>  #define QUEUE_SYSFS_FEATURE(_name, _feature)				\
> @@ -227,10 +213,10 @@ static ssize_t queue_##_name##_show(struct gendisk *disk, char *page)	\
>  	return sysfs_emit(page, "%u\n",					\
>  		!!(disk->queue->limits.features & _feature));		\
>  }									\
> -static ssize_t queue_##_name##_store(struct gendisk *disk,		\
> -		const char *page, size_t count)				\
> +static int queue_##_name##_store(struct gendisk *disk,			\
> +		const char *page, size_t count, struct queue_limits *lim) \
>  {									\
> -	return queue_feature_store(disk, page, count, _feature);	\
> +	return queue_feature_store(disk, page, count, lim, _feature);	\
>  }
>  
>  QUEUE_SYSFS_FEATURE(rotational, BLK_FEAT_ROTATIONAL)
> @@ -266,10 +252,9 @@ static ssize_t queue_iostats_passthrough_show(struct gendisk *disk, char *page)
>  	return queue_var_show(!!blk_queue_passthrough_stat(disk->queue), page);
>  }
>  
> -static ssize_t queue_iostats_passthrough_store(struct gendisk *disk,
> -					       const char *page, size_t count)
> +static int queue_iostats_passthrough_store(struct gendisk *disk,
> +		const char *page, size_t count, struct queue_limits *lim)
>  {
> -	struct queue_limits lim;
>  	unsigned long ios;
>  	ssize_t ret;
>  
> @@ -277,18 +262,13 @@ static ssize_t queue_iostats_passthrough_store(struct gendisk *disk,
>  	if (ret < 0)
>  		return ret;
>  
> -	lim = queue_limits_start_update(disk->queue);
>  	if (ios)
> -		lim.flags |= BLK_FLAG_IOSTATS_PASSTHROUGH;
> +		lim->flags |= BLK_FLAG_IOSTATS_PASSTHROUGH;
>  	else
> -		lim.flags &= ~BLK_FLAG_IOSTATS_PASSTHROUGH;
> -
> -	ret = queue_limits_commit_update(disk->queue, &lim);
> -	if (ret)
> -		return ret;
> -
> -	return count;
> +		lim->flags &= ~BLK_FLAG_IOSTATS_PASSTHROUGH;
> +	return 0;
>  }
> +
>  static ssize_t queue_nomerges_show(struct gendisk *disk, char *page)
>  {
>  	return queue_var_show((blk_queue_nomerges(disk->queue) << 1) |
> @@ -391,12 +371,10 @@ static ssize_t queue_wc_show(struct gendisk *disk, char *page)
>  	return sysfs_emit(page, "write through\n");
>  }
>  
> -static ssize_t queue_wc_store(struct gendisk *disk, const char *page,
> -			      size_t count)
> +static int queue_wc_store(struct gendisk *disk, const char *page,
> +		size_t count, struct queue_limits *lim)
>  {
> -	struct queue_limits lim;
>  	bool disable;
> -	int err;
>  
>  	if (!strncmp(page, "write back", 10)) {
>  		disable = false;
> @@ -407,15 +385,11 @@ static ssize_t queue_wc_store(struct gendisk *disk, const char *page,
>  		return -EINVAL;
>  	}
>  
> -	lim = queue_limits_start_update(disk->queue);
>  	if (disable)
> -		lim.flags |= BLK_FLAG_WRITE_CACHE_DISABLED;
> +		lim->flags |= BLK_FLAG_WRITE_CACHE_DISABLED;
>  	else
> -		lim.flags &= ~BLK_FLAG_WRITE_CACHE_DISABLED;
> -	err = queue_limits_commit_update(disk->queue, &lim);
> -	if (err)
> -		return err;
> -	return count;
> +		lim->flags &= ~BLK_FLAG_WRITE_CACHE_DISABLED;
> +	return 0;
>  }
>  
>  #define QUEUE_RO_ENTRY(_prefix, _name)			\
> @@ -431,6 +405,13 @@ static struct queue_sysfs_entry _prefix##_entry = {	\
>  	.store	= _prefix##_store,			\
>  };
>  
> +#define QUEUE_LIM_RW_ENTRY(_prefix, _name)			\
> +static struct queue_sysfs_entry _prefix##_entry = {	\
> +	.attr		= { .name = _name, .mode = 0644 },	\
> +	.show		= _prefix##_show,			\
> +	.store_limit	= _prefix##_store,			\
> +}
> +
>  #define QUEUE_RW_LOAD_MODULE_ENTRY(_prefix, _name)		\
>  static struct queue_sysfs_entry _prefix##_entry = {		\
>  	.attr		= { .name = _name, .mode = 0644 },	\
> @@ -441,7 +422,7 @@ static struct queue_sysfs_entry _prefix##_entry = {		\
>  
>  QUEUE_RW_ENTRY(queue_requests, "nr_requests");
>  QUEUE_RW_ENTRY(queue_ra, "read_ahead_kb");
> -QUEUE_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
> +QUEUE_LIM_RW_ENTRY(queue_max_sectors, "max_sectors_kb");
>  QUEUE_RO_ENTRY(queue_max_hw_sectors, "max_hw_sectors_kb");
>  QUEUE_RO_ENTRY(queue_max_segments, "max_segments");
>  QUEUE_RO_ENTRY(queue_max_integrity_segments, "max_integrity_segments");
> @@ -457,7 +438,7 @@ QUEUE_RO_ENTRY(queue_io_opt, "optimal_io_size");
>  QUEUE_RO_ENTRY(queue_max_discard_segments, "max_discard_segments");
>  QUEUE_RO_ENTRY(queue_discard_granularity, "discard_granularity");
>  QUEUE_RO_ENTRY(queue_max_hw_discard_sectors, "discard_max_hw_bytes");
> -QUEUE_RW_ENTRY(queue_max_discard_sectors, "discard_max_bytes");
> +QUEUE_LIM_RW_ENTRY(queue_max_discard_sectors, "discard_max_bytes");
>  QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
>  
>  QUEUE_RO_ENTRY(queue_atomic_write_max_sectors, "atomic_write_max_bytes");
> @@ -477,11 +458,11 @@ QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
>  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
>  
>  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
> -QUEUE_RW_ENTRY(queue_iostats_passthrough, "iostats_passthrough");
> +QUEUE_LIM_RW_ENTRY(queue_iostats_passthrough, "iostats_passthrough");
>  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
>  QUEUE_RW_ENTRY(queue_poll, "io_poll");
>  QUEUE_RW_ENTRY(queue_poll_delay, "io_poll_delay");
> -QUEUE_RW_ENTRY(queue_wc, "write_cache");
> +QUEUE_LIM_RW_ENTRY(queue_wc, "write_cache");
>  QUEUE_RO_ENTRY(queue_fua, "fua");
>  QUEUE_RO_ENTRY(queue_dax, "dax");
>  QUEUE_RW_ENTRY(queue_io_timeout, "io_timeout");
> @@ -494,10 +475,10 @@ static struct queue_sysfs_entry queue_hw_sector_size_entry = {
>  	.show = queue_logical_block_size_show,
>  };
>  
> -QUEUE_RW_ENTRY(queue_rotational, "rotational");
> -QUEUE_RW_ENTRY(queue_iostats, "iostats");
> -QUEUE_RW_ENTRY(queue_add_random, "add_random");
> -QUEUE_RW_ENTRY(queue_stable_writes, "stable_writes");
> +QUEUE_LIM_RW_ENTRY(queue_rotational, "rotational");
> +QUEUE_LIM_RW_ENTRY(queue_iostats, "iostats");
> +QUEUE_LIM_RW_ENTRY(queue_add_random, "add_random");
> +QUEUE_LIM_RW_ENTRY(queue_stable_writes, "stable_writes");
>  
>  #ifdef CONFIG_BLK_WBT
>  static ssize_t queue_var_store64(s64 *var, const char *page)
> @@ -695,7 +676,7 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
>  	struct request_queue *q = disk->queue;
>  	ssize_t res;
>  
> -	if (!entry->store)
> +	if (!entry->store_limit && !entry->store)
>  		return -EIO;
>  
>  	/*
> @@ -706,11 +687,24 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
>  	if (entry->load_module)
>  		entry->load_module(disk, page, length);
>  
> -	blk_mq_freeze_queue(q);
>  	mutex_lock(&q->sysfs_lock);
> -	res = entry->store(disk, page, length);
> -	mutex_unlock(&q->sysfs_lock);
> +	blk_mq_freeze_queue(q);

Order between freeze and ->sysfs_lock is changed, and it may cause new
lockdep warning because we may freeze queue first before acquiring
->sysfs_lock in del_gendisk().


thanks,
Ming

