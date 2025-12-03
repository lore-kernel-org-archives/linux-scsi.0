Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4C6343D6E;
	Wed,  3 Dec 2025 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777477; cv=none; b=qjslWuo6MWYXdnCryh0dfAIrQjwACAvSO5kDBKTlAjvviffqBxE7PbbX4gr1+DPB/dtEaSpfcbrhcXzpVJWB9oGwSmREgOJjwA4ZYu4kyyKKO7oS49IpyhPIVzGUpjmhIOc7KD2DsknxrWDBy9R3gliDopZwIXLu379ynSmeOkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777477; c=relaxed/simple;
	bh=yuC5AqRNozXptlKElEys759nOtatkLpbwEzbxGqXe/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lPT5QcvuBb+7bkHxp5XNUESrub9fx5OdWZNnva4kmGCjX/KfcuY9R4bIn/No/R+zasE+89PxSeLyhPWgaapU/N/Ki4pAUXSZ56+6bql0AWoy46lgPzbbw+hyRPbEpJK9VAIN2y84l69/VQZjGAu2Tfz2dYXKXOu4rN4Cm87LxQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g+iV8Dfn; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g+iV8Dfn"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dM2NL6bJMz1XM6Jl;
	Wed,  3 Dec 2025 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764777473; x=1767369474; bh=/dO2Rzn3myFH3VSBZWn3Q6pG
	5bh1kBA9gR9pkIM2YMw=; b=g+iV8DfnK84+rrp1CRaB0sxE/zNtzMM580qzw6pk
	6UQoHBo+1EcjgDE+lHx9pF2d0zWYWjegXnL6IgOjtNzbTt26k3cNoKXK2fq+IdNC
	5Gdqtb05GJVufpvQwOVXoaRJhwlhz9bG8ivSTnk0dxrwDxm81NHfxyaELT88tvSU
	DdPlfb99rVRpNgbBemUccPg7femQMzD4kIygM12kO70Q8MZLOnDz20/KUN/wgS/1
	yQigZTModbtCR1HWKvgwquwZsF0vhV4py/YLsxDdJESl5Ndr7IXfggx5vUUgiDHA
	FRiGnYdQQyrzpSIq0T9Eny4SnThJ9phEPvsKUqLOyi0dMg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dzIakoKLjH-t; Wed,  3 Dec 2025 15:57:53 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dM2NG313Jz1XM6Jk;
	Wed,  3 Dec 2025 15:57:49 +0000 (UTC)
Message-ID: <9d678edb-0db0-4ee5-9ad7-b2b141575026@acm.org>
Date: Wed, 3 Dec 2025 05:57:49 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
To: Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>,
 Hannes Reinecke <hare@suse.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20251203073310.2248956-1-powenkao@google.com>
 <aS_pE4nf7wQ031Y8@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aS_pE4nf7wQ031Y8@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/2/25 9:38 PM, Christoph Hellwig wrote:
> On Wed, Dec 03, 2025 at 07:33:08AM +0000, Po-Wen Kao wrote:
>> From: Brian Kao <powenkao@google.com>
>>
>> Some low-level drivers (LLD) access block layer crypto fields, such as
>> rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
>> configure hardware for inline encryption.
> 
> So don't do that except for commands that can actually be encrypted,
> i.e. those that have non-zero payload size.  I think you really want
> to fix this in the driver.

That would make it impossible to submit SCSI commands from the SCSI
error handler that read data, e.g. to check that the medium is still
readable. I think that the approach of this patch is better than
requiring that every SCSI LLD driver that supports inline encryption
only sets up inline encryption for commands that have a non-zero
payload size.

Thanks,

Bart.
