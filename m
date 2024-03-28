Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C111DDD5;
	Thu, 28 Mar 2024 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711661524; cv=none; b=X5fCRWQ0XqhJvWc8StU3wCGPCSsSvjh6iS7udQ0W/dh6fNJY7QAq+ho7WnBQf1lcLfOg0wdC32O5fcEKg+gUrDk/KBTXUi4bLUmjMlh1zTXfiFketMRiUBPW3SujbHEnfOiFawRA/BefZrc77Hkch5Vig6S3unsBRD/EU2lmAEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711661524; c=relaxed/simple;
	bh=ksg/DMS1bxH4ci9zDHJu3QBPaiyJrb+/OpfKms9PbmU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l9tzCzJ3ol/MGzlI0h/Y9qKDWZP0TMdxI1fkQF10c8B4ZySHP3z98MIb3gGDnZaFRf9iA0EmRVK/JZXEjjmIUjkZ03RIs6RT8OxCmkOTl7oJ/uaLBQdB3GC3NTMi2Etl6M4+NZR6FiEr5NNlto4HJn9T1lLyRdQ9VHXjjFUdbbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kj7rSatT; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kj7rSatT"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5Gvk4twjzlgTGW;
	Thu, 28 Mar 2024 21:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711661520; x=1714253521; bh=ksg/DMS1bxH4ci9zDHJu3QBP
	aiyJrb+/OpfKms9PbmU=; b=kj7rSatTaqYNmgtdm7OdbCpNUs3WbpN0DUznjiMI
	s25jK7EI3aiZgMT+w+TGuNIa6d4iy4PVrNtfU/ytvsKG40pZZkfioMFIhGfSRAR0
	kvSydIlwugESGpuRfd7OTvDZ0hvKV4EfXJfh22UsbOCzoZ+NcYXgPGYlbCCmNeq6
	wzC3HYFs8MLCbBhO5XAsRJUuJToomSn0TVHCc/BPEHLLsKPn8DuRvGX5jNngYB5i
	zXN5ZQCj1asx2muF1wdXtM8PNEtd7Rh2gANKYufe083lv2AW19/0+t1jGQ9z7OyC
	5Q1oKxt/Cb2O3HptwWDJGSYOhm1UeYQsQRtHcAyNf1ONzA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d8a6biSl8T5g; Thu, 28 Mar 2024 21:32:00 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5Gvf5VxCzlgTHp;
	Thu, 28 Mar 2024 21:31:58 +0000 (UTC)
Message-ID: <44eedc5c-a5be-4e60-94cc-c22e7a187ce2@acm.org>
Date: Thu, 28 Mar 2024 14:31:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-5-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> On completion of a zone append request, the request sector indicates the
> location of the written data. This value must be returned to the user
> through the BIO iter sector. This is done in 2 places: in
> blk_complete_request() and in blk_update_request(). Introduce the inline
> helper function blk_zone_update_request_bio() to avoid duplicating
> this BIO update for zone append requests, and to compile out this
> helper call when CONFIG_BLK_DEV_ZONED is not enabled.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

