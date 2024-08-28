Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D3518786F
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724854215; cv=none; b=YBzGmFzZciCyeM6DDBpIiG2rfzNcXC2LorHa2fjD0yJugttK3kKja0NbUq9OHSYccirWmFU9EBF8cUuUmPEJM3T8siBOaoLM0E7tjAJFytSGglc/EsDdBS9BavvBmoYTpU4pFqQ9t6abCTCtlPR4KepsIGBJiFEMIdPuOKDdo5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724854215; c=relaxed/simple;
	bh=qTBoEZ4laCJiZjRig3Gj8qGoLfh2aP+qTu9RjgoXn1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGoGN6GBdR/+F4EGphUUO9Rgr6I0U1GYUEWpPDBx6ObdqVtLYKwpwz0G7SftamTaWQ7ysUGuL1lbn04v2SimcCZkoY5dcwA15qYqJExk4wkreax3Kw8fqYNHxKntwagv0KyFd/0d+6WOnbOfflw6Q/BvpHxYSHhL8N54JbQ/6hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=of4j0AgP; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="of4j0AgP"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wv5sK3Tgyz6ClY92;
	Wed, 28 Aug 2024 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724854212; x=1727446213; bh=5c6ksadIdgxd2CVvnEO0hdOm
	6F2H7VE/6BUBd+7Us8I=; b=of4j0AgPLCq/vLUW1moPsb+uNccJSXYXn9C5sU65
	5nkxADnotcjfQ52153s7MaT1dzIsVjHCBTHBFmR4qEplOkssPvZjJEmS/beyJThy
	lIYIcOr4FeVJUVl3iRMFFrKB57uCVcePU9q61lUDeFllAuPD3Jo2LiS9zElKPxPL
	1/SO2An+R94+Tno/VTx9B2FUm7q/dH08/FCcMGU4/nP1yWByionU4kOjrdWa2VWi
	6+Dnu1rKkHbj8KtmzKAP9kXl17Cqe5sja0Eb6mnQQiGVT5ih9kf2aKzRQtolT/BF
	nhbO1OVte4ZRR9q74VG5YgZGZgmF8HejbuE9DKHB7MPhDA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bYE56Z7afyYZ; Wed, 28 Aug 2024 14:10:12 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wv5sH4bQJz6ClY90;
	Wed, 28 Aug 2024 14:10:11 +0000 (UTC)
Message-ID: <62a5b419-930e-4e70-a4bd-affb29c2e95c@acm.org>
Date: Wed, 28 Aug 2024 10:10:10 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
 <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
 <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
 <0476168b16b4ba6a2b52cad23714206c6e386d80.camel@mediatek.com>
 <71de72f4-2cb0-44ea-aac7-0f2a5c8fa492@acm.org>
 <1f0274b239c4a2484a65c28c5678aac4d4040a00.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1f0274b239c4a2484a65c28c5678aac4d4040a00.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/28/24 9:46 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> 1. If only UFS controller core driver should do this,
>     What about registers that are not REG_INTERRUPT_ENABLE?
>     Since ufshcd_writel has been exported, shouldn't the host
>     driver have the authority to control all Host REGs?

It is not because host drivers can change any host controller register
that host drivers should take the freedom to modify all host controller
registers. Modifying host controller registers that are vendor
specific from a host driver seems totally fine to me. I think that
standardized host controller registers should only be modified from the
UFS driver core. Otherwise the UFS core driver cannot be understood nor
verified without deep understanding of all the host drivers.

> 2. Set REG_INTERRUPT_ENABLE only when hibernate exit?
>     If cause the UniPro link to exit, then it should still be correct,
>     just exiting hibernate early?

This approach has two disadvantages:
- It requires that even more state information is tracked in struct
   ufs_hba.
- This approach is probably incompatible with the power management core.
   I think that there is code in the power management core for disabling
   interrupts during suspend and reenabling interrupts during resume.
   Enabling an interrupt that is already enabled is not allowed.

In general, disabling / reenabling interrupts is something that should
be avoided because it is not compatible with multithreading. The reason
why it works in the UFS driver for UIC commands is because these are
serialized.

Thanks,

Bart.
