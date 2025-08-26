Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDFB1C3314;
	Tue, 26 Aug 2025 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215928; cv=none; b=P6SlXvw3Yp4yzjkYHN/PC6CPjHpDM59mm1mQqcNlIicfifHMRpe/p9fKTXOqFlgyy0KtV77cUkqLRZUMLi8i0El7njvVRJkkATPr4/Rb9e7ddKwmPKKy4kTXdbgS3DTVS+qZkuGlI6APnsIb81I7fM8AT7s/aIsLkjE9i88t2OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215928; c=relaxed/simple;
	bh=ujLpd+pLkmK69KjW1Z9e5OVycYRAIFGQcUpYZa/du6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pr49BOBUQDzaKRwQR2u3WGab4XkCV8FLFhLnX4M7QOClEeoD6LK2zEPMN4G0tN1z+2495xcgZzLsOe5wPj2p5RtspWdoIcdyL9EWGGtOCBtG+zMwgHbLJLB3Y/ecjDay2IBZN17Ehi+qmlPfeg1rKnv+cEhp+7kH+ulO6jBL0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S7aRCycT; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S7aRCycT"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cB8790nNlzm174K;
	Tue, 26 Aug 2025 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756215923; x=1758807924; bh=5MKSiEzjkldvDf+0Dulez47A
	pFhe7CYYC5lZzFYHk+c=; b=S7aRCycTq2cqHYoHO5anNLu0O/qBoyoV3tJPQF5F
	XN3b8+hAw4/RKQVLV/BJbA57/24LmiUavd6BVbMSP+g+ObT7THGIV9sHTkhKrJdd
	2tEX6f9FnG2uW7fTOSM79lefOR25+9EQVuoxF1Kp6LGaASnFaTolSTY6v+s3eB83
	H9lTbnvOCD83IaBulZNtQwtJIuJ7k0Q710oidvWSYhYFZbeqeq4IcG8HzNSOppcB
	fb0K0Yw75hNfTScwosjVzBk2Oy+GQqXzqqnaXHKZpTt8LhDgAm1yZnrvRM0sb7dt
	dJJEnWco+QcGYZfw2TtKteSdL9kS/djrGH5A9WQ4WKX1hA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GrdjopkJutjx; Tue, 26 Aug 2025 13:45:23 +0000 (UTC)
Received: from [172.20.6.188] (unknown [208.98.210.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cB8703kWZzm174W;
	Tue, 26 Aug 2025 13:45:15 +0000 (UTC)
Message-ID: <c0510108-30ed-4301-ad2f-00bcbba7bf1a@acm.org>
Date: Tue, 26 Aug 2025 06:45:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Jason Yan <yanaijie@huawei.com>, Yihang Li <liyihang9@h-partners.com>,
 martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
 <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
 <41077713-8119-4898-8307-731a0d8f346e@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41077713-8119-4898-8307-731a0d8f346e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/26/25 1:47 AM, Jason Yan wrote:
> It seems the official replacement of tasklets is WQ_BH. However there 
> are very few users now. I'm not sure if the stability and performance 
> can meet our requirements.

I'm not aware of any stability issues related to WQ_BH.

The alternative that I proposed should result in better performance and 
lower latency than tasklets and shouldn't have the disadvantages of an
approach based on tasklets.

Bart.
