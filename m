Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F184733769D;
	Wed, 15 Oct 2025 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760546138; cv=none; b=qHJnZ82R0pLJDY9HVIj3mfiCDpxR9ASeSfaOlJ5GmlWdM2lU65AIps32cYwb5iEY8sMrYZCXxW2U/fZuyW8yWcJ+Q9tPKh27fbI1pVbGBV0yij4xRaZqWtXquXZlkSqwUZwCALYBshC4KRB3lPXcI1ZPlPaD6iRQco3vWVoT2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760546138; c=relaxed/simple;
	bh=gMDpsY0OBW+a4KAJ9ztSaalh4BBCF9av0aRhHcEskBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbwLCcvDJ91n+BFYSweWlhiRvtg9fx2IDWMsdktTPO1mHdlobmaQzMGM1Igxapy1Ro2MgsSZv2+6VAvjuq2nyIfLHvFBiXGtaQNmj77gVvQnFK/5aVtWms7I7xcSEBCKyD5YFGQi+yKmPmXjYtfuZoJVfQTixkynYmDQ8B0/yYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P6/W0tRQ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P6/W0tRQ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmxXR5NVRzm16kl;
	Wed, 15 Oct 2025 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760546134; x=1763138135; bh=DEWkkSgYJfoQoJCaidm/v0Mk
	55du1F31xNxRsQ6YuNQ=; b=P6/W0tRQ1npbpph7pyDKVg4R8hk0VrltBLnNoKVo
	+Vs7xh24vAr6ZDTYdIBNz0VYYx7KX/Fn5pyRbfkeE7xS169daw5MxDmr6c75/FTF
	hrNqJfGFFCOnZ+4jZm2s12eApnrHpD67Qs99abfkxcIXkNYHibqJS2jdvoj+dN6c
	S4mKNllTFzeU1KncBwodrxnSxY9j1anIBKY64NsMtpP6lAOYatrlwbPMAkmw+o9e
	kMp3dGNS584aL1Q3zdhiBFk9QSZblmeJyJ/zH67CEQTGcwZhMhAoDpyTT8O8UrT3
	iiACfP+rKTMsayR1kwsRE9nkW2TKELUSYgWFoGotKsE/2Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id n-zgqd0Hcsq0; Wed, 15 Oct 2025 16:35:34 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmxXM2pM8zm16kk;
	Wed, 15 Oct 2025 16:35:29 +0000 (UTC)
Message-ID: <c2c9b136-fe21-432f-9ec9-42382e6f0a69@acm.org>
Date: Wed, 15 Oct 2025 09:35:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 05/20] blk-mq: Run all hwqs for sq scheds if write
 pipelining is enabled
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-6-bvanassche@acm.org>
 <9c8923cb-2c1b-4d04-b1ba-796472ce8c53@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9c8923cb-2c1b-4d04-b1ba-796472ce8c53@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/25 12:25 AM, Damien Le Moal wrote:
> On 2025/10/15 6:54, Bart Van Assche wrote:
>> @@ -2412,6 +2411,11 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
>>   	if (!blk_queue_sq_sched(q))
>>   		return NULL;
>>   
>> +	if (blk_queue_is_zoned(q) && blk_pipeline_zwr(q) &&
>> +	    test_bit(ELEVATOR_FLAG_SUPPORTS_ZONED_WRITE_PIPELINING,
>> +		     &q->elevator->flags))
> 
> The above test_bit() is already done in blk_pipeline_zwr().

Thanks for the feedback. I will drop this test_bit() call.

Bart.
