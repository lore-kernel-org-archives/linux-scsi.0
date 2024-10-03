Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051DA1AB500
	for <linux-scsi@vger.kernel.org>; Thu,  3 Oct 2024 21:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727989741; cv=none; b=Vv7+G4wbaMZ7muHyTRineL5JeCYPNp6hIx5WiMM9R3kh2w6T85h4EwdpNjWBTW+NtXoQCsE+LWmmzLE/vXXkJ1bP9LcqnJJfuolbqlgpm6iIcEzJOALMwTplenN5SB7AdybJUKhp1/hLXk13bv3e8YRLNJOg6EAnBFj3DyiSyUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727989741; c=relaxed/simple;
	bh=/WVK1JfTfvUguTWKQ8S2LJyAFVsty4+2dfEpAfzh4kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T+Gd/xcBQPjEJls68DOFPfTWhUXdpfbq9qUMOW3PITByK/aNO8JunE3fvqT5kXcGGydUu8MNu00Ty6+wXitNBafqMlezw5KyJeZB1dnpcirXIQIXEKJOgR1tUxuB+QgZNnWO3ebmDQjZjr+3V4xDINh83Hs7yHpvP7tb53DmheU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QvWxb91a; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QvWxb91a"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XKPRv3bFKz6ClY9J;
	Thu,  3 Oct 2024 21:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727989738; x=1730581739; bh=5ktZQla1mmy8ZHe1shj7HHRY
	i4Bs+DbpqeL57zMlsfc=; b=QvWxb91aIJuOtrDbVPNZv5ou7fdXZz4oRVepes3P
	SdtXaorIpSnKYZrfCbvh2a6O1cM2omUrwY+68MzjRxwvAl4rCVnsSzDvfBAD8MrX
	qkYVCgldXiu0kUSs11NLgF1mNz5vG3pywgPXEDnZ20i8s3rUqEU5QV45nexbA/SF
	9snvs1mPEhwhZRiCuOMEITT6abfMbcpfIteJENpd5dnI8LiQzrL20ths34WB+GT6
	s4uuEGjSbGLH4OUq3t9/oNHs9CFSxN80Es+j2SfA1n3UvqluX9tzstqYERDiml+v
	fsjHzpABL6M9L9ue+MS9UxMdJmEIMR/z1rOkNz388aq9Rg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rxYMmM1yb7Xs; Thu,  3 Oct 2024 21:08:58 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XKPRs2syyz6ClY9F;
	Thu,  3 Oct 2024 21:08:57 +0000 (UTC)
Message-ID: <c7820872-cf9c-4424-a620-20de02b1d684@acm.org>
Date: Thu, 3 Oct 2024 14:08:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] scsi: Rename .slave_alloc() and .slave_destroy()
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-7-bvanassche@acm.org>
 <7f2ae124-e98c-4360-8ab8-654a197751f9@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7f2ae124-e98c-4360-8ab8-654a197751f9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 3:39 PM, Damien Le Moal wrote:
> On 10/3/24 05:33, Bart Van Assche wrote:
>> Rename .slave_alloc() into .sdev_prep() and .slave_destroy() into
> 
> "sdev_init" or "sdev_initialize" may be a better name instead of "sdev_prep",
> which does not really convey what the call will be preparing for. Also, "prep"
> not being fully spelled out may confuse some people.

Hi Damien,

The function pointer name "sdev_init" seems clear enough to me.
Additionally, the word "init" literally occurs in the comment block
above the declaration of this function pointer. If nobody objects I will
change "sdev_prep" into "sdev_init".

Thanks,

Bart.

