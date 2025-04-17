Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C5F19DF60
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 02:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744857262; cv=none; b=ArC2ClABpvUd6ZKy6dHTTPmpGQ0Ip0SwrgiLdDWrzj1R4UN3T/EdMUwcJwW3Ien+QeEtY+x9O6Xw+Jrox+OP5VLCfx+UIyetX9RnWWy+JFn84P2yEA3E5VpA7LUz8ljOf5hbJ/8iJK+1QKABpyHUt3qM29iuR3g53dAMaYaATH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744857262; c=relaxed/simple;
	bh=lzu4RHdidFF3IvAP3ntWf+o5vVtP3s2YPbz4MELxehE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=pXur1xGfIaBJ+lwkjinNFFKaKYdbUbIilIiGAOIrlj5unmUwRgvG9tHrFKOBHEU1Am3+U6rCFzy0BpuUezgi7rcz/5LcIaRRWabhQ2j1jxeT+ybxtqDDHgEfhdcXcOqBoH/1KWEiI7UW082wvy0XCBJdIiYMGtwtNvqq5wh5ohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=u97qMqdH; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u97qMqdH"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250417023416epoutp03888d75daaf9dadc8aacedca4b2c9f308~2_m4xCOPT0300303003epoutp03L
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 02:34:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250417023416epoutp03888d75daaf9dadc8aacedca4b2c9f308~2_m4xCOPT0300303003epoutp03L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744857256;
	bh=wjeE/pXfIQFwZScu66ols+meQfxXWKJ+jO8uL41b120=;
	h=From:To:Cc:Subject:Date:References:From;
	b=u97qMqdHEOsVqViHF15lO573hh3LmrXb+TFeXNs6qajpDsSXAl7v9wCa1riPcaZ1P
	 NrUj1OcmL3ogs0nDyHgPp4PtAxRDnPQmKeNO47wkt+kTock9HkbnBwbscGA+1X0AiD
	 sL82E5l4UW9Y4KCXRVpmsIbb1Qufdd2uqt8nBoVw=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20250417023416epcas1p3bd3f3e95f989c02eeba3064f378b8064~2_m4ISfKy1017310173epcas1p3c;
	Thu, 17 Apr 2025 02:34:16 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.38.240]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZdMRC4Mwvz6B9m7; Thu, 17 Apr
	2025 02:34:15 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	F9.E3.10210.7A860086; Thu, 17 Apr 2025 11:34:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250417023415epcas1p47da6d269afcb5d1807004c9b708675a5~2_m3J2FBp1437214372epcas1p4E;
	Thu, 17 Apr 2025 02:34:15 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250417023415epsmtrp1c2c84d0460a4e8829fde31c34d6783b9~2_m3I2DoX2422224222epsmtrp1A;
	Thu, 17 Apr 2025 02:34:15 +0000 (GMT)
X-AuditID: b6c32a33-145fd700000027e2-75-680068a75d27
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	83.03.19478.6A860086; Thu, 17 Apr 2025 11:34:14 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250417023414epsmtip21504e7ff7f309e1bf7acdf3388b2de9e~2_m24HDzL2769027690epsmtip2M;
	Thu, 17 Apr 2025 02:34:14 +0000 (GMT)
From: DooHyun Hwang <dh0421.hwang@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
	quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
	jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
	sh8267.baek@samsung.com, wkon.kim@samsung.com, DooHyun Hwang
	<dh0421.hwang@samsung.com>
Subject: [PATCH 0/2] scsi: ufs: Add an enum for ufs_trace_str_t to check uic
 cmd error
