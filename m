Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C058C1C1AD7;
	Thu, 12 Sep 2024 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726175523; cv=none; b=qhOI6LYF9k5s5cCRDrsODPyLrbCOCUFlNae3nPfh2FfLhiZK+5bwP3dYEGJq/OgOBLPkLJZUrpQ6ML/xlivGEq7/aRgidSrTRieJwDG3iu4bYRduS1l2Ojk4N4csF2wbuygHgvFeuG8MLOUaiW0cws9rNEBc7AVRYqgwEAD2kMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726175523; c=relaxed/simple;
	bh=C6CkW2oCJhZUpWHZhRaLMofmbBfUu+5eB8hqNusT0CI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jv6g0tB6oIhc3wcbXxngxhsOeXQ/OSr4waTQRZeamS+8NLfhKbvpH369n2aoAJV8Th12G1VEG0hKnO3Eb6XHxJGqdcbj8fhLu029j8rpj2NBl8pPW0o/UO//zIv0Db++C6ZPPwvotNy6vf6FusMKoCbrw0Ef2fjpbkQifopSSus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mK4oX0p/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mK4oX0p/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X4VW51T8rzlgMVW;
	Thu, 12 Sep 2024 21:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726175512; x=1728767513; bh=GTOsC91kloUZyZyFxUUv7fuF
	od8x7DnECYaKtYuXhk4=; b=mK4oX0p/RdYS+DRyXfiZRpOOVJ8VS36r+DKp7W1M
	XtFqAJI3VyDmjjHh/byUaYVhYwbr/0ezHMfUR/2dcQvAELxfn9BcCiqn+kzzNFoP
	vozQiXvNDc7Iko+5E0ADHXdfzX1uK3Sh1H9RUIjycUOK3zWzv8lP+TbkkjAqWPUo
	lYCd3yDGzsBFRQdduh1G+8usahdfxW5pDAOnevPTiEVDidTUCPLygtU7wacSL+ut
	B7Du1Nqy2HnKLGAyVfZqwmFEkp72S/iqjadOjCeRx+1spzoXP+jj6CCXaHlXjMi6
	v8M+AuuxfDh5p5RtABx/4LfqH3wZ/LtOAk1vSCP7K++/IA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iOblTJxy53mX; Thu, 12 Sep 2024 21:11:52 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X4VVq6LBTzlgMVN;
	Thu, 12 Sep 2024 21:11:47 +0000 (UTC)
Message-ID: <cad4804b-2102-4c95-9387-a63ff847cf21@acm.org>
Date: Thu, 12 Sep 2024 14:11:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] ufs: core: requeue aborted request
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240911095622.19225-1-peter.wang@mediatek.com>
 <20240911095622.19225-3-peter.wang@mediatek.com>
 <55d2cca5-0e30-4734-aa25-d5f5cdfbfd93@acm.org>
 <d3306f9d2b88c5b6ae8d2104041e5c941898dee5.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d3306f9d2b88c5b6ae8d2104041e5c941898dee5.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/12/24 6:49 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Wed, 2024-09-11 at 12:37 -0700, Bart Van Assche wrote:
[ ... ]
> So at this time, the device will not have a corresponding
> response coming back. The host controller will automatically
> fill in the response for the corresponding command based on
> the results of SQ cleanup (MCQ) or UTRLCLR (DBR, mediatek),
> with the COS content being ABORTED by interrupt.

I don't think so. In SDB mode, writing into the UTRLCLR register does
NOT cause the ABORTED status to be written into the OCS field. Even if
there would be UFSHCI controllers that do this, the UFSHCI specification
does not require this behavior and hence the UFS driver should not
assume this behavior.

>> The above change will cause lrbp->abort_initiated_by_eh to be set not
>> only if the UFS error handler decides to abort a command but also if
>> the
>> SCSI core decides to abort a command. I think this is wrong.
>=20
> Sorry, I might have missed something, but I didn't see
> scsi abort (ufshcd_abort) calling ufshcd_set_eh_in_progress.
> So, during a SCSI abort, ufshcd_eh_in_progress(hba)
> should return false and not set this flag, right?

I think you are right so please ignore my comment above.

> Additionally, SCSI abort (ufshcd_abort) will have different
> return values for MCQ mode and DBR mode when the device
> does not respond with a response.
> MCQ mode will receivce OCS_ABORTED (nullify)
> 	case OCS_ABORTED:
> 		result |=3D DID_ABORT << 16;
> 		break;

No. ufshcd_abort() submits an abort TMF and the OCS status is not
modified if the abort TMF succeeds.

> But DBR mode, OCS won't change, it is 0x0F
> 	case OCS_INVALID_COMMAND_STATUS:
> 		result |=3D DID_REQUEUE << 16;
> 		break;
> In this case, should we also return DID_ABORT for DBR mode?

The above code comes from ufshcd_transfer_rsp_status(), isn't it?
ufshcd_transfer_rsp_status() should not be called if the SCSI core
aborts a SCSI command (ufshcd_abort()). It is not allowed to call
scsi_done() from a SCSI abort handler like ufshcd_abort(). SCSI
abort handlers must return SUCCESS, FAILED or FAST_IO_FAIL and let
the SCSI core decide whether to complete or whether to resubmit the
SCSI command.

Thanks,

Bart.
