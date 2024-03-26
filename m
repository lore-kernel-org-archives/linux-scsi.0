Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE2128394;
	Tue, 26 Mar 2024 08:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711440759; cv=none; b=OapAPseAiQcjfIpXWyYEWMCb5tWwGdEuqZqUGzgk3hMZ26vZyBCCghzzCA2HNs5c/+UjpX4AGFBS+Z/rNhzHRliF+ZT8CloaBGGCpKe34b3NY5tHGD3taawYEY4i6YJoIlHd4bGM+t/Oj/t3KUJYVok1oKKIX01o5nU6kG1m2JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711440759; c=relaxed/simple;
	bh=b4XUqaiVZydt81c4Vs8fVNoLebubbR4Ob9RU0xtoAoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRCegMTQhE6l31YpPH53ejZT5UWysb36YutmVXPvLDq8DGtgOmKY8PYjRwU5hH+XrOPqi8gkgm/roOUxeAfBlpN4dqRDpRiDGH0L7YCqJqNGkmvk9jupnx19wAnwcGPPtQ7Y84eUEgnvXCXTeg6LAMuU6VEynCcdprp3fWf6gMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZc+HtR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZc+HtR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05545C433C7;
	Tue, 26 Mar 2024 08:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711440759;
	bh=b4XUqaiVZydt81c4Vs8fVNoLebubbR4Ob9RU0xtoAoU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TZc+HtR9AElhUaxKANVz9kkQRnaVdbFgyGpZdQSEsMLFycW0HXdLcEgyZTijTa4T5
	 nKVDnBQOSdfimYYuY6ZjYAqABmDP3Ro0nlnOgzHCyvUXo30pGEE0kolGGajDGLnB+E
	 SEtu8fzkSk1xQwbHqdvA9ef9m/8j9d6U2zENEueP0Th7jA4X1bOPbUJVE3QAvXXuS5
	 bbfELrduImnWfu4CW1k49EZQ+y5MbvCnaTYyvLRY+OhEmo9AvORCN8B8k41n9iYwNI
	 n7CRyRPxAMWIlx9Z6yWKgALdkTluANehXa3t1X+Y10sRYljBieYyABJ31miVcwdqUz
	 kpkV8WbEaT/rQ==
Message-ID: <80acb831-b8c9-4bcd-8c36-72977936a32a@kernel.org>
Date: Tue, 26 Mar 2024 17:12:36 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/28] block: Allow BIO-based drivers to use
 blk_revalidate_disk_zones()
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-13-dlemoal@kernel.org> <20240326070838.GA8402@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240326070838.GA8402@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/24 16:08, Christoph Hellwig wrote:
>> +	/*
>> +	 * For devices using a BIO-based driver, we need zone resources only
>> +	 * if zone append emulation is required.
>> +	 */
>> +	if (!queue_is_mq(disk->queue) &&
>> +	    !queue_emulates_zone_append(disk->queue))
>> +		return 0;
>> +
> 
> This code and the comment is duplicated in two places.  It also fails
> to capture why bio drivers don't need zoned resources - that is that
> we can't enforce QD=1 per zone for them.  Maybe add a little helper
> to encapsulate this check and expand the comment a little?

That is not the reason. Because we can actually enforce QD=1 write per zone for
DM devices with zone write plugging. E.g. dm-crypt requires that.
The reason is more that most DM devices don't need to have that enforcement as
they are responsible for handling the sequential writing of zones themselves. So
no hash table and no conv bitmap needed for them, unless like dm-crypt, they
request zone append emulation, in which case, zone write plugging is turned on
for the DM device.

But I agree about the helper. Will make that change.

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
Damien Le Moal
Western Digital Research

