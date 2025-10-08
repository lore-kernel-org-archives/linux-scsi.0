Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7D7296BDD
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 05:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759901745; cv=none; b=ohSJT7cApeQzD99FFbD8n/g6/vpHeB5NU0+nUBdmhMl8GWYqXmMwdkadtpccsQRNdmDJofkRVqKP5E/tPX0xnKQFMXJftG6WIoBC5zL1PVw96G+038JIgpIpzmm4yjPfU1JEfRAx9uOUVN+xb2jiZuyoWE9gdnSKu0PXgkBfzHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759901745; c=relaxed/simple;
	bh=7uc0xT9UsHI99+GDI6EgnSy2itreCf2z0lQhv12bRGA=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=c2WJ1jIETUzLjMDIrmzCSnGlle0W8AuAF4bcu+ZpJxZ3r1Tm1ahcyZ0NBgnqRwdYLudCSRw/AetZ3LB1VV9c2w0ZRc92pNRauHxtP+cmwcyjHyqnfEoxV9PKaixiww0HUlLn2dsX9TOzYxFWeDV+psA9FZPonOQ2JTYeWCyjAKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LXkUvFnM; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LXkUvFnM"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20251008053539epoutp02987a974d32b8c3c7585d54923d60a126~sbU7afYbq0652406524epoutp02i
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 05:35:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20251008053539epoutp02987a974d32b8c3c7585d54923d60a126~sbU7afYbq0652406524epoutp02i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759901739;
	bh=7uc0xT9UsHI99+GDI6EgnSy2itreCf2z0lQhv12bRGA=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=LXkUvFnM6gxwF6xCnQY2mIqw6mH4op32HUKsndntILWN11pDL5KtoRAliSYp7DieJ
	 8g+L25csZ6fF5D0niPGoejxu+cooJxCwQKKwG54NvCKKQrunh8U90VlyGy3GRC5bhk
	 MjeeYqpFOhv/fHpv1BKmnO8z4MvAabkm43VK6/n8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251008053539epcas5p1d95fda2e1b05c18f9d6ce3eb7772fb06~sbU68JLuP1634316343epcas5p1q;
	Wed,  8 Oct 2025 05:35:39 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4chMDB1tdFz6B9m4; Wed,  8 Oct
	2025 05:35:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251008053537epcas5p375e37929f025c0d11aa4309e3d62d897~sbU5N0bIj0810108101epcas5p3b;
	Wed,  8 Oct 2025 05:35:37 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251008053535epsmtip1a048821efddcf4d6723bf0bedd4fa5e3~sbU3Ue-he1568815688epsmtip17;
	Wed,  8 Oct 2025 05:35:35 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: =?utf-8?Q?'Andr=C3=A9_Draszik'?= <andre.draszik@linaro.org>, "'Avri
 Altman'" <avri.altman@wdc.com>, "'Bart Van Assche'" <bvanassche@acm.org>,
	"'Rob Herring'" <robh@kernel.org>, "'Krzysztof Kozlowski'"
	<krzk+dt@kernel.org>, "'Conor Dooley'" <conor+dt@kernel.org>
Cc: "'Peter Griffin'" <peter.griffin@linaro.org>, "'Tudor Ambarus'"
	<tudor.ambarus@linaro.org>, "'Will McVicker'" <willmcvicker@google.com>,
	<kernel-team@android.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>
Subject: RE: [PATCH] scsi: ufs: dt-bindings: exynos: add power-domains
Date: Wed, 8 Oct 2025 11:05:34 +0530
Message-ID: <001501dc3815$601ec450$205c4cf0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHS0boKDTdfIj5X2r9DvSTLTl+2HwHj5ytttLtl7FA=
Content-Language: en-us
X-CMS-MailID: 20251008053537epcas5p375e37929f025c0d11aa4309e3d62d897
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251007155631epcas5p2cbf4c7b52bd217128c156bf6f5f1ea82
References: <CGME20251007155631epcas5p2cbf4c7b52bd217128c156bf6f5f1ea82@epcas5p2.samsung.com>
	<20251007-power-domains-scsi-ufs-dt-bindings-exynos-v1-1-1acfa81a887a@linaro.org>



> -----Original Message-----
> From: Andr=C3=A9=20Draszik=20<andre.draszik=40linaro.org>=0D=0A>=20Sent:=
=20Tuesday,=20October=207,=202025=209:26=20PM=0D=0A>=20To:=20Alim=20Akhtar=
=20<alim.akhtar=40samsung.com>;=20Avri=20Altman=0D=0A>=20<avri.altman=40wdc=
.com>;=20Bart=20Van=20Assche=20<bvanassche=40acm.org>;=20Rob=0D=0A>=20Herri=
ng=20<robh=40kernel.org>;=20Krzysztof=20Kozlowski=20<krzk+dt=40kernel.org>;=
=0D=0A>=20Conor=20Dooley=20<conor+dt=40kernel.org>=0D=0A>=20Cc:=20Peter=20G=
riffin=20<peter.griffin=40linaro.org>;=20Tudor=20Ambarus=0D=0A>=20<tudor.am=
barus=40linaro.org>;=20Will=20McVicker=20<willmcvicker=40google.com>;=0D=0A=
>=20kernel-team=40android.com;=20linux-scsi=40vger.kernel.org;=0D=0A>=20dev=
icetree=40vger.kernel.org;=20linux-arm-kernel=40lists.infradead.org;=20linu=
x-=0D=0A>=20samsung-soc=40vger.kernel.org;=20linux-kernel=40vger.kernel.org=
;=20Andr=C3=A9=20Draszik=0D=0A>=20<andre.draszik=40linaro.org>=0D=0A>=20Sub=
ject:=20=5BPATCH=5D=20scsi:=20ufs:=20dt-bindings:=20exynos:=20add=20power-d=
omains=0D=0A>=20=0D=0A>=20The=20UFS=20controller=20can=20be=20part=20of=20a=
=20power=20domain,=20so=20we=20need=20to=20allow=20the=0D=0A>=20relevant=20=
property=20'power-domains'.=0D=0A>=20=0D=0AIn=20Exynos,=20power=20domains=
=20has=20a=20boundary=20at=20_block_=20level.=20I=20assume=20in=20this=0D=
=0Acase=20it=20is=20BLK_HSI,=20which=20contains,=20multiple=20IPs=20within=
=20block,=20including=20UFS=0D=0Acontroller.=20I=20hope=20you=20will=20be=
=20sending=20the=20corresponding=20DTS=20changes=20as=20well.=20=0D=0A=0D=
=0A>=20Signed-off-by:=20Andr=C3=A9=20Draszik=20<andre.draszik=40linaro.org>=
=0D=0A>=20---=0D=0AFeel=20free=20to=20add=20=0D=0AReviewed-by:=20Alim=20Akh=
tar=20<alim.akhtar=40samsung.com>=0D=0A=0D=0A
