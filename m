Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BFE38DC7;
	Tue, 15 Oct 2024 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729016042; cv=none; b=U1Od4EFSr/asps5V7GjnrslCg7gNZz0t5mzq+Z8GvnnRDXlG82GLjfhi8ZeAS8tzl4xNHMQrHs7nmsS6f//ljUUnaK2Hhq7RKOeUwsDaPjlKPCFvcX0bIDdkmU2kdKiCWt79o7Sw8EwKzypNgZ9jH0Hw79yGe7KDo5FEseXiuN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729016042; c=relaxed/simple;
	bh=NuuSKPyw9BOEDfj88ei99Ubn1R/nnJqQiQ4AL9f4wRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=umM9+wV/HuV7mpolmzaMXfP1AvI1aUpth17IXTcu/NLNl2HBDVnTNZazMBTMe6Yrce+JuXO8vaSiYndq3vtXbqBJh3tiTFCtMt8XXg6cy5CcqtWU7GHRjh49ic3fhx1+wAOMDngFgWwHihCCdcGhFZ3fwc+KCgcU3CiVwrgM5xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NoASghbF; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NoASghbF"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XSj0L3jKxzlgMVp;
	Tue, 15 Oct 2024 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729016029; x=1731608030; bh=NuuSKPyw9BOEDfj88ei99Ubn
	1R/nnJqQiQ4AL9f4wRw=; b=NoASghbFw2VKynVxJX0Zxgj/s+/KGLI0dD1ZtLgy
	55Ivb4KvfZdGRlIQ7WLyw1J87onlb8IgJx7rnaHQmQ/bT6nEdqKmTzP63rq92IJv
	YyZk1OSCUx2uPlfAyLZnCCw+RNH2+dCbF5+q+mDvGk5G6/c5mcnm9Pach8ehGHbf
	ElfA0ABvfh0LGccz6GHEsz7qg/S95njPd8iptolNbBxXHumozS51haj9ooS04Nfj
	RIBaGcy9LuHSSy/1KruFhh4yl677iWhKh8d2JilyWdVxw1k8/hdDtKzFSB8eK/xV
	Cx45NWkw0mqYH8TAK8ZSM48EezVci+NRAJ7tdt85O/GN2Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id w9apkZmV1nWc; Tue, 15 Oct 2024 18:13:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XSj094FPpzlgMW5;
	Tue, 15 Oct 2024 18:13:45 +0000 (UTC)
Message-ID: <420692d5-d968-4e47-9eaf-14d574b62593@acm.org>
Date: Tue, 15 Oct 2024 11:13:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: ufs: core: reflect function execution result
 in return
To: SEO HOYOUNG <hy50.seo@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
 kwangwon.min@samsung.com, kwmad.kim@samsung.com, sh425.lee@samsung.com,
 quic_nguyenb@quicinc.com, cpgs@samsung.com, h10.kim@samsung.com,
 grant.jung@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <cover.1728544727.git.hy50.seo@samsung.com>
 <CGME20241010074231epcas2p2d15a81d68b68d757039a56e8dd9cca3c@epcas2p2.samsung.com>
 <300052382d9d03bf087d71201bd159805b8fd041.1728544727.git.hy50.seo@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <300052382d9d03bf087d71201bd159805b8fd041.1728544727.git.hy50.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 12:52 AM, SEO HOYOUNG wrote:
> If an error is returned in the power mode function, it is returned and
> modified to cause failure in the UFS linkup.
> If it is an asymmetric connected lane, the UFS init can fail because it is
> an incorrect situation.

Why is this an incorrect situation? If ufshcd_get_max_pwr_mode() fails,
won't communication succeed with a lower power mode than maximum power?

Thanks,

Bart.
