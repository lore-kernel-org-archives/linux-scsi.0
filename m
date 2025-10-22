Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9204C2E8B9E
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761156458; cv=none; b=RLzcACz0krtQi1Fpsyu8rOGLH4wst/B0+ruwjdVer6NUM7wM9GVkVhaPjlqwXeu45g1PnJwbzBfPG+d955Vc+dfuQl8pMafvDw3DlWsSTT8SIf3ZtS7afRaOE9g4pj/P/rpvZO7Zz9Fe2EizjjKD+IaWEmU3gS/dDYIMOAW/u38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761156458; c=relaxed/simple;
	bh=7bzCIZQJ+TBbTfpafd8E8wWKmN0cF2219e4eYMpShG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EuDi7Xh403pZLznoq9DHQ65cx0JVBch2bttvT/GnEZSimy/hspmVOOezgnKdQxvzvpvU5dlhUMoM0+F7Lp1sTU0L5LwuZX74DUH6SyMQ3LnCVuzB+nwbnEd3aYFYqzEvfjIcVHb9oyXpkO9hEMvCGDVm+6OcTX8hdAnq2jPWwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lSpZUAzw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lSpZUAzw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4csHFM3dq3zm0ytp;
	Wed, 22 Oct 2025 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761156454; x=1763748455; bh=GQOQFpuUuNY2uwqANOP4hsg2
	nJkk8z1QhVxuHCaAIMw=; b=lSpZUAzwyCl64joFVk8xeTn7RW4/Wahl6ojHjeFf
	ut332Xcs0eHzMEYtwNNayocavaCZF8eg+Z3jzER8C9au/GORk9LpKfM++pLMrA0V
	GU/tEpMnGRMsSzq5yW2iCNGv0WFywgYAzkkN2g7DiMrfS02lQGWfJjOpzz7EGzz6
	ZPOVH2kIa0Q9Xiy180sb8YM/0Uvhr/OVOGyDhZYHhU3qGVXQ5BV5HAKCOQu+OvEx
	3Y1QK+9QyIs8/mU6ZSFR9VTZJq7OobqYS2e6zseFOsrN5eUlRFFN/L4OMTBkShil
	kQ8HxkghWnPUKMbMpRMuV+dsRVm9s55n1a40ae23VGM8wA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rNVFxgy5Imex; Wed, 22 Oct 2025 18:07:34 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4csHFB5V53zm0yVk;
	Wed, 22 Oct 2025 18:07:25 +0000 (UTC)
Message-ID: <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
Date: Wed, 22 Oct 2025 11:07:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/25 1:13 AM, John Garry wrote:
> On 22/10/2025 03:26, Martin K. Petersen wrote:
>>> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
>>> iterators") introduced the following regression:
>>
>> Applied to 6.18/scsi-fixes, thanks!
> 
> I don't think that we should call scsi_host_busy() on a shost which has 
> not been added, so it would be nice to have a plan to fix the LLDs also.

A fix for the UFS driver has already been merged by Martin. See also
"scsi: ufs: core: Reduce link startup failure logging".

Thanks,

Bart.
