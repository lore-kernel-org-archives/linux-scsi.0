Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BEE30DECB;
	Mon,  6 Jul 2026 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783347048; cv=none; b=BngRy5i0whF/Ih5Qrf6/NdE2h8G1friIeE2pESeFrqLeeO+jgqEhzvQsjLD8mcfb3BKBL3rGwe72D5YcmjgX/XLsiDPl4Lz/7poi8ykC99hrxkF+1oAulHQoVY1Q05XlxzuT2T8mhCk4iTjCDukMBq8dFh490HRRew8aY1Nu9C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783347048; c=relaxed/simple;
	bh=pR0sfPewLqUjkvilAE3sjmZNNVe5yhV2yVLlfN77kUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7dmcI1jutXJuKqhIMIieiJMDLLcK3qbd6qxt+76oFxxJrGvsrryku4A4YchIF3qA7OZm9O8u2EyYpJjtOBt1QxdpF1vkBFdXtVGY7y/kmT3YB1EcHnXaLWXQ5KXUVR86Aj6xG5JG3X03ih+DEKuq76Nf1q3oZWxVSbbZCnpG/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Nmo+NKTN; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Nmo+NKTN"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gv5qV5QDNzlfpM9;
	Mon,  6 Jul 2026 14:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783347043; x=1785939044; bh=12uaOnO3hyvTf2UbJyGKDu0v
	KtvT5CdVVK/2N66mqc4=; b=Nmo+NKTN5BKXLj+z2E+lzmzmEZ5Cf6KJLSrdqPT1
	QBooPjD7r86zmhN91GTzJwqQEqu0W/Mi0hObjZXOCi3hD8YvA49oOeNF+5D9w7SO
	bgBwHBGee+JPdIz8zAr5OX3vLvhXR/nz9mFZrIsCy9WqleDbn/BRSF9FTafAhvEj
	qePuTkfXpLM7lonuIfMT9Y7ffuAPhQ1lHFGX6vLzJYl3pb/UL4qfartJimlTeI1C
	DMLKWcVyn9urtKWti1UTeBxfzdfrN8+qYKZDNkSVDYZchq5XZfBjURj/NvJ5NRFR
	l5R6clI0QYoyun6etY2jnmkEERAPPo00npDM7VZz0ZBfYw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pv_wTnKquzXn; Mon,  6 Jul 2026 14:10:43 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gv5qN3fhdzlhH04;
	Mon,  6 Jul 2026 14:10:40 +0000 (UTC)
Message-ID: <8fc64eb4-d4bf-4231-ae0f-2db357b58a0e@acm.org>
Date: Mon, 6 Jul 2026 07:10:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufshcd: use str_enabled_disabled() for Write
 Booster messages
To: Animesh Rai <animeshrai853@gmail.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@sandisk.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260701175152.7446-1-animeshrai853@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260701175152.7446-1-animeshrai853@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/26 10:51 AM, Animesh Rai wrote:
> Replace open-coded ternary expressions of the form
>    enable ? "enabled" : "disabled"
> with the str_enabled_disabled() helper from <linux/string_choices.h>.
> 
> This reduces code duplication and allows the linker to deduplicate the
> constant strings across the kernel image.

This patch doesn't look like an improvement to me. I don't think that we
need this patch.

Bart.
