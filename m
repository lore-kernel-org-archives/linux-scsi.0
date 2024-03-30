Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C443610FF;
	Sat, 30 Mar 2024 00:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711758808; cv=none; b=GCVVSmti0c4dvGnAesdH+dAdiMm6io7nsSMAkSrgVNbw/nYKTybvN4LhibqkbH8LMkDSih4q6BMQUGpWU0eM7i8Ihud3znnZjxGixkNK+aZ2yWvnBucBrtnLwIeTuMkHzrQ+Mp3GpNPZw/ngz9t6P2yPQqZTHtDXx7a9QUwYxPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711758808; c=relaxed/simple;
	bh=csJGkazmVozzT5A8motwawZT4X6xZdC0OteDaVk0kTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sOeCsoUFjwzx+VImt0yzADEjuPnNxEKI4cy8BfvFQO6r8vmSzWkLFIxJfyydvosTD2YTgghwSG2DNzRvPc7qebpSjC5zU9unB+Ef24/0AdeqoiGlWV4+TCErlAGGkWP3KyeXZSCwWXkBMb1ixsB5B6bLdmxxOEX4dNoa1N6YiGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foDMAoyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foDMAoyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98800C433C7;
	Sat, 30 Mar 2024 00:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711758808;
	bh=csJGkazmVozzT5A8motwawZT4X6xZdC0OteDaVk0kTk=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=foDMAoyLdSsfL8d5rqY2PUtDxwp1rhpbwNQafskaT6bWWR+5xdxZ/JDASoQ8rBkPG
	 OqaKf3SMuEAddayru0agzGW6QurWphr/P68Kc7z7Bnk3/Z54pLmpLed9uQPGn+WnTz
	 euObADHgwau0WzgBhIxDBT49N8TJDQ5i0m6moMlcHheXiro5JxEB4NX3UZ4sKx9SpP
	 PkYKFH0jiyiXwi3ngZ2fsDIp/97dqcdAvN8QcGyXxT7ZYvz5CKiratCpWY8Ur+Fkpc
	 5yxDde9SD92clcTvIH+mFVqNPbofnEJxPLzfbEvUaCq6vfTOOSgwSMZ1ocCnKLSSYi
	 bN9Xdq+Ybgakw==
Message-ID: <f661db89-8008-4c56-a50d-44ad95d706ef@kernel.org>
Date: Sat, 30 Mar 2024 09:33:24 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/30] null_blk: Introduce zone_append_max_sectors
 attribute
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-19-dlemoal@kernel.org>
 <20897217-2eae-44f8-9873-43d8898ecf43@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20897217-2eae-44f8-9873-43d8898ecf43@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/24 06:35, Bart Van Assche wrote:
> On 3/27/24 5:43 PM, Damien Le Moal wrote:
>> @@ -1953,7 +1961,7 @@ static int null_add_dev(struct nullb_device *dev)
>>   
>>   	rv = add_disk(nullb->disk);
>>   	if (rv)
>> -		goto out_ida_free;
>> +		goto out_cleanup_zone;
>>   
> 
> The above change is unrelated to the introduction of
> zone_append_max_sectors and hence should not be in this patch.

Good catch. That is a bug of this patch. I removed this change as it is incorrect.

> Additionally, the order of cleanup actions in the error path seems
> wrong to me. null_init_zoned_dev() is called before blk_mq_alloc_disk().
> Hence, the put_disk() call in the error path should occur before the
> null_free_zoned_dev() call.

That is separate from this patch (and the series). But I will send a fix patch
for that.

-- 
Damien Le Moal
Western Digital Research

