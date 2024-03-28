Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE12913342F;
	Thu, 28 Mar 2024 22:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711664423; cv=none; b=U/M2byzAvWvFWJsaaBMG/yMSgMBgZOKXUq5b81Ma45NeNhlqOV01RzaYLhcbfYT4qdNhFNxH2WYoAaa/9u077VFxIx0HYcAzKwBpAJDJQxO8I6FZLc9bMo0VpwOfEmi//C6kQs+rlNiHoj5ghYX1SUfv/CFMtLkr2VvPhKWO9UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711664423; c=relaxed/simple;
	bh=52Dhf6z/72rCN3hRJbd5HD2QYzajoOPuuQICDXLGhso=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=LkhB2vka5qfmDA0+p6on97IPgYikcMfs28X5Mu5zLwXflGcAzhTgBB6R6kpuFNeXjecf/PQz1VI807XPbtictAhU+Qfg5K1vXfmJkeBsvEErqImntmux1aoSev6uCeLBs5OmcKG8fE02o8VJ2kdI9/gj3BlSSh5yMRwdYIA49kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=l0Iqx4ws; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="l0Iqx4ws"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5HzT2dwDz6Cnk8t;
	Thu, 28 Mar 2024 22:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711664416; x=1714256417; bh=biHmi33YIfGx176ee0cuOTX9
	tPVA38ASjA6C7DNKzzc=; b=l0Iqx4wsPxCNSTyduWDzbW4fjR19IlBtTP6gJH+r
	NIi8nOXwGV8tke4FTPjMLey7r+Q32Zc6nfhvuWpoPtixNItr66IGljL81VPrJnvb
	BH3lxrfxtsBnrOAXmYMTu9xzrU1/nBFZ7tNViHStqGZK4O90LjjSF4JRQVXfC0ek
	kbE/93ok6J+OlHcpH+S8/lVZXK9wyCGyXJGKU7kYbrxPA/jg7Knc5ML5YDAfA0Fx
	F0/cY6XuUSp6BxBqeVKlbObYI30Cu8+FQ03qNPya68XPCPwTnvQ4nCWagerl0+B5
	I+f9A7RHRpWJ1fS9WOGizbzr/hmAPPVgUS/sRVBbQ0sVkQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id l62VJEqGq-6D; Thu, 28 Mar 2024 22:20:16 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5HzM1Blqz6Cnk8m;
	Thu, 28 Mar 2024 22:20:14 +0000 (UTC)
Message-ID: <688607d9-6dfe-4c37-81e8-4fea91ec8da8@acm.org>
Date: Thu, 28 Mar 2024 15:20:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/30] block: Introduce zone write plugging
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-9-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> +	/*
> +	 * Initialize the zoen write plug with an extra reference so that
> +	 * it is not freed when the zone write plug becomes idle without
> +	 * the zone being full.
> +	 */

zoen -> zone

> +static void disk_zone_wplugs_work(struct work_struct *work)
> +{
> +	struct gendisk *disk =
> +		container_of(work, struct gendisk, zone_wplugs_work);
> +	struct blk_zone_wplug *zwplug;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +
> +	while (!list_empty(&disk->zone_wplugs_err_list)) {
> +		zwplug = list_first_entry(&disk->zone_wplugs_err_list,
> +					  struct blk_zone_wplug, link);
> +		list_del_init(&zwplug->link);
> +		blk_get_zone_wplug(zwplug);
> +		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +
> +		disk_zone_wplug_handle_error(disk, zwplug);
> +		disk_put_zone_wplug(zwplug);
> +
> +		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
> +}

What is the maximum number of iterations the above while loop can 
perform? I'm wondering whether a cond_resched() call should be added.

> +
> +	/* Wait for the zone write plugs to be RCU-freed. */
> +	rcu_barrier();
> +}

It is not clear to me why the above rcu_barrier() call is necessary? I'm
not aware of any other kernel code where kfree_rcu() is followed by an
rcu_barrier() call.

> +static int disk_alloc_zone_resources(struct gendisk *disk,
> +				     unsigned int max_nr_zwplugs)
> +{
> +	unsigned int i;
> +
> +	disk->zone_wplugs_hash_bits =
> +		min(ilog2(max_nr_zwplugs) + 1, BLK_ZONE_MAX_WPLUG_HASH_BITS);

If max_nr_zwplugs is a power of two, the above formula will result in a
hash table with a size that is twice the size of max_nr_zwplugs.
Shouldn't ilog2(max_nr_zwplugs) + 1 be changed into
ilog2(roundup_pow_of_two(max_nr_zwplugs))?

Otherwise this patch looks fine to me.

Thanks,

Bart.
