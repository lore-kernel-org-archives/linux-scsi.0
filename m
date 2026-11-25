Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795644957;
	b=YfMVw+btzLUAxNXvKlxRveCr4DJLWiQCtZBeB6VH0uIdSAyA9Jd0huGIOHp7tD6EiUwg
	 l1YvCcuzm7vzWvEoLYrVfhtZ89W7lt2c32N7wosHW8Ufwvb4fhoNQ1oUF3YAx7OMVWLkI
	 42N+y1bEqYV+Kqn8YvSWdnn0yCWkIx9RsPPjGKR3VJtblgMpon+FBa51U85ITThiIN00p
	 cZ0RoQLJ5EjLss8gK0DYMqrKHW4KZCf3T9hwmOVWIqfwNSXNaLCBQxZ2JUhTYCUqk4OCE
	 Ve6S7+Ruv58h2PTC/GHJlNTqwji2KWr86jGdbV60t2A8kmThVVNM1sKTRkr3z+Grahw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795644957;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=d4ptN/8XrX9ZMKz3hQVofK7j9WySlHwfLfQLMr46Vbk=;
	b=olW8zZiuZbCUDB9Dhpdx/9y0GOPZzRMTHgY/J78NpPPqstkmswxPkBzooxk3BegXzJ+C
	 IUvFsJ1OrXSq/HYsjdbm3QDDIwe+lUVfXCE0RMU4qJn1je8HadugODvVicwyu30GccaUF
	 i/AHYHrxQzvestDdcP8wOwllXkFAvBB8Ohemg6acN6IfNCfQd4HyFUVyTHSwQ6xlr+ZPa
	 boDkVBQ5eMaQVfSETijx3oz4LBdcjanAk0y4LW8dSfQxaP9zCZfmjr9SZ100fX2sk7QyJ
	 T1wFkYf2wWC1Rk151Uxs97UQ43m4mG5wZypTsgATr3KeRiz6G5lWc5iXeKqdvsx0jAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2qUPoqu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889F1606A321
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 22:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q2qUPoqu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD11F000C4;
	Wed, 25 Nov 2026 22:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795644956;
	bh=d4ptN/8XrX9ZMKz3hQVofK7j9WySlHwfLfQLMr46Vbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q2qUPoqu3F8CDMYa3e1Lijo0KYSnvHiKvGrpHJ7qJj2dtFvJbnbSDEB4HXDadu9X7
	 A6WWgDxozJ+SiTBAgrAffKqEnO0b3p79GtCPWPQlCa+p92jN3Q7fXfbdV5WqdgWagp
	 KMyOmuWKH8gWb7DHqxHRKnK9SY6V7wNgWFG1sQufpdnp2UYhokt0CG8x0lohg6ogrv
	 dfzkSmIRcVm/6z6NMs66ir/Ro/D0ZCH/foyPqPVo/ebE5nFYKcvmPUVnsnn1wNrYpe
	 DZWdq33hhqGKRuGHXUq7ZVidNLkBRnM9wOLudkevpCxWHIeH1U7wEn2aP2IgLvcI+G
	 Pjx+WU7NwnPhQ==
Message-ID: <cc627606-0760-4bee-89e1-001c89f999b5@kernel.org>
Date: Thu, 26 Nov 2026 07:15:54 +0900
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: trace: print the CDL duration limit descriptor
 index
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
References: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261124124137.146673-1-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/26 21:41, Johannes Thumshirn wrote:
> Print the duration limit descriptor index (DLD) of READ(16), WRITE(16),
> READ(32) and WRITE(32) commands in the SCSI command tracing, so it can be
> seen which command duration limit a command was issued with.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
