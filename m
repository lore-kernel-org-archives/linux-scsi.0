Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCB0652;
	Wed, 27 Mar 2024 07:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711524162; cv=none; b=kC/BKq5scxBOLQFJXerXdnwo+VyhXB+198+UX7aE0caJbTXQvuWeerk+A8Wop8SXXNX0rZJRruHPR4v3nD8OykqBHv2MDg19cGHm0t6NyUiqQf66fqRMTfUl9X0htscaBpxNuQ6c38Ks9Mv+Rd+RwfhhXZtCqtFooIPi6lRg8fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711524162; c=relaxed/simple;
	bh=LXzarL/VxvorhOvGRBzD/zTB++DSvtnl2GmSD7a9clk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLs8OdMQKit+Xe6Esb3FuWylMCgT8sgUdse1XtXOJ8jXaAqFyGGGvT1CKBZiqYRqIukmE2PIYoinUPvwe6bJJldd/RnFRKazc+aDSOvczp5A07vph9TCeDNLi6G1ttW4D1QlhBSLMdRW9MpLjEjNHCApWQZoB+DrpHzkmdWuNfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQ+CGyt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQ+CGyt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBAFC433F1;
	Wed, 27 Mar 2024 07:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711524162;
	bh=LXzarL/VxvorhOvGRBzD/zTB++DSvtnl2GmSD7a9clk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SQ+CGyt/zhZqFJFljhtENiX0bcgRRacBT012KMABYl/CMq8Ruvy/xVgYms5xQU/pd
	 MAn2dO8jZQlwsxGf3N+ROYt5mP+ZzpzVZCYZXwmw/knmgBmqw1AdFq9gAuzevoNr8o
	 zpUvR/DfuuSIVSHXNaEohiN2NtqHCK+3fjK1vr29P4jPALO143EayFjKLrbzOo5BS8
	 FdTUZlR6uAOpqkFIgu4pqi2eSK3sc99OTXWPnJnOZMAidOneSiAAwUh42cTTnberx6
	 aQK/6MzsCL82cQwrffPXEbK3P1LDmjXAU6prvvRrarTV212STLYUczlzlUJvJTgua4
	 ucz9r2ePpEmJg==
Message-ID: <de7d6ae9-c82d-408c-b5ab-a76d612a3519@kernel.org>
Date: Wed, 27 Mar 2024 16:22:39 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/28] block: Use a mempool to allocate zone write
 plugs
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-9-dlemoal@kernel.org>
 <6b2aca56-9a0b-4caf-878b-3331dc938a90@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <6b2aca56-9a0b-4caf-878b-3331dc938a90@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 16:19, Hannes Reinecke wrote:
> On 3/25/24 05:44, Damien Le Moal wrote:
>> Allocating zone write plugs using a struct kmem_cache does not guarantee
>> that enough write plugs can be allocated to simultaneously write up to
>> the maximum number of active zones of a zoned block device.
>>
>> Avoid any issue with memory allocation by using a mempool with a size
>> equal to the disk maximum number of open zones or maximum number of
>> active zones, whichever is larger. For zoned devices that do not have
>> open or active zone limits, the default 128 is used as the mempool size.
>> If a change to the zone limits is detected, the mempool is resized in
>> blk_revalidate_disk_zones().
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   block/blk-zoned.c      | 62 ++++++++++++++++++++++++++++++------------
>>   include/linux/blkdev.h |  3 ++
>>   2 files changed, 47 insertions(+), 18 deletions(-)
>>
> Why isn't this part of the previous patch?

I tried to reduce the patch size...

> But that shouldn't hold off the patchset, so:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks. But I am about to send V3 and I removed the mempool and replaced it with
a simple free list...

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research