Date: Thu, 17 Apr 2025 11:34:02 +0900
Message-ID: <20250417023405.6954-1-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHJsWRmVeSWpSXmKPExsWy7bCmnu7yDIYMg9fLFCwezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/STkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRW
	KbUgJafArECvODG3uDQvXS8vtcTK0MDAyBSoMCE74/nLtUwF3SwVf1t5Ghh7mLsYOTkkBEwk
	jk2eC2YLCexglDj5VK+LkQvI/sQocXfWJFaIBJAzaXo9TMPHW9OZIYp2Mkp0L93JCOF8ZpRY
	s2E72Cg2AT2JPb2rWEESIgLzmCQ6Ly1hAXGYBT4ySiy89ZoNpEpYIEKif/5+sA4WAVWJjS9W
	M4HYvAI2EuuezmSE2CcvcamrjR0iLihxcuYTFhCbGSjevHU22B0SAgc4JFa8PwfV4CLR0/yA
	HcIWlnh1fAuULSXxsr8Nyi6WuHLuLBuE3cIo8agjA8K2l2hubQaKcwAt0JRYv0sfYhefxLuv
	PawgYQkBXomONiGIajWJxf++A21lB7JlJBq5IaIeEpf7OhghARcrMW3yY9YJjHKzkNw/C8n9
	sxBWLWBkXsUollpQnJuemmxYYAiPxuT83E2M4ISsZbyD8fL8f3qHGJk4GA8xSnAwK4nwnjP/
	ly7Em5JYWZValB9fVJqTWnyI0RQYohOZpUST84E5Ia8k3tDE0sDEzMjEwtjS2ExJnHf3x6fp
	QgLpiSWp2ampBalFMH1MHJxSDUyuFU1dvT9Sg1UrrFXe/Zq54Oi6t6ozs64zaS8q2vPIyz74
	juUc3Ypz1ZJuhbk7KioUpBkZrJ9vP1XJvuKG/7vN5/L/ed73X2i27Of+11I+Tga+H5fvk5oU
	e+jcUcvL6cG9lW7MIn8fiR2RVHFrLY1iP7Pquu/KVTVSOj/WnXfT3XPyuM8Gf551a6ZMY3oe
	Pyfid1YQv/y0/xzWrP7qp+qYQ4yeljBXS4afF12/4EPkeZfAPtli5Sz/pPlJv641fT8oc1i+
	NN513g217qxTX2w1rPXskliXaLHtXr7oX7Tv+bNBgZ/65n06dujixdwWHrfVSl6GUx5rp/VY
	eTnocwUp+nC7PWmcOvNzN2vnCyWW4oxEQy3mouJEAKx8G1ZRBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvO6yDIYMgzs3rS0ezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZxWWTkpqTWZZapG+XwJXx/OVapoJuloq/
	rTwNjD3MXYycHBICJhIfb00Hsrk4hAS2M0rMWXeAESIhI9F9fy97FyMHkC0scfhwMUTNR0aJ
	j+cfMoHUsAnoSezpXcUKkhARWMEkMf/WR3YQh1ngN6PEpB/N7CBVwgJhElNWLmADsVkEVCU2
	vlgN1s0rYCOx7ulMqG3yEpe62tgh4oISJ2c+YQGxmYHizVtnM09g5JuFJDULSWoBI9MqRtHU
	guLc9NzkAkO94sTc4tK8dL3k/NxNjODI0Qrawbhs/V+9Q4xMHIyHGCU4mJVEeM+Z/0sX4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkzquc05kiJJCeWJKanZpakFoEk2Xi4JRqYOLQ5k7N8xNUZr+4
	81VmVciXfUq5uzkz+LX8vpcv77ERTM4+52YQx7Cztu/+1hWeiodrpebM0Nzm1fY1/9fN0KAH
	P3cLyxjOOxa7a7rbzw+pfF4Tjz9Q+z1r2a9vth6x/46pnVbUX3RIxecr665XaUpWuq0OJx2u
	XbxT1XEpe6b+o3yG9+VXzFZKFQlmXL8t5S0113f6TK7MaenCsUdvbjlw+q2119XiM8rLq3f9
	nPtOwGhqudDXhtLsDTvnlvQm2M7XOh3n9+25ncO/HNn7GnlsHr1ZZVanhWfs33fxcsqM5F2+
	8ioL0tq3pWTsP5wy5/D0JZ43pP114q3uPzx1Sk854/yBA9z7Np4/frDz1SElluKMREMt5qLi
	RABKDV6vCwMAAA==
X-CMS-MailID: 20250417023415epcas1p47da6d269afcb5d1807004c9b708675a5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023415epcas1p47da6d269afcb5d1807004c9b708675a5
References: <CGME20250417023415epcas1p47da6d269afcb5d1807004c9b708675a5@epcas1p4.samsung.com>

There is no trace when a ufs uic command error occurs.

So, add "UFS_CMD_ERR" enum to ufs_trace_str_t and add trace function calls when a uic
command error happens.

DooHyun Hwang (2):
  scsi: ufs: Add an enum for ufs_trace to check ufs cmd error
  scsi: ufs: core: Add a trace function calling when uic command error
    occurs

 drivers/ufs/core/ufs_trace.h | 1 +
 drivers/ufs/core/ufshcd.c    | 5 +++++
 include/ufs/ufs.h            | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

-- 
2.48.1

