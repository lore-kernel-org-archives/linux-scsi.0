Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BC7282F5
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2025 06:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737699383; cv=none; b=iqLfVyTlGXmL6O+FN85PFsbre6HYgZFp1NWsi9CF5DN1V4wWZ5cmHhMkzw9I1IUXrngFJUzGgIsr4GrszSPQVwDASpewN4rHvDjTXtnQumYxbN4yUOK7eJ6wC9jo4GTNqNRJDfmnf7HtjY647L6FtlXzh77zyKGqDxXevjcTOeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737699383; c=relaxed/simple;
	bh=UilMh9SbX4NQuzHI58VTtAynTtkbzLheztbNESSsnw0=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=AqNZPkxNaPTfolhhbHEGTrwW1kRlAfC7Fu+AS64QLwHkL2eAPrTFbGgfmLWwLuUdauHYN2pKiXK0dedpR43QXKJDXcpbbXmuYmqGVLi6KekjEpcwm8Kil4BV0SX7K/s1MNA7BcVy4SkvuqzUspCz+YKcm5RPSeZYskE3wJylphk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PlDi/eJd; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PlDi/eJd"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250124061612epoutp032f8c8f394b9cb692fa7c05a0d981c394~djF9nHjEI0119901199epoutp03U
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jan 2025 06:16:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250124061612epoutp032f8c8f394b9cb692fa7c05a0d981c394~djF9nHjEI0119901199epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1737699372;
	bh=WIgo5MH6l08HeK8L3BrQuxcOQOWOwek6ssgRhrvqzlw=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=PlDi/eJdARMAxlz9MrIyQJl/b/5fMIAfoO5ea18ocGT7GdDnspfoLDIweENOP8nBO
	 1tHP4OI8Vd8kS+z27Ray0Hd42OWpNFXOj5K7HVTu5DnPiZEQieyt7Ljlhi8sKqw1X0
	 PcesuKeKCsBVqFNzIJG7a2Uv6gmV/Ew8d4wv2x7o=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTP id
	20250124061611epcas1p1a7cbace80344ee15f8dab4b5eb17bd69~djF9AqjNY1040610406epcas1p1L;
	Fri, 24 Jan 2025 06:16:11 +0000 (GMT)
