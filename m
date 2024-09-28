Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8568F2AEEE
	for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2024 23:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727565014; cv=none; b=Sqrck4SCUpVLDDWOjfsLUYwk/h2Rjm6E6K7KYfYfeij+32u8VhcwwQZq9Fg46UuUwSLl5yUremBq9JdLVy462cEnUsf+QNm4dmFBe6lJ+6Q1hpyeL/06PCz8w346TTwac3D6ZdBUjPqWln7RVCfYELUkrRaRXkOJ5jcIwoHIx5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727565014; c=relaxed/simple;
	bh=lDH1I0n6CobWpfHCOFJY2fcgIUKYBf4cQkYlbI9Ns0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jW82XUSb3VNIhu22mCwfmRW+Dv1XRWBFn9emNxCSAypKDFiRViVGeuxB8BW/Ghrj7pYJqNGCgBb2HJRdZkJxXkmZ6bbMQaczGkWuxg9IiUZuG/FopY/GSGWefF9C3FL3FtOL3LUTbFVTCTfPmZykziVqWfM8hnJ13KEOIKC/dA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Mxrxze2Q; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Mxrxze2Q"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XGNMy0Cl5z6ClY9F;
	Sat, 28 Sep 2024 23:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727565004; x=1730157005; bh=DE0gHgchUphEF1siXM+W5he6
	YGmhBRtsJLL0f82jDSs=; b=Mxrxze2QrjO543vv3KnLY15dbwZTBY8S/o54wzR2
	PG+dCWgRRRLR7abkROYDRMX37ssXN4ptymnnog2Krl4AOZDjwayHD7GWJRH8B0OM
	3hF5bjtLwqRlr4pjaj6QJeJZsTEX6KQTw4oooIq3eDCowpIx6Yf+FedeWhFtw0ua
	S0tdhJaUiu/+qvr/a047LilAX0fpTHEQuvoCQ12nQizEXiLn3n12CiGo3kv+XQlF
	/UlU4/o0/egc0HEaVeUdAKvdvM2yUnQrEasSZ89vyzhYiRCsBi7ideQwEsyPnpal
	rNGltOSmhOcTS87UvOwCL8BypbnRcqSX6cSP8knQxxkxrQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tdumEmy3THr9; Sat, 28 Sep 2024 23:10:04 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XGNMv4rDcz6ClY97;
	Sat, 28 Sep 2024 23:10:03 +0000 (UTC)
Message-ID: <c014f499-1a5d-4e3a-adc1-a95a38bbe2de@acm.org>
Date: Sat, 28 Sep 2024 16:10:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
 <20240925095546.19492-3-peter.wang@mediatek.com>
 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
 <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
 <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
 <134227055619610a781d5e46fb14e689f874b7d4.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <134227055619610a781d5e46fb14e689f874b7d4.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/27/24 12:51 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> In this section of the UFSHCI 4.0 specification.
> 4.4.6 (Informative) Processing Abort in MCQ mode: An Implementation
> Example
> There are three case for MCQ abort:
>=20
> 1. When the host controller has already sent out the SQE
>     and the UFS device has already responded with the
>     corresponding response, the CQ Entry will automatically
>     increment by 1. This case is the simplest, the SQE
>     will have a corresponding CQE for the host to cleanup
>     resources.
>=20
> 2. When the host controller has not yet sent out this SQE
>    (SQ is not empty), the software can fill in 'nullify' to
>    notify the host controller that there is no need to send
>    it, and directly fill the corresponding response into the
>    CQ with OCS: ABORTED. This scenario is also straightforward,
>    the UFS device won't be aware, and only the host controller
>    needs to clean up the related resources.
>=20
> 3. When the host controller has already sent out the SQE
>     and is waiting for the response from the UFS device (CQE),
>     the software can initiate cleanup to notify the host
>     controller that there is no need to wait, and directly fill
>     the corresponding response into the CQ with OCS: ABORTED.

Hi Peter,

Thank you for having drawn my attention to the above text. Regarding
the code changes included in your previous email, do you agree that the
completion code must not call scsi_done() if the CQE status is ABORTED
and if the SCSI command has been aborted by the SCSI core since in this
case calling scsi_done() could result in a use-after-free?

Thanks,

Bart.
