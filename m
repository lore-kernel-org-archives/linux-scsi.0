Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E779312834;
	Tue, 11 Nov 2025 16:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762879080; cv=none; b=pXTdufegw3SDvyapTHf6vzfi4/tvakAt7y1WJqliOkbshjqW8ALDEzghzRMW3AIqbsMIA4eLcKkV+ho5iqu9CE7OK1FBOHAQmHX8F3Y+xJK0S/CzeDVXjXh0wQBunlXE4KQ92ajaik9Yi9MDyXlum+K4l3uERS/ZC+P1oQSemcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762879080; c=relaxed/simple;
	bh=WB52QtiKFD/17i5bL4H9LLCE1ceHoCk1fNfnbl8nCV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SviaEFaUJ+SNJzDY8B7ruRY3VuNj7sMbrEDFsuRjVaufzQ+X6WRs3QoVTWojMf4xs1iPFSLW+YYcJYHz0jDhm8sXa7DAjxj7ClSrJtRCc9GlbND0MAaQll7nBJtU6OZFtcaIfcm3/sa0C4RQjwPAaN9On8QLow0r7LVgqhQK9h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=z20rIDfP; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="z20rIDfP"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d5XJb0yS6zltMW0;
	Tue, 11 Nov 2025 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1762879069; x=1765471070; bh=WB52QtiKFD/17i5bL4H9LLCE
	1ceHoCk1fNfnbl8nCV0=; b=z20rIDfPl5+wTl6Zdtmzyoh0K7/P6N3M21MPGpRB
	Nw9qeUwpi0I7JyxiLz2CCA3PGCsZltHF5ViTWrbXhY4/p6kIP5fYYXnzfxuRKsmf
	tXJ21HUCp2i4HoxyLQ2guC5xu+OPr5a9geDDBGZSnlAKdNG2+Xdf+qcidc9jdAw5
	Irzx/i7G25/sRV9iftbxeVLihx5i5WnRzvIEzvVDv1Ajs9drm1jObXMPktS+Pt8W
	siejfJOrOVmCHT6Qj7VbQI3MMMIBqtfivFDK6qLHo7N/37rUbZPrNQsmf+HqqlT5
	Ka/OzxbV0Rjya87omI5vdK1SC6wttbHEy3ha+voKgaxcqg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z7_AnTf2sIef; Tue, 11 Nov 2025 16:37:49 +0000 (UTC)
Received: from [10.111.50.167] (191.sub-174-194-195.myvzw.com [174.194.195.191])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d5XJ55hhlzltH7F;
	Tue, 11 Nov 2025 16:37:24 +0000 (UTC)
Message-ID: <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
Date: Tue, 11 Nov 2025 08:37:19 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "storage.sec@samsung.com" <storage.sec@samsung.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
 <20251106012654.4094-1-sh043.lee@samsung.com>
 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/11/25 1:03 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> It seems that there is no node in the DTS to describe the
> UFS device. The UFS host node is not suitable, because the
> timeout value depends on the UFS device itself.
>=20
> Since you found that some devices may have TM command
> times exceeding 100ms, why not add a device quirk and change
> the timeout value only for those devices?
>=20
> Alternatively, you could consider using a module parameter,
> similar to uic_cmd_timeout and dev_cmd_timeout.

Why a quirk? A quirk will select a single specific timeout. The approach
of this patch lets the host driver set the timeout. This seems more
flexible to me than introducing a new quirk. Additionally, I think this
is a better solution than a new kernel module parameter.

Thanks,

Bart.
