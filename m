Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1377158874;
	Thu, 30 May 2024 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098295; cv=none; b=n3iwWoy+bgP/jr2vaYyLnLbb2jgPYXz7vwvX9mPOlNwm+utcBRTKIzxX6aQuJIOfEKG1UDqKd0186OUqQqGfsJn7JWXFLb1CdGOjjEvR5ET7sBzmT6bGCwYQGm121grhb8cpwRnqarCzRgzLCSz7aPhAfMo0tBXf4YptC/S7CEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098295; c=relaxed/simple;
	bh=NqD7BFqcvpYiPPucUb5Xs7cfQLPshp0Z3ca0XeE2TaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jwBn2wtixZ6CeRTs491ctFnZYKQHY+hHIJ7pXETRHpH7fpjK8nJmSUhUyL5FVI7UoS2M335UBx09LUeUe0sw0u2t4FvHNWH0B4QdOXu1tz139T1k3LQ1f7ek/InhmV0eSiZovuKrycsp6caH/uL6yjhFKANrOi9+LPP3P72D8Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O+dyHa1D; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O+dyHa1D"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VqxY061N4zlgMVV;
	Thu, 30 May 2024 19:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717098288; x=1719690289; bh=1qawYRnNtHLyKkfk2KIuL7Vw
	Fij1fGlSBD1rE6Kec4k=; b=O+dyHa1DO+LxwuvN37caN3rc79Al5B59aVt872Yy
	myvPBRd3qJOpB/ssbZf9DD6jeQwG3oky5nPyGHmKtOjLfDnHlE+e3wVIfqzpWjOs
	6hfPZNndbOYIdhdiprqYgfQpwZxp2KIDZmAsJBYG5LuLkM6flrrsn+Z7CP3aCzDV
	pwN4+gbFQD4bp6z4s36qcFNV+1waUaRjvrfL+xtNhs1hivVR8LlUKLXvQ4CEJ/sF
	RymJznQ8+fPT5LcsiI4IQupBmhHjJpPce8ad1C01w5LQVIcRKBZRcPzwxcXH/hff
	wu+Gqo4QOptIYFBfw/rmjL36jeH02rPcp9YADbGYnOeaDg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XhrHqHFE5lIy; Thu, 30 May 2024 19:44:48 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VqxXv0mMXzlgMVR;
	Thu, 30 May 2024 19:44:46 +0000 (UTC)
Message-ID: <2384c3c9-5629-4438-a87b-0e05e1b6f5cc@acm.org>
Date: Thu, 30 May 2024 12:44:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] ubd: untagle discard vs write zeroes not support
 handling
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-2-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Discard and Write Zeroes are different operation and implemented
> by different fallocate opcodes for ubd.  If one fails the other one
> can work and vice versa.
> 
> Split the code to disable the operations in ubd_handler to only
> disable the operation that actually failed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

