Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A1D383C64
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 12:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776427333; cv=none; b=OE7nXjsdH0+7gjieEJMNEkLMdvAIVzRK1Z5tX+VcvEgQn7Yqq7HUu01UeDH/QWbMbsdBMPSsQGO6D0DtLYH6hPB85akGhkM/ckAC2ZBsEm1uMSgPkjCu7mWaGs5KuBvcAwj1KgZzUjx+oJ0bofugf/00seUHjg4oCOM6/w0ZQQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776427333; c=relaxed/simple;
	bh=t6eZXyHNiWJlMPxM72NMbuvVY0gQaMo5L301Abw+9Es=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=m0Z38RdeboSxTnwBDBcknl6WEx7MgSEeG9HBgUFFL/h2yCGg/ri5Oapr77TpoOR/2lMeYzMKXu4TzFfTmHEmwtEqP1eE+zyCrnP5tSI0VmhPXnrU3BLsHzQ2m+S26FFJsq4LXoaMVCj8zjIjMB54iG9hEb6CFXzz9nhF7QeXf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uXtjwSbA; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uXtjwSbA"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260417120210epoutp03b77b3ffe2907d046a81f7b23633bce92~nIz6r5ilx0955509555epoutp03n
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 12:02:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260417120210epoutp03b77b3ffe2907d046a81f7b23633bce92~nIz6r5ilx0955509555epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1776427330;
	bh=t6eZXyHNiWJlMPxM72NMbuvVY0gQaMo5L301Abw+9Es=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=uXtjwSbAib6XoQjCQgQ78lt0aB8YO/+qZUvT8NpBjbGzzITK0/wjiGlxZZM6h4k8f
	 hgaDFhZeL/JCOl3qI5vgaAXs8WDSQ5PPoHRY9GubM3fZNSuhoKpt34QlODyrUrAULe
	 M4kdQBw3Ijdwl2+YXJeA46IjTDhcOs7YZ21iab7M=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260417120209epcas5p2c7b7b1351fa2fb6592e924044fe204da~nIz6QPy7D1732117321epcas5p2A;
	Fri, 17 Apr 2026 12:02:09 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fxtm04wSkz3hhT3; Fri, 17 Apr
	2026 12:02:08 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260417120208epcas5p1c0a1fdff70a9d0b153c785d4e9ad40ad~nIz43G8ib2498824988epcas5p1W;
	Fri, 17 Apr 2026 12:02:08 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20260417120205epsmtip25f2452928dcab35412aea6c8c3ff68fc~nIz2vLA7w0953009530epsmtip2i;
	Fri, 17 Apr 2026 12:02:05 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: <avri.altman@wdc.com>, <bvanassche@acm.org>, <robh@kernel.org>,
	<martin.petersen@oracle.com>, <krzk+dt@kernel.org>
Cc: <sowon.na@samsung.com>, <peter.griffin@linaro.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"'Krzysztof	Kozlowski'" <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20260417121452.827054-3-alim.akhtar@samsung.com>
Subject: RE: [PATCH v2 2/4] dt-bindings: ufs: exynos: add ExynosAutov920
 compatible string
Date: Fri, 17 Apr 2026 17:32:03 +0530
Message-ID: <27b401dcce62$03bd3280$0b379780$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGOvTbkBrgGLxEZFB5FxnehV1lv0gFmXzAQAmEqbtm2YQzccA==
Content-Language: en-us
X-CMS-MailID: 20260417120208epcas5p1c0a1fdff70a9d0b153c785d4e9ad40ad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-543,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417115842epcas5p1fb06d6f1663b97b1eae3aafaa6a3de0b
References: <20260417121452.827054-1-alim.akhtar@samsung.com>
	<CGME20260417115842epcas5p1fb06d6f1663b97b1eae3aafaa6a3de0b@epcas5p1.samsung.com>
	<20260417121452.827054-3-alim.akhtar@samsung.com>



> -----Original Message-----
> From: Alim Akhtar <alim.akhtar=40samsung.com>
> Sent: Friday, April 17, 2026 5:45 PM
> To: avri.altman=40wdc.com; bvanassche=40acm.org; robh=40kernel.org;
> martin.petersen=40oracle.com; krzk+dt=40kernel.org
> Cc: sowon.na=40samsung.com; peter.griffin=40linaro.org; linux-
> scsi=40vger.kernel.org; devicetree=40vger.kernel.org; linux-samsung-
> soc=40vger.kernel.org; linux-kernel=40vger.kernel.org; Krzysztof Kozlowsk=
i
> <krzysztof.kozlowski=40linaro.org>; Alim Akhtar <alim.akhtar=40samsung.co=
m>
> Subject: =5BPATCH v2 2/4=5D dt-bindings: ufs: exynos: add ExynosAutov920
> compatible string
>=20
> From: Sowon Na <sowon.na=40samsung.com>
>=20
> Add samsung,exynosautov920-ufs compatible for ExynosAutov920 SoC.
>=20
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski=40linaro.org>
Just noticed that this email is no longer valid, In case there is a re-spin=
, will correct this.
Sorry for the noise.=20