Received: from epsmgec1p1-new.samsung.com (unknown [182.195.38.248]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4YfSHb3zWTz4x9Q1; Fri, 24 Jan
	2025 06:16:11 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmgec1p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.58.31735.B2033976; Fri, 24 Jan 2025 15:16:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250124061611epcas1p2ad34999373e7cb1677a663d348e0e49a~djF8L2Q252380423804epcas1p2P;
	Fri, 24 Jan 2025 06:16:11 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250124061611epsmtrp26a24dc56c418f230472610278c3cad72~djF8K6lLd1664516645epsmtrp21;
	Fri, 24 Jan 2025 06:16:11 +0000 (GMT)
X-AuditID: b6c32a4c-ad1fe70000007bf7-c9-6793302b1c50
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E4.EF.23488.A2033976; Fri, 24 Jan 2025 15:16:10 +0900 (KST)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250124061610epsmtip18cbf49a754f72770e3919e59e5523e53~djF76EIbP3135331353epsmtip1h;
	Fri, 24 Jan 2025 06:16:10 +0000 (GMT)
From: "DooHyun Hwang" <dh0421.hwang@samsung.com>
To: "'Bao D. Nguyen'" <quic_nguyenb@quicinc.com>, "'Avri Altman'"
	<Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<bvanassche@acm.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <peter.wang@mediatek.com>,
	<manivannan.sadhasivam@linaro.org>, <quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <6a49b676-e530-2320-9f53-c05597a56dac@quicinc.com>
Subject: RE: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Date: Fri, 24 Jan 2025 15:16:10 +0900
Message-ID: <006f01db6e27$768291d0$6387b570$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKQSHeU970FIzmh0/qkLVV+LAs8RgHb9Bl4AkEjfm8CcqkRDQJ9ENlZsXNUBVA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJJsWRmVeSWpSXmKPExsWy7bCmga62weR0g+frZC0ezNvGZvHy51U2
	i2kffjJbzDjVxmrx6+96douN/RwWHVsnM1nseH6G3WLX32Ymi8u75rBZdF/fwWZxt6WT1WL5
	8X9MFls//Wa1+Nb3hN1i6ovj7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/STkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRW
	KbUgJafArECvODG3uDQvXS8vtcTK0MDAyBSoMCE74/L7vewFy7gqjiw+ytjA2MvRxcjJISFg
	IvHtzwL2LkYuDiGBPYwSPcv6GCGcT4wS/Yc3s0A43xgldjz9xQjT8nvHLKiqvYwSK1tes0I4
	rxkljt6dD1bFJmAgMfnYGzaQhIjAJyaJ6dMegW1hFrjOKPHz3hcmkCpOAXuJaRuegXUIC3hJ
	3P93mQ3EZhFQlXj6tR3M5hWwlGj7uIoJwhaUODnzCQuIzSwgL7H97RxmiJsUJH4+XcYKYosI
	+ElcmHqcGaJGRGJ2ZxszyGIJgcmcEi/nnGaBaHCRWHP2NZQtLPHq+BZ2CFtK4vO7vWwQdrHE
	lXNnoewWRolHHRkQtr1Ec2szUJwDaIGmxPpd+hC7+CTefe1hBQlLCPBKdLQJQVSrSSz+9x3o
	RXYgW0aikRsi6iHxff859gmMirOQ/DULyV+zkNw/C2HVAkaWVYxSqQXFuempyYYFhrp5qeXw
	GE/Oz93ECE7zWj47GL+v/6t3iJGJg/EQowQHs5II7/8nE9KFeFMSK6tSi/Lji0pzUosPMZoC
	Q3sis5Rocj4w0+SVxBuaWBqYmBmZWBhbGpspifNe2NaSLiSQnliSmp2aWpBaBNPHxMEp1cBk
	1CSdXdXj4d6sxJO191XHKZPZFap6nXMS+Y+nsAS+vbfj0rPs5tnOP6MDiwwcevXfeoV1v+RY
	xTQxSk7K9nH5fgYv7W61pI0XZra9+Zm011jCXM5td4nByu1Rbx0mMszZu0CGJWf7haX3/HzF
	0wL9vZbdONHBwflKWXsad5K92eT9XJXxNw5NPNk30036YteUjCVf/ZNdz65+IDvf5JfVrZxr
	TqkLb0+dtWJD87Ra19l3FU3n+Yj/5ctw8ZFZnRXy9X9m/cmz253nnFt/+apdwofYXRM7U349
	v2DWfm7e55RJq1N/mwiXBARZxcxZUaRWJtRrGbGqe6ZL4/JDE67rLOc5OIntzo9Jd16vtWdQ
	YinOSDTUYi4qTgQAAjO8Z3wEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7bCSnK6WweR0gz+zrSwezNvGZvHy51U2
	i2kffjJbzDjVxmrx6+96douN/RwWHVsnM1nseH6G3WLX32Ymi8u75rBZdF/fwWZxt6WT1WL5
	8X9MFls//Wa1+Nb3hN1i6ovj7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZxWWTkpqTWZZapG+XwJVx+f1e9oJlXBVH
	Fh9lbGDs5ehi5OSQEDCR+L1jFmMXIxeHkMBuRonjs5azQSRkJLrv72XvYuQAsoUlDh8uhqh5
	ySix8n07O0gNm4CBxORjb9hAEiICf5gkZi8/xATiMAvcZ5RYtG0qO0TLASaJ1X+nMYK0cArY
	S0zb8AzMFhbwkrj/7zLYOhYBVYmnX9vBbF4BS4m2j6uYIGxBiZMzn7CA2MwC2hK9D1sZIWx5
	ie1v5zBDnKog8fPpMlYQW0TAT+LC1OPMEDUiErM725gnMArPQjJqFpJRs5CMmoWkZQEjyypG
	ydSC4tz03GTDAsO81HK94sTc4tK8dL3k/NxNjOBo19LYwfjuW5P+IUYmDsZDjBIczEoivP+f
	TEgX4k1JrKxKLcqPLyrNSS0+xCjNwaIkzrvSMCJdSCA9sSQ1OzW1ILUIJsvEwSnVwNRgnPzm
	HKfSAflL+9q4O2a/XrV2c6ShP+cc7wVy90zqWLlSmo7KHHD9e/HVFV2hrRzxX2dKLn4SGNz2
	O0/la4b5zLVJZ715Z17rqJ7/+9PtT1d/qHddkGo3/D2vJ87w/twS2Q+dAhZLP32wvB4gHlzt
	Yde2benjpPJAYceDRqLn0xY/vmXvkto+ye7Mtp7Dfklyt+2n7LgpLdxzfq35hq6U3109Kp4P
	K+60VE97wf/UO2jJ6+zFpz4V6oo23Ny/aF++z87O1P3nJxyLO9Hlc+Wb1o2TQUn3SmaIa+vb
	n9/yYNPrrxpP3tyNrhU89on94rI5S5wd2UJnnMrZMNsm7PTq9OauggZR60085+UOvGxQYinO
	SDTUYi4qTgQAlLnmXGUDAAA=
X-CMS-MailID: 20250124061611epcas1p2ad34999373e7cb1677a663d348e0e49a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250115022348epcas1p29705c109f51c01e1e91ef227233c7119
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>
	<20250115022344.3967-1-dh0421.hwang@samsung.com>
	<DM6PR04MB6575C2833DD66B847572F53CFC1A2@DM6PR04MB6575.namprd04.prod.outlook.com>
	<425301db67fd$5c27ca60$14775f20$@samsung.com>
	<6a49b676-e530-2320-9f53-c05597a56dac@quicinc.com>

On 1/16/2025 8:30 AM, Bao D. Nguyen wrote:
> On 1/16/2025 1:59 AM, DooHyun Hwang wrote:
> >>
> >>> It is found that is UFS device may take longer than 500ms(50ms *
> >>> 10times) to respond to NOP_OUT command.
> >>>
> >>> The NOP_OUT command timeout was total 500ms that is from a timeout
> >>> value of 50ms(defined by NOP_OUT_TIMEOUT) with 10 retries(defined by
> >>> NOP_OUT_RETRIES)
> >>>
> >>> This change increase the NOP_OUT command timeout to total 1000ms by
> >>> changing timeout value to 100ms(NOP_OUT_TIMEOUT)
> >>>
> >>> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
> >> Why not edit hba->nop_out_timeout in the .init vop?
> >> Like some vendors already do.
> >>
> >> Thanks,
> >> Avri
> >>
> > Thank you for your suggestion.
> > I'll fix that in .init vop as you said.
> >
> > And I'll reject this patch.
> Hi DooHyun Hwang,
> Since this is a common issue that multiple platform vendors have to fix in
> their vops, should we fix it in the common code instead?
> 
> Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>


This is already set to rejected state on patchwork.
Anyway, thank you for the review.

I thought it would be efficient to fix it in the common code.
I don't know which UFS devices have the same problem.

Thank you.
DooHyun Hwang.

