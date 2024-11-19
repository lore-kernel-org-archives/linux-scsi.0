Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6644B1D3593;
	Tue, 19 Nov 2024 21:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732051014; cv=none; b=PxmObNZUX4PMldZmPJE5BrfktmDPWXeB6WPe1LnnWcvWbZvs3PzmQ9/yfpk0e9+RH9DofsP5nQLpa4xgOAo7nsban/CxOfEX4NdCmNBw9DV+JHQ8MOxCJCREz6Mj2ea9vQnFxtYjOjNOQH6Weds5KERcATaCcykmioagQuXygpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732051014; c=relaxed/simple;
	bh=/PgPwr586TwAdKKfkDnvw8HMu7Q4j3d7HllxTw1w/F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ez5DWubQp0otjyyx7FLscSYN1cKMrcmCW37nw78JeizrV2HkdrCrmmqQMNRiKB5ZltZzTTRLnfV/apaTlg5X5LzxT8pEoIW/iG9fWL0idQoJpZTDRPtMCwZReYHQZnmhJ7ysjt3+ra6sMfaKK4aYk2CaxmCu2AEWryHZpNr5/NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=i1RAaTBQ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="i1RAaTBQ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XtHPJ4vf2z6CmSMs;
	Tue, 19 Nov 2024 21:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732051008; x=1734643009; bh=uKmj9itP7XWPeYmFMYCcVK6R
	rRQrA9phkqPjeVufcr0=; b=i1RAaTBQZ0rQSZu4RYljv+CY2RM1Y6YOyUdcUK/d
	nZCF3e07KLZkk2akHm6t14t4lDrmzggnTaddK3N+GrBVC3T2+0+yg5OhSCSjD3Sc
	NgWgAGs6tFnR805R/TDKVXtmMYyynkcp2qHnUlCDlN/gvJ3VhXTrB4LG3ZGcpo29
	UUgakerTLz5PQOeIUmm7kM5yCDHYVYRJZA6kFTp7vgeQ0hgZID7e+T4KecX3ChPP
	O+emDsCp5ByChdvKtcM1m5XnB0vRfyxr7AZaZLyvvLwHx7b9kD0SAsRqhB+7E/e1
	CBMQYKf1sQCYKqLo+8gUf7B5kBS1oohXJqwPbFB9zGtjwA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hq2nfVbrd6D9; Tue, 19 Nov 2024 21:16:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XtHPC4TLJz6CmM6V;
	Tue, 19 Nov 2024 21:16:47 +0000 (UTC)
Message-ID: <267e6853-eca7-423a-bda7-46494e888a0b@acm.org>
Date: Tue, 19 Nov 2024 13:16:46 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 14/26] blk-mq: Restore the zoned write order when
 requeuing
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-15-bvanassche@acm.org>
 <db6d72c5-5221-413f-a355-df8ab414f63e@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <db6d72c5-5221-413f-a355-df8ab414f63e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 11:52 PM, Damien Le Moal wrote:
> On 11/19/24 09:28, Bart Van Assche wrote:
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index f134d5e1c4a1..1302ccbf2a7d 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -1564,7 +1564,9 @@ static void blk_mq_requeue_work(struct work_struct *work)
>>   		 * already.  Insert it into the hctx dispatch list to avoid
>>   		 * block layer merges for the request.
>>   		 */
>> -		if (rq->rq_flags & RQF_DONTPREP)
>> +		if (blk_rq_is_seq_zoned_write(rq))
>> +			blk_mq_insert_request(rq, BLK_MQ_INSERT_ORDERED);
> 
> Is this OK to do without any starvation prevention ? A high LBA write that
> constantly gets requeued behind low LBA writes could end up in a timeout
> situation, no ?

Hi Damien,

Requeuing zoned writes should be exceptional and shouldn't happen often.
Such starvation can only happen if zoned writes for two different zones
are requeued over and over again. If that happens there will not only be
starvation for the write with the higher LBA but also retry count
exhaustion for the write with the lower LBA. If we agree that zoned
write retries are rare then I don't think we have to worry about
this kind of starvation.

Thanks,

Bart.
