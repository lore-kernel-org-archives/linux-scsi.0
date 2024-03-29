Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC32541206;
	Fri, 29 Mar 2024 18:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711736475; cv=none; b=m2aQfWdtG90Ma3Osc8OMWe85mh+Zo8cTXejZVRery3N3XbQnUUlkr/ZDXsJlIlf56m6K1Ltk5oyRFHruHyM7UDLd8OofFMF1nRznPtqG/Ws5Zs38hwRtDgTU6jjInPE1vQCOcEJ6cc2CCiE61qGioMMQrC7z1OYmFAQLv15hTCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711736475; c=relaxed/simple;
	bh=RG69lixKT8XbHVx5HThaYvbNC0wFCvDkG/GNVyevG1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=O/34wJbYDrLXfw3zYzCOAyuwxEuE+/FYLkJvz6a6tre/AGJA13yUMIP28Bm0+yF5XUGMShFfFYLzavYvrxvXcuAl3y0hvr+K6fvXiFlNK+W7DM8y6wtZKrbjuLS1G5e1Cm5wAvEXbISsp6h+Ihi7dg31gEo5suGt8EK54mahp38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4P5rAMbb; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4P5rAMbb"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5pcz3t92zlgTGW;
	Fri, 29 Mar 2024 18:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711736464; x=1714328465; bh=oWd4mKvBTfHIVdJ4XtrugL3T
	fCRZQd98PpL66KZWPK0=; b=4P5rAMbbzABVDZwOK+CHiFKZhkTEmN/S0+pJT6Ol
	GtbQhk5zaXO0QOt+nUoepPnvpBK0GVK8XuBUcMKlTHwL+wsKsfNgBCKuWJirpxNo
	TPQ8DfnCfBJCgePs+2Ft8yWtPWc8pSv0VdTt9PPCK0xzUAPXiYwOmblN9AONmiA5
	iIdvFh52Q2QozPqSVGJRv4hP8YoWn9xkwEJ1yT31mHyKCSpMj1WXixfm0dz7CI3K
	92vCDLxlH465cgNF6Nu/5EyXQoGiPq7C35T/Qfe2bCiGmZVVOM9tqoz2/+n5712u
	+GOsye2JpFffvjG+x6fUfkBqqTUUiT7m1660D2m2f2i6ww==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SOWuDXWEU5aM; Fri, 29 Mar 2024 18:21:04 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5pcs5YCJzlgTHp;
	Fri, 29 Mar 2024 18:21:01 +0000 (UTC)
Message-ID: <e36aac15-1090-4e3c-a402-cff56b4d1961@acm.org>
Date: Fri, 29 Mar 2024 11:20:59 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/30] block: Introduce zone write plugging
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-9-dlemoal@kernel.org>
 <688607d9-6dfe-4c37-81e8-4fea91ec8da8@acm.org>
 <caf50c25-8f3d-4eb1-85bc-cc3499d5b107@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <caf50c25-8f3d-4eb1-85bc-cc3499d5b107@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 3:38 PM, Damien Le Moal wrote:
> On 3/29/24 07:20, Bart Van Assche wrote:
>>> +	/* Wait for the zone write plugs to be RCU-freed. */
>>> +	rcu_barrier();
>>> +}
>>
>> It is not clear to me why the above rcu_barrier() call is necessary? I'm
>> not aware of any other kernel code where kfree_rcu() is followed by an
>> rcu_barrier() call.
> 
> Right after that, the mempool (in v4, free list here) is destroyed. So the
> rcu_barrier() is needed to ensure that the grace period is past and that all
> plugs are back in the pool/freelist. Without this, I saw problems/crashes when
> removing devices.

This patch would be easier to read if the rcu_barrier() call would be
moved out of disk_free_zone_wplugs() and into its caller.

Thanks,

Bart.

