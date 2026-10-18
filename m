Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569211CAA6C
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 00:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792282742; cv=none; b=FGj8q4rZxMdWYKxz4jP5JF2426r1X9Xn4oJVF4ZicGhP2JkmG4Ysw3iBA/JlMv1nVKTXAhE3i93B5t5YUBgXXFr9b5Ww8cu6UPvxrtJvce5EGsOflFPVooI9QvMxbDz3KCvNJ9QjX523YZ6dj5nEJqn99fHDSidSWaC0Z9AxO0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792282742; c=relaxed/simple;
	bh=/q4urES+leaR/5KSxxVXi22SEAZsMzGwxX8GZR9d2Hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CUlNjiZAVg3eL1Y0FFr9i1xJ8W0kKtz0Q7vd+7bxAb3Rj8Ok95Q5tPXZQ4LfeB+2CV1/1Cqx2OjED2V+88zxm2Z0pGBJVQR77Pm0VouhKlBgqxA2scj6i/m+gvA1lrG7l09+MmqNYp/0tAIUoF/zqojmFBQWxu1zKX98APyQx5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x3pONo8h; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x3pONo8h"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j6fRm49bVz1XM5kt;
	Sun, 18 Oct 2026 00:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792282737; x=1794874738; bh=/q4urES+leaR/5KSxxVXi22S
	EAZsMzGwxX8GZR9d2Hs=; b=x3pONo8hWb06zclivB97gH9qE+ChM3jp38NWx3Yc
	6Bf8CGEwqpPQtj6X3+SzemL/LAUmJ9zFV16zBRnFwMfq+fz7B3VXxDCMqDQVQ71o
	ac91AGLNfwdXsFwXmcxDLm/av5qvtUvVLjpetllopQFpt1LJKhmbH2kO2J/+gt+T
	QfajYnKupX/LYOxTBEQHGyr8wcjIBGBf2YLU672jQmWnALIBskE7a7vgd1b8gX+j
	GqoSYka/4KRFYZ2dfF+QeJQf2ouIYoO1FahMGFye512zGrC2AmpaR4oGV6VXcMsn
	y4u5rdkhiDALkx/MS7eERTTB0ykTr+Xzz+I+vrga6T3r/Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vHd6oArFpOyr; Sun, 18 Oct 2026 00:18:57 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j6fRj0vHHz1XM4Tl;
	Sun, 18 Oct 2026 00:18:56 +0000 (UTC)
Message-ID: <1c8eea0a-0bac-494c-8596-355be50bac8b@acm.org>
Date: Sat, 17 Oct 2026 17:18:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/54] scsi: fnic: Enable lock context analysis
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <e8ac2000b7ed23cec78f5be360a21d741f50a73e.1790360262.git.bvanassche@acm.org>
 <20261016023120.GA2863622@ax162>
 <9c375265-e198-42e1-97f5-fdfb08563d41@acm.org>
 <20261017235838.GA413570@ax162>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261017235838.GA413570@ax162>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 4:58 PM, Nathan Chancellor wrote:
> I can reproduce it with clang @ 1ae71725e3edb2bb5c5bed7f2cff9d2f22e10636
> so it doesn't seem like something specific to LLVM 23. Is it
> configuration related?

CONFIG_NVME_FC was missing from my kernel config. I will send a patch.

Thanks,

Bart.


