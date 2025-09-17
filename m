Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAE421C194
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 21:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758145060; cv=none; b=eg8qlhMZYNUpS8HMm65nw9gdpHISUw+6oYRJXdSB9b2nTCuORpOdHgs3oUD+S3GgG/hM8MKHU5+6p6xaPmoO39fS+mj4kmsaGowDY8He6Ru0OzzyeOm+gFZ2rGdFoYt/g88+y8nBF5lKXVG2g9KHn2JqMqAhAxhAXPSOTFpkBl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758145060; c=relaxed/simple;
	bh=pwCK3is4eRAojZXpwg/mCdyFb3hTrawtwaHzA+t+lcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijThXguROWNJAUf0I2wA3VDBj19KrvfJVI37P+luIzZlklGsz/BU6Z6SfFlgdjANiLbBe+iMOPVkWUUdbWCBA8tj7sir5lPJFafjKHF92CdKSWeCCBvCdv9TsH+9CSPG2kKvAKp2f2zfcOJtaKji9xKQVGVZyrEQc1nAOQRW6Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a80dA28j; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a80dA28j"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cRsYs2w8Czm0yTk;
	Wed, 17 Sep 2025 21:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758145056; x=1760737057; bh=pwCK3is4eRAojZXpwg/mCdyF
	b3hTrawtwaHzA+t+lcI=; b=a80dA28jrtPy0df7jQfgC0gVrPHqbY70axIf5KB9
	n2lQczmc06shd2ObdYIrhY836+T+wZDyhVvkq6/pwE7c2yWyzCDiO9T0QG0CARWi
	gMsg9mgyXHAmENnTceMzjj6BnpifU0khaZIO6Dmj1rWdxZow3/w9jI7D7NrL5wkC
	lIXR7+TOmtmYnKWqBatUV8A59+pNT5a6COGUIjidrPWRjEtZ7dM5+BbYGHqR0Gxh
	fHwmR9IqSk7fVmSKeB6FTorgWOKBQoKe/W2UFiFB0Pr3rtBpcGXvjV2OKEpbZeX5
	0xBXtdq3r9bB/o/ZtHd4yRrP93orx386TliBFm/lTS3r2A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Fca1s7386qzN; Wed, 17 Sep 2025 21:37:36 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cRsYn7058zm0ytj;
	Wed, 17 Sep 2025 21:37:31 +0000 (UTC)
Message-ID: <6e3206c3-e9b4-44de-b5f5-6a6312013f7e@acm.org>
Date: Wed, 17 Sep 2025 14:37:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/29] scsi_debug: Allocate a pseudo SCSI device
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-8-bvanassche@acm.org>
 <75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/17/25 5:09 AM, John Garry wrote:
> On 12/09/2025 19:21, Bart Van Assche wrote:
>> Make sure that the code for allocating a pseudo SCSI device gets=20
>> triggered
>> while running blktests.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>> =C2=A0 drivers/scsi/scsi_debug.c | 14 ++++++++++++++
>> =C2=A0 1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 2a8638937d23..3f7884025d19 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -9197,6 +9197,19 @@ static int sdebug_fail_cmd(struct scsi_cmnd=20
>> *cmnd, int *retval,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> +/*
>=20
> Hi Bart,
>=20
> Could you consider integrating the following patch into this series? I=20
> think maybe some ideas can be applied to the UFS driver. I made this=20
> change on top of your series. My motivation is that I would like to be=20
> able to test reserved commands handling.

Thanks for the patch! I will look into combining this patch with "[PATCH
v4 07/29] scsi_debug: Allocate a pseudo SCSI device" unless if you
request me to keep this patch as a separate patch.

Bart.
