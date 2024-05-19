Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD7E74262
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716157576; cv=none; b=MVMHfIl83SFegvnoAxpidSwgsTFBNV4LGHWpxoxad3yGsHEmsWhjhp66HqbwuQM5YovEZe5NNjVrT36MAzvtU0pdWIK/m6Bcz1GjRqUHn4s+rgagrqqqS0MhKHZBwUx9JWVmSTFRWERVCaWWiNKpn1/H49KC2xNastKj6Z5Kl0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716157576; c=relaxed/simple;
	bh=Szu9njIL0tIEKdHzkoPwCn2+lvTZdhLreYacJvxijn0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=NOganfSDw84ebN1gz5cJrF0BBwK4Kv/nKe8zyYQ4XyEzt1SwdqbRZm9q4wrvqaH9qK9D5FZHQ3vMgzz56yHl5Cy7oVMhS/5d+J7Z6Bs4Cw3pvMBBwnMBM26wYGvNsLHi3o0h0tU12tMAJeay+xFMoMgE/pf1T/V/nxtDtdlmiuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AvMy9RkQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AvMy9RkQ"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240519222606epoutp02ceef68a82446a74ca0f2ee6952aa9647~RBDa9ih7C1130411304epoutp02K
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 22:26:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240519222606epoutp02ceef68a82446a74ca0f2ee6952aa9647~RBDa9ih7C1130411304epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716157566;
	bh=PgDI/bMjdgVCYmG1zHkg2MC/8ynUaS5Yh6Yuf3VKhsM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=AvMy9RkQXyeTyEVOe1vfCJuna/Si9F8ZhCW11BD0iBjlWA1lW8jewbjALPg3E8CK4
	 z97VwECt4rtIxtpV6O9hynpeRz+MxbBShnrwODvY+aQFU6MO8gZQ6BeoQMy67CurbM
	 bW0/mErMvxyoKj4URCUC9FBRgXvF+X6NqZ2Gz3RA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240519222605epcas2p213aa99fa1635db33711693cff10aba2f~RBDahJany2706827068epcas2p2D;
	Sun, 19 May 2024 22:26:05 +0000 (GMT)
Received: from epsmgec2p1.samsung.com (unknown [182.195.36.101]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VjFf46F3Gz4x9Pt; Sun, 19 May
	2024 22:26:04 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmgec2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	47.1D.08666.C7C7A466; Mon, 20 May 2024 07:26:04 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240519222604epcas2p3d427f2f5b3b0156881f6840443210931~RBDZN_waB0281302813epcas2p3O;
	Sun, 19 May 2024 22:26:04 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240519222604epsmtrp1bf2e98b6bc334be84d9f3dd05f8d88dc~RBDZNUXes2746627466epsmtrp1R;
	Sun, 19 May 2024 22:26:04 +0000 (GMT)
X-AuditID: b6c32a43-aa9fa700000021da-a5-664a7c7ce137
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CA.40.19234.C7C7A466; Mon, 20 May 2024 07:26:04 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240519222604epsmtip27ac701456c85d36b41aadf47ffb03d2a~RBDY_hv4d0625506255epsmtip23;
	Sun, 19 May 2024 22:26:04 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
	Assche  <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joel Granados
	<j.granados@samsung.com>, gost.dev@samsung.com, Minwoo Im
	<minwoo.im@samsung.com>, Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 0/2] ufs: mcq: Fix and cleanup unsafe macros
