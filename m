Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4118640BE0;
	Tue, 19 Nov 2024 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732042361; cv=none; b=d+eWP4qnHiO/nUY8zZv4stKv1xIeA06Ff28e5A9jnsQu5BRwIiC1tEtnrvTaJ4kX5QbYdAIcdZgluZRoMuucjLauuJsntpOumFyV1yVi9dbofV8lYLuvNQqMtjx+MTRG25Jnd0w3pZ+rsID6OJ5AoYxlBKNAjV5TDXrJo6lMqYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732042361; c=relaxed/simple;
	bh=KROwqvWzCeoO+8AWMaIuzk5h10i+YsNyKAwM2bhLFgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sfc3Zx4G0uLfq5kUinlBySvZoTC1V//j8PpvlRzR+4XU+0NsezKMvIhLMKWYyEeBuPMF/OC7FNgCfbK3aVvs9DxT0ikRdr3Izos5y9cLYS8mw5mdWBNHZi5KcDx272IvDvPgivELodUtewdDGI6xjRqMFP98ZDPS0zXgpqsdW/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=C+qkkxD+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="C+qkkxD+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XtDBv3lm1zlgTWM;
	Tue, 19 Nov 2024 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732042357; x=1734634358; bh=FBRC5j4HorFzPcWTIrHuc7qP
	8xkPYV9CgWbuWHHFlCA=; b=C+qkkxD+MWSEB4QK6KpDJPTg7xYDkEPc5Z+oZFk6
	uDubO6z/dFX/7PF8XE02SrUnLyl9l4eH98y4ILeZNu5cowsrIviX58ACyUA/EqVb
	GRzHtbXxNXYDARSrnh6g/5g1wrzzFGfL6scv0dJn05E4yqYH83FUGcyl/xGU+3u/
	ur6eA9oa2ZVnSWHhpKmqPcf+W0y1FGcZd6jqvf2RVBXIWCwvm3hInt49E3d7gZlO
	WQKwKbCyx7sRtgfVmeUV+pfK8I20YfYBXU246Ez6j0m2HAm7ZOFiPbFN0ZZa6NBn
	lL2+Ki/hzXk6L+HYHs1gAz7zH1hYwm9lUTdrTKR1KP0h2Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6_iDmGvN1MSW; Tue, 19 Nov 2024 18:52:37 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XtDBq6MnWzlgTWK;
	Tue, 19 Nov 2024 18:52:35 +0000 (UTC)
Message-ID: <05d08c8a-7bae-4bf9-8238-46cd739223c4@acm.org>
Date: Tue, 19 Nov 2024 10:52:34 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 00/26] Improve write performance for zoned UFS devices
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119122533.GA28580@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241119122533.GA28580@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 4:25 AM, Christoph Hellwig wrote:
> What's your exact test setup?

Pixel 2023 and 2025 development boards with android-mainline kernel
(https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline). 
The android mainline kernel tracks the upstream kernel closely. While 
the performance of Pixel development boards is
identical to that of the corresponding smartphone generation, these
development boards have the following advantages:
- A UFS socket that allows swapping UFS devices without any soldering.
- A USB port that makes it easy to monitor and capture kernel log
   messages.

> Which upstream kernel support zoned UFS device are using?

A Micron ZUFS device. Micron zoned UFS devices have a zone size that is
a power of two.

Thanks,

Bart.


