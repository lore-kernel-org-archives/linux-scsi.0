Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BB8225CF;
	Thu, 28 Mar 2024 22:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711665520; cv=none; b=LHnhOMfPvWNKAl5mAMJEtcCEB5GDLJ1/iwqib/k4POGNlqmE4y3R5L4Igy23FFCxSPPkrLAmnVEN0UySSAGmDsYYswIGle5/KQZIcG6MZGnSX40msNw5zGcwi4CkLy4poIVMgdLyfIuSyMtZaFpPRvKhg8xrEe1a+IkgH1WQvs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711665520; c=relaxed/simple;
	bh=VmmipSPvKCh4HSGbBCJ49hCyh1IaCoVaMfEsMghh+ts=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i5ndnTZy8Sxa7j3ZsgnzoLxC/f5JMVkzjBddSi6e9D4iWvJQ2pZAYTBsrl3LYHAEqJOahcbqJyzZDgxg+EqMhZkvSjwH6c85FNLTAT5NzGVw3BKXLON+eIH0gtFXLmtIMlBPBXS0lhboCx4wntQEh9eietljSdakrPh9d5aNL2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpqrxBLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpqrxBLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58E2C433F1;
	Thu, 28 Mar 2024 22:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711665520;
	bh=VmmipSPvKCh4HSGbBCJ49hCyh1IaCoVaMfEsMghh+ts=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=cpqrxBLld5KuuWt+1Jeok7tuSZMfX+iVDt6cYmfC4YiIiSelqAYl2+xicbIzHddhC
	 t+o+20xk2p4IxiCV+uOkvkD8aKz/+/A/53LJZJ7muz+82dIj+6w9YOQxnbdBNhJd+S
	 m0RNYVtCAfMnTTFbQK0BGQ4TIPG0oHVxD6Jnk2CsiT9cAKQHUjTlHfX2zwqqxwNn7t
	 MVq6BTF9Q69b/FWK8gh5SrwnGmTiys4ZnQZO3V4t9fztoAJ6yje0B+nHbtdddkp3pD
	 hpxy39ohw+4XFbkWStrXwXOI/wYqm/6t6Alh1DDToZtuj2pdJXE4GD3KdWvF42EC8Z
	 R7FEjFkp2P35g==
Message-ID: <caf50c25-8f3d-4eb1-85bc-cc3499d5b107@kernel.org>
Date: Fri, 29 Mar 2024 07:38:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/30] block: Introduce zone write plugging
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-9-dlemoal@kernel.org>
 <688607d9-6dfe-4c37-81e8-4fea91ec8da8@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <688607d9-6dfe-4c37-81e8-4fea91ec8da8@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 07:20, Bart Van Assche wrote:
>> +static void disk_zone_wplugs_work(struct work_struct *work)
>> +{
>> +	struct gendisk *disk =
>> +		container_of(work, struct gendisk, zone_wplugs_work);
>> +	struct blk_zone_wplug *zwplug;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>> +
>> +	while (!list_empty(&disk->zone_wplugs_err_list)) {
>> +		zwplug = list_first_entry(&disk->zone_wplugs_err_list,
>> +					  struct blk_zone_wplug, link);
>> +		list_del_init(&zwplug->link);
>> +		blk_get_zone_wplug(zwplug);
>> +		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +
>> +		disk_zone_wplug_handle_error(disk, zwplug);
>> +		disk_put_zone_wplug(zwplug);
>> +
>> +		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +}
> 
> What is the maximum number of iterations the above while loop can 
> perform? I'm wondering whether a cond_resched() call should be added.

The loop will go on as long as there are plugged BIOs and they can be merged,
that is, as long as the request does not exceed the queue limits. So this is all
limited naturally by the queue limits.

>> +	/* Wait for the zone write plugs to be RCU-freed. */
>> +	rcu_barrier();
>> +}
> 
> It is not clear to me why the above rcu_barrier() call is necessary? I'm
> not aware of any other kernel code where kfree_rcu() is followed by an
> rcu_barrier() call.

Right after that, the mempool (in v4, free list here) is destroyed. So the
rcu_barrier() is needed to ensure that the grace period is past and that all
plugs are back in the pool/freelist. Without this, I saw problems/crashes when
removing devices.

>> +static int disk_alloc_zone_resources(struct gendisk *disk,
>> +				     unsigned int max_nr_zwplugs)
>> +{
>> +	unsigned int i;
>> +
>> +	disk->zone_wplugs_hash_bits =
>> +		min(ilog2(max_nr_zwplugs) + 1, BLK_ZONE_MAX_WPLUG_HASH_BITS);
> 
> If max_nr_zwplugs is a power of two, the above formula will result in a
> hash table with a size that is twice the size of max_nr_zwplugs.

Yes, that is in purpose, to avoid hash collisions as much as possible.

> Shouldn't ilog2(max_nr_zwplugs) + 1 be changed into
> ilog2(roundup_pow_of_two(max_nr_zwplugs))?

I think it should be:

ilog2(roundup_pow_of_two(max_nr_zwplugs)) + 1

-- 
Damien Le Moal
Western Digital Research

