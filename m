Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA166382F25
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 20:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779137094; cv=none; b=bSo5hQWcDMGQndN/TUNB8/COKD2jVLe9flHtpKoFttlblHYffq1NwgndOylBG4kznx23UCUs4zAmwohurXwVGtI5qz1TyXXh6ks78p+dJtlWgGJV2TX9MGVNDYb+zlGSKN8NMaBIsVpxe+5k73scv95rC6fcljDe5flziNPVCCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779137094; c=relaxed/simple;
	bh=JWy4HlV7zOVEzxkuyVJ2g6TsYUUCGoC8YOYacSOaHqo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I+sAmmsxF7ytzXDP+qAHH6QFvDNTa9r+6miNVmhSCVPovD5dS+MsRB0nBR3CjIxeGH+vSmzlxKYAlqBLH03M3Av4RnbdPzV8hGpsIhWu/HTYAnnr2ncIzo1/H8MDj6Qt9x7kDIdip6RkFFmYPhQhuYZvR5FlRdr1eMKIHzZcraw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3wyPB8Ir; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3wyPB8Ir"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gK8tr2VD2zlgwNK;
	Mon, 18 May 2026 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1779137090; x=1781729091; bh=JWy4HlV7zOVEzxkuyVJ2g6Ts
	YUUCGoC8YOYacSOaHqo=; b=3wyPB8IrpFH3FMuIqYKobzM63hm0CZtN94bMTUFn
	R1493utI/VY4Blx0PduzCS0hxUZfj7HbLoEKWtB9iaoaWrhmnYiEENJew5NzOHVd
	o/gyjVejsv72NeRHPZLaVTop56D2KzS0wptf0+11pqDVhS/l78znkR+0T4pGEggP
	P1DK1GyYFA6yLualySyarMqdyiIjZyyRHya5yFYR1vjZGU3MnEbxwm3yk1FmSIch
	fkduXPhvB6TUlF1DSGCyTkMC+4i+uxWUFTb7OqtMqlz38+Xn6CcgOsIyDbIxJ/0F
	Xx8jIQ021ZvL/2+TjlBKvqAqrqT9GBdxxg5vAZBWNrW0Eg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FFfFChqh-kOk; Mon, 18 May 2026 20:44:50 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gK8tn1rlkzlgtcp;
	Mon, 18 May 2026 20:44:48 +0000 (UTC)
Message-ID: <577f9fbb-fd99-4aaa-976c-b217c2bc9711@acm.org>
Date: Mon, 18 May 2026 13:44:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: wake eh reliably when using scsi_schedule_eh
To: David Jeffery <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20260515181112.9758-1-djeffery@redhat.com>
 <b020a37b-ded6-4fd7-af4a-f4553a72717b@acm.org>
 <CA+-xHTEc=Q-tGLgvDBK=upzgqyiDuusBzNnw2-L+PftJs6ir2Q@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CA+-xHTEc=Q-tGLgvDBK=upzgqyiDuusBzNnw2-L+PftJs6ir2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/18/26 10:53 AM, David Jeffery wrote:
> The scsi_dec_host_busy comment may not be completely clear from
> condensing too many details on how and why it works, but the RCU usage
> does cover this type of race. The rcu read lock combined with the rcu
> callback will mean the execution of scsi_eh_inc_host_failed can only
> happen at a point in time where any active call to scsi_dec_host_busy
> is guaranteed to see the host as in recovery and take the error path.
> And the error path's memory barrier and locking will then work with
> scsi_eh_inc_host_failed's ordering to avoid a missed wakeup.

Hmm ... I think there is an open issue. As the comment above
scsi_dec_host_busy() explains, the implementation of that function is
based on the assumption that scsi_dec_host_busy() and
scsi_eh_inc_host_failed() are serialized. I don't think that the RCU
API guarantees serialization of RCU callbacks and code guarded by an
RCU reader lock.

Thanks,

Bart.
