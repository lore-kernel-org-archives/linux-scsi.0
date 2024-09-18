Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD82E17A597;
	Wed, 18 Sep 2024 18:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726684164; cv=none; b=hbiznnTaexKesgqVxcEC1Ae/aQ4qvIAHpAiZdjKbaJfXxndYKKlSjmrei0rII4jKz1F1Z5eApbroWpYH7wpCAJLDxPFEpQLds9e2krvdSvj+b/9R0eFTFhmjoEjc+zmHUMH9um4/Kn/8B5qLrzBYLtnCOyrXwVAeJC6fGggdgOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726684164; c=relaxed/simple;
	bh=nkl580+a0uBOKhc5mcNyZK23ECNeaOr9f9p593OR1Ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T0IzbBYPavO6kYWMm/3csaVkv14bDDniedqZgXoSYUEsgtIhBGmfpQ7GOEXLz5uzKvbf96DQQauq2cWZfQ/n1l9nIMZ/ZX1W0SMfmU0VsFkHegzUBylVpYJJe7LlRXLxWVSlVWvJMl5hjFzrt0+ET3C8wCkQYVsyXMaX+9I0UKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FeWKh0CS; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FeWKh0CS"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X86cf00qrz6ClY9Q;
	Wed, 18 Sep 2024 18:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726684150; x=1729276151; bh=n1hkPjiAcjY9wOAoX0674Dr6
	Aw0zG2371dqlM9Wwe+E=; b=FeWKh0CS6b8lxHH+29DNP7yMc57kcF4LyQH/teCz
	3lFD32sH3dU67JWm5a4jQ2AX6TXi3jHwsOMQYFWVF9RW/pUsob+7blK19sVyjg9V
	kE5IOHoqUSDWXFOYH7ryrFHk4RbpremrUf+wOmPrXI3J/FXhc+r0Ccv9/qtHkFO3
	zws2pyLSvO2KookzuCBwKrpJ87OQfGJQcTeBA1mTlx88e02onNXvy9q09PP26DSV
	kO1ifqAGCyTfIVSzAIVZepXfPoz2sRR03doo9HBWlhF6+rUFnE57Klb5BQgwqIJe
	fih/nOUj6tODx+d++nlAQ8mrHTtOWTSFIEvkEphyUSEgFw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dXTB5ufEFL7m; Wed, 18 Sep 2024 18:29:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X86cK4VsMz6ClY9N;
	Wed, 18 Sep 2024 18:29:05 +0000 (UTC)
Message-ID: <78c7fc74-81c2-40e4-b050-1d65dec96d0a@acm.org>
Date: Wed, 18 Sep 2024 11:29:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] ufs: core: requeue aborted request
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
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
 <20240910073035.25974-3-peter.wang@mediatek.com>
 <e42abf07-ba6b-4301-8717-8d5b01d56640@acm.org>
 <04e392c00986ac798e881dcd347ff5045cf61708.camel@mediatek.com>
 <858c4b6b-fcbc-4d51-8641-051aeda387c5@acm.org>
 <524e9da9196cc0acf497ff87eba3a8043b780332.camel@mediatek.com>
 <6203d7c9-b33c-4bf1-aca3-5fc8ba5636b9@acm.org>
 <6fc025d7ffb9d702a117381fb5da318b40a24246.camel@mediatek.com>
 <46d8be04-10db-4de1-8a59-6cd402bcecb1@acm.org>
 <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <61a1678cad16dcb15f1e215ff1c47476666f0ee8.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/18/24 6:29 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Basically, this patch currently only needs to handle requeueing
> for the error handler abort.
> The approach for DBR mode and MCQ mode should be consistent.
> If receive an interrupt response (OCS:ABORTED or INVALID_OCS_VALUE),
> then set DID_REQUEUE. If there is no interrupt, it will also set
> SCSI DID_REQUEUE in ufshcd_err_handler through
> ufshcd_complete_requests
> with force_compl =3D true.

Reporting a completion for commands cleared by writing into the legacy
UTRLCLR register is not compliant with any version of the UFSHCI
standard. Reporting a completion for commands cleared by writing into
that register is problematic because it causes ufshcd_release_scsi_cmd()
to be called as follows:

ufshcd_sl_intr()
   ufshcd_transfer_req_compl()
     ufshcd_poll()
       __ufshcd_transfer_req_compl()
         ufshcd_compl_one_cqe()
           cmd->result =3D ...
           ufshcd_release_scsi_cmd()
           scsi_done()

Calling ufshcd_release_scsi_cmd() if a command has been cleared is
problematic because the SCSI core does not expect this. If=20
ufshcd_try_to_abort_task() clears a SCSI command,=20
ufshcd_release_scsi_cmd() must not be called until the SCSI core
decides to release the command. This is why I wrote in a previous mail
that I think that a quirk should be introduced to suppress the
completions generated by clearing a SCSI command.

> The more problematic part is with MCQ mode. To imitate the DBR
> approach, we just need to set DID_REQUEUE upon receiving an interrupt.
> Everything else remains the same. This would make things simpler.
>=20
> Moving forward, if we want to simplify things and we have also
> taken stock of the two or three scenarios where OCS: ABORTED occurs,
> do we even need a flag? Couldn't we just set DID_REQUEUE directly
> for OCS: ABORTED?
> What do you think?

How about making ufshcd_compl_one_cqe() skip entries with status
OCS_ABORTED? That would make ufshcd_compl_one_cqe() behave as the
SCSI core expects, namely not freeing any command resources if a
SCSI command is aborted successfully.

This approach may require further changes to ufshcd_abort_all().
In that function there are separate code paths for legacy and MCQ
mode. This is less than ideal. Would it be possible to combine
these code paths by removing the ufshcd_complete_requests() call
from ufshcd_abort_all() and by handling completions from inside
ufshcd_abort_one()?

Thanks,

Bart.
