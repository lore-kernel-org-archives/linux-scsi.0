Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBB218872A
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2025 04:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739765294; cv=none; b=Hiqn3qGclwol19RVeRtcLSAB1mVMZ19/jiXFW2EMnLBNiT99ml228otRecm078+843C1UrG0JKVf6vYMAwu7lVqDH763bajH4NBDIf2MN0jdRFE16NE4jVHgJhWZ8IDgHjtgD30kcikiwLm7SddQB9X5YomhNlZn8B4SBu/InHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739765294; c=relaxed/simple;
	bh=i/PwgKMCBCZLfEHQsGsntQ1fEhhQoS94549m2nz6EA4=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=ZZwV5uCv2DOz4BAqS3ya5KtW7z7Ps5rEFxE3IIw5mchSlRzPQiB7wzS2Mr07IlmYYbgkCwG34bfai45vbdsE1Wxs1NIY/ASI6Z9rBl5XxZ99BSXvUvyHz5fXc6fBk8lWCl92j/NsxbELQRWkVGyp163DpyzoLEqQ9cfOzHfYGpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=THB3WQuR; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="THB3WQuR"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250217040803epoutp043b8be2793e3c0de79026646ad95923ec~k407aiP2K0407904079epoutp04b
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2025 04:08:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250217040803epoutp043b8be2793e3c0de79026646ad95923ec~k407aiP2K0407904079epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739765283;
	bh=q4FEvnHmy+mB9MbRC/88U70doteoss0rejRbFKfqfQk=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=THB3WQuRNek7ifCXOT8QGTh0l7OeOwTmw2+XSDdbKXaCrq8lZ84tsfB2yJvSy6DTg
	 P8ZMjqjBSo6UirKm7A4dq2j5a4Af3G7J1uiPpikrn4VOvHWrIrVQIZktiMZZZQKAOs
	 aKC+tWmXQVvi9g0QK5oL40QsKuiAxWcgrHPmybV0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20250217040803epcas2p4bf4912fef65c350a72e533852c54683c~k4060pky53087230872epcas2p4G;
	Mon, 17 Feb 2025 04:08:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Yx8Jg1dbtz4x9Pv; Mon, 17 Feb
	2025 04:08:03 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE:(2) [PATCH] scsi: ufs: Fix incorrect bit assignment for
 temperature notifications
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: Avri Altman <Avri.Altman@sandisk.com>, Keoseong Park
	<keosung.park@samsung.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "linux@roeck-us.net" <linux@roeck-us.net>, Daejun Park
	<daejun7.park@samsung.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Bao D .
 Nguyen" <quic_nguyenb@quicinc.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <PH7PR16MB61965AFF2D91331975BBD24EE5FE2@PH7PR16MB6196.namprd16.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01739765283208.JavaMail.epsvc@epcpadp2new>
Date: Mon, 17 Feb 2025 11:39:00 +0900
X-CMS-MailID: 20250217023900epcms2p6d07e63f7ede68a88b53daf7a17f4062a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250214105219epcms2p3a60810a14e6181092cb397924ce36019
References: <PH7PR16MB61965AFF2D91331975BBD24EE5FE2@PH7PR16MB6196.namprd16.prod.outlook.com>
	<1891546521.01739535602406.JavaMail.epsvc@epcpadp1new>
	<CGME20250214105219epcms2p3a60810a14e6181092cb397924ce36019@epcms2p6>

> + Bao
>
>> According to the UFS specification, the bit positions for
>> `UFS_DEV_HIGH_TEMP_NOTIF` and `UFS_DEV_LOW_TEMP_NOTIF` were
>> incorrectly assigned. This patch corrects the bit assignment to align wi=
th the
>> specification.
>>=20
>> If this issue is not fixed, devices that support both high and low tempe=
rature
>> notifications may function correctly, but devices that support only one =
of
>> them may fail to trigger the corresponding exception event.
>>=20
>> Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notificatio=
n
>> support")
>> Signed-off-by: Keoseong Park <keosung.park@samsung.com>
> Already noticed by Bao D. Nguyen - see https://protect2.fireeye.com/v1/ur=
l?k=3D81dbf2a5-e050e79f-81da79ea-74fe4860008a-0424961c73a03c70&q=3D1&e=3Dfc=
fc99c7-cb2b-4f68-8ef4-e2760c685fec&u=3Dhttps%3A%2F%2Fwww.spinics.net%2Flist=
s%2Flinux-scsi%2Fmsg202162.html
>
> Thanks,
> Avri
>

Hi Avri,

Thank you for the update. I wasn=E2=80=99t aware that Bao D. Nguyen=E2=80=
=99s patch had already been applied. =20
I appreciate the heads-up, and I=E2=80=99ll make sure to check the latest p=
atches more carefully next time. =20

Best Regards,
Keoseong

>> ---
>>  include/ufs/ufs.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h index
>> d335bff1a310..8a24ed59ec46 100644
>> --- a/include/ufs/ufs.h
>> +++ b/include/ufs/ufs.h
>> @@ -385,8 +385,8 @@ enum {
>>=20
>>  /* Possible values for dExtendedUFSFeaturesSupport */  enum {
>> -=09UFS_DEV_LOW_TEMP_NOTIF=09=09=3D BIT(4),
>> -=09UFS_DEV_HIGH_TEMP_NOTIF=09=09=3D BIT(5),
>> +=09UFS_DEV_HIGH_TEMP_NOTIF=09=09=3D BIT(4),
>> +=09UFS_DEV_LOW_TEMP_NOTIF=09=09=3D BIT(5),
>>  =09UFS_DEV_EXT_TEMP_NOTIF=09=09=3D BIT(6),
>>  =09UFS_DEV_HPB_SUPPORT=09=09=3D BIT(7),
>>  =09UFS_DEV_WRITE_BOOSTER_SUP=09=3D BIT(8),
>> --
>> 2.25.1
>>=20
>>=20
>
