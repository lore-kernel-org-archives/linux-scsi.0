Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C72F1388
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 00:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725236857; cv=none; b=ICT9RBM+FqAtkF/efh8n0/C6BeSDKVHu5D933jo6VF6NOLotyIYZV+IrQNAcxSZRevU+Q1bFw9Fq0aYdrgbbDJNdchkQOQdgpJ1e0In2EjOOV0w0YVWgRif05zxODd3mtprUJ8PC6FyJN3mr+aO5eLdYgzdWzUzFI4Td7kSQif8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725236857; c=relaxed/simple;
	bh=cudBe4pfoHN4czpYxsfg3AspcCUWqKPE7BjUxyXeyjk=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=Q6weOtnNcrtnZXJ1DFE1vs/dt9OfjKMu97UGHUyeGAoA6uvUVlyQh6WcPlNFHmafR7yb+58f6ItiUdvW76g8Lc8gxUYj9K6K6PrrJoYOL/ISRpkpQzNvv9Alg8/7OHCL+eaCm42j2h6UBtT3zBYFrx9vCElj5AOaHleUGd+lenA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NKYJf1FJ; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NKYJf1FJ"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240902002725epoutp040a38b33615dc5cdf5d4b0fb4fdbc0b8f~xRcVF6wi03079530795epoutp04Y
	for <linux-scsi@vger.kernel.org>; Mon,  2 Sep 2024 00:27:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240902002725epoutp040a38b33615dc5cdf5d4b0fb4fdbc0b8f~xRcVF6wi03079530795epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725236845;
	bh=cudBe4pfoHN4czpYxsfg3AspcCUWqKPE7BjUxyXeyjk=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=NKYJf1FJAz52BtzlDo6hpz4doqoHP+2Ob4L8Rcej6sYCqQuCat8x9yjfXkjff7ErO
	 SCvtTWdOjHhzD9/wxjF65rJYI/O3TMjyS7SaMN7xpyyyyy6UDQV5R96CL46+3IAyWD
	 Acri43dgSWIT+iEnpjysNQ1f3GVo8SrwKt8FAeek=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240902002725epcas2p2fa2d58fe1bdf3e9d61f329b42310b8a0~xRcUkz9Pm2190721907epcas2p2_;
	Mon,  2 Sep 2024 00:27:25 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.90]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4WxqMc4bpNz4x9QX; Mon,  2 Sep
	2024 00:27:24 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.10.10431.C6605D66; Mon,  2 Sep 2024 09:27:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240902002723epcas2p259bc00c2020aa51df8c2c2bd34855e02~xRcTQQB0w2190721907epcas2p2y;
	Mon,  2 Sep 2024 00:27:23 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240902002723epsmtrp180081d2ed3858dbda9d1242ed3f48681~xRcTPPobN2457024570epsmtrp1_;
	Mon,  2 Sep 2024 00:27:23 +0000 (GMT)
