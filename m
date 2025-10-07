Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8956F2E7658;
	Tue,  7 Oct 2025 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759854006; cv=none; b=kNxvT6wdfeHlDXNXnVfjnL9h+VZUvymu5p6bC2s1KRetj7vPzNSRBp8UP06SN1/cz8gdv7Aw8wLzhF7rSRmja1VHJfICljTgo9e4ogqfTyA9uNuofKQCYg1NevlkXrU/GVAylFbDwnpvO1SiUNSV/SNsr3nHlHKkzwmkJiym39E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759854006; c=relaxed/simple;
	bh=h/Eg/Uc6BoL1pnkILtNEBcDhyDg10QbRxuCgWt+axpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcTtT0/qbLnn7CGv/dTmOC+QuFihGwCyykR/27Qgr2v8h9uu+PpkHM0rcFzyuS3TqnZbqDm6PU4NyA5ldCMJjxI9xlLKM/FSVwbThE7kxZ8dAi+m2pLaaiWUUsBP564wIYfTuSSMOFM4XIc/gHAnIPxRs4oVfxExfYTidQo3QaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xoD0pR9R; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xoD0pR9R"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ch1ZC2hjJzlgqV0;
	Tue,  7 Oct 2025 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1759854000; x=1762446001; bh=h/Eg/Uc6BoL1pnkILtNEBcDh
	yDg10QbRxuCgWt+axpY=; b=xoD0pR9RDOxtIlxFtnRIjLF5rDcQM0X1iuuILYui
	O3QZUQDkXGb+c8M22sxgLJJEt/jyua8CnJfK1FlY7ovl1bTcwuSpuZJutVBviAEk
	txlm9ekn8MOKdM0iDBnrUH9VMVBpQW/S6SV7nJYSS27TYQg65+MkPS8F5oRTenjA
	l/09DjusndKDTO86kC6vhfpzfvG0oMyOeoVfA6Yy5rW4j0RFuYbFKJ0Gy+j54Xgm
	CclaftVCQ6yBhavTdG6erMsRG/mDOscI97eVXrsU/GL/pP1t+AtXCFb2+1mRnJLc
	UnaHZ+eowxsGQXuJkPVKDQIkJPrI3c+ICHVi+PLxaKEcLg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sWalvk3kUJVJ; Tue,  7 Oct 2025 16:20:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ch1Yt1s7vzlgqVF;
	Tue,  7 Oct 2025 16:19:45 +0000 (UTC)
Message-ID: <2ce08f9f-af8c-4cac-8d66-97517eb18037@acm.org>
Date: Tue, 7 Oct 2025 09:19:44 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] scsi: ufs: core: Reduce the sleep before vcc can
 be powered on
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1759348507.git.quic_nguyenb@quicinc.com>
 <b9467720ccabbabd6d3d230a21f9ffb24721f1ed.1759348507.git.quic_nguyenb@quicinc.com>
 <c12b15699ad8176760c220100247af15954f30d8.camel@mediatek.com>
 <a1eaae1e-3e10-4512-bc83-ae25eacc43d6@quicinc.com>
 <4943d9d6e31b2993ee0563722b8bc38c3b1ef069.camel@mediatek.com>
 <234a5185-d7f3-fe81-9c02-7895691c1fbd@quicinc.com>
 <85bce5dc28293f48e32b64eed5591d66c54c9e69.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <85bce5dc28293f48e32b64eed5591d66c54c9e69.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 10/7/25 12:04 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Fri, 2025-10-03 at 14:27 -0700, Bao D. Nguyen wrote:
>> With the current or recent offerings of ufs devices in the market,=20
>> the requirement is 1ms. For example, the Kioxia datasheet says
>> "Vcc shall be kept less than 0.3V for at least 1ms before it goes
>> beyond 0.3V again". Similarly other vendors have this 1ms
>> requirement. So I believe this indicates the worst case scenario.=20
>> I understand there may be very old devices that are upgrading the=20
>> kernel only. In that case I don't know the specifics for these old
>> ufs parts as mentioned.
>=20
> Hi Bao,
>=20
> Please consider using module_param_cb to set the default
> delay to 2ms(or 1ms). At the same time, we should keep the
> flexibility for devices that may require a longer delay by
> allowing them to extend the delay through a module parameter.

Why a kernel module parameter? Why can't the default delay be set by
ufshcd_variant_ops.init()?

Thanks,

Bart.
