Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCAB14C586;
	Tue,  4 Jun 2024 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717539472; cv=none; b=ct7PPH4jE5bBs1Z3TiWi4saCWt8oI8MU/srn16TZ+e6WN/mUVeOIXGDIlVl2IjhJSrla206QoJMOzJAzc89r3B2I3JCf3695t618IR8y8k3W2i5GT+n3eUTLFGQICm1WJtSnsOfvzI3/5ELGVaw/zD3Y6q4czlnWy+EbfonSvW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717539472; c=relaxed/simple;
	bh=oaIgqISLd761bJIc5dUfKnvFG7TULh78jPDaUi7zHjs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RJYJYtE2p5ii6OiDyD99Hlhr57qp63ktYPnYWSD1R//99tCIQIHwAQOnwMm6dtz9G6u0hDnE2+E37sDprgGDAO9GPhFTLhsU3/i0jh+FSjY4qGvuPel9Q0Je3AISA62FiS8y2alz2rrq/gLNzjY7wthMFPjfHK3Hbqn2CoKMGxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LfvfQRrH; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LfvfQRrH"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vv4jB2HjbzlgMVX;
	Tue,  4 Jun 2024 22:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717539467; x=1720131468; bh=Ob7mbusC7CX1S50UmdOQWRvK
	K03R2ITcdjC2G42Erk8=; b=LfvfQRrHO8Sjem4XEc9d7TC77jHvwN/bCOuUwI5w
	Kd6uSuW6T523kEn+oJ5THUQjd8lnAqrsNyH+R8KFLWeypmNjAPZf8E9hEhYVwyFY
	NZamt+2ygOFiqCPsrAd8hSVJkXovvnMKPGqC9T1S6sqbn4dgZWotq+Rnu0O51gmo
	1b85dJF07olWjX4IWPJMbSRxXHU+PbfM65JnGW7P8rhtXzbpKB9k/0ueV9QwYwyk
	2QhmHTzeVLGKonj21ZIro/6XnX0InKdekNM6hGL4yq6AyuRgxtaFm6KCFO2B+wLU
	XUU9VKuCCwmot6Q1Q7UKd6BG1j4Sx5ykV+Xgyr4QIy2w1w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IexBPLDxR7pc; Tue,  4 Jun 2024 22:17:47 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vv4j64QZ8zlgMVV;
	Tue,  4 Jun 2024 22:17:46 +0000 (UTC)
Message-ID: <6d0e22e7-05af-4f83-8573-bb033c951f72@acm.org>
Date: Tue, 4 Jun 2024 16:17:45 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] ufs: pci: Add support UFSHCI 4.0 MCQ
To: Minwoo Im <minwoo.im@samsung.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
References: <CGME20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3@epcas2p1.samsung.com>
 <20240531212244.1593535-1-minwoo.im@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240531212244.1593535-1-minwoo.im@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/24 15:22, Minwoo Im wrote:
> This patchset introduces add support for MCQ introduced in UFSHCI 4.0.  The
> first patch adds a simple helper to get the address of MCQ queue config
> registers.  The second one enables MCQ feature by adding mandatory vops
> callback functions required at MCQ initialization phase.  The last one is to
> prevent a case where number of MCQ is given 1 since driver allocates poll_queues
> first rather than I/O queues to handle device commands.  Instead of causing
> exception handlers due to no I/O queue, failfast during the initialization time.

For both patches, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
