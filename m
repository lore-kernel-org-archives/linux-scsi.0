Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17701E008B;
	Thu, 26 Jun 2025 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750958295; cv=none; b=CD7AQf2fZOBm77Fg8RpjNamlS01q6sfA4Y89YvxSwMojdzGNrWqq1CUJrRJPPsbprRNMgUJuyOkvzhMNybvWNxaBvYVAn/sz+jZlUnq0OWw67/+0IL4/mdscvc7ou8DG4yWb5DOUoB9b1mjJW7MImykFwxgrzBfapG2HPHLGPC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750958295; c=relaxed/simple;
	bh=1f7wed8XYHY6XPhic6jgNyzg1EhaCjzmjAC4efSpuqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsZIkbsA97oDmEy8O5SMmYPFGzkRX6k2oJK6PGdf2XOBqQdxJsyREVO3aJ6YMHkPiAMnXbMIPnOcNSXWkXyT4qQn3pd+XYZpygw3Z6lkd2e8no2TRNQt/GBhjN6gf5AXfEhIEP0lJZtJjRpoD2O3wfVQj+WlebegieCTJ8xjOQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Was7X4rf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Was7X4rf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bSlkl1VypzlvNRr;
	Thu, 26 Jun 2025 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750958285; x=1753550286; bh=kwUjOM2XgYAyH/Jd0ooGBu7b
	Dfs+PEdYCPIs3qj/MhU=; b=Was7X4rfOsHU66qE9T7l7GMNOh+wXoBLlWCgEpdK
	YDoFIxnWO9mol936N5vYaQg4u+VKhBa0e8idWuM/Jne0x8qI5SkGAE5CM04zBAx8
	qlXs5PgE+6cB0nY5Dx/poM2YPaGgyx94on19+IQGULIPxzApGrJz4OXzbDEIa9wJ
	BScsKqNijeaWeQnGdvG/tFMRVQTHha6gsvnoR24fypI3wsnbaIWCw6CIUbsB2T9x
	m7C+syhcqzR2kLd1+CJG1rngPxag3zBB6NFy5ydX1NwlR1gRF1K3xD2vBMZMb30/
	Uc6CPQAA+9zu3ULNYVx5NrrTiOc+wS/GZIXXGjPYXAW7PQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JP_WNRLA7VNz; Thu, 26 Jun 2025 17:18:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bSlkd2f1qzlmm7x;
	Thu, 26 Jun 2025 17:18:00 +0000 (UTC)
Message-ID: <1e4651ff-77a4-49e3-84e4-7b42ffc45034@acm.org>
Date: Thu, 26 Jun 2025 10:17:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 03/12] block: Support allocating from a specific
 software queue
To: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-4-bvanassche@acm.org>
 <c22a7c1e-8d57-4d71-895b-fc2913404f0f@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c22a7c1e-8d57-4d71-895b-fc2913404f0f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 5:04 PM, Damien Le Moal wrote:
> On 6/17/25 07:33, Bart Van Assche wrote:
>> A later patch will preserve the order of pipelined zoned writes by
>> submitting all zoned writes per zone to the same software queue as
>> previously submitted zoned writes. Hence support allocating a request
>> from a specific software queue.
> 
> Why is this needed ? All you need to do is schedule the zone write plug BIO work
> on a specific CPU. Then the request used will naturally come from the software
> queue of that CPU, no ? Am I missing something ?

Yes. That approach may be acceptable for rotating magnetic storage but
is not acceptable for UFS devices. Inserting a context switch in the hot
path would slow down UFS writes significantly.

Thanks,

Bart.
