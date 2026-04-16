Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC69022A1D4;
	Thu, 16 Apr 2026 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351965; cv=none; b=d0/VkGuaIEeW2KiMQW+myt597dAivZ+XOmcawOxrMp9H5sIJ62Y7YJqUxWg2RxqT49z416YbMo27AyFBK97c9Uq/sK8s63p6y+PFExZ3v5EDM2YfRy66rC7PeIJ7w+suH8As535BxweH/PcYd30iqoU0NJB3K/3+h2tvlAhoovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351965; c=relaxed/simple;
	bh=P94d0czA0kVrOf+BpXWyRuuo7wFUqVaQDv593wR5EkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFWNtOHfk0nTbeVplVHGf3NjAEAqICcKuyFaMK0tLbuZFE8LWOvPYRJ3UvaFYb3XKQpd/Q8ILA5slX2aexGp57vgflOjHBYhIrBcX0xiOSC9sYqSiAPfWBJAxARtynKTK7k2ZLET6gqz/Deb50OJvb9xhzuv2bayDSPu3AcAzKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=R2objZ72; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="R2objZ72"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fxLtg0vCYz1XM6JS;
	Thu, 16 Apr 2026 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1776351958; x=1778943959; bh=+62CXLRM1uzSBuDTgZ8plgok
	i7DM7W9VerjenFTMs0A=; b=R2objZ72wH2D7lgZkR1G6k2JU0QrxI7q3PbighRp
	nnPh+yiuHltsSXcAihKAOK7aZzT5x/ysPen6DwqN1aTc1LOdocTSdZ3eZNvDYTuV
	7oUD1yBAwLMoUiyerLL14qEKpcFxQBvMWuHr0fk2pD1PvBO5+wNP2z5fQP7C8lYa
	AwuPdSFMcnnTUGQPRLCQjeGHi/7WFG59cW1Ixji4ID3emFDmNnznWzDysMCFaSyr
	YM7U3erVx5mmwdDAS73c0M66X8rm37tp1pHY25b65HHoNbCORYRaQhGfBXMzAiJN
	Qn6O31SF/Q7drl9fWueZpH95jqQ+M5oosLFI71jBxFd20w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 95N9jNqz_Bq5; Thu, 16 Apr 2026 15:05:58 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fxLtW0mmYz1XM6JN;
	Thu, 16 Apr 2026 15:05:54 +0000 (UTC)
Message-ID: <718b7e79-8fd8-4c96-8feb-9ad237d46631@acm.org>
Date: Thu, 16 Apr 2026 08:05:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] sg: don't use GFP_ATOMIC in sg_start_req
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Doug Gilbert <dgilbert@interlog.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260415060813.807659-1-hch@lst.de>
 <20260415060813.807659-2-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260415060813.807659-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/26 11:08 PM, Christoph Hellwig wrote:
> sg_start_req is called from normal user context and can sleep when
> waiting for memory.  Switch it to use GFP_KERNEL, which fixes allocation
> failures seend with the bio_alloc rework.

seend -> seen

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

