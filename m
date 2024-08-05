Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E247D15ECEE
	for <linux-scsi@vger.kernel.org>; Mon,  5 Aug 2024 23:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901117; cv=none; b=raAX5z7O4i4G+3pBS+X09uXLHjqv33ZW2I0aIXyr4KcKYySXDtuFf1JNsVY7lAiKEdvUCrCgAXXvr1gsZVOtifDNx5cHOjSoglF2DXNtssolvK2EcUcf7Uz3y700j6LcA2OBUSLEE4kspEw/KMFFKIXcFK2WN4MhfzQ9VaGbr2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901117; c=relaxed/simple;
	bh=NEavT1BMFgdSQJIG5WbdauSiJpx/LfWm1IegTmO2Avs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PTvJMtPsiNtu+f/Juv+bRO20CM/u/17rquwvqHIu5fGBr5/D9fW4K3/8jFqDq0BCZMgLD3dxObc13YJyAFS7U1BocJgOJkJVQu3c8oIm8bqARRU1ALny5/+Pwue2lF+gaIf3kN/shfF8Cn+pQofIuELciw4ue1FMpI4GG/hO2kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WV/FRJ6h; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WV/FRJ6h"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WdCYl1hy4zlgVnF;
	Mon,  5 Aug 2024 23:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1722901113; x=1725493114; bh=dZw24zHleknEiucDEx5cgAfb
	crhyM6TOTN/9Ju/Vixk=; b=WV/FRJ6hZVXjKWw3eqgZ7MVVr719Yjc3lNW77eM3
	7GO2pxmOh8dGniDqaG2m1+qC6dg9hKelTyeZKt7+GyZmn45GWrnOYRT88F9T4hQI
	G6n3gp3a43m55igVR6Nha9ODMkfc4uC9PSSkkfDWvyfh5LSuxO04AImFG3js7LcU
	PN5MxwatA4Y/dVTb8qcYcVBFtUdrK6EaI045phjq9SQsI1gBUR6mh+YyBE6cMYl2
	rfGh2itoj/MBk1wmsedD61DXgf6ElVXKJCvLEy5/ECyhjzVWq+mp6vGT/bYi9Xk4
	yQH/PreTgVaERoNAxV3Ha+WalgBk/hHtD0RqkcYNwYoGVQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rfK7rEhFACBL; Mon,  5 Aug 2024 23:38:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WdCYh6wjnzlgTGW;
	Mon,  5 Aug 2024 23:38:32 +0000 (UTC)
Message-ID: <98771368-86ca-4177-84de-55e8e9c1c734@acm.org>
Date: Mon, 5 Aug 2024 16:38:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] scsi: sd: Do not split error messages
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240730210042.266504-1-bvanassche@acm.org>
 <20240730210042.266504-7-bvanassche@acm.org>
 <ba1abee6-8f02-40c6-9e60-eb68667aa0fe@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ba1abee6-8f02-40c6-9e60-eb68667aa0fe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 4:47 PM, Damien Le Moal wrote:
> On 7/31/24 06:00, Bart Van Assche wrote:
>> @@ -2856,8 +2857,8 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
>>   	 */
>>   	if (sdp->fix_capacity ||
>>   	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
>> -		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
>> -				"from its reported value: %llu\n",
>> +		sd_printk(KERN_INFO, sdkp,
>> +				"Adjusting the sector count from its reported value: %llu\n",
>>   				(unsigned long long) sdkp->capacity);
> 
> Can you fix the alignment of the format string while at it ? No need for that
> extra tab, removing it will make the line shorter.

Sure, I will fix the alignment of the sd_printk() arguments. Thanks for
the reviews!

Bart.


