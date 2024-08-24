Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32E5AD5B
	for <linux-scsi@vger.kernel.org>; Sat, 24 Aug 2024 02:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724467740; cv=none; b=dQsTEhkSBqcEkpb2ieDkdseo+Eju38DXZeoeUtKz94KJSGDM9H5hANXVvPuy9iHR8FHmQEkLAL8UWA4W511aezAefLs54K9H6rKmObzHpBJe+9OQRSbbMSn5YETDO3fYo/e4MGV9hlHLsOmu9Kom9/c0EIzyrp7LsBLdxVet1Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724467740; c=relaxed/simple;
	bh=OqhlSOxTWbvDrmgo/e2KIcsuH1lIbMJGvdh+F9GdbIg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NXCtDKPx472xe06TPsXYR+0YPmkxco3sWcu5HhYHRFTla46gMj2Z0++ZaQYlTDtEH+MD5/Qwd1XFjG8OjJ7qkVfjIJzoj6dEJ5hihWbnI0IEPbLjihAKbKYIbPDMKzCna3Wd6WpXOyhtRqCfZi8FTQVocB0oVcB0E+8hrCGWd4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qhF4Avzo; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qhF4Avzo"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WrLx60MlzzlgVnf;
	Sat, 24 Aug 2024 02:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724467734; x=1727059735; bh=OqhlSOxTWbvDrmgo/e2KIcsu
	H1lIbMJGvdh+F9GdbIg=; b=qhF4Avzo3U3zYo2HGhBrsZx9uXs2FPfNv6OefOPR
	Cumg96gangAOBdwqbHPLQ9Rfv5Ee322cgpBJliLa0j92aTg54lSlAqipWAcFu+EU
	rZsClIJNlq43DAXMizHedNSINLebzw9yAA9cEo6a+uRtZNN04IkRdx9lE6IC6dH0
	8Kbx5kyPfndi8y67Q8Tbxgo5uCq7vryZkGXpz6FnMMMFyLFl2SOUNplM/DNuJH00
	6BM+58DIPX47YSRfJBb0n18PydOMuIY8iJruO1EUpe3sQnXesxoXJe6VxbyFHg5t
	tP24uUpOu26MFIu7wGgDVUfNDgfJsHr/t3Dck/y+FNEckQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hozhmgqbk0_k; Sat, 24 Aug 2024 02:48:54 +0000 (UTC)
Received: from [172.20.20.20] (unknown [98.51.1.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WrLwz4JTZzlgVnF;
	Sat, 24 Aug 2024 02:48:51 +0000 (UTC)
Message-ID: <861b64b8-d0cc-42b3-bf57-375f84f4fe85@acm.org>
Date: Fri, 23 Aug 2024 19:48:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
 <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
 <20240823145817.e24ka7mmbkn5purd@thinkpad>
 <c5699d57-cd51-4bff-95f4-372a00b2a3dd@acm.org>
 <20240823164822.fdkfswpyhlwnfgfl@thinkpad>
 <4b7d6a81-a0ac-4f1e-9744-6fc1ed4c6c43@acm.org>
 <20240824022929.sxnh7sjl2tb6pmbm@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240824022929.sxnh7sjl2tb6pmbm@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 7:29 PM, Manivannan Sadhasivam wrote:
> What if other vendors start adding the workaround in the core driver citing GKI
> requirement (provided it also removes some code as you justified)? Will it be
> acceptable? NO.

It's not up to you to define new rules for upstream kernel development.
Anyone is allowed to publish patches that rework kernel code, whether
or not the purpose of such a patch is to work around a SoC bug.

Additionally, it has already happened that one of your colleagues
submitted a workaround for a SoC bug to the UFS core driver.
 From the description of commit 0f52fcb99ea2 ("scsi: ufs: Try to save
power mode change and UIC cmd completion timeout"): "This is to deal
with the scenario in which completion has been raised but the one
waiting for the completion cannot be awaken in time due to kernel
scheduling problem." That description makes zero sense to me. My
conclusion from commit 0f52fcb99ea2 is that it is a workaround for a
bug in a UFS host controller, namely that a particular UFS host
controller not always generates a UIC completion interrupt when it
should.

Bart.

