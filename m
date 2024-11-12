Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A1215018
	for <linux-scsi@vger.kernel.org>; Tue, 12 Nov 2024 21:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731445780; cv=none; b=ReW4FsFap5owzhhYasgvsihXtp6Vasg2+VX8GSyt/9g5nCLKQjF4PR3pdeLrT1Z8VQho/MUmr+ExF6zqinf4RjyRMcLlbfrsx71EbSNceuKtKXqCEvGbJMuVzAlY/wOPoP4XpWHFa7QBzTr1zlYUnEfs8xZrDwgbpr6Obo68MWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731445780; c=relaxed/simple;
	bh=CfOTGWr9r7DRqvjCS/8CFuxRMmZwXH+fAqT1qTvJjo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ECnt4oGOK+tI3M6KALB1F0g5FTutVPspLe8y1tZoJw1bxNV4oYZQa+GYOiHkH0wqqm7cMIhPHIwxrG8Ug4MIulB6kp+HTk38pMNG6h6JlUW/qpi0mX/GBMGnsAPxtgaILCL+A1HjbL/0LMv6EBqBLrHPtGDCoZ+dP0YOWmqMDrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kDcQAQPq; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kDcQAQPq"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XnzZ92p0TzlgMVm;
	Tue, 12 Nov 2024 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731445775; x=1734037776; bh=64a7qhKL8b9VwuBIR3r16Zon
	YYfrEZkNqKhhzTtKS40=; b=kDcQAQPqqltwt7pU9+De2owuImOwfes92hSZ3E1m
	kAglSyClADt2/dYUEJTq5zq6mj1bVoGR0ENw0gohEy3qbdQIwpNcnWUVGtmHT1ru
	TKWnODbOue41IBKQ3qAmv2ZfCRLOueZAkL3Zs/Gh925L1HiT8yezGIsQYORy+25R
	oaaAR+7msbiWlsAQ8xBXq7Mvj0z3vN1U4jfKU7Ep3FVrfJqv+jq3s6ixkBa9Ly05
	KLJnhRvRPDEOVP+47z5LsFuKBhEsTP4GY4zf7idIcd4AXmMBe8U4M7ex16ikk+Md
	Lq/6QcCdYbms1wG1ooYNLr91VkmL9O1+1+fGtBwbe9O5DA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m_cXD8p9okBf; Tue, 12 Nov 2024 21:09:35 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XnzZ65R7KzlgMVl;
	Tue, 12 Nov 2024 21:09:34 +0000 (UTC)
Message-ID: <04024572-acc5-44cf-9505-b5cd2bf83a2f@acm.org>
Date: Tue, 12 Nov 2024 13:09:33 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 1/8] scsi: Add multipath device support
To: himanshu.madhani@oracle.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
 <20241109044529.992935-2-himanshu.madhani@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241109044529.992935-2-himanshu.madhani@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/24 8:45 PM, himanshu.madhani@oracle.com wrote:
> +		switch(sdev->mpath_state) {
> +		case SCSI_MPATH_OPTIMAL:
> +		    if (distance < found_distance) {
> +			    found_distance = distance;
> +			    sdev_found = sdev;
> +		    }

Please follow the Linux kernel coding style. As an example, I have never
seen anyone else indenting statements under a case label in the kernel
with four spaces. You may want to run the entire patch series through
clang-format.

Thanks,

Bart.
