Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CFA1DF97C;
	Fri, 22 Nov 2024 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732299639; cv=none; b=RGB9toori5rZh4oLcQch6xEZ0+fljLuvDKwiADDAl3tyiHK1LPyP/vJU1tHh9lKLkdxeh2BMpPYlJ7P0CUKPg0bEtGuWSYmE7I8YqBgBW0fJqpWygTboXhT/kDwgpixl7GVWVkBQWCHM1ASzSkrNp1MdduWF/Zc+71uQG7XS0js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732299639; c=relaxed/simple;
	bh=WnliFglmUfZeWNLF2kN4Yt+995PvKostfOMpqFxOexs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1ODOLC6BkJ9Nz07Fi3jwVyjNYHa7IMZ8SqgbIIV2a2h4nCWsfMRek1QYF8glPgnZKI9HifZXaL+xxOQ/1T54MDCP/YcGg8QbnzywRCK65z7kU7CAmz6u22Mx7NMmD+ingSbsERn9GkU4Putv0lUW+UqZiY+kHDUy7Nl4ExecqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RnPA3kY8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RnPA3kY8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xw3LR4mGZzlgMVS;
	Fri, 22 Nov 2024 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732299628; x=1734891629; bh=xGwZPVbAGLVdk9OY447HfJib
	RxdKJ1Ggqw1YBrON7Ts=; b=RnPA3kY830DsYlvbNuBVVIvjBZcsN2dcjzjknuiy
	f17B3qw1/2qKQUGJvjQxrcljkII8tF+KdTk5EI1nBfCo4KHQnK767HIjxFYhfcEo
	ZybduC8pJXYMwHQMUZ0bBMy6+RbOy6Il92L8uNg3G9ILqm0jWxqHK3oL1NMOD9+K
	/DQHcIUUxzSwPMzXLI2H2vJMOT06LeElWw4hurHarWLLZgGbS3u1V6U1Cx8lZz4T
	K0NwGVKEvvcng2G14nntkxIZ9MCg98KiQmt9E3GzJX41C2YSkCufSS7YIjuBmL2N
	dVs9Za2YSedaZp6A5ZIQwBTfDeTcuTwXifYl2aABUJFxTA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wUOjuKAzGPkT; Fri, 22 Nov 2024 18:20:28 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xw3LL0V1ZzlgMVP;
	Fri, 22 Nov 2024 18:20:25 +0000 (UTC)
Message-ID: <82649541-7db9-4b50-a1e1-e38a9078761c@acm.org>
Date: Fri, 22 Nov 2024 10:20:24 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 26/26] scsi: ufs: Inform the block layer about write
 ordering
To: Can Guo <quic_cang@quicinc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, "Bao D. Nguyen"
 <quic_nguyenb@quicinc.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Avri Altman <avri.altman@wdc.com>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-27-bvanassche@acm.org>
 <37f95f44-ab1d-20db-e0c7-94946cb9d4eb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <37f95f44-ab1d-20db-e0c7-94946cb9d4eb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 6:58 PM, Can Guo wrote:
> So, in MCQ mode, we are re-directing all zoned writes to one HW queue to 
> preserve the write order, is my understanding correct?
That's somewhat but not entirely correct. As one can see in patch 20/26,
the software queue (and hence also the hardware queue) that was selected
for zoned writes is unselected after all pending zoned writes for a
given zone have completed:

+	if (refcount_read(&zwplug->ref) == 2)
+		zwplug->swq_cpu = -1;

So the next time a write bio or write request is submitted a different
queue may be selected.

Thanks,

Bart.
