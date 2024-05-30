Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5684D8DD;
	Thu, 30 May 2024 20:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717099333; cv=none; b=Kz4ioSQS1Q370zM1nXikKXU1tMBAhaf+o0N6fmSNz27ckbXURMJQDJaT1oozuq9akvH3Nyf5C2hBWurJbJfL0XYFDz6pgrlfCjUV4sIbAsztJYUKacpxj07UwoQ0pDHgEd7aDHF+ESoj/kGyaBWnouxQ5sMJ3uN/5mQb1vsKSR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717099333; c=relaxed/simple;
	bh=mbOtu3q9zjV5nBmJEGmUM2ChlXZYTtjXht6IjdlxuYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jI5B+nHhzPcSayon3SaEbchs4nmRRL3cVKR6wGez8EUs5w1bogp7m/CE+DpBajRvwMxBpMtRugk7WEO9lTUh/d0gCwNexfl3ZAoaZpvLpoBccIdor2DdwHCYHYACUVMlrw5pm1uMUcDC0SnkQUWDhCLnqohrJrV5jhnbNIUXOoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=F/EUZ7Zo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="F/EUZ7Zo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vqxwz1Qt3z6Cnk9T;
	Thu, 30 May 2024 20:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717099326; x=1719691327; bh=mbOtu3q9zjV5nBmJEGmUM2Ch
	lXZYTtjXht6IjdlxuYo=; b=F/EUZ7ZoluH2NApSjB6LS4U+IseVIwCjj1+dB0GQ
	Hzd/jksY/Fw5Zro8gliSKkstCF1FjokCnbsfexxZKJdkTxEAEPIYDNL8Qr6xEnV9
	rJ7hsYcQWK7x55L8pxb/1Sxg7HUnHdJTyGXoCBAKmGZJnKsfm9hEfmMr40tWPhVi
	H6OveqevfRhZsr+gmDFCxlYpIB9o9xQP2SQ9BKfuKoYQ2KM6iZ+h17N6LqEDIWcJ
	VpoHnGJGnHY0dmLgFjDoWjP/wCgsZwF0k5CVqOvxoLdxfHwd8lS4d6WQoZn/kYPz
	/dr2Nfj8gmo+hFuTTKGCcdGS7oOPWkNQF2/83ZmILBkUCA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TbhOJyciqa7X; Thu, 30 May 2024 20:02:06 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqxwr3ZGLz6Cnk9F;
	Thu, 30 May 2024 20:02:04 +0000 (UTC)
Message-ID: <6d52dd83-0cad-448e-8a22-b6f0e1bcac46@acm.org>
Date: Thu, 30 May 2024 13:02:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] sd: simplify the disable case in sd_config_discard
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
 <20240529050507.1392041-7-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Fall through to the main call to blk_queue_max_discard_sectors given that
> max_blocks has been initialized to zero above instead of duplicating the
> call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

