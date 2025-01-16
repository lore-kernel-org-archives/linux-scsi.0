Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830D728E0F
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 02:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736992963; cv=none; b=htyKgiT/8KzIYG71FIks1TB4QK+aZl3x0yhqd6Ky1jALQ1UCHHIGsutPVuz/XQnR5MeTefQvLOqKjgmd4F/2sYKQj1rtRqLEEzbhNv4qjW800zxR5wPe2SoQv2E6p+XNRvDslNTqGAgNMZL5ne0ZfKkw81J+7PF0lZ+ukDHtrGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736992963; c=relaxed/simple;
	bh=TmeFQHK641XTNGFf1orvcJbjvdJBV1DHE2xLt6IgCRk=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=pm0C8jJ1pfan7tCctvLiMiGeIYjVzvCzd31xcbIC1m5bassHJLv0vYiCAcq09b9XxhrQ21o5mqQKBt78dKSALOmqmrp75NYsk/xdMGonPersZoLT0SDopdXBVLvmDGIwuAjbO1ZHmPedxmSkB9bb5ay07ZH5pqLz8tCZIln3ETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Kma7SoG+; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Kma7SoG+"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250116020238epoutp01488b623bc6a2d6e1d7e4e9a2c2d65b3f~bCeR8xuFg1500315003epoutp01L
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 02:02:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250116020238epoutp01488b623bc6a2d6e1d7e4e9a2c2d65b3f~bCeR8xuFg1500315003epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1736992958;
	bh=EklwP6z+KF1bPV1sh4TEQfLm8IteL4uAIsMtfcY092Q=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=Kma7SoG+bLjILGSTmnjjmavZL45EDXAKuo04b7aB0B2JX9C1/AtIeX5GEVOmdxu78
	 xP+wIqjyjUFq8UxNIFqJocIUA7NdLNIIHCcHSYUMfzsinZPkphoCvIp9xoimluUPXf
	 iJphzISmu2MeTMQkkDQdRw86t6Tbvou/8E/ZRuPk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20250116020237epcas1p3d466b8dd566c65d52397ec9259586961~bCeRPDi8g3007430074epcas1p33;
	Thu, 16 Jan 2025 02:02:37 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.38.249]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4YYR2j010Nz4x9QQ; Thu, 16 Jan
	2025 02:02:37 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B2.97.23253.CB868876; Thu, 16 Jan 2025 11:02:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250116020236epcas1p22f7bc69166063c388a8d37ef06daf63d~bCeQNlbED0392903929epcas1p2B;
	Thu, 16 Jan 2025 02:02:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250116020236epsmtrp12384411aa6b8317e3751c086a5bbc89f~bCeQGSBPp2179621796epsmtrp1l;
	Thu, 16 Jan 2025 02:02:36 +0000 (GMT)
X-AuditID: b6c32a33-5a18170000005ad5-41-678868bc8bdb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	81.74.18729.CB868876; Thu, 16 Jan 2025 11:02:36 +0900 (KST)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250116020235epsmtip105e732e4b1e49adcaeb078bef5694059~bCeP1jkT-0253702537epsmtip1r;
	Thu, 16 Jan 2025 02:02:35 +0000 (GMT)
From: =?utf-8?Q?DooHyun_Hwang=28=ED=99=A9=EB=91=90=ED=98=84/Device_S/W_Sol?=
	=?utf-8?Q?ution_Lab.=28MX=29/=EC=82=BC=EC=84=B1=EC=A0=84=EC=9E=90=29?=
	<dh0421.hwang@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
	<manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <44520a93-a52e-4f88-8ca5-5f0fb38df607@acm.org>
