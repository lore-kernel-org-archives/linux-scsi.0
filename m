Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891AB314D0A;
	Mon,  5 Jan 2026 10:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767609679; cv=none; b=RI9Zg5V0g0IcpsAjtlGKiJwMCawMwPyWEB7Nt0PrHct6GDKjoswMFDxd01rbsivq3bha37mmSUcgVMADSm/cTLU8DhxU84fgqP4XJZ4B5lpTtM1ONL5KxBgopfScCVFXvoXxo+edB9GKcT9c+aLZnIJoEybuasK0wMCfZZEgEyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767609679; c=relaxed/simple;
	bh=SexiQIV12VR2enzoPuVCxJ9Tsc7jBAJdPojoDcxGVxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GGKisL758l8f9cR5Eu9KdSj77N6+10/e4yT6Eb7X4BL+f9kGTA4M8aLGpXIlzMJrRl6S4yU1b6zVctM0PoJHApLtf3PG9ndlR1Rp3B1fR3d0oraYlNOhe/pq1CScJE1Mc1Pzhd+72JUYlHqqwxCrMikE1LBQijdi2V/xdJsJFH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=f2BPmy4C; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="f2BPmy4C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1767609666; x=1768214466; i=markus.elfring@web.de;
	bh=SexiQIV12VR2enzoPuVCxJ9Tsc7jBAJdPojoDcxGVxU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=f2BPmy4Cdhc0B4o8PI3+lKrgKhLW9zrSSx/cW2WTSYYdxRePSElwqQ7T9DRdPe75
	 VoQgazlf5tIASimxCdCzpp0HzUhJ0vtZkkgS9Nw17q9WyxgDOe1M/mhCZTWc5akd4
	 S9+V73BVHU41IZkGEh5nVZl8MyKeFTeLHr3vYCzkPlGeIVACN2OTWW7YpNeefkf0C
	 Q4z762Uhb3Gspkt70qcW8wdi8HmP11vcRe9U9b8VnOaBQYeXbVoE2ztpDGBPqCOHI
	 NVoc5raAKkZHa6zPBUZssVvIdVoDMPy9cteKnbvMd1NFurZDB7MABIps/lDWkJrlX
	 27MG41GMADfZOO4HOA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.232]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1My6lX-1vnu3R0Pxn-0113Cu; Mon, 05
 Jan 2026 11:41:06 +0100
Message-ID: <ce145c7f-33fc-47a7-bcbf-2ec62719047a@web.de>
Date: Mon, 5 Jan 2026 11:41:03 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Jianhao Xu <jianhao.xu@seu.edu.cn>, Zilin Guan <zilin@seu.edu.cn>,
 linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Justin Tee <justin.tee@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Paul Ely <paul.ely@broadcom.com>
References: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
 <20251230062008.1021449-1-zilin@seu.edu.cn>
 <aVuKJPNjNyt3_yEV@stanley.mountain> <aVuP0lJxn2pc6cNa@stanley.mountain>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aVuP0lJxn2pc6cNa@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:MfoMZIk4iImB5b+5yoxQRZuDNX+/43/hn3ohCayoseHbZ9V44v6
 4QfbMI4pvnQaY4j+TfsfNOU9Q2vgFi2gYoQTzTZi2OUcai/ivH8mSlJwhvx7pANfD0WuQAA
 25BeLwajVk4U1dC19yvH+UsStUSWGNdRF8YOvFqUvAQEvT3NJ5sCqkdTfuZSa9HCPub7GZm
 bA16TwQcsmKlKDmtRAkyQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZB0hQM6j0Ak=;aaKMd5zNSBuII3zlA7PV46Unt0I
 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
 QDsXsKdgwzsY2KW9NhRYalMfj32rqHgxyLHsfR

> I meant "or at least stop complaining about style and grammar issues".

Do any other contributors occasionally get also into the mood to point similar
adjustment opportunities out?

Regards,
Markus
