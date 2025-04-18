Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B6F1DA21
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2025 04:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744951739; cv=none; b=Tipu9fHLIrU+GwRcFHmNnKBouAbTdkn42+zWW6dy4jAm/3RnTL8q7+3j1Hl9j7aokB+P7vyb5zHaVJeUxJVZLCIMtvS1yyX1LAGO31YtVLDfGTB8C1PnDe3P42UcZ1PBSggVVkoO2DBUiZFF8ny6cPGtv4Xnb53P/rnKUtavG+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744951739; c=relaxed/simple;
	bh=Vx9jz1zUWuMVqiOGM+dVKc3TQBEl7E+SyT+EDrvlm1Q=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=l7Vhr2HYnplFQRYTjtMVqNfAp5gfvyPwJP4SPm7pUQVZD5Jjp8fp2W4KBhkCUGtu8K4wdnekjejfRydJDHb4t6XLeFvmpRFOkpk9mOfW94fgXJyIunAnjYqFc+A63NUeMVBTWqswqgI7h3vQ4HDbEnEejiQo4pZcPFcucczc6tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bCJqCyWe; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bCJqCyWe"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250418044855epoutp0277e58d93d222a66b2cd939023a512746~3UFu1TNd52158321583epoutp023
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2025 04:48:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250418044855epoutp0277e58d93d222a66b2cd939023a512746~3UFu1TNd52158321583epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744951735;
	bh=obxaqcfMZ8QlNe2fgyNBHlsHe9cW48zZiyv7HWZT0Cw=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=bCJqCyWeNWmyXWNe8VMzhd/21h632z3lRfHIvQgtDWD3OG3a59rZ5JGbNs3pDabYz
	 s2TzqBNF5ovzMO+Qm6Dp9X+7Y5kYjTsvCZKQSA5lgw2IrsU7YkPBB/lgtIFj0/+8vq
	 /H/egyzspSz41N2IDdgfsjJpjMfYfNcCk/pBBR2U=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20250418044854epcas1p16697f303759a9be299445aa8e613a837~3UFuFye8_0986609866epcas1p1y;
	Fri, 18 Apr 2025 04:48:54 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.36.224]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4Zf2N608Nyz6B9mN; Fri, 18 Apr
	2025 04:48:54 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20250418044853epcas1p38ded689388f26c3df5930550db0a13a7~3UFs30Pc41069610696epcas1p3k;
	Fri, 18 Apr 2025 04:48:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250418044853epsmtrp264fcd61e25c0523ab81021e7ed57d519~3UFs24oqq2067220672epsmtrp2G;
	Fri, 18 Apr 2025 04:48:53 +0000 (GMT)
X-AuditID: b6c32a29-55afd7000000223e-33-6801d9b524aa
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9D.A0.08766.5B9D1086; Fri, 18 Apr 2025 13:48:53 +0900 (KST)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250418044853epsmtip1b93fcc5ebf99d6186af71c304403aa4a~3UFsloUUW1455314553epsmtip1M;
	Fri, 18 Apr 2025 04:48:53 +0000 (GMT)
From: "DooHyun Hwang" <dh0421.hwang@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
	<manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <17781804-d36f-41c2-a858-1edf905ca8ac@acm.org>
Subject: RE: [PATCH 2/2] scsi: ufs: core: Add a trace function calling when
 uic command error occurs
