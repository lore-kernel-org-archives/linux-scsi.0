Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C76F348866
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 09:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777024351; cv=none; b=khzOKXfL+yfwuu5PcIC6/gHe8r6So8VrM7/y5D1Icqu93woeMjrHKaBrqKmW+vih5sLrhe/QHK2Fv3tJHuB5bydK05GcHfUAR+KnmA349g6P95tI8yq3GlPIAaxZuhTWNBfgM2P9C8QgIF4pymEkOHK1uG8oC0mVJgsDUDslUF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777024351; c=relaxed/simple;
	bh=7+nwNe0hubPEq2tWT6cJD5lGdELFJsocZFhWYUVObOo=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=lmiCnLm5wy1UsXdYxUgb5l8ME4+Zfl94cgRyjBM6BNiXhNfQnWFpMJP4Fyet6qZgyqp9Fkbg02bQJIiMa6i8fr2KPsYWbdXbKIeUXTr7xqOMdeDbPNNLynoi05H4GGx5R7oykr6s9F+xHgCnVIdFDS4IuRp16MIDNu8z5EIExOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RxWygvqZ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RxWygvqZ"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260424095218epoutp02aae5bb22a6448ac2ca7760d5bb218aa7~pQjh9uTK70701507015epoutp02e
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 09:52:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260424095218epoutp02aae5bb22a6448ac2ca7760d5bb218aa7~pQjh9uTK70701507015epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1777024338;
	bh=7+nwNe0hubPEq2tWT6cJD5lGdELFJsocZFhWYUVObOo=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=RxWygvqZ91MbmEivtdDYymY/GcSy4zP1uQl7oJMHSd+cKKFiu1TvCJ4AmR7peNSV0
	 +6P+YnnwzXy0N8XbjgB92Poe7piO+x9JLm9Dm3FbqF0kXJ57w/uwkKaVP/CLmXHwUF
	 SSp5oUZDfxvFSvXtu/XOYcP0rqXM+xUBpHmXvuSA=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260424095217epcas5p2f0cf8cb26a0976167a98fbf6b8dcf11a~pQjhTUF821838618386epcas5p2B;
	Fri, 24 Apr 2026 09:52:17 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4g27Xw28BCz6B9m7; Fri, 24 Apr
	2026 09:52:16 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260424095215epcas5p291a4e6a42b1390cb9c21560e5c22ef57~pQjfotDis1732717327epcas5p2I;
	Fri, 24 Apr 2026 09:52:15 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20260424095213epsmtip25c4683e24d4e19f2bbdcfac925c538d6~pQjdrfLIu1913119131epsmtip2Y;
	Fri, 24 Apr 2026 09:52:13 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Krzysztof Kozlowski'" <krzk@kernel.org>, <avri.altman@wdc.com>,
	<bvanassche@acm.org>, <robh@kernel.org>, <martin.petersen@oracle.com>,
	<krzk+dt@kernel.org>
Cc: <sowon.na@samsung.com>, <peter.griffin@linaro.org>,
	<linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	"'Krzysztof	Kozlowski'" <krzysztof.kozlowski@linaro.org>
In-Reply-To: <f1a829c6-a612-4334-b6fc-993c51cc90de@kernel.org>
Subject: RE: [PATCH v2 2/4] dt-bindings: ufs: exynos: add ExynosAutov920
 compatible string
Date: Fri, 24 Apr 2026 15:22:12 +0530
Message-ID: <31a201dcd3d0$08164dd0$1842e970$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGOvTbkBrgGLxEZFB5FxnehV1lv0gFmXzAQAmEqbtkC/V4hngLthV3ktjyR8kA=
Content-Language: en-us
X-CMS-MailID: 20260424095215epcas5p291a4e6a42b1390cb9c21560e5c22ef57
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-543,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417115842epcas5p1fb06d6f1663b97b1eae3aafaa6a3de0b
References: <20260417121452.827054-1-alim.akhtar@samsung.com>
	<CGME20260417115842epcas5p1fb06d6f1663b97b1eae3aafaa6a3de0b@epcas5p1.samsung.com>
	<20260417121452.827054-3-alim.akhtar@samsung.com>
	<27b401dcce62$03bd3280$0b379780$@samsung.com>
	<f1a829c6-a612-4334-b6fc-993c51cc90de@kernel.org>



> -----Original Message-----
> From: Krzysztof Kozlowski <krzk=40kernel.org>
> Sent: Friday, April 17, 2026 6:25 PM
> To: Alim Akhtar <alim.akhtar=40samsung.com>; avri.altman=40wdc.com;
> bvanassche=40acm.org; robh=40kernel.org; martin.petersen=40oracle.com;
> krzk+dt=40kernel.org
> Cc: sowon.na=40samsung.com; peter.griffin=40linaro.org; linux-
> scsi=40vger.kernel.org; devicetree=40vger.kernel.org; linux-samsung-
> soc=40vger.kernel.org; linux-kernel=40vger.kernel.org; 'Krzysztof Kozlows=
ki'
> <krzysztof.kozlowski=40linaro.org>
> Subject: Re: =5BPATCH v2 2/4=5D dt-bindings: ufs: exynos: add ExynosAutov=
920
> compatible string
>=20
> On 17/04/2026 14:02, Alim Akhtar wrote:
> >
> >
> >> -----Original Message-----
> >> From: Alim Akhtar <alim.akhtar=40samsung.com>
> >> Sent: Friday, April 17, 2026 5:45 PM
> >> To: avri.altman=40wdc.com; bvanassche=40acm.org; robh=40kernel.org;
> >> martin.petersen=40oracle.com; krzk+dt=40kernel.org
> >> Cc: sowon.na=40samsung.com; peter.griffin=40linaro.org; linux-
> >> scsi=40vger.kernel.org; devicetree=40vger.kernel.org; linux-samsung-
> >> soc=40vger.kernel.org; linux-kernel=40vger.kernel.org; Krzysztof
> >> Kozlowski <krzysztof.kozlowski=40linaro.org>; Alim Akhtar
> >> <alim.akhtar=40samsung.com>
> >> Subject: =5BPATCH v2 2/4=5D dt-bindings: ufs: exynos: add ExynosAutov9=
20
> >> compatible string
> >>
> >> From: Sowon Na <sowon.na=40samsung.com>
> >>
> >> Add samsung,exynosautov920-ufs compatible for ExynosAutov920 SoC.
> >>
> >> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski=40linaro.org>
> > Just noticed that this email is no longer valid, In case there is a re-=
spin, will
> correct this.
> > Sorry for the noise.
>=20
> The ack can stay wild email, it's fine. It still gives the credit to prev=
ious
> employer.
>=20
Thanks Krzysztof for clarification.=20

> Best regards,
> Krzysztof

