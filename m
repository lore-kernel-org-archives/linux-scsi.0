Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C92837E
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 00:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716423810; cv=none; b=lyDIeE8Aq6qtf6u51u9QKjt+NgAbRrMBJWkmaLQe2m5p2KUqMfptWyJw+dSnKRzfeD8q6Qob+yZvVONsVMZ42226b4pDw6HP4uHOs8VxOg1FI9RkbjpFDiLtyT8yTUsEmd7z0bjLW/t0ymk96d6UkiBv5cJsecGiYCs9ylY4UBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716423810; c=relaxed/simple;
	bh=aBFl6NoNCYEgzTWuk4Xg5V4yj/L2vRLZ5FrXJZWqsW4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=ZZkRSJQmUotc1qKWwpWoFYPcRuWikj/cO6HKoy5zIMaDsCKM7Ry1Zk6mzNLLrpd6lo1CjylG9O1ZA+68/u7Qzo6vWqY5R8uVbsxMjRCvtzvOXkc9NJlsthkF2Xjb+hwHj2OjxoIQvDfs4FQLM9CRBylIqrlvkCzlAHkTh5I71Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cOYMj7fs; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cOYMj7fs"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240523002324epoutp044478400cc462a09c162660816ad134a4~R9lse9wsX2644926449epoutp048
	for <linux-scsi@vger.kernel.org>; Thu, 23 May 2024 00:23:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240523002324epoutp044478400cc462a09c162660816ad134a4~R9lse9wsX2644926449epoutp048
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716423804;
	bh=bxbj9vt7C7y18tsnTS/FCojRnLKLZliPPTlfmq6LKHk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=cOYMj7fsIsfk/fNJzC94alFaVCdj/iXqCk6zyzsUqlOh0AQgkl1h4oR0LlGLf0Xbh
	 z5VGbco7Hq25/tE7CMzjSibb0pUPQ8eoSsvjBMgSUF0t+5YgwoSpX8ZI61T+kcdXMR
	 i2gU0pspcJjK20B9Tp8DY/sexZZJPAaPLP9HACG4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTP id
	20240523002323epcas1p4740006fec15f67c3c7fe37592d4e89a1~R9lsAclkC1730517305epcas1p4d;
	Thu, 23 May 2024 00:23:23 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.38.248]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Vl863202Kz4x9Pt; Thu, 23 May
	2024 00:23:23 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	7E.88.10158.B7C8E466; Thu, 23 May 2024 09:23:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20240523002322epcas1p2a63dfc646a2b2dd8fcadad2a8807bcee~R9lrCKqcu0290602906epcas1p24;
	Thu, 23 May 2024 00:23:22 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240523002322epsmtrp2cc595954cd7d71202618b62dc197f8c4~R9lrBRRF80430204302epsmtrp2l;
	Thu, 23 May 2024 00:23:22 +0000 (GMT)
X-AuditID: b6c32a38-8e1ff700000027ae-3b-664e8c7b8a8e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AE.89.08390.A7C8E466; Thu, 23 May 2024 09:23:22 +0900 (KST)
Received: from lee.. (unknown [10.253.100.232]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240523002322epsmtip2601973feec3adc41b834b58dfd4c5949~R9lqzQNzn1770717707epsmtip2m;
	Thu, 23 May 2024 00:23:22 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	stanley.chu@mediatek.com, quic_nguyenb@quicinc.com, quic_cang@quicinc.com,
	powen.kao@mediatek.com, yang.lee@linux.alibaba.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] ufs:mcq:Fixing Error Output for ufshcd_try_to_abort_task in
 ufshcd_mcq_abort
