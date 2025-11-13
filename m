Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CE62FF165
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763055044; cv=none; b=TQAV09eT78IAHT7xulb3gT4wz2kdiNLtp7Nxhv3e4IX9ib4M3/iz54Zytp9pEte6VZercyG78F7BTR4JS5gNeq35mTRx0cIvuijW9NTWLr2KX0gYH4eRpn4eILNlL43AFPtzIT4DMef8bgapg7CQ7Y8NYUux65MI6pg48FcMo6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763055044; c=relaxed/simple;
	bh=kKtda9vnVdsN4jwy5l7Z/51fZF8hilefDt9bhiCwD3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oUp0AXUIoMAnnWnf0wmsOMm7bVCny0pwoatzzkaeStrnB8CAxMcqFKCe+XzDDWQEMztyIwhtZWTnOp3YEDg7dLRAcQhG908CgsypVCu7I/ntN5M8o1VH5nEf0BjzHRMs56qty5lry8tHPLGeHH5nx6y4agKWNyp5NSNA/fxSkco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jKA8liXA; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jKA8liXA"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d6nNZ6Vj4zm1CGq;
	Thu, 13 Nov 2025 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763055037; x=1765647038; bh=3jVGD+AZPxYfhUVQKLfLbVjc
	MSMrHwpT7vKXw74k1PA=; b=jKA8liXAQk3+cJi+dwxudWqJCZiZR+jEjcUjkyz4
	IyCySA9D954xRGJjW0VD8gc3+NWGwhpSMvcVon4TbT6sCunPl8TvRdHvGP9sHLVk
	pVkcmeFHrS1fisBxxhs9xIna6bCTG2x9MT65TyNAhoyVoBh30Gy0vuazSHnYUwEX
	6Gc8bj/1dwRBUYLhpad2KyDIqKL1U6C3paz32Ffhnq+pcyvZ3lPY0tpaMUOxafCX
	gOmLY/uDkmIDYO0IF1YeMibXs0XlSVp9tNDRKV4vEWU3irGepyEbJR5AMouzveDN
	Ac3wovziw6JMSE8epKT8QQs8d8FuMxlbdR5vyS0LgrEYBQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XfVgrttmXP-Y; Thu, 13 Nov 2025 17:30:37 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d6nNV0JkJzm17Ff;
	Thu, 13 Nov 2025 17:30:33 +0000 (UTC)
Message-ID: <7abc306f-781b-4ce5-b8df-d27562ff1714@acm.org>
Date: Thu, 13 Nov 2025 09:30:32 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-zoned: Document disk_zone_wplug_schedule_bio_work()
 locking
To: Jens Axboe <axboe@kernel.dk>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20251112182421.3047074-1-bvanassche@acm.org>
 <bfa525c9-5d86-4384-8e80-85efea15c5ff@kernel.dk>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bfa525c9-5d86-4384-8e80-85efea15c5ff@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/25 6:22 AM, Jens Axboe wrote:
> On 11/12/25 11:24 AM, Bart Van Assche wrote:
>> Document that all callers hold this lock because the code in
>> disk_zone_wplug_schedule_bio_work() depends on this.
> 
> This is already included in your previous series?

Hi Jens,

You are right, this patch is already in the series "[PATCH v2 0/3] 
Refactor blk_zone_wplug_handle_write()" and is already in your for-next 
branch. Thanks for having reported this. Something went wrong at my side
(wrong branch?). I will check which SCSI patch I actually wanted to
send out and resend it.

Bart.

