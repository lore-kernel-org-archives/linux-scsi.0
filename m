Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B17941C2F8
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230685; cv=none; b=Yqxrn2ztTaauUvg2sP6AqhvoE0hFbEVVMGbeEDYY6b+rQRevASoW3WSHVhi7KHofWPDNiDus+/0jKcL7kgd4P3Was3Um5zUs+vEvplX3A9bjNsOfgGYvggi+vmf0RTQv65gO34teiR45pwRw5nnfwcDDBSkzpuNhCzPEMwFmCXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230685; c=relaxed/simple;
	bh=+63ZTf5M1RWcI1MVFzXqsKmGZhLzdmggi77HDIgYxhU=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=KgcQhJPU+shUOvrOBgwf0PtsTrJObSG7nJ9n6jhraNCj8Fn7ayV3k1tvNFWD952SVkKIBdP8lNpnFU348X5+wb194OGWbS0Z3q/xt8Hu8ehWlvPqjXpm6U11pjhhw0deX7KYekW3pSH41dgXhIU0IK7ZSdHxJg3VuTAW47rLFw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cVSPpH2P; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cVSPpH2P"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260728092435epoutp045dafbc87cc4f4fbbd3e88032db45949a~GaddaMM_03111831118epoutp04V
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 09:24:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260728092435epoutp045dafbc87cc4f4fbbd3e88032db45949a~GaddaMM_03111831118epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1785230675;
	bh=grBLpAzGku0vMSw72dRbQsUXhDTj3gNbLndtcsf8qnI=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=cVSPpH2PAq3WJMkc2v2fRtudp5QBscJlX5bZud/AHjSHT569EFmY3OiiWEWvlZoiS
	 6InOh5J+e11CMHfckV87ZrPBkBftHq9ll2Q7C1eCRPZel4eJvIQh7x01o7u9l/IjvP
	 WBPrtDJGIyU3BJQMH4a+IuINIoykcgfyCrsiEjkg=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPS id
	20260728092435epcas2p309bad6673e8653055eb8f5bba0cf9f1e~Gadc9J6yq1969619696epcas2p3Z;
	Tue, 28 Jul 2026 09:24:35 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.199]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4h8VR71gH9z3hhTC; Tue, 28 Jul
	2026 09:24:35 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v4 1/2] scsi: ufs: Use unsigned types for the BSG query
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
In-Reply-To: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260728092434epcms2p56b013ab7a2df90d3df9186322de54340@epcms2p5>
Date: Tue, 28 Jul 2026 18:24:34 +0900
X-CMS-MailID: 20260728092434epcms2p56b013ab7a2df90d3df9186322de54340
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0
References: <20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p8>
	<CGME20260728092208epcms2p881b17276fb41c006a4229c1d073b4ad0@epcms2p5>

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
index 58b506eac6dc..089cf81de275 100644
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
 
+	*desc_len = min(*desc_len, QUERY_DESC_MAX_SIZE);
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

