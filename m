Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7745136F8EF
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784862640; cv=none; b=cQ4s352L30NWQ5PBPXu3yq2+6ExRoN0WGug14EhgHf5bX6iFq0sMk+p29We7cnqJ3KfgUq45k+ZF1XAaezNU93Bj59cy/wjr4unlrWmDh1SBBl1UyO/NR4uVJMTuDCskIutVGn9qeHykvCn/P7Jmon0Fo1g4eKgw3q+Js3l2tvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784862640; c=relaxed/simple;
	bh=nOzdidjXQV0uz1EFMYu1dWklnHb4gWft3rugDHKnOjU=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=hUF3uQgJFfzOrw8cBkmPSl+QVeXHt28flBLoeypockTyR24pvsz6YVnJFrchfR3te7R3YmxLKmYGTCK6CCeuNzz/CBCUGNxy0Sv064t5kd72kaDgyJpwVbboS5jIAFwuGOcYUhncNFcnEF9DjXb8hz0b+FUBGFaLyfLVFVAMfE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XH2+m++M; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XH2+m++M"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260724031036epoutp037a6ae562461698f9c46bea4acb801f02~FGxxkgsxE3076930769epoutp036
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:10:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260724031036epoutp037a6ae562461698f9c46bea4acb801f02~FGxxkgsxE3076930769epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784862636;
	bh=tojf8rj2bem989rr1WHdMeD6Sk/iktrZUYltKHtYFcM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=XH2+m++MlVny4b/2teIGS7CR4QmynxaSfXJJEll9CMjMu8pSYaeLJ/TF42rTaQLmk
	 okcWtFsUhoB2/Xn8AR1ZhbSv2KiVAmOGVU7yh9Jvk/A30cc9sKOpmnT6NvRWtdG1fZ
	 s2Ms7BhwUMDa8nLd4tMvLbmJVfYX08sweCA2QbKQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260724031035epcas2p27d8a3d9c0bd144ac23f2826c2880b29a~FGxxMW4Mw3106531065epcas2p2x;
	Fri, 24 Jul 2026 03:10:35 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.203]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h5tKR3Ngpz6B9m7; Fri, 24 Jul
	2026 03:10:35 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v3 1/2] scsi: ufs: Use unsigned types for the BSG query
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: ALIM AKHTAR <alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Jinyoung Choi <j-young.choi@samsung.com>, Dukhyun Kwon
	<d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>, Keoseong Park
	<keosung.park@samsung.com>, Jaemyung Lee <jaemyung.lee@samsung.com>, Jieon
	Seol <jieon.seol@samsung.com>, Gyusun Lee <gyusun.lee@samsung.com>, Yunjae
	Jo <yunjae00.jo@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260724031034epcms2p14226b8d04342b36525abd33aa33d3815@epcms2p1>
Date: Fri, 24 Jul 2026 12:10:34 +0900
X-CMS-MailID: 20260724031034epcms2p14226b8d04342b36525abd33aa33d3815
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa
References: <20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
	<CGME20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p1>

The UPIU query length field is an unsigned 16-bit value per the UFS
standard, but ufs_bsg carried it around in signed int. Switch the
descriptor length and buffer pointer to u16/u8, fold the trivial
ufs_bsg_get_query_desc_size() helper into its only caller, and replace
min_t(int, ...) with min(). No functional change intended.

Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
---
 drivers/ufs/core/ufs_bsg.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index 58b506eac6dc..b300d9156fac 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -13,21 +13,8 @@
 #include <ufs/ufshcd.h>
 #include "ufshcd-priv.h"
 
-static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_len,
-				       struct utp_upiu_query *qr)
-{
-	int desc_size = be16_to_cpu(qr->length);
-
-	if (desc_size <= 0)
-		return -EINVAL;
-
-	*desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
-
-	return 0;
-}
-
 static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
-				     uint8_t **desc_buff, int *desc_len,
+				     u8 **desc_buff, u16 *desc_len,
 				     enum query_opcode desc_op)
 {
 	struct ufs_bsg_request *bsg_request = job->request;
@@ -39,11 +26,14 @@ static int ufs_bsg_alloc_desc_buffer(struct ufs_hba *hba, struct bsg_job *job,
 		goto out;
 
 	qr = &bsg_request->upiu_req.qr;
-	if (ufs_bsg_get_query_desc_size(hba, desc_len, qr)) {
+	*desc_len = be16_to_cpu(qr->length);
+	if (*desc_len == 0) {
 		dev_err(hba->dev, "Illegal desc size\n");
 		return -EINVAL;
 	}
 
+	*desc_len = min(*desc_len, (u16)QUERY_DESC_MAX_SIZE);
+
 	if (*desc_len > job->request_payload.payload_len) {
 		dev_err(hba->dev, "Illegal desc size\n");
 		return -EINVAL;
@@ -136,8 +126,9 @@ static int ufs_bsg_request(struct bsg_job *job)
 	struct ufs_hba *hba = shost_priv(dev_to_shost(job->dev->parent));
 	struct uic_command uc = {};
 	int msgcode;
-	uint8_t *buff = NULL;
-	int desc_len = 0;
+	u8 *buff = NULL;
+	u16 desc_len = 0;
+	int buff_len;
 	enum query_opcode desc_op = UPIU_QUERY_OPCODE_NOP;
 	int ret;
 	bool rpmb = false;
@@ -156,9 +147,11 @@ static int ufs_bsg_request(struct bsg_job *job)
 		fallthrough;
 	case UPIU_TRANSACTION_NOP_OUT:
 	case UPIU_TRANSACTION_TASK_REQ:
+		buff_len = desc_len;
 		ret = ufshcd_exec_raw_upiu_cmd(hba, &bsg_request->upiu_req,
 					       &bsg_reply->upiu_rsp, msgcode,
-					       buff, &desc_len, desc_op);
+					       buff, &buff_len, desc_op);
+		desc_len = buff_len;
 		if (ret)
 			dev_err(hba->dev, "exe raw upiu: error code %d\n", ret);
 		else if (desc_op == UPIU_QUERY_OPCODE_READ_DESC && desc_len) {
-- 
2.25.1
