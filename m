Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2141B3FBB8;
	Thu, 28 Mar 2024 05:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711603723; cv=none; b=gTzIiCHZEq+JveTnB61Rbjk3K9UOKXjeWd2JPHO6Lq5qRkZKTwNpWfpblzB5bpmuiNRKbcq/b7+M98D8PAtlyf0LhZBfARISCYnVfs9tcMFrVj9IuNRnzszj22L2gb7dLoEVkXEWUxhHSN/l/8CxlozxQy4DPL7PPVxy08clmt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711603723; c=relaxed/simple;
	bh=joeI5vjilCn2N1WZep2c8Jhovr8+M4ZlkrQFBtpEbI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OYNbMQkYlKsRUdnT7xwGrlC+1PCCUc6aFcKnjhoZk/W3lEZtPzTyQ0vCkroJw7KdXDpLRQAVQ6zg4zxGWBUnruRmjjVKDomGU87wvwBFHICRQGWhrwqyjqNwmXXzr3PxXrXrqWmXdioUAWawgTMHBYsCyW7Vxyc8/26gzFFp1m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IF2pwYqS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IF2pwYqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6419CC433C7;
	Thu, 28 Mar 2024 05:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711603722;
	bh=joeI5vjilCn2N1WZep2c8Jhovr8+M4ZlkrQFBtpEbI4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IF2pwYqSx8KmA8+ubLE6jcJEnJvul6TNsoSButRs7Tc6aF/49j1R0PvnJLj1RhkhO
	 xL8jz4x9iTsXlI8OY49iWJK+nRm2fCt+WOhc16UTEs/cjye1ZA0fSxPwebjedEAQkR
	 XlogSS56vXkvm4gHagRU6oQtSSZfXJyXi1NnvsGS/92mF9HbdJZJ1nOOH9iUDnxvfZ
	 0GAze/6/l5K+kyLC13nNZj0BwKLvez1G8WVmJ5S/yqCKfi4ztKLLTZsqawpxUkp0RI
	 Z9CmAD6XD1gXDn8UzP+e8XgwAFScmSUjIDNVl9eyY/IwUbINCeBcqOBfUye3t2kMYu
	 U2ov1MuNgUdWA==
Message-ID: <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
Date: Thu, 28 Mar 2024 14:28:40 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328043016.GA13701@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 13:30, Christoph Hellwig wrote:
> I think this should go into the previous patch, splitting it
> out just causes confusion.
> 
>> +static void disk_free_zone_wplug(struct blk_zone_wplug *zwplug)
>> +{
>> +	struct gendisk *disk = zwplug->disk;
>> +	unsigned long flags;
>> +
>> +	if (zwplug->flags & BLK_ZONE_WPLUG_NEEDS_FREE) {
>> +		kfree(zwplug);
>> +		return;
>> +	}
>> +
>> +	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
>> +	list_add_tail(&zwplug->link, &disk->zone_wplugs_free_list);
>> +	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
>> +}
>> +
>>  static bool disk_insert_zone_wplug(struct gendisk *disk,
>>  				   struct blk_zone_wplug *zwplug)
>>  {
>> @@ -630,18 +665,24 @@ static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
>>  	return zwplug;
>>  }
>>  
>> +static void disk_free_zone_wplug_rcu(struct rcu_head *rcu_head)
>> +{
>> +	struct blk_zone_wplug *zwplug =
>> +		container_of(rcu_head, struct blk_zone_wplug, rcu_head);
>> +
>> +	disk_free_zone_wplug(zwplug);
>> +}
> 
> Please verify my idea carefully, but I think we can do without the
> RCU grace period and thus the rcu_head in struct blk_zone_wplug:
> 
> When the zwplug is removed from the hash, we set the
> BLK_ZONE_WPLUG_UNHASHED flag under disk->zone_wplugs_lock.  Once
> caller see that flag any lookup that modifies the structure
> will fail/wait.  If we then just clear BLK_ZONE_WPLUG_UNHASHED after
> the final put in disk_put_zone_wplug when we know the bio list is
> empty and no other state is kept (if there might be flags left
> we should clear them before), it is perfectly fine for the
> zwplug to get reused for another zone at this point.

That was my thinking initially as well, which is why I did not have the grace
period. However, getting a reference on a plug is a not done under
disk->zone_wplugs_lock and is thus racy, albeit with a super tiny time window:
the hash table lookup may "see" a plug that has already been removed and has a
refcount dropped to 0 already. The use of atomic_inc_not_zero() prevents us from
trying to keep using that stale plug, but we *are* referencing it. So without
the grace period, I think there is a risk (again, super tiny window) that we
start reusing the plug, or kfree it while atomic_inc_not_zero() is executing...
I am overthinking this ?

-- 
Damien Le Moal
Western Digital Research

