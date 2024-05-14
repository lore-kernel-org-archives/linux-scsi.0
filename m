Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD25C1DDD6;
	Tue, 14 May 2024 20:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715720063; cv=none; b=Zx88V7oiwzZoz9Onl/r9IdNAx2eaz0Ur2rSP+O57Y7iRmzQ8fvAeGz2veRwqtyVktJII7MbSXplAT0XOrvzq4iukM77JSTizrPY28zI0kPvdLy1XhuzM7eVIlv/rnaU0iHeUNTlb/Kso5VARI74DNhIy87BtrNFS7QNv2m4bfnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715720063; c=relaxed/simple;
	bh=k9c4buxNu05Aufa9vu+21j4fvkSF4Yhlj0w7eGVwrtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G4j9nvC7Qx77WAfEIvHDV7awlU4CY0ceXkYhQoZG5N1i2g1+VjG6V1/s/GAYZ/FQxVj4rMI6evzUu8rwxFzdERxzuqg90KmsgFGRGwstaRFuyokUwsPERwWyev6ibzVMRlbIqEpvBkqzrpZe3Ny/13/cDC/piabRL9JEBpEv8Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3OmKJQvT; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3OmKJQvT"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vf7rX6CxWz6Cnk90;
	Tue, 14 May 2024 20:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715720058; x=1718312059; bh=IrNZfvETl7WV5WxVHxU5OxkN
	BAGTJ7bQra6C27GqQbQ=; b=3OmKJQvTWxx5XaT0ZKR+B39EHIuBkyUSELFQXCH3
	MvbwbdjlwfQtwIVum7Rl/xVjBqg8rUdrl0FhafoxtND1l2yJTv1ql5ohTJm9g0Qb
	fhVfmRsGGYnErQpnBx7cHKa3o2GgW926ukb0ymdFgK2Ag4wLjd0T7fdWq869OxrJ
	GCXlj88K1bjARurv5/Sbvs244lBrvyOvBeYES4jBfSE73Q/b+c6ZSAzCKcRf2XUH
	YpFRNlw+1U8fS2xRZj1/YTgzJ4DYusFxbhMggw4un+XY1jYLWjv0fPuDZFLonigJ
	1qkN5JhaR4+3YP0rhJsA27X08OdvpFyu+MrQJ1nZr6mB9A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cBeT42pl3TTG; Tue, 14 May 2024 20:54:18 +0000 (UTC)
Received: from [172.21.16.125] (unknown [50.204.89.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vf7rT3lxnz6Cnk8s;
	Tue, 14 May 2024 20:54:17 +0000 (UTC)
Message-ID: <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
Date: Tue, 14 May 2024 14:54:14 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: Allow RTT negotiation
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240514050823.735-1-avri.altman@wdc.com>
 <34c50f23-82dc-4b53-b8cb-e5c07c6e0106@acm.org>
 <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575CE65772D92073360FE64FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 14:34, Avri Altman wrote:
>> On 5/13/24 23:08, Avri Altman wrote:
>>> +/* bMaxNumOfRTT is equal to two after device manufacturing */
>>> +#define DEFAULT_MAX_NUM_RTT 2
>>> [ ... ]
>>> +     /* do not override if it was already written */
>>> +     if (dev_rtt != DEFAULT_MAX_NUM_RTT)
>>> +             return;
>>
>> I haven't found any text in the UFSHCI 4.0 specification that says
>> that the default value for the number of outstanding RTT requests
>> should be 2. Did I perhaps overlook something? If I didn't overlook
>> anything, the driver should not try to check whether dev_rtt is at its
>> default value.
> JEDEC Standard No. 220F Page 150 Line 2837 says: "bMaxNumOfRTT is equal to two after device manufacturing,"

Thanks Avri for having looked this up.

My understanding is that the above check won't work as intended if
ufshcd_rtt_set() does not modify the RTT value. Wouldn't it be better
to add a boolean in struct ufs_hba that indicates whether or not
ufshcd_rtt_set() has been called before?

Thanks,

Bart.
