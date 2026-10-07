Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FB347606F;
	Wed,  7 Oct 2026 14:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383876; cv=none; b=Qwc4h2FpEuGxpc7DEiZG79CKem3oXmHdRt00YAxxsmK8E4ZJRz1onruzKkQ1dIAK5hGx/X9oKtZPLMBsZT6irYDpd4oTf77bwOd8j7vYaw6nKPonSsWpfzWpzNZl6M9VXwt2uOrwHxMWCktZsuBecnLT8nSOO/gH5kmisOJPKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383876; c=relaxed/simple;
	bh=dzJ8hxFggwU6pJ2zCOph7qZdH888jnzXK7GIJ3OY9Nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/H2SSoxUCskKRPdW0b4BuVkqT1wILP3iwWSfZVPBEHbXVqfxES9KVKhlSuEoLjJMRG1xaQ6UxrZKH2jKp/jF/ILH5e9RVd9Tz+CsmK9i77njC+kA/TC4tbBW78t3nWEIh8Lvp3anCZmR6yF+B57RLxhViN7RHwXps37Bj+aK28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iibbs16m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iibbs16m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28E51F0089B;
	Wed,  7 Oct 2026 14:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791383871;
	bh=GG5jwSXwFZSPrkPAWhdwXn9rWMgKeHr3/fZis9XEEZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Iibbs16mQ8Ecy6bBjomx/ySbkrIrG4jRD5UBboCRm5AHjhgGNVZMAe7QqqRv5I511
	 U5200g9QdVTp2DRfanzUhrTGzNzVnaRo/oIgIrWrws2bbqnqYqwi/huoxhEaJu3bm2
	 IXIq8oLietHNgdT+QTMHj6sNxFRpz04UHyPdZYWXdpFYW6RDbkGfxc8eyt1ULpbfAx
	 9YnkMG2eDhSV37gT2myctxoH+E5MJfnHxNm12t7KFG2dzKgxpJLVeTJuneLXfnoJFg
	 Fi/Oa+faJgOm6/tu/dLNvaXBS6+qHvs9amTW5MTv07icVmMFz7afov22J44mNrs3wm
	 zR8jUKGC2pvSw==
Message-ID: <e11de48b-e719-4cfc-a08d-916a8603782d@kernel.org>
Date: Wed, 7 Oct 2026 16:37:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] block: add storage element management ioctls
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
 <20261007082344.1049179-4-dlemoal@kernel.org> <20261007133922.GC31906@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261007133922.GC31906@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/07 15:39, Christoph Hellwig wrote:
>> +	if (copy_from_user(&rep, argp,
>> +			   sizeof(struct blk_storage_elements_report)))
> 
> Can we shorten the name of the struct a bit?  blk_se_report?
> Similar for other identifiers?

Sure.

> 
>> +		return -EFAULT;
>> +
>> +	ret = bdev_report_storage_elements(bdev, NULL, &nr_elements);
>> +	if (ret)
>> +		return ret;
>> +
>> +	nr_elements = min(rep.nr_elements, nr_elements);
>> +	if (!nr_elements)
>> +		return -EINVAL;
>> +
>> +	elements = kzalloc_objs(struct blk_storage_element, nr_elements);
> 
> This doesn't work as it could race.  We'll always need to allocate
> the space for all the elements the user asked for?

I am not following... The number of elements of a drive never changes, and that
is what nr_elements indicates. So getting the min with the user indicated value
still gives all elements, and that also creates a bound in case we get a crazy
large value from the user.

> 
>> +	retc = copy_to_user(argp + sizeof(struct blk_storage_elements_report),
>> +			    elements,
>> +			    sizeof(struct blk_storage_element) * nr_elements);
>> +	if (retc) {
>> +		ret = -EFAULT;
>> +		goto free_elements;
>> +	}
>> +
>> +	rep.nr_elements = nr_elements;
>> +	retc = copy_to_user(argp, &rep,
>> +			    sizeof(struct blk_storage_elements_report));
> 
> Why not copy back the entire struct in one go?

Indeed.

>> +		ret = truncate_bdev_range(bdev, mode, 0,
>> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);
> 
> Use bdev_nr_bytes() here?
> 
>> +	/*
>> +	 * Storage element restoration is a destructive operation that will
>> +	 * reset all zones. So fflush the device volatile write cache and
>> +	 * invalidate all cached data that we may have.
>> +	 */
>> +	filemap_invalidate_lock(bdev->bd_mapping);
>> +	ret = blkdev_issue_flush(bdev->bd_disk->part0);
>> +	if (!ret)
>> +		ret = truncate_bdev_range(bdev, mode, 0,
>> +			(get_capacity(bdev->bd_disk) << SECTOR_SHIFT) - 1);
> 
> Same.  Also what about factoring the duplicate code block into a helper?

Yes.


-- 
Damien Le Moal
Western Digital Research
