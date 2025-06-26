Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAABD2FF;
	Thu, 26 Jun 2025 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750958173; cv=none; b=dItKUEkuFK/FGvKiWGH9rBWzfANiinStlUlmYWQaQqVvERlorcAay3UYwqsE4XMd64tRjWbMUNBndKMDMRK8cip+MhFn64vyWseAoWOMcsRfUcLzEBvwoRJAYm5FS0D2svtNwpGrtSWkQ5xCH3HVVSHyPK8pA4joRPLfarLNkUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750958173; c=relaxed/simple;
	bh=22GUUNyyHzdLy3gQcp9Q12+bBTiN/dmjUrVHPiY4a9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U312ieAULMjiNQ3t36y7V9ZFLJCtKedUOnjxqh/dmq70pKmnkGcTq21EskMO/XZxTaCdcrzBtmOOEToP3MFT1xiHdWFjhIY8qu36iJuJPNFooVYd7GHEaroqGXuMbVfSukCxItCVZTO2oa+mtvkezcZV8MXUdiUjXxmOTF+D/js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BsTx/hXw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BsTx/hXw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bSlhT5ykYzm0pKZ;
	Thu, 26 Jun 2025 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750958168; x=1753550169; bh=22GUUNyyHzdLy3gQcp9Q12+b
	BTiN/dmjUrVHPiY4a9E=; b=BsTx/hXwFaGZccE97lwR6Fl5gEwjaScZCoXgXmCo
	wFwG1ZMPuoRNqbooEkTZ4u9JiCgd48h9XSsbHST1pibTrFKivNzJbbhGbpbHZGUv
	ls7qnG/23X2beJ2liSIH+cl1goxUKjtXkdjJNVhu45p0bQFY+9KHCmvXmtv1sghw
	uo/DLE2CiGUYzqHJnTKNiCOJSrjG74iS4rLWRxRiV5zLajFqFQ0YUmFGZRVUWmJa
	jGzG19BGu5nx8RPtoIM1maok9O2CuA7wM3qocexvojm53m2N2UsubnC2nTB9esQw
	36hK57WFfwTeuBSBQR8ZMzZYPXMPh4KSc/+e5zXrfZZ7ZA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RqnSB6YLdNNl; Thu, 26 Jun 2025 17:16:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bSlhP2ngJzm0pL2;
	Thu, 26 Jun 2025 17:16:04 +0000 (UTC)
Message-ID: <8b3c4594-fdd2-4387-9242-f122839a7f83@acm.org>
Date: Thu, 26 Jun 2025 10:16:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 05/12] blk-zoned: Add an argument to
 blk_zone_plug_bio()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-6-bvanassche@acm.org>
 <92be4ac8-df7c-440f-af6c-df611ecddb76@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <92be4ac8-df7c-440f-af6c-df611ecddb76@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 5:15 PM, Damien Le Moal wrote:
> I suspect it is to handle the case where a submitter changes CPU when issuing
> writes to a zone.

Yes, that's correct.

> But if that is the case, you should be able to hide that
> explicit CPU choice within the blk-zoned code instead of exposing it through the
> API. E.g.: plug the bio and schedule the BIO work to run on the CPU you want.

The purpose of this patch series is to process zoned writes faster for
storage controllers and devices that preserve the write order per queue.
Adding this kind of overhead in the hot path would make write processing
slower for UFS devices instead of faster and hence is unacceptable.

Bart.
