Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165514A60C;
	Tue, 19 Nov 2024 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732051124; cv=none; b=tX+GHpg3zVtgZzCQmXMODmGEq2Cc9e8FV+/vm/cJ6QzwLGAZj8HCTlMUuW1pmls6mKmDKK8jineTV+hnUXs62ZlKQkJBlTO7/22INQ96+uj5ceqyh2Rbb5CH8MQ1oht/QrVXb10hIUm2YHXy4ht0MW6z002VcaAg5ptJeqo6jyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732051124; c=relaxed/simple;
	bh=jK2L1+Gvrtkj3DmQ1i/SumhfpwZ2iXL2E8VSHiqVm0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bFDPM8A3xiamZRjX/8p/JkY4MFrXQrMQPL4ZUMvN6N66wRTahLB2XXhU7TzuVg6t4/wcZWIUUN/VhHI5eTXsSo+8R3EP5ZyClqBPQwwHXTOiyvNrou/1X3ml4qQ1polaxS2c3K8vwKzivdqGdymZXbKdydUTTzKWrKVIAJY3w6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HzuMcRw0; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HzuMcRw0"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtHRQ2kGpzlgTWM;
	Tue, 19 Nov 2024 21:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732051120; x=1734643121; bh=0XX4Mcl76VCzWKpHilLlkyOA
	z1ZK4DUTi3UDqXrC1Lk=; b=HzuMcRw0z2cSvOZQi3mh21qikkEGEWkC0kT+o1XJ
	Gw1n5v1bmgNvnnkWLUUjJKMKYNoQaPLBMyKHXiPTdyUnnBgdE1xJ5PBuuCTie0LU
	n9tQ+JyCXxvsXfMGQgMv+yqNsd0uL6AiA+lbmgHrgvi0tDdjfRWSO3vQIA6iRFf2
	sfl0PZOXtjmBrwzG95C+flpf1NHl05C+F5n9eOZeSg1QMY2lt/3E+EyomR1fp8jT
	PeUnsun7k04ixgOFvvdMR4mngYbTVEhzClB0+W5Ym4zrKC9RaIvLcnpi5MC8PmW+
	RXlaKmQV1WgfBlfnVmrG1EeT8spa3UigTx18T9eEKGm3Tg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E8Xt6hdzUtU5; Tue, 19 Nov 2024 21:18:40 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtHRL5TmhzlgTWG;
	Tue, 19 Nov 2024 21:18:38 +0000 (UTC)
Message-ID: <2aca0072-cfa9-4929-addb-cc28560f2786@acm.org>
Date: Tue, 19 Nov 2024 13:18:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 16/26] blk-zoned: Document locking assumptions
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-17-bvanassche@acm.org>
 <9defe57a-8a40-4f63-85d8-b30f4da79768@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9defe57a-8a40-4f63-85d8-b30f4da79768@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 11:53 PM, Damien Le Moal wrote:
> On 11/19/24 09:28, Bart Van Assche wrote:
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> The patch title seems incorrect. This is not documenting anything but adding
> lockdep checks.

Hmm ... what this patch does is to document what the locking assumptions
are for the modified functions. So I'm not sure why the patch title is
considered incorrect?

Thanks,

Bart.

