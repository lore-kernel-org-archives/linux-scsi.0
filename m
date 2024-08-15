Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D56381B9;
	Thu, 15 Aug 2024 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723744064; cv=none; b=V/mjEzSnDbP5ZY15LxV81VFzaSRqx8M741vhlMjDo8351vboe00TNRHG9Lu14FDzdC+GGJECTMUtQ+WwuevZ9kdF6rEjSWS4X8W0cj9MY9rTEyIW6cWbkl7qn4+eXkcI+zgKQAYsNCf4ALa7qbJRmilenYFsH3XPOkuGerVG5cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723744064; c=relaxed/simple;
	bh=DTY5vhhVs/JFNuUFMNzI7mcxoohJksI8QzqLh34g294=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMR6OzS94OaJEcCWouPc7YSM1f3o+RYh2UYogAtzvSPq+ufrOuJrxiqJsVusz3sTLru2HvMm/vgJC+j5aeA7eBUIXI/iRW4SdxBsQCZ7l05qqCmTsNxOGIS9fI0aAI1e250CgyKIunBgkh80VdiXOxycOQ7iN/P8kWJ0CjY+kO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MxKGdfXE; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MxKGdfXE"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WlCJ83GN4z6ClY8q;
	Thu, 15 Aug 2024 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723744053; x=1726336054; bh=DTY5vhhVs/JFNuUFMNzI7mcx
	oohJksI8QzqLh34g294=; b=MxKGdfXEQKbSpQIAD6+UxQ7iSouXuwNJhBIHTE3c
	vbytkuTYqmKxpMTHR67oEInSusNueT1qLr9mAsOZsJtsLyuOm/9o2qP5Qd2RaVym
	BFyEDQNKeYDIxxE3iAQoPrEx+V1PoBgjZWjPlryXBVtuOaxCUyWQPrlZ9nORmcJf
	2ZPhB1TajFvVrwxdGJgJZBd49GKCfx+0ca4SlD0eK/62uhIRoMC+1n17o5rvhhsr
	ZOr213tFH8NLoYCYRwMr3ntBhM4nbVt+TvnvEwM2HBvrEybFHTg2ykTEr6DS19Bc
	eOpY/nbWGLrcNn5IlwyQ6QmFe3m98VOUVPJ9zAXToGka8Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ngpqyb4JQK5x; Thu, 15 Aug 2024 17:47:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WlCJ34Wgbz6ClbJ9;
	Thu, 15 Aug 2024 17:47:31 +0000 (UTC)
Message-ID: <b613d16f-1167-456d-a5cd-807db875adb9@acm.org>
Date: Thu, 15 Aug 2024 10:47:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: Signedness bug in
 ufshcd_parse_clock_info()
To: Dan Carpenter <dan.carpenter@linaro.org>, Rob Herring <robh@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Brian Masney <bmasney@redhat.com>, Nitin Rawat <quic_nitirawa@quicinc.com>,
 Can Guo <quic_cang@quicinc.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <404a4727-89c6-410b-9ece-301fa399d4db@stanley.mountain>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <404a4727-89c6-410b-9ece-301fa399d4db@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 4:24 AM, Dan Carpenter wrote:
> The "sz" variable needs to be a signed type for the error handling to
> work as intended.

What error handling are you referring to? I haven't found any code that
assigns a negative value to 'sz' in ufshcd_parse_clock_info(). Did I
perhaps overlook something?

Thanks,

Bart.
