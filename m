Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEA222DF91
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 02:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736907842; cv=none; b=irUROyOBBjxhwUW2lJzzjii/e9r3hU+L3PP83QO3Ih8yFlAbNPcfM7acP4V64NMbNZ4k/wQxCZnERQIqoxss521ubOzUPRhkqq/0gSyos2fvWys1KCgPFBF8Zel+tVPIwLZ9mmxLFq/ZtHSKsXt3BcGQjY1ySJfvOoM/RKk65fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736907842; c=relaxed/simple;
	bh=sj+/ST6ICx0lzWFuUGzNxO9ai+Jl601xBnsjw/bRMdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=iQwfzgsIvdxrzW96NCzUWoZYLiOEq73BEzeDqKs8a86gmSFhCJ4OqNFy2RipmuCWbR0zIPx65IiDRGmz0KdKipKnP3m06Y0/BVo7dY9ZeRNwIrC9xqNW/HWTMxd+mJ8Vqc0GguEik+52Gd/xVMCod2tc1OI4Y0MnXFcr8dOU0W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fEotTZeL; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fEotTZeL"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250115022350epoutp03977797ef9e01d85694de3e3782b29968~avHgTHdsF2728927289epoutp03W
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jan 2025 02:23:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250115022350epoutp03977797ef9e01d85694de3e3782b29968~avHgTHdsF2728927289epoutp03W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1736907830;
	bh=y++4LWKsodRYF6qh8WPDx00tViPvFDUU/EFkyHHQNqE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fEotTZeLJvUackvj6A3rc52qkOPaycgZHhuVC3HWIMTOUh+/3c4Deqp8YxruvfVLe
	 Yz3I4dTypShE2Rb8cJT+ID8eLd4Z6hutl9a1/wKNmI19ftskNZDYYFtsDwjPXsc3/h
	 za19zqIeYHUAchD/qUO5v22tayjMupWVFgjbfCbM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20250115022349epcas1p3db8ffff504e8142e51c96825f8980f9d~avHfgra-v2069920699epcas1p3u;
	Wed, 15 Jan 2025 02:23:49 +0000 (GMT)
