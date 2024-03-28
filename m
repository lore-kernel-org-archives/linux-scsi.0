Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE7D37165;
	Thu, 28 Mar 2024 22:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711665801; cv=none; b=pMOSiP0Xnlxo/v0RcBHCAp2gtibzOeddMoS3/nJ1ClNMwlspQcv6Y91MfMJKP0NelgVCbfiW9+sH4t+p9A40AZVLpmMV+D+9y26HMHJoe3Mhz4pIxyGjUSMNpjtEGodlYnee5I646eVssRDe+iYzIU2nOpvqrbf9uMwAe68axQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711665801; c=relaxed/simple;
	bh=CITK6Ojd1qaNKBu5TkUujht795crhOMrLdIVFC0Z5hM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Y/LDkcGRU6Hekjp6zma1piaRsa3iBTmc2JOYzV2KYL5JziV6y9BHJS9KPUs67E/oEaTdNKMzan4SjAMd6Ds175U3gjjAIS5wT7TSRoMTXa9STWuSjTlYn6QnQGre+Z2yA/StjVorN5jRGt8Hm447WE9aIlQYDMtRtojAM78rlhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKCy/AVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKCy/AVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBA0C433C7;
	Thu, 28 Mar 2024 22:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711665800;
	bh=CITK6Ojd1qaNKBu5TkUujht795crhOMrLdIVFC0Z5hM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=MKCy/AVU6l2/Wrshu0b1+Qr72XyFVoSv41DvYqxpLZR5jzfI7OrjWnyhqwEJ8kIC5
	 9Cd238wXzx+FNBGZseIM7viDlGvYyda7z9CYEwW6iYWjEiG2OmR4HMTT0yp+wurT2C
	 ssR3nRcj742vELHhL64gVOziqBuTKhRUJJEPJolpYIBqLzEoSkLrrfRgkvJeqxS4WH
	 xevrEy77CY54uuhICmkeeg9iydwkca+Cup/S1456Qs5SfIB/kQbBapooQnDU+Sp1Y3
	 XLA+/o23yQTWn1PhKXEW1xdKWL+l132FnXtAd2hUurbcsoTX/oUkCPTQim8uW+i9pL
	 oMNYZe8JYT/pA==
Message-ID: <935b43c0-b5cc-48ef-a283-564499ac7bde@kernel.org>
Date: Fri, 29 Mar 2024 07:43:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/30] block: Do not force full zone append completion
 in req_bio_endio()
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-2-dlemoal@kernel.org>
 <a474bae3-e505-4d17-a5e4-ed9928b6cbb3@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <a474bae3-e505-4d17-a5e4-ed9928b6cbb3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/29/24 03:14, Bart Van Assche wrote:
> On 3/27/24 17:43, Damien Le Moal wrote:
>> This reverts commit 748dc0b65ec2b4b7b3dbd7befcc4a54fdcac7988.
>>
>> Partial zone append completions cannot be supported as there is no
>> guarantees that the fragmented data will be written sequentially in the
>> same manner as with a full command. Commit 748dc0b65ec2 ("block: fix
>> partial zone append completion handling in req_bio_endio()") changed
>> req_bio_endio() to always advance a partially failed BIO by its full
>> length, but this can lead to incorrect accounting. So revert this
>> change and let low level device drivers handle this case by always
>> failing completely zone append operations. With this revert, users will
>> still see an IO error for a partially completed zone append BIO.
>>
>> Fixes: 748dc0b65ec2 ("block: fix partial zone append completion handling in req_bio_endio()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   block/blk-mq.c | 9 ++-------
>>   1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 555ada922cf0..32afb87efbd0 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -770,16 +770,11 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
>>   		/*
>>   		 * Partial zone append completions cannot be supported as the
>>   		 * BIO fragments may end up not being written sequentially.
>> -		 * For such case, force the completed nbytes to be equal to
>> -		 * the BIO size so that bio_advance() sets the BIO remaining
>> -		 * size to 0 and we end up calling bio_endio() before returning.
>>   		 */
>> -		if (bio->bi_iter.bi_size != nbytes) {
>> +		if (bio->bi_iter.bi_size != nbytes)
>>   			bio->bi_status = BLK_STS_IOERR;
>> -			nbytes = bio->bi_iter.bi_size;
>> -		} else {
>> +		else
>>   			bio->bi_iter.bi_sector = rq->__sector;
>> -		}
>>   	}
>>   
>>   	bio_advance(bio, nbytes);
> 
> Hi Damien,
> 
> This patch looks good to me but shouldn't it be separated from this
> patch series? I think that will help this patch to get merged sooner.

Yes, it can go on its own. But patch 3 depends on it so I kept it in the series.

Jens,

How would you like to proceed with this one ?

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

