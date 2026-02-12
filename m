Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B603FEF
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770915954; cv=none; b=o3WB3AdMPg32ty2RZ8w2c9blxNlliY5RPIqQx9zBn8l0xtl8kVZ5mZx/HdYCUMe9ChpEFXTkDYdQB99jWSAaYqv4/nnnER6xFqVspucu2pba6/3Xa6cTFSoA+p4FmpBcwo0eWRStsIJhiFvsBg6JZQgM2ko6TwYJZGnv3ud5xm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770915954; c=relaxed/simple;
	bh=6e6Mhb1NpNhNJR4c5haXkBnXEsPnauIHWIImOup+NSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o++H2wU1Zk+NEQF1c7RX8cwmIbsvkrXiNRO6DUuv0xpBdcNzOl8YUo5icGreBiHVzxCSvJDHL7F+QQnynBt0aKDc6mZm1ts29v8UocUyFAu6FugoINXNN8gxrvx82fJIzKzZHVTB+uz23FB+Dl/5ZFETNFqyppYMlPdrhP9fxkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DYw479AX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DYw479AX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fBhWt3DVhzlh1T7;
	Thu, 12 Feb 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770915943; x=1773507944; bh=sqjVjUJPIx5XRzC8FeSmyEDs
	yRAC5ggcFEonjZ1ktf4=; b=DYw479AXfbYbnTG+ir62RXZ/uc+jyJvg6Rp8VhB+
	GqtVSzxD9iF5sGKRlsvOziCI4ry0X1p+AE8SOk2dU36u1jMQnbdVZAhC/n/gw+Uf
	iXKxdLLnbIjMEcUAROwblC18ihlynmhjMt+vmme+r5E+Qck63JZziKl26vTP+GAi
	HpKgl3WwXDnLHOrp6UfvKlAAz8DNafN7dGLz0B8Vc9mTxi+ipSqI+cgPC+Cjb2PK
	Q+SO460FWNCMpdevCq103ZQU4/oVOyeia02dn/hVpyO/g/YhBxCgyqEJdGbJuYz/
	eR7ueY6FOcO2Q7w5Ll/7OcsezHmhlTIMPxLB8jHfeWmNFg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o14x-WW7aY-c; Thu, 12 Feb 2026 17:05:43 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fBhWl34jYzlh1Vh;
	Thu, 12 Feb 2026 17:05:38 +0000 (UTC)
Message-ID: <3b16945d-a93d-4165-94cd-6f12ab59ab0b@acm.org>
Date: Thu, 12 Feb 2026 09:05:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] scsi: ufs: Fix handling of lrbp->cmd
To: hoyoung seo <hy50.seo@samsung.com>
Cc: Arthur.Simchaev@wdc.com, JBottomley@Parallels.com,
 adrian.hunter@intel.com, athierry@redhat.com, avri.altman@wdc.com,
 beanhuo@micron.com, cpgs@samsung.com, jaegeuk@kernel.org,
 jejb@linux.ibm.com, kwangwon.min@samsung.com, kwmad.kim@samsung.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, santoshsy@gmail.com,
 h10.kim@samsung.com, cmllamas@google.com
References: <CGME20260212105422epcas2p44c875c9f8d57d1b4f6d231b9aef833c9@epcas2p4.samsung.com>
 <000101dc9c0d$f231f360$d695da20$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <000101dc9c0d$f231f360$d695da20$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/26 2:54 AM, hoyoung seo wrote:
> I have to use kernel-6.18, what should I do in this case?

Please continue the conversation in 
https://b.corp.google.com/issues/480758258 instead of using the 
linux-scsi mailing list.

Bart.
