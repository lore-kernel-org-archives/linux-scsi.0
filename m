Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3946F533;
	Mon, 25 Mar 2024 21:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711403608; cv=none; b=Z20SsXQ+MAlh9VSyM4e7tcpnxcRpB2aOihtPyi0SWqr5A0oFJzyPArj2R/+HXTd+byaPefnHIMVNwEbEQt6x8oc4bRXjcJoT8d9ksiWFsVsgG7lrdouNJPrsumfxr2y7Sm7EhpQJqtBY/89mBvcQZXkFA/eD4V/llXDS1ntOD6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711403608; c=relaxed/simple;
	bh=eTPbed+VAYNOADDv3q7YeouOmFcTvGCdg5bGQqGV6+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PSVPg7di1ts2xZl7SXMr1MCHB3IPK/+HP7ESOXFLaGMDQO9I3Hig2wdcrgCnne5QF55d4vbRzjtcY7YFevs6+dudyDnPgMUbuFHJ+g4i175Q600/IXznVzbGKBb/zTbnn4HL14rD/SdH0bqnzgAFzQ4maZ30ePnI7i7MZfky+uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=aCWdEeX5; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="aCWdEeX5"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3RWp1BN3zlgVnW;
	Mon, 25 Mar 2024 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711403602; x=1713995603; bh=wg4KJ1e3HidXWUzaLyU4qeTt
	auPnXyoAnJb8qevm8gY=; b=aCWdEeX5iO7Ehuwr5AVDmTmiJ8mekUjqjwC063LE
	IpHRKlt4vxM2pmJLghJBrodLeBqGH3Wq2mkTAVVaBa7tihRm1LEwKW5fdx8NxqIs
	uyIUt6t8g/THvQ1le1JyTOJ+wS3Kpm+pSRAV6H+pGX9vibJaEjxBL0/kAkG480j9
	qsqBAa9NQZwbgu2YhR3BnbLrPGNk3RCOk0WE6+Vqc3afjO6usK4bgmqj3aGVP847
	VJbr0eZKYkn3JtUS8DGjsjku5bfnHUyD8onSXIv3IMswX/HDuBpvWACnEHQyOc+L
	k3QeDzPKtPglDU3Rw1CEgbkcquSRkvOHx3ABoTClgZUHmw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AsVjKjgKR5V6; Mon, 25 Mar 2024 21:53:22 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3RWg6rlmzlgTGW;
	Mon, 25 Mar 2024 21:53:19 +0000 (UTC)
Message-ID: <f3b298bb-b68a-4375-a3b4-fc91229740c1@acm.org>
Date: Mon, 25 Mar 2024 14:53:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-8-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> +/*
> + * Per-zone write plug.
> + */
> +struct blk_zone_wplug {
> +	struct hlist_node	node;
> +	struct list_head	err;
> +	atomic_t		ref;
> +	spinlock_t		lock;
> +	unsigned int		flags;
> +	unsigned int		zone_no;
> +	unsigned int		wp_offset;
> +	struct bio_list		bio_list;
> +	struct work_struct	bio_work;
> +};

Please document what 'lock' protects. Please also document the unit of
wp_offset.

Since there is an atomic reference count in this data structure, why is
the flag BLK_ZONE_WPLUG_FREEING required? Can that flag be replaced by
checking whether or not 'ref' is zero?

> -void disk_free_zone_bitmaps(struct gendisk *disk)
> +static bool disk_insert_zone_wplug(struct gendisk *disk,
> +				   struct blk_zone_wplug *zwplug)
> +{
> +	struct blk_zone_wplug *zwplg;
> +	unsigned long flags;
> +	unsigned int idx =
> +		hash_32(zwplug->zone_no, disk->zone_wplugs_hash_bits);
> +
> +	/*
> +	 * Add the new zone write plug to the hash table, but carefully as we
> +	 * are racing with other submission context, so we may already have a
> +	 * zone write plug for the same zone.
> +	 */
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	hlist_for_each_entry_rcu(zwplg, &disk->zone_wplugs_hash[idx], node) {
> +		if (zwplg->zone_no == zwplug->zone_no) {
> +			spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +			return false;
> +		}
> +	}
> +	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +
> +	return true;
> +}

Since this function inserts an element into disk->zone_wplugs_hash[],
can it happen that another thread removes that element from the hash
list before this function returns?

> +static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
> +{
> +	if (atomic_dec_and_test(&zwplug->ref)) {
> +		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
> +		WARN_ON_ONCE(!list_empty(&zwplug->err));
> +
> +		kmem_cache_free(blk_zone_wplugs_cachep, zwplug);
> +	}
> +}

Calling kfree() or any of its variants for elements on an RCU-list
usually is not safe. If this is really safe in this case, a comment
should explain why.

> +static struct blk_zone_wplug *disk_get_zone_wplug_locked(struct gendisk *disk,
> +					sector_t sector, gfp_t gfp_mask,
> +					unsigned long *flags)

What does the "_locked" suffix in the function name mean? Please add a
comment that explains this.

> +static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
> +					    struct blk_zone_wplug *zwplug)

What does the "_unaligned" suffix in this function name mean? Please add
a comment that explains this.

Thanks,

Bart.
