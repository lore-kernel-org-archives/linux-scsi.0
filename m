Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D005C4D108
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 11:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724843910; cv=none; b=IZfe9xsO7/KTpvJ/urjW9sxi5Wd0ktMGXsn+0RZRaKVoWyH6FZH+QEHW/hl2yS5rLQRewtfyEGZq0wM6I5a0IO1YbLcnHJHRBCx9oG/fFXxxzyzMTqVUS8Bl+2G5+Ts4ZMf2xdoeO0mSS6c/3prIx8Gpq1BA4uQIElSsyXOYMWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724843910; c=relaxed/simple;
	bh=awrB3FBOyBTZ4p+nAjMAmIqfDIIGN3nvevBtnYAAisI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BQnYergHbNvU5c4y1WMqGwFrD/i7p4cZb1dyLd+Hr6YfDsX4+HqGevvI6iMRYytsgSd185/7UzUxzD31b9He1iuVy1tSYD5hysQ8eGe1pmxt81ioi3/tXD6w/8NquDMwjf/f4YPKJMdWOpF8vF0UwhLsm1VkE1EsHTRWIbMzmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JYagSAYw; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JYagSAYw"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wv2323xf2z6CmM6N;
	Wed, 28 Aug 2024 11:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724843897; x=1727435898; bh=OUBE34sMobsn4T9s6yl5UtbC
	pcnOSH3aZadDdXwARac=; b=JYagSAYwDrHuhL8EMLS7k/AsoN/1XrU1Nzk3xS3N
	Xi6N3PNTc9IzZO8N/XMpYmUuJ0V23Bud2ZwY2D2LFMKZGThoqolxEiJr8llRGlRx
	QWq7Zk7qSSwjlz5D9EvlHPD7BN+rCMhJ4EoeRUXsEpktG8E3ZYhlWhXKOu5zwh+a
	I3Y5CF/mVqBriq54n9IzVjD+DNK1RfmWcGkpiZ8y3pEjPKw9MHt0HJ52BkFXmvKB
	55AvpgRC2NqxGqtL0vea2BdXCcXeRcdXB+WS9HkbITvkHF2jxgf/B9+TYAH8Mlf2
	Tuqqx4v4qoAH6RNX3SIfEtA+IotS30UwdhKINigvKjG74Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LbV6940oQHmw; Wed, 28 Aug 2024 11:18:17 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wv22t5h4vz6ClY91;
	Wed, 28 Aug 2024 11:18:14 +0000 (UTC)
Message-ID: <71de72f4-2cb0-44ea-aac7-0f2a5c8fa492@acm.org>
Date: Wed, 28 Aug 2024 07:18:13 -0400
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
 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
 <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
 <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
 <0476168b16b4ba6a2b52cad23714206c6e386d80.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0476168b16b4ba6a2b52cad23714206c6e386d80.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/28/24 2:17 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> No, I means you can reference ufs-sprd.c driver. which may have the
> same issue?
>=20
> 			/*
> 			 * Disable UIC COMPL INTR to prevent access to
> UFSHCI after
> 			 * checking HCS.UPMCRS
> 			 */
> 			ufs_sprd_ctrl_uic_compl(hba, false);
>=20
> Then after enter hibernte, you can prevent access to UFSHCI.
> After exit hibernate, enable uic complete interrupt again for
> workaround.
Hi Peter,

My opinion about this is as follows:
* Host drivers should not disable or enable the UIC completion
   interrupt. Only the UFS controller core driver should do this.
* The behavior I'm observing is that modifying the REG_INTERRUPT_ENABLE
   register is sufficient to cause the UniPro link to exit the
   hibernation state. Avoiding this cannot be achieved in a clean way
   without modifying the UFS controller core driver.

Thanks,

Bart.
