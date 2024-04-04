Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218771BDCD;
	Thu,  4 Apr 2024 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248470; cv=none; b=qWu5zHxJrqXHP6OQvnfJNsFBcQUB5JaRwP5t7ByMliAylfXLN2iNjF1tbiDYjuS17+9TlMadBuKXTAfqfiS9Z2wm7Z7gNzWuzId+BfaIWj1XunShsGKQY/CEe7+aVlfdaaIAfdmdiW0FQBRSUrkuAcsWNrlT7pGfsE/5QJuXywg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248470; c=relaxed/simple;
	bh=PYsZwXvaAWiIglPCnYvnXJi+o8yH85D9GSSwibY+o0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bJqE54Ckd2sZPNWEtuCkWFir8C+bdLF1pbaChw7nFI0QxGfo5pWNGzPCUJiiqOBQeyshei/X3PKmHiYw68mMof3BI9QVdZxbm2naowrlkw9mB/ZHfh+LCjg2gncuaiizyIKP9Gyi2+J8aFUKjPHC41+nxqitQaPEZ40ym9+alNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=091+neT1; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="091+neT1"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9Rz82lVqzlgTGW;
	Thu,  4 Apr 2024 16:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712248465; x=1714840466; bh=gtgsa6hJPcd82Maymu91LBcQ
	ldrh83j7UrAsr0LevII=; b=091+neT1o3mekbMq718chh9bKsxwE0wkn+CCOZYG
	S6fl1APE+r3rTwwS0xvPO8UCgzrEHBLgfTYh30/4zh3cR+zIxwqiHd5GVycF0zqA
	5/ZCpyTG+KYqdwztkGR9Nv+e4hBGMZFdN4YTYN9dHPt1e8BwGSmxtMf/QQVbG9oj
	rIxbM0PkdVbKCOKDjI7fwAf504qlshL9dnvwKBBkQgjkgtdqBoTwxeXeTyXtpcQy
	UPtcWDPYWFUoo/Qoi+/5qfJ1UDCHuYQeYxbqxqpfanty3BGOvNOd1Pr2G/cW3cmd
	/9CqjatN++lg2ZRM3mVSk3mWcU9oSF5zD5jt/AsA8LPnDA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8dDNJUMNhI2V; Thu,  4 Apr 2024 16:34:25 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9Rz44ZJxzlgTHp;
	Thu,  4 Apr 2024 16:34:24 +0000 (UTC)
Message-ID: <063d9b04-facd-4399-bf50-40452bd2c42f@acm.org>
Date: Thu, 4 Apr 2024 09:34:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sg: Avoid race in error handling & drop bogus
 warn
Content-Language: en-US
To: Alexander Wetzel <Alexander@wetzel-home.de>, dgilbert@interlog.com
Cc: gregkh@linuxfoundation.org, sachinp@linux.ibm.com,
 linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 martin.petersen@oracle.com, stable@vger.kernel.org
References: <81266270-42F4-48F9-9139-8F0C3F0A6553@linux.ibm.com>
 <20240401191038.18359-1-Alexander@wetzel-home.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240401191038.18359-1-Alexander@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/24 12:10, Alexander Wetzel wrote:
> commit 27f58c04a8f4 ("scsi: sg: Avoid sg device teardown race")
> introduced an incorrect WARN_ON_ONCE() and missed a sequence where
> sg_device_destroy() was used after scsi_device_put().
> 
> sg_device_destroy() is accessing the parent scsi_device request_queue which
> will already be set to NULL when the preceding call to scsi_device_put()
> removed the last reference to the parent scsi_device.
> 
> Drop the incorrect WARN_ON_ONCE() - allowing more than one concurrent
> access to the sg device - and make sure sg_device_destroy() is not used
> after scsi_device_put() in the error handling.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
