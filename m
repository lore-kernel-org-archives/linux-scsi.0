Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1229F1755C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725987133; cv=none; b=kFTebcKfX8ViohH0OER3KPMs5QfJpSYTVxqWNQbjEjWtAvPMRQXe4HkjxNmTYXAsUpB58ikmSYbKfkt3kBupzMM7Ur5FO781wj7Ss5P36EAKFRebqvaPVWO/dLS98dbA4a040ecji+ordIbExtc5kE7pAXund1nk/WqTfeNR4SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725987133; c=relaxed/simple;
	bh=sb2JFs6Gtc508Mf1eZZArtNewp8xt3VGWxPYVQzQzQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kOY/CNj33sS62x9hwUo4jmsSkZrDFf0adK92N9MzpMougU5K1wQ6Az6meWNBslr1kXmIz4g9H7EpOVmUDOgSf5BPAaNe14F3l2iOvcB7KcER1Fz9ou92QiyRUvqK/eudmX5D1WqfxZjz+rsxpvKiJNRjSUcU2xtVS84zhgrxUpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FCY2FR08; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FCY2FR08"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X38rC1lq2zlgVnf;
	Tue, 10 Sep 2024 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725987127; x=1728579128; bh=Df7l14F8jXFtCF6/vah94d3d
	aPn5x21Gm5j+RNfmjUc=; b=FCY2FR08YBp3MINtG03P5v8kTe7r8YxEfo7sIfmK
	APlThcJE1TvYuJ4BphXGOv5R5oDpxlFONFi95R1LYPzA6i8GEax+0w4CkAlhDCy+
	5sETjqanNgFw2BXzaN1Z7Ambt/wcYcDc+Yd4WVjt4ZrSGHpxxRytiRQh4AUijlQ7
	flkjfhzmddZdszVDpbkfp7yNjgG6EJM6HYxLC4MpgFQru6VwoXfLJgZZPa5+4ZvF
	WVE+Zn1ynFy1xvkXQWq8sr4j+b2KiQbpxqbkO4HHbiBjphnTFBFBLXtOo4y971tw
	xeIa/kbfunpBiEgxtijQFpplMu6aXOD3yroYoX6ar0Y6Aw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QVHH0Trz8ZYE; Tue, 10 Sep 2024 16:52:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X38r66NqzzlgTWQ;
	Tue, 10 Sep 2024 16:52:06 +0000 (UTC)
Message-ID: <ddebdbc9-0866-429c-985c-0529ddb4c1ef@acm.org>
Date: Tue, 10 Sep 2024 09:52:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] scsi: ufs: core: Always initialize the UIC done
 completion
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>
References: <20240909231139.2367576-1-bvanassche@acm.org>
 <20240909231139.2367576-4-bvanassche@acm.org>
 <cc8434bc72a8f015acd2acaa6dc9ad84d7c9d76f.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cc8434bc72a8f015acd2acaa6dc9ad84d7c9d76f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/10/24 5:34 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2024-09-09 at 16:11 -0700, Bart Van Assche wrote:
>>   Simplify __ufshcd_send_uic_cmd() by always initializing the
>> uic_cmd::done completion. This is fine since the time required to
>> initialize a completion is small compared to the time required to
>> process an UIC command.
>=20
> The time to compare should not be with the UIC command process time.
> It should be compared with the time for the "if (completion)"
> conditional
> expression. We cannot justify increasing the latency of sending a UIC
> command just because the UIC command process time is longer.

Although I appreciate your concern about performance, I don't think that
the above feedback is appropriate. On my test setup UIC commands take
between 20 and 1500 microseconds to complete. A single init_completion()
call takes about 0.01 microseconds. So I don't think that the time spent
in init_completion() matters for UIC commands. Additionally, this patch
only introduces an init_completion() call for power management commands
and not any other type of UIC command.

Thanks,

Bart.

