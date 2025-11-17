Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08FC3164AB
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 07:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763363491; cv=none; b=DBMyXVq+MZvMbsDtHh7UwfR0y/KWx6XQrEMF5OIj1MdOa9k+ZH6vekevYlTkq7/gXoUxFuy2H2QBVgt0FZ/P5yIjqmX+d/rPvtC5UEvCSw3+wYPckgV7UqxuGsE+nY1qruNhZim5FwIEfbCUXYlVp1TkfqUJuaTU/D+POQ+EsAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763363491; c=relaxed/simple;
	bh=JrPHp6Zu/fejD33P8gxlJtlCpk9AThhgTcZA4duKV3I=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=B0PMGIIdXrZs6mCj7/p1q+fnpSklZ45UDhZBvFbqPcbCW/pjduEkZjYoIBkMWMwgvw3QJyVtFiQ0U6jCx/FMDq8H0vlzVutpCEGp6wkar4nwDjuH744GYckYMVxARZ1q8SqDJQQ+cys4xa5k35ep2g6Sk5HJ9iBwXDZm4qFq8BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ome1EB0S; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ome1EB0S"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251117071120epoutp01d8b00c4c8b87044da94f040c27d8d468~4ub5BNrGm2351923519epoutp01j
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 07:11:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251117071120epoutp01d8b00c4c8b87044da94f040c27d8d468~4ub5BNrGm2351923519epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763363480;
	bh=JrPHp6Zu/fejD33P8gxlJtlCpk9AThhgTcZA4duKV3I=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=ome1EB0SBroFyi7M7Jp95IyWCcsdkYjelo70f9UCW/IJc4f/QQcHJSAaWV2XdWIdm
	 s3bzeDbcGSEhtoqYThuQyKeTtbHAsN3P458+m+g7ASzCwyafU0JRiwF6TrX0/+F5MQ
	 N+sFGrjQ8Euc1zjLMkxBZo0dzqXGfTDVDHl+VbbE=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20251117071120epcas1p39720e04641227bd6c6a9c4f8d4d0257d~4ub4QhhaV0548105481epcas1p3E;
	Mon, 17 Nov 2025 07:11:20 +0000 (GMT)
