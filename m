Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C7C216A21;
	Tue, 12 Nov 2024 18:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436330; cv=none; b=QpbSkuABWy7Fiw/DTG8nQ7mYWib69gB3TPxBkiLbYlj416CmcMn2QdyrUNw0jjq/jrFbRIlBAYVu4ZCHTnLCzIEttlB3fege6oUWiZVyb9EvVenK5aEXG4Y273gELY4sO0TPCZGfeCqzNOx/L5/UOG8713C6Nbv7WOSQqL2rX5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436330; c=relaxed/simple;
	bh=YMXgxzHVe2Twj7UmMuZugISZzQj+zZOPwPMCKCpMZGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gUUXIOVn5inF8R6Zh54Blp/H9fc2zLAs4LhYNE4Zn/hBQhItFayXUl0tlUAm3okaYhlDtiPQiiuN0s0oT6xmOCMCAamqS9+fGGJ/60riXyvnRLuqwbNbAPYLyuBCGP7xKvsmStDEnOnfEnYVhXIGOf+Uw7PQw9OSmOgA1dNx1L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wu0m03KD; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wu0m03KD"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xnw4S3Xw9z6ClbFS;
	Tue, 12 Nov 2024 18:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731436326; x=1734028327; bh=sOBy4bM0+J8kckG32n1p5z2G
	JWi3f4fQJe1tWAyzuZY=; b=wu0m03KDQNZpnU7uMVwpkeZSvX5rBy4PkbSS4qE+
	EgPTlmgchwR7aKXdHVg1UEvzMwLYo0YUgWWopZteAScVU/P7KbRp8ZiRnE7oL1F0
	oqN20crGpEdsEMiDJlh51o+MQAQisQ0Rzsly82gsWZgUlRAw9G8UpzGfielk6gJK
	hGpzisx9FEgTaLS2boPGddrsvuCswbOhYIaUFMpnaSGz0X6TP0iuUioz+asvW27l
	ebX7jnqgmXH1w2x48Lu+1WwNpIIJOyoNQU/UcaEfyqqk01d1Pw5wxk8U3/j8oFXc
	rmCvBbhWRYOUmg8BHTmMybbjRaCS+fRjKhauUi0Ak+55Qg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cNJLcPKfc7zu; Tue, 12 Nov 2024 18:32:06 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xnw4N73JKz6CmQwT;
	Tue, 12 Nov 2024 18:32:04 +0000 (UTC)
Message-ID: <79c475f2-cb1b-4aaa-b87d-99ed85c7556f@acm.org>
Date: Tue, 12 Nov 2024 10:32:02 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] block: remove the ioprio field from struct request
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20241112170050.1612998-1-hch@lst.de>
 <20241112170050.1612998-3-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241112170050.1612998-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 9:00 AM, Christoph Hellwig wrote:
> The request ioprio is only initialized from the first attached bio,
> so requests without a bio already never set it.  Directly use the
> bio field instead.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
