Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE2013792C;
	Fri, 29 Mar 2024 21:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747356; cv=none; b=dgo6O0B2xnrg3xADN1nSbUHv2E5Y2EA4B1GECRsFIaJnYvfYw4sgeHO1tdMoziF5BOfqLnFUubQIFyDySFnHMk28cJ1bPPS1acot3mv2kJKZWapFekuzXHtJIEnnmtXDki/CfPFZdQQJw9V+Z2Vf5ElxkbI0AtQG5MX5Mu4L75Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747356; c=relaxed/simple;
	bh=QgZYRYaa8a9iCxhW7qjxiU+OnRe8oTJFGisnmUV8P5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ci7dGmMqGGsuVGyepHSSP09+E8Zl1grNEDYInDkkJIbfaz0gFqOOfogCwPguqr1RDI3H/zYIEx9qplQgS8u6x3srtXvfpgfieya664gNj+/iblyn3eyGt9mmpCQ55Cobi4xCh6HVDQOsvOrQeDYrf50dwf8ZJqpKdi4wVVHIZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vqlBIOnm; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vqlBIOnm"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5tfK6FbzzlgVnN;
	Fri, 29 Mar 2024 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711747350; x=1714339351; bh=QgZYRYaa8a9iCxhW7qjxiU+O
	nRe8oTJFGisnmUV8P5c=; b=vqlBIOnmERprvcdhibbbOjSOXSiGVzGIYUBgy4t2
	f659cctbeAEw6pf19gZrbbQ7JegB6djAQB1ep9oAMzVksnZfYUbAhl3qvcR0Aoic
	3howFRbyJ2JejMPnnlnbviz04FAxLU240YDqGqDa2510ryTCWPgc5jpLlEkRmFT8
	Svq8+kNnXoENsWpoXpwXiD8FiAqh6NbfIr+w0NJCfTDcmuroEM5bxDGUFUTowfBT
	ZrJmsoMDbxtMEnBGFJlmwnk5rG+qoqKSqi2SstX7lVcShaL+BJVPW1J3sRIIb3+B
	tZpWO/GYo10SwD8OIQ36h9rmvmkmB5A7wbzUdKebMxOyYw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qEUGB76_WZXP; Fri, 29 Mar 2024 21:22:30 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tfC6gcvzlgTGW;
	Fri, 29 Mar 2024 21:22:27 +0000 (UTC)
Message-ID: <35ae7b56-b624-4bf7-b112-35c620719e11@acm.org>
Date: Fri, 29 Mar 2024 14:22:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/30] block: Implement zone append emulation
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-13-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-13-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> Given that zone write plugging manages all writes to zones of a zoned
> block device and track the write pointer position of all zones,
> emulating zone append operations using regular writes can be
> implemented generically, without relying on the underlying device driver
> to implement such emulation. This is needed for devices that do not
> natively support the zone append command, e.g. SMR hard-disks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
