Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC9E3196A5;
	Wed,  2 Jul 2025 15:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751471878; cv=none; b=VNDBBGyPNGEZxZVeeFZBI1GMszTytzy3xnYWodcdJ9MJCWsfRkRHYZbJ5kYwZPyGyhitJY0bPbov0psS1BILRaAK0cxjOWJAuELbJf/PI4T+r8BHk6OgLkBvKZHTp261yRPgtiYZCf06KahVJ+ZMg/x3oXZnWNBTtg8/oLW2is8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751471878; c=relaxed/simple;
	bh=gwye1teiaps5as9heCm9q+Sa7m2k7Xz9P8EnQdc1TTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iGbuzZ3l1NrF0cekZv7PQOr0ffMUIxqimNSDd7NLfH6QIEeitSOGUXoo5xVxgSQinmD7eSn/vQ+X/SkZBT3/GXzrrzhf+9pRRYspCEjxa93psIWzorxQM+zFBQUGgAHKNv6H7yqP2as2JCq8B9JxtzXYa7tZAaLMWIvCDlmVTpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZB3nXkxz; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZB3nXkxz"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bXPgS0Vngzm0bfy;
	Wed,  2 Jul 2025 15:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751471874; x=1754063875; bh=UV4hVlihWLKsw5JkHc7nVsGt
	SEDaoosSukurztYHhLM=; b=ZB3nXkxz8jUckSLVm69C+t/XQdVqK/27qQ3JN4HU
	0bHNq3Cgp+agA8SaMVRPaU73HPHCsbIk9OZ67y70A84V/K8ddWxtm4AMMDZfXHPX
	MLD598mRrSPPXJ7cMyzmNMCBB+s9KP2qaqXs3hhVSYmnagGpSce/1icdi7lzrJUO
	zksejbxP96eTblklCnXVYmHtHP88RhoYhHnWBK7hSGi/1EM5/zZjQs26LQtBfFDV
	CI+wzqwCSrtTXBiJn4eESOAfGvXlL5S4X+e6YkD+8+t3Ht8llOGiX5zFlulMmWa8
	vKwUidPUePP81XyDCiYcyIH2Cc2cHDzm/jkSVkJNtTQ7jQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8la--Wg9Dwew; Wed,  2 Jul 2025 15:57:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bXPgG6Ypczm0XC0;
	Wed,  2 Jul 2025 15:57:45 +0000 (UTC)
Message-ID: <a7b5b394-ed7d-4f57-96ba-ff14375b2e7b@acm.org>
Date: Wed, 2 Jul 2025 08:57:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 01/11] block: Support block drivers that preserve the
 order of write requests
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
 Nitesh Shetty <nj.shetty@samsung.com>, Ming Lei <ming.lei@redhat.com>
References: <20250630223003.2642594-1-bvanassche@acm.org>
 <20250630223003.2642594-2-bvanassche@acm.org>
 <0f9f5900-b7d0-4df2-8c05-fc147c991534@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0f9f5900-b7d0-4df2-8c05-fc147c991534@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/25 3:57 AM, Damien Le Moal wrote:
> On 7/1/25 07:29, Bart Van Assche wrote:
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index a000daafbfb4..bceb9a9cb5ba 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -814,6 +814,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   	}
>>   	t->max_secure_erase_sectors = min_not_zero(t->max_secure_erase_sectors,
>>   						   b->max_secure_erase_sectors);
>> +	t->driver_preserves_write_order = t->driver_preserves_write_order &&
>> +		b->driver_preserves_write_order;
> 
> Why not use a feature instead ? Stacking of the features does exactly this, no ?
> That would be less code and one less limit.

Hi Damien,

Thanks for the feedback. I will look into making this change.

Please also help with reviewing the other patches in this series.
Progress on this patch series has been slow so far because every time I
post this patch series reviewer feedback is provided on less than 10% of
the code in this patch series.

Thanks,

Bart.
