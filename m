Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20E04C76
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2025 02:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737166605; cv=none; b=uJc9RAwHH9xTiQQrET2nUtU7Ocl6MmG1Xz6okeR8qByHqFfriCftqItRn3nzIoQd4T52jkk+/mDf6TK3cKL/P0xCIAgnLry5JpQNCtTBPDkx/0uB4Pdztf1Nh6jpI/CWhIlTxbE+mIdmOj+DfLdrSmecvl7tMlivU6xBSTzyFRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737166605; c=relaxed/simple;
	bh=PA2j4PXn+SZaNvjJCSwPWV3ajxxzrNN8EF80U7iEkWU=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=ANUwrQR8SXLy8CAnGe/DpjFPyy5NcJOI9F8DhxQvUKIZaTONo1Ukfzpb8Sz8ofE+DGoRLq/ltxkuheJceirU/+1/mlY/lyIsN5ZHpF83XjJXOfTnE8WLFihoohw0AjdJ9EDpIzY1D4Tiub4mj98RvXycbonOpUGjyPvwlrsMQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BNNwCLLa; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BNNwCLLa"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250118021633epoutp0404540e9152bf76ffcd85a041422d887f~bp9AyQ5S_0341903419epoutp04e
	for <linux-scsi@vger.kernel.org>; Sat, 18 Jan 2025 02:16:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250118021633epoutp0404540e9152bf76ffcd85a041422d887f~bp9AyQ5S_0341903419epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1737166593;
	bh=hry7ebK+dZT8622vI6btVyWNt3LPeD0KZdrI0+uLYE8=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=BNNwCLLavUR2h+yz2WpZ1dHyu7H90JBAZ3fqt1K36Fet6iF2lc8Ics90p9rCYmKAT
	 rgGA/PpAB9wyr6lD/MMhnaj7WU+QQ/SrmZyshJuka1ByF2XzOkzwqxoXAllnceedqO
	 yP8586CzEnB9OacDFsfJFfWGk2jHAx2qel26hvRY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20250118021633epcas1p3fc069e9d20b3dfd5aa3fbc858a6a830c~bp9AeYSwG1111711117epcas1p3q;
	Sat, 18 Jan 2025 02:16:33 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.36.224]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YZgFs1Yn9z4x9Pp; Sat, 18 Jan
	2025 02:16:33 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
	5E.29.23425.10F0B876; Sat, 18 Jan 2025 11:16:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250118021632epcas1p40b7b55527cdb5ffda7b0fb497ca9d525~bp8-r3Hp_0937109371epcas1p4_;
	Sat, 18 Jan 2025 02:16:32 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250118021632epsmtrp29aea4f37aa81ece4cfebdb7b82bc8b6d~bp8-rVJTy1164411644epsmtrp2Z;
	Sat, 18 Jan 2025 02:16:32 +0000 (GMT)
X-AuditID: b6c32a39-973e970000005b81-2a-678b0f01966d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6A.58.18949.00F0B876; Sat, 18 Jan 2025 11:16:32 +0900 (KST)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250118021632epsmtip113247e65ce7bf15b8a630b93c0f556c8~bp8-hGq7Z0759807598epsmtip1O;
	Sat, 18 Jan 2025 02:16:32 +0000 (GMT)
