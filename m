Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B13C6A4;
	Mon, 25 Mar 2024 20:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711396808; cv=none; b=Qt/THFq+9HQHFstuq2eVYyvsT7a92j1njBGATfVFdNu4DC4IbefJzq9MwuqrLOB+0VCGvHbsJEn79ZzGQD0bWTG1spqkNa71gyeO+GNJ4/Xx4WlsEGtVHGuqLUXnTsUHselpfdGf6G/84J5u07C3/iS9Lw1vZiMyykz5yVD/6ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711396808; c=relaxed/simple;
	bh=ZaN/od6HV2z1YYpfc4vvCah2IwIGBmeELwFKCcI2H/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ta/qBkrGVQQw/y57Q4Nj7DUGLpF/T33XoWpzG0St2pkdNKQ/gxvFR4E1fTFV4NbdZrIx5NhrcjQcTLaN32InrFOITg8H43SyFO1zMwV/3u+kYfX78n/YdzSGQyw9X7eb9I8afgd7gyQ3DvnNMZpxMYeeDj9EI+OpQb8DL5ECG+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Qs9u6XAZ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Qs9u6XAZ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V3P125rGpz6Cnk9N;
	Mon, 25 Mar 2024 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711396804; x=1713988805; bh=ZaN/od6HV2z1YYpfc4vvCah2
	IwIGBmeELwFKCcI2H/I=; b=Qs9u6XAZhadwporS5G33wCWtbY8lxNWDGIACKLYP
	daldNlZH1gnHgt/MGvj4ySQYtPl5VlOQs3TL4xNj6E50z5DJwTScWraMoBRKiseV
	59HTRP2ef+oSMMrYLXOPjmEAFsdN59DqIqN01cKpRjnGeGbg0qNF1CSYMjCIf6qS
	BNa1b/+yQvdtcgGeXPgzbUYM2KkuLwme/BJRLD1/sx5iLc9GB39b9tgp9hBoSN7q
	2H64VYHFQox90x8gCH5d5smH6rg5KCXVig3+gBtXz0fNamO4fnn9i1HVIeBo3EZG
	AyQJYn4lpEUpvsthAyW+y+P7hfZoi3/T+K4juDZOpbiAUQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RsJPTzikabki; Mon, 25 Mar 2024 20:00:04 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V3P0y2CSkz6Cnk9M;
	Mon, 25 Mar 2024 20:00:01 +0000 (UTC)
Message-ID: <08f8003e-f913-49bf-a8d6-d82db84b750a@acm.org>
Date: Mon, 25 Mar 2024 13:00:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/28] block: Allow using bio_attempt_back_merge()
 internally
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-6-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> Remove "static" from the definition of bio_attempt_back_merge() and
> declare this function in block/blk.h to allow using it internally from
> other block layer files. The definition of enum bio_merge_status is
> also moved to block/blk.h.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
