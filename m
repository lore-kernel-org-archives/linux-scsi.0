Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139C1D9A49
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 09:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737021588; cv=none; b=BseSJmR+yjRK2rQPiASqeTbu9iPzXQEfn74FXw2FZvqRJxwN5ua3ZLOkaZ7wg1WCwh2R827YYn/UikrPU8ayk1qmHmVP9M2LwTP/2bTg4Ix0/bzbKjrK8lrDkVC3w9//zzP07DqKs/XLFeqTSgCLYg4hEdhEPHcoKmMEoialnmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737021588; c=relaxed/simple;
	bh=IlCw8fA1nxfVSyN5MLWPc9yR25fLVVn+3/t0RHnWbGI=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=PmMFfcF3uYx36QJ7fUfodCG+/4kxY70EWjg08wDxWKzm0+T7zhLQVKJqRqynUyLzjXxQCg9z++b3uhJOx059QLUbz0/pBki7jETqokJFUV5sEcJIC3sxFGb+IEJuFRQ07FSe4PsMfUsaTjqU3fmV8VzrJ+ggR4Oz3uAciH7xxzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZsypRApX; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZsypRApX"
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250116095943epoutp0115f88755f00f4d0db9ed6b652594f2c0~bI_1Fv_yk0581005810epoutp01Q
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 09:59:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250116095943epoutp0115f88755f00f4d0db9ed6b652594f2c0~bI_1Fv_yk0581005810epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1737021583;
	bh=2l0kxbwZVaqgJTX0w16kLUp1PZkCVaeSLxiwlkySHoA=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=ZsypRApXyD+JHL5R23S0W7/tanL9uTbISmOnAKGrPeV1tMc5baCP1+KhdRoXlo7RG
	 PcZTFzYUrR3LF4zxA9IMf0YGPMXEQnl7PVnBYo0x1enjQlEuibvPEeI0IlaeQ9coLb
	 wlnSU31M0GDxifIYk+j9dwlsd7pmgvrnk37KlvjA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20250116095942epcas1p2c23c89935977f40e49df25bef1da87f4~bI_0a6mPJ1492014920epcas1p2S;
	Thu, 16 Jan 2025 09:59:42 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.36.225]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4YYddB1L24z4x9Px; Thu, 16 Jan
	2025 09:59:42 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	6C.DE.24218.E88D8876; Thu, 16 Jan 2025 18:59:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250116095941epcas1p42b54034c1afd7e1d261ef84a1425e498~bI_y-CZIw0721107211epcas1p4S;
	Thu, 16 Jan 2025 09:59:41 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250116095940epsmtrp2c565b5e11dd6d52e2ad4d57e602f22a2~bI_y97hUv2160421604epsmtrp26;
	Thu, 16 Jan 2025 09:59:40 +0000 (GMT)
X-AuditID: b6c32a38-56bff70000005e9a-a5-6788d88e3b34
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	85.7B.18729.C88D8876; Thu, 16 Jan 2025 18:59:40 +0900 (KST)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250116095940epsmtip187af124efb13243c90760aa3bbd9cbc1~bI_yu6cCA0721507215epsmtip1Y;
	Thu, 16 Jan 2025 09:59:40 +0000 (GMT)
From: "DooHyun Hwang" <dh0421.hwang@samsung.com>
To: "'Avri Altman'" <Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<bvanassche@acm.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
	<manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <DM6PR04MB6575C2833DD66B847572F53CFC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Date: Thu, 16 Jan 2025 18:59:40 +0900
