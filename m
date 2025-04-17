Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0908D19DF75
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 02:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744857263; cv=none; b=qJoYF//8Rft1ve+EpEQzzUzQ0wOz00qswyQR1zIxGG0ayFF48IieMqYObktzkSwzm58nJi8GqcRu1AsnSSxfO6giwje+ltfj7KoZJmxz63ya0btIRweWq03SvRiXDI2o6DKPk4/J5leCnO7/dY49+7NnxcmWXWq0ecn2RYKWJ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744857263; c=relaxed/simple;
	bh=kNB2L12JvfmAaJ0HDfR2s4w/6I+kNU9uKDMuBpUt8z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DqYQpOOokEuFpLXyxnI0dyT4Xf7/mX5JHtUgHqLX5HMPBH42bqzZsYda8VFYy8JPwErAQpgNzsELR7EFvfWKDJX7LW8QfT9OVSiERCSOio4iBgsvyE5xzdkq0QD419TNp8Zs+V+baGPc1jWWg//b5seaG9JZ2K7j5834OnT3rEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=h+FZRigx; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="h+FZRigx"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250417023418epoutp01dc3a5821e659ba1a07f0b19143544457~2_m6hGPnI2271422714epoutp01g
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 02:34:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250417023418epoutp01dc3a5821e659ba1a07f0b19143544457~2_m6hGPnI2271422714epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744857258;
	bh=D7F7NaF5UnEmaeue9Kdvmd+i76+NOJP5kgA7N0uBp14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+FZRigx+251a0pm87PnfHqgLouyksbhqwaKML6bAwFfdgWcHMfwEdI1UeL4DixkZ
	 3l5HkItXaAd1dVkyhBIXayFcIKFfcfBQsG7uOxrO/z4pDLVQYJgop8lkLOnxJ98eP/
	 bB9rtC1JsK4tQZnVIQC9inlmWnwy9c0R/8zwd340=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20250417023418epcas1p323d719cfa7c6097f0d1d522a6b3ef6d5~2_m54j3gB1516515165epcas1p3B;
	Thu, 17 Apr 2025 02:34:18 +0000 (GMT)
Received: from epsmgec1p1-new.samsung.com (unknown [182.195.38.249]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZdMRF4WJgz6B9mG; Thu, 17 Apr
	2025 02:34:17 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
	epsmgec1p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.63.19624.9A860086; Thu, 17 Apr 2025 11:34:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d~2_m5HjoDO1513415134epcas1p3j;
	Thu, 17 Apr 2025 02:34:17 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250417023417epsmtrp107fcb2fdde25f1994b322dd480e92699~2_m5Gni-h2422224222epsmtrp1C;
	Thu, 17 Apr 2025 02:34:17 +0000 (GMT)
X-AuditID: b6c32a4c-079ff70000004ca8-89-680068a9e8de
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	85.03.19478.8A860086; Thu, 17 Apr 2025 11:34:17 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.61]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250417023416epsmtip2c51b53f9cf38df6985d1fd2bcf31e089~2_m4zQ1s72619426194epsmtip2b;
	Thu, 17 Apr 2025 02:34:16 +0000 (GMT)
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
Subject: [PATCH 1/2] scsi: ufs: Add an enum for ufs_trace to check ufs cmd
 error
