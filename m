Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6225D385D70;
	Mon,  6 Jul 2026 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783348586; cv=none; b=tyuOirvCl8c8aPmh1YzDAy4kKeURWJ8DcgFWAqIlF8hAVL2hMSV/I2NbJHz4wJTuLfi8uxPcG3Kn1fiqztUJKy9VYOcXWRQMqAv/tFdxk00Li1iigDvDCZmmXk4F1tCstjom++NR4WIcs7jhePAYeUh4RZcQQujJhEl/isqWGNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783348586; c=relaxed/simple;
	bh=DgK4DmyUkiXtPIumJrm5A39C5bExfICoZNYmIFe4mKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jAa34hL3n46j/gg6/XIBgyrOBYKth2qSxR9GWYkPI3sWxdBn1nMWrIPMHF2gxaeUtgU61LrniJV60R730SejYIQ5SeUaN7gte1+uYmeO74RrEsGiIo5Zdi30iYU8mOQP1DOlKd3jufUsS36X+p3AZGM4Yl7FddrxlZ9PwgVIdow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iDLBtxiz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iDLBtxiz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gv6P46Rlkz1XM6JX;
	Mon,  6 Jul 2026 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783348581; x=1785940582; bh=h8MocHFFKvqgIk5OWIFgXY4E
	iQwjNBAaf8nHwptNO2A=; b=iDLBtxizuUqYzfgUeni8nAlDoNqjBBU2WSjvnu7V
	uczZc9emSSEYRHASBi+VSxZ/7ftg0OkX81yZCM6j2tYR3nYFrTIfy0sB0//MI6V9
	5t+6ktiGw+XUOWPktza/jm72g4tB2EMAgTCyF4qyDM2E/U3IloCKKP73Wj8Gg8lk
	g7k8Plzpxd6AaaTnsHF441tgbRcmzmfsosssjtFDeFfut+az/1WqwIxzR6qm0CKm
	SDqhKAd0XB1lmCU68osPyBjh75C/iYQAdFEYtIb2vI8Hwa6do2pcviHv5wFrmnRl
	ASfX54LDnj5RIoWNW8cbzK8IvD+s3nxP1lsmWeDRyHl2RA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HskJwa86eB1F; Mon,  6 Jul 2026 14:36:21 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gv6Nz1yk1z1XM6JQ;
	Mon,  6 Jul 2026 14:36:18 +0000 (UTC)
Message-ID: <8dca295e-9c39-4707-bdd6-e4aeadbf780c@acm.org>
Date: Mon, 6 Jul 2026 07:36:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: switch WriteBooster missing free space message as
 warn_once
To: Neil Armstrong <neil.armstrong@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260618-topic-ufs-wb-empty-warn-v1-1-ec744a153e0e@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/26 12:52 AM, Neil Armstrong wrote:
> Once the UFS WriteBooster fails to allocate memory, the situation
> will stay until fstrim or equivalent is ran.
> 
> Mark is as a warning since it impacts the performance but only
> print it once for the lifetime of the kernel since it's not fatal.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