Subject: RE: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Date: Thu, 16 Jan 2025 11:02:35 +0900
Message-ID: <351601db67ba$b67a54d0$236efe70$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKQSHeU970FIzmh0/qkLVV+LAs8RgHb9Bl4AZ1Y6qOxkxQXcA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJsWRmVeSWpSXmKPExsWy7bCmvu6ejI50g6PnLSwezNvGZvHy51U2
	i2kffjJbzDjVxmrx6+96douN/RwWHVsnM1nseH6G3WLX32Ymi8u75rBZdF/fwWZxt6WT1WL5
	8X9MFls//Wa1+Nb3hN2i6c8+FotrZ06wWmy+9I3FQcjj8hVvj2mTTrF53Lm2h82j5eR+Fo+P
	T2+xeEzcU+fRt2UVo8fnTXIe7Qe6mQI4o7JtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4DeUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQU
	mBXoFSfmFpfmpevlpZZYGRoYGJkCFSZkZ7Q0rWUu2C1acXzSc6YGximCXYycHBICJhJLN3Yw
	dTFycQgJ7GCUuPdwExuE84lR4l3TAqjMN0aJ+VduMMG0TGpcwgyR2MsocfDpEXYI5zWjRPPR
	2YwgDpvAJkaJrqNNrCCOiMAxJomWC6vBepgFrjNK/Lz3BWgYBwengLXEtjf8IHOFBbwk7v+7
	zAZiswioSmw5tgvM5hWwlNj2aB4rhC0ocXLmExYQm1lAW2LZwtfMEDcpSPx8ugysRkTASaLj
	+2Y2iBoRidmdbWB7JQSaOSX+nu1lg2hwkfgy8ydUs7DEq+Nb2CFsKYmX/W1QdrHElXNnoepb
	GCUedWRA2PYSza3NbCD3MwtoSqzfpQ+xi0/i3dceVpCwhACvREebEES1msTif9+BgcIOZMtI
	NHJDRD0kvu8/xz6BUXEWkr9mIflrFpL7ZyGsWsDIsopRLLWgODc9NdmwwBAe28n5uZsYwUld
	y3gH4+X5//QOMTJxMB5ilOBgVhLhXcLWmi7Em5JYWZValB9fVJqTWnyI0RQY0hOZpUST84F5
	Ja8k3tDE0sDEzMjEwtjS2ExJnPfCtpZ0IYH0xJLU7NTUgtQimD4mDk6pBqaGpXX7lJ+6LVGR
	e5uhnqBZ0rrhTN2635VFyyb837x0KbfR5XTVpcFms7YKWE8vFdbtObZv3tuK3tUpGRLNqRHz
	w2fUhfxJCPX8eWLGHI6WfI+X12ySjogf3MWy7RrDxOW74mO2PBfeEPPq6XZ3v5zLX/Pmerwq
	zDnGYrqnpq5+w+mvultXay0WejBN+tE3ycy4p6es04TyDtz9KJ7pIL+o++IvRbMy+y/FAWJ5
	e+/VrOBcaLlt46o6ppZoJoFTr56+uKjRNSPWxK1cfUbw3+Te6Z2hRr/Uz4WJnmQUW7x1xodJ
	lytfcRpwS2hm7fKompafZOIuYy38b5Ll5hZBpnmlIm8c7kzkPRAuOX3ityVKLMUZiYZazEXF
	iQBUuy1McwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSnO6ejI50gx8f2S0ezNvGZvHy51U2
	i2kffjJbzDjVxmrx6+96douN/RwWHVsnM1nseH6G3WLX32Ymi8u75rBZdF/fwWZxt6WT1WL5
	8X9MFls//Wa1+Nb3hN2i6c8+FotrZ06wWmy+9I3FQcjj8hVvj2mTTrF53Lm2h82j5eR+Fo+P
	T2+xeEzcU+fRt2UVo8fnTXIe7Qe6mQI4o7hsUlJzMstSi/TtErgyFu/axVQwUbTi88yvrA2M
	zwS6GDk5JARMJCY1LmHuYuTiEBLYzSix+NFjJoiEjET3/b3sXYwcQLawxOHDxRA1Lxklzq9r
	ZQdx2AQ2MEps/nuCDaRBROACk8TXVkuQBLPAfUaJRdumskO07GWUuLf4NxvIKE4Ba4ltb/hB
	GoQFvCTu/7sM1swioCqx5dguMJtXwFJi26N5rBC2oMTJmU9YQGxmAW2JpzefwtnLFr5mhrhU
	QeLn02WsEEc4SXR838wGUSMiMbuzjXkCo/AsJKNmIRk1C8moWUhaFjCyrGKUTC0ozk3PLTYs
	MMxLLdcrTswtLs1L10vOz93ECI5wLc0djNtXfdA7xMjEwXiIUYKDWUmEdwlba7oQb0piZVVq
	UX58UWlOavEhRmkOFiVxXvEXvSlCAumJJanZqakFqUUwWSYOTqkGJuHuf2vftG7V7FSXszKK
	t1u7/LET76pKjr/bs794v4l8+vn0F+nC/rP7dUMWXFJRyPhluGThLw/VbUbPWqRfpsz6nXL1
	0bwjR/vXWXbczvN9OiWuokNaacZbCZPvSyof8vk88WvNXyNmtPuBykserZy1cyzWLlgl7ifc
	ozZV/liM2gvPh4+LBMuOK6xKUNSJP6t0/Mzl2T2nvGc31mqXtQV2J13nXeNWmTxJ0c68pt0u
	eHn64gm9C4yFnq5VXCG0evYMi8JFcXocixjnaJ1OZS9N9Q3euX5yYOvXCTYPWNZu+/e7z4Mx
	+EvU3Sx3VXFOAbfrv5eIdQU+5q1Vf/3kscOR96zLS3Y/5TKcL+OxTImlOCPRUIu5qDgRAFRH
	gr5fAwAA
