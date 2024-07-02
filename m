Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794E7282E1
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 20:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719952055; cv=none; b=F8G1MnbNdhZFaLSKW6euI5C3mQ/7flzR746GoBY71ZdYpr2A1+HfKOaE2wWMryDSf7K50G5BaAwgptfPsyZG6iYItpX8q/WAwjRE1Mbb03DltsffhSfTgj+QOfq70j6+g9dxGU1mb51yuJ8uE94bTM7kV8UvYillzsQYPnxR7Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719952055; c=relaxed/simple;
	bh=4WvldaF/KQ0sC9FwV8/VcLdzZQPN7V2udcXQI4AaLVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r7nCUuUsMTnHn2CeLu1IVI0HzkVjOQuJSMT8JZaAdpbUpboN+v7StWFaqJ6t+/vyhJPkP764QS5wiH9Bu7uWdf8zpoWhdQ6ZuHUjHx/IU6s2+k9mV0etc+qVqUMWGJJtO+9Kg9OyPzSb2cY9Cc1bzvV/RciAOrLoKfRvbI9DkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AYf9dn1I; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AYf9dn1I"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDDwt4ydvzlnQkn;
	Tue,  2 Jul 2024 20:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719952043; x=1722544044; bh=4WvldaF/KQ0sC9FwV8/VcLdz
	ZQPN7V2udcXQI4AaLVM=; b=AYf9dn1IMb9euICCizTqDC0Rcdvu9qzq+VH9C2Bx
	D94FLc51DwIg+ICKcDjX6UBw9l2S0wO137GajN+gXRXWuFkAsWGfMWHC8IMNhGp3
	nmhBe309ghillBb89R9HiUc8wYgBNQzXPDrU1iAgKeFmX/v37C460tffvCosUEYn
	9vtRp7aNUcWSe4XzJ3k4jRCd4z0eujddMK23zzJaP5gm37o8j5C7a2zXyzAQfdSV
	FyX2LZOnFXO/AWkhB9aFSho50EogxmW2P+fZs7zAcERkPme8jPZsz6D+qUJ2fGYf
	8pK+b4D175XPvCRvIdVqKze13jNEMuaj2nS9qIYxgZs8SQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id i_Uy7GwQWhzn; Tue,  2 Jul 2024 20:27:23 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDDwp03xPzlg9g7;
	Tue,  2 Jul 2024 20:27:21 +0000 (UTC)
Message-ID: <31ba05cc-3ab0-465f-8d3c-b0e32e13f583@acm.org>
Date: Tue, 2 Jul 2024 13:27:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] scsi: ufs: Make .get_hba_mac() optional
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
 "yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
 <20240701180419.1028844-8-bvanassche@acm.org>
 <0b1a9acb836a5ce5467ec5e2327b750ace51ad82.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0b1a9acb836a5ce5467ec5e2327b750ace51ad82.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 7/1/24 11:29 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Before ufshcd_mcq_enable,
> here read REG_CONTROLLER_CAPABILITIES should be SDB value.
> Beacuse MCQ is not enable.

I think this needs to be fixed in another way, namely by enabling MCQ
before ufshcd_mcq_decide_queue_depth() is called. See also v3 of this
patch series.

Thanks,

Bart.

