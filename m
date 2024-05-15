Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB767EA4;
	Wed, 15 May 2024 04:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715747577; cv=none; b=lo3kMGyl/SEu3CoGTfHtGt9uQ6+ZknvrzqM2s97vpTFdS/9ZTKlnOUjrG4PH3CpEHZlsX9rLkLmv7Sfmy/l6IQIUJtOSQJeLVIPKNcdhAtfXB3q4AevpGO2A1eI0TE8cDhs6Azy++Ul9l+a3A4PQjFGagB76L7avxZRn22wnC1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715747577; c=relaxed/simple;
	bh=Yo39EB6jrUbAacBHPv9rywt0Ai871FVruWXcOiDl+4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfpHAgDs74aD4TyYDZGC+tkFRu3AWh0bZ4ndJvbEwy9GDg6fGUei+i3Vjga+EJFU7VM4t1yQzB7VEMCOuaPu9WMzXxHz46ksUZ+d3a5Y5PvEHfqpihCotyp2MNUjPPQWQ8iF8Xbz9GPk5RGkKdaxNCF+qaEGqUn60wPfa9ZWc8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kBXOlXgZ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kBXOlXgZ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VfL1Y15CkzlgT1M;
	Wed, 15 May 2024 04:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715747567; x=1718339568; bh=Yo39EB6jrUbAacBHPv9rywt0
	Ai871FVruWXcOiDl+4E=; b=kBXOlXgZJAHps4T8aAmKvg5inNn66MhJTttx2fpa
	uczaUU3WXnsbOu9B7uCN9K8TizsBQojJB7csXtnRiLSMaFSB6TUzBCiGBjqfOA6V
	QKfDzGvoA8Bt2407dkjBe5LonGcCHDoFRaJujtB1w2w39abpr0NU4GlwscYsa00w
	V9L+eI+fbMRS5dPBIPZ2nLP4n+oZf0hVj3wSilTPFRxWrSL/fp084w5mgePvgdzR
	p6VPU0xboUwszMWhgu1jPJgZ3cwk5+blSP2kZYfBEMbUlS+kY3o4lXZYEh7sLZ0N
	5Z/GiscBTqkhmhiGlp6nQiVItqY2PElbvO7afVHBVS5T7A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VSczGBCQHKou; Wed, 15 May 2024 04:32:47 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VfL1V43gMzlgT1K;
	Wed, 15 May 2024 04:32:46 +0000 (UTC)
Message-ID: <de19c4be-ef6d-4b1a-be26-fb697ac29026@acm.org>
Date: Tue, 14 May 2024 22:32:40 -0600
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
 <0300cd4e-46d6-499a-98d5-72360c94ae49@acm.org>
 <DM6PR04MB65759D4064B9FBF13BBFCF72FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65759D4064B9FBF13BBFCF72FCE32@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 15:07, Avri Altman wrote:
> Bart Van Assche wrote:
>> My understanding is that the above check won't work as intended if
>> ufshcd_rtt_set() does not modify the RTT value. Wouldn't it be better
>> to add a boolean in struct ufs_hba that indicates whether or not
>> ufshcd_rtt_set() has been called before?
 >
> My intension was to not override RTT should it was written, e.g. from user space.
> As this attribute is persistent.

How can RTT be written from user space? There is no sysfs attribute for
configuring the RTT value. If the above refers to a mechanism that
bypasses the UFSHCI kernel driver: I don't think that we should preserve
any configuration changes applied this way. As an example, the SCSI core
does not care about configuration changes applied via the SG interface.

Additionally, what does "persistent" mean in this context?

Thanks,

Bart.

