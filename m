Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9BF28A1C8
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 07:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752649298; cv=none; b=RwsR38i6gPuWrg8zpkbDrRqwns4ga6CHGFjzbngFoQzY8H6KjQcezYD2qTg9kQppddeQ78KfxHKATDaCJ4S05p2A+5q/5MWN8XJagW4jxWnWRtcn+5xzwrDS/lfmKOC1eTLag4V/4MkAk8uDaoQ3BHdcMNxZ1oc1/GQhtg7KvUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752649298; c=relaxed/simple;
	bh=TAQ21jHyZJyJijMMs0Y5ry5nybACZ40xdCqwZMi4QM0=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=qjmkJXAchD4cTyYN7zLVK+xRZchAyqy3Hex/gcJQ6SMjaQ8Ic7YulOPy9DmBs3MS8R72z8NhKm9IO8FcZ2lmntAucSUZ+h95/O2riPxcHXYHLDHOf92DqWFCZSQv2PYsNnXvJMzzDz2iHKa5SOJzv+fRDEVtpZJXDvrI9YIrJR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Huk0EEC5; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Huk0EEC5"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250716070127epoutp045c2aa6c24823cac63074b5b7e1da05ff~SqT3BeyIS1604116041epoutp040
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 07:01:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250716070127epoutp045c2aa6c24823cac63074b5b7e1da05ff~SqT3BeyIS1604116041epoutp040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752649287;
	bh=TAQ21jHyZJyJijMMs0Y5ry5nybACZ40xdCqwZMi4QM0=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=Huk0EEC5OIqvcyLfJXWr1Xq2gpXWPll1JoMoGmP661H5XAHmb96G70jOJprv/Daz3
	 ecgchIkv2Pcb3aKVvlyq9YPbA1GzBdZS+v7TpBANk/taf1kqOIJEikR8roY2JEtc3+
	 x7K3p0ChuNcoGnK1jMgX3gV5b862F/9KVMNa5JFo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250716070127epcas1p4f96e1cf0070bfb18dcb9ab61f86c1af1~SqT2udh0V1167411674epcas1p4O;
	Wed, 16 Jul 2025 07:01:27 +0000 (GMT)
