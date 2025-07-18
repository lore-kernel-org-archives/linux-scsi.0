Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7B529B8C2;
	Fri, 18 Jul 2025 15:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752854066; cv=none; b=iwohI4aa4usvb84E/Y6X6+3wn3GhtN7/m/jI8XzmrNLqvIDXrHBAGJ67EDXaVUeAGpm41WXgcd34/YSxvteMYDZ61olrWIXqYYn29oD3gl/Xq9ZMxxrACw0iDsPvukBPNTcTUWGYHi0weAs0je20c81F/6DcKQ7lN4XRu4/PLu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752854066; c=relaxed/simple;
	bh=4XDQPkNdV4slch1Zvmvcajx94L6Rki4tub6PxZD5o4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BGOgFts2G9GLV71MWsJIurHs4dPZcgzamiU5tIZVuyOxEkqyAP5UUH2g75JFbctK7s94Si8NU2NvHcExedv/4dOqtEq3SU6KaaChqgox1XmoggU37E+igVOS5LO+s6J3t4W0IeSjHQZqo1K5psjhunJ7z5/Nxygd0GEyhSkaHms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xr5KkONc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xr5KkONc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkDr03VcNzm0yVk;
	Fri, 18 Jul 2025 15:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752854062; x=1755446063; bh=W63/koGubiYj2tWQlzrfrG79
	F7ylsbnCGV3lGigxmUg=; b=xr5KkONcPrs8yhkPWPg2y4uAI+PVIycjOSmY+M2K
	gL/1Sv0OGvViOayA0YWlX1SHC4ckQjLGoCiiwr8ol3u90CwPqVgzrMTL67vG6h+q
	qWNEMfF8pK6qK35JUp66dr6XnSBlqXm5ySqXfqwvZIB/xPSWDYc3gOlAGomandz9
	8iCgV8s1UvR+68Ch/9nyMSa4aejYW91Q0oBi0OazqMCTy/AMs/ZPkVb5VZxGrEc9
	ip1uX1fenrA1ugTBlI4A/mLujozFa6e9xYCobt5ETpr/KZZZ3Po3HFZ3AK5OzFay
	9Yc2a8gysH5pqSoaMhykd3G9y+E+f9QZFUoJyWOzQl6P4g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QinSqasYWzzw; Fri, 18 Jul 2025 15:54:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkDqv2l6Qzm0yV3;
	Fri, 18 Jul 2025 15:54:18 +0000 (UTC)
Message-ID: <2d06bfe0-0ea6-4c52-83fa-e933557ea399@acm.org>
Date: Fri, 18 Jul 2025 08:54:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 03/12] blk-zoned: Add an argument to
 blk_zone_plug_bio()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250717205808.3292926-1-bvanassche@acm.org>
 <20250717205808.3292926-4-bvanassche@acm.org>
 <eae89738-44e6-46ea-ada6-665fdfd8db07@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <eae89738-44e6-46ea-ada6-665fdfd8db07@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 7/18/25 12:13 AM, Damien Le Moal wrote:
> I still do not understand why this patch is needed because you can get the
> current CPU submitting the BIO inside blk_zone_plug_bio() with
> raw_smp_processor_id(). That CPU ID should be the same as the cached request
> that we will use only if the BIO is not going through the BIO work, that is, if
> it is the first write BIO in-flight for the zone.

I do not agree with the above. With CONFIG_PREEMPT enabled, migration to 
another CPU may happen after a cached request has been allocated and
before the zoned block device code is called. This can be prevented by
surrounding code with preempt_disable() and preempt_enable(). However, I
don't think that we want to do this in submit_bio() since there is code
in submit_bio() that may sleep (bio_queue_enter()) and sleeping with
preemption disabled is not allowed.

Is there perhaps something that I'm overlooking or misunderstanding?

> Furthermore, for the DM case, you pass a CPU of "-1", but if the DM target needs
> zone append emulation, it will use zone write plugging. So the same control as
> for blk-mq is needed.

This "-1" means that it is not known from which CPU a request will be
allocated since a migration to another CPU may happen between the
blk_zone_plug_bio() call and request allocation.

Thanks,

Bart.
