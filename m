Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADCA3164D8
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783911158; cv=none; b=aTtycO76bpPFI6SZbLuGBoNQLSsVbU7wOn03FP4Uxs1w7RPe2zd6t53InPfeCskotncah5F26vsjWlwRH80N9vs55EAkgYWslmnJ4/21CBmaka3wUlfwxu8sVebuqmPbG4TqCQcYcyt7gHGJrRTg2ycxXajwE5rMUfNvupkMzuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783911158; c=relaxed/simple;
	bh=RPJ/yFfdo2BqiRL2Bc2f+l++a0D6prSxSPsfAp/ClXY=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=K+D2muPGHm0s8lsII4TOFOJFQLj6AGrx65uPo0HuwD1QQbTgR9QIwnI6bdCcQvvDuWoC85xCXVeM2Rq+rCmPPYpu8g8pxVC7QwN8ry1ulZbM4IS92uqFeGKRYkLdTYNxbY1aAb1095YaBMCtKFK4vAASCrS8fPBEPi2bfM9lvAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UBtLyIAe; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UBtLyIAe"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260713025228epoutp04f9dd474e039e4e32e11ea0699ab48613~Bubzg_OSA1615216152epoutp04w
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 02:52:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260713025228epoutp04f9dd474e039e4e32e11ea0699ab48613~Bubzg_OSA1615216152epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1783911148;
	bh=RPJ/yFfdo2BqiRL2Bc2f+l++a0D6prSxSPsfAp/ClXY=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=UBtLyIAeZ3Eqp7pNGnjWTdJFNgofBQrAa1DE3sHmOUgEB1vSxsQqB56ijiiQ8OWyp
	 7ZxlXhlqb08opttwYNQThrviEq7UJQoAPPUgbRWLYBe6UTfEOlOFHlOKWMMrOimvHw
	 S4FptqzXF3viQxjmwCIGZ0hpgGV7v6Jcx4HMpm5Y=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20260713025227epcas2p109a56ade85eb62cfacba0d0603338b80~BubzIiQpC1000110001epcas2p1q;
	Mon, 13 Jul 2026 02:52:27 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.210]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4gz6Rb43k4z3hhT8; Mon, 13 Jul
	2026 02:52:27 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] scsi: ufs: Add support for the aggregated read query
 opcode
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: ALIM AKHTAR <alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Jinyoung Choi <j-young.choi@samsung.com>,
	Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
	Keoseong Park <keosung.park@samsung.com>, Jaemyung Lee
	<jaemyung.lee@samsung.com>, Jieon Seol <jieon.seol@samsung.com>, Gyusun Lee
	<gyusun.lee@samsung.com>, Yunjae Jo <yunjae00.jo@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <6d087f28-5795-4929-b5d3-3f78d9b9bc60@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260713025227epcms2p41de509bb713eb7a6be2c945073be6b3a@epcms2p4>
Date: Mon, 13 Jul 2026 11:52:27 +0900
X-CMS-MailID: 20260713025227epcms2p41de509bb713eb7a6be2c945073be6b3a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260710053524epcms2p82121eba4240c37112fc5669430035442
References: <6d087f28-5795-4929-b5d3-3f78d9b9bc60@acm.org>
	<20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
	<CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>

Hi Bart,

On 7/10/26 02:46 PM, Bart Van Assche wrote:
> On 7/9/26 10:45 PM, Hyeoncheol Jeong wrote:
> > struct utp_transfer_cmd_desc =7B
> >=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u8=20command_upiu=5BA=
LIGNED_UPIU_SIZE=5D;=0D=0A>=20>=20-=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u8=
=20response_upiu=5BALIGNED_UPIU_SIZE=5D;=0D=0A>=20>=20+=20=C2=A0=20=C2=A0=
=20=C2=A0=20=C2=A0u8=20response_upiu=5BALIGNED_RSP_UPIU_SIZE=5D;=0D=0A>=20>=
=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0u8=20prd_table=5B=5D;=0D=
=0A>=20>=20=7D;=0D=0A>=0D=0A>=20This=20change=20increases=20the=20size=20of=
=20every=20CQ=20entry=20and=20also=20of=20every=20LRB=0D=0A>=20entry=20by=
=20about=204=20KiB.=20This=20is=20not=20acceptable.=0D=0A=0D=0AThanks=20for=
=20the=20review.=20You're=20right=20=E2=80=94=20growing=20the=20shared=0D=
=0Autp_transfer_cmd_desc=20enlarges=20the=20response=20area=20for=20every=
=20tag,=0D=0Awhich=20is=20wasteful.=20The=20aggregated=20read=20only=20uses=
=20the=20reserved=0D=0A(device=20management)=20tag,=20so=20only=20that=20ta=
g=20needs=20the=20big=20buffer.=0D=0A=0D=0AWould=20it=20be=20okay=20to=20ke=
ep=20utp_transfer_cmd_desc=20as=20is=20and=20give=0D=0Ajust=20the=20reserve=
d=20tag=20a=20dedicated=204=20KiB=20response=20descriptor?=0D=0ARegular=20t=
ags=20and=20normal=20I/O=20would=20stay=20unchanged.=0D=0A=0D=0ALet=20me=20=
know=20if=20you'd=20prefer=20another=20approach.=0D=0A=0D=0AThanks.=0D=0A
