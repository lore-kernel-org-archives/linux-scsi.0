Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE613B8D67;
	Thu, 11 Dec 2025 19:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765479722; cv=none; b=kkDurMlmX9X2FYBFL4UVRjUe3R9SdQ+WukC8+N6KR4ZEriBJ9fhQVgFsGmluVFE6xfn5C56PENFIZld5Lf1C4JP2pmRV1mngv5liHEIdb/KT1WIkydsLk/3hdpKDYYtglKs9BTYpOdZjTUJpnzkB68kLv52SZSRcwrypBMuOWkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765479722; c=relaxed/simple;
	bh=++Qq4XFsvlgO1t3jN5j83gdhq2yEVcIJU8PNimYlSaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BFEnZsA28uXf+SAE+1RIZA6CTlmAW3blW+83k3pB5LGCWTrcozxgYIY/d0jGZcFT+tsy3nO0QjsENREBEZURLOnR/q77VoyIz4REN4Df3dkxvDM70kczpIGYgUylvysCIfNZ/79R/0YWBbD1cSj6pQmyz3uUCGPIgLIZ1Q8ybeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W6/lzoND; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W6/lzoND"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dS24y4TxlzlfvpG;
	Thu, 11 Dec 2025 19:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765479712; x=1768071713; bh=++Qq4XFsvlgO1t3jN5j83gdh
	q2yEVcIJU8PNimYlSaI=; b=W6/lzoNDupX3DomTxyELw+sYTt7BMsoUoKBzQZ6K
	td16u0+2l9zuMgwsAEiJOMomp4oGhwYDw5+xj3A7mO2lWKOrwAfnGBPw0jElOuJw
	80Xr0zgpxdWDvGajAidZsGiUj7vTAglAJboTEnyF1v/SxY4c+JTHvrgYZ6HlkDki
	3MGJWkT3R4XuZg0bQYZ1x+al9U8v4beRO9Poh3iFfVyVtNwjrAhmy5pGx1C/eBSv
	+CO11oMLP+CZvqfK7iMz1Dfwdy0xrO9S0UmTY/TJkmI8nLBcsTJeY9LdaE8AV8VN
	19AxWeDojus6lchCI1G1EXv+fJTQxHe1xJJ9brnguvfavQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id khwxVY5FJAlv; Thu, 11 Dec 2025 19:01:52 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dS24s6hmczllB7D;
	Thu, 11 Dec 2025 19:01:49 +0000 (UTC)
Message-ID: <8b6d2a9f-dde8-47bb-a896-e1a8c5108e51@acm.org>
Date: Thu, 11 Dec 2025 11:01:47 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: mcq: Refactor ufshcd_mcq_enable_esi()
To: vamshi gajjela <vamshigajjela@google.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: avri.altman@wdc.com, alim.akhtar@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251211133227.4159394-1-vamshigajjela@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251211133227.4159394-1-vamshigajjela@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/25 5:32 AM, vamshi gajjela wrote:
> Currently, ufshcd_mcq_enable_esi() manually implements a
> read-modify-write sequence using ufshcd_readl() and ufshcd_writel().

Usually this type of change is described as follows: "Use ufshcd_rmwl()
instead of open-coding it".

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

