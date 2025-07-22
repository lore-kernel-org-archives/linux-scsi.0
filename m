Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A91277814;
	Tue, 22 Jul 2025 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753208664; cv=none; b=KJN/B0SnGIpfTHObQ4v90dmTyClQ/boN2tKrv+NFtHi39nEww+1unS4rBC+12UCuECUM9TXysFcNS2W+hshz9Zul1vB1vf+JhhcIT1CNP9y2RA03hvTkz/oiqzWilcpRgoS/CrLzbyAxC+ZBeKZr2EZM4ZVjur5OjlU01guLse4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753208664; c=relaxed/simple;
	bh=RXiPFcZP8YUTo92NZjVWSXznAJZMUgm+hGMeoQQ9Iro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3ZdbevOc9uDC4Xz2vRhXyaCYmg1Iw6aPYnbCDChvyk+zSC5qJwCO9AWm5nQTytya4CnwmAFWLik/vYaLkd18c0iGcz3smY4MwL9vVuqwQ5YHBoxvHyjEcjFtLmK2e8qJ8h+PtjfXSXS77Rhm6idVMWrqB8Ke3M+4bVFMXsyp88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RefWCW36; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RefWCW36"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bmlz865xzzm174s;
	Tue, 22 Jul 2025 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753208659; x=1755800660; bh=zzEnckDP0s5joNArOYWQ1Wec
	QVDJVDnNtd2cMJQIlE0=; b=RefWCW36zINMyHslA4PPBCsT94mJW+hp7Dq5t8D5
	lrvPA1djP+UgRDx9UnEfYRuPPEBMIcjEJnZ4OZXTgQPqpUCrSgXe7VzDaPo+mtLK
	WTWgNpuZ65d+uGfYuDJDznu3HFMYy6cD+1B6hhjOOmVZXQCRaKrhNnEtrv6eDwVB
	bYtapICAaDCZCOxyjtHt3jQGFCSDShllBYGPXVko/nNURTbGNw2utFbanFN2hgQE
	IYxNzvVjkMur7yaZMkg+ZiOVUX1vmQiDMq43y/sj6FEEXzcnYbOMayM2F5RpS4J7
	Y4ies26ZGI3j0feZwwYrHHMm4xCfSKYh71AdTOXIyDY+dA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CKuryHqZYAHs; Tue, 22 Jul 2025 18:24:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bmlz30jkszm174B;
	Tue, 22 Jul 2025 18:24:14 +0000 (UTC)
Message-ID: <889b483a-e7ff-45c4-aa6e-e7d4e6aa2a44@acm.org>
Date: Tue, 22 Jul 2025 11:24:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 00/12] Improve write performance for zoned UFS devices
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <f1b3060c-f951-4184-886c-87ba812986a7@kernel.org>
 <754540df-0039-47b5-ab60-44d6c4f7ac5a@acm.org>
 <15e63230-6e18-4581-a60a-a77bc3b57721@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <15e63230-6e18-4581-a60a-a77bc3b57721@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/25 6:36 PM, Damien Le Moal wrote:
> I would really prefer something that does not cause such submission 
> errors to be sure that if we see an error, it is due to the a user
> bug (user sending unaligned writes).

Hi Damien,

I will look into this.

Thanks,

Bart.
