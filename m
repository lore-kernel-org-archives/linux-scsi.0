Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD2A53E1E
	for <linux-scsi@vger.kernel.org>; Wed, 20 Mar 2024 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710947674; cv=none; b=JUxlcBvA5Aq4Lc8q9MbJjDjTML/VTi65HReU57QfSkTB8Xnn5pTJyD04PVUdIRIHbAifROADqfoCbSw3I75OjIaQT11SlZ+yqKPGT/bj6ePo3QbCOWx5s01SLHlZI3pqAvemQpy6Ho6qLKAgofv58P4ExOYkXLaqtg1Wf1m59eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710947674; c=relaxed/simple;
	bh=MLIXzgkB9cgWj26D5dgtGq4LSDtERkfv2MJm6BAGNF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xi5IkuzevbwmeLthpvH7PTZ8eGVOQDqGarttR7vlzoBS2/+cbpx3UHuXLw+tLtiq8ih9OTsvRO6h1A/A2pt+GB0xJVePru4+ErwjYs4lrSIIuCCnaa69aGXH/y6vQE2eSMfPC9EKgZw+2jGWme2CUQOhQJAoQZ+TBsN1SU/2ANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=N0e1ZWT5; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="N0e1ZWT5"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V0Bvq74pwz6Cnk8y;
	Wed, 20 Mar 2024 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710947670; x=1713539671; bh=8MlsgXDLTzg4Y3u831ROjhfq
	csncf3r+0eLClFLTdf0=; b=N0e1ZWT5W674pKcd8SKnta4ZNBnTf2ryqML2MwjM
	Dt5YnSYWU74Morr3dChJ/lh6ewIsT8h2J52dA4FJmXAWQHlIypnAIAdNhz6H0YlV
	1+cdxxvHl0o3H/LscmtEEMc+wVtY5S6xD0ThJ3hPKRWSgF2gAfh7gq29arTiRcht
	AO85aMkSmTLtYFhn+8dTruzYQ1y39DTK7+/QCYpmMgNx5oN6xE1v9hjuRTcZI7sd
	BD1sri4embz9G6bkPkJFSrJf24u0uG25xVaoZUd3Yfc5r3lW6aRZ20S8JwKesYW/
	NYIsBGDAwNyaNU75QrmVrgBI++Qy98yhbLYJIj/Itc69Cg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 86tLquL3vGhp; Wed, 20 Mar 2024 15:14:30 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V0Bvn4WrWz6Cnk8t;
	Wed, 20 Mar 2024 15:14:29 +0000 (UTC)
Message-ID: <e8f9d970-2266-4ed3-9e34-c7668b4a2f57@acm.org>
Date: Wed, 20 Mar 2024 08:14:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] scsi: scsi_debug: Factor out initialization of
 size parameters
Content-Language: en-US
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Douglas Gilbert <dgilbert@interlog.com>
References: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
 <20240311065427.3006023-2-shinichiro.kawasaki@wdc.com>
 <b62b8f7d-abb9-470c-a042-c0710710da96@acm.org>
 <rzhvj5uieq4ers2ocmwmkivtbfcjyhvvpmx4ufj7ii3tgndr4r@6jpf2tanpmcy>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <rzhvj5uieq4ers2ocmwmkivtbfcjyhvvpmx4ufj7ii3tgndr4r@6jpf2tanpmcy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/24 18:46, Shinichiro Kawasaki wrote:
> On Mar 11, 2024 / 10:22, Bart Van Assche wrote:
>> Please remove sdebug_heads, sdebug_cylinders_per and sdebug_sectors_per
>> instead of making this change. While these values are reported in a
>> MODE SENSE response, I don't think that it is valuable to keep support
>> for heads, cylinders and sectors in the scsi_debug driver.
> 
> I see. I guess we can return just zero as sdebug_sectors_per in the MODE
> SENSE response instead.
> 
> I noticed that the three variables you suggest to remove are used in
> sdebug_build_parts() also. It is not a good idea to remove the function
> and drop or modify the partition table generation feature, probably. I
> think we can make the three variables non-global, local variables in the
> function. What do you think?

I propose to rework sdebug_build_parts() such that it aligns partitions
on logical block boundaries instead of cylinder boundaries. That will
make sdebug_build_parts() independent of sdebug_heads,
sdebug_cylinders_per and sdebug_sectors and hence will allow these three
variables to be removed.

Thanks,

Bart.
