Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06EA273FD
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 07:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752652185; cv=none; b=UJhbQlJZoielRt39AVwJdvnpo4CF0fLdaLguQ8FOmrHPR9cGhHYSeQoQKIrmQEdgVS315gAFLBDXEO4wi+y9XvQ1J5lSnacGn8SIQFjACrGwiT1h7er/tz18gQiRVvh3yksDVxIpYHFjZND6I8H4B0dDli6GHE3MPI24tsWqRkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752652185; c=relaxed/simple;
	bh=y8D0j6QjLoii9X/3wf3a/hVeooufBszGM8rUeoBsZhc=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=ZEBODwsNmFB+bcGJfc3ZL3n9+Ibo/qhkzr2lqaNbABQroaSaJ3o8m/tgiecJj4vmAc+JYgddoZZporfkMrRxwzKorNVcQbhGorjEZzDyJNCvV837xXYISk9A2VuWkE57Wmrvj4+0fPAyyMrM9Pi0d8iZQw17u5Epd/3xEuEVrwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JDcwS5Jn; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JDcwS5Jn"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250716074934epoutp03d81ccb6bfda02abf9f8e3a985c7b6e80~Sq93k7fjl0987509875epoutp030
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 07:49:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250716074934epoutp03d81ccb6bfda02abf9f8e3a985c7b6e80~Sq93k7fjl0987509875epoutp030
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752652174;
	bh=y8D0j6QjLoii9X/3wf3a/hVeooufBszGM8rUeoBsZhc=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=JDcwS5JnRJ9JIKUMqPGW4+7/Yh3e/3Wzxsn/xAOVvJ5KHKAu9+iwBi/wqVYcm9gIg
	 6jdDGjy97lYqBetarn6YYzQ5fjMvZISzcHcohzuSV6nVIkV5sE8kzyxVke4Ft740Xt
	 viaI21Yv4OtbUjMEbZX238cdB6rGQRKXHA51At5c=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250716074934epcas1p42e996dc713414b00511e29f0f0fdb54c~Sq93K6J8E2825428254epcas1p4z;
	Wed, 16 Jul 2025 07:49:34 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.36.223]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bhp9T5Bfpz2SSKm; Wed, 16 Jul
	2025 07:49:33 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250716074933epcas1p1cf4c5edd70abdce1966762858c2d4e16~Sq92SBkf20523405234epcas1p1K;
	Wed, 16 Jul 2025 07:49:33 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250716074933epsmtip2658b1c7a7316f9a47d43141a26bd6168~Sq92OBx6u0063700637epsmtip2H;
	Wed, 16 Jul 2025 07:49:33 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: "'Bean Huo'" <huobean@gmail.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <sdriver.sec@samsung.com>
In-Reply-To: <005801dbf61f$7287e7d0$5797b770$@samsung.com>
Subject: RE: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Wed, 16 Jul 2025 16:49:32 +0900
Message-ID: <00f301dbf626$2b2a1550$817e3ff0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH3aHPkcZ8xP3B7R0c5EXGU8cAQqgKwpSsnAUiyhkICOzcz6QJIvQEgAeA6CDKzqo6wYA==
Content-Language: ko
X-CMS-MailID: 20250716074933epcas1p1cf4c5edd70abdce1966762858c2d4e16
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	<20250714090617.9212-1-sh043.lee@samsung.com>
	<b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
	<000901dbf52f$63a69090$2af3b1b0$@samsung.com>
	<cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
	<005801dbf61f$7287e7d0$5797b770$@samsung.com>

