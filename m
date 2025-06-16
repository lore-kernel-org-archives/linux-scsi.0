Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30770214236;
	Mon, 16 Jun 2025 16:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750090744; cv=none; b=qQsi59XtlPPuS/LoyuEnohw2bWr+na9c2pvoeW1BsRyBUI0SM8khthtna4KTKvga3e4s8g1NAl9TZcjc6Qhf6Gxoq6omhQZmtDRpIrzcPVWKe0Ek8wsL6TV5SFAvlCN7tz0uBZMdVo7e9PB5GKPccVVjstVH9asJDlqHspyOdmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750090744; c=relaxed/simple;
	bh=vNhHW5dg6GReJadydX/LuZNflj5jbfPBFe7d5xyXAFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jh1AZ1rGuDnSBYWNLZmIzth7vvNHYG20lKX1gnGokZUImxnlm22WBP2muDnw7EMfNTMBe8wyuCZ8kuvGvoJsYOr/hTfil22ghxwNH+jLKW4lzEfNjd0iBCwst+4a9DQ/G9medBoT21efIuvaeY8LovD7OECG+JBFlF6PB9LMQmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PO7YVfUO; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PO7YVfUO"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bLZv36jrZzm0ySJ;
	Mon, 16 Jun 2025 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750090733; x=1752682734; bh=6wC2gwimnc3l+Xw9+5+MBM67
	AOIiYYbDZC+GpSzNsL4=; b=PO7YVfUOX9bC8pnhFFcoQfuKAx+vsYtSrRKjAyRm
	CFO/noAxj//F7emgHgnnroYkVSOtuPbPaB0vhQogugRzuNRimplcqBKiQhkTDxHq
	ni8I2P6NVl//blknGVCOXtLfou2bIlLvZqAuIFFhGisULhy1i2eCc6gta23TjhhG
	nv2DesA0exMNuq36jjsMfIbFnEb7SuZ1MerJMVctuLIgHBV7WoJujNLaiw0Bmo02
	r7xD+710UOwEaO0lsGz1dG/6Jv1X32lNaatFrW/V1AdpG4DvPHp7UDRtdwKki+uQ
	WMFBweudA8bDijco6gedWp+TrZ/UnJxRGzFTq2x3a/D6dg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H3JDOKb3Nser; Mon, 16 Jun 2025 16:18:53 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bLZts2QLGzm0yTC;
	Mon, 16 Jun 2025 16:18:43 +0000 (UTC)
Message-ID: <bf8ae60e-032e-4b72-afb6-4448a7f949d3@acm.org>
Date: Mon, 16 Jun 2025 09:18:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
To: Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Christoph Hellwig <hch@lst.de>, "Ewan D. Milne" <emilne@redhat.com>,
 Laurence Oberman <loberman@redhat.com>
References: <20250616160509.52491-1-ming.lei@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250616160509.52491-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/25 9:05 AM, Ming Lei wrote:
> - storvrc uses virt_boundary to define `segment`
     ^^^^^^^
storvsc?

> - strovrc does not define max_segment_size
     ^^^^^^^
storvsc?

Otherwise this patch looks good to me.

Thanks,

Bart.
