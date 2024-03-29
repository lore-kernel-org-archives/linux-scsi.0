Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A733A13B58D;
	Fri, 29 Mar 2024 21:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748200; cv=none; b=pgipUjZDiu7X86ZfGpHhan7Prngzh8M/L+PSNr1YQkIJKgFWMm6cLeaqMqJt0U7U38lNKgjn4hEVVJXEYaPvKp89GaxppKYnr3Rcc8BtHFy3sQQoalBsPhuUimwxJE4cavciIVVNSe40df3Wob95RY9uPijWd68Er2YKLnTCadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748200; c=relaxed/simple;
	bh=qyW0A9i11EXcUQ9vjuF2t+J0FNRIBRXEh21IoZ/6szo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lbt2bm8EBm9lzLT171etpFiSyyX0yspRVZUaMlldR93hk4NwtVrmEzKyLUQUGpbXYWR8vrTN/inD96aJcC8ZWxUJiw4gNRbg4+6RAwTVpR+3KeGNIAQSx6GYiJt30xKNTwkH4zboSDCojJWVgdFzlo5B8LB5DtfoPkGsnZf5Cic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rp/leA2R; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rp/leA2R"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5tyZ27TYzlgVnN;
	Fri, 29 Mar 2024 21:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711748195; x=1714340196; bh=ILPcbheZHdFuGMTWruKarxpy
	4hrw4lKh6I10MWrFRbM=; b=rp/leA2RXultcYnMXa9v+UnwR3CLLwP/CjuBcuuB
	ZD91YXxUS0iXi5XHbF6WDaQ5SN+++kq1O3N1oswPBzIlsGrpo2YkfSrAtpvhv6eB
	X7lthFYp37gBRogie2AlkEEOf0N39Wihz3HPBNTUrTbsGIpGqNc3UO2qmsI7qcKB
	udyCL4/LZbT68tAcJsVmsjSJkrtow/VQgB3xm9Fx4uIF2/oQ0nNSyqKGw5rr0NU/
	H7uaMHWdsvGAB2H0NLCu9eWhfVRowYVFKR+85hDF+6MngkVqcJQCEtPx27f2CsgP
	dfRubV8PFFAS+hz9ns/ZZNoW1FlLu2kmI+YxRHLvmQWTag==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nzLAYjzdhXIG; Fri, 29 Mar 2024 21:36:35 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tyS6jhpzlgTGW;
	Fri, 29 Mar 2024 21:36:32 +0000 (UTC)
Message-ID: <b255e6ec-e698-4ceb-a193-2fcc0eaea5e8@acm.org>
Date: Fri, 29 Mar 2024 14:36:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/30] null_blk: Introduce fua attribute
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-20-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-20-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:43 PM, Damien Le Moal wrote:
> Add the fua configfs attribute and module parameter to allow
> configuring if the device supports FUA or not. Using this attribute
> has an effect on the null_blk device only if memory backing is enabled
> together with a write cache (cache_size option).
> 
> This new attribute allows configuring a null_blk device with a write
> cache but without FUA support. This is convenient to test the block
> layer flush machinery.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
