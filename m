Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A2813B58D;
	Fri, 29 Mar 2024 21:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748117; cv=none; b=P4xGfoUiyC62OFAe0qrTN/jIlEmeNwKIOZ1xA1TED9vjBOz/hWxpz/KtXRUDkbvQHsquT3X+heqeEVY4y1/kCdGejMX7qjAeeowNYGEfsppC0OfXQFgx30RbyZn8biTA5Eos4l76l8fyM2Di6SumCJwMoKwWobe9i7nDtnUVBuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748117; c=relaxed/simple;
	bh=26INcwOY+8rdF16imgJpkzsJBkuL3BOYplHSIQZ4WFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cBegC5NTApQI26WxnvaesFi6RN8wTz8b2o0LAbE1qUv+nM6i6HfnraeLgc0dPS5Get5w9rhbuKwKAUTo9fDpFtpf5i6YfP8N2Asl6FsPn9dJkGCXecXMxXI8lX1Va5RuF2txNUFk1MrnkK1J0tMYdKEagJDf1ednC99MD1X1Sxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lmK85EaC; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lmK85EaC"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5twz1KmkzlgVnN;
	Fri, 29 Mar 2024 21:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711748112; x=1714340113; bh=8mmuXfxqAGob0U9v+vaAkabl
	mgwKdRtFtFZl+vh9Eh0=; b=lmK85EaCDIoKCLNiWhIl2IcvXJq+g8ZjH+4SamGh
	V6XDFuPUZ9ShkFZzsHgg2AXlfYMN7opRw9uk+f7xdv7QbQQl5Xy+hkHTqcn2spg8
	8DYZiqY5TjFxWDUkUbDuCreFPZp4tnFFq4NM5/ShYext/XQW2whEmufi8xWL1P/W
	BnmJShz/gpdkT9SmXvzzyIKLk/i1KigJt9qrZJNlKWw3fShZY3Vi+3wqVYhli59j
	44qv0L2RsmAewAXpQLBzDUThpfdLJBxXAfkHde7fXE6FSj0il++CkBXB1a+aUfn4
	5x1jGsQQDHgjz3yosAlV8aI17ZhqU74qynY+vG4kUMfAbg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GpA9PQ9iA98h; Fri, 29 Mar 2024 21:35:12 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tws56cjzlgTGW;
	Fri, 29 Mar 2024 21:35:09 +0000 (UTC)
Message-ID: <20897217-2eae-44f8-9873-43d8898ecf43@acm.org>
Date: Fri, 29 Mar 2024 14:35:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 18/30] null_blk: Introduce zone_append_max_sectors
 attribute
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-19-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> @@ -1953,7 +1961,7 @@ static int null_add_dev(struct nullb_device *dev)
>   
>   	rv = add_disk(nullb->disk);
>   	if (rv)
> -		goto out_ida_free;
> +		goto out_cleanup_zone;
>   

The above change is unrelated to the introduction of
zone_append_max_sectors and hence should not be in this patch.
Additionally, the order of cleanup actions in the error path seems
wrong to me. null_init_zoned_dev() is called before blk_mq_alloc_disk().
Hence, the put_disk() call in the error path should occur before the
null_free_zoned_dev() call.

Thanks,

Bart.
