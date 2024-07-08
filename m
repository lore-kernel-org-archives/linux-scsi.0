Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2242101E2
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 05:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720415377; cv=none; b=lOxC7lto2h83Py9jX2tR48q7cNmb8636QipZ8/xGDTiykdcO/OsbIieAEhKx9Hgd5u42k/KKnxDHnUTlTbv6L+TqgQSxPO2exnTku8esyeGwH/vc7G0SjOhDmSKJcwcFlyISLXX7HuSD9+ZwJmrUMvq/FnDo/FqTMpFgKQ89usE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720415377; c=relaxed/simple;
	bh=n6cPiefcjaieOkMHARpJyosXzcWWcAJ7EjBZWaPPzGY=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=r29hCL5RGvlH+NS/SXla/ubSvDGiAEG98KWKtcp7a2m+kdVW/VaJl+/NCxTpWch3OilMpKbc/iox4hAF1v5Q0XGbPgd4dSumx/1/DwBDkg5wEfpv33ePOmvuXVPz7LWs2P+760wOZ3GlOKse8nh/k4nweIFbTafaSjJ2vMRDiiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NyzybdEz; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NyzybdEz"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240708050930epoutp03181b2c441ef0ea668e029529b8f9b95f~gJKomihmY2236522365epoutp037
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2024 05:09:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240708050930epoutp03181b2c441ef0ea668e029529b8f9b95f~gJKomihmY2236522365epoutp037
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720415370;
	bh=n6cPiefcjaieOkMHARpJyosXzcWWcAJ7EjBZWaPPzGY=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=NyzybdEzmVbGBJKISWkorUGD2+nwKPB+ZN9Rs1K88nh6dLdVYIZ1Qp+JAI4OkAYrz
	 Wu8+VUqIMLUyy/FIPu2v3HJuNnVnrsZjCwVhfWE4oF/BGjmoJI1Yv4Aw2pxB1h040M
	 s/vMkJ8RtFrTQ7PxNiucQXtwLmYSnicSehDiodjc=
