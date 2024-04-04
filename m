Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB39130AD6;
	Thu,  4 Apr 2024 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712257500; cv=none; b=CyCGQ2llpI8+ct1cJ5TX5YZe/YuEsFQjhw3aWp+MK+SjBNw4ZCky4Ewyz3Szm5o4popNY1IaPlEOTfLqnMZ2wvBWBATAkzjd/JgQ2xPGYZKB0mMxu6e0xNBmphOzFZkvyDG0Uh4NBtY94DsWGfEVv/iLlgC6Izz1Snbnj8wTvl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712257500; c=relaxed/simple;
	bh=Qdf0hOCIsqICXNg/HmfX4nJquVLaNONycWsHwUiLeRI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ocvoaNRy+YT6ifnWQSScVv6OGKJPjbJuqVkYXrFrRVH0OMoI3Rf4ZMv19M8WYDQ5CbMaFvWHD4l19l/om3UlFw2yMME2yI9btO4eMP7xpyOH2q+7EP5w3am6elq+VRYcLSnSu4+H3pBQHAaHmAAYuhpqcaYS/XCq5ZrbvBul0T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=I/D4TLxF; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="I/D4TLxF"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9WJm6q9JzlgTGW;
	Thu,  4 Apr 2024 19:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712257494; x=1714849495; bh=Qdf0hOCIsqICXNg/HmfX4nJq
	uVLaNONycWsHwUiLeRI=; b=I/D4TLxF+fg0FHnVoMGoPznge8gJS08T6awXDBem
	JuikBakcZt7aZ3yepKwvgGq0xRkIRpFjxGKP26AgCJ3jdeAxqeVJJFqmxOp35tFA
	s8tLGEjICxaKlR4reewEkUVwW1Jqfx6o7e+++rzbTxGONHMG6UsGQPC8The9cwV5
	lZRoDbEa8Br07DfqTUSDGTf8sCPywK3mPN5EEU3CP5m/we01E1DjVQFYT6EcrPsH
	eYDh/nVRXlxShkXPCOzuN6xuCkZjiZDB1GAvAn/FdtiMA/foxd3s/ItjzbgDS9cC
	WrmFWn3L9kMRvKevWxR7cokIZQ/yEi2ozxr1qcTUnE6GSA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Bf1mq8KR3xRF; Thu,  4 Apr 2024 19:04:54 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9WJg489fzlgTHp;
	Thu,  4 Apr 2024 19:04:50 +0000 (UTC)
Message-ID: <acd9961a-ed3c-43f6-94a4-b5b3df6ce9e7@acm.org>
Date: Thu, 4 Apr 2024 12:04:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/28] block: Fake max open zones limit when there is
 no limit
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-9-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240403084247.856481-9-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/24 01:42, Damien Le Moal wrote:
> For a zoned block device that has no limit on the number of open zones
> and no limit on the number of active zones, the zone write plug mempool
> is created with a size of 128 zone write plugs. For such case, set the
> device max_open_zones queue limit to this value to indicate to the user
> the potential performance penalty that may happen when writing
> simultaneously to more zones than the mempool size.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
