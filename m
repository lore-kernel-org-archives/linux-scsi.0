Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018DB6F533;
	Mon, 25 Mar 2024 21:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711403613; cv=none; b=UMbIBfS/g9XXIh33DqvNgjZvXGMF5cHqhTyf0yBs06ICF+4iPIlwTCKP7rKhTHwQfBigrhMPcy+SXVfaWpqV9BVmNZklQFB2yujJ5sH80vtj8HZQuwK+27sF37QiT1pTg+RV1PB46swrhlmAMcRUVTqCIF3yK+5/nWXxmjlIKKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711403613; c=relaxed/simple;
	bh=Ie3epx9FMfV5IO1IjZ1R8esxCVWPB+w55HlChItVMGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SXgeQMGo7Ff6WfVQsprAomq3zko4PuWMAbAQV7oUakPpaOdsxiIcFhZrh2uEH+WN/xd5Nv947LRACzsOCDR2wh+Xav7s3GJn/B7T8503YZOJnG3XUKk3JDpvIdZmdk9Ci27Zhwfbu/Xl66CuWl3dk3OPMxF9I7kyPWG9Zb+E6OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=c+Hk+wn+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="c+Hk+wn+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V3RWv3p6WzlgVnW;
	Mon, 25 Mar 2024 21:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711403609; x=1713995610; bh=yKqm8lQwdry1AL1X2ZSwasu3
	7lQXGhDAX3yUxjjOOoI=; b=c+Hk+wn+zH2O80vc5PcbJTHAz1sV0uyi/bKYyUZn
	Rh0TFqmH/ZVDW232Ggv/2SevRuMH7M8U7Wfpn2aOFuKazcFE+C8bMa98mwO2kxfQ
	L8iFENzkmDPewmbnn1tnfsINbXPB6+HURp+vBnkHmLuOzGWh28BfAhUVnPcpQWr6
	UmDsBz/yqTNyNe/VzG/uuESYcvqvdPFfutAEF5yUgUmCMhnw6guxTktamnIICYXU
	qZ+4oV0uo6aGD//FoqQjgc7xu6i8qFya4SFHJJVbphLE4Qd7tD1pnLkWqx2aJHMF
	si1kNGhcro9hpHtLF1i5l8QUgBncFNjF5CNejvivOFu69Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PIeOHKoYi9Ov; Mon, 25 Mar 2024 21:53:29 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V3RWn3hBMzlgVnN;
	Mon, 25 Mar 2024 21:53:25 +0000 (UTC)
Message-ID: <641c122c-1dfa-4590-b908-68706721a2ef@acm.org>
Date: Mon, 25 Mar 2024 14:53:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/28] block: Remember zone capacity when revalidating
 zones
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
 <20240325044452.3125418-7-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240325044452.3125418-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/24 21:44, Damien Le Moal wrote:
> +		/*
> +		 * Remember the capacity of the first sequential zone and check
> +		 * if it is constant for all zones.
> +		 */
> +		if (!args->zone_capacity)
> +			args->zone_capacity = zone->capacity;
> +		if (zone->capacity != args->zone_capacity) {
> +			pr_warn("%s: Invalid variable zone capacity\n",
> +				disk->disk_name);
> +			return -ENODEV;
> +		}

The above code won't refuse devices for which the first few zones have 
capacity zero. Shouldn't these be rejected?

Thanks,

Bart.
