Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D987E765
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 23:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720566931; cv=none; b=YiGD9K1SfQtyNtkFJPwAozjd0YcERG4gVHhusERGBmIoXz20EBW0JouYvs9e7X5NNverjTZbY/WO5krnQh6FwT6Z1ZNBq47VmEHfkg7WAi+K8zAQwtRf6VkGDdWxdPulRm5DaOZbNlAH4NIEzU7cltg7c3jqzGE5JehNxxRYpmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720566931; c=relaxed/simple;
	bh=DE1oq+nwcbY5PHUVwpml0GWBYQc6eR1tQ/tlmaw/cYg=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=cDVxEjl+hbWZeIVdXxJGW6089YZ9pY2ZaLIF/HPFW/okb7cYrDwdgqlZwuBBLcVhNhfb0CfGsJVEODzdFA0k9HW3MV91UmXBzHnGxjFMzeE6eqA5F/xvF7JfsQUqssmWGqgjmmbGeHJ9xGWlUM5SaWeLG1r2o+25IrE4yXILaio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sNec80OG; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sNec80OG"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240709231525epoutp02fa2c07ac9525a5c796571b32eaccb4db~groCo7TDn2774227742epoutp02O
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 23:15:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240709231525epoutp02fa2c07ac9525a5c796571b32eaccb4db~groCo7TDn2774227742epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720566925;
	bh=DE1oq+nwcbY5PHUVwpml0GWBYQc6eR1tQ/tlmaw/cYg=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=sNec80OGj4jnV9v+yDiNdX+mM/JGNmzZ5MIt46rEOuKahU9eWED5h/I8UUPV8E8p1
	 HFtdOLI7zgA0j6ciyJF820t5W3gZtteqYxVqo89AvTWWH1Z8ILRRnA3f1YPEmwocvL
	 /hM6oG7Bu2UYXNLns0kpLgFihfSspgAlSHrsidls=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240709231524epcas2p3daa2320bc7847b30b0dd9989841f08f5~groCWTzdQ3138531385epcas2p38;
	Tue,  9 Jul 2024 23:15:24 +0000 (GMT)
X-AuditID: b6c32a47-ecbfa7000000264e-d3-668dc48c18a4
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	83.18.09806.C84CD866; Wed, 10 Jul 2024 08:15:24 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: Re: [PATCH V3] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: Bart Van Assche <bvanassche@acm.org>, "Ed.Tsai@mediatek.com"
	<Ed.Tsai@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kyoungrul Kim
	<k831.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <cb2ad7aa-baa0-4228-9d37-43e4562a9118@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240709231524epcms2p56ce3211c8969ec79fac2af4af0fdd73e@epcms2p5>
Date: Wed, 10 Jul 2024 08:15:24 +0900
X-CMS-MailID: 20240709231524epcms2p56ce3211c8969ec79fac2af4af0fdd73e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdljTTLfnSG+awZKdJhbTPvxkttiz3s5i
	Yz+HxZRNXxktuq/vYLNYfvwfk8Wz0weYHdg9Ll/x9pg26RSbR8vJ/SweH5/eYvHo27KK0ePz
	JrkAtigum5TUnMyy1CJ9uwSujJdrW9kK+pUq5rT0MDYwTlXsYuTkkBAwkTi2+ShbFyMXh5DA
	DkaJU5feMnUxcnDwCghK/N0hDFIjLOAm0THxIRuILSQgJ3F9fjcrRFxHorv5AzOIzSagJbHx
	+EawOSICkxgl/n9/yQLiMAs8ZJRY0/CHBWIbr8SM9qdQtrTE9uVbGUFsTgFriRs7uxgh4hoS
	P5b1MkPYohI3V79lh7HfH5sPVSMi0XrvLFSNoMSDn7uh4lISbbN/M0HY1RJXG3eDHSEh0MEo
	0dL6kBUiYS6xcvUlsAZeAV+Jb/cvgMVZBFQl/t7tYIOocZHYfWIt2CBmAW2JZQtfM4NChVlA
	U2L9Ln0QU0JAWeLILRaICj6JjsN/2WFe3DHvCdQJShLt265CbZWQeDbxAtTJHhIHf51jncCo
	OAsR1LOQ7JqFsGsBI/MqRrHUguLc9NRiowJjveLE3OLSvHS95PzcTYzgNKPlvoNxxtsPeocY
	mTgYDzFKcDArifDOv9GdJsSbklhZlVqUH19UmpNafIhRmoNFSZz3XuvcFCGB9MSS1OzU1ILU
	IpgsEwenVANT762jen8/Vq85cKa031rAMDg7213TnIHnduDCVfrGpV2RV72FXINeB1Z/5vyw
	OPfrfa0ETmd3fbY3k7JvXxD4HpzUGV7t1sTsxHMrW0a8Nu1Za2twsID79SfzpM2WZmr+XG4U
	vdvBvEbXMTWppPnIyptb87lEJrvx7Jk0X262vnd2xMaturcvn5l5yV7qN9OyovUOnBZKt+LD
	zxy4utU7VrpmIe9pgX9Rejq5/RXr4rqPf9T8zPL8wRXhcC5d2bnCs95dYrXkyFp9W0rA4Oqb
	B8w7zircnKNi6NrKnD/JIo5Dd/c3e4fv8QcYt3+b91Bne1aOjc+FWwuduBZYfrjx/Inu8oMt
	X/uuP371+rYSS3FGoqEWc1FxIgBBwFxUogMAAA==
