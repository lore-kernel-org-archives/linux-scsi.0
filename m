Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C7E3624B8
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 12:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772801895; cv=none; b=q1ubUIEdWxkfsMtmYKwTJux8afbH9pPBkgeia5zVHa3MM4pzTRw6Uv2ZN64xNcBi7+mg+fG1aoaF0f0mikbQ11G0gMIAFMJ5TiWag3lSe1Yy30+5iOqF8cCB8O+zJh5Q1a9VnBNbp3M/ocTCpNxEfemNy5zD9Yc21vM0U9MkzMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772801895; c=relaxed/simple;
	bh=VZ5cFyA2MVw0U8rC/u4sU/JH5V0Fn9YqLuUXdUOwJRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9xpPeh0XDYMJ+7+93KkOOTeInD7yi/zPkZrKoi0Z5RxDZfOk2Yi48+IMG6BBfX+vyS2L4SCXLvwD2kmCha4dPpEGLrToZbWokL3MOEBvcTAau4UBIi9EiKqtlS5Smd14Od/FqoPsihcxeYlqoF6XKwYMHZdZ7n9/f2lP/5lXrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Dwe8ijOd; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Dwe8ijOd"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fS60565nRz1XLyhj;
	Fri,  6 Mar 2026 12:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772801890; x=1775393891; bh=L8dnhySjEDJynYBBgN2AtNp8
	Y0QW0/GbC4EJ7QY3xdk=; b=Dwe8ijOd7Q1WxPiJQSrGZfEnXhsh+vcUrulsc0rd
	2W6SBlZxRYtDMBmBzQw09TojLcceF9+xO4H90ANEqRNvAOp3pCNAwHB8qLTCs1/x
	dXtLjIu0svIbDG6A2Cp0ZxucUAXC46EWLxoELV7rhl2Jd/WSlGa7Np8WRecOgSSh
	Z6fpfpo2M7OTia+EL6hAF2n0UjLdqzg+OghDIERP/AE0ngudaFrVTFc40AbD3R8m
	gKiY8MGVfRy+Sn8GpS2VzhkzLscPv0GBndEsXOFi9Rgi8R0ceuABJUc5ipthn4fS
	m213YLi/JUveNPNzDzshDEecQ4mT59ZFrLepqPqkJZItZw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6BsiQVq3ZRjZ; Fri,  6 Mar 2026 12:58:10 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fS60010qSz1XM0p2;
	Fri,  6 Mar 2026 12:58:07 +0000 (UTC)
Message-ID: <f2edf079-111c-4150-8486-ec1791441450@acm.org>
Date: Fri, 6 Mar 2026 06:58:06 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix SError in ufshcd_rtc_work()
 during UFS suspend
To: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, wanghui33@xiaomi.com
References: <20260306072647.2991132-1-wangshuaiwei1@xiaomi.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260306072647.2991132-1-wangshuaiwei1@xiaomi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/6/26 1:26 AM, Wang Shuaiwei wrote:
> Fix this by moving cancel_delayed_work_sync() before the call to
> ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE), ensuring the UFS RTC work is
> fully completed or cancelled at that point.
> 
> Signed-off-by: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>

A "Fixes:" tag is missing. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