Received: from epsmges2p2.samsung.com (unknown [182.195.42.70]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240708050930epcas2p42ca6a32c2a41bc65706d0cb2ae5bf403~gJKoLIuPF3177031770epcas2p4u;
	Mon,  8 Jul 2024 05:09:30 +0000 (GMT)
X-AuditID: b6c32a46-f3bff7000000250d-d3-668b748aceff
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	B6.9D.09485.A847B866; Mon,  8 Jul 2024 14:09:30 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: Re: [PATCH V2] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, SSDR Gost Dev
	<gost.dev@samsung.com>, Minwoo Im <minwoo.im@samsung.com>, Kyoungrul Kim
	<k831.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <6eeecf00c1602751d97bf8d5855fed05d64408b3.camel@mediatek.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240708050929epcms2p605d0b68988acc68c838c384b3c887eca@epcms2p6>
Date: Mon, 08 Jul 2024 14:09:29 +0900
X-CMS-MailID: 20240708050929epcms2p605d0b68988acc68c838c384b3c887eca
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsWy7bCmmW5XSXeaQed3IYtpH34yW+xZb2dx
	88BOJouN/RwWUzZ9ZbTovr6DzWL58X9MFs9OH2B24PC4fMXbY9qkU2weLSf3s3h8fHqLxaNv
	yypGj8+b5ALYorhsUlJzMstSi/TtErgyzs9UKvigWnH2ZTtbA+NTlS5GTg4JAROJuzffsHYx
	cnEICexglJj7tBPI4eDgFRCU+LtDGKRGWMBN4suR/4wgtpCAnMT1+d2sEHEdie7mD8wgNpuA
	lsTG4xvZQOaICFxllLi3eR3YUGaBu4wSvSvPMUFs45WY0f6UBcKWlti+fCvYVE4BL4kzvyYy
	Q8Q1JH4s64WyRSVurn7LDmO/PzafEcIWkWi9dxaqRlDiwc/dUHEpibbZv6F2VUtcbdzNAnKE
	hEAHo0RL60NWiIS5xMrVl8AaeAV8JW4d/gO2gEVAVaJvzWSoZheJP1vXs4HYzALaEssWvmYG
	hQqzgKbE+l36IKaEgLLEkVssEBV8Eh2H/7LDvLhj3hOoKUoS7duuQm2VkHg28QLUyR4Sl8/O
	ZpnAqDgLEdSzkOyahbBrASPzKkax1ILi3PTUYqMCI73ixNzi0rx0veT83E2M4HSj5baDccrb
	D3qHGJk4GA8xSnAwK4nwnn7cnibEm5JYWZValB9fVJqTWnyIUZqDRUmc917r3BQhgfTEktTs
	1NSC1CKYLBMHp1QDU/3zB/Ob78taV7o3+uV9iJK61uL4lf3rrM23qw+o8LGLvbq4er1eztql
	pxWy3knPnMg/PyGwg2m9fIRinIzCJZWL2m0LpQRPX5PfP6EjZ01FZs6MFdJ3l22SjDKLWTbN
	YPavTd6ThY3PTc9fLRNZLth4rYBDte5yXdMJqX2t5oti2vvOzPzx6/Otgzde1KW7aR02yWdt
	UFskJic7q8Mw+qPlBAsdT1f/DUun/qqeeSx5g2TXaob1Uw92eIvIs3f/mSm5d8plpqWqXxxT
	2uy3irY6TpY8I3M28OHy6mUxbUvMbhuZV+gem9K4vrHGNfTPpiyF10znFeMyOYxmPr36wHZ7
	7bskRwsJ1+0uzxK3KbEUZyQaajEXFScCAL+gix+mAwAA
X-CMS-RootMailID: 20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80
References: <6eeecf00c1602751d97bf8d5855fed05d64408b3.camel@mediatek.com>
	<20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p8>
	<CGME20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p6>

I made a mistake.
I will revise comment and commit message.
thanks.
=C2=A0=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASen=
der=20:=20Ed=20Tsai=20(=E8=94=A1=E5=AE=97=E8=BB=92)=20<Ed.Tsai=40mediatek.c=
om>=0D=0ADate=20:=202024-07-08=2011:53=20(GMT+9)=0D=0ATitle=20:=20Re:=20=5B=
PATCH=20V2=5D=20scsi:=20ufs:=20core:=20Check=20LSDBS=20cap=20when=20=21mcq=
=0D=0A=C2=A0=0D=0AOn=20Fri,=202024-07-05=20at=2017:30=20+0900,=20Kyoungrul=
=20Kim=20wrote:=0D=0A>=20if=20the=20user=20set=20use_mcq_mode=20to=200,=20t=
he=20host=20will=20activate=20the=20lsdb=0D=0A>=20mode=0D=0A>=20uncondition=
ally=20even=20when=20the=20lsdbs=20of=20device=20hci=20cap=20is=200.=20so=
=20it=0D=0A>=20makes=0D=0A=0D=0Alsdbs=20=3D=201=20indicates=20unsupported,=
=20not=200.=0D=0A=0D=0Aor=20simply=20say=20host=20controller=20doesn't=20su=
pport=20LSDB=20mode=20?=0D=0A=0D=0A>=20timeout=20cmds=20and=20fail=20to=20d=
evice=20probing.=0D=0A>=0D=0A>=20To=20prevent=20that=20problem.=20check=20t=
he=20lsdbs=20cap=20when=20mcq=20is=20not=0D=0A>=20supported=0D=0A>=20case.=
=0D=0A>=0D=0A>=20Signed-off-by:=20k831.kim=20<k831.kim=40samsung.com>=0D=0A=
>=0D=0A>=20---=0D=0A>=20Changes=20to=20v1:=20Fix=20wrong=20bit=20of=20lsdb=
=20support.=0D=0A>=20---=0D=0A>=C2=A0=20drivers/ufs/core/ufshcd.c=2016=20++=
++++++++++++++=0D=0A>=C2=A0=20include/ufs/ufshcd.h=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=201=20+=0D=0A>=C2=A0=20include/ufs/ufshci.h=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=201=20+=0D=0A>=C2=A0=203=20files=20changed,=2018=20insertions(=
+)=0D=0A>=0D=0A>=20diff=20--git=20a/drivers/ufs/core/ufshcd.c=20b/drivers/u=
fs/core/ufshcd.c=0D=0A>=20index=201b65e6ae4137..b5a05f8492c4=20100644=0D=0A=
>=20---=20a/drivers/ufs/core/ufshcd.c=0D=0A>=20+++=20b/drivers/ufs/core/ufs=
hcd.c=0D=0A>=20=40=40=20-2412,7=20+2412,17=20=40=40=20static=20inline=20int=
=0D=0A>=20ufshcd_hba_capabilities(struct=20ufs_hba=20*hba)=0D=0A>=C2=A0=20r=
eturn=20err;=0D=0A>=C2=A0=20=7D=0D=0A>=C2=A0=0D=0A>=20+/*=0D=0A>=20+=20*=C2=
=A0=20UFS=203.0=20has=20no=20MCQ_SUPPORT=20and=20LSDB_SUPPORT,=20but=20=5B3=
1:29=5D=20as=0D=0A>=20reserved=0D=0A>=20+=20*=C2=A0=20bits=20with=20reset=
=20value=200s,=20which=20means=20we=20can=20simply=20read=20values=0D=0A>=
=20+=20*=C2=A0=20regardless=20to=20version=0D=0A>=20+=20*/=0D=0A>=C2=A0=20h=
ba->mcq_sup=20=3D=20FIELD_GET(MASK_MCQ_SUPPORT,=20hba->capabilities);=0D=0A=
>=20+/*=0D=0A>=20+=20*=C2=A0=200h:=20legacy=20single=20doorbell=20support=
=20is=20available=0D=0A>=20+=20*=C2=A0=201h:=20indicate=20that=20legacy=20s=
ingle=20doorbell=20support=20have=20been=0D=0A>=20remove=0D=0A=0D=0As/remov=
e/removed/=0D=0A=0D=0Aalso,=20seems=20like=20there=20is=20an=20extra=20spac=
e=20at=20the=20beginning=20of=20each=0D=0Acomment=20message=20?=0D=0A=0D=0A=
>=20+=20*/=0D=0A>=20+hba->lsdb_sup=20=3D=20=21FIELD_GET(MASK_LSDB_SUPPORT,=
=20hba->capabilities);=0D=0A>=C2=A0=20if=20(=21hba->mcq_sup)=0D=0A>=C2=A0=
=20return=200;=0D=0A>=C2=A0=0D=0A>=20=40=40=20-10449,6=20+10459,12=20=40=40=
=20int=20ufshcd_init(struct=20ufs_hba=20*hba,=20void=0D=0A>=20__iomem=20*mm=
io_base,=20unsigned=20int=20irq)=0D=0A>=C2=A0=20=7D=0D=0A>=C2=A0=0D=0A>=C2=
=A0=20if=20(=21is_mcq_supported(hba))=20=7B=0D=0A>=20+if=20(=21hba->lsdb_su=
p)=20=7B=0D=0A>=20+dev_err(hba->dev,=20=22%s:=20failed=20to=20initialize=20=
(legacy=20doorbell=20mode=0D=0A>=20not=20supported=5Cn=22,=0D=0A>=20+__func=
__);=0D=0A>=20+err=20=3D=20-EINVAL;=0D=0A>=20+goto=20out_disable;=0D=0A>=20=
+=7D=0D=0A>=C2=A0=20err=20=3D=20scsi_add_host(host,=20hba->dev);=0D=0A>=C2=
=A0=20if=20(err)=20=7B=0D=0A>=C2=A0=20dev_err(hba->dev,=20=22scsi_add_host=
=20failed=5Cn=22);=0D=0A>=20diff=20--git=20a/include/ufs/ufshcd.h=20b/inclu=
de/ufs/ufshcd.h=0D=0A>=20index=20bad88bd91995..fd391f6eee73=20100644=0D=0A>=
=20---=20a/include/ufs/ufshcd.h=0D=0A>=20+++=20b/include/ufs/ufshcd.h=0D=0A=
>=20=40=40=20-1074,6=20+1074,7=20=40=40=20struct=20ufs_hba=20=7B=0D=0A>=C2=
=A0=20bool=20ext_iid_sup;=0D=0A>=C2=A0=20bool=20scsi_host_added;=0D=0A>=C2=
=A0=20bool=20mcq_sup;=0D=0A>=20+bool=20lsdb_sup;=0D=0A>=C2=A0=20bool=20mcq_=
enabled;=0D=0A>=C2=A0=20struct=20ufshcd_res_info=20res=5BRES_MAX=5D;=0D=0A>=
=C2=A0=20void=20__iomem=20*mcq_base;=0D=0A>=20diff=20--git=20a/include/ufs/=
ufshci.h=20b/include/ufs/ufshci.h=0D=0A>=20index=20385e1c6b8d60..22ba85e81d=
8c=20100644=0D=0A>=20---=20a/include/ufs/ufshci.h=0D=0A>=20+++=20b/include/=
ufs/ufshci.h=0D=0A>=20=40=40=20-75,6=20+75,7=20=40=40=20enum=20=7B=0D=0A>=
=C2=A0=20MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT=3D=200x02000000,=0D=0A>=C2=
=A0=20MASK_UIC_DME_TEST_MODE_SUPPORT=3D=200x04000000,=0D=0A>=C2=A0=20MASK_C=
RYPTO_SUPPORT=3D=200x10000000,=0D=0A>=20+MASK_LSDB_SUPPORT=3D=200x20000000,=
=0D=0A>=C2=A0=20MASK_MCQ_SUPPORT=3D=200x40000000,=0D=0A>=C2=A0=20=7D;=0D=0A=
>=C2=A0=0D=0A>=20--=0D=0A>=202.34.1=0D=0A>
