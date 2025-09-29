Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3974CA52;
	Mon, 29 Sep 2025 16:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759164564; cv=none; b=TS3AG0+bH8XqWsxQ9nUVMwQbvMjN4NC4E6YllV+OlTI9kpFXElUBqbkylQqQws03PxTUx/qwf2IbR5tEd1TXDIbtiq0WoYk/ryo7s8/sdpKLZ9VxXLYztyudW5w47uThj+NO3Av/vPefYG6TUwc/5rf8ohGhmqaTzvqz+wm2VSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759164564; c=relaxed/simple;
	bh=ZSP3mNB2sB5cl8qcTm29vCIdXpjTj/WEWNMSp+mRwSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T0NiSRGVTK1372cGsvlSAQ+BTzg/9IBgcFQ9NehCelRKrsHRL6nJwWGN4bOpHIM60keTJggd/wHQkS2lDu1eHoul8bIzC+8Bg0+gl3PkwukN/Fe9AS+7cDkIzG9JWXuVxtThvShAU2lqyfZkQuurTtjlwOa+uh3Aoqm0c+j/9Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KyQM7ztF; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KyQM7ztF"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cb6bj6GwKzlgqTr;
	Mon, 29 Sep 2025 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759164559; x=1761756560; bh=rEY7nmFk8IR9pKktb6E6mW/0
	RF8PFkg5eHS4Lhk1X8o=; b=KyQM7ztFI28KSg4iqb+7WEKVeQvXI60ByDVoPMkw
	UTlr0MG/jCgLVROfwXF+JuTGQkTCZ70vDgqTWLeATptOSQDXUWgEi+RzXRU9BsXr
	WnwHe/T2y6dNGtCONqom8LEWkClM8HEbsN27Gh+v9LXsOvD+2GDlURvUvETtSoIG
	RJzWMHulxNH26dwdRqqbVy53519kKa5Rx03Cu09t1VqC5rME/OH0kWVcPfvuNzA/
	LS3jHJfNPI+Sz5RjFsRY6wlh29sizGq3hW03uWxAD6UA7ZgBYXuGklIwUv853UBK
	Hckz286kj3MyO9M1WnekoJ2r/m8kn30ZjXN5SDlkXmaS0A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d_3rveOCYAYB; Mon, 29 Sep 2025 16:49:19 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cb6bW1WNxzlgqV7;
	Mon, 29 Sep 2025 16:49:10 +0000 (UTC)
Message-ID: <9b60d18d-d590-4fc1-8aff-e8a0fcebd79b@acm.org>
Date: Mon, 29 Sep 2025 09:49:09 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: ufs: core: Introduce quirk to check UTP error
To: HOYOUNG SEO <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
 h10.kim@samsung.com
References: <CGME20250929105936epcas2p1308a10b1ab51c5b543ea246bc3165fe4@epcas2p1.samsung.com>
 <20250929105801.428105-1-hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250929105801.428105-1-hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/25 3:58 AM, HOYOUNG SEO wrote:
> +	/*
> +	 * This quirk indicated that report the error when UTP error occurs.
> +	 * Enable this quirk will the error handler allows the ufs to be reocvery.
> +	 */
> +	UFSHCD_QUIRK_UTP_ERROR				= 1 << 26,

Quirks should only be introduced for behavior that differs between host
controllers. I don't see why the behavior introduced by this patch
should only be enabled for some UFS host controllers and not for all UFS
host controllers. Please remove "UFSHCD_QUIRK_UTP_ERROR" from this patch
such that UTP errors trigger UFS error handling for all UFS host
controllers.

Thanks,

Bart.
