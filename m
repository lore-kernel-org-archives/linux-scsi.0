Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32C42FDC5E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 08:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937411; cv=none; b=gU9qEJiztUODjAWFmj4h1kqvhu73NV6c6KvkxFr0oZqLTkvxY0qzPGeZkJjI3Kjlu8JFpNKrjSSLy1fKj7N1gVqyXiAkto1bOZXdVmAn6DjaJi7pZJLIHSmmPqnzihc4EQ0JSYd5pT6OTDrThdH4lmyFIiQzSgBloHuwSC2WZYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937411; c=relaxed/simple;
	bh=4acyidLPLtSMWFCpqkHsxXW/yHTGc5VoUrzYk1+PpNo=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=DdTJUF5Ii5MZodwmnLXK3tBvlNhhx52CVXISxA2kipCW+XBUYuzr8GHhm1sDcd8C4z2i/vROZBTw+CX805FoYACiMEsh7KZUwsjDl/pzEEpvg/6Lcxd9obs6w1MWoBbV+JDOozHcnHXvwc65Hon1wX4e8/n+PSeASqX09s+KXJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=m2k+9Yz3; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="m2k+9Yz3"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251112085001epoutp03e22af3138c69f5acc6afc47533959722~3Njnnhj4Z2445724457epoutp03H
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 08:50:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251112085001epoutp03e22af3138c69f5acc6afc47533959722~3Njnnhj4Z2445724457epoutp03H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1762937401;
	bh=4acyidLPLtSMWFCpqkHsxXW/yHTGc5VoUrzYk1+PpNo=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=m2k+9Yz3lbYw+U2kxlt+9Qc9gCHEBXqwhdf/aVA379K9krG8p8NIjmvGXen7fOHjm
	 O7ck0CLpkqDFeHHCQ554twABPc7/PNrbmYU6NNs6+8u8SgnGLGWvMi3QZONIQnffAH
	 dKtmV+hUGwgBdJVbY61dJh5Hh5g2ieetH5YfqUeo=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20251112085000epcas1p24d581f895d84959542ea3f43ad79baa9~3NjnDgBBG1115411154epcas1p2u;
	Wed, 12 Nov 2025 08:50:00 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.193]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4d5xtJ4Vc1z3hhT7; Wed, 12 Nov
	2025 08:50:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20251112084959epcas1p1242f2dcd9ac206fe363f4b4c0313a7be~3NjmI9W272104521045epcas1p1n;
	Wed, 12 Nov 2025 08:49:59 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20251112084959epsmtip2e4ae3397c1f9470a0ec5be15a3af1082~3NjmEJwAF2336523365epsmtip2Q;
	Wed, 12 Nov 2025 08:49:59 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: =?utf-8?Q?'Peter_Wang_=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29'?=
	<peter.wang@mediatek.com>, <beanhuo@micron.com>, <avri.altman@wdc.com>,
	<storage.sec@samsung.com>, <linux-scsi@vger.kernel.org>,
	<bvanassche@acm.org>, <linux-kernel@vger.kernel.org>,
	<alim.akhtar@samsung.com>, <adrian.hunter@intel.com>,
	<martin.petersen@oracle.com>
In-Reply-To: <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
Subject: RE: [PATCH] UFS: Make TM command timeout configurable from host
 side
Date: Wed, 12 Nov 2025 17:49:59 +0900
Message-ID: <000001dc53b1$540988a0$fc1c99e0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKPfZmbwG70PGLKm/pFTS39UPXmNQJO/jelAdbalYUBDqcQiAEtGsS3ASfXEoMCIZ0ypbM7CPAw
Content-Language: ko
X-CMS-MailID: 20251112084959epcas1p1242f2dcd9ac206fe363f4b4c0313a7be
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
	<20251106012654.4094-1-sh043.lee@samsung.com>
	<e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
	<009401dc52e7$5d042cf0$170c86d0$@samsung.com>
	<f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
	<be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
	<8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>

