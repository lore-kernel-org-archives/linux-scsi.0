Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10912797AA
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207481; cv=none; b=H36tf01S0iQ7kKdArCERDvLDqpfM+ESXeKoAeJ8trOJGSlS/pe8eqf51moq7KYsLUKcdj56M8iH7plZAgnRm2imhuOF8IraajlHITqwpl8V/qU2OqFtkW2FMVvjfJG0EXryUXxa42gLjFNqUSmo8U/SV6usxzVlRSgD28Q34ORs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207481; c=relaxed/simple;
	bh=H1EVGGtyfspbOKnIAIosVDzUG/EnM2nw/Jf4X+cuzts=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GmMnl1vAHtKGwphw4y+/nE+tdgeLvNuO/u/akwhgYQmTzG1CNb3WCPF7LViY7Ng+qU7K55BZe9aE+qzsflFqO7XaiI4uN/kGM+U+Vip8VrodKTTJ4CxtKDHwv0vDfG0HqgRFKI9st0BcdDmRttuHR6+lXWm5LQbt9UC8rJaWYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sxPR0/O5; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sxPR0/O5"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2z9y4xhjzm0yTf;
	Thu, 14 Aug 2025 21:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207477; x=1757799478; bh=1Ae8b4vndEvEpL/lfFsOwdmQ
	VjeTM3zDmHqDuk5ikgU=; b=sxPR0/O53kjJps56Xk3smW1RB7Vokbm0020Jh384
	dazdE913/ejlIygV4hRZMFELRgSrv9QhT70aKviWpbqMP2bD8nQVAaZwPzklFYRt
	pMaX8vkK2p+Mt2qThQzQwUqQ0e6ZmG2SuHydQsVga5alXtqC4io7vNsSieeQ/w1Q
	DrA3bs1WuU8qXRABpwdx8ZmyfEmxzCn8iFL+GYAtnL7YRdrFCwnfUV7oE3cYHSW1
	7iURDSQ0iFM1FJZf2IsSzNB/8uF+mLCUTc82TSdvUslbv+P1tJ4N2iGzBRzUiZO3
	v3RmP9g1Oqb/oH+kSS+D4bBSpHZYVGJFwLaqI1yevBmsnQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S94S7qDXblhK; Thu, 14 Aug 2025 21:37:57 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2z9t3d73zm0ySm;
	Thu, 14 Aug 2025 21:37:53 +0000 (UTC)
Message-ID: <6fc92366-f317-4627-9697-9d451d9ccff1@acm.org>
Date: Thu, 14 Aug 2025 14:37:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] scsi: Simplify nested if conditional in
 scsi_probe_lun()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-9-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-9-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> -		if (result == 0) {
> +		if ((result == 0) && (resid == try_inquiry_len)) {

Also here, no superfluous parentheses please.

Thanks,

Bart.
