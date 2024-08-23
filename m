Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554581940AA
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 20:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724444872; cv=none; b=UAAXO7I8D2Dy0hmA5Ragj2P4wy6XFj6JN9UhbKkQlOz9X8ZSzFVTJr9hsPgQ3p7MXBjGp400Hdl0xQ7NNl8QSuxQoAZ/zp3FnwnmHSjlOn/z9ia2NAAC+2ZZpTkZdPF9hR9LVgBNmEFh2tPWalFWwp5s6sMlLyaaksGupQ11HB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724444872; c=relaxed/simple;
	bh=fVHqq2IPyfvqjlRSJP88AuevL24As5eSIs72RQvTluI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CeJykYJGASLWYTlKlHNFPzPRPvLrEVko+LiSJKxgEYYIXfXxuP4VSmBdQqenbGQgPk1PVaaSfs9uj8uS9i3S0QoIlsvuGKfVJmb2L5PKApwW83+me9o+zTRSIGwoycSx4z/D8AYgbm5sl2StQq6ejEqMbPvVU3UEQnUqDI9vbsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bSeB4aTJ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bSeB4aTJ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WrBTL50LlzlgVnK;
	Fri, 23 Aug 2024 20:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724444867; x=1727036868; bh=MS3iIWVy55JDpHqgZn9Q82Zb
	1YijlL1niKS37pYgttM=; b=bSeB4aTJAVXRRvdHmPD/L+u/qMoSJMkkCH4tpzG6
	FHjhehyTqATBLCTUJz3V5o3oYUutknDKbln2ARSOj90cxwH/jauwEn1RV1bIBzCO
	FW4xOFg3R1o7SaOMjtptZJdBLcd5o+e5bBB55CkSdvg3Ab4VJA2AtFLkznVv1WEh
	sdDMmqq0bOcgc2gIzNxQ8gqU7nhpvPIiy7XQ4FA9Sz5qcwhH7I4KopyxOYYoPAdZ
	38JstyGS2Zujgtag1wegCrouPerGXAIXpCWAmbl3POHJP0+FyLqhOFqOzRuN0f+8
	l3gCO8A0FYEgi59utXY69fYf1bd7N8risIK7KSjxwACCeQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FazZj4b_MJNR; Fri, 23 Aug 2024 20:27:47 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WrBTF3dv2zlgVnF;
	Fri, 23 Aug 2024 20:27:45 +0000 (UTC)
Message-ID: <63b82e64-e968-4704-85b8-fad919994432@acm.org>
Date: Fri, 23 Aug 2024 13:27:44 -0700
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
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/22/24 7:57 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> You assume that the following steps are executed in sequence.
> (Theread A) send ufshcd_uic_pwr_ctrl
> (ISR) UIC_POWER_MODE A
> 	clear hab->active_uic_cmd
> (ISR) UIC_COMMAND_COMPL A (step A)
> 	do nothing
> (Thread B) ufshcd_send_uic_cmd set hab->active_uic_cmd (step B)
> (ISR) UIC_COMMAND_COMPL B
> 	complte thread B's cmd
>=20
> But actually step A ISR may come after step B and cause error.
>=20
> (Theread A) send ufshcd_uic_pwr_ctrl
> (ISR) UIC_POWER_MODE A
> 	clear hab->active_uic_cmd
> (Thread B) ufshcd_send_uic_cmd set hab->active_uic_cmd (step B)
> (ISR) UIC_COMMAND_COMPL A (step A)
> 	complete Thread A cmd=09

Hi Peter,

Can you please take a look at the fix I proposed in my reply to Bao?

Thanks,

Bart.

