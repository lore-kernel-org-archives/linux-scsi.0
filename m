Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B182822F171
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 04:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736915894; cv=none; b=b4tshLoAibj59ucUnTW8A3PrtBkNxZ3YSvtBu8a3WKErCLKglomCmHhsG2mPLqgKwEMAb4wyQZ8zmSbIF2oiS+54u1/aFgC52TulH0eQaRAbQlBvHSH6KNbXp+siL4y1BUy3i0021MmGd1fqHLrEXppovIBVd66tx35X2p906wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736915894; c=relaxed/simple;
	bh=7Wj6Lt9VD86BQX6ErYGAlR/O/oKXvdjHtmq7r63FjJ8=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=tBrkIWn+UJiVvygw4gdO/6CO4TiJAx+vXb9lOePnphq2UoRpT6zacs54lD6xfZvVTw+N1krjeZjIgNtpkv96ynCC9bThEc367o2snyrk78PVO7aME6Khv8kUWt+MIsYrb/LP/itvsIBvtMLqZYL0sCZAutD+0V6SSuDqH8MSzZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jPC8Ixez; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jPC8Ixez"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250115043803epoutp0418f559fa7fa2779ca46e1b9062f3075c~aw8skdFj52714227142epoutp04B
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 04:38:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250115043803epoutp0418f559fa7fa2779ca46e1b9062f3075c~aw8skdFj52714227142epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1736915883;
	bh=fwE2zfHSZsIAIwhO6bCQFceBK8F+GWTHqDXZ1N3Mnig=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=jPC8IxezYjiizX1AwhlVuf9ysG1gH08HUjrc1ZSqGo8CtTOIFiBTQG4EyeZoPJwBC
	 rMOEn8WJURx8RC/u2BqGMs4IgIxN7lzVXj7WY/SaowhRskBpoxhX2DSgZ2UnoECitd
	 0R4iAnkp40y7LLKCtOmTqhLjlNqjTcySR8sRXyGU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250115043802epcas5p4cee7f8802fdc0802f9f709038cbb9fd2~aw8r0r4RK0138701387epcas5p4S;
	Wed, 15 Jan 2025 04:38:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4YXtXV4XKBz4x9Pr; Wed, 15 Jan
	2025 04:38:02 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250115040249epcas5p3e3dc20b887ccadc31f7698e953e63ee7~awd7ulJjA2943529435epcas5p3K;
	Wed, 15 Jan 2025 04:02:49 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250115040249epsmtrp10e02996ddc8c9e2379a39a56ae2a133f~awd7txdeA2418724187epsmtrp1C;
	Wed, 15 Jan 2025 04:02:49 +0000 (GMT)
X-AuditID: b6c32a2a-38bf570000004a05-56-67873369a270
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	22.2A.18949.96337876; Wed, 15 Jan 2025 13:02:49 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250115040247epsmtip2b2a8e54942f3c2e6b1e7083ee838b2ee~awd5xwhX43010430104epsmtip2k;
	Wed, 15 Jan 2025 04:02:47 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>, "'Avri
	Altman'" <avri.altman@wdc.com>, "'Bart Van Assche'" <bvanassche@acm.org>,
	"'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>, "'Martin
 K. Petersen'" <martin.petersen@oracle.com>, "'Peter Wang'"
	<peter.wang@mediatek.com>, "'Stanley	Jhu'" <chu.stanley@gmail.com>,
	"'Matthias Brugger'" <matthias.bgg@gmail.com>, "'AngeloGioacchino Del
	Regno'" <angelogioacchino.delregno@collabora.com>,
 <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mediatek@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Cc: <cpgs@samsung.com>
