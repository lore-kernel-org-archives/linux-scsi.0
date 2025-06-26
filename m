Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C00D78F2F;
	Thu, 26 Jun 2025 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750958750; cv=none; b=pTFZ7gsh+DyRDJIKDDnZ/W70kFPWGEcTgn2gRaAzq5+xI2yAz4HCHw6XI1CWKTw7aEnFM5Ht1cJxKdYVNdgPGt2xFkhYkUa1aJMvoVDWdLxMLQG/NP9zT05v8kCo/GO91QZHRvucJ/iC4lYHAMzpIsrEJW9NXTmnO9Gdb5XmY4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750958750; c=relaxed/simple;
	bh=lXahm46a9ky2T7ukyv3Jw7Eg4Kk/gnBV/VdOqmDVAaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLaVJVvanTutgvQhuPOi45XuFd1/L8t+22KWN1KXIUft6pQodVTvc7Ax/UOrAB9qerCjECPwIWnIthacBFUtUW9/eoqQ8xUBTVgpkGEfT/Gt+UhSPwosQzWbe7Oq0EPIyz3KdMMQqPNnj+1z5EDIi947prAGeG2NFFYuDxk0azo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Dpzgiiyy; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Dpzgiiyy"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bSlvc06fbzm0gc9;
	Thu, 26 Jun 2025 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750958746; x=1753550747; bh=a2QVQzEhFPL4A6Hd9qQY+llT
	fAzFFAriOUUdn7jLp0g=; b=DpzgiiyyG2dCoI89DIAri5q7mVYB9EtF5gQCsklq
	dq41T+XG1k6+nqgr0khTvDcFNHIDnOJUL3Fdon13bfgS3Pd74G5pNHIDVkEGrfAO
	CjLPtLk6Yqjdz711JappVavGcrSUTZleQ4nsXop4i3ERGb+cMnt9ubfupF8hKPVl
	StuJxyXL1H+2vBuSA/YpQx2IFV9myc7HZ2Hb4/x7rgeCX8zEGuwzPGie/FZAM5v/
	klcxBSiUQzEZgwiSmkNP7HSWyNoRHdkNVQDZlzsdRlxy3vMWFRX7SH6Yls+9cqxZ
	fEvwsIICUNuGlKSn6veN9P322lXbkTaSNyY7hk6Bim4pJA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NdFizUVHyEYi; Thu, 26 Jun 2025 17:25:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bSlvW6fx4zm0yQd;
	Thu, 26 Jun 2025 17:25:43 +0000 (UTC)
Message-ID: <61cf7e54-832c-42df-a476-08d8a2d1e462@acm.org>
Date: Thu, 26 Jun 2025 10:25:41 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 02/12] block: Rework request allocation in
 blk_mq_submit_bio()
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-3-bvanassche@acm.org>
 <aeeb5b64-e539-4f0b-b80e-5aaecde55550@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aeeb5b64-e539-4f0b-b80e-5aaecde55550@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 5:00 PM, Damien Le Moal wrote:
> On 6/17/25 07:33, Bart Van Assche wrote:
>> Prepare for allocating a request from a specific hctx by making
>> blk_mq_submit_bio() allocate a request later.
>>
>> The performance impact of this patch on the hot path is small: if a
>> request is cached, one percpu_ref_get(&q->q_usage_counter) call and one
>> percpu_ref_put(&q->q_usage_counter) call are added to the hot path.
> 
> Numbers ?
> 
> The change is forcing a queue enter for all BIOs because you remove the cached
> request optimization. So I am not sure it is the impact is that small if you
> have a very fast storage device.

Hi Damien,

I will check whether I can drop this patch by reworking the later
patches from this series.

Thanks,

Bart.
