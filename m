Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBBA218845
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 08:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744878112; cv=none; b=iPXiZ3uzroKhA7omJMd8YHrB+F/NX2hW40e/HzdYw1IRcC26JMPymRXTclH4tEZQICpO/KUcashGnIhqqKrtWQaaj2iaRMos8s3igV+5K1yaufAuWVioO7gs+qRegx81CwO95oz2x6q9H++jp6IeRuity+zSYwdgokeFu/4PeqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744878112; c=relaxed/simple;
	bh=/O9PzffT0UkF38g6YsQfm2ehvWBdBRlM1qDTFBNKPcg=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=ush3fZz5MSiBoxKeRT4LSUcdA6l1UIFtcjABTUhRb5RVk8EOMU8s1n5QV1zwnUGQ8FdOEVn1sVjFC+yfwqX2Zq05i4p9JrpQAdQJg82QbzCwnfxaD4AHqBZM6Ooi6cDQutZkhLrKwqMHZx/94DnxVszWPLLPrsysEWa4siNLNzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=don8ttsG; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="don8ttsG"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250417082141epoutp014b6a7e3463ab06370df6e5d44079c2f8~3DWN0mYFd0664306643epoutp01i
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 08:21:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250417082141epoutp014b6a7e3463ab06370df6e5d44079c2f8~3DWN0mYFd0664306643epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744878101;
	bh=nKe4i8h6okYt25emOV7WfFmaZZU5uL7Xb8zHj/J4a4c=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=don8ttsGE+XWMOQjR52294VgyDel9rFbIaPPQdh91Fh61M+vR9+ELCtYhSt+bbkKS
	 yL0zslYAsIVsuiIVk2uDDVfoyiTDJgEm9UkdhLV9lTQ5LAS1440OwRsvr0mRuE5eLt
	 u2K0gdeWc61v1wI4g+WocIc2xqX2u0NZ+Y/1r/74=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20250417082140epcas1p48d7a4439fa3773be1ee9784e78e6fd63~3DWNCgvbu2991529915epcas1p4F;
	Thu, 17 Apr 2025 08:21:40 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.36.226]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZdW841mrLz6B9m5; Thu, 17 Apr
	2025 08:21:40 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
	3B.72.10191.41AB0086; Thu, 17 Apr 2025 17:21:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20250417082139epcas1p3ca8595055b368abd970300e9422e3515~3DWMJPt_01730217302epcas1p38;
	Thu, 17 Apr 2025 08:21:39 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250417082139epsmtrp2dc85a27f3e86f17c5141280daa730411~3DWMH6Rta1656716567epsmtrp2M;
	Thu, 17 Apr 2025 08:21:39 +0000 (GMT)
