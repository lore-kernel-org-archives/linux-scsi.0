Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3412621D5B6;
	Mon,  7 Jul 2025 21:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751922860; cv=none; b=F+fiFLU5YKtYkO3TzEj2AFyXlkHpxd1NsDFVlWq0LcBOQHJ7Nt6WURP0ZQno14P7bCNY+3YrmwXGur0r5UA/qLPQKPL4qKB1Lsckc5DW229E1JWU6mG1UdzR+D/8vVD3nfne08fC0QZfci5rMtaRX3WKMQzOnTttwbPkX4OWmOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751922860; c=relaxed/simple;
	bh=Fjap2xSsko+w7KDhnAl893n5tTyw2ZbP1/ejRaKFNsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lrB6Ayv7bhyPvKMfYXlMaRvR0f9HtLhsKW6xdALLxUPCGgX4KEgww0NaAjULuAUDZ1xPvcG1EI1v/JhlVMcpymBUkq0HZxt0zv6qdr/YGo6/IdPrO6C0k2EBSxigWZ05YAAi+6ZD1agCdLFXi5zOkZ70uQDVn0T7vbsKyw/aA1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BYO/exIX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BYO/exIX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bbcSB0pgWzm0ySc;
	Mon,  7 Jul 2025 21:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751922856; x=1754514857; bh=wJKxG0xSrrtCdoNKRmX5ZL91
	1r/pXL8iTzwGCux5+0M=; b=BYO/exIXQCxPdys7x3kUJPYqACqiPB3/q+nbJtJ1
	k51wiRg1PPX8ZP+iLemGCDyGGAvt3FRTdAJnwySJDZ+nG65IMh2C2kXCtOr9Qtj1
	KytrYNz+B2NA5Pjc8whxIa6iDD0Og1uP9ZnjXJ8hOeW2N+gXMqsaRqp/pds7ymX5
	2yFopCEcYBCkeh2WAjMVAvf63/gIRkQHg7oIjbJ1aPrisPYxEIh/aX+p2NV9xQRB
	uwtUZXP2qTZKElw67uglgrqC8+hIpNct7LZmn+xjm71D+4Evcviwx3mM3ArFY6Eu
	yCwUKe8iYswrbAHFTGgSwJlKB24wsUpCM+c4xLAnJFJNyw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tSbmb0RguPMQ; Mon,  7 Jul 2025 21:14:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bbcS336Yrzm0ySG;
	Mon,  7 Jul 2025 21:14:10 +0000 (UTC)
Message-ID: <38a74ff2-1aa1-4119-9fbb-e18b8d796ba3@acm.org>
Date: Mon, 7 Jul 2025 14:14:09 -0700
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

Not all device mapper drivers preserve the bio order. The above code
allows device mapper drivers to declare whether or not the bio order is
preserved. The suggested alternative implements a different behavior,
namely that the driver at the top of the stack inherits the behavior
from the bottommost driver. I prefer to keep the above code.

Thanks,

Bart.
