Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A40190676;
	Thu,  8 Aug 2024 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723136976; cv=none; b=uQ1IRPvabFE2GLMmSd+XYVQuv3SO6JhDSqCeiUFFMSe3paqRboa7GEfi6853nkvuEyw7XxJWd/+1wl2TjeE2jh6PBSkXIIw+mcyYNnmNdaUrEjoSJoefyswD7gOtptca+6LAwMCCta6wkeAsrheS9/aiRxJlwv9YjmmacfFATTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723136976; c=relaxed/simple;
	bh=KQfhpG899WREQJR6m8agwW7joO2Q+rPgEyHbvEc0IuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o870yINMrjMDzxu2GMmEcl9khnvl/t0qlAMg2TmcRbfk45+aPPdEXloYB8dRK/RrWteHQ8jLRDJQRlBaYihtquGkHgTwvgKlO9N/tUvvgqCu7/w3pYKISAkPGfKpvFMlnu1MUHqDNYSrgYQT6zctz1o7ryqqZq0B8uirZIbKKb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2hIuT0cg; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2hIuT0cg"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WftnV2pPszlgT1M;
	Thu,  8 Aug 2024 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723136972; x=1725728973; bh=Z3KoOaR4ede/YKq3o7eE7rEW
	W1YeFAj84qRfCBa59lI=; b=2hIuT0cgHkP0MASml4BwVtKCDr/yG599L+/ZAH6N
	6NXbR/vns7EsPZ1VQmVZFEdD/TE2cQQmbRVZ0Bvlyyw9l5lZFTGa+14YG8OueTAd
	/rHrVowLnNoqcIADWfdnX+EeWsjFjZuuB0EBu2p4o5Wvp/DmG/hNd+tliimhIqDm
	xgRDSJVc+rSGKaifxduNXhCBdfL+4swEoW5yAJA656BRXc0PIkxxwbho8o3brecF
	gptEJqimKX3+0gprey/4XarFNVct7qn3LSQE079ygGpDBBCqD6gjVOYY559tZ0p0
	InShOHu+M0gq7zApqFuzF0g9zDnLhGLDP1H/FVLSKoDZnw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 72hJX89rSXqg; Thu,  8 Aug 2024 17:09:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WftnR4mzGzlgTGW;
	Thu,  8 Aug 2024 17:09:31 +0000 (UTC)
Message-ID: <0abb75e1-62a8-4630-88dd-db984d31f741@acm.org>
Date: Thu, 8 Aug 2024 10:09:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use
 of_property_count_u32_elems() to get property length
To: "Rob Herring (Arm)" <robh@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240808170704.1438658-1-robh@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240808170704.1438658-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 10:07 AM, Rob Herring (Arm) wrote:
> Replace of_get_property() with the type specific
> of_property_count_u32_elems() to get the property length.
> 
> This is part of a larger effort to remove callers of of_get_property()
> and similar functions. of_get_property() leaks the DT property data
> pointer which is a problem for dynamically allocated nodes which may
> be freed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
