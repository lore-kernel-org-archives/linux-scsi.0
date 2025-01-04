Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BB225949A;
	Sat,  4 Jan 2025 12:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735995055; cv=none; b=ssTOJDFlAA0bzSfey5MQ9e+mshLL/EU0BOZsLbWKUUvySXv13JKcEqt2xTfyiGeBaT7BdrIeCQuUzevxdYjM/3fd6ARGpEOX9Vfhm+MaKqBv1TWL7z8Ec/lNyzKCTPFiRwgFXNsdzyMpaFZqx4mv026EghW18zUpDhLGxXd7sWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735995055; c=relaxed/simple;
	bh=wG77QoH8YFFbXXyt5XCkGfnUCh8vBW7TkSa0RhILZzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/Cx4F8CXAwapa0BS8UpO3ixnYaISb+QIulgzbvi9Syo5tcGHeNipuaz/Y06v+CvlzCeEYsvrfVFqmVa01z0+el1J6FBpxi12M2ODb/CK0YzdvAk7hHwG2Adn3wpzXSpRl1nV42SsPzi0eipVZiDxFLSNv8+a0ZtYE3zjkG1R/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0zCc9HW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0zCc9HW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52620C4CED1;
	Sat,  4 Jan 2025 12:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735995055;
	bh=wG77QoH8YFFbXXyt5XCkGfnUCh8vBW7TkSa0RhILZzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j0zCc9HWipc7zTQ8rkjD80P+cRJkuXXw5Uha4fDe4TAwguqKT0X7jF+pA+DF4rYD8
	 9TQJWrt7lv0psR5Xly8hgXGoy3vtGHjfmMftBO2WubmHz7TJNAU3l75qWzz7o+rQ3e
	 7+HjKPOIQ34jCCYSEucQ7m0KCilb7CGBf8f+/9v6kHo2io/mTHd73NAKdf25+A1zNe
	 MmZS7ETnVhCDRsMCbApBtCpLn4R9GhwZDUM3xkNOaH99oW7rZ3sVgH39Ze9QD6repg
	 UkafmN15l2IohchFSiXZ6O4zAssA86u705jfuz03NC4HnYYdGFjqgtcjMW/ab6GIiG
	 NGBymgNtQOXjw==
Message-ID: <84b856a9-482a-45ac-974b-61bbe619b588@kernel.org>
Date: Sat, 4 Jan 2025 21:50:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: avoid to send scsi command with ->queue_limits lock
 held
To: Nilay Shroff <nilay@linux.ibm.com>, Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20241231042241.171227-1-ming.lei@redhat.com>
 <770947cc-6ce9-4ef0-8577-6966c7b8d555@kernel.org>
 <89b19b37-3e47-4914-aed0-83e5602c3ab8@linux.ibm.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <89b19b37-3e47-4914-aed0-83e5602c3ab8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/4/25 20:28, Nilay Shroff wrote:
> 
> 
> On 1/4/25 12:47 PM, Damien Le Moal wrote:
>> On 12/31/24 13:22, Ming Lei wrote:
>>> Block request queue is often frozen before acquiring the queue
>>> ->limits_lock.
>>
>> "often" is rather vague. What cases are we talking about here beside the block
>> layer sysfs ->store() operations ? Fixing these is easy and does not need this
>> change.
> Other than sysfs ->store(), I see there're few call sites in NVMe driver (nvme_update_
> ns_info_block(), nvme_update_ns_info_generic(), nvme_update_ns_info() etc.) which first
> freezes queue and then acquire limits lock. Also there's one call site (__blk_mq_update_
> nr_hw_queues) in block layer which does the same.

I sent a patch to address the block layer sysfs. Starting looking into these
other calls with the reversed locking.

>> Furthermore, this change almost feels like a layering violation as it replicates
>> most of the queue limits structure inside sd. This introducing a strong
>> dependency to the block layer internals which we should avoid.
>>
> In theory, we don't need to hold limits lock while sd_revalidate_disk() reads various
> limits from hardware. However can't we make this one exception (till we find a better 
> solution) for sd_revalidate_disk() and allow it to acquire limits lock while blk-mq 
> request is processed?

Sure, but issuing IOs to probe a device with the limits lock held is also *not*
an issue. All that can cause is a slight delay for user initiated changes
through sysfs. The fundamental issue is not issuing IOs with the limits lock
held, it is the inconsistent ordering of the calls to blk_mq_freeze_queue and
queue_limits_start_update().

My take on this is that we should always freeze the queue only once the limits
lock is held, with the queue freeze only around queue_limits_commit_update(). If
the consensus is to do the reverse, that's fine with me as well, but probably
will be more work to change (as this large patch tends to indicate).

-- 
Damien Le Moal
Western Digital Research
