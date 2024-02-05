Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3D4CE11;
	Mon,  5 Feb 2024 23:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707176555; cv=none; b=TdgOPdpka79X/u3UnbJmpvGhLOAHHwItH+sN1YR73SnO4xwugyCkrqwoCsPnHyuoHCd+r8hHNrl8tyCHRy89EwJy47HE2oXFzmewoZZxEeqSeDYnnmUPVgffbeaROnZfRa98CAe+M+3GfHOcTEmm3euokZJR33F4m6cn50NQHe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707176555; c=relaxed/simple;
	bh=wd40x1v+SPVp2OE8+TMFmj0g60/oTey0Ksn4EwwsPFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNGBwjYV+KyQBXV6vB8fwHvgIiZ2WiYupsIundPaTqC5tHU8vDjTh3PKBeXlnnMfe3fojrKtYYm/0vLM8puRzzyKLJlkX/zed0ySXY+jawX+QAYcImAH8BKO1r3+nME/Aq0uJtSugvLhKkNsDs9Hnyv/V4O0pyKXyw+G5ckjZe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGFzZNnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGFzZNnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F8FC433F1;
	Mon,  5 Feb 2024 23:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707176555;
	bh=wd40x1v+SPVp2OE8+TMFmj0g60/oTey0Ksn4EwwsPFM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JGFzZNnlMzOPkj4QQOnWqLB3sabQnT2yQTZoOWdkB+chjTAogN+i5a58OgXAOUr7f
	 inN+J/BpuWVHfsgtUSLebpYwpQKfZqI3VChSMTrfIJ1uWFo6AfJRcFRFEMnAQe30tz
	 EEPsPL4PWjKfe9aaW446mveiyP2wTf3Iss6lcSzYabp3PzQyddPsPXgr95mP0ypPNN
	 WUOU8a8irPT9SMihrJbUx8Hjs6zYgfTlHdOkN62sRt4aD62iDgiM13dSi5xDoWZgR+
	 XpRYW5iljvYWkdW13dpEYon2OXZ12YQ6jUJImOx+LbQBhkrkaf/Bsk2iufTSNHchQN
	 MpWJ2BiNjk4eA==
Message-ID: <02b70ef3-259f-4adc-b2c6-c77e90f19507@kernel.org>
Date: Tue, 6 Feb 2024 08:42:33 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/26] block: Restore sector of flush requests
Content-Language: en-US
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-2-dlemoal@kernel.org>
 <7a326c42-5839-4487-9a5c-db35a4ee03d4@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7a326c42-5839-4487-9a5c-db35a4ee03d4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/24 02:22, Bart Van Assche wrote:
> On 2/1/24 23:30, Damien Le Moal wrote:
>> diff --git a/block/blk-flush.c b/block/blk-flush.c
>> index b0f314f4bc14..2f58ae018464 100644
>> --- a/block/blk-flush.c
>> +++ b/block/blk-flush.c
>> @@ -130,6 +130,7 @@ static void blk_flush_restore_request(struct request *rq)
>>   	 * original @rq->bio.  Restore it.
>>   	 */
>>   	rq->bio = rq->biotail;
>> +	rq->__sector = rq->bio->bi_iter.bi_sector;
> 
> Hmm ... is it guaranteed that rq->bio != NULL in this context?

Yes.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

