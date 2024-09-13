Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959886F2E2
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726250136; cv=none; b=f3FvKL74bu3sxrpvCJDg340AKkiK1CFXHhzqfivZEAdL7aScCrVDxtNIfedIAqjgVrQSpD/u2L/BxEefJpu+0oHzBNLtqEWc1bzrBFql7ksPar5RPtjpps1JwqG0d9COlInYfrMIEqC/Uckco4I+OmWlfI8n2PfkRjnHwCfS+XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726250136; c=relaxed/simple;
	bh=GU4VC/uji0ikp/wEq2IDZJMobVOdcoViMCfqfKAvzIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bR7+siFhMWk6Zt4bkGDWuaNKdg6P8Hf4RNf4VIiVVIFw1Jc8bUckn9xqUOLEDIswLD5YFGZMDglLjj3tmuV1AbvDLptvDJDDeq25N5tQd55/Icn47XiDLTOlqVx/RG+G3tWUGoqRyTT/uajfrghBvpg+nuMmywaU6KMA/al5mdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=A7GcIoD9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="A7GcIoD9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X525y0XG2z6ClY9y;
	Fri, 13 Sep 2024 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726250131; x=1728842132; bh=GU4VC/uji0ikp/wEq2IDZJMo
	bVOdcoViMCfqfKAvzIc=; b=A7GcIoD9K3BnX/jhfbwtseOFLCW4I1Nom6B57uys
	WfF1B0Pi4riHE5IQmYQQ2i5ktIw3SPpVCz/RmpYTAGbK2nmuynEHtyRQMTAvJzaX
	LlRimFJEI28X24OpByI7VQ453KfaHxGqff4qiAhmR+lbUUg2drdXJOX72F66c5hG
	iWPJdDJyBL/sByqc+AaoqTnG9J/9y9fQGheib4BaOHKaTdzvxWIMnFLnUbwbYREt
	o7I5sqD8vq12pnECzGSPwpInhQADO7GtNJj0QJOAHs03YDS0LA/Q1km71/regCHk
	yrK9aJugfJFJu0xpmBHIJDpv6Pnb/aCwMwVxT6XlJtH4QQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LP3wr7ye64yW; Fri, 13 Sep 2024 17:55:31 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X525s3mf5z6ClY9v;
	Fri, 13 Sep 2024 17:55:29 +0000 (UTC)
Message-ID: <fbbb8d00-2b70-403a-98cb-55ca0dba1d7f@acm.org>
Date: Fri, 13 Sep 2024 10:55:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>
References: <20240912223019.3510966-1-bvanassche@acm.org>
 <20240912223019.3510966-4-bvanassche@acm.org>
 <c4ce91f3-6724-03eb-ed72-0215c8992e0c@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c4ce91f3-6724-03eb-ed72-0215c8992e0c@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/13/24 12:31 AM, Bao D. Nguyen wrote:
> On 9/12/2024 3:30 PM, Bart Van Assche wrote:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ufshcd_is_auto_hibern8_error(hba, i=
ntr_status))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->errors |=3D=
 (UFSHCD_UIC_HIBERN8_MASK & intr_status);
>=20
> Hi Bart, while you are at it, there are extra parenthesis here too.

Agreed, but since of the one-change-per-patch rule I'd like to keep that
change out of this patch.

Thanks,

Bart.