In-Reply-To: <20250114200716.969457-1-krzysztof.kozlowski@linaro.org>
Subject: RE: [PATCH] ufs: Use str_enable_disable-like helpers
Date: Wed, 15 Jan 2025 09:32:46 +0530
Message-ID: <1891546521.01736915882616.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKOlDQiw1aDG1OI85tvS2g7EBI6nAKoU7y+sZuZQrA=
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWy7bCSvG6mcXu6wY+fYhaXVkpYvPx5lc1i
	2oefzBZfLu5ntnh5SNNiYz+Hxd7XW9ktNj2+xmpxedccNovLzRcZLbqv72CzWH78H5NFU4ux
	xdZPv1kd+DwuX/H22HF3CaPHzll32T2mTTrF5nHn2h42j81L6j1aTu5n8fj49BaLR9+WVYwe
	nzfJebQf6GYK4I7isklJzcksSy3St0vgymid389a0CNQ0bP7AlsD4zHeLkZODgkBE4m+2U+Z
	uhi5OIQEdjNKfFrUzAKRkJa4vnECO4QtLLHy33N2iKLnjBKH93UzgSTYBHQldixuYwNJiAh8
	YZG4/eQSG0iCWUBM4uezI6wQHdMYJRpXLAUbxSngKvFn0nZGEFtYwFbi365tYOtYBFQlLsz9
	xgpi8wpYSqx/+JARwhaUODnzCVANB9BQPYm2jYwQ8+Ultr+dwwxxnYLEz6fLwFpFBKwkJhy+
	zAxRIy7x8ugR9gmMwrOQTJqFMGkWkkmzkHQsYGRZxSiZWlCcm55bbFhglJdarlecmFtcmpeu
	l5yfu4kRHMVaWjsY96z6oHeIkYmD8RCjBAezkgjvErbWdCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK83173pggJpCeWpGanphakFsFkmTg4pRqYVtwxYwt56FETlGTEnes0N3NuQFrBeUtWpSav
	kxcvCz3mqdS62L/l51anYwHi2+yemDd0uZ86NT+9ZGLi15n36sz5b3UoZosH8Pqvc5nfqv71
	3wWpktIJE218lveVp4uWa/jqiEz4oXnP8LHXGpFXSx7kuJ/Kdzj4etP81/O2z1q0/We6YkHl
	X9XO2Xfc2eYHxGtt9mHY4ljvsTN0MYthjvWyF+IeM7btWrF6RpEax+W7lb4LZnoktTgvX7pp
	yuJZ978FXbXxqWRLCgjryJsapR7++yDz9n9C5688ufnXhL19b/nBGWZXFR9M0bsmeSdxysrz
	ZV5TG34+8t6ctO7sg6Ob39wOqHbPvsO5YUFgnxJLcUaioRZzUXEiAMZ7jD5RAwAA
X-CMS-MailID: 20250115040249epcas5p3e3dc20b887ccadc31f7698e953e63ee7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250114200726epcas5p4dc896686dd6cdcc449344dbef87af21d
References: <CGME20250114200726epcas5p4dc896686dd6cdcc449344dbef87af21d@epcas5p4.samsung.com>
	<20250114200716.969457-1-krzysztof.kozlowski@linaro.org>

Hello Krzysztof,

> -----Original Message-----
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Sent: Wednesday, January 15, 2025 1:37 AM
> To: Alim Akhtar <alim.akhtar@samsung.com>; Avri Altman
> <avri.altman@wdc.com>; Bart Van Assche <bvanassche@acm.org>; James
> E.J. Bottomley <James.Bottomley@HansenPartnership.com>; Martin K.
> Petersen <martin.petersen@oracle.com>; Peter Wang
> <peter.wang@mediatek.com>; Stanley Jhu <chu.stanley@gmail.com>;
> Matthias Brugger <matthias.bgg@gmail.com>; AngeloGioacchino Del Regno
> <angelogioacchino.delregno@collabora.com>; linux-scsi@vger.kernel.org;
> linux-kernel@vger.kernel.org; linux-mediatek@lists.infradead.org; linux-
> arm-kernel@lists.infradead.org
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Subject: [PATCH] ufs: Use str_enable_disable-like helpers
> 
> Replace ternary (condition ? "enable" : "disable") syntax with helpers
from
> string_choices.h because:
> 1. Simple function call with one argument is easier to read.  Ternary
>    operator has three arguments and with wrapping might lead to quite
>    long code.
> 2. Is slightly shorter thus also easier to read.
> 3. It brings uniformity in the text - same string.
> 4. Allows deduping by the linker, which results in a smaller binary
>    file.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  drivers/ufs/core/ufshcd.c       | 11 ++++++-----
>  drivers/ufs/host/ufs-mediatek.c |  7 +++----
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

On a side note, there are other host controller driver (e.g. exynos and
Qcomm) which also uses few conditional operators, But I didn't find a
matching helper in string_choices.h, so may be that can be taken separately
in future.


> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 27154a5dcb7b..5225d48a47f8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
[Snip]
> --
> 2.43.0