Received: from epcas1p2.samsung.com (unknown [182.195.38.118]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4d8zS76D8Wz6B9m6; Mon, 17 Nov
	2025 07:11:19 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20251117071119epcas1p4b08367b4877f66ef407efde5ef2c94b1~4ub3kcc6I1500915009epcas1p4f;
	Mon, 17 Nov 2025 07:11:19 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20251117071119epsmtip200192c51334cf8a9eb10ca9cb3a6e43b~4ub3fzd_71330013300epsmtip2C;
	Mon, 17 Nov 2025 07:11:19 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: =?utf-8?Q?'Peter_Wang_=28=E7=8E=8B=E4=BF=A1=E5=8F=8B=29'?=
	<peter.wang@mediatek.com>, <beanhuo@micron.com>, <avri.altman@wdc.com>,
	<storage.sec@samsung.com>, <linux-scsi@vger.kernel.org>,
	<bvanassche@acm.org>, <linux-kernel@vger.kernel.org>,
	<alim.akhtar@samsung.com>, <adrian.hunter@intel.com>,
	<martin.petersen@oracle.com>
In-Reply-To: <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
Subject: RE: [PATCH] UFS: Make TM command timeout configurable from host
 side
Date: Mon, 17 Nov 2025 16:11:19 +0900
Message-ID: <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKPfZmbwG70PGLKm/pFTS39UPXmNQJO/jelAdbalYUBDqcQiAEtGsS3ASfXEoMCIZ0ypQGwF+chApxwnbuzIGpR4A==
Content-Language: ko
X-CMS-MailID: 20251117071119epcas1p4b08367b4877f66ef407efde5ef2c94b1
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
	<1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
	<b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>

> -----Original Message-----
> From: Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B)=20<peter.wang=40mediatek.c=
om>=0D=0A>=20Sent:=20Thursday,=20November=2013,=202025=207:09=20PM=0D=0A>=
=20To:=20beanhuo=40micron.com;=20sh043.lee=40samsung.com;=20avri.altman=40w=
dc.com;=0D=0A>=20storage.sec=40samsung.com;=20linux-scsi=40vger.kernel.org;=
=20bvanassche=40acm.org;=0D=0A>=20linux-kernel=40vger.kernel.org;=20alim.ak=
htar=40samsung.com;=0D=0A>=20adrian.hunter=40intel.com;=20martin.petersen=
=40oracle.com=0D=0A>=20Subject:=20Re:=20=5BPATCH=5D=20UFS:=20Make=20TM=20co=
mmand=20timeout=20configurable=20from=20host=0D=0A>=20side=0D=0A>=20=0D=0A>=
=20On=20Wed,=202025-11-12=20at=2008:51=20-0800,=20Bart=20Van=20Assche=20wro=
te:=0D=0A>=20>=0D=0A>=20>=20Can't=20we=20increase=20the=20default=20timeout=
=20(TM_CMD_TIMEOUT)?=20Increasing=20the=0D=0A>=20>=20default=20timeout=20sh=
ouldn't=20affect=20any=20configuration=20negatively,=20isn't=0D=0A>=20>=20i=
t?=0D=0A>=20>=0D=0A>=20=0D=0A>=20Hi=20Bart,=0D=0A>=20=0D=0A>=20In=20the=20w=
orst-case=20scenario=20(when=20the=20device=20is=20stuck),=20it=20may=20tak=
es=201.1=0D=0A>=20seconds=20to=20abort=20a=20single=20task.=20When=20the=20=
queue=20is=20full=20(64),=20there=20will=20be=0D=0A>=20noticeable=20lag.=20=
Aborting=20all=20tasks=20can=20take=20over=20a=20minute,=20which=20is=0D=0A=
>=20unacceptable=20regardless=20of=20whether=20TM_CMD_TIMEOUT=20is=20increa=
sed=20or=20not.=0D=0A>=20Under=20normal=20conditions,=20it=E2=80=99s=20very=
=20unlikely=20to=20exceed=20100ms.=20So=20I=20think=0D=0A>=20directly=20mod=
ifying=20TM_CMD_TIMEOUT=20is=20also=20acceptable,=20but=20I=20suggest=0D=0A=
>=20keeping=20it=20within=20500ms.=0D=0A>=20=0D=0A>=20However,=20the=20opti=
mal=20solution=20is=20for=20the=20vendor=20to=20update=20the=20firmware,=0D=
=0A>=20ensuring=20that=20TM=20command=20priority=20is=20set=20appropriately=
=20to=20prevent=0D=0A>=20situations=20where=20it=20exceeds=20100ms.=0D=0A>=
=20=0D=0A>=20Thanks=0D=0A>=20Peter=0D=0A=0D=0AHi=20Mr.Wang,=0D=0A=0D=0AI=20=
understand=20your=20concerns=20about=20considering=20the=20worst-case=20sce=
nario.=0D=0AWhat=20about=20directly=20modifying=20TM_CMD_TIMEOUT=20(100ms=
=20->=20300ms)=20and=0D=0Areducing=20the=20TM=20retry=20count=20from=20100=
=20to=2030?=0D=0A=0D=0APlease=20let=20me=20know=20your=20opinion.=0D=0A=0D=
=0AThank=20you,=0D=0ASeunghui=20Lee.=0D=0A=0D=0A---=20a/drivers/ufs/core/uf=
shcd.c=0D=0A+++=20b/drivers/ufs/core/ufshcd.c=0D=0A=40=40=20-68,7=20+68,7=
=20=40=40=20enum=20=7B=0D=0A=20=23define=20ADVANCED_RPMB_REQ_TIMEOUT=20=203=
000=20/*=203=20seconds=20*/=0D=0A=20=0D=0A=20/*=20Task=20management=20comma=
nd=20timeout=20*/=0D=0A-=23define=20TM_CMD_TIMEOUT=20100=20/*=20msecs=20*/=
=0D=0A+=23define=20TM_CMD_TIMEOUT=20300=20/*=20msecs=20*/=0D=0A=20=0D=0A=20=
/*=20maximum=20number=20of=20retries=20for=20a=20general=20UIC=20command=20=
=20*/=0D=0A=20=23define=20UFS_UIC_COMMAND_RETRIES=203=0D=0A=40=40=20-7663,7=
=20+7663,7=20=40=40=20int=20ufshcd_try_to_abort_task(struct=20ufs_hba=20*hb=
a,=20int=20tag)=0D=0A=20=20=20=20=20=20=20=20int=20poll_cnt;=0D=0A=20=20=20=
=20=20=20=20=20u8=20resp=20=3D=200xF;=0D=0A=20=0D=0A-=20=20=20=20=20=20=20f=
or=20(poll_cnt=20=3D=20100;=20poll_cnt;=20poll_cnt--)=20=7B=0D=0A+=20=20=20=
=20=20=20=20for=20(poll_cnt=20=3D=2030;=20poll_cnt;=20poll_cnt--)=20=7B=0D=
=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20err=20=3D=20ufshcd_issue=
_tm_cmd(hba,=20lrbp->lun,=20lrbp->task_tag,=0D=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20UFS=
_QUERY_TASK,=20&resp);=0D=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20if=20(=21err=20&&=20resp=20=3D=3D=20UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)=
=20=7B=0D=0A=0D=0A=0D=0A