Received: from epdlp6prp5 (unknown [182.195.38.247]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bhn5y6Z0Qz6B9mB; Wed, 16 Jul
	2025 07:01:26 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20250716070126epcas1p30f738d1f211b88d10d5595c414602e27~SqT1yOH-U2246622466epcas1p3s;
	Wed, 16 Jul 2025 07:01:26 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250716070126epsmtip22c645fceb4cb48dffc1e818c597e2521~SqT1uM9jz0459304593epsmtip2y;
	Wed, 16 Jul 2025 07:01:26 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: "'Bean Huo'" <huobean@gmail.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <sdriver.sec@samsung.com>
In-Reply-To: <cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
Subject: RE: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Wed, 16 Jul 2025 16:01:26 +0900
Message-ID: <005801dbf61f$7287e7d0$5797b770$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH3aHPkcZ8xP3B7R0c5EXGU8cAQqgKwpSsnAUiyhkICOzcz6QJIvQEgs7mAebA=
Content-Language: ko
X-CMS-MailID: 20250716070126epcas1p30f738d1f211b88d10d5595c414602e27
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

> -----Original Message-----
> From: Bean Huo <huobean=40gmail.com>
> Sent: Wednesday, July 16, 2025 12:22 AM
> To: =EC=9D=B4=EC=8A=B9=ED=9D=AC=20<sh043.lee=40samsung.com>;=20alim.akhta=
r=40samsung.com;=0D=0A>=20avri.altman=40wdc.com;=20bvanassche=40acm.org;=0D=
=0A>=20James.Bottomley=40HansenPartnership.com;=20martin.petersen=40oracle.=
com;=20linux-=0D=0A>=20scsi=40vger.kernel.org;=20sdriver.sec=40samsung.com=
=0D=0A>=20Subject:=20Re:=20=5BPATCH=5D=20ufs:=20core:=20Use=20link=20recove=
ry=20when=20the=20h8=20exit=20failure=0D=0A>=20during=20runtime=20resume=0D=
=0A>=20=0D=0A>=20=0D=0A>=20You=20patched=20ufshcd_runtime_suspend()=20to=20=
return=20-EBUSY=20if=20eh_in_progress=20is=0D=0A>=20true=20=E2=80=94=20mean=
t=20to=20avoid=20suspend=20during=20error=20handling.=20I=20don't=20underst=
and=0D=0A>=20why=20here=20parent=20is=20not=20active?=0D=0A=0D=0AAfter=20ch=
ecking=20the=20RPM=20devices,=20I=20found=20that=20the=20parent=20device=20=
is=20suspended=20due=20to=20the=20failure=20of=20ufshcd_wl_runtime_resume.=
=0D=0AEven=20if=20we=20guarantee=20both=20the=20completion=20of=20ufshcd_ru=
ntime_suspend=20and=20the=20error=20handling=20completion=20to=20avoid=20ra=
ces,=20ufshcd_recover_pm_error=20can't=20fully=20recover=20from=20a=20runti=
me=20pm=20failure=20scenario.=0D=0A=0D=0A>=20=0D=0A>=20would=20like=20to=20=
try=20return=20-EAGAIN?=0D=0A>=20=0D=0A>=20=0D=0A>=20Kind=20regards,=0D=0A>=
=20Bean=0D=0A>=20=0D=0A=0D=0AI've=20tried=20that=20as=20well,=20but=20it=20=
doesn't=20work=20either.=0D=0A=5B=20=20328.915154=5D=20=5B0:=20=20kworker/u=
32:7:=20=20941=5D=20ufs_device_wlun=200:0:0:49488:=20runtime=20PM=20trying=
=20to=20activate=20child=20device=200:0:0:49488=20but=20parent=20(target0:0=
:0)=20is=20not=20active=0D=0A=5B=20=20328.915156=5D=20=5B0:=20=20kworker/u3=
2:7:=20=20941=5D=20ufs_device_wlun=200:0:0:49488:=20ufshcd_recover_pm_error=
:=20rpm=20set_active=20ret(-16)=0D=0A=5B=20=20328.915157=5D=20=5B0:=20=20kw=
orker/u32:7:=20=20941=5D=20ufshcd-qcom=201d84000.ufshc:=20ufshcd_recover_pm=
_error:=20rpm=20set_active=20ret(-11)=0D=0ADue=20to=20this=20error,=20pm_re=
quest_resume(q->dev)=20for=20each=20scsi=20device=20can't=20execute.=0D=0AT=
his=20causes=20the=20I/O=20stack=20to=20become=20stuck.=0D=0A=0D=0AThis=20i=
ssue=20arises=20from=20the=20race=20condition=20between=20the=20runtime=20p=
m=20worker=20and=20the=20error=20handler=20worker.=0D=0AI=20believe=20it=20=
would=20be=20safer=20to=20handle=20recovery=20within=20the=20runtime=20pm=
=20worker=20itself.=0D=0A=0D=0AFor=20reference,=20ufshcd_link_recovery=20is=
=20useful=20for=20the=20similar=20issue.=20(resolving=20the=20race=20condit=
ion=20between=20the=20runtime=20pm=20worker=20and=20the=20SCSI=20error=20ha=
ndler=20worker)=0D=0Ahttps://patchwork.kernel.org/project/linux-scsi/patch/=
20230927033557.13801-1-peter.wang=40mediatek.com/=0D=0A=0D=0AI'll=20add=20F=
ixes=20tags=20and=20modify=20v2=20as=20requested.=0D=0A=0D=0AThank=20you,=
=0D=0ASeunghui=20Lee.=0D=0A=0D=0A=0D=0A=0D=0A
