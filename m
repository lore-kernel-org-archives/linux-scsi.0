Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149218645;
	Mon, 25 Mar 2024 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711395049; cv=none; b=mGHswEDNuZL3pu3spkopfJg95bpHJg7RgRnOb5GeKErTkokMyT6jz6ZiT3YS+4JIO1l630CskrYx0qRMjGsTUoBL4NHx7gWGEG5xJ+VgSFeOtNI4tbrlB04h+q4JKY45LadBY7J6EtiiUmHUsly7RAq9qBdkgcSYBVH0lPRAQN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711395049; c=relaxed/simple;
	bh=WU9EsGdlACTjLrxfz6Tz2zLxS3vNvLw31qKAtfSMUPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y8ihG/4b1SxZd8mtnsirltT9VKwFeHUj/g5o2Ff37Ph8wtPRuIkz2fKvh2hP+J9nPvdypRKokH3+t/cc8d8KXJzLgkju9wif+lLtssQ6QtP9xVSyNvi/XOtBJHFY6vSGcgU086hQVsKAH/HZ5i/j78uSupUWAMRoZV6Yk/3QM94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gJ7S6+mr; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gJ7S6+mr"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3NMC3zdJzlgVnN;
	Mon, 25 Mar 2024 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711395045; x=1713987046; bh=jPTfKpVGdIu9emQzxzx7ldmw
	zWioJ2EKR3njROT8h9g=; b=gJ7S6+mrSZz9PN8x4kG61dyyaDCYLhhxcJKxVC4u
	pWWLij/UMIbRTti4PQ+pybR9aFV/btV4dxeaYBt0pGRB9BycxY1SJAZ+x2qM7iWw
	XsPcHLaFy26sZTuq3q06yALAsxHgstJxEc31lrq/P+bIXxT55AD7Niwd3NVZICBH
	jtIFC82Mu/v9sr0jl1bYiMSlcJZgJea2E2bzQYaWywfWHTfNUeYysax26n9zUtR2
	+g9H4E9WAF7ayoOwzNxne3QX0EUVmO9TBknybIKzDNvvRYDMc95mAGCQWI81U/NY
	mdJsFfbSztJU+FUn5Cqc9oDINh2UYC44e606ibd+7eoxqw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gsi7-D_0lrc5; Mon, 25 Mar 2024 19:30:45 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3NM80VbVzlgTGW;
	Mon, 25 Mar 2024 19:30:43 +0000 (UTC)
Message-ID: <814ee49d-bbe8-475e-b5ea-02face8bd169@acm.org>
Date: Mon, 25 Mar 2024 12:30:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/28] block: Restore sector of flush requests
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-2-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> On completion of a flush sequence, blk_flush_restore_request() restores
> the bio of a request to the original submitted BIO. However, the last
> use of the request in the flush sequence may have been for a POSTFLUSH
> which does not have a sector. So make sure to restore the request sector
> using the iter sector of the original BIO. This BIO has not changed yet
> since the completions of the flush sequence intermediate steps use
> requeueing of the request until all steps are completed.
> 
> Restoring the request sector ensures that blk_mq_end_request() will see
> a valid sector as originally set when the flush BIO was submitted.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