> -----Original Message-----
> From: Seunghui Lee <sh043.lee=40samsung.com>
> Sent: Wednesday, July 16, 2025 4:01 PM
> To: 'Bean Huo' <huobean=40gmail.com>; alim.akhtar=40samsung.com;
> avri.altman=40wdc.com; bvanassche=40acm.org;
> James.Bottomley=40HansenPartnership.com; martin.petersen=40oracle.com; li=
nux-
> scsi=40vger.kernel.org; sdriver.sec=40samsung.com
> Subject: RE: =5BPATCH=5D ufs: core: Use link recovery when the h8 exit fa=
ilure
> during runtime resume
>=20
> > -----Original Message-----
> > From: Bean Huo <huobean=40gmail.com>
> > Sent: Wednesday, July 16, 2025 12:22 AM
> > To: =EC=9D=B4=EC=8A=B9=ED=9D=AC=20<sh043.lee=40samsung.com>;=20alim.akh=
tar=40samsung.com;=0D=0A>=20>=20avri.altman=40wdc.com;=20bvanassche=40acm.o=
rg;=0D=0A>=20>=20James.Bottomley=40HansenPartnership.com;=20martin.petersen=
=40oracle.com;=0D=0A>=20>=20linux-=20scsi=40vger.kernel.org;=20sdriver.sec=
=40samsung.com=0D=0A>=20>=20Subject:=20Re:=20=5BPATCH=5D=20ufs:=20core:=20U=
se=20link=20recovery=20when=20the=20h8=20exit=0D=0A>=20>=20failure=20during=
=20runtime=20resume=0D=0A>=20>=0D=0A>=20>=0D=0A>=20>=20You=20patched=20ufsh=
cd_runtime_suspend()=20to=20return=20-EBUSY=20if=0D=0A>=20>=20eh_in_progres=
s=20is=20true=20=E2=80=94=20meant=20to=20avoid=20suspend=20during=20error=
=20handling.=0D=0A>=20>=20I=20don't=20understand=20why=20here=20parent=20is=
=20not=20active?=0D=0A>=20=0D=0A>=20After=20checking=20the=20RPM=20devices,=
=20I=20found=20that=20the=20parent=20device=20is=0D=0A>=20suspended=20due=
=20to=20the=20failure=20of=20ufshcd_wl_runtime_resume.=0D=0A>=20Even=20if=
=20we=20guarantee=20both=20the=20completion=20of=20ufshcd_runtime_suspend=
=20and=20the=0D=0A>=20error=20handling=20completion=20to=20avoid=20races,=
=20ufshcd_recover_pm_error=20can't=0D=0A>=20fully=20recover=20from=20a=20ru=
ntime=20pm=20failure=20scenario.=0D=0A>=20=0D=0A>=20>=0D=0A>=20>=20would=20=
like=20to=20try=20return=20-EAGAIN?=0D=0A>=20>=0D=0A>=20>=0D=0A>=20>=20Kind=
=20regards,=0D=0A>=20>=20Bean=0D=0A>=20>=0D=0A>=20=0D=0A>=20I've=20tried=20=
that=20as=20well,=20but=20it=20doesn't=20work=20either.=0D=0A>=20=5B=20=203=
28.915154=5D=20=5B0:=20=20kworker/u32:7:=20=20941=5D=20ufs_device_wlun=200:=
0:0:49488:=0D=0A>=20runtime=20PM=20trying=20to=20activate=20child=20device=
=200:0:0:49488=20but=20parent=0D=0A>=20(target0:0:0)=20is=20not=20active=20=
=5B=20=20328.915156=5D=20=5B0:=20=20kworker/u32:7:=20=20941=5D=0D=0A>=20ufs=
_device_wlun=200:0:0:49488:=20ufshcd_recover_pm_error:=20rpm=20set_active=
=20ret(-=0D=0A>=2016)=20=5B=20=20328.915157=5D=20=5B0:=20=20kworker/u32:7:=
=20=20941=5D=20ufshcd-qcom=201d84000.ufshc:=0D=0A>=20ufshcd_recover_pm_erro=
r:=20rpm=20set_active=20ret(-11)=20Due=20to=20this=20error,=0D=0A>=20pm_req=
uest_resume(q->dev)=20for=20each=20scsi=20device=20can't=20execute.=0D=0A>=
=20This=20causes=20the=20I/O=20stack=20to=20become=20stuck.=0D=0A>=20=0D=0A=
>=20This=20issue=20arises=20from=20the=20race=20condition=20between=20the=
=20runtime=20pm=20worker=0D=0A>=20and=20the=20error=20handler=20worker.=0D=
=0A>=20I=20believe=20it=20would=20be=20safer=20to=20handle=20recovery=20wit=
hin=20the=20runtime=20pm=0D=0A>=20worker=20itself.=0D=0A>=20=0D=0A>=20For=
=20reference,=20ufshcd_link_recovery=20is=20useful=20for=20the=20similar=20=
issue.=0D=0A>=20(resolving=20the=20race=20condition=20between=20the=20runti=
me=20pm=20worker=20and=20the=20SCSI=0D=0A>=20error=20handler=20worker)=20ht=
tps://patchwork.kernel.org/project/linux-=0D=0A>=20scsi/patch/2023092703355=
7.13801-1-peter.wang=40mediatek.com/=0D=0A>=20=0D=0A>=20I'll=20add=20Fixes=
=20tags=20and=20modify=20v2=20as=20requested.=0D=0A>=20=0D=0A>=20Thank=20yo=
u,=0D=0A>=20Seunghui=20Lee.=0D=0A>=20=0D=0A=0D=0AI=20would=20love=20to=20fi=
nd=20the=20previous=20tag,=20but=20it's=20old=20code.=0D=0AAnd=20plus,=20it=
's=20hard=20to=20pick=20one=20commit=20for=20Fixes.=0D=0APlease=20understan=
d=20this.=0D=0A=0D=0AIf=20this=20commit=20is=20okay,=20please=20review=20th=
is=20commit.=0D=0A=0D=0AThank=20you,=0D=0ASeunghui=20Lee.=0D=0A=0D=0A
