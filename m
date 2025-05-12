Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCC8299A89;
	Mon, 12 May 2025 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747088439; cv=none; b=AehYmHsBBe3QfXH7A3VxHimCwYT8YguIR6KAuHSxIW34W4MTW6u4Vb6DjLfsOxdT5YSzjGutQr48JqGkYXKPUfoH4JWGQfAv+S/XOtbwiGj6krZGykq3RKAOgjHrw7pqSS5MGWCYTgLVU5mkKwcyi16J15Po6IvuNKNjFlueinQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747088439; c=relaxed/simple;
	bh=BjWcCR3N9hkfpjvPuw/RADWmZupgdpE1gUPzbn8E3fw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WX5wuQ0oZF8pr/aJmJdbWq7gWZx6CL5xEdj50wE9IcnmUj7h2k8DoJy6eIV3yeerRjiPwXgehfHRzKttSTNUC8nIim5tflu9pzMgiWAycyAxTJGT2hyVhyQdfzec/G/+pJ7RVY15Zji7ZesJTNp7LnGm6Hsq3SaqP2Nc8WEperM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MzstLUlO; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MzstLUlO"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZxDZQ1M1Gzm0ySR;
	Mon, 12 May 2025 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747088428; x=1749680429; bh=BjWcCR3N9hkfpjvPuw/RADWm
	ZupgdpE1gUPzbn8E3fw=; b=MzstLUlOo39QA68aQnopR3M6GdbRNAQpq8Rdxb7v
	bwxVl9V4HJDrp3in/lxeD8tkgk5di4DLV5+HtDjFfA0oSiLK8HUszIbLQkQQ0INE
	mvQWueipj2VjhSFm+Mhv/I6BamQj/TQx8f36l5KyiNev5bOWgTdwoIDZnqh0+nwP
	vj2CrbgwRNZQDU9Ju+6lSASqm422OE8z3uDfQ5bsqEUEmnW0vTan6tKr11hYbIR8
	LiyH5Pkvfdg8P6lxvxPm4DGntz9fR5PRVf+v8e5T0184is22Yn1bmWts9ddAAXi9
	1rptlayVzufJPzgZOxqplow6GKi7UPW1agMnqdW/+dEHcA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Tv-Q7IJesitq; Mon, 12 May 2025 22:20:28 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZxDZK5JMGzm0yTL;
	Mon, 12 May 2025 22:20:24 +0000 (UTC)
Message-ID: <99c5ba18-2000-44c3-a8d8-d1a4270fc050@acm.org>
Date: Mon, 12 May 2025 15:20:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Print error value as hex format on
 ufshcd_err_handler()
To: Wonkon Kim <wkon.kim@samsung.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250512025214epcas1p273986e3b3bb3451e4039094d21611e86@epcas1p2.samsung.com>
 <20250512025210.5802-1-wkon.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250512025210.5802-1-wkon.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/25 7:52 PM, Wonkon Kim wrote:
> It is better to print saved_err and saved_uic_err in hex format.
> Integer format is hard to decode.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
