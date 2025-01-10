Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDCE207A2A;
	Fri, 10 Jan 2025 09:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736503072; cv=none; b=e2LIFd9WDvShSV1VCzfwQJKcZmStr21TF8JWefTFhH/5UHXKBif4MS68Q7G9CUkyrGvsRaws3NWX6zJREdDd6fpfYV0GVcA9xSPcHmCBCOYMTYcr7H1JGvmUHoQbcenid0ozZJDYlNFMW9f7mazq1BwG8z6Ziq3rfTj8V3BJMio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736503072; c=relaxed/simple;
	bh=Ahu3Dj96KxIjB1xjdFeJU1rYT88XOcVzEVQ7DyN66M8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sl3pgXhuabSLdE/wN9Abjg8QZzTlhK/i6Btpy8VASDDHG7mbafh4eD92XI03v4alcgewbEfLGo8n9Cg7apnc75rrmpRvdoDxnQeOIa8da/NJ2tzV3tVVkrNpe6DTYV8TKvpcC0rDd0cuHWlsKHbyltdf2Ymj93jRnVP/AT0DE94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nNFYg8qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nNFYg8qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE57C4CED6;
	Fri, 10 Jan 2025 09:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736503072;
	bh=Ahu3Dj96KxIjB1xjdFeJU1rYT88XOcVzEVQ7DyN66M8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nNFYg8qjo580eFZxxDoYZpxhYQGkf0D87WqqbLMa5KZ13hqmud4O3xBZb50SKG4ec
	 gDh3vn734bXAldYZFUP3PUBXTMPWHs7X9oDJp1PKnw9SJX8J3gSDYlRRntLbGUQBhM
	 4ZTf9aQW1+ql/1pDuuzP3ZhfU11nDXoeAJxewVFwrGXq/vaTS08CZ6dnFBm/g5gLxM
	 aD0+wO+1sbAx8Z6cKTkHriQfBH+WqXzPY1w1nRNPiZnBOwiJbpKLjnB3ZkGx0yfghc
	 sGj4kRcDO5VHKtBxxWVoYpb63rwtJJzMlkr/4Ulz8CzQ8AJNae9MioAuBGr4Qx4U/H
	 hu72t/BZ5t8gw==
Message-ID: <d7db7620-1f2e-4216-8929-2cfd4d847447@kernel.org>
Date: Fri, 10 Jan 2025 18:57:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] block: add a store_limit operations for sysfs
 entries
To: John Garry <john.g.garry@oracle.com>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250110054726.1499538-1-hch@lst.de>
 <20250110054726.1499538-6-hch@lst.de>
 <79d85a4e-57c3-454e-a65b-d2a3764eaf0c@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <79d85a4e-57c3-454e-a65b-d2a3764eaf0c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/01/10 18:56, John Garry wrote:
> On 10/01/2025 05:47, Christoph Hellwig wrote:
>> -static ssize_t queue_iostats_passthrough_store(struct gendisk *disk,
>> -					       const char *page, size_t count)
>> +static int queue_iostats_passthrough_store(struct gendisk *disk,
>> +		const char *page, size_t count, struct queue_limits *lim)
>>   {
>> -	struct queue_limits lim;
>>   	unsigned long ios;
>>   	ssize_t ret;
>>   
>> @@ -284,18 +269,13 @@ static ssize_t queue_iostats_passthrough_store(struct gendisk *disk,
>>   	if (ret < 0)
>>   		return ret;
>>   
>> -	lim = queue_limits_start_update(disk->queue);
>>   	if (ios)
>> -		lim.flags |= BLK_FLAG_IOSTATS_PASSTHROUGH;
>> +		lim->flags |= BLK_FLAG_IOSTATS_PASSTHROUGH;
>>   	else
>> -		lim.flags &= ~BLK_FLAG_IOSTATS_PASSTHROUGH;
>> -
>> -	ret = queue_limits_commit_update(disk->queue, &lim);
>> -	if (ret)
>> -		return ret;
>> -
>> -	return count;
>> +		lim->flags &= ~BLK_FLAG_IOSTATS_PASSTHROUGH;
>> +	return 0;
>>   }
> 
> BTW, this function seems to duplicate queue_feature_store(), no?
> 
> I mean, why not:
> 
> static int queue_iostats_passthrough_store(struct gendisk *disk,
> const char *page, size_t count, struct queue_limits *lim)
> {
> 	return queue_feature_store(disk, page, count, lim,
> 		BLK_FLAG_IOSTATS_PASSTHROUGH);
> }
> 
> I think that there is even a macro for this.

Another cleanup to add to the pile I guess :)

-- 
Damien Le Moal
Western Digital Research