> -----Original Message-----
> From: Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B)=20<peter.wang=40mediatek.c=
om>=0D=0A>=20Sent:=20Wednesday,=20November=2012,=202025=2011:58=20AM=0D=0A>=
=20To:=20beanhuo=40micron.com;=20sh043.lee=40samsung.com;=20avri.altman=40w=
dc.com;=0D=0A>=20storage.sec=40samsung.com;=20linux-scsi=40vger.kernel.org;=
=20bvanassche=40acm.org;=0D=0A>=20linux-kernel=40vger.kernel.org;=20alim.ak=
htar=40samsung.com;=0D=0A>=20adrian.hunter=40intel.com;=20martin.petersen=
=40oracle.com=0D=0A>=20Subject:=20Re:=20=5BPATCH=5D=20UFS:=20Make=20TM=20co=
mmand=20timeout=20configurable=20from=20host=0D=0A>=20side=0D=0A>=20=0D=0A>=
=20On=20Tue,=202025-11-11=20at=2008:37=20-0800,=20Bart=20Van=20Assche=20wro=
te:=0D=0A>=20>=0D=0A>=20>=20Why=20a=20quirk?=20A=20quirk=20will=20select=20=
a=20single=20specific=20timeout.=20The=0D=0A>=20>=20approach=20of=20this=20=
patch=20lets=20the=20host=20driver=20set=20the=20timeout.=20This=0D=0A>=20>=
=20seems=20more=20flexible=20to=20me=20than=20introducing=20a=20new=20quirk=
.=20Additionally,=0D=0A>=20>=20I=20think=20this=20is=20a=20better=20solutio=
n=20than=20a=20new=20kernel=20module=20parameter.=0D=0A>=20>=0D=0A>=20>=20T=
hanks,=0D=0A>=20>=0D=0A>=20>=20Bart.=0D=0A>=20=0D=0A>=20Hi=20Bart,=0D=0A>=
=20=0D=0A>=20It=20is=20not=20reasonable=20because=20the=20timeout=20value=
=20does=20not=20depend=20on=20the=20host,=0D=0A>=20it=20depends=20on=20the=
=20device.=20It=20could=20set=20a=20large=20timoeut=20value=20for=20those=
=0D=0A>=20devices.=0D=0A>=20=0D=0A>=20By=20the=20way,=20this=20patch=20also=
=20doesn't=20change=20any=20host=20timeout=20value=20if=20you=0D=0A>=20insi=
st=20that=20the=20timeout=20value=20depends=20on=20the=20host.=0D=0A>=20=0D=
=0A>=20Using=20a=20module=20parameter=20is=20a=20flexible=20method=20if=20t=
he=20customer=20is=20using=20a=0D=0A>=20device=20that=20may=20require=20an=
=20extended=20timeout=20value.=0D=0A>=20Moreover,=20this=20approach=20would=
=20help=20maintain=20consistency.=0D=0A>=20Otherwise,=20with=20so=20many=20=
different=20timeouts=20(uic/dev/tm),=20it=20would=20be=20quite=0D=0A>=20cha=
otic=20if=20each=20is=20handled=20in=20a=20different=20way.=0D=0A>=20=0D=0A=
>=20Thanks=0D=0A>=20Peter=0D=0A=0D=0AHi=20Peter,=0D=0A=0D=0ACurrently,=20th=
e=20modification=20is=20about=20changing=20it=20in=20the=20same=20way=20as=
=20nop_out_timeout.=0D=0AThe=20tm_cmd_timeout=20value=20is=20not=20read=20f=
rom=20the=20device.=0D=0AAlso,=20if=20the=20UFS=20can=20read=20the=20tm_cmd=
_timeout=20value=20and=20requires=20a=20longer=20timeout=20period=20than=20=
the=20specified=20value,=20dev=20quirks=20would=20also=20be=20acceptable.=
=0D=0A=0D=0AHowever,=20for=20now,=20it=20seems=20fine=20to=20set=20it=20on=
=20the=20host.=0D=0AWhen=20we=20checked=20on=20our=20side,=20it=20wasn't=20=
that=20the=20tm=20timeout=20value=20was=20insufficient=20for=20specific=20d=
evices,=20but=20rather=20some=20vendors=20needed=20to=20increase=20it.=0D=
=0AWe=20plan=20to=20appropriately=20increase=20and=20use=20it.=20Also,=20si=
nce=20the=20current=20modification=20maintains=20the=20default=20value=20an=
d=20allows=20an=20appropriate=20value=20to=20be=20adjusted=20according=20to=
=20each=20vendor,=20the=20current=20method=20also=20seems=20acceptable.=0D=
=0A=0D=0AThank=20you,=0D=0ASeunghui=20Lee.=0D=0A=0D=0A=0D=0A
