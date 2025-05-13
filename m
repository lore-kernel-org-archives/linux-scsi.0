Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9300C1F098A;
	Tue, 13 May 2025 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747165159; cv=none; b=Gb8idDkaIv6q4m72DI5+YE71EqLMJAljnIBnTKp2kPhGLVPAJIAgldeKtISQx9/2hRPS4yeRzz/06K4FhDbnvzqtpp+JgcgagAwJqSuN2OngSce89B/4hCxBIbkGPrlLB6tTmjNThRGVijj435lW5/GK9Bn1OZ+SBgiPcsIllgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747165159; c=relaxed/simple;
	bh=1shFHY4kJtz0oI5zPIYpAeK/A+xuI8MIOwlYL8H86bw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3ORTEkEuGmXpHJS1t37g8amz/VOo81cs2rwd3OuFlb5wzo/MjdybP2UZ84ypjzaV8xGel3muY7p/G7Q1bErWnR0jF6vQadHaikbCvwSxA8W8WDTxMtOdfcy7PkKx7KePcUXywabwkd1rBzxicAcy2z0R24CzMIWd3QvdhxDk9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zn7NRM0t; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zn7NRM0t"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Zxmxm2HM4zlvnLs;
	Tue, 13 May 2025 19:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747165146; x=1749757147; bh=1shFHY4kJtz0oI5zPIYpAeK/
	A+xuI8MIOwlYL8H86bw=; b=Zn7NRM0ttt/4/PstqrfSbmAsnJ70YbjjIaT+ypsV
	E89WDa0HOOnIEmDcxoIlo8VNhc+xQ1huEsFFKpiWCIm8FPZ05UEWBRwekQCAvJaR
	oPV1elZrQ9UsOzSNkwmHYK221Cvmo9wjxqgm9pvmbSyYNkjfs/vkImqZmFu3fuPQ
	AiYWOm0mc99NleaPUiebUN247bPG3jrfTG2vrG0Q3naWNjbxRDMeRHQ1qw8lR15v
	oJN60mI2jj/rVgCmrpZHHWE5n/I4AbnDJitP/2YnxjmQ6aadpiUi97M8cHC/q1/v
	+vYwB3AuvZE9WcdRlI87G3AKrtymMlsTZZmlC2Khpwccxw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YmXNaaPw4iC8; Tue, 13 May 2025 19:39:06 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zxmxg1pnMzlng8g;
	Tue, 13 May 2025 19:39:02 +0000 (UTC)
Message-ID: <c0865d5a-12ba-425c-af5a-1da1a06ce426@acm.org>
Date: Tue, 13 May 2025 12:39:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Add SCSI error events, sent as kobject uevents by
 mid-layer
To: Salomon Dushimirimana <salomondush@google.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250422181729.2792081-1-salomondush@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250422181729.2792081-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 11:17 AM, Salomon Dushimirimana wrote:
> A per-device ratelimiting mechanism is added to prevent flooding
> userspace during persistent error conditions. The ratelimit is checked
> before scheduling the event work.

Isn't the above an argument to use ftrace instead of uevents to
send this information to user space?

Thanks,

Bart.