Message-ID: <425301db67fd$5c27ca60$14775f20$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKQSHeU970FIzmh0/qkLVV+LAs8RgHb9Bl4AkEjfm+xjn960A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJsWRmVeSWpSXmKPExsWy7bCmgW7fjY50g0vv2SwezNvGZvHy51U2
	i2kffjJbzDjVxmrx6+96douN/RwWHVsnM1nseH6G3WLX32Ymi8u75rBZdF/fwWZxt6WT1WL5
	8X9MFls//Wa1+Nb3hN2i6c8+FotrZ06wWmy+9I3FQcjj8hVvj2mTTrF53Lm2h82j5eR+Fo+P
	T2+xeEzcU+fRt2UVo8fnTXIe7Qe6mQI4o7JtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4DeUVIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQU
	mBXoFSfmFpfmpevlpZZYGRoYGJkCFSZkZzRM+s1e8Jq7YtnR7AbGWZxdjBwcEgImEm9nlXcx
	cnEICexglFiz7hszhPOJUWLPx9dQzjdGidVLd7F2MXKCdew5vpgFIrGXUeL9tzmsEM5rRokz
	7c3MIFVsAgYSk4+9YQNJiAgcYpJYtnsyI4jDLHCdUeLnvS9MINs5BWIl3r5TBmkQFvCSuP/v
	MhuIzSKgKjFj9iewdbwClhIrD+xghLAFJU7OfMICYjMLyEtsfzuHGeIkBYmfT5exgowUEXCS
	6PxSBFEiIjG7sw3sBQmBZk6JNe9OM0HUu0j8f9vFBmELS7w6voUdwpaS+PxuL1S8WOLKubNQ
	dgujxKOODAjbXqK5tZkNZBezgKbE+l36ELv4JN597WGFhCmvREebEES1msTif9+BrmcHsmUk
	Grkhoh4S3/efY5/AqDgLyVuzkLw1C8n9sxBWLWBkWcUollpQnJueWmxYYAKP6eT83E2M4GSu
	ZbGDce7bD3qHGJk4GA8xSnAwK4nwLmFrTRfiTUmsrEotyo8vKs1JLT7EaAoM6InMUqLJ+cB8
	klcSb2hiaWBiZmRiYWxpbKYkznthW0u6kEB6YklqdmpqQWoRTB8TB6dUA5PVipt8Arc7D+5I
	3yWZmPZj2odd+qoZir9kKq4a6y7ze1e+TvdA4GXvV6emnL//NW7fnRmibBe+HzV4YRQX+adK
	9MMrifcvnofb3UyZJjrd1DH9YFA31yvziXdyc9s1f869Yi+v+yU9l8c4i1VwjhxD9hYrAa9o
	mQ+ahTuXvvr2qNhNLmbW36OxyoYKr36cn/HdT0ttXbND/qNF4jZcl06uZDp7r/9NJ9vm4km1
	DqKN/a3BjZvSwh4lHpy37Fqmxewtq5Y1T365c8HEPP4gth3qO0/OuhPY/+LR3MxWtt7bqwRL
	dxieibT+rOjkLqOTKGT0uX+NrJ3OLy++zsja9YffpbbP2jnXqKk5+NEN0zglluKMREMt5qLi
	RAAOL+nlbwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWy7bCSnG7PjY50g0tXzCwezNvGZvHy51U2
	i2kffjJbzDjVxmrx6+96douN/RwWHVsnM1nseH6G3WLX32Ymi8u75rBZdF/fwWZxt6WT1WL5
	8X9MFls//Wa1+Nb3hN2i6c8+FotrZ06wWmy+9I3FQcjj8hVvj2mTTrF53Lm2h82j5eR+Fo+P
	T2+xeEzcU+fRt2UVo8fnTXIe7Qe6mQI4o7hsUlJzMstSi/TtErgyGib9Zi94zV2x7Gh2A+Ms
	zi5GTg4JAROJPccXs3QxcnEICexmlDh5dQUbREJGovv+XvYuRg4gW1ji8OFiiJqXjBKzJy9j
	BalhEzCQmHzsDVi9iMAZJonuNzogRcwC9xklFm2byg6SEAJxDv8xAxnEKRAr8fadMkhYWMBL
	4v6/y2C9LAKqEjNmfwKbyStgKbHywA5GCFtQ4uTMJywgNrOAtsTTm0+hbHmJ7W/nMEPcqSDx
	8ynIPRxANzhJdH4pgigRkZjd2cY8gVF4FpJJs5BMmoVk0iwkLQsYWVYxSqYWFOem5xYbFhjm
	pZbrFSfmFpfmpesl5+duYgRHtpbmDsbtqz7oHWJk4mA8xCjBwawkwruErTVdiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOK/4i94UIYH0xJLU7NTUgtQimCwTB6dUA5MZS85nayfxx/OO3ZfSnirT
	XVlxOn6Kjo7ovNjLsVeS5Iz6e+04Zq11eDZzFT+fzu8XbyvN2T1PdrkFb/7WqJcb8q5qyq3H
	eeo/Olc1GibZCv+bf2LVikVvX7gvD43d9apT/M0N/lU6N3/XSZQ+rTrzQ9k8MWmhoMpRO6O5
	En3abDNS1eQtF77cu2BVbcrNG+ltGRvPx69cYON276fdibVcbCs3Wdl+NHwsobRp38XCgrYn
	FuaXo44lHChatnZB8BzPrItBpyYJ/nXucXtyh3POBLXHTX0r5MJWLiv52HX1jm6cWvyX9Qut
	BTOsV8/ZUiD3ovaDnN7qxbkF9t1/9jsxlmS37G6Jub3o9xOu/l9KLMUZiYZazEXFiQCj14Y8
	WwMAAA==
X-CMS-MailID: 20250116095941epcas1p42b54034c1afd7e1d261ef84a1425e498
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250115022348epcas1p29705c109f51c01e1e91ef227233c7119
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
	<20250115022344.3967-1-dh0421.hwang@samsung.com>
	<DM6PR04MB6575C2833DD66B847572F53CFC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>

> 
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
> > Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
> Why not edit hba->nop_out_timeout in the .init vop?
> Like some vendors already do.
> 
> Thanks,
> Avri
> 
Thank you for your suggestion.
I'll fix that in .init vop as you said.

And I'll reject this patch.

BR,
Thank you.
DooHyun Hwang.

> > ---
> >  drivers/ufs/core/ufshcd.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index cd404ade48dc..bf5c4620ef6b 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -57,8 +57,8 @@ enum {
> >  };
> >  /* NOP OUT retries waiting for NOP IN response */
> >  #define NOP_OUT_RETRIES    10
> > -/* Timeout after 50 msecs if NOP OUT hangs without response */
> > -#define NOP_OUT_TIMEOUT    50 /* msecs */
> > +/* Timeout after 100 msecs if NOP OUT hangs without response */
> > +#define NOP_OUT_TIMEOUT    100 /* msecs */
> >
> >  /* Query request retries */
> >  #define QUERY_REQ_RETRIES 3
> > --
> > 2.48.0
> >


