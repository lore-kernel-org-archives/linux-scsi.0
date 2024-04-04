Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8B1130E57;
	Thu,  4 Apr 2024 23:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712274157; cv=none; b=Wev0UVaoidLWsk1t2weKambPMsXuQzzcVP8a/wy+J2+DYMRPgc6xsWy/bi5gSiGpNGPR9xDX8s1WOR9O+pp3OJukHU8Y8MLcl+lwS8BVbV8mVxPmAyV+EK8YNIs6hSBr6Bm0uEIgORocy5lEmtbQfyri3KX8oWLefA0nlNJUvLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712274157; c=relaxed/simple;
	bh=5OnWf4Xt+xlgOz29z2figVy/sDPXs/fL3zV4KVB5lG4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=krBE0wcEa/CfTKkgZfnFZjBENcWlg85qVMruoNZRpCq5UgcuvbhBDN0/WIB0ce6DmCE/XHaLdZSUmF1kIAEr8kY/fHJ9ZKxM2V/Q3wrNCeuKALyXL2EXCTGD7oP674dsxVD16vnzjiw3AZ0nd2oTZ6HSzm2PvWesuLXU/+/6AOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IcekslrO; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IcekslrO"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V9dT14jxVz6CmcjL;
	Thu,  4 Apr 2024 23:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712274146; x=1714866147; bh=hCNNSFTHXgF2NbuSv1+knxGg
	M+QOk7VTtWOf3chMhZk=; b=IcekslrO0yYvDrQj9oYpX8SP2P9SxxVvqpG7qQlo
	myaaJJ3coLr2VpEjsnnDcfnI9cmLwG4/FQgMeb9zvK1lbOtmzNTIL1vXSOEpFPYr
	/dGIY2oAak8OwIYC9FkBSWltcCiiC85YGSq6w0MzPfhRPbgwV7ZeNaZ6B9hqJHju
	a3p0evgcFLvB2xPvsgeysd79Kblqx1BK42AmsYDz9aFdokVoY51uqKV7AwvkZOuf
	hyqA7Ph2HKp+rnBrsGM9ZUCTDCedzaFyIohq/JLRU91Im2q9wv/74A4SEhXk6HBw
	fEIGXTmpqL9Alqz5juKrENJTajW5gLZZY+MtKZqeq4z91A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FM9lWrRTfceT; Thu,  4 Apr 2024 23:42:26 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V9dSt52y5z6Cnk9X;
	Thu,  4 Apr 2024 23:42:22 +0000 (UTC)
Message-ID: <889ca9a7-833c-4a78-9c59-328f54d28219@acm.org>
Date: Thu, 4 Apr 2024 16:42:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240403084247.856481-1-dlemoal@kernel.org>
 <20240403084247.856481-8-dlemoal@kernel.org>
 <c3bbe9ac-690c-43a7-bc75-3634af5cfe7a@acm.org>
 <6bad5d07-01bf-466a-86bb-e082ed961049@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6bad5d07-01bf-466a-86bb-e082ed961049@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/24 16:18, Damien Le Moal wrote:
> On 4/5/24 03:31, Bart Van Assche wrote:
>> The order of words in the blk_zone_write_plug_bio() function name seems
>> unusual to me. How about renaming that function into
>> blk_zone_plug_write_bio()?
> 
> To be consistent with your other renaming ideas, what about "blk_zone_plug_bio()" ?

That name is fine with me. I hadn't suggested this yet because I wasn't
sure whether that name would be correct.

Thanks,

Bart.

