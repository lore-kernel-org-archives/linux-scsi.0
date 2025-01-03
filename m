Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083B78BE5;
	Fri,  3 Jan 2025 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735865710; cv=none; b=oF8xege6gtMTjVWDQs1Z+naot4r5z4G/TSkncHRYQrKS5xaPDaA2i0L18XP8FXYAYWfXrTXpgPllDayk6OEYoku6hKl5Yd/wT2a+hmhM8t2y2wO0L8rgHvdXKCApsFpDkgBBe5R9ziGib0R3pI6tow7e4OeRD/mtnde/+02f6kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735865710; c=relaxed/simple;
	bh=nAlIjIQ9CbQeql6qpQuRtEPkrP5H9lf3zn9ixZI2ncc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vAluhd5PXPLHbHP8xyP8Pajix4dp4zxPpGl+7qSxZbbxswgeTiaD+z2wiruE9tCDazi1I+DEXn199bK3JP2ya+IMMd0Uh79QaLcUhREdpiEe7Sv/yOAmqjtaaIY7EAvHLcw2u+UVI/P9DHUbtBoe88Q6zNZrLuTEUEGCHRx3gek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CSVpdB1L; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CSVpdB1L"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YPQ4D1bfmzlfflL;
	Fri,  3 Jan 2025 00:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1735865466; x=1738457467; bh=m8x9FB66FFGLK/cKk1vcxqNe
	Lm3IX+GFbU3yVKEVRQc=; b=CSVpdB1LPP/bk5jPs0pokdneHaXbwf2qpG+KBC5o
	vOjNU6pXRUODm0o+/PEkxag6Mp3/XM+lGlbeKXKp0hbf6ZFZ3grwAzss9BHbOLdA
	LqUYw6hRnxv9igiZfMcAPjxxtWVDstCcSPGsS5EMsKeBgATiPh4COvnjMWnqgYTi
	pxlZwZz/wH8Syg67pKxYxIu8LaU6h9Cr/Q3pKL+kT+8VneKki+ZfbwV34ZqfXmlO
	+16P1YC1GEJD6DhA+1UGecL0Gzl6S1qO+Q9EPK4p3c+J56IcDlJIx7MDHgm/cGh0
	p9OV2XpL7dmEr83CZOyxVMx8LqiBk7b1km8EPhXLRP+skg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0wiKFJC3YkCO; Fri,  3 Jan 2025 00:51:06 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YPQ474zTKzlff0R;
	Fri,  3 Jan 2025 00:51:03 +0000 (UTC)
Message-ID: <c933571d-a87c-44b9-af44-4fd9230cb319@acm.org>
Date: Thu, 2 Jan 2025 16:51:01 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Revert "scsi: ufs: core: Probe for EXT_IID support"
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Can Guo <quic_cang@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>
References: <20250101134140.57580-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250101134140.57580-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/1/25 5:41 AM, Avri Altman wrote:
> Although added a while ago, to date no one make use of ext_iid,
> specifically incorporates it in the upiu header.  Therefore, remove it
> as it is just a dead code.

Hi Avri,

Although the patch itself looks fine to me, is the description
accurate? "dead code" means code that is not executed. I think that
the code removed by this patch gets executed?

> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 27364c4a6ef9..155f0801e907 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -23,7 +23,7 @@ enum {
>   /* UFSHCI Registers */
>   enum {
>   	REG_CONTROLLER_CAPABILITIES		= 0x00,
> -	REG_MCQCAP				= 0x04,
> +	REG_MCQCAP                              = 0x04,

Is this whitespace-only change really necessary?

Thanks,

Bart.

