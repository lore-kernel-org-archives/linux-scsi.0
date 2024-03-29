Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9A879DF;
	Fri, 29 Mar 2024 21:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748714; cv=none; b=f0T4RU4MrSeKg6y5hSz7ralPuXyJ3GmkfleZN+8ZB7vY9MmfTXtLcopLpiK+3dKP9Q8fO7Nz1NKN52iJbQMAYcYR3oNRhN4PJKEjZrnmSO42eel5P3NDIiH1Ho7j8dm+Ak2OV4sk93VljXnaMQi9Q9G5dsC1nXmW8dC9RKERjQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748714; c=relaxed/simple;
	bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cQbhWLGdLv56FA+g4e1Qn0OTMyo1PrUHqIVNQkbVdzIa4MPUO2oq/4sxQ3AFO6s8xlArUsx1gn0KBOfEHpltlc8iRFWk6eeM/028ssXMt1PEdzw0L+nsJl2orgmS4B2ncVQbrrKlVKLCxsMHL2hc6WKxrf9bt1bRVobUmZ9/wXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3p8xQGqR; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3p8xQGqR"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5v8S6K9dzlgVnN;
	Fri, 29 Mar 2024 21:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711748710; x=1714340711; bh=FRIggP1YvWWV3rj+5WU1Cj2n
	MoZrQOSbDSPE/2jMC40=; b=3p8xQGqRCoLavO27/ItRd0QrNFLp7MDHlamTXy/m
	9u0HPVVWMfPYvV8JgBPGaea0nXLRsEU9Cb5oF5owc1+iTC8k72KXB+SXMuh0GcHC
	YKmDjW4nW0VvKWH4aA8iiJU1UA6yJYoprWiUk5Lj5k458nE3TfSCMQSUBwSz7UJk
	ClQgkK5KobK2uxuM+tMpXzxTxcXdVWdGh6viOqoGthEdLy6Hl3CbIB73r9U9YWSs
	h37XQubBIH1VmlC6JJA2XPyKJHib3PTQzcLO+yBzCIG5OkSMN+dQ1dayaQKN50t7
	3NPVmOuF1yNvKiHad2KTHO8F7QZQW2m90LtBdWgrC7bzjw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Hee33N_fJNrP; Fri, 29 Mar 2024 21:45:10 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5v8N0jWczlgTGW;
	Fri, 29 Mar 2024 21:45:07 +0000 (UTC)
Message-ID: <df018c8c-ac3c-4556-bfc4-6d44bb877718@acm.org>
Date: Fri, 29 Mar 2024 14:45:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/30] block: Do not check zone type in
 blk_check_zone_append()
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-26-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-26-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