Date: Thu, 23 May 2024 09:22:57 +0900
Message-Id: <20240523002257.1068373-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmgW51j1+aQWsHt8WDedvYLF7+vMpm
	Me3DT2aLGafaWC029nNYXN41h82i+/oONovlx/8xWby9+5/FYtK1DWwWU18cZ7dYuvUmo8W7
	xsOMDrwel694e0ybdIrNY+dDS4+Wk/tZPD4+vcXiMXFPnUffllWMHp83yXm0H+hmCuCMyrbJ
	SE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpaSaEsMacU
	KBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgVqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd8fHZ
	ApaCj+wVp/pFGxh3snUxcnBICJhInJ1k1sXIxSEksINR4u30bjYI5xOjROvu04wQzjdGibU/
	VrJ2MXKCdTxe0gOV2MsosevHNWYI5wmjRMOeLnaQuWwCWhK3j3mDNIgInGCSuPMsGcRmFtCQ
	+NN2kQ3EFhaIl7h8cjcjiM0ioCqxp/Et2AJeAVuJbyuWMEMsk5fYf/AsM0RcUOLkzCcsEHPk
	JZq3zgbbKyHQyyFxZ+49qAYXieY5J5kgbGGJV8e3sEPYUhKf3+1lg2hoZpRY+OY4VPcERokv
	H2+zQVTZSzS3NoNDhllAU2L9Ln2IbXwS7772sEICjFeio00IolpFYk7XOTaY+R9vPIaGkIfE
	9P1TwA4VEoiV2PZuLeMERrlZSH6YheSHWQjLFjAyr2IUSy0ozk1PLTYsMIFHZHJ+7iZGcFrV
	stjBOPftB71DjEwcjIcYJTiYlUR4o1f6pgnxpiRWVqUW5ccXleakFh9iNAWG6kRmKdHkfGBi
	zyuJNzSxNDAxMzKxMLY0NlMS5z1zpSxVSCA9sSQ1OzW1ILUIpo+Jg1OqgcnV4rXc1UWex6ct
	nGpdfWXSx6Z5ae9XlxStXaudrcotbmLMEuD8lP1b3N0fbZyXBZbfOLN2ieCm9Ek/TR3DPBQm
	m11bHu8yJ7nrm+yaiYoBj0NFq6Z98ktmcuMO/KTrdqBF9eD31yuX/RAxZS7r38g3+fS8pa7T
	C/bz+08v6gw980DkdYpg2IZnKT7xc7cdNcreU5Z59MnpjftmWnCnqpmUfhSSDxD5q2zzJE13
	UqdD1Zoff18XmfTErWC/cu/L63c+V4tNii9e1VjzqenEAV3NBukdPgwvN01cblLyWPRT3uaz
	B168L5+iv+Vhq4Hot6QG+bkXl6uyaSuu/MU1+5vaUl7VCqvwTdyvtCLK7x1WYinOSDTUYi4q
	TgQAHS5u3DQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSvG5Vj1+awfs2ZYsH87axWbz8eZXN
	YtqHn8wWM061sVps7OewuLxrDptF9/UdbBbLj/9jsnh79z+LxaRrG9gspr44zm6xdOtNRot3
	jYcZHXg9Ll/x9pg26RSbx86Hlh4tJ/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZxWWT
	kpqTWZZapG+XwJXx8dkCloKP7BWn+kUbGHeydTFyckgImEg8XtLD2MXIxSEksJtR4t/cl1AJ
	KYnd+88D2RxAtrDE4cPFEDWPGCWuv+gEi7MJaEncPuYNEhcRuMYk0Xz7GStIL7OAhsSftotg
	c4QFYiV2zJkFZrMIqErsaXwLVsMrYCvxbcUSZohd8hL7D55lhogLSpyc+YQFYo68RPPW2cwT
	GPlmIUnNQpJawMi0ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOPy1tHYw7ln1Qe8Q
	IxMH4yFGCQ5mJRHe6JW+aUK8KYmVValF+fFFpTmpxYcYpTlYlMR5v73uTRESSE8sSc1OTS1I
	LYLJMnFwSjUwzdLcIKjiMUn30NVnhXPtNv/ITpfQWrnG8iKL4anplcU+e5dsPVzFdT25+uGK
	lVvMf67QY2K3XrKn4di/15z6fpdYP548ukcqbtfbKy82C/I99/RaFLBZWXHm01SPPSvqzBK3
	d9sWLn91SOqgh3vKpOU+W+ddcnr8yUdLVU/hx96a++u+d6qeNGJluzJh8zOpR8rXnXYdf50W
	x6vPzXJJ54n9vStKfBZLbjFtORnFMvve/D7tQz8TmOTfhfwy3mNsyaq2gfW5ybNYgUktq3oe
	uqutmuR9wvC2fbmPqMVS74yPHP/SmH3q/TMq5HT/c7xXffHTPT7m4rGOzXrJHbsYM98x+u3K
	2PdBeHvo55KWGiWW4oxEQy3mouJEABuUXQ3uAgAA
X-CMS-MailID: 20240523002322epcas1p2a63dfc646a2b2dd8fcadad2a8807bcee
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240523002322epcas1p2a63dfc646a2b2dd8fcadad2a8807bcee
References: <CGME20240523002322epcas1p2a63dfc646a2b2dd8fcadad2a8807bcee@epcas1p2.samsung.com>

An error unrelated to ufshcd_try_to_abort_task is being output and
can cause confusion. So, I modified it to output the result of abort
fail. This modification was similarly revised by referring to the
ufshcd_abort function.

Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 005d63ab1f44..fc24d1af1fe8 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -667,9 +667,11 @@ int ufshcd_mcq_abort(struct scsi_cmnd *cmd)
 	 * in the completion queue either. Query the device to see if
 	 * the command is being processed in the device.
 	 */
-	if (ufshcd_try_to_abort_task(hba, tag)) {
+	err = ufshcd_try_to_abort_task(hba, tag);
+	if (err) {
 		dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
 		lrbp->req_abort_skip = true;
+		err = FAILED;
 		goto out;
 	}
 
-- 
2.34.1

