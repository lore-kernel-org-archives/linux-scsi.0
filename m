Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F851F416D;
	Thu,  6 Feb 2025 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738857269; cv=none; b=QWI9ztV0betBxJvuJBhiWttEl3jlXmkzFvjGP+eyXLXwrh/FZevV+S8yyo7wXiYLm8a6UeTRtd/sJeqU4oNxSz4f0u/uwyBVAcJjpaZFr2Bzl6ZK5dTlbRC7yvX0As7t8fGOSUcilvlcIpVHb6hhEv+YH02pdtK+8LSIiQgUXug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738857269; c=relaxed/simple;
	bh=MABX6xVCTVYjqfhW7HCIEvQlyd3hFI0FBMQSjwhEX4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gs4kI/7nuswsoLq6pAITHhKfJFnmXSGROsOt3MVVrkDnmhxgP86TWb0MdRZxZYoM7h4f2MlK2hQg1KPV6eqNa+lP+d/h5zB6qowOOsHln0GDxtNizmddW127pdW5vXpnAhT8wUDNlYwSthDYFeg+17ni7jaLIlcMIC7gKuuwUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WHoZLrHu; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WHoZLrHu"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YphVq52sRz6CmM6L;
	Thu,  6 Feb 2025 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738857265; x=1741449266; bh=MABX6xVCTVYjqfhW7HCIEvQl
	yd3hFI0FBMQSjwhEX4M=; b=WHoZLrHuy62dhmq1EZlReF8SHjop/c2DkxYfpIGc
	1vA6yatDwUnrR/UnnA7MCHNv+6cdsd4jXr1jis1T1nFBHAObCQW0LqvnPoPNvj9V
	8l/c+36VidJGKJypyRT0a5wlJrUVNudDpmJBuFnkvcGeDSyepukjK8P8FFql/RMz
	gIl847y4KBZDsYx/7tpXkB04nV4nEckhuncyam0q8Ca+dBN1dRymqWOihpT1vvy8
	zHn6P78TMFk/8gKQ9oTGerhgFlnYIg9EnTfOUJCw5RE7aQa76+p02BDSZdhjWUrV
	20EojEZ2pcZrncmy8jQA6p0SMC6Cpc3qY1r4mT09NgCEYw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 69iNgM2IxfKn; Thu,  6 Feb 2025 15:54:25 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YphVl72WZz6CmM6D;
	Thu,  6 Feb 2025 15:54:23 +0000 (UTC)
Message-ID: <b962df63-42c4-4bc9-9815-9871be1ce2d5@acm.org>
Date: Thu, 6 Feb 2025 07:54:21 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: critical health condition
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20250204143124.1252912-1-avri.altman@wdc.com>
 <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
 <DM6PR04MB6575FACB152A64BDA4B4F5E8FCF72@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB65757320A1761FE473BFC5CCFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65757320A1761FE473BFC5CCFCF62@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/25 12:54 AM, Avri Altman wrote:
> After some further internal discussions: The set conditions are
> vendor specific; The device may set it as many times it wants
> depending on its criticality. The spec does not define that nor what
> the host should do. So there is this concern that some vendors will
> report multiple times, while other wont. Hence, reading
> critical_health = 1 might be misleading. What do you think?

How about emitting a uevent if a critical health condition has been
reported by a UFS device? See also sdev_evt_send().

Thanks,

Bart.