Date: Thu, 17 Apr 2025 11:34:03 +0900
Message-ID: <20250417023405.6954-2-dh0421.hwang@samsung.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250417023405.6954-1-dh0421.hwang@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmru7KDIYMg0eLlCwezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/STkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRW
	KbUgJafArECvODG3uDQvXS8vtcTK0MDAyBSoMCE7Y9MM1YLvnBV7JjezNzAu4Ohi5OSQEDCR
	mHTyGlsXIxeHkMAeRokT8w5COZ8YJfYe+ssO51w/8ogdpuXXjGdQVTsZJU7f+MEI4XxmlLj2
	+zYrSBWbgJ7Ent5VrCAJEYF5TBKdl5awgDjMAh8ZJRbees0GUiUsECRx6+hPRhCbRUBV4l/f
	OxYQm1fARmLRk3YmiH3yEpe62sB2cwrYShx9ehuqRlDi5MwnYDYzUE3z1tnMIAskBK5wSBw9
	3cUK0ewi0dL5iw3CFpZ4dXwL1BNSEi/726DsYokr585C1bQwSjzqyICw7SWaW5uB4hxACzQl
	1u/Sh9jFJ/Huaw8rSFhCgFeio00IolpNYvG/70CvsAPZMhKN3BBRD4nHbW9YIOEzgVHi0M6N
	7BMY5WcheWAWkgdmIexawMi8ilEqtaA4Nz012bDAUDcvtRwes8n5uZsYwWlby2cH4/f1f/UO
	MTJxMB5ilOBgVhLhPWf+L12INyWxsiq1KD++qDQntfgQoykwiCcyS4km5wMzR15JvKGJpYGJ
	mZGJhbGlsZmSOO+ej0/ThQTSE0tSs1NTC1KLYPqYODilGpjimtcUdyyPm1+nvCtacU77tNb8
	Us3c5Q9Xz3J6t7VigXjdx+887/rcElRi31tHT1Bq2dkoINxbubR1x9tzd5NitrV/ry2XfDdr
	bvTb7YtbJq1fXrNudf0H1qiC0t60u+3bt1seyHlhn/op8tZa6ZhMg31MR9LqFzrfSpU6WK28
	d+kRNvFSQ021OTFnt/oHNS+Tuvng/E+Vy1o7TcxqPr6/kWH1fhK30PrzbtsfBz9q8vO48fuL
	7rbfutzqFt4TKrntE7sZp3G8cz1oG927cuaXRYrJ8bK8+/4vFZ31+3eWTntdmfttcT3VJwK7
	jxtKNfIs8zvscCQi0s0l88v0RYduXxJ5auZq2x380fRUaYsSS3FGoqEWc1FxIgBOKm/SZAQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSvO7KDIYMg+OfmCwezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONou7
	LZ2sFsuP/2Oy2PrpN6vFt74n7BZNf/axWFw7c4LVYvOlbywOwh6Xr3h7TJt0is3jzrU9bB4t
	J/ezeHx8eovFY+KeOo++LasYPT5vkvNoP9DNFMAZxWWTkpqTWZZapG+XwJWxaYZqwXfOij2T
	m9kbGBdwdDFyckgImEj8mvGMrYuRi0NIYDujxP4JnWwQCRmJ7vt72bsYOYBsYYnDh4shaj4y
	Ssx9NZUVpIZNQE9iT+8qVpCEiMAKJon5tz6ygzjMAr8ZJSb9aGYHqRIWCJBoP7wDzGYRUJX4
	1/eOBcTmFbCRWPSknQlim7zEpa42sBpOAVuJo09vg9UIAdVM/9rKDlEvKHFy5hOwODNQffPW
	2cwTGAVmIUnNQpJawMi0ilE0taA4Nz03ucBQrzgxt7g0L10vOT93EyM40rSCdjAuW/9X7xAj
	EwfjIUYJDmYlEd5z5v/ShXhTEiurUovy44tKc1KLDzFKc7AoifMq53SmCAmkJ5akZqemFqQW
	wWSZODilGph0fvDsSqtl2vgpfdLiTbPkzdx5Y3tNlu07Y+H569SZOE2zp8U52r3Fffbzw9Yd
	O786YptPgPHiCSdrNi9zetWT6GF1e37qwkMnKl3uNDtc+3oqbIneriBjgzd5gSHt0f5hV7Pq
	mg5J/hPJcvTP+RuXInBFLWYPe7hGeHRqm4fNnCrPlTv7vFabF39dYCFWfvDpUZYy9pijlzrX
	1v3eejh3GfNJywmqEztKFmy5+uOFxSaDsuaFm3yaRJ+Y3kiLtpl/zbZXNzWN435X/cfDtVsZ
	kvufH1+e3BC1JGP/CqcLEsxmjosZFfsSL9wOaZz+IjjoVhu3yhLm090NLUUTvuve+rc9/eNl
	w/9eJg35EUosxRmJhlrMRcWJALLRTlojAwAA
X-CMS-MailID: 20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
	<CGME20250417023417epcas1p31338c05e70e61b0a5e96d0ac0910713d@epcas1p3.samsung.com>

There is no trace when a ufs uic cmd error occurs.
So, add "UFS_CMD_ERR" enumeration to ufs_trace_str_t.

Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
---
 drivers/ufs/core/ufs_trace.h | 1 +
 include/ufs/ufs.h            | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
index caa32e23ffa5..43830a092637 100644
--- a/drivers/ufs/core/ufs_trace.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -41,6 +41,7 @@
 #define UFS_CMD_TRACE_STRINGS					\
 	EM(UFS_CMD_SEND,	"send_req")			\
 	EM(UFS_CMD_COMP,	"complete_rsp")			\
+	EM(UFS_CMD_ERR,		"req_complete_err")		\
 	EM(UFS_DEV_COMP,	"dev_complete")			\
 	EM(UFS_QUERY_SEND,	"query_send")			\
 	EM(UFS_QUERY_COMP,	"query_complete")		\
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index c0c59a8f7256..7f2d418bdd86 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -631,7 +631,7 @@ struct ufs_dev_info {
  * This enum is used in string mapping in ufs_trace.h.
  */
 enum ufs_trace_str_t {
-	UFS_CMD_SEND, UFS_CMD_COMP, UFS_DEV_COMP,
+	UFS_CMD_SEND, UFS_CMD_COMP, UFS_CMD_ERR, UFS_DEV_COMP,
 	UFS_QUERY_SEND, UFS_QUERY_COMP, UFS_QUERY_ERR,
 	UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR
 };
-- 
2.48.1

