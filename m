Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C438C1862A
	for <linux-scsi@vger.kernel.org>; Sun, 16 Nov 2025 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763332259; cv=none; b=Jib/S+g1bIOvbNavOjO/7N+QCBORwpAufEarFXDleeSTq2IFffD9B2NkrFdfcW7QuzCnnEp0b+Y5S+EN05T/997Lrq3QdUAAaoRiqDeaKyWdh6OVrW1TVOVXW/NoQbbxhAMv5+qhZbDMxbB4E+S8jP40bY0DuURYPFxzm8szYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763332259; c=relaxed/simple;
	bh=gn7CyJP355RYutrkMjr77Fb3xzwp9UHCH/tZGf+jFB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3WtSiikwXo9SIWOjuAFRaorKJR0PAz3DJ3zfQLgbw2I3oH6xjnWH0GQU798wO9/VbkW0lXrE1VDQkAvQ2pb7YEtwhHXz6/yFTRAuA6XA285FlEC3StDmQmSrVLdO2/92d5z4P4zh8Z6piuElKjzLfqjluCSsyPPnMRaCSHo7/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x4SMCjSp; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x4SMCjSp"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4d8lvZ1JBPzm0pKk;
	Sun, 16 Nov 2025 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763332248; x=1765924249; bh=gn7CyJP355RYutrkMjr77Fb3
	xzwp9UHCH/tZGf+jFB8=; b=x4SMCjSpSRx8RhrEo7LwaOFWoIlc1ER7pZAgzyvY
	8Gb+jncF9RpKgVR73dhdREE11OtD0QZleqh3MwJnJV54QAobGd+Utf+7wsskcN5e
	PMb8qO4PhS46ZXJV3LLKlbwQ8Xt/6v3TjsaUR7TAnuqk8ZEUzHdeNjdv+bYJTCnH
	rcEj+5cs4JU1g4Zaq7HfWYccDm9vhd/9Ocu7woA4idvvfeOMZ806m/QTtgIECyty
	leb7N1lR8gtU7G6v7ykAfE6S+AyXxy0twDAWgt4XHml2e8ew/kQ2FaA6Gbq9Jr4j
	7sM5vFBeyAr9WrmHu53x1G+lAZbC9fHCIlocqjkPCFXTVw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GryExVswBtoR; Sun, 16 Nov 2025 22:30:48 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4d8lvK34z9zm1Hcb;
	Sun, 16 Nov 2025 22:30:36 +0000 (UTC)
Message-ID: <b70af2fb-e18b-46ae-b0f5-64cf23354552@acm.org>
Date: Sun, 16 Nov 2025 14:30:35 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: David Heidelberg <david@ixit.cz>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <CGME20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5@eucas1p1.samsung.com>
 <c988a6dd-588d-4dbc-ab83-bbee17f2a686@samsung.com>
 <83ffbceb9e66b2a3b6096231551d969034ed8a74.camel@linaro.org>
 <2a2aef4e-288f-4dec-8ab1-fbc95bc1f880@acm.org>
 <d03f1c89-7918-46f7-86c2-62df51055166@ixit.cz>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d03f1c89-7918-46f7-86c2-62df51055166@ixit.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/16/25 7:40 AM, David Heidelberg wrote:
> Tested-by: David Heidelberg <david@ixit.cz>=C2=A0 # Pixel 3

Thanks for testing!

Would it be possible to explain how this patch has been tested on a
Pixel 3 device? From an LLM: "Running an upstream (mainline) Linux
kernel on a device like the Pixel 3 is a complex process often referred
to as mainlining. It involves significantly more effort than simply
flashing a custom Android kernel because you are attempting to run a
kernel designed for general computing environments on hardware that
relies heavily on custom, Android-specific kernel code and proprietary
drivers.

The Pixel 3 (codenames blueline and crosshatch) uses a downstream,
Google-maintained kernel that is a blend of the long-term stable (LTS)
Linux kernel and many Android-specific patches and proprietary drivers."

Thanks,

Bart.