Received: from epsmgec1p1.samsung.com (unknown [182.195.38.242]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4YXqYc6kLhz4x9Pp; Wed, 15 Jan
	2025 02:23:48 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmgec1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.A2.23869.43C17876; Wed, 15 Jan 2025 11:23:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250115022348epcas1p29705c109f51c01e1e91ef227233c7119~avHef7NAm1473514735epcas1p2_;
	Wed, 15 Jan 2025 02:23:48 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250115022348epsmtrp2e8015a1a1c97a19c8992b630da6d08ca~avHee3xiN0517805178epsmtrp2d;
	Wed, 15 Jan 2025 02:23:48 +0000 (GMT)
X-AuditID: b6c32a36-6e9e870000005d3d-79-67871c34ee46
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	94.32.18949.43C17876; Wed, 15 Jan 2025 11:23:48 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250115022347epsmtip14496ce46e800b13c6eca9d6b61bf4bd8~avHeLv9lR1687016870epsmtip1N;
	Wed, 15 Jan 2025 02:23:47 +0000 (GMT)
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
Subject: [PATCH] scsi: ufs: core: increase the NOP_OUT command timeout
Date: Wed, 15 Jan 2025 11:23:44 +0900
Message-ID: <20250115022344.3967-1-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.48.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmnq6JTHu6QfsXY4sH87axWbz8eZXN
	YtqHn8wWM061sVrsu3aS3eLX3/XsFhv7OSw6tk5mstjx/Ay7xa6/zUwWl3fNYbPovr6DzeJu
	SyerxfLj/5gstn76zWrxre8Ju0XTn30sFtfOnGC12HzpG4uDsMflK94e0yadYvO4c20Pm0fL
	yf0sHh+f3mLxmLinzqNvyypGj8+b5DzaD3QzBXBGZdtkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAP2kpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFV
	Si1IySkwK9ArTswtLs1L18tLLbEyNDAwMgUqTMjO2LXhFnvBc46KeYe+szUwzmDvYuTkkBAw
	kZgz7xFTFyMXh5DADkaJeb1fWCCcT4wSey9+YwGpEhL4xijRu9oLpmPS7TOsEEV7GSWePFjH
	COF8ZpT48vMBK0gVm4CexJ7eVWBVIgLzmCQ6Ly0Bm8ss8JFRYuGt12wgVcICbhJPn+0HSnBw
	sAioSlw+nQxi8grYSDx45Q+xTV7i9pqTYFfwCghKnJz5BMxmBoo3b53NDFFzhEPi01pJCNtF
	4sDilVC/CUu8Or4FypaS+PxuLxuEXSxx5dxZKLuFUeJRRwaEbS/R3NrMBnICs4CmxPpd+hCr
	+CTefe1hBQlLCPBKdLQJQVSrSSz+9x3odXYgW0aikRsi6iHxff85dkioxUqcuLSdaQKj3Cwk
	589Ccv4shFULGJlXMYqlFhTnpqcWGxYYwWMxOT93EyM4HWuZ7WCc9PaD3iFGJg7GQ4wSHMxK
	IrxL2FrThXhTEiurUovy44tKc1KLDzGaAoNzIrOUaHI+MCPklcQbmlgamJgZmVgYWxqbKYnz
	XtjWki4kkJ5YkpqdmlqQWgTTx8TBKdXAlJqSEFbydd/yB0wCPvbKhvpcz4MXM7mtOrQhP2LG
	1uRvbWyzOM2l4/yW2bI+F7Ll9144b0tCMA+D+tQPT6JNcl+9FtsvNn3xJs7nsx4sVtMqzLaf
	e/KPoslVp0j2d+dmVuw59ftbZn6WxO2Z90zm3em9+7vSXTPR2nZ93tKSB53zBaxiXrHfUJ1X
	LSW2mvFSo/UM78q9yr4m+/jjrPZpPtXKyORhvuHLuHZS36n6dap8/w06xFU2/439+CJMKHVa
	fUTEMmaTyXfl09xWH/54e0qt03yWBYlsLhmhfd+cetnCD7N05sgeXptWPju05K17wb1z289c
	NnBOZLZwUXNKiXFg5by+lHdhxE67021KLMUZiYZazEXFiQB508q6UAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWy7bCSnK6JTHu6wdq57BYP5m1js3j58yqb
	xbQPP5ktZpxqY7XYd+0ku8Wvv+vZLTb2c1h0bJ3MZLHj+Rl2i11/m5ksLu+aw2bRfX0Hm8Xd
	lk5Wi+XH/zFZbP30m9XiW98TdoumP/tYLK6dOcFqsfnSNxYHYY/LV7w9pk06xeZx59oeNo+W
	k/tZPD4+vcXiMXFPnUffllWMHp83yXm0H+hmCuCM4rJJSc3JLEst0rdL4MrYteEWe8Fzjop5
	h76zNTDOYO9i5OSQEDCRmHT7DGsXIxeHkMBuRonFB3sZIRIyEt339wIVcQDZwhKHDxdD1Hxk
	lFjw8w0rSA2bgJ7Ent5VYM0iAiuYJObf+sgO4jAL/GaUmPSjGWyFsICbxNNn+1lAJrEIqEpc
	Pp0MYvIK2Eg8eOUPsUte4vaakywgNq+AoMTJmU/AbGagePPW2cwTGPlmIUnNQpJawMi0ilEy
	taA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOH60tHYw7ln1Qe8QIxMH4yFGCQ5mJRHeJWyt
	6UK8KYmVValF+fFFpTmpxYcYpTlYlMR5v73uTRESSE8sSc1OTS1ILYLJMnFwSjUwRdzeWFTq
	ZOd6p3wif37/we2vtvtuLrf4rM/rVaT8IHaV1gb/w5N//ZU3s5zb8PtwAuuFmfvPn9yqo/VW
	ojLeUO9Jbs230zEOnx/nzpaZfjvm0y2Hsv1LdnOvZOK72tLxW3jRywWbC7eoNv3oNWmsapC+
	Fbe4dNK+g83RU5jrpK5o/t656pmKkpL2zlOei/ruzOBfUXXh1vxtE0t+6YnOfiVSa7vvf/fZ
	d7dud0q46PJsOPSLtfgJ42WZnWpZ/fZh9S4TpzE/e9pR8iHYeHbzf4n7EYIVnEbxsr/1ahRP
	Oq06++D4fZutk33K9zyack5tU3ujVve7gDhOpTXieV686XuEv8cyLTC/03bY/tRLGyWW4oxE
	Qy3mouJEAHfPvzkOAwAA
X-CMS-MailID: 20250115022348epcas1p29705c109f51c01e1e91ef227233c7119
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250115022348epcas1p29705c109f51c01e1e91ef227233c7119
References: <CGME20250115022348epcas1p29705c109f51c01e1e91ef227233c7119@epcas1p2.samsung.com>

It is found that is UFS device may take longer than 500ms(50ms * 10times)
to respond to NOP_OUT command.

The NOP_OUT command timeout was total 500ms that is from
a timeout value of 50ms(defined by NOP_OUT_TIMEOUT)
with 10 retries(defined by NOP_OUT_RETRIES)

This change increase the NOP_OUT command timeout to total 1000ms
by changing timeout value to 100ms(NOP_OUT_TIMEOUT)

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cd404ade48dc..bf5c4620ef6b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -57,8 +57,8 @@ enum {
 };
 /* NOP OUT retries waiting for NOP IN response */
 #define NOP_OUT_RETRIES    10
-/* Timeout after 50 msecs if NOP OUT hangs without response */
-#define NOP_OUT_TIMEOUT    50 /* msecs */
+/* Timeout after 100 msecs if NOP OUT hangs without response */
+#define NOP_OUT_TIMEOUT    100 /* msecs */
 
 /* Query request retries */
 #define QUERY_REQ_RETRIES 3
-- 
2.48.0

