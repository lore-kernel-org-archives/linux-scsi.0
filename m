Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8692317D8A6
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724695746; cv=none; b=ksd1XqJeFtx4uE+aVJRWUJZ7vXSX5Xcd6R+tKIpV235spOrv8J0hhSlGWHJ+78u4XZEHkA9lgZQXqUMRgRb92+GJl4FUG1PnxlolXD6PtESE36u68iRQfiIGgTg7yPHRoso1niBa8pUlEsZ6xmnkDGaH71ni5s1Kbfcoz3mPyQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724695746; c=relaxed/simple;
	bh=W4GzooEqiT/xx4yZcjx8+qMk4ubODq7qTxVb+WsAmpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=igxecfM8lI2PMonEE8ZsuVI0BLlqPFrHGwtN+VAd8hJGONDUuxlQvhENoREVjdF5bvNogALb5DlNO7/jxZOnLsbBs0lc+SaGkil+lGGvtCz33gA91mZGC/8vRjoIvzVZIPvaC+4xwEUdzuNP8pwlK2+oEwzqj51KwUYJ2+l9EhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HH7HMYRQ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HH7HMYRQ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WszFq62m8z6ClY9H;
	Mon, 26 Aug 2024 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724695739; x=1727287740; bh=W4GzooEqiT/xx4yZcjx8+qMk
	4ubODq7qTxVb+WsAmpw=; b=HH7HMYRQycsg5DE6nFCuoU5cRZuVS3Ggrx8XKPw4
	Y9e2AHZCGnUZbR26wuyG0Xr9pVjF3LsPCeFcfrFVks8J7hHKeL6GHrZ2zvYMt17m
	HrIQweuHWqLgj+WxriTkVqg9Zr4Uf6Cyy5T1gyif16vamViuywRHcuGBW+ic03EV
	6NOmt0Cur3Fl/dtIX8i2ee2F9bGD9SZrpIShOUrZin00GMEil7rsxtw2Epu+YefT
	qqUN7cPGKxRtD51gMHvhTvKk+7YKf6yEKWZhWRg+oLKwLa6CRKjUYVjKViN0NEOB
	C5BwCGcJmTnoQQuJXEuyBClnRdyGeTjpLdIcDiaXbEe75g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 241SW4EtQD18; Mon, 26 Aug 2024 18:08:59 +0000 (UTC)
Received: from [172.31.110.201] (unknown [216.9.110.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WszFj44wDz6ClY9F;
	Mon, 26 Aug 2024 18:08:57 +0000 (UTC)
Message-ID: <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
Date: Mon, 26 Aug 2024 11:08:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/25/24 11:16 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> In this case, I suggest use a vendor hooks ufshcd_vops_hibern8_notify.
> When hibernate enter pre-change, disable UIC_COMMAND_COMPL interrupt
> to prevent enable UIC_COMMAND_COMPL after hibernate enter.
> When hibernate exit post-change, enable UIC_COMMAND_COMPL interrupt.
>=20
> If it works, it won't modify the native kernel code, nor will it
> require adding a quirk. It would simply use a vendor hook as a
> workaround, without violating GKI, right?

Hmm ... does this mean introducing a new vendor hook without introducing
any host driver code that implements that hook? I don't think this is
allowed.

How about introducing a quirk that selects the current behavior if set
(disable UIC completion interrupt around hibernation) and not touching
the UIC completion interrupt if that quirk is not set?

Thanks,

Bart.