X-CMS-MailID: 20250116020236epcas1p22f7bc69166063c388a8d37ef06daf63d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250115022348epcas1p29705c109f51c01e1e91ef227233c7119
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
	<20250115022344.3967-1-dh0421.hwang@samsung.com>
	<44520a93-a52e-4f88-8ca5-5f0fb38df607@acm.org>

> On 1/14/25 6:23 PM, DooHyun Hwang wrote:
> > It is found that is UFS device may take longer than 500ms(50ms *
> > 10times) to respond to NOP_OUT command.
> >
> > The NOP_OUT command timeout was total 500ms that is from a timeout
> > value of 50ms(defined by NOP_OUT_TIMEOUT) with 10 retries(defined by
> > NOP_OUT_RETRIES)
> >
> > This change increase the NOP_OUT command timeout to total 1000ms by
> > changing timeout value to 100ms(NOP_OUT_TIMEOUT)
> >
> > Signed-off-by: DooHyun Hwang <dh0421.hwang=40samsung.com>
> > ---
> >   drivers/ufs/core/ufshcd.c =7C 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index cd404ade48dc..bf5c4620ef6b 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > =40=40 -57,8 +57,8 =40=40 enum =7B
> >   =7D;
> >   /* NOP OUT retries waiting for NOP IN response */
> >   =23define NOP_OUT_RETRIES    10
> > -/* Timeout after 50 msecs if NOP OUT hangs without response */
> > -=23define NOP_OUT_TIMEOUT    50 /* msecs */
> > +/* Timeout after 100 msecs if NOP OUT hangs without response */
> > +=23define NOP_OUT_TIMEOUT    100 /* msecs */
> >
> >   /* Query request retries */
> >   =23define QUERY_REQ_RETRIES 3
>=20
> The above change relies on all device management commands being issued
> with the same tag. If a single NOP OUT command may take longer than
> 500 ms, shouldn't NOP_OUT_TIMEOUT be increased to 1000 ms instead of
> 100 ms? The number of NOP OUT retries seems high to me and probably can b=
e
> reduced?
>=20
> Thanks,
>=20
> Bart.
I want to keep sending NOP_OUT commands repeatedly to get a response
from the UFS device, as per the existing method. To accommodate this method=
,
I propose increasing the total timeout duration by increasing the single ti=
meout
value(defined by NOP_OUT_TIMEOUT) from 50ms to 100ms rather than
increasing the timeout value(defined by NOP_OUT_TIMEOUT) from 50ms to 1000m=
s
or increasing the retry count value(defined by NOP_OUT_RETRIES).

This is time measurement log confirmed on a real device with NOP_OUT_TIMEOU=
T is 100ms

1. normal operation
=5B    2.010156=5D =5B6:  kworker/u18:0:   76=5D ufshcd-qcom 1d84000.ufshc:=
 =5BTEST=5D ufshcd_verify_dev_init: takes 1271 us, retries =3D 1 * 100ms.

2. issued log : exceeds 500ms
=5B    2.524525=5D =5B6:  kworker/u17:2:  141=5D ufshcd-qcom 1d84000.ufshc:=
 =5BTEST=5D ufshcd_verify_dev_init: takes 533000 us, retries =3D 6 * 100ms.

And a certain UFS vendor has confirmed that the response to NOP_OUT command
can be delayed by up to 540ms in certain circumstances on a specific model.

BR,
Thank you.
DooHyun Hwang.

