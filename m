Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12F5365D28
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761840727; cv=none; b=EVIVoAs6wclkj9T4Mnz/TFR5B0AOKsYnhSeXVD2btq4oYl1bVGz89YKPZz3QqVXBHNIYs3CMtzO+wkxOhkv0PHCnrHgFCl8bjLT9yhXtKoPjggMq57It2iBgJ/R1guERe4/xI3ODHxu2m8CnPMbpA72bAtn1E7OUMW+bQr7T570=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761840727; c=relaxed/simple;
	bh=Ndb0fIfS9pyboJ2DqnoHZZQWZX6DYqEAALp/Kc5CiJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jocYbhXPjVbnbNWnzu68yFmFXM5kyfWXdWC0MtD8GFMzfPRFxwooLKqVn8sq0oO+wDjMjtGJwOK5Qc8i914T5YHrmopchH5RS3duH5PS2zu/k6KK/BVQihjuNfv6Ufseco1vRq0gqZlWmWpknQcILA4WejyY40R6fBXF9Qfn4hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qz0/7DOt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qz0/7DOt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cy8JG3Y82zlnfwj;
	Thu, 30 Oct 2025 16:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761840716; x=1764432717; bh=Ndb0fIfS9pyboJ2DqnoHZZQW
	ZX6DYqEAALp/Kc5CiJA=; b=qz0/7DOtKr6HBSMtRxiSXzNO/BeA6sUEqon1gYCK
	JsQxb4RXxxMIOdlFrUwc0MVEWzyCPpuJ1ro9+Dij+VQNdaUTuq6pzdRN307ymOwU
	BSl8F4idbbUb6KEnIAPLXGfheJ8uCdiUIbf35xytF35cCgWDB/AYma3cQdEQh7V1
	EdWfUxXDXt00jyXBFGi7fhPk/cxhfuaub5zkXpCFanwZ6O/HqpRPWnrMAQPbikKd
	5NVh8v24CpyIyLUDs6zXRSS0dpgNgZ9mQpn2XHL6iQtmz8IyCnRZ8g51sd3IHbqE
	6DhSwOCSEv+Z4FHX7R8Yboyrwkck4etPKRcKlq/PCH1zFA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id O3eTcBxV08UD; Thu, 30 Oct 2025 16:11:56 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cy8J54lMNzlnfdF;
	Thu, 30 Oct 2025 16:11:48 +0000 (UTC)
Message-ID: <b658b822-e6af-4222-91df-39f1a920133a@acm.org>
Date: Thu, 30 Oct 2025 09:11:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "ping.gao@samsung.com" <ping.gao@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>, "mani@kernel.org" <mani@kernel.org>
References: <20251027154437.2394817-1-bvanassche@acm.org>
 <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
 <37a7d14c-5e6f-4fb4-a850-af3ca322ae99@acm.org>
 <7d955a693d11424d527fcdaf4f05ffd792e1edfa.camel@mediatek.com>
 <1674d018-9243-4fd5-83d1-26783165e3e6@acm.org>
 <c1c7b449924dd0eaf8179cf8a3e5b9983fffc0ec.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c1c7b449924dd0eaf8179cf8a3e5b9983fffc0ec.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/29/25 11:38 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> It=E2=80=99s possible that you misunderstood my point.
> ufshcd_mcq_sqe_search will alwasy return true if
> UFSHCD_QUIRK_MCQ_BROKEN_RTC flag is set by below flow.
>=20
> static bool ufshcd_mcq_sqe_search(...)
> {
> ...
> if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
> return true;
> ...
> }
>=20
> Hence, the code below will always return -ETIMEDOUT.
>=20
> if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
> return ufshcd_mcq_sqe_search(hba, hwq, task_tag) ? -ETIMEDOUT
> : 0;

Hi Peter,

Thank you for having clarified this. This is something I had overlooked.

I took another look at ufshcd_mcq_sqe_search() and it seems to me that
that function can't operate safely without stopping the submission
queue. And the submission queue can't be stopped if the quirk
UFSHCD_QUIRK_MCQ_BROKEN_RTC has been set.

I will drop this patch.

Bart.
