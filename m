Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643E31CA4E;
	Mon,  6 Jul 2026 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360575; cv=none; b=aUbefXAV5EI6egq6CeEWjsOpa6MAPyhC/E+qFMZTX/6gwobrEIXhKCLc8WyRKrMK3/514+P8bfdZ1OPkYTxNIlgSLxjaxJQ0QdHluRSkiSRP49nmV0agJZjDKNypKQg/ZGXapwXwY3v4VhZW0azV+V87apFoP+EZKt707l5mPyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360575; c=relaxed/simple;
	bh=8Tk/PjWPbnTR1IBa1OywOq3vwJKIu20nWioenIVvgBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0Wtot7f2BMtqG2SZtLCUg1DYZopOkOMKPLJ3VakvMvqL2fD7PFgxWdrRy8b0XiFneeqPvZ4kscB0+fI4fFJa1/HEibCwtzyH3ha5qfAGxVAHF9OW57scPNRlCnYbZ6/N3znV0ot14Ohoi6s084k7EYU00BvrxkATg9LWu0l2VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YIcozZb/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YIcozZb/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gvBqd0fKZz1XM6JQ;
	Mon,  6 Jul 2026 17:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783360568; x=1785952569; bh=DZMX73GcZThripYdnzjra9O4
	QSoz/b28yq+rPQy6+qg=; b=YIcozZb/OweJOgaDwqZ+EQqa2liDAALzs+wKbZWM
	LBuIaXyi6eQA9cZGVX9i8VBdhvO0VKletRLn2gtEoqxdkHQwv1GAkWQshgFavVWG
	mwYcs8dpTcSUswmhMW/L1Bili8vJmWPPWZejJvkbwEtActSF7jlegrsvpqhO93Xx
	n3JGmo8Gu/neUJgNoyzEC2az5KviwV0RGHS6jEv/5aeyrk5yhTHJND0clqFzjvTn
	3OcnmS3P6/QcT62LTIkRWjJatSSxw2NWBgvuRGmemPKroe5UYDbVbTjol4VdF0ah
	bM4NHmHD7HcGxKYT1Zdsl2mIGGn6SzZMyebE1bRD2r7PcQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R61eMYN1_fQM; Mon,  6 Jul 2026 17:56:08 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gvBqV5K5Pz1XM6J4;
	Mon,  6 Jul 2026 17:56:06 +0000 (UTC)
Message-ID: <6db8dcc3-6f79-4407-a5de-ec80915bc73a@acm.org>
Date: Mon, 6 Jul 2026 10:56:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] sbitmap enforced fairness for blk-mq
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
 sumit.saxena@broadcom.com, Keith Busch <kbusch@kernel.org>
References: <20260706173438.3537347-1-kbusch@meta.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260706173438.3537347-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/26 10:34 AM, Keith Busch wrote:
> There have been a few proposals to remove the blk-mq tag fairness
> algorithm:
> 
>   https://lore.kernel.org/linux-block/20240529213921.3166462-1-bvanassche@acm.org/
>   https://lore.kernel.org/linux-block/20260609121806.2121755-1-sumit.saxena@broadcom.com/

There have been more proposals to remove the fairness code from other
kernel contributors. I proposed to remove the tag fairness code because
prior attempts to solve UFS performance issues were not good enough for
the upstream kernel.

> Both abandon blk-mq's attempt to enforce tag allocation limits on the
> per-queue/per-hctx users that share tag space. This can harm resource
> allocation for lesser devices sharing the space, potentially starving,
> them from fair progress by a highly utilized device.

Has this starving phenomenon ever been observed? I think that the
measurement data that I published shows that the fairness properties of
the current sbitmap implementation are good enough.

> This series proposes an entirely different fairness mechanism that
> doesn't require per-IO atomic accounting:
> 
>    First, the sbitmap API is augmented with a ranged allocator. This
>    allows a client to carve the depth into exclusive ranges for specific
>    users.
>    
>    Second, you can optionally declare a percentage of that pool to be
>    fair game for anyone to allocate from. This provides a way to
>    guarantee minimum tag space for each client while allowing a user to
>    over-allocate its fair budget on demand into the shared zone.

What software layer is expected to set these percentages? My patch
series intentionally removes the fairness mechanism because that's
exactly what the legacy code path in the UFS driver needs. The UFS
WLUN and data logical units share a single tag set. Any activity on
the WLUN increases the number of active queues and hence reduces the
number of tags available for any data logical units.

Additionally, what is the performance impact of this patch series?
Removing the tag fairness code increases IOPS so this patch series
probably has a performance impact.

Thanks,

Bart.

