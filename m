Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6114A60C;
	Tue, 19 Nov 2024 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732051247; cv=none; b=hx1C1mE2Vu8wqhWBe+6pQxkBu0Ou2CaXxevBwjHI3SpnmXPZFZmIiGx7LPhUqUMtE3wfSNeWs3t1RiAge/Iv2rnYRLlXaNGD8X1RmqKzkVsewm73hqKjLATpEjD/qvadufkYGeM2SKRg0Ur0JY7Q1ftbQPlctWrIZA+6w3e6iFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732051247; c=relaxed/simple;
	bh=La/tZKDMvnd6geD6wQ/REDbXwfQjuTcF4tkMki9i7Mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PN3N7LZ+142Cm8jLe2iJU2PJRfHXWpEnfj6dMHdqpwTvJb7EWT6iajgv8Lh8Lq91UPS8eGuIqnl0gT5xrym4WhXyKCibO9QfFAHd6nc4bXidRegkUFg3u9kB8v6PQ9na6J2trWS+YRDfaYoF5A6CjL/XlhsW7JNw8+Jm54v7Vx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5LjeNWcu; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5LjeNWcu"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtHTn0ZlLzlgTWM;
	Tue, 19 Nov 2024 21:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732051242; x=1734643243; bh=La/tZKDMvnd6geD6wQ/REDbX
	wfQjuTcF4tkMki9i7Mo=; b=5LjeNWcublckqn2qUegDkSMVwwbpCTUx8oMz5Q8q
	U+9HhOWlpx5MNDlz4massq2xjrQdmlCO1IZiurPc1lG8XtsCT2LrIAdPmuUpEd4U
	TXCaJ9VgYBAKxv9aef53Wz3fkDkQMFMtAllJLpTS6e3dMhM98QrdvzTeAVyHrxql
	ywe3DViR2LFY1RoxhXpH6PRorUFykp509pnar2mgsevB4RIfI4cB9cVprLfI2Jhh
	18AJtjkE2OtY0hJVcG9zeScA/whGxqGExs56xVfuCNnvk3abCgSEExLDzOsoPdP2
	wRR8MmKaibn03yKX5o9rv+O3p36dHtQGrdTxA+9oVcOQtQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oFpXu3aL5zlT; Tue, 19 Nov 2024 21:20:42 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtHTj1BKmzlgTWG;
	Tue, 19 Nov 2024 21:20:40 +0000 (UTC)
Message-ID: <c95b067d-b39f-49b2-8428-1897609041c3@acm.org>
Date: Tue, 19 Nov 2024 13:20:39 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 17/26] blk-zoned: Uninline functions that are not in
 the hot path
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-18-bvanassche@acm.org>
 <c8cd9037-4487-48b5-80dc-2ee35c1fc972@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c8cd9037-4487-48b5-80dc-2ee35c1fc972@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/24 11:55 PM, Damien Le Moal wrote:
> I do not really see the point... Anyway, looks OK.
Hi Damien,

One of the approaches I used to debug this patch series is to add
trace_printk() calls to track zwplug state changes. trace_printk()
reports the function name in front of the information in its argument
list. I noticed that the function name reported by trace_printk() is
incorrect for inlined functions. Hence this patch.

Thanks,

Bart.
