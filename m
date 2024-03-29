Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8621DA5E;
	Fri, 29 Mar 2024 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711738484; cv=none; b=VbzwSN13FGRlVmjC9rxQOQ3gpzbISJ8Y2jdvuCbHiz75lqtoPzQg4AMR5v1HMnVSeJQa8Y4wyJu4j6JcHL0BjQ0Nmfu8cXEyXt+nqdVojU95N2slHooPHADlohpLNoZWJoQGVEQ2mkWOGpHt/LSa/5nqUf2G46lpRed4RzpBvQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711738484; c=relaxed/simple;
	bh=U84P2UZiEwJFidbEUjKKDPrxU1JnOtZMvldeFPWtuaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=okcSVez7AL4nsvrww+8XH6sxPcapKR0NdBSmswyRuJcC4gKnr8HEMRmnzeD6EfP/pwV9oBeZMaH23kwR3l/TJNBEMczdVLJpTxbDXLtlZUuSjKyge/J2S90foMazc3Wfk8U4VpQBJU05sMsuBy+RwJtUREEq+b/ZmcdzNMRPTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RDrJlwFc; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RDrJlwFc"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5qMj4LlXzlgTGW;
	Fri, 29 Mar 2024 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711738478; x=1714330479; bh=Luk15JfJt4tSBUDO/lIjil5U
	4uWJ6kI3NEcDIpjaZ0w=; b=RDrJlwFcF7O73W64IAAXHSjL5fxvW/vKPTB/zrNV
	YuITZp3+mJoeMG8rI0AaXSMZJhEKOOSNy21snAK6llKhHsty99CPwA150updXZwJ
	PO6EtV0G6v3ado8mhZPra/HUl/yOu07Nm+8quDsoxJPUMALMCXAz6lAUcraErAF7
	ooxcu1iGbvMiG6is3YXCQVOaVp982aOxpjPI2FexbSvOCtFk6kH3BpQnYIy1Uw9y
	te+UpNl8umwzR9B54OcCdk1ACJHkMc9k7kWxQab0lCRN2ebroTYe9B0Ie2+fFDUL
	vCkkVX0zvxDpZYVsEjzC0/7h9w6bnus4n3ku9SnPsNlfFg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GV5JYmJTWhW4; Fri, 29 Mar 2024 18:54:38 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5qMc2V1XzlgTsK;
	Fri, 29 Mar 2024 18:54:35 +0000 (UTC)
Message-ID: <bf23c77d-65b4-43a7-b173-7a5c2c6fc652@acm.org>
Date: Fri, 29 Mar 2024 11:54:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/30] block: Replace zone_wlock debugfs entry with
 zone_wplugs entry
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-28-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-28-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 5:44 PM, Damien Le Moal wrote:
> In preparation to completely remove zone write locking, replace the
> "zone_wlock" mq-debugfs entry that was listing zones that are
> write-locked with the zone_wplugs entry which lists the zones that
> currently have a write plug allocated.
> 
> The write plug information provided is: the zone number, the zone write
> plug flags, the zone write plug write pointer offset and the number of
> BIOs currently waiting for execution in the zone write plug BIO list.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