X-AuditID: b6c32a45-ffffa700000028bf-6f-66d5066c5eba
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	03.D6.08456.B6605D66; Mon,  2 Sep 2024 09:27:23 +0900 (KST)
Received: from KORCO164647 (unknown [10.229.38.229]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240902002723epsmtip200308016616b66c605554c4770eea25c~xRcS9hYNI2791227912epsmtip2c;
	Mon,  2 Sep 2024 00:27:23 +0000 (GMT)
From: "Kiwoong Kim" <kwmad.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, "'Bean Huo'"
	<huobean@gmail.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<beanhuo@micron.com>, <adrian.hunter@intel.com>, <h10.kim@samsung.com>,
	<hy50.seo@samsung.com>, <sh425.lee@samsung.com>, <kwangwon.min@samsung.com>,
	<junwoo80.lee@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <2e7e0a2e-39e3-47d1-adc4-24b7e9761b5f@acm.org>
Subject: RE: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
Date: Mon, 2 Sep 2024 09:27:23 +0900
Message-ID: <004b01dafcce$e15186d0$a3f49470$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMVAzAZ81RvDzfQ3MBmGZ181G9RyALYKPinAVEwIPQBsz6+v6+gsTuw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te1BUdRTud+/lcteZxevK4xcxzXLRIWBYdpHHpXiaObdsjFGzopp1Yy8s
	sq/2Lo7V2DAhbwZJCmUDQWgRIQZFZZZVC5ZmyFEreSShvBpAl2YBe2DsBLXL3Yz/vnPO951z
	vt+DQEV38UAiR2tkDVqFmsI3Yd39YXSkGh/Jkv7RStE3Zr7C6akz3ThtXxnB6b7pUoyuWVpB
	6dV7d7zoutv5CN3ePIXRTaPdCG1dLUDoK6M9GD1krcPp8rsWnD43sIbQ5jUHRl8aXMZSSWZo
	eA/TYxr3Zpqv2RGmqqkXMI87S3Dm0ewYxlRebgPM713PMsW95Ui6ICM3UcUqlKxBzGozdcoc
	bXYStWe//EV5bJxUFilLoOMpsVahYZOoXa+mR+7OUbtsUOIjCnWeK5Wu4DgqKjnRoMszsmKV
	jjMmUaxeqdbH6yWcQsPlabMlWtb4vEwqjY51EQ/lqhY/n8T099Gjduccng8eIWVAQEAyBlqr
	zF5lYBMhIi0AnqpcRPjgNwCdNivgg2UAF2tvP5FcWDzjzReuA9hf0+eR2AG8tGxB3SycjIA1
	01fXG/uSAyh0NjtcEoIQkC/AX1pD3Zyt5H54tal5nY+R2+Df9VO4GwvJBLhQex7l8RZ4o3YG
	c2PU1bPl7K8ov4UYrsy2eLlb+pK74Td/0jzFF35RWoS6x0LyIQFnPpvw5vm7YMdQD8bjrXB+
	4LInHwjtJ4o8mIMdlhGEF+cD2D5/01PYAU1zxcA9DCXDYKc1yg0hGQK/HfOs5gNL+le9+bQQ
	lhSJeGEIdJ6sBjx+Gtb+fN/TkIE3vxsHVSDYtMGkaYNJ0wY3pv/nNgKsDfizek6TzXLRetmT
	y87UabrA+gsPf8kCqh1LEhtACGADkEApX6H52p0skVCp+OBD1qCTG/LULGcDsa5j/xQN9MvU
	ub6I1iiXxSRIY+LiZPHRsdJ4KkA4UVivFJHZCiOby7J61vCfDiEEgflIz87ktKLJoNKo5zK+
	rHn79Vdkx5YO+DepKwiH07zj8GCmZDrX6RCd27n9UGH7e6trxbCijTJdv3X28WbnYPT3B9+U
	nHLWBwcXZvnLUsUHA9KGqUz/vU+Be4Yfy/6Ktb7j46w+3NCXrjnaUOgTen7uZVP18A+bgx78
	JDeWhY7l2lOn1WG2SSJ5/EGjsHFfSM4zESffP7bQeXoAK09ruDJxK8HGLsuP10lM7/YxleaM
	17J1DaPkxb0Xvg5Gc1pUW1JblQGUPeyNxIKC48xbg35jqP7jfdtm/bwXUmoIx6j0QIR/smVp
	XvXRkX/gxZgGc8UJL06ABxV39Pd2fdKakvLQaQinME6lkIWjBk7xL9puf8BqBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWy7bCSvG4229U0g4YDWhYnn6xhs3gwbxub
	xcufV9ksDj7sZLGY9uEns8Xf2xdZLeacbWCyWL34AYvFohvbmCx2/W1msth6YyeLxeVdc9gs
	uq/vYLNYfvwfk8XSf29ZLDZf+sbiIOBx+Yq3x85Zd9k9Fu95yeQxYdEBRo/v6zvYPD4+vcXi
	0bdlFaPH501yHu0HupkCOKO4bFJSczLLUov07RK4Mh72f2UruM9c8X/eN9YGxk9MXYycHBIC
	JhIb3s9j72Lk4hAS2M0oMf3sHKiEpMSJnc8ZIWxhifstR1ghip4zSuye8hOsiE1AW2Law91g
	CRGBm8wSe7e+har6wijx9NUali5GDg5OAWuJRyvUQRqEBQIl1vZ/ApvKIqAi8WfuAzYQm1fA
	UuLdzJXMELagxMmZT1hAbGagBb0PWxlh7GULXzNDXKQg8fPpMlaQ8SICbhL7v1pAlIhIzO5s
	Y57AKDQLyaRZSCbNQjJpFpKWBYwsqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxguNW
	S2sH455VH/QOMTJxMB5ilOBgVhLhXbrnYpoQb0piZVVqUX58UWlOavEhRmkOFiVx3m+ve1OE
	BNITS1KzU1MLUotgskwcnFINTG6ibZb7Za8+3P6OO+Ckq0GM5qVPH3eKOq8TlutrZ3e6oKL+
	/sF19xUO39TNn/R6/vls/Ljp2fv0Erei5onLGVieMdxlO9WrtTb/ZU2Li8BiLYHzs4XfXn/Q
	tm9dxiv5iMa+ni3FtfHz6ud87urTP7Jq9pOCe9s2JN647ynx4HdRtNpHkd7DjyPO8jQm7V67
	xCL3F7N7Wf/r21zl727Lvb3d4uLqFpXWGnQlP8zg+91urtWZr7cryJ+7Lvwjhbvj1DLz+Zsq
	i0/fdb0waa07g1upecaGreX6nvcuBwgI3HzU+352+qR/Dx6v3eqUtF1jUVDdJO9Vp7aETQ6/
	f/aB5M5X+sd3TDE5P8Hy4vtPMdlKLMUZiYZazEXFiQD42GZySgMAAA==
X-CMS-MailID: 20240902002723epcas2p259bc00c2020aa51df8c2c2bd34855e02
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240822111247epcas2p2d3051255f42af05fd049b7247c395da4
References: <CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
	<cover.1724325280.git.kwmad.kim@samsung.com>
	<04306da77d74e16edab1d682a8602f61b35025a3.camel@gmail.com>
	<2e7e0a2e-39e3-47d1-adc4-24b7e9761b5f@acm.org>

> > I wonder if you have considered the case where the command is aborted
> > by the host software or by the device itself?
> >
> > If you change OCS to OCS_INVALID_COMMAND_STATUS, there will report a
> > DID_REQUEUE to SCSI.
>=20
> The decision about what to do probably should depend on whether or not
> the command has been nullified.
>=20
> Thanks,
>=20
> Bart.

When MCQ is enabled, Exynos host reports OCS_ABORTED only for nullified cas=
es.

Thanks.

