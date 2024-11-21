Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC99623098E;
	Thu, 21 Nov 2024 03:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732160175; cv=none; b=HxISM9j8ep+an4/KH9tC4KN+g2ZJP49Xkd6BYcXdFzD3/LqZ/O9AjAbYQp0oL7I3bmjgj0P+zn8P9YuVfKgzAwJRcQKg6QgtSj5VDUXZQLIeLGh3SAcG5o4AfQlpM9/kRZ3zg1YYwM+1H0tWpJ7bwC1geXe+UKhiStEjo/8LuK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732160175; c=relaxed/simple;
	bh=ojDAgE6ET3xq5uXlQ+cUKjtsix9D/L5aVGcIzb9qoto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pMsUbWaBdn7lA1IJkeje1huQ/ijYN4clkSomwboG18OTEaB9O/HPpNUJEFY1LNB4pm0W+Qz4lmySywSyzkd4g/nGP8MBobNF2fV0WkHatpGvqPEF9yPqPhnSrFHPc8Y1vpy+jlh8sM/U0akBS8VbaslTvEFkxBdMg9zGR3cVgXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJzW1hSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJzW1hSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E33C4CECD;
	Thu, 21 Nov 2024 03:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732160175;
	bh=ojDAgE6ET3xq5uXlQ+cUKjtsix9D/L5aVGcIzb9qoto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gJzW1hSQv5IQ7nubb9/tq8I9XFi8NjBxaFcNDyST3q6p0DnGxP7U9Pbs/++DPg/JB
	 6nf9VXYhXrGigVmpRFNBaNWUrTNZZRIYUgZuOqptEUYImPc0I1Ig4NMetwFQENMP39
	 VBxxZlB4Qqkm15znQi7KGlpbH5/LuK9tgSeDDmNH6QCPs9tpupRMkkZpMa84R2OxAx
	 /RwDXJnGsSxruiWVYule7n1MqML0A/GPH8+QLZQbIZNQ2wsxrhbtbxh+piCFrspIO5
	 LGEhDOqdTYCCNPHZ+sVxYCTLGT1cTsYH0Xh4Wrpjs8/ZHPpn2tg97lPdkb8xtZTRl9
	 Is5q++7xyDFxQ==
Message-ID: <fae2ad97-2269-48fe-884d-bda3617126fe@kernel.org>
Date: Thu, 21 Nov 2024 12:36:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 17/26] blk-zoned: Uninline functions that are not in
 the hot path
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-18-bvanassche@acm.org>
 <c8cd9037-4487-48b5-80dc-2ee35c1fc972@kernel.org>
 <c95b067d-b39f-49b2-8428-1897609041c3@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <c95b067d-b39f-49b2-8428-1897609041c3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/24 06:20, Bart Van Assche wrote:
> On 11/18/24 11:55 PM, Damien Le Moal wrote:
>> I do not really see the point... Anyway, looks OK.
> Hi Damien,
> 
> One of the approaches I used to debug this patch series is to add
> trace_printk() calls to track zwplug state changes. trace_printk()
> reports the function name in front of the information in its argument
> list. I noticed that the function name reported by trace_printk() is
> incorrect for inlined functions. Hence this patch.

Maybe add this explanation to the commit message ? It does make sense to no
inline these function with tracing.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
