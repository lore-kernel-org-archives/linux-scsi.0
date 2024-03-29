Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EFA13B2B8;
	Fri, 29 Mar 2024 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711747792; cv=none; b=dnrM3LWjBKPiJ0+5dH/CSuEZ3Dd5Exgb75SbtsGtnPIGHpDsXLdCfunmaYQLWqPQ31vrALSWhviql353ZmgGATrU/xjUBSE1JFeIqs/ALwBSyxRPfZn2xEkPGnlk704OzV+DYAGZ1X+XI6AEnHx/uRk1hvQzbUBmlWyjGXhuEws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711747792; c=relaxed/simple;
	bh=lc0NcWfF0by26pXy12hhUlfvf5XiaKWl1W5E/h87mJg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WuCer1tCIhc5IWrokn7vxu2z1CjMVDgW0saFidvLjHrJmyzSLtRMQqoHZQKoQEliYUDXXBJfjQcieC/N+40OH4aKXyHvSQ2Gqmmh5CnYd0HcUzIPR0pDMLmplvUkfiNaDQZBNl+KHz4T3UrlToHnaonZEHRS2FbNKa6WtEfEI8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fG/p6zru; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fG/p6zru"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5tpk2gWXz6Cnk8t;
	Fri, 29 Mar 2024 21:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711747787; x=1714339788; bh=lc0NcWfF0by26pXy12hhUlfv
	f5XiaKWl1W5E/h87mJg=; b=fG/p6zruj6YuZgcNnDh8wQpnZpezjz+9aKlgV++f
	OrRRn3MKuCHqW6J1boB/wK8j6bxQBAB3Zofnam4H138j47UL7A5A461RrlVbNgk7
	N88Eyngjh+s1b9n+AalfpjDy3W80jYyulppCLTUsXSeqPzCXVix7ocHBG85xswV1
	gXPFbazW/rgIJK66kC5SiWmv99G0TA3CnWgLxV57PbNVRZGIItktqqti/InnqHog
	sAvlsWvVafsb8jBvllLpaH6+ae5wJfWiZxSGwHEq2VnV3VBdN7herO5DQ8H9h4qV
	ULcRAgXwVsnGCll1vD2VS6kShmrIlMHbTX1Tv+sF8KYV9Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b5BOTmqDgFmw; Fri, 29 Mar 2024 21:29:47 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tpd093Hz6Cnk8m;
	Fri, 29 Mar 2024 21:29:44 +0000 (UTC)
Message-ID: <48700671-d3c8-4386-a2ff-a9287e571d20@acm.org>
Date: Fri, 29 Mar 2024 14:29:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/30] null_blk: Do not request
 ELEVATOR_F_ZBD_SEQ_WRITE elevator feature
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-18-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> With zone write plugging enabled at the block layer level, any zone

zone -> zoned

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