X-CMS-RootMailID: 20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8
References: <cb2ad7aa-baa0-4228-9d37-43e4562a9118@acm.org>
	<20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>
	<CGME20240708052542epcms2p5358e41c0116c936d2a43ad99f7c1e4a8@epcms2p5>

Thanks for your comment.
I will revise that.
=C2=A0=C2=A0=0D=0A=C2=A0=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20=
---------=0D=0ASender=20:=20Bart=20Van=20Assche=20<bvanassche=40acm.org>=0D=
=0ADate=20:=202024-07-10=2003:19=20(GMT+9)=0D=0ATitle=20:=20Re:=20=5BPATCH=
=20V3=5D=20scsi:=20ufs:=20core:=20Check=20LSDBS=20cap=20when=20=21mcq=0D=0A=
=C2=A0=0D=0AOn=207/7/24=2010:25=20PM,=20Kyoungrul=20Kim=20wrote:=0D=0A>=20i=
f=20the=20user=20set=20use_mcq_mode=20to=200,=20the=20host=20will=20try=20t=
o=20activate=20the=0D=0A=0D=0Aset=20->=20sets=0D=0A=0D=0A>=20lsdb=20mode=20=
unconditionally=20even=20when=20the=20lsdbs=20of=20device=20hci=20cap=20is=
=201.=20so=0D=0A>=20it=20makes=20timeout=20cmds=20and=20fail=20to=20device=
=20probing.=0D=0A=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0/*=0D=0A>=
=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*=20UFS=203.0=20has=20no=20MCQ_S=
UPPORT=20and=20LSDB_SUPPORT,=20but=20=5B31:29=5D=20as=20reserved=0D=0A>=20+=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*=20bits=20with=20reset=20value=200s=
,=20which=20means=20we=20can=20simply=20read=20values=0D=0A>=20+=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20*=20regardless=20to=20version=0D=0A>=20+=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*/=0D=0A=0D=0APlease=20change=20=22UFS=
=203.0=20has=20no=22=20into=20=22The=20UFSHCI=203.0=20specification=20does=
=0D=0Anot=20define=22=0D=0A=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0hba->mcq_sup=20=3D=20FIELD_GET(MASK_MCQ_SUPPORT,=20hba->capabil=
ities);=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0/*=0D=0A>=20+=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*=200h:=20legacy=20single=20doorbell=20sup=
port=20is=20available=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*=20=
1h:=20indicate=20that=20legacy=20single=20doorbell=20support=20have=20been=
=20removed=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20*/=0D=0A=0D=0Ah=
ave=20->=20has=0D=0A=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0hba->lsd=
b_sup=20=3D=20=21FIELD_GET(MASK_LSDB_SUPPORT,=20hba->capabilities);=0D=0A>=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=20(=21hba->mcq_sup)=
=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0return=200;=0D=0A>=C2=A0=0D=0A>=20=40=40=20-10449,6=20=
+10459,12=20=40=40=20int=20ufshcd_init(struct=20ufs_hba=20*hba,=20void=20__=
iomem=20*mmio_base,=20unsigned=20int=20irq)=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=7D=0D=0A>=C2=A0=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0if=20(=21is_mcq_supported(hba))=20=7B=0D=0A>=20+=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0if=
=20(=21hba->lsdb_sup)=20=7B=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0dev=
_err(hba->dev,=20=22%s:=20failed=20to=20initialize=20(legacy=20doorbell=20m=
ode=20not=20supported=5Cn=22,=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0__func__);=0D=0A=0D=0AA=20closing=20par=
enthesis=20is=20missing=20(=22)=22).=0D=0A=0D=0A>=20diff=20--git=20a/includ=
e/ufs/ufshcd.h=20b/include/ufs/ufshcd.h=0D=0A>=20index=20bad88bd91995..fd39=
1f6eee73=20100644=0D=0A>=20---=20a/include/ufs/ufshcd.h=0D=0A>=20+++=20b/in=
clude/ufs/ufshcd.h=0D=0A>=20=40=40=20-1074,6=20+1074,7=20=40=40=20struct=20=
ufs_hba=20=7B=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=
=20ext_iid_sup;=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bo=
ol=20scsi_host_added;=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0bool=20mcq_sup;=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20=
lsdb_sup;=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0bool=20m=
cq_enabled;=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0struct=
=20ufshcd_res_info=20res=5BRES_MAX=5D;=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0void=20__iomem=20*mcq_base;=0D=0A=0D=0APlease=20update=
=20the=20kernel-doc=20comment=20above=20struct=20ufs_hba=20for=20the=20new=
=0D=0Alsdb_sup=20member=20and=20please=20move=20the=20new=20member=20above=
=20mcq_sup=20such=20that=0D=0Athe=20mcq_sup=20and=20mcq_enabled=20definitio=
ns=20remain=20adjacent.=0D=0A=0D=0AThanks,=0D=0A=0D=0ABart.
