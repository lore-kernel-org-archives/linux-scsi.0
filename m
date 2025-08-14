Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B17727701C
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207445; cv=none; b=ME+yPgDtk6Juw/ibVqfuYFcaETnOChArtddkfOpSYhgsqy95Kqj2UKmVNaagvVdThADFuL8ECgW4F2p75V7r+IYOJz4ntiOu3iTuFeEEiD4CBHYuhicWBfy/BxhXowSBX10qiDQpIsEGaLxrc1zJXgCVjz0PQej6TbVqLVHrAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207445; c=relaxed/simple;
	bh=FKS/WRsVKCZBh78LjcaV3kXvf77M4LjXdS6wPOKFy4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tc5ad9ywz2Vipu05ruwPXlE34/MkIM6QKsvjS8+mhqUPkY74D5xkLsbJMH2j0zbH0uguodIj8jc9JLZSvfCbJT4FnW0w0p0bRc5pel+rRfL4SbG01OQS/QaTf7oNsfWxD1qHWsZ4/PxSxMCylppRrNowL1sRcpNL4UUF5LzKgno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bcuk7UuV; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bcuk7UuV"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2z9G4bcgzm0yTk;
	Thu, 14 Aug 2025 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207441; x=1757799442; bh=5fFEoS+DzfJMwtNYzxQpxrmD
	JcdpXefLzbQXhg4jbc4=; b=bcuk7UuVtgkrOP5XEp8BV32K235oFmx0wUs0j2nL
	aYblsRw5u/FVmqFIhAbeXfxbJ3xpb7nB/IgHv4gcfSJ3ew7LTBZDTeJ9IwsdFwl9
	Lihm1hdrCDfMYCCYJvmXFrkKSOE5nyGM0xORaE/TUgTTFit7MnNucYMVCNYwJRle
	jVdxcn258c5cNVk+vfAtdh141XZLWDDbMdSecHnjGJgFfNs+AahxlvaSlO/W8M2w
	2IV3F2plPxar730hGy9WeGq7esF0UFTYrLviddb5DPZxUZDBHuJL2PPFl4DJtMZA
	ntrSpLFprpC7HbmmUw8KHgDSvde+bcWkuWr/rQFLZyKdjg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ch84gYWcsPJ5; Thu, 14 Aug 2025 21:37:21 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2z9B3h9Dzm0yTf;
	Thu, 14 Aug 2025 21:37:17 +0000 (UTC)
Message-ID: <47d2a5c0-f9ff-4b62-8692-24a4e5f5f63e@acm.org>
Date: Thu, 14 Aug 2025 14:37:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] scsi: sd: Check for and retry in case of
 READ_CAPCITY(10)/(16) returning no data
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-8-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-8-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> +		if ((the_result == 0) && (resid == RC16_LEN)) {

No superfluous parentheses please. Otherwise this patch looks good to me.

Thanks,

Bart.
