Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50813279917
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760976847; cv=none; b=bcl811Hu/pM3G/W9OBG5ANOQ+KsNuuX4Hna4gTI8ruFDN7PVB1YfUOXOnM5RIj2CwhTdoCebRewpgMxE2PPdrkZfzoPPqRdvXF0mqV6KhyWwvElO6NDMnPH58qjP4ntURSpcAngow9e8BlxtkZ6GayDbLpHiL4/QTGdU6a0Dt3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760976847; c=relaxed/simple;
	bh=OUmz5lCRR7pA1Xb3FdcvzF5ShY8dpKAtXPtwFyP9Mh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLgpk5I4DTm6758P2KV77rgfhghuGlpaL/YenIGhZ//CRtBtAff2T79Y1EAgx2DzhgjEA53VS0Rrz6/a2DRSaytmYHf0AxHK889wXhv549ZIIBUrVAQHSzrPL/08PG9YUHqw8xOgmdzA8WJb19DHI0X+SodIzm4yZWnWZnZnWmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yqtDNBks; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yqtDNBks"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cr0qJ1Ysqzm0yV6;
	Mon, 20 Oct 2025 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760976842; x=1763568843; bh=KgZzwvaAqPFVP9R9WojbaK1B
	5spxdrZCS30om7VD8jI=; b=yqtDNBksWdkFS+mt+aOzNWSyidANsFqLor4gIsZZ
	b8RrH17mKOVMLN+uBLCY+rOqgz0T7CwHLdMgNHT2R50xD76OT3MQ6TdG1EymGU44
	pQpONiR0Fu2xrggIkL2srlapXf7T07XgUducyB7nTd2U2f5yY5av91AE4FL42+z0
	Pta0FARZ2sPy9ZqQjEX8Wf5hLkjaKC5n22RJIwtFUhQBbzECtt7VjNYrwAlyWXTr
	DGRUuspXbFnyrEdqadlRyX2VkJoIUaVizxpcudedmIIfHyExMYjsjTU0sTQhH8yr
	uhZck0V0rPJSiQjX60G4FZXBLfISAGbx6fpC0jZrsoPvfw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b-T0wktVw0PJ; Mon, 20 Oct 2025 16:14:02 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cr0q81j7czm0yVd;
	Mon, 20 Oct 2025 16:13:55 +0000 (UTC)
Message-ID: <62ec19d2-f7ee-445d-be97-098acc1f390b@acm.org>
Date: Mon, 20 Oct 2025 09:13:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chullee@google.com" <chullee@google.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <20251014200118.3390839-2-bvanassche@acm.org>
 <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
 <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
 <bc0ac3e9f44bb3c6e0f06efd7372b21535ac07a9.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bc0ac3e9f44bb3c6e0f06efd7372b21535ac07a9.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/19/25 11:51 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Fri, 2025-10-17 at 09:25 -0700, Bart Van Assche wrote:
>> Sure. The call chain is as follows:
>>
>> ufshcd_async_scan()
>>  =C2=A0=C2=A0 ufshcd_probe_hba(hba, true)
>>  =C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_device_init()
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufshcd_device_params_init()
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ufs_get_device_desc(=
)
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sysfs_up=
date_group()
>=20
> It seems that ufs_get_device_desc() doesn=E2=80=99t call sysfs_update_g=
roup().
> Did I miss something?

Hi Peter,

Please take a look at commit bb7663dec67b ("scsi: ufs: sysfs: Make HID
attributes visible"). That commit has been merged in the upstream Linux
kernel during the v6.18 merge window. See also this pull request from
October 11:

https://lore.kernel.org/linux-scsi/6e77e31acee95ebcba03c54dc1b34173cbaf83=
1e.camel@HansenPartnership.com/

Thanks,

Bart.