Date: Mon, 20 May 2024 07:14:55 +0900
Message-Id: <20240519221457.772346-1-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmhW5NjVeawa0mI4sH87axWbz8eZXN
	YtqHn8wWNw/sZLJYuv8ho8XGfg6Ly7vmsFl0X9/BZrH8+D8mi2enDzBbLOyYy+LA7XH5irfH
	tEmn2Dw+Pr3F4jFxT51H35ZVjB6fN8l5tB/oZgpgj8q2yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6UEmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xi
	q5RakJJTYF6gV5yYW1yal66Xl1piZWhgYGQKVJiQnXH2/Fy2gka2isf7F7I0MN5h6WLk5JAQ
	MJG40feAvYuRi0NIYAejxIVdM1ggnE+MEova2xjhnNWH1zN3MXKAtbzYrggR38koMX3pYmYI
	5zejxMmmPewgc9kE1CUapr4C2yEi8IFRYtMbA5AiZoFTjBKf77czgiSEBewlWi59ZAaxWQRU
	JW5tPM4KYvMKWEt8ufONHeJAeYn9B88yQ8QFJU7OfAI2lBko3rx1NthmCYGf7BLHn56CanCR
	6LoyE+o7YYlXx7dAxaUkXva3QdnlEj/fTGKEsCskDs66zQbxmr3EtecpICazgKbE+l36EFFl
	iSO3oLbySXQc/ssOEeaV6GgTgpihLPHx0CFmCFtSYvml12wQtofE3SUTwXYKCcRKLPl/m3kC
	o/wsJL/MQvLLLIS9CxiZVzGKpRYU56anJhsVGMLjNDk/dxMjOI1qOe9gvDL/n94hRiYOxkOM
	EhzMSiK8m7Z4pgnxpiRWVqUW5ccXleakFh9iNAWG7kRmKdHkfGAizyuJNzSxNDAxMzM0NzI1
	MFcS573XOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgUmg8qf0z6Bp89q6GhV9Z3vfStn/NmfjKZfo
	lld3lnQcX39Iwf10suisp1saM2b3Mnqsdt6798yTOqcMyy2HnpkmdhXHWhp+ED1rXahwdcZV
	5v2GS76FazaelAub/68jmPndM8cnM4/OXZ437yx/oKG0sQM393W2nSKftbeLshhdVY9/132D
	6bAao7cH373LffFXTr7e57ti/uk1N70bs3aY+H1g5WJP7Dl9T97+3rbXn6YlJ1YeKXPwU54s
	kH453LjIV/NdXprphDnHHC1fzv2wtVZi2T+JtNJQnoMS+xY+EVzKnl5eLa5x86ky/yd2KyN2
	CeuqtX+kCssMZepi97GatzjIblytouuj5GjSp8RSnJFoqMVcVJwIABqdHScsBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvG5NjVeawf4PXBYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxdP9DRouN/RwWl3fNYbPovr6DzWL58X9MFs9OH2C2WNgxl8WB2+PyFW+P
	aZNOsXl8fHqLxWPinjqPvi2rGD0+b5LzaD/QzRTAHsVlk5Kak1mWWqRvl8CVcfb8XLaCRraK
	x/sXsjQw3mHpYuTgkBAwkXixXbGLkZNDSGA7o8S8VUkgtoSApMS+0zdZIWxhifstR4BsLqCa
	n4wS/1avZgRJsAmoSzRMfcUCkhAR+MQosamrA8xhFrjAKDHn0ydmkCphAXuJlksfwWwWAVWJ
	WxuPg43lFbCW+HLnGzvECnmJ/QfPMkPEBSVOznzCAmIzA8Wbt85mnsDINwtJahaS1AJGplWM
	oqkFxbnpuckFhnrFibnFpXnpesn5uZsYwUGtFbSDcdn6v3qHGJk4GA8xSnAwK4nwbtrimSbE
	m5JYWZValB9fVJqTWnyIUZqDRUmcVzmnM0VIID2xJDU7NbUgtQgmy8TBKdXAZOqgnR/3hfvH
	glu912zyItS6f6/sXLkqQE1r67XSWY8E3lUvidhxIfx4ia/ItOWMWRylzLGWnV/Lj1x5P/+n
	ZOyjZ7qq7p2Kpx7nPratnrhX8dSvu+GT//9q8WdVO+Z149vz+AbDN1+fd4ttCPPa7xDhI2bL
	+mPfhy9OHj8/7pAP0d0cdJ/boj3cpn6S7fLTfXK+07NXx6+P9hA9c7ThU4JwocbV7xM2JOfz
	d/01YDmx+9/zrEv7z+6cMGv3pLuR59/MuJATpmzz/tuGiZ7ei6S2GNzbfklh7nnHe7qRBl46
	H5Q/rd8c0HR8qwPDdhO2EolJFT1uL/bGq69M/PxZ+f6Dhxd/ri97uKFCemeOe4YSS3FGoqEW
	c1FxIgB+n14M2QIAAA==
X-CMS-MailID: 20240519222604epcas2p3d427f2f5b3b0156881f6840443210931
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240519222604epcas2p3d427f2f5b3b0156881f6840443210931
References: <CGME20240519222604epcas2p3d427f2f5b3b0156881f6840443210931@epcas2p3.samsung.com>

Hello,

This patch set fixes an potential bug for further usages in ufs-mcq.c and
contains a simple clean-up converting macro to an inline function.

Please review.

Thanks,

v2:
  - Fix missing argument 'hba' in MCQ_OPR_OFFSET_n by converting it to an
    inline function (Bart)
  - Added [2/2] patch to convert the remaining one macro in ufs-mcq.c to an
    inline function along with the previous patch for the sake of consistency.

Minwoo Im (2):
  ufs: mcq: Fix missing argument 'hba' in MCQ_OPR_OFFSET_n
  ufs: mcq: Convert MCQ_CFG_n to a inline function

 drivers/ufs/core/ufs-mcq.c | 35 ++++++++++++++---------------------
 include/ufs/ufshcd.h       | 13 +++++++++++++
 2 files changed, 27 insertions(+), 21 deletions(-)

-- 
2.34.1

