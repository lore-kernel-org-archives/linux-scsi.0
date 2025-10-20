Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D94281531;
	Mon, 20 Oct 2025 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976089; cv=none; b=qhMGvLEvSKNGUftfy7Q3gdcXC82pVbK47QpLLBOaHG/nzLBwlakZpQ96wKOMoR7DZB4EY0qUydbRt1nt1QvYdYTCZ7aLoKrGbilFuIsV6dtEilVgIJKfx7ZPWNM9QLRExYvWfFL5KrzHUpiboOhZ1zlKwqOu/CzY4qGX4P6LumM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976089; c=relaxed/simple;
	bh=8uW8TyZNB1QKAet4lyUQxOj5jxP90ZWaskUmPdpaLhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rmfY5R5vj1FebzQ8VInbeFDts7/rpKBTuU6JQVLl/c7NtF9Pyc+qRFStvGLV0xrDXGootggts5/x8Puo3TqgHDof1YGQKjobxgWgYCTn80pfHZuE4vZe85lQWFbfD8S6WsdsLACDmUVLHtm6r6yjjvgQQNE7fjRd5NRAuuxgSps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XjCctqcV; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XjCctqcV"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cr0Xk4s79zlmm7h;
	Mon, 20 Oct 2025 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760976085; x=1763568086; bh=8uW8TyZNB1QKAet4lyUQxOj5
	jxP90ZWaskUmPdpaLhU=; b=XjCctqcV7EzMLw1uLHXHHPlCQ7dG2V/GajH6YC+E
	6xI1Q8rJxEYws4ArM/3dYAVyAiBvsSQC+g6WQFnv++A7X+pjfaD2vhutdVqupSqo
	fyFLy7PxIVNKxRkKEE1EoC82ATtd7a6acK9ZpzU0vE9kYrDx/p+/jFTBfzuKiUJx
	SNvB6fLE9H16JXn0Jfy/T74LdoKaU+T1HYH0ixDGAL0/Kbe7C/L2dc5v3+rgousU
	2Z3HX6JLMKd2Z7+u7Kp0rjy6Y8mBWIcKRLGb4ZLEN9Hdubk2yxkdNejfvrFR2+gT
	1Dm7N8ObrJFZRsM1ZwfBpvpHTAe3+mSYNEiN5iI3TwTv5w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dCUdWXd6rDGI; Mon, 20 Oct 2025 16:01:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cr0Xd30V8zlmm7x;
	Mon, 20 Oct 2025 16:01:20 +0000 (UTC)
Message-ID: <ad1498a6-3faf-4ac2-8c47-f1f3fa464f7d@acm.org>
Date: Mon, 20 Oct 2025 09:01:19 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ufs: core: Initialize a value of an attribute at
 ufshcd_dme_get_attr()
To: Wonkon Kim <wkon.kim@samsung.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20251020061545epcas1p2c494b8e57d424f1b2dfdcc9eef6e669e@epcas1p2.samsung.com>
 <20251020061539.28661-1-wkon.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251020061539.28661-1-wkon.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/19/25 11:15 PM, Wonkon Kim wrote:
> It needs to initialize a value of an attribute at ufshcd_dme_get_attr().

For both patches:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

