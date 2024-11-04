Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9C13D53B
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 17:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730741310; cv=none; b=cVbmn1fVQG/cPDLq2kSFe7Z8I9YouJhVjtgT8IGTngscMwUtevnigQoEeIIFZL0SQHMSEMjEQUhYRd0hmywkt5SfVPKDZ+LwBLx9FM5hKKuSoaeBQwgGKdkcjIWGDj6jxoarWtHDLqpHd6Bv0VPeFSjLkCgbCQS0UDIAiWmn7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730741310; c=relaxed/simple;
	bh=Sxrqr0ewkjW5c5xbIxe3654Z0aFa+sDSgzmLkD2x1KM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eD8tNecyIeP6q3EEEJnfIrsFnNLzajAm58jqf6GiHYg05qI6EJlGFuFR8an4AtAJqz5nOlzYRVMzT+BTAJ0DvSSkndC+BOWFwY75PEDrNIewDL9qByChioR8YHXGKfrSPpMVTgFIZ+Rdq4wZglXCsmiyKecgM1z5B4tI5fEhf/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rrefPn2w; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rrefPn2w"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xhz2h1Sd0zlgMVP;
	Mon,  4 Nov 2024 17:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730741305; x=1733333306; bh=Sxrqr0ewkjW5c5xbIxe3654Z
	0aFa+sDSgzmLkD2x1KM=; b=rrefPn2wNplcUmPWc0VbddG7yNsZyuhUtNKTxON6
	rhJtBi+PBvgqhnZNbdDJ9hc8YLF2q1ccambZqQl/BsDb2DfowUyaUuF37YqNVQDg
	LkWadFv+FdFIGC6T996nskGAyYh9aPrkX3IouzYrABHitrNaGIdHI4fe3niTF7BJ
	xZaTCGwJI9Jv2mm8lV90NAkyxx+UX7Wl8s45jUOZRkHIjEHu2RKBLWftGiEeSYNL
	j59ZrRw0eIhSf/zbFJ21T9ziiTtwwwcXq8ndJdKyn2lpO2WNoW0bxWmvkpU8um6o
	Km4GC0Rrv7UfUvUhmLAjwi65N1og+c0sXLq7doGCaCmkug==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9t1jBWUoP92w; Mon,  4 Nov 2024 17:28:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xhz2c0MsjzlgMVN;
	Mon,  4 Nov 2024 17:28:23 +0000 (UTC)
Message-ID: <cfba8202-6578-4100-8b95-773ad318f325@acm.org>
Date: Mon, 4 Nov 2024 09:28:22 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: Add WB buffer resize support
To: Huan Tang <tanghuan@vivo.com>
Cc: huobean@gmail.com, cang@qti.qualcomm.com, linux-scsi@vger.kernel.org,
 opensource.kernel@vivo.com, richardp@quicinc.com, luhongfei@vivo.com
References: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
 <20241104142716.299-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241104142716.299-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 6:27 AM, Huan Tang wrote:
> I have submitted the v6 patch according to your suggestions.Could you
> please review it again?

The WB buffer resize functionality will be included in the JEDEC UFS 4.1
standard and that standard has not yet been published. Do the JEDEC
rules allow inclusion in the upstream kernel of functionality that has
not yet been published?

Thanks,

Bart.