Date: Fri, 18 Apr 2025 13:48:52 +0900
Message-ID: <0ed401dbb01d$2f487720$8dd96560$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEmYeTjtFjYRI1QNWxgWL0Y7ybfIwLekswsAdKaXvgB7EVFwrTeiuPg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSnO7Wm4wZBtsX8Fk8mLeNzeLlz6ts
	FtM+/GS2mHGqjdXi19/17BYb+zksOrZOZrLY8fwMu8Wuv81MFpd3zWGz6L6+g83ibksnq8Xy
	4/+YLLZ++s1q8a3vCbtF0599LBbXzpxgtdh86RuLg5DH5SveHtMmnWLzuHNtD5tHy8n9LB4f
	n95i8Zi4p86jb8sqRo/Pm+Q82g90MwVwRnHZpKTmZJalFunbJXBlNPU/Yy5YxVdx/cJSlgbG
	PdxdjJwcEgImEhs/nmTpYuTiEBLYzShx/8QVVoiEjET3/b3sXYwcQLawxOHDxRA1Lxklpk2Z
	C1bDJmAgMfnYGzYQW0TgApPE11ZLkCJmgfuMEou2TWWH6HgH5Dy6wAxSxSlgLTHv6guwbmGB
	FInZUz6wg9gsAqoSV45vB5vEK2Apsb7zOzOELShxcuYTFhCbWUBb4unNp3D2soWvmSEuVZD4
	+XQZK8QVbhKb1vUwQdSISMzubGOewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sNCwzz
	Usv1ihNzi0vz0vWS83M3MYIjXEtzB+P2VR/0DjEycTAeYpTgYFYS4T1n/i9diDclsbIqtSg/
	vqg0J7X4EKM0B4uSOK/4i94UIYH0xJLU7NTUgtQimCwTB6dUA1OdnaPv42c6143/8l0NVDil
	FOYQWFVZp9Cy5I9+ZWWdi0ajx9/NT1axPN0m9VPPcpk4/7rlxVn+71+ZpPPGCuZPMpTxfFX9
	VZRR/8Odsv/+j3j1pE+ylbE9vHvOdJuDS2J6SFyxuEJSVatj7+GYq9/z5mS9uBm+YM0h0aXX
	JL6v87AzV3CK55gjlWw/+f+82LqnzOKG9tJNt0Q4l3DtS+Vl+BGeP+vzzk0TzFtuHGX9GmGl
	75cp8/GzlgT3UbF/cl7J+46v3/JWtPnfgfzNjtdWRwV9N3+006/jkHeWXRnf1CsXM98vn8Pj
	6ra7ZeKm4Ll3+mT2zp25sGMmt9VliW/HEoqvG6+9N8lxjcJkPyWW4oxEQy3mouJEAK+K2IRf
	AwAA
X-CMS-MailID: 20250418044853epcas1p38ded689388f26c3df5930550db0a13a7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023419epcas1p343060855c4470f8056116a207a584956
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023419epcas1p343060855c4470f8056116a207a584956@epcas1p3.samsung.com>
	<20250417023405.6954-3-dh0421.hwang@samsung.com>
	<17781804-d36f-41c2-a858-1edf905ca8ac@acm.org>

> On 4/16/25 7:34 PM, DooHyun Hwang wrote:
> > When a uic command error occurs, there is no trace function calling.
> > Therefore, trace function calls are added when a uic command error
> happens.
> >
> > Signed-off-by: DooHyun Hwang <dh0421.hwang=40samsung.com>
> > ---
> >   drivers/ufs/core/ufshcd.c =7C 5 +++++
> >   1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index ab98acd982b5..baac1ae94efc 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > =40=40 -2534,6 +2534,9 =40=40 ufshcd_wait_for_uic_cmd(struct ufs_hba *h=
ba,
> struct uic_command *uic_cmd)
> >   	hba->active_uic_cmd =3D NULL;
> >   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >
> > +	if (ret)
> > +		ufshcd_add_uic_command_trace(hba, uic_cmd, UFS_CMD_ERR);
> > +
> >   	return ret;
> >   =7D
> >
> > =40=40 -4306,6 +4309,8 =40=40 static int ufshcd_uic_pwr_ctrl(struct ufs=
_hba *hba,
> struct uic_command *cmd)
> >   	=7D
> >   out:
> >   	if (ret) =7B
> > +		ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
> > +					     UFS_CMD_ERR);
> >   		ufshcd_print_host_state(hba);
> >   		ufshcd_print_pwr_info(hba);
> >   		ufshcd_print_evt_hist(hba);
>=20
> Shouldn't the value of 'ret' be included in the UFS_CMD_ERR trace output?
>=20
> Thanks,
>=20
> Bart.
Thank you for your insightful feedback.

Upon further consideration, it seems that the existing trace, which capture=
s detailed information through the UICCMDARG1 to UICCMDARG3 fields.
That already provides sufficient context for analyzing command-related issu=
es.
The UFS_CMD_ERR trace output, combined with UICCMDARG* values, should be ad=
equate for diagnosing errors and understanding the command's execution stat=
us.

BR,
Thank you.
DooHyun Hwang.

