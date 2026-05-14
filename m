Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C973375D5
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2026 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778775623; cv=none; b=WJXv87A+QmCHCzAEQPMQ5HQrMpaA0rb1AkrRxl6Kh8GFWPK6kjRKY5KUSSUel8tl93WHt1MiHp7ZaiswH+NfZWkCGXnfdr+rxmoOJ2TdGbt/W3Ptmuy+zsuZ1nTGQAYKS189inbi44Fl9RGrts+uJ16jUok5flQoSaEhnOVW/Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778775623; c=relaxed/simple;
	bh=yDNGfqtK2za6RKRqCFOlNNlb8hjQwdUg4Syhq7Dtips=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p0uxTdH7GhODvelUmju7NjLIp4xzEwPom31vbvdxaimRjBOoj7+lGSTupyakhzMO6wp6b06ikZw8gU0ocWkqW1R5fBBXVUzjUd44GLHrKXMUXyIWdjfguuW6l1fd+W/QUS1ZLA2EnK0O/eUieBFZo9LeNldlAEXL2wmtYWfHJyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vFHloJp5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vFHloJp5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gGbCS4qPxzlfddr;
	Thu, 14 May 2026 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778775616; x=1781367617; bh=yDNGfqtK2za6RKRqCFOlNNlb
	8hjQwdUg4Syhq7Dtips=; b=vFHloJp5TqaOiYCV07i/N1l6vtidxs4hIQJPaKFy
	XvBbeaG8XcfeMdslBK6EcoR+3Dj7DVtoJYjuLlv5iVt6g6yUAwjsku4TLkDv1jSY
	iN3IHuK6NY2XPU+IYn0ufZnfVL96uD1pUKtxN4pUumP/c0VAmAJxXbYiBEJZBKSw
	XRqM7V9BOAHaA0nn9BmPt8jraEaDm0/cLBLL4vMf9f7AnRXKfFBd+r4VKb1JgFz8
	/yL6zY+Og3i12NZIN6W2go8wk9hc31ry9glyp2biPSJKFuyGgfsyd+JmdP2Cysuk
	aiK9Q+aziRkYU287hYkC1k9hs5WVCXww/pC830VlRw9RDw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8evFEKxvBj8R; Thu, 14 May 2026 16:20:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gGbCL0Dthzlfvq7;
	Thu, 14 May 2026 16:20:13 +0000 (UTC)
Message-ID: <d7547792-62a7-409f-9906-c5f3854a0866@acm.org>
Date: Thu, 14 May 2026 09:20:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20260402171404.3008494-1-bvanassche@acm.org>
 <20260402171404.3008494-2-bvanassche@acm.org>
 <459ba5ca0f24ce49fd7de7ae6e014588f40e2445.camel@mediatek.com>
 <d81c6987-6f76-4391-a713-96bbde4efc8d@acm.org>
 <23d57dd91882a3014c0d97a7b08b81117ade5b72.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <23d57dd91882a3014c0d97a7b08b81117ade5b72.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/14/26 12:34 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> However, the UFS ISR still cannot acquire
> the spinlock and executes an unknown task that disables IRQs,
> the duration of which is controlled by F2FS.

I see this as an F2FS bug. It is widely known that bi_end_io callbacks
may be called from interrupt context and hence should finish quickly.

Thanks,

Bart.
