Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4280A1448DC;
	Tue, 19 Nov 2024 19:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732043341; cv=none; b=tnuRuTjjz/BC3FkMtVAOy0OAQuaHLNP8Ti1jbpuvhiyiRw51A5FG3B2V14rv46seYpJ5XULOr0nhwaxmRekcZmTBV9uVkjQsVoIfxKSL2rHeqNc3dgoU8QALpv/meaNChZ/Y/GS+XWrZfZx/opuXbBkyYwtJsiigYAOsQ9UtHec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732043341; c=relaxed/simple;
	bh=MkHxwzS+pHbevNSM/MzUMObE4uUmjSw/2/09ZbaMz1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gCD6EotrMfjZ154ARwt5u1IEvKNUXDPdRrVcwpSlEe5eZi8PrKHnHJYEn0iWslqveGwJnp2p2npv5dtUGScBLlNvgQW0ej3sBrLxgVV775La5RLwS1atqLTGjvbWGZCFF7J27YPrYY64/SSjTklIuMD3CLAxDbKBeb17Ur26zRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0EiugfpC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0EiugfpC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XtDYd4hpBz6CmQwP;
	Tue, 19 Nov 2024 19:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732043330; x=1734635331; bh=MkHxwzS+pHbevNSM/MzUMObE
	4uUmjSw/2/09ZbaMz1E=; b=0EiugfpCo2NbY77AnXC+Bsd+pof/mqnp747kSTqF
	3/hSr63X30WzZObv7RAEAqxr8A3ITb5cjkPSC0JIddRPBmEICtQxYBgs07l1fdIo
	7y+xBY0qkdiY7kYjw7FIZGS6823C1i9EDG1VrYAnBL4n3sq0dfgy1Y7kskAy/C3S
	XBpguS8aP9e+wgtRcNkxID14usV6CbLTQS/KX5D4Sy/e+X2XqlYTr0g5VfR+Nk2b
	UDY9sq1mf4UBsmyW5n3qOaTNYrCr4EZK5OPCkqXqHC2T7ZXsKiobiqoGcou/Z2IN
	tSi6TOhv0/r/m+Gsiob1bjVi1hiNySa8oL263PeNspPWsQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fm4lxvdUH_Ci; Tue, 19 Nov 2024 19:08:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XtDYX4NHHz6Cnv3Q;
	Tue, 19 Nov 2024 19:08:48 +0000 (UTC)
Message-ID: <de43ae13-240a-4653-b8ac-f36c433d9ffb@acm.org>
Date: Tue, 19 Nov 2024 11:08:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <95ab028e-6cf7-474e-aa33-37ab3bccd078@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 12:01 AM, Damien Le Moal wrote:
> Impressive improvements but the changes are rather invasive. Have you tried
> simpler solution like forcing unplugging a zone write plug from the driver once
> a command is passed to the driver and the driver did not reject it ? It seems
> like this would make everything simpler on the block layer side. But I am not
> sure if the performance gains would be the same.

Hi Damien,

I'm not sure that the approach of submitting a new zoned write if the
driver did not reject the previous write would result in a simpler
solution. SCSI devices are allowed to respond to any command with a unit
attention instead of processing the command. If a unit attention is
reported, the SCSI core requeues the command. In other words, even with
this approach, proper support for requeued zoned writes in the block
layer is required.

Additionally, that approach is not compatible with using .queue_rqs().
While the SCSI core does not yet support a .queue_rqs() callback, I
think it would be good to have this support in the SCSI core.

If we need requeuing support anyway, why to select an approach that
probably will result in lower performance than what has been implemented
in this patch series?

Thanks,

Bart.
