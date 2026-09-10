Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0635B47D468;
	Thu, 10 Sep 2026 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045792; cv=none; b=GjvaqRQAJasAXnajOys1G1wQO3ozjrBMiTp7s0CdW6WfV16YsppQESG3+u2g6Z18Xa2OGUQGZ7ouxJzY/rMP9Ba6M/XsKVggG3xgltUxdfq2YJBOY235OpuvLZEirbJynH39Vy8yDcsyOlxKtGpdvT8rdr2jLDS6oyWURd6ijtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045792; c=relaxed/simple;
	bh=uYEll0xRGJQKEXkXknOttnZJWYJjiAm9OIEVvnRtTQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYEURAR9SUlu43Lh418ztCK/pnhz4g06QA25gyXPFOFiMvRSLkTYMlnKQAHdqyxL+1ahb3vIsOX4raQKciKE7bW9nNE46PqJMrYgIOylwfKFXOKID1u1zzlqMUBF0yJZQh0InKCceOIxwNeYlDopn0W6xYydifCd9xlu+OAR5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sFFX+OCa; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sFFX+OCa"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hgdLc4Y5Yz1XM6JP;
	Thu, 10 Sep 2026 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789045777; x=1791637778; bh=uYEll0xRGJQKEXkXknOttnZJ
	WYJjiAm9OIEVvnRtTQI=; b=sFFX+OCa1UnWOA0pAOXqKCBomup2w1N5Imnnq6i4
	Aav+XQ1NVrE7XRYnUtT+Gz2H0WdyNlY4+O5nBRMIMgEdT89yrSwDjhbtoXDfK2QT
	ZIegW4QU3HavifFZhQazC4Uxa/KmxGRYqIt84T3ZZUG6yg5YYyoT9/OIyplHEvH/
	RnJ9sGIRVuIVH3tLiXU61Sa6nQ5CZCpymNO7uyzeD2US0s1YE9FdJXInIweTkyO+
	rtEtEHxXtwD+mJlrBeRmQjBV3hr0mIkOJ1MdB8/hX0nWHn3EkI+f7QaNDJHrO4o1
	ZDpFMI5FfE9uYPsF29Ce1UXJLHYFDnG3KdfvCtyb47IbfQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2rNR6jfMuhwf; Thu, 10 Sep 2026 13:09:37 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hgdLM5xC2z1XM4Sx;
	Thu, 10 Sep 2026 13:09:31 +0000 (UTC)
Message-ID: <63f41284-a9ca-4d0e-ba34-096712f27b59@acm.org>
Date: Thu, 10 Sep 2026 06:09:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Cc: Kartik Rajput <kkartik@nvidia.com>, Alim Akhtar
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Thierry Reding <thierry.reding@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Philipp Zabel
 <p.zabel@pengutronix.de>, Thierry Reding <treding@nvidia.com>,
 linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
 <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
 <aqFqhNA50674GtPo@monoceros> <45a04396-c6c1-41f4-ace8-0ee0ccbc50ad@acm.org>
 <aqKOipmg5V4oqZlB@monoceros>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aqKOipmg5V4oqZlB@monoceros>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/10/26 4:21 AM, Uwe Kleine-K=C3=B6nig wrote:
> What makes you claim that {} is preferred?

There are many more occurrences of " =3D {};" (about 7000) in the Linux
kernel than of " =3D { };" (about 1500). Additionally, clang-format
changes any occurrence of " =3D { };" into " =3D {};".

Thanks,

Bart.
