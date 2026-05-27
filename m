Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14693E9F85
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779873721; cv=none; b=Abk+stxaA+/tFesepsjZ+4QMaEakU9fvhYhSZOtVzV5xRIseF5klpVtA/9Vqc62l0x8L+dzAISaSW9JLVXUN54a3G6vz95X+x8aiqQWC/4Fc2Gi0TOH1l9137iPGAOYEDHlHc13IT0N8S8pDnlasoafxDcBaQOaF6MxAsm26kxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779873721; c=relaxed/simple;
	bh=hsmYXl8xmJm4v7Ncri/9UQiditax/yXaJ41PCUbm35c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=BGvXlX+TC3HiqxK29olzqT9C8NzivrFur5TF920K/A5lFrR04MIeXIwIdcOiA5L8BwgrU05k2uhTxuUT+gy/KAAIm08BrTI8CnAB6W1kgkygb6dWQQnqH18brhfrXN8+iNjtHxmDCBebuHHdLzTfnXjQ40fmZhT/r8OfKOQnfm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mtf5lza8; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mtf5lza8"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260527092153epoutp0337e9a5ba4d652b987705ffe77bd2d3a9~zYbZUifQT2399223992epoutp03t
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:21:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260527092153epoutp0337e9a5ba4d652b987705ffe77bd2d3a9~zYbZUifQT2399223992epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1779873713;
	bh=SuiqQA8qqE+ZYpK5mesn5gTP68L+7eo4i14VRJHlLz0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=mtf5lza8CvEmnvQ9zCBJ0zDVEKM1ApPDSdO1g0lTma8P3GM3AEFUaYY7N2REW4Hwo
	 fnsVd+VOiSnIG1tbrO5MYlHTU+ObzJx9/Si9JOX6qG9QgraOI1jTGc6BGfaBOpXULN
	 VhePtVeXduTh4pM/s8mFHNVrDMwWd/Gu5+knI0ws=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20260527092152epcas1p1665712d5f8b65c809ca29746983f8097~zYbYk1e9b3132231322epcas1p1S;
	Wed, 27 May 2026 09:21:52 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.193]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4gQPJc33zvz3hhT9; Wed, 27 May
	2026 09:21:52 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260527092151epcas1p125118deafc1caad64c4c2c9620124969~zYbX5eJxf0563505635epcas1p1d;
	Wed, 27 May 2026 09:21:51 +0000 (GMT)
Received: from cw9316lee.. (unknown [10.253.101.98]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20260527092151epsmtip2840f4ffc216b62de86ca2ad6b6380634~zYbXzpzjQ0703507035epsmtip2-;
	Wed, 27 May 2026 09:21:51 +0000 (GMT)
From: Chanwoo Lee <cw9316.lee@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, beanhuo@micron.com, can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Chanwoo Lee <cw9316.lee@samsung.com>
Subject: [PATCH] scsi: ufs: Fix wrong value printed in unexpected UPIU
 response case
Date: Wed, 27 May 2026 18:21:34 +0900
Message-ID: <20260527092134.275887-1-cw9316.lee@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260527092151epcas1p125118deafc1caad64c4c2c9620124969
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260527092151epcas1p125118deafc1caad64c4c2c9620124969
References: <CGME20260527092151epcas1p125118deafc1caad64c4c2c9620124969@epcas1p1.samsung.com>

In ufshcd_transfer_rsp_status(), the default case of the inner switch
statement prints the UPIU response code when an unexpected response is
received. However, the code was printing 'result' variable which is
always 0 at that point, making the error message useless for debugging.

Fix this by printing the actual UPIU response code returned by
ufshcd_get_req_rsp().

Fixes: 08108d31129a ("scsi: ufs: Improve type safety")
Signed-off-by: Chanwoo Lee <cw9316.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0371dea44887..d8f309db967e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5706,7 +5706,7 @@ static inline int ufshcd_transfer_rsp_status(struct ufs_hba *hba,
 		default:
 			dev_err(hba->dev,
 				"Unexpected request response code = %x\n",
-				result);
+				ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr));
 			result = DID_ERROR << 16;
 			break;
 		}
-- 
2.43.0