From: =?utf-8?B?7J207Iq57Z2s?= <sh043.lee@samsung.com>
To: "'Bean Huo'" <huobean@gmail.com>, <linux-scsi@vger.kernel.org>
In-Reply-To: <478fd574de9b6059061ea9112aea2c1542c61b59.camel@gmail.com>
Subject: RE: [PATCH] scsi: ufs: core: Fix error return with query response
Date: Sat, 18 Jan 2025 11:16:32 +0900
Message-ID: <000101db694e$fde3c550$f9ab4ff0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQFFMZX7mslXVJs3Rj22MiNMunAHGAKXNj9MAXkV2Ly0J7edAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmni4jf3e6wYzl7BZzzjYwWXRf38Hm
	wOSxc9Zddo/Pm+QCmKKybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
	lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswK9IoTc4tL89L1
	8lJLrAwNDIxMgQoTsjNmn9vMVNDOX/H38zSmBsZ7XF2MnBwSAiYSx54dZepi5OIQEtjBKHHh
	TTsrhPOJUeLPnnaozDegzMNv7DAt1980MEIk9jJK9PWugmp5wSjx+OQ8oBYODjYBM4nnd4JA
	TBEBJ4nfh2xBejkF3CXePt/HCGILC3hJPJs2kxnEZhFQlbi65wYriM0rYCkxZcUHZghbUOLk
	zCcsIDazgLzE9rdzmCFuUJD4+XQZK0RcRGJ2ZxtYHGTVnaVHwW6TEDjHLvHuxnw2kBskBFwk
	7s01g+gVlnh1fAvUL1ISn9/tZYOob2aUaGv4ygLhTGCUeLHgFRNElb1Ec2sz2CBmAU2J9bv0
	IRbzSbz72sMKMZ9XoqNNCKJaWeLlo2VQnZISS9pvQd3sITHx8StouJ1mlFgx7T3bBEaFWUj+
	nIXkz1lIfpuFsHkBI8sqRrHUguLc9NRiwwJTeGwn5+duYgQnPS3LHYzT337QO8TIxMF4iFGC
	g1lJhDftd0e6EG9KYmVValF+fFFpTmrxIUZTYMhPZJYSTc4Hpt28knhDE0sDEzMjEwtjS2Mz
	JXHeC9ta0oUE0hNLUrNTUwtSi2D6mDg4pRqYNixq3M+34G/Td9GMYLlSty+Foad4wiQXctyP
	ZWWrm3n7Y2sHT4XgXP+IhZ+9Lm3/Ede3taBfWZqTkUHZxX97U2/Ht/0vPx05PeNHEf8s3drI
	pun3jjy40qjs0GOWuuSLtceUvXxOSj0PVR99O1cVol6T4t0u4aIfarLF/ff+w/x6J/bpqTe6
	ZMjm716pElS3TXCKUDjDZMkzvBfrMs4uXKhxb8a9rzrzl6QnNGxnTGFgKgcm/k0m2960TTY6
	8kNHzPMN+7VVEv9uP8u3T3wQWuPrYfbxst4PhcJr8SpbzEUWcjDNP1W5O9B8c07l3p9rpBgZ
	X/EIlOonVxTm8jGZFgonTlGb96g4f5KRuxJLcUaioRZzUXEiAPm8RlIDBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSnC4Df3e6wdbN6hZzzjYwWXRf38Hm
	wOSxc9Zddo/Pm+QCmKK4bFJSczLLUov07RK4Mmaf28xU0M5f8ffzNKYGxntcXYycHBICJhLX
	3zQwdjFycQgJ7GaUWLbtGxNEQlJi8aOHbF2MHEC2sMThw8UQNc8YJVb83sgMEmcTMJN4ficI
	pFxEwEVi+5oeZoia44wSp+bcAZvDKeAu8fb5PkYQW1jAS+LZtJnMIDaLgKrE1T03WEFsXgFL
	iSkrPjBD2IISJ2c+YQGxmQW0JZ7efAply0tsfzuHGeI2BYmfT5exQsRFJGZ3tjFDHOEkcWfp
	UcYJjEKzkIyahWTULCSjZiFpX8DIsopRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjI
	tbR2MO5Z9UHvECMTB+MhRgkOZiUR3rTfHelCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb+97k0R
	EkhPLEnNTk0tSC2CyTJxcEo1MEllG1QzFrt+2/NY3M31n2CdBd+cwAqxVxrBZ5Mf9cj+ZFjx
	it/KpT/mh0JWZMqL5v953hpMVd4/cnbs/76I+YyWd5xF3Lm6GUst/0xgWXbaYGLs0wT7iLjJ
	a5Nt/rHe67VMtX/LtfKJutbjTWWFpXqZKSufPuzedWSfW9ov77iHt7yuuU4Vvb1AYN76bbaz
	+ton7k3SZjC4u7ks22LTZ9Ndenf3/117UeDLS193Jp//W9v6t64NTS39oRelG2YT13fr0qb8
	8D+7An6kJOpuF953MNypynTpKzvNZVsELRbwHFJ9XyvZxemtkWScMiUptHBl+XTXSx96DzLc
	6JCdKjKt+dT69byzQv7uXDZbVImlOCPRUIu5qDgRACrQA5bhAgAA
X-CMS-MailID: 20250118021632epcas1p40b7b55527cdb5ffda7b0fb497ca9d525
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5
References: <CGME20250117071604epcas1p44c7f7898b826ad8762cfdd79aa31bbf5@epcas1p4.samsung.com>
	<20250117071600.19369-1-sh043.lee@samsung.com>
	<478fd574de9b6059061ea9112aea2c1542c61b59.camel@gmail.com>

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: Friday, January 17, 2025 7:47 PM
> To: Seunghui Lee <sh043.lee@samsung.com>; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] scsi: ufs: core: Fix error return with query response
> 
> On Fri, 2025-01-17 at 16:16 +0900, Seunghui Lee wrote:
> > There is currently no mechanism to return error from query responses.
> > Return the error and print the corresponding error message with it.
> >
> > Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
> > ---
> >  drivers/ufs/core/ufshcd.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 9c26e8767515..6b27ea1a7a1b 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -3118,8 +3118,13 @@ ufshcd_dev_cmd_completion(struct ufs_hba *hba,
> > struct ufshcd_lrb *lrbp)
> >         case UPIU_TRANSACTION_QUERY_RSP: {
> >                 u8 response = lrbp->ucd_rsp_ptr->header.response;
> >
> > -               if (response == 0)
> > +               if (response == 0) {
> >                         err = ufshcd_copy_query_response(hba, lrbp);
> > +               } else {
> > +                       err = -EINVAL;
> > +                       dev_err(hba->dev, "%s: unexpected response
> > %x\n",
> > +                                       __func__, resp);
> > +               }
> >                 break;
> >         }
> >         case UPIU_TRANSACTION_REJECT_UPIU:
> 
> 
> 
> There is a confusing mix of UPIU transaction code and response in UPIU
> here, I think you want to print "response" instead of transaction code.
> 
> dev_err(hba->dev, "%s: Unexpected response in Query RSP: %x\n", __func__,
> response);
> 
> 

I think that your suggestion is much better.
I'll modify this as your suggestion with v2.
Thank you.


