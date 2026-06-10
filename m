Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F371425CCE;
	Wed, 10 Jun 2026 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781107411; cv=none; b=X4uYeKjLIQyZ6PZh8WmnGm/tzcLb2ylC5zjMn88vn7sN51LaIJnXMMd8NS1O4CJvUKZAxggZemM6j+lzYfQAR+U4YXhwStAaWqhYz26S/fov5qUyNlmRMchmxvi4lcboLaXUzhDEPRvLIYft2usqgcYOZ1ST13VShHO4ihNSXwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781107411; c=relaxed/simple;
	bh=oTJPm08EzzAuncfkXNtJ44afjWHqp8T8eunHcsQwgW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ixGFW37t/LbiqpjnkMl+giOSQ57z3dLpqfOZ4+IMEJB8PrynxuBrX7dTKrrOgzMWfTI9XtjPdW8Wo1NxKhW9tgYZEkQU+dIWDW5fii+7Q3EeAMDz1tIyuvMXBapjZNqr5JVqVZYrH8v2M1YF4MX2Ygj1562bQ07EVVsdXvVFRyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pK3gccuG; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pK3gccuG"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gb9YY4Kltzlfl5d;
	Wed, 10 Jun 2026 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781107404; x=1783699405; bh=oTJPm08EzzAuncfkXNtJ44af
	jWHqp8T8eunHcsQwgW4=; b=pK3gccuGizJzNi7VdSbv3WnCrxw7h/9I6SvTZI7W
	+zoBmr1giaSbBku+IU9OKDkxFPC+U/X+ipsZgUkTRGEvJSY0zvPaiTO45MG5HGmz
	7CO/+116RXwOr8Xi5K29COZGcgeufPdzxa7LWekSLPIXLMUVTFgYIJRaIzUsK4sK
	IiiedXD5rsIz3HKUDdCyKQE3VHQ/nOBomy56ypiEUaK7kuzYHq5BSMYgSgKrfNsY
	Lkpjwt6YI2tMmnFRItsXWJnga0K1K0YZGd9KF++2bVWTcob6IFisVeDP37Lwn+9V
	AOTjBOCiLui8PK5T8hqOhyxBwMdKa089+60AQxQ8E+DuHw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oSw0lJntkkcB; Wed, 10 Jun 2026 16:03:24 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gb9YN6Ts8zlfvq4;
	Wed, 10 Jun 2026 16:03:20 +0000 (UTC)
Message-ID: <64525fc7-6bef-47d7-b8e1-dd92d2c27e7a@acm.org>
Date: Wed, 10 Jun 2026 09:03:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] block: drop shared-tag fairness throttling
To: open-iscsi@googlegroups.com, Christoph Hellwig <hch@infradead.org>,
 Sumit Saxena <sumit.saxena@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-4-sumit.saxena@broadcom.com>
 <aikAs4X-2NWTuwCc@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aikAs4X-2NWTuwCc@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/9/26 11:14 PM, Christoph Hellwig wrote:
> Just dropping the fairness was rejected before and there is no
> explanation here on why any of that has changed.
Hmm ... has anyone ever rejected this patch? Jens' latest feedback
(May 2024) is available here:
https://lore.kernel.org/linux-block/7a69eba2-42e4-4c67-8a54-37b5b41675f9@kernel.dk/

Thanks,

Bart.
