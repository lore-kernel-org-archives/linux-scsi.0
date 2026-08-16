Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46D94B04B1
	for <linux-scsi@vger.kernel.org>; Sun, 16 Aug 2026 13:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786885474; cv=none; b=UNfHZ/Byeei2avXlvyE+RTgnm+6vIqHQvmdDKOsZRVIEaJK0KATIDLKNpXkO4gJQtLqsIi26u7UNVsdug/v4alfcT1xoDWG4xJieWogkF4VA6QbvszWEgYsGe0kTHR7UBw6rxykI+fFMJHE2hHyaCmxHuxvzNGroKKvI8MfpbIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786885474; c=relaxed/simple;
	bh=+SM1mqKjDsLv1yi2Fz628v66oZSELSzpGNjY0lyuq/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfIKicHB8urQQ+AcI0PCYkKJjeu7aEKvWwTsiLSOToIQWsPm1PgN4bT+L814lvy+RCWkImWe69CvCZ+hSPzwEbFK3dlzobznlVa3HxVbhOJNxzFbxE1C52GG+eyeSATa+15C/9yfIfEjQvOZVSZ/CQX5iPZvZdHyo9FFq11SeDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oYrj2bq8; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oYrj2bq8"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hNGQ25Kl5zlfvqJ;
	Sun, 16 Aug 2026 13:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1786885464; x=1789477465; bh=+SM1mqKjDsLv1yi2Fz628v66
	oZSELSzpGNjY0lyuq/U=; b=oYrj2bq8MMQZWe6xq487bdBVJ2oStXOr9m/blrFE
	oKRjt4bhI0U/cmEON+kCrxbGbUXwRcW2Vk2fbK3V0uj47HkCgBDgS62BKF+ppbaw
	VSSC/DuZI45kE2X1VlWz3Os7jKJaqWi+bhtLla8ok6XzL3o37gm1eEANDTDWVGsU
	tcqtN7EhAHWdqXrTAoURUZoopPjhCDRV9tNK0uJMV0jYpUQZVJkmm3ESNRM/e7RF
	VSo2cdispvu+ZCR6LxO2CmyKSCl7LcnPPN0SScWLauNiCgEXD4FucS3kX9AHX/Kj
	Uopv9+/mqv7W0M/noBsg9lI4oW/h3k3+Nl6FJcV+0JQ4pQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6N2f8I69EbLb; Sun, 16 Aug 2026 13:04:24 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hNGPz3qW3zlfvq4;
	Sun, 16 Aug 2026 13:04:23 +0000 (UTC)
Message-ID: <6d22ddff-d4d2-42fe-8b01-0a17d0609e81@acm.org>
Date: Sun, 16 Aug 2026 06:04:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Disable queue depth tracking support
To: Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20260814214951.80673-1-bvanassche@acm.org>
 <20260816121050.GB66924@unreal>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260816121050.GB66924@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/26 5:10 AM, Leon Romanovsky wrote:
> I believe we can drop this comment and keep the patch limited
> to drivers/ufs/core/ufshcd.c only.

Hi Leon,

Agreed that the ib_srp changes should be removed from this patch. These
changes got included by accident in this patch.

Thanks,

Bart.
