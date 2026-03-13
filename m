Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2AB3AD503;
	Fri, 13 Mar 2026 15:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773416121; cv=none; b=uDIA8TFXCRA9KrsbbMrD+PTpgsDMMFMZKkYg7f3m4j5Fw+YjjbEsDbrrnwYXfbU/3WwlVi6nItg1Ay/HVoxBlSnR9VEna9XgTBHN3VxV0E9hShh3Dv8GFLIK0EmFWjpO2mNwJTMezd+bQ5kbovSt6jKyevN0kKLHboU7BMm/+4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773416121; c=relaxed/simple;
	bh=S5RrfOTR+vqS01jTUce/jcaNx6XQnb+g25kfAtPKCSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L8MMq/BjS29GiY2leqTGed4ZPSKtyox3k7kQTpC/ajhN3FYc6U4FeZJMBS6oRmTyyF60XeDeSWjxryoBf0cWCY+lCIT8Z8RhJoBLUFJCU35QUDSx/O3kljzNnb3GEJkwu2SHRu163YIzG/s8/KTDDbP/JqF9267wjA9kj8Ub2co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4ULMzX5x; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4ULMzX5x"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fXT861Z43zlfc3r;
	Fri, 13 Mar 2026 15:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773416114; x=1776008115; bh=wxAWdKFlGcE3ZAuy6Sq0YSU7
	T5KB2Hcae+M7EGn+ZSo=; b=4ULMzX5xit3Hk+GoYHfon6dsqsxbGoMJ3vp7wlrO
	/l3o1aRI21r1D/FMTRLUYKQmqXm9ghwLVzlddNSk3vGa+zUqwgpTzTBl/Ih0Rr2j
	CkGpBhjAxpBaJ9VlQ9mtcHVq4iiPidM+gIZ3bxe6obgYa0tm+F5whq0WvqZoYm+K
	BMIolzbKE1fCdrGY9gSGq+yJwO8si2P8zoH4ejtw7tivkb5JgoZn6kIfgHnmEdzK
	iDutnB8U3Z4LP1EfQBp7Up2SxzZRO2UETaiJONjK3/O4cHdZnSI+pD7KOgycYsm6
	+43CXYXZ7ncuGPGolxEin10xlQ0dZTD0xjQV2KaqBPsGKw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wklXI8EoBwZP; Fri, 13 Mar 2026 15:35:14 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fXT811DrlzlffvB;
	Fri, 13 Mar 2026 15:35:12 +0000 (UTC)
Message-ID: <11e4be87-de2b-4f5d-9f98-522191cc7711@acm.org>
Date: Fri, 13 Mar 2026 08:35:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] bsg: add io_uring command support to generic layer
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
 <20260312092237.2464560-2-yangxiuwei@kylinos.cn>
 <96545a0f-2cdf-47ae-bf15-bfb33a35c799@acm.org>
 <20260313073415.102437-2-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260313073415.102437-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/13/26 12:34 AM, Yang Xiuwei wrote:
> To follow your suggestion, I now combine the declarations with the
> initializations, but I had to keep the dependency order between `bd`
> and `q`, since `q` is initialized from `bd->queue`. The current version
> looks like this:
> 
>          struct bsg_device *bd = to_bsg_device(file_inode(ioucmd->file));
>          bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
>          struct request_queue *q = bd->queue;
>          int ret;
> 		
> This way we respect the declaration+initialization style and keep the
> data dependency clear, while following the reverse Christmas tree style
> as far as it does not conflict with the dependency.
> Does this arrangement look reasonable to you, or would you prefer a
> different ordering here?

That sounds good to me and I think this is the style followed elsewhere 
in the Linux kernel.

Thanks,

Bart.