X-AuditID: b6c32a39-0213c240000027cf-84-6800ba146716
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.F2.08805.31AB0086; Thu, 17 Apr 2025 17:21:39 +0900 (KST)
Received: from dh0421hwang02 (unknown [10.253.101.58]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250417082139epsmtip2d388a92515101398af77802a15043ec1~3DWL6ohPs1317113171epsmtip2w;
	Thu, 17 Apr 2025 08:21:39 +0000 (GMT)
From: "DooHyun Hwang" <dh0421.hwang@samsung.com>
To: "'Avri Altman'" <Avri.Altman@sandisk.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
	<quic_mnaresh@quicinc.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <jangsub.yi@samsung.com>,
	<sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
In-Reply-To: <PH7PR16MB6196EF7F7A1862B48B66C5C5E5BC2@PH7PR16MB6196.namprd16.prod.outlook.com>
Subject: RE: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs
 cmd error
Date: Thu, 17 Apr 2025 17:21:39 +0900
Message-ID: <055d01dbaf71$be2da7f0$3a88f7d0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEmYeTjtFjYRI1QNWxgWL0Y7ybfIwITLn2gAaoUPAICNqyVwLTieWog
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJsWRmVeSWpSXmKPExsWy7bCmga7ILoYMg78ruCwezNvGZvFu/RYm
	i5c/r7JZTPvwk9lixqk2Votff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPaatOc/k8XmTnEf7gW6mAK6obJuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMeUFMoSc0qBQgGJxcVK+nY2RfmlJakK
	GfnFJbZKqQUpOQVmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZMy5FFUwQquidt5m5gbGPt4uR
	k0NCwETi5sppLCC2kMAORok1m3W6GLmA7E+MEltuXmCCcL4xSjw98ZkFpuP2rZfMEIm9jBL3
	ft1hh3BeM0ocnDWLHaSKTcBAYvKxN2wgCRGB+0wSXU9vgrUwC1xnlPh57wsTSBWnQKzErXs7
	gDo4OIQFwiQe/jYCCbMIqEos//eQDcTmFbCU2He0mx3CFpQ4OfMJ2BnMAvIS29/OYYY4SUHi
	59NlrCC2iICbxJsTa6BqRCRmd7aB7ZUQmMwp0fR4IyNEg4vE5P/H2SFsYYlXx7dA2VISn9/t
	ZYOwiyWunDsLZbcwSjzqyICw7SWaW5vZQG5mFtCUWL9LH2IXn8S7rz2sIGEJAV6JjjYhiGo1
	icX/vgNtZQeyZSQauSGiHhKP296wTGBUnIXkr1lI/pqF5P5ZCKsWMLKsYhRLLSjOTU8tNiww
	hUd1cn7uJkZwitey3ME4/e0HvUOMTByMhxglOJiVRHjPmf9LF+JNSaysSi3Kjy8qzUktPsRo
	CgzpicxSosn5wCyTVxJvaGJpYGJmZGJhbGlspiTOu+fj03QhgfTEktTs1NSC1CKYPiYOTqkG
	Jv4jm4/0qb0y++Aa1bQ0bW3t56mchv/+HXNYpFJ20N133iXn6uObTx63VNRmdIm9f+AmU8zj
	e1VLvXx9t29w3jHnQ0r3z4kdjaInV7t/Ndn88cFnyzdG3m9F1lkGKj1a8ufqbG+rZGtHk1Kt
	zybOUYnB1ef37V4xf/OiS5fVpb5zx97hKYotO/47bNYMxl8LHTI0X1lHWadPuFTuP/HCjsw/
	DL+naDUWTv0gqnD1hOtZYdV19/fPP6d89/MugVPC6ts0/P5Zsk3cJjtV8IhNUuGtiphJM7w3
	vJIWTmhplq1u4PydvZQrQ1lgTfL0w7v+M/Hz5ce92pVSr/Pb1Hp5f9aywK3VIj7ZmTNPZe0J
	t1ZiKc5INNRiLipOBADTcn9megQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWy7bCSvK7wLoYMg5/blSwezNvGZvFu/RYm
	i5c/r7JZTPvwk9lixqk2Votff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPaatOc/k8XmTnEf7gW6mAK4oLpuU1JzMstQifbsErowZl6IK
	JghV9M7bzNzA2MfbxcjJISFgInH71kvmLkYuDiGB3YwS++avZoFIyEh039/L3sXIAWQLSxw+
	XAxR85JR4um3NrAaNgEDicnH3rCBJEQEXjJJLLvzlxHEYRa4zyixaNtUdoiWCUwSqy5cZAdp
	4RSIlbh1bweYLSwQInH820Ewm0VAVWL5v4dsIDavgKXEvqPd7BC2oMTJmU9YQM5gFtCTaNvI
	CBJmFpCX2P52DjPEpQoSP58uYwWxRQTcJN6cWMMCUSMiMbuzjXkCo/AsJJNmIUyahWTSLCQd
	CxhZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEe8ltYOxj2rPugdYmTiYDzEKMHB
	rCTCe878X7oQb0piZVVqUX58UWlOavEhRmkOFiVx3m+ve1OEBNITS1KzU1MLUotgskwcnFIN
	TDxpP+/q/b9TFPlkpaXFBIWtogtq31+Zk7HeJHuptuVGmWhJp56m2PLHt40lixUb5yZL7Plv
	a2R6jbVC53jFQalLpcl71vHWTNwgGie9JE75o4HiG4ui8yvvGNrpmQcW5smXZJ/lKefOMN9z
	wbrnhumi9i1ruHMdzunmxh+5nNOdeDXVh6/7K4v6pL7OnQsPv87Z7We3TfSvvoSjiKjno2ua
	Z3JCd1sVFPoHq2qa9HsIW/9LYZNOCX8oY/vnQGGyhN9tgToTrfna8bO3t+gcCJ13aGpDHesC
	ZYGT0pPNGjzmqFyW485/K79L2Mqr9fzV0twPbXlszZ4s+06nBK18qBkTd630n9jym/s8y5RY
	ijMSDbWYi4oTAQswajtnAwAA
X-CMS-MailID: 20250417082139epcas1p3ca8595055b368abd970300e9422e3515
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>
	<20250417023405.6954-2-dh0421.hwang@samsung.com>
	<PH7PR16MB6196EF7F7A1862B48B66C5C5E5BC2@PH7PR16MB6196.namprd16.prod.outlook.com>

> > There is no trace when a ufs uic cmd error occurs.
> > So, add "UFS_CMD_ERR" enumeration to ufs_trace_str_t.
> >
> > Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
> > ---
> >  drivers/ufs/core/ufs_trace.h | 1 +
> >  include/ufs/ufs.h            | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
> index
> > caa32e23ffa5..43830a092637 100644
> > --- a/drivers/ufs/core/ufs_trace.h
> > +++ b/drivers/ufs/core/ufs_trace.h
> > @@ -41,6 +41,7 @@
> >  #define UFS_CMD_TRACE_STRINGS                                  \
> >         EM(UFS_CMD_SEND,        "send_req")                     \
> >         EM(UFS_CMD_COMP,        "complete_rsp")                 \
> > +       EM(UFS_CMD_ERR,         "req_complete_err")             \
> >         EM(UFS_DEV_COMP,        "dev_complete")                 \
> >         EM(UFS_QUERY_SEND,      "query_send")                   \
> >         EM(UFS_QUERY_COMP,      "query_complete")               \
> > diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h index
> > c0c59a8f7256..7f2d418bdd86 100644
> > --- a/include/ufs/ufs.h
> > +++ b/include/ufs/ufs.h
> > @@ -631,7 +631,7 @@ struct ufs_dev_info {
> >   * This enum is used in string mapping in ufs_trace.h.
> >   */
> >  enum ufs_trace_str_t {
> > -       UFS_CMD_SEND, UFS_CMD_COMP, UFS_DEV_COMP,
> > +       UFS_CMD_SEND, UFS_CMD_COMP, UFS_CMD_ERR, UFS_DEV_COMP,
> >         UFS_QUERY_SEND, UFS_QUERY_COMP, UFS_QUERY_ERR,
> >         UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR  };
> It seems strange to me that scsi & uic commands are designated by the same
> enum.
> Has it been considered to add UFS_UIC_SEND, UFS_UIC_COMP, UFS_UIC_ERR to
> enum ufs_trace_str_t ?
> Also looks like UFS_DEV_COMP is unused ?
> 
> Thanks,
> Avri
It is correct that the same enumeration is used for both SCSI and UIC
commands.
However, the trace function differs for SCSI and UIC commands.
The enum is solely for handling the sending and completion of each command
within the respective trace functions.

Therefore, I think there is no need to add new enums like "UFS_UIC_SEND".

It seems better to discuss "UFS_DEV_COMP" in another commit.


Thank you.
DooHyun Hwang.
> > --
> > 2.48.1
> 


