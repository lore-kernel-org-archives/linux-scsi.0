Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707BF1D4166
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 21:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724794777; cv=none; b=aVnEQYTitusxJNNRroS6RxH/IL/3/H0ediG/BqjfVFYJLdAMrap7TEIkqgefDEV7Qj5r9rX7Dd5ZHofYyEjB1anmO8Le8OyKIf1mJDclQEferQ93JVnUsLSA1aP7XOV2DJdJ9ktBdOPosrSvPqcGuUmL5qkeLf/B4lUkPdN60b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724794777; c=relaxed/simple;
	bh=bmzOe1WRjYj3lspIAMFdMsjhsJbELMEwg0F1cqvYl1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cxUIe6Ya0bWiR55Jefsmyb0fMhP/x0FGcn9z3a3T0Rg0bYL5nXIAOxs6LnYjcl6ZAxohDGaG02RY7jyieYcGMT/h7oJ1ZJ7+sX4QKxjv7xzLXCmydmrNuEpNB1TXgXEHtabLfFglt5muT+k7HV1eOXU66Nd+TZsmnBd/JY+u8VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LayR1vX2; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LayR1vX2"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wtgt922ktzlgTWP;
	Tue, 27 Aug 2024 21:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724794765; x=1727386766; bh=X1dolJ02dpmNm0j3hPUsbC7Y
	h72Sh94nJgrrQYD9fhE=; b=LayR1vX2P2zKpCP/wZpelm1iAKMtJu2FNEKPCg0g
	Hmaqq3+aKTPnkdKkV5Ee6hL/2oxM7YiWOcFsNtvRC2M8Y8gqdDIt6ZC/TwAY5wae
	+/McQKE198fW7K/yFeP3Ig9f42mb6P90vmQzcBlMNE09XN/zjK4GR2CDoM2vbYnc
	Ue7pRVJMlB6TsgVu4U2vQu0CF/4/ILcQ9g8AGP5l6vrHKgIod1sN8R+yMyUlV21J
	EvwTiabPTFXaLGJ/+m2B8cUSNlP+T6m0l9aius2pJeJevvwh+vZLzK/+gmMj/niq
	B+piFm1fsrNncgf+7HLZWKzYn0TSNApIOM56bcnPu28lpw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3c_mAlQ4HXoD; Tue, 27 Aug 2024 21:39:25 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wtgt16rt9zlgTWM;
	Tue, 27 Aug 2024 21:39:21 +0000 (UTC)
Message-ID: <8bc11826-0c0e-4137-a5e2-da2f6b7dcace@acm.org>
Date: Tue, 27 Aug 2024 17:39:19 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <1bc51b34-0d2f-59ec-f025-bcc68da74718@quicinc.com>
 <e974b034-62e8-4795-aa78-ee142fd14441@acm.org>
 <3a982573-3e0d-a644-e429-6b6aee829af8@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <3a982573-3e0d-a644-e429-6b6aee829af8@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/27/24 5:17 PM, Bao D. Nguyen wrote:
> On 8/23/2024 1:25 PM, Bart Van Assche wrote:
>> -=C2=A0=C2=A0=C2=A0 if (completion)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 init_completion(&uic_cmd->=
done);
>> +=C2=A0=C2=A0=C2=A0 init_completion(&uic_cmd->done);
>=20
> This change may not work, Bart.

Why not? It is allowed to call init_completion() multiple times before
wait_for_completion() is called. It is even allowed to call=20
init_completion() without ever calling wait_for_completion(). All=20
init_completion() does is to perform a few assignments:

static inline void init_completion(struct completion *x)
{
	x->done =3D 0;
	init_swait_queue_head(&x->wait);
}

It is not allowed to call init_completion() concurrently with
wait_for_completion() because that would trigger a race condition. But
I don't think that my patch introduces such a race.

Thanks,

Bart.
