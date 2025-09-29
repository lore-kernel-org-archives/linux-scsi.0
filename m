Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D42305968;
	Mon, 29 Sep 2025 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759164071; cv=none; b=JWYrBIx9Cr5yKHs312vX3bPMyiLcHNQ0lPjWXbYcNEuw9tEqTmsSF8wDDa8UDrIe80ZM9iWQUqs2bV0np3yhBOkmkv/fNWFp5eb/xr+FTy6P3b0OSuhE5MYpAae1eNRlHwhpq/yR7XgCMC5s4BjbyHFbgOf3XK4dVJm8kRNpYU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759164071; c=relaxed/simple;
	bh=eA3CY1JD5axGZ/GGRfWXbA30WrC+bPgs1tJvieVH1dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8p1x/okvHkDi7xVaMzi7df3hjYmjcWCmCpTXHzfqyMaghtBSLUOz158uvkR4v90wUhUxjZwj0Hy2QwDyuHzbsrFKgE3YpSeV8GbPIrocoLJYbKAM0OQIi+hkmganr/Aha9ekc9MKJumWVHgO1rz2pvFhbvwNQzmzh85189HMhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SyL5KcpI; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SyL5KcpI"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cb6QF11XqzlgqVP;
	Mon, 29 Sep 2025 16:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759164067; x=1761756068; bh=eA3CY1JD5axGZ/GGRfWXbA30
	WrC+bPgs1tJvieVH1dQ=; b=SyL5KcpI85lgcgO/fIj9RmlCQJ3KbUR7bVybC963
	ueNDn/zvXV1/HL8bO3i8/efPwujN7dmqd1L9EkDwms4esmiRvyjrPN8WF8xbYCNF
	muibIMMWyo+qjFuq+AixQK1DABwEiROIoFmtWtxwXKT39ULEY9aMKjwRE5aYfWmE
	m3aea8uQDku8hS27wwpZOa+HbO31TGnwua1+SJqlP58N4x1vWjGRWDNhRSAFkCXn
	SHPZkfWFywrTmoSeghC8rwUZwabuZlfaY0LLUif6u/2GWg37hfJAawDdQFMRBYT6
	+IGSI7gnye+k6VhkaB3B8gyxWNAh84wOIWa8EqHSWodRgA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Yzaq_wWtRVjD; Mon, 29 Sep 2025 16:41:07 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cb6Q651pLzlgqVk;
	Mon, 29 Sep 2025 16:41:01 +0000 (UTC)
Message-ID: <7129a520-5def-43c5-9195-ec945850bf96@acm.org>
Date: Mon, 29 Sep 2025 09:41:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Fix PM QoS mutex initialization
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
References: <CGME20250929112740eucas1p284c5c49f54fec23c55260edf07aa1138@eucas1p2.samsung.com>
 <20250929112730.3782765-1-m.szyprowski@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250929112730.3782765-1-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/25 4:27 AM, Marek Szyprowski wrote:
> hba->pm_qos_mutex is used very early as a part of ufshcd_init(), so it
> need to be initialized before that call.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

