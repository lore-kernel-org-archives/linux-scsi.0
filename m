Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1341991C9;
	Fri, 11 Jul 2025 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752270156; cv=none; b=n2zwUTV1GH3uK3Y7g/E2JHSkKxeP6Ec/huP5SC5b0BMw3DrnJtVJ7tLu7pvYyLlOViubWzkZ3MTzPTb3L3+5zo1yxWdxQN7N+7HKdyHFhBGv1s8gVQScjzG6jCrNFzhSlQtLjVf13bVlmtLCm4uiXtPyrkMePIOydNAi3iN5lPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752270156; c=relaxed/simple;
	bh=HlGNRHlqbdFhn/2cFmzlGSkoeIkuuhm1Aepa6F2dRvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ns4D1OqmPYX+wjBNdHcmY44gb2OnRd8+im9Q7naFg5F7RhbWn1lHsY4LVaT3uvd3VpuGKWJKXoxVoVJpIFgcAojnNOh6JuypIrPTawnuGvImC1xp4uZ963ZxGGTTwGSJJTx+KuYkp92B5/E2Bx9ft5+iSckG/Eep7QtA5XyirXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vP4pWF6A; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vP4pWF6A"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bf4tx4Ftczm0yTg;
	Fri, 11 Jul 2025 21:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752270152; x=1754862153; bh=11+WtG58jM6hfL3QHapg96Ql
	YWxfuHB3PBCg5gAXPyA=; b=vP4pWF6A8BVzJ8GPZRKlBFyl2fuSlfz4IfTV4Rqn
	zD82aiTGo5ovWHNChFucItvBqQdfKG7pBiqJrTA7WtPQIrsVS2Z4J3bHQES76o43
	PVhCgWoEG9vXaO39EfeEsbNE0n87qWtBgyjxgmhyzgHJ4c0lg5pt8QUyAP3NMu+8
	M1Yjq4PchwfBd5wg9/u5pclTGU7SQzLj1qZ7UY36c0FI+ruOHZKGR3/ktV5PpJWW
	lS9PN9t1bvVjpJBtmsgQa9ODfak9zJ0x3yRdGketR1e0xMOywx/amd1Le/luuBlb
	zdBXkFAC+fbKmYBynNXZ3GnXSK/QNWIyJVhyPCt8qYEA3w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4LInP-km_g2c; Fri, 11 Jul 2025 21:42:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bf4ts3bYhzm0ytT;
	Fri, 11 Jul 2025 21:42:28 +0000 (UTC)
Message-ID: <946afbba-dde6-46d9-a2dc-e51f195aedc4@acm.org>
Date: Fri, 11 Jul 2025 14:42:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 05/13] blk-zoned: Move code from
 disk_zone_wplug_add_bio() into its caller
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250708220710.3897958-1-bvanassche@acm.org>
 <20250708220710.3897958-6-bvanassche@acm.org>
 <f612d306-f8bd-4e05-9fe2-936c00b2beb4@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f612d306-f8bd-4e05-9fe2-936c00b2beb4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/25 9:46 PM, Damien Le Moal wrote:
> On 7/9/25 7:07 AM, Bart Van Assche wrote:
>> Move the following code into the only caller of disk_zone_wplug_add_bio():
>>   - bio->bi_opf &= ~REQ_NOWAIT
>>   - wplug->flags |= BLK_ZONE_WPLUG_PLUGGED
>>   - The disk_zone_wplug_schedule_bio_work() call.
> 
> Please make sentences instead of copy-pasting code. We can see that in the
> patch itself.

Is this good enough?

Move the following code into the only caller of disk_zone_wplug_add_bio():
  - The code for clearing the REQ_NOWAIT flag.
  - The code that sets the BLK_ZONE_WPLUG_PLUGGED flag.
  - The disk_zone_wplug_schedule_bio_work() call.

>>   	/* If the zone is already plugged, add the BIO to the plug BIO list. */
>>   	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
>> -		goto plug;
>> +		goto queue_bio;
> 
> "queue_bio" is not a good name. Please make that "add_bio" or "plug_bio" to
> match the call to disk_zone_wplug_add_bio() done.

bio_list_add() adds BIOs at the end of zwplug->bio_list and
bio_list_pop() removes BIOs from the front of zwplug->bio_list. Hence,
zwplug->bio_list is used as a queue, isn't it? This is why I chose the
name "queue_bio". Anyway, if that label name isn't considered
good enough, how about changing it into "add_to_bio_list"?

Thanks,

Bart.
