Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14BC18C08
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2024 19:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720812768; cv=none; b=k170VIpsbIG0vFi5FxNp6DU0y/PWQfU/RtFJITkdH/BRBGNbE9ah3J9E2Rua1OA4i06z/IMJYNLwXcRkgWEjFKoHaD2659o7E8MZxp2ckh7MO7ypcikysuGLNqpu1OV5dgK5Maf3lBMmWfgQDxf11oBJC0vZ5DNDHNr6Dg5Os6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720812768; c=relaxed/simple;
	bh=LO1e5wPPVJkpLZsVpgn+QglDPnkvY2ZH6VpRbKG0aSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OO6Sj2PHGh7OVTDJelLFDuUFZTmq4FY88h2uqaLxAakoEorUJVt4P4t6ijjCiiKDV7rC0x4LL4FWEjG+GO/X0FXmKDnMInawqFTRHkOGKiXRc1cfwovbD7Y1r/wyeeCBWeBubgJBzrroD5byI2W8emAEkzwQwn1i9G3mp2M7UFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0V4r5uZG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0V4r5uZG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WLMFB2K5Pz6CmQvG;
	Fri, 12 Jul 2024 19:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720812764; x=1723404765; bh=jnJmh3O1wPApLNqXRFzJKFvJ
	UtvK5fpgAM+N+38vf2g=; b=0V4r5uZGoLvKengV+2CruTpLKbpo9rTsbeUu4HgR
	qNEEak1h2CGMrR+x1N0c1ZUEvehkkSOw6M6ICnH4yLRGa1LIe977fCYk43LPSV8J
	IgiaDvRifQ+90OuP0A23qMkJmaPngSf4uEdTI0Yj6LzQDo2DGEob9uZoU+wc8Xlj
	4zhGdzCsHoqLIwL/cX8SRbQS9oljbzFpgVv6Dv7914g4/cz0uluctiNYyA9P2W3w
	77iU14ceFQcZaLMDCrjvFwWGhkG5+KAdRS/gAzs2YRPHQHMCXYIydUDraByVRyRB
	7kimoN6SfS0BlIYWJaT/cb18Divdh16fd5lOLNxnk/9ukQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u5HCurNVdrX9; Fri, 12 Jul 2024 19:32:44 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WLMF73Yv1z6CmR09;
	Fri, 12 Jul 2024 19:32:43 +0000 (UTC)
Message-ID: <d1b72809-f72a-4513-a7e7-750a9647c953@acm.org>
Date: Fri, 12 Jul 2024 12:32:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] scsi: ufs: core: Check LSDBS cap when !mcq
To: k831.kim@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "Ed.Tsai@mediatek.com" <Ed.Tsai@mediatek.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <CGME20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
 <20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 4:25 PM, Kyoungrul Kim wrote:
> if the user sets use_mcq_mode to 0, the host will try to activate the
> lsdb mode unconditionally even when the lsdbs of device hci cap is 1. so
> it makes timeout cmds and fail to device probing.
> 
> To prevent that problem. check the lsdbs cap when mcq is not supported
> case.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
