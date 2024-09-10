Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A6A1A0B1A
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 16:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725987200; cv=none; b=clMhYp5Qq+f0e+FiNr5VKbo1UueNWFRz9x3v9/BRCdwnFWXdv72XuTMIVrLcjhaYbzI8oMeuvEIwS6MvmJ/ykDQgfnila9np+BF2zHCsOR/tHbcpE6vF4eB4/NPr3wWCJkBuF2U9RijKI8RQZ/GdwPBedBgKTOOIlVzQWJfEvQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725987200; c=relaxed/simple;
	bh=jL7/VeVUqIdK4tKX+yWUaG3KzGNEFcC5WQWSHkT59IY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7bYVDhv0HORNPP1fJFaphmZZDJNydb2dM6l3LWwaCt/0uReTYO0WOPdju+Mqr4FQfy1eobDCLHl2BLX+yoocU1YTgefHb/6xEIhNLbyIRXjIveYB7bn0CREPdDbDP+f+5Lq3czc/iKf/5Wwp/yyZOuxELz+JsVLkXycu8SWBCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Pu223Sn7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Pu223Sn7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X38sN4rPfz6ClY9C;
	Tue, 10 Sep 2024 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725987188; x=1728579189; bh=jL7/VeVUqIdK4tKX+yWUaG3K
	zGNEFcC5WQWSHkT59IY=; b=Pu223Sn7dRtRBJBa/sKYh4NO16eqPcPPHY45lTlX
	gRY3NsluHhNL17r4RjGJ4fh6d4qdZuRA5RLT4/TyWojb0yLT8PPfCUJN7biMRxjh
	bMHGES7DZm3rFmab0szzwmyWCakTsJtP0vG2dulMMcjJe9RNLY514+JRTaUyr6Fm
	+FLi9NWOryXLV8AIJX4Mvh3ef0JJ+7bZ0WpBKhU89RB46NClij8pwDKmWis9nres
	IaL3Rxf48HTscl2ww23wL5vqReqjJ8W8IgbzElYZvwxBDDewwtd9HI9RBBfElGcF
	nlL2fI57ybjy6sKC8AfLbjE5tt7vKDafokyqgDO5ksyLHg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pV-4Z0agyY0T; Tue, 10 Sep 2024 16:53:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X38sG4nycz6ClY8n;
	Tue, 10 Sep 2024 16:53:06 +0000 (UTC)
Message-ID: <4c8b1da1-aa43-443e-b6bd-b759abb4d6d1@acm.org>
Date: Tue, 10 Sep 2024 09:53:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] scsi: ufs: core: Change the approach for power
 change UIC commands
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "ebiggers@google.com" <ebiggers@google.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "minwoo.im@samsung.com" <minwoo.im@samsung.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "angelogioacchino.delregno@collabora.com"
 <angelogioacchino.delregno@collabora.com>
References: <20240909231139.2367576-1-bvanassche@acm.org>
 <20240909231139.2367576-5-bvanassche@acm.org>
 <bc2a536c97de9e536dd25a5ae11dea6127c7e82c.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bc2a536c97de9e536dd25a5ae11dea6127c7e82c.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/10/24 5:36 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> I'm not sure what other SoC host think, but the meaning of a "quirk"
> should be to use it in situations that do not follow the spec and
> require special handling. However, MediaTek designs according to
> the spec, so using a quirk may give the impression that MediaTek
> does not follow the spec.
>=20
> Moreover, it shouldn't be the case that only MediaTek and Qualcomm
> need to add this quirk."

Got it. Let me think further about this and see whether there is perhaps
a better solution.

Thanks,

Bart.

