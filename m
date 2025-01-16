Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E285A22BAA6;
	Thu, 16 Jan 2025 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737039551; cv=none; b=Dwc9aE0QmceOvG+bDlHDRa7cFnrG8ph72VTMLriIdcLAG44GGFsv3Z9CVI7N0vnECYykiriSSBmo4TsAITvraGFmuZpM2/O84ndaXygw+U9rLjp6oRa1N0fImbMEmvayZw3IJ9YiW99gTHkWAIkodgPOlql/fQaH3/vh43hMZ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737039551; c=relaxed/simple;
	bh=i+V3Z2NUJCMCx/znFI/oGZZdryeyksmDefW2R52fwB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BAwNdYv3SS6DxSL/0rG+hS36itAYe9pgvL8eLnsj4BQx5LBvFPgx6PnLClNkCQY1UGqvHul5AhkLIgFmiSxRz/QMYLBtTuchqBEYGLfA+9XT5kFgT2swOlXegbJTBseDvJc8gKfsIWlpWynEA8JJiAsf+kgs4B2+vDFWd0ZaII4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=px9Yhk9t; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="px9Yhk9t"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YYmGd25f3z6CmQyT;
	Thu, 16 Jan 2025 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1737039536; x=1739631537; bh=j12opHSIEh0oDBccvVD9ZvPw
	ZPzo7OXtIm4cM0e9PzM=; b=px9Yhk9tf32prO7dpZ2IqqOyuGPIQjcd1E9mOfwL
	55X+JuldZ8UjUQVt+CSTkAEYMLYiv2e7Ybmq7WUpKjkQN/maUDMt3axMIztICjMM
	zisopiavgL35quyhvjAjNRoMm9PUA39SpwitzJZOJ25mMvQndfvtSdD96trgV90/
	jU0SXSkkciZ8tLWN6W0+14AW6X98B6V7Y4VqwmjFgbDpK8YAj6zQYvK9T1Radw4k
	yQcMG0v4TTWcjCQ9ftPUyvvEAv0nnsdNzoymYeWpf5IUdrbuGnPOQjx1oipSk9oY
	y59k0HWOuh0+ZYf0U2vSOtJUaKLt6IDNvimGJNDnfXWgHA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xygppzRZorP3; Thu, 16 Jan 2025 14:58:56 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YYmGJ2qHmz6Cnk9G;
	Thu, 16 Jan 2025 14:58:47 +0000 (UTC)
Message-ID: <0509c5a9-47ec-4a0f-8251-f1be62e8ca1e@acm.org>
Date: Thu, 16 Jan 2025 06:58:46 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
To: =?UTF-8?B?RG9vSHl1biBId2FuZyjtmanrkZDtmIQvRGV2aWNlIFMvVyBTb2x1dGlvbiBM?=
 =?UTF-8?B?YWIuKE1YKS/sgrzshLHsoITsnpAp?= <dh0421.hwang@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
 sh8267.baek@samsung.com, wkon.kim@samsung.com
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
 <20250115022344.3967-1-dh0421.hwang@samsung.com>
 <44520a93-a52e-4f88-8ca5-5f0fb38df607@acm.org>
 <351601db67ba$b67a54d0$236efe70$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <351601db67ba$b67a54d0$236efe70$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/15/25 6:02 PM, DooHyun Hwang(=ED=99=A9=EB=91=90=ED=98=84/Device S/W =
Solution Lab.(MX)/=EC=82=BC=EC=84=B1=EC=A0=84=EC=9E=90)=20
wrote:
> I want to keep sending NOP_OUT commands repeatedly to get a response
> from the UFS device, as per the existing method. To accommodate this me=
thod,
> I propose increasing the total timeout duration by increasing the singl=
e timeout
> value(defined by NOP_OUT_TIMEOUT) from 50ms to 100ms rather than
> increasing the timeout value(defined by NOP_OUT_TIMEOUT) from 50ms to 1=
000ms
> or increasing the retry count value(defined by NOP_OUT_RETRIES).
>=20
> This is time measurement log confirmed on a real device with NOP_OUT_TI=
MEOUT is 100ms
>=20
> 1. normal operation
> [    2.010156] [6:  kworker/u18:0:   76] ufshcd-qcom 1d84000.ufshc: [TE=
ST] ufshcd_verify_dev_init: takes 1271 us, retries =3D 1 * 100ms.
>=20
> 2. issued log : exceeds 500ms
> [    2.524525] [6:  kworker/u17:2:  141] ufshcd-qcom 1d84000.ufshc: [TE=
ST] ufshcd_verify_dev_init: takes 533000 us, retries =3D 6 * 100ms.
>=20
> And a certain UFS vendor has confirmed that the response to NOP_OUT com=
mand
> can be delayed by up to 540ms in certain circumstances on a specific mo=
del.

Thank you for having provided all this additional information. Because
of the above clarification, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
