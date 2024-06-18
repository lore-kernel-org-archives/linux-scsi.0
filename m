Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EBD1CD26
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 16:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718727478; cv=none; b=ejAiIgsP/0jT/TU3ouDfzfwuOKFY87oGRRLeZcI8UZ3yOYkUwz0XKjZ/lRA/Afz7MjKXpIXbjwdNPgIY93ZwFRzPvozSUZSEMIgL/QiFqePjftwY+9lNBg9PM1u1K90nuyBXP/cx5H7+bzfIIW782sbxAZnOpm8uUxhbX8nO6vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718727478; c=relaxed/simple;
	bh=9tz8j9kA6mRMMz+DQOshDHL5XXlz+Sp9ftSRadd43io=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gU4tnHDfWm2alWYiiTcYiPYGR4HgdE4acoo7aiPzEfDWGtqE37RPQcx96fSVHL/9x7bqgrbeeEjhejdkA7I1qPL97rJxx4rciQ+yAf+Kuciadi+L1Af7NS1xcsj1GDGMrm9G9Bxr/sIP1j2liXCNSRdrA8iPMS1agHgsZIVKd0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IFX+S0J7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IFX+S0J7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W3X3S4Fncz6Cnk9F;
	Tue, 18 Jun 2024 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718727472; x=1721319473; bh=IOaXE61jUehz54M8QziAWsOH
	J54KCSl1pOrp8ZPUijg=; b=IFX+S0J74dorhjSkxsJiWeWvq3fvbqcW70roV1Vg
	tGr9aaTh8tx4aJHlgflQ4+BAj5QxwnnCBiUlpf0JiQJGlQfDrjV35jz26z13KrGk
	wav8cwZVFKXRD7yJ2X/byOQ6gptwlp4o3Nl9OdO1ZezxU3aZjHJPYMpv0iErUeel
	LbFV5BaFaqF6cuYjuJbguPsJMoMAb8y2n2OHIbgR2PHe9tq9GK4yJYsdBNBCiqQR
	F+69eSLGahElpQZpIKLTCkRumHTlO//2ufRugDeVzNBsF8fN077VdAQTJ70ZtWpH
	fG4L5cg9Cgs9ISKwxaMzY4D28tlIUpsbJoO32HXhNCsdAA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yD7ZMTRF-Us9; Tue, 18 Jun 2024 16:17:52 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W3X3K2s7Wz6Cnk8y;
	Tue, 18 Jun 2024 16:17:49 +0000 (UTC)
Message-ID: <a1126ebd-4bad-4f51-ac80-64cec10546df@acm.org>
Date: Tue, 18 Jun 2024 09:17:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] scsi: ufs: Make .get_hba_mac() optional
To: daejun7.park@samsung.com, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Minwoo Im <minwoo.im@samsung.com>, Peter Wang <peter.wang@mediatek.com>,
 ChanWoo Lee <cw9316.lee@samsung.com>, Yang Li <yang.lee@linux.alibaba.com>,
 Po-Wen Kao <powen.kao@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>, Bean Huo <beanhuo@micron.com>
References: <20240617210844.337476-5-bvanassche@acm.org>
 <20240617210844.337476-1-bvanassche@acm.org>
 <CGME20240617210952epcas2p33dbf2b725c4061894f7453671b4298bb@epcms2p7>
 <252651381.21718675102994.JavaMail.epsvc@epcpadp3>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <252651381.21718675102994.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/17/24 6:28 PM, Daejun Park wrote:
>> @@ -146,10 +145,13 @@ int ufshcd_mcq_decide_queue_depth(struct ufs_hba=
 *hba)
>> {
>>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int mac =3D -EOPNOTSUPP;
> This initialization can be removed.

I will remove the initialization.

Thanks,

Bart.
