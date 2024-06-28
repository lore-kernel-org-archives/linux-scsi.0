Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C27817F8
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 02:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719541122; cv=none; b=GGjbrOfAcx67DljeF5T8e1nfT5nBTLTxB8CLfZqlMOYXlO+bYqBRwXF5wAG/SJ1vvaibRop68wNxNJlc9Gn5ZyIsROi4RKG58QwgkxPoyduibpJMBW8NYIPe306HoQLnFT73HiGS6/JsEfhqpAARusXr0AenH/p6UrTAJfxqPmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719541122; c=relaxed/simple;
	bh=PdD600JfY7UiyIXM4bWYuokg8oGhog2nT7zdYG5MVMM=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=b8IxdFVh7XeKEh2zX6OXvxmPmPuMgqExC4cmIeVCZIbV+wiXw0YvEH677XY0AdyQsf5PkmloeDQPHoRp6GUMhwcbdnUahSSBMo877LEmdDEfiD+el9VIypf3Peq/6Va9AN/c4DAnum4bpoUV0QQyijBr4bxEPExeimRU7kgnXeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dxRmLDdL; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dxRmLDdL"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240628021836epoutp02e27a4fde3991ddf0a8ee0854b01005ac~dCYkO3uA30164901649epoutp02Q
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 02:18:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240628021836epoutp02e27a4fde3991ddf0a8ee0854b01005ac~dCYkO3uA30164901649epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719541117;
	bh=PdD600JfY7UiyIXM4bWYuokg8oGhog2nT7zdYG5MVMM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=dxRmLDdLZJBqLaCdnWMJthQUgORYKN/0/ErdxWtYPefYDCnG+aVC/QROrrqVvkfT5
	 t63ROhiHU5i03mAPivWXuesUz3E78uJeV9wdFWyGmKr3g8rBdCG6JNtaD7dnIX/nVT
	 msHv9t1I7wK7maLlHbf8Ef6TP0ATp134Bulft+CI=
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.42.77]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240628021836epcas2p2b91719665d705c2d12de0c02f8f50256~dCYj9EJIg1129111291epcas2p2H;
	Fri, 28 Jun 2024 02:18:36 +0000 (GMT)
X-AuditID: b6c32a4d-62569a80000262f0-aa-667e1d7cba06
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DD.66.25328.C7D1E766; Fri, 28 Jun 2024 11:18:36 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: Re: [PATCH] ufs: core: Remove scsi host only if added
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Minwoo Im
	<minwoo.im@samsung.com>, Kyoungrul Kim <k831.kim@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2004249a-7130-42ab-8264-78f9c418bef3@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240628021836epcms2p71dd5b348d5a386635d99fb342fe9cb04@epcms2p7>
Date: Fri, 28 Jun 2024 11:18:36 +0900
X-CMS-MailID: 20240628021836epcms2p71dd5b348d5a386635d99fb342fe9cb04
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42LZdljTVLdGti7NYMNcVYtpH34yW2zs57CY
	sukro0X39R1sFsuP/2OyeHb6ALMDm8flK94e0yadYvP4+PQWi0ffllWMHp83yQWwRnHZpKTm
	ZJalFunbJXBlrP87gbHgM0/FmruH2BsYJ/N0MXJwSAiYSFyfxtjFyMkhJLCHUeLCBD2QMK+A
	oMTfHcIgprCAk8SBKXEQFXIS1+d3s4LYwgI6Et3NH5hBbDYBLYmNxzeydTFycYgI7GKU2Lb2
	PBOIwyzQwSixpXMqWJWEAK/EjPanLBC2tMT25VvB9nIKWEt8nf+IHSKuIfFjWS9UvajEzdVv
	2WHs98fmM0LYIhKt985C1QhKPPi5GyouJdE2+zcThF0tMXnBIqjeGom1b6dC2eYSv+/vZoX4
	0VfizKJAkDCLgKrE1deXWSFKXCQ6VnSAjWQW0JZYtvA1M0g5s4CmxPpd+pBAU5Y4cosFooJP
	ouPwX3aYB3fMewJ1gJJE+7arUBMlJJ5NvAB1sIfEpTUrWSYwKs5ChPMsJLtmIexawMi8ilEq
	taA4Nz012ajAUDcvtVyvODG3uDQvXS85P3cTIzilaPnuYHy9/q/eIUYmDsZDjBIczEoivKEl
	VWlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEee+1zk0REkhPLEnNTk0tSC2CyTJxcEo1MOmsDst/
	ZWpw5sKzKlbOoMYjF5evvbt3/sOrz/0e11kc2BtrsnBZkNclA5/NdfeFFzfsnvvw8ufOacxq
	rzYm7NCZZaq64KbEpmBBXc807u8JqttDWBTmnHqlHR8QsaRfrp031/vETPOAMNaj+b9P96zL
	+xds+mvxuVP6Wsf72CZr6V0RvyLhzN28/btVT1EAr8FhZyZD/mNWO+YWMYQYWNQ/OeQ/4ZhT
	dca8XvNrLi80NE+c5j+45zJrD/Oqb9LZWq9U6twem4gxb1A0OvXbM9rF7Nr6RXp9Kmeqba+s
	OCLz0Wft4uRDCcohdYsO1p50r2qr7/XYUdGy75xXKP8RwTnK3zonXZ6S68jb4m69SomlOCPR
	UIu5qDgRAKR2BwGYAwAA
X-CMS-RootMailID: 20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7
References: <2004249a-7130-42ab-8264-78f9c418bef3@acm.org>
	<20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
	<CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p7>

Yes, scsi_add_host has been moved the async function (ufshcd_device_init)as=
 MCQ patch applied.
So the ufshcd driver attaches the device without knowing whether the probe =
fails or not.
and if host tries to remove ufshcd driver, it makes kernel panic.
So it became necessary to check whether to add a host or not.
=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASender=20:=20Ba=
rt=20Van=20Assche=20<bvanassche=40acm.org>=0D=0ADate=20:=202024-06-28=2001:=
25=20(GMT+9)=0D=0ATitle=20:=20Re:=20=5BPATCH=5D=20ufs:=20core:=20Remove=20s=
csi=20host=20only=20if=20added=0D=0A=C2=A0=0D=0AOn=206/27/24=201:51=20AM,=
=20=EA=B9=80=EA=B2=BD=EB=A5=A0=20wrote:=0D=0A>=20=40=40=20-10638,6=20+10639=
,7=20=40=40=20int=20ufshcd_init(struct=20ufs_hba=20*hba,=20void=20__iomem=
=20*mmio_base,=20unsigned=20int=20irq)=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0dev_err(hba->dev,=20=22scsi_add_host=20failed=5Cn=22);=0D=
=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0goto=20out_disable;=
=0D=0A>=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=
=A0=20=C2=A0=20=C2=A0=7D=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0hba->scsi_host_added=20=3D=20true;=0D=0A>=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=7D=0D=0A>=C2=A0=0D=0A=
=0D=0AWhy=20has=20no=20=22hba->scsi_host_added=20=3D=20true=22=20assignment=
=20been=20added=20in=0D=0Aufshcd_device_init()?=20Isn't=20that=20a=20bug?=
=0D=0A=0D=0ABart.
