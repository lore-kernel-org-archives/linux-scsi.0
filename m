Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014F2347FED;
	Wed,  4 Mar 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772636640; cv=none; b=iuPezc9Unx1qIhpbv/+fPvX1NkzqOzA6g0sqvYSM1hZdaa+gXhPRexJBttQiNcw+XMV+OJkU8Qv8QVggQb3750T9Ve5achma50EBk1HknJuLatISwMhhSIqW2a9tZPmD8opJ1/fSTbWH+9BX1tve1Zby6A+KFJXs5puEVrvaiGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772636640; c=relaxed/simple;
	bh=qUBhHFU3PdKI4qz6TzxREgJyoDaNnI1/K/vqlI7LWzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LK+TDTCS4LJ39DiH6tltqTdE6mfhx/u9Bh15OCMtzDZHVQVIatIFe9S261gkmLhi1/XgQ//haqaMdFzaalWHnJGf2FQ3YxwURJAKoajrBsoRNQ8zKDYU65w/B7Ovq4hha12sZM9Rz85UsD3fdd9bF/ZyXITrC6XIEJTZ4DEAWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FCyZUgq5; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FCyZUgq5"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fQwt30VfRz1XM0pS;
	Wed,  4 Mar 2026 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772636607; x=1775228608; bh=qUBhHFU3PdKI4qz6TzxREgJy
	oDaNnI1/K/vqlI7LWzc=; b=FCyZUgq52i07D3SIoLO0QTggaglP6YI0lQ/ERccf
	v9yvln40MGipTrGuLxJp5bCizrYqRJHLSccTYT+unBxFUj8DCFCya37dzwHkLmWq
	MutIP5+Xibv4axuvoHIbxGuc2pxl4l/AB77EgDT8hvLpNR+Vuxn7lrBT3n59omFP
	26Zs7wvGuC4cZLQNZJ0yTy/QZ2PicgZrOpaM0tT2KH0IWWesdyjDKiCjXU2XhlXm
	twy1ihWeze436pYITtdwHNeAV1vpzi3jVUBKbC38V+H+byDiFMPrUt9yNOXBY+oD
	KDbHAORBv86Iabn3Z4s04IV9CTixV0rRUNEm+aROaLEcHA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bcHpn71STf_C; Wed,  4 Mar 2026 15:03:27 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fQwsM3WJQz1XM6Hv;
	Wed,  4 Mar 2026 15:03:18 +0000 (UTC)
Message-ID: <2cdc620b-b521-4058-a802-87591aa4c253@acm.org>
Date: Wed, 4 Mar 2026 09:02:57 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Handle MCQ IAG events
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "vamshigajjela@google.com" <vamshigajjela@google.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "arthur.simchaev@sandisk.com" <arthur.simchaev@sandisk.com>
References: <20260302180117.2797184-1-vamshigajjela@google.com>
 <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1fa500fdfbfff7d43bea1839ce1992fb4283c5eb.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/3/26 4:25 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2026-03-02 at 23:31 +0530, vamshi gajjela wrote:
>> @@ -7141,7 +7149,10 @@ static irqreturn_t ufshcd_sl_intr(struct
>> ufs_hba *hba, u32 intr_status)
>> =C2=A0retval |=3D ufshcd_transfer_req_compl(hba);
>> =20
>> =C2=A0if (intr_status & MCQ_CQ_EVENT_STATUS)
>> -retval |=3D ufshcd_handle_mcq_cq_events(hba);
>> +retval |=3D ufshcd_handle_mcq_cq_events(hba, false);
>> +
>> +if (intr_status & MCQ_IAG_EVENT_STATUS)
>> +retval |=3D ufshcd_handle_mcq_cq_events(hba, true);
>=20
> Hi Vamshi,
>=20
> This is strange to me.
> Why does receiving an IAG_EVENT call ufshcd_handle_mcq_cq_events?
> Shouldn't it be ufshcd_handle_mcq_iag_events instead?
Doesn't this follow from the UFSHCI standard? From the UFSHCI 5.0
standard: "MCQ Interrupt Aggregation Event Status (IAGES): This bit is
transparent and becomes =E2=80=981=E2=80=99 when all of the following con=
ditions are met
=E2=80=A2 Controller is operating in MCQ mode (Config.QT =3D 1)
=E2=80=A2 ESI is not enabled (Config.ESIE =3D 0)
=E2=80=A2 At least one interrupt aggregation group has triggered, which m=
eans it
has satisfied either counter or timer condition

When in MCQ mode, and ESI is not used, SW can use traditional interrupt=20
approach. When this bit is set, interrupt routine needs to scan all
interrupt aggregation groups to determine which IAG has caused this
interrupt.

Thanks,

Bart.
