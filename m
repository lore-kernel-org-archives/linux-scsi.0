Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D5A1DA53
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2024 04:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719635985; cv=none; b=Wt2pMvcJiz81bndooJ16SgAhoY8cFeIv/E62lIj889iL/sLOaRj//xOdhhsvfyClzQF3LRHDE5IV+Y4NK8L5MaEzFYkxK4kkarD/swagXdzmaDcvZLHT+BbWRX/2rvL249ygod8LuCWcPdtOoToUgNy/AsNGlAMOuzKUhrXOdKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719635985; c=relaxed/simple;
	bh=OfYLpRXPLbKOeQIUFWViG64plp4T+dyD8EAwon2/mN4=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=TvRG03kAEP6z1S0B+wOsp3+AVZIiv3mu8xgn3xbWqXOGncsQOB1GoLigWPSkrIJfc9CiOUH0tRY47HfQRehlCLOZ+WZu2TlI4h3g02ykatbeYRhfZUxJ1oFGAk4UHxWPWYmdnPXwZA+DRsoWE8fy24wttecB+rwdiAXnm5hqQxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YVK+t68+; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YVK+t68+"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240629043938epoutp04ede47d47f79b5a08b04f0bfe13fa40b0~dX8_2Bo3z0869908699epoutp044
	for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2024 04:39:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240629043938epoutp04ede47d47f79b5a08b04f0bfe13fa40b0~dX8_2Bo3z0869908699epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719635978;
	bh=OfYLpRXPLbKOeQIUFWViG64plp4T+dyD8EAwon2/mN4=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=YVK+t68+XO3Tb1MKjM1JTBoX+2HyUQcgbUXfXeNk+Gun0O1yzhnxryf76BDs5Wh+p
	 PwhMzoGn4mXo31YE5qYY1wIIzBGhyOGESM4JBK1rw2Brd1fiS7sm+CsjR8HDWNPGtC
	 dWZYJe5i+g5seE1vrX6vgPhk5ly58vljsfV3uB7I=
Received: from epsmges2p1.samsung.com (unknown [182.195.42.69]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240629043937epcas2p14cc287f55a1ffd24af0f724a6160c04d~dX897tJlI1213312133epcas2p1G;
	Sat, 29 Jun 2024 04:39:37 +0000 (GMT)
X-AuditID: b6c32a45-447fe70000002678-93-667f90096525
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	87.F2.09848.9009F766; Sat, 29 Jun 2024 13:39:37 +0900 (KST)
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
In-Reply-To: <adbf2b00-541c-4ab8-9b13-7ad70a6353c9@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240629043936epcms2p69efb803ff47ecb61c625fdf14217ae18@epcms2p6>
Date: Sat, 29 Jun 2024 13:39:36 +0900
X-CMS-MailID: 20240629043936epcms2p69efb803ff47ecb61c625fdf14217ae18
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42LZdljTTJdzQn2awdOzIhbTPvxkttjYz2Ex
	ZdNXRovu6zvYLJYf/8dk8ez0AWYHNo/LV7w9pk06xebx8ektFo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DKWPn+DVvBBq6K0896GRsYP3J2MXJySAiYSFyZsJS5i5GLQ0hgB6PE7VdXWLsY
	OTh4BQQl/u4QBjGFBZwkDkyJAykXEpCTuD6/mxXEFhbQkehu/sAMYrMJaElsPL6RDWSMiMAu
	Rolta88zgTjMAh2MEls6pzJDLOOVmNH+lAXClpbYvnwrI4jNKWAtMeviJKi4hsSPZb1Q9aIS
	N1e/ZYex3x+bzwhhi0i03jsLVSMo8eDnbqi4lETb7N9MEHa1xOQFi6B6ayTWvp0KZZtL/L6/
	G+wDXgFfifvL74PNYRFQlbg/eRcbRI2LxIdts8FqmAW0JZYtfM0MCghmAU2J9bv0QUwJAWWJ
	I7dYICr4JDoO/2WH+XDHvCdQFyhJtG+7ygphS0g8m3gB6mIPiUtrVrJMYFSchQjoWUh2zULY
	tYCReRWjWGpBcW56arFRgaFecWJucWleul5yfu4mRnBC0XLdwTj57Qe9Q4xMHIyHGCU4mJVE
	ePkz69KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ895rnZsiJJCeWJKanZpakFoEk2Xi4JRqYIoU
	Vns+weC/jmU9F3ujamLakm+Ombev7TjV9sgum5H3JOengrmvoosLf1yer3X7qbe9Yd8CiR7t
	pprFZo+7Mz24f+ydNm2jWeEUhrA7PU5ne1n0F//OqDYPT1De1LvO6UKcdHpQok9h2yu3JjEe
	k0L5ghthSnMO1Nvy6rkuPN62mrFJ/pWcYdTpaw+SP4tNSVl74N/PW66brrydsetbrIvmdeOs
	D3rLThxfNnH31JrTEhGpKctcP9n3+P3Jv+pr8Oikzi2HWYsWHl0w6YDrYfNHVSEpS8PEBBe3
	HEpkCHjJ8vxrt4Rn1m4O9sgXMwXW96/8lWFxODVke3rAHe3a3PqVP3dcP7VqJd8s0aRl65RY
	ijMSDbWYi4oTAfCULfeXAwAA
X-CMS-RootMailID: 20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7
References: <adbf2b00-541c-4ab8-9b13-7ad70a6353c9@acm.org>
	<2004249a-7130-42ab-8264-78f9c418bef3@acm.org>
	<20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
	<20240628021836epcms2p71dd5b348d5a386635d99fb342fe9cb04@epcms2p7>
	<CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p6>

Yes, you are right. The ufshcd_init() and ufshcd_device_init() call scsi_ad=
d_host().
However, the ufs_device_init() already has the =22hba->scsi_host_added =3D =
true=22 assignment.
So, I added only one assignment.
=C2=A0=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASen=
der=20:=20Bart=20Van=20Assche=20<bvanassche=40acm.org>=0D=0ADate=20:=202024=
-06-29=2004:30=20(GMT+9)=0D=0ATitle=20:=20Re:=20=5BPATCH=5D=20ufs:=20core:=
=20Remove=20scsi=20host=20only=20if=20added=0D=0A=C2=A0=0D=0AOn=206/27/24=
=207:18=20PM,=20Kyoungrul=20Kim=20wrote:=0D=0A>=20Yes,=20scsi_add_host=20ha=
s=20been=20moved=20the=20async=20function=20(ufshcd_device_init)as=20MCQ=20=
patch=20applied.=0D=0A>=20So=20the=20ufshcd=20driver=20attaches=20the=20dev=
ice=20without=20knowing=20whether=20the=20probe=20fails=20or=20not.=0D=0A>=
=20and=20if=20host=20tries=20to=20remove=20ufshcd=20driver,=20it=20makes=20=
kernel=20panic.=0D=0A>=20So=20it=20became=20necessary=20to=20check=20whethe=
r=20to=20add=20a=20host=20or=20not.=0D=0A=0D=0AThere=20are=20two=20scsi_add=
_host()=20calls=20in=20the=20UFS=20driver=20and=20this=20patch=0D=0Aonly=20=
adds=20one=20=22hba->scsi_host_added=20=3D=20true=22=20assignment.=20Should=
n't=20this=0D=0Apatch=20add=20two=20such=20assignments?=0D=0A=0D=0AThanks,=
=0D=0A=0D=0ABart.
