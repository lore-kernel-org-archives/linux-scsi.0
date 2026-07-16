Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E246223DFF;
	Thu, 16 Jul 2026 06:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182852; cv=none; b=aP+g68Q9nieeY3JbQKuBMCWEl7pABlb6qOqYe00XC9MRNDcb+5oJmnaeKRkbGVTFdCF9UNIOkcoRpmW3oEfaR96VyAMcqpQ6Tima35Vd9bjVEPYkhFzjWzn4kTKPLdNT/K2fPZIK8VK2VytA337MNICRq+71cklfuqmRVU9haNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182852; c=relaxed/simple;
	bh=nxjbH6GXNrrixcAV67UNPKyYzhZEtJAsGOF4SkLanUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEgPzefOZRiT6eOzIhBuVXfMtUR3q2je8ggtsir4VtEUJc9vyw8j2EUfVRHLswLGgiSXCDfp/j9FWWMCuXFcmHajGUAc0IfARlIUSXGwZIGHrWhTWhI0aUMXkO/vce8VNhNZC4bkIsYsmvKk69g3hSp/jUXL6tC/EBqOX5p3pKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 75785cf480de11f1aa26b74ffac11d73-20260716
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fceac09e-a4d2-46c5-9503-74b842c45b45,IP:15,
	URL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:15
X-CID-INFO: VERSION:1.3.12,REQID:fceac09e-a4d2-46c5-9503-74b842c45b45,IP:15,UR
	L:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:15
X-CID-META: VersionHash:e7bac3a,CLOUDID:94cbe84b7af7721d1a676460f0bae25f,BulkI
	D:2607161420381J7P8O3U,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 75785cf480de11f1aa26b74ffac11d73-20260716
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 861809527; Thu, 16 Jul 2026 14:20:36 +0800
From: liqiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH 4/5] scsi: ufs: rpmb: Validate frame before parsing
Date: Thu, 16 Jul 2026 14:19:54 +0800
Message-ID: <70412f5cb24714052127ada81a7aac0f9d86000e.1784182493.git.liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784182493.git.liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Qiang <liqiang01@kylinos.cn>

The RPMB core only verifies that request and response buffers are
nonempty. This callback reads req_resp at the end of the first request
frame before validating the request length.

Require a complete frame before that access. Use unaligned accessors
because RPMB buffers are passed as u8 pointers and do not have an
alignment guarantee.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufs-rpmb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index ffad049872b9..53f66b274aca 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -69,7 +69,11 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 
 	hba = ufs_rpmb->hba;
 
-	req_type = be16_to_cpu(frm_out->req_resp);
+	/* req_resp is at the end of an RPMB frame. */
+	if (req_len < sizeof(*frm_out))
+		return -EINVAL;
+
+	req_type = get_unaligned_be16(&frm_out->req_resp);
 
 	switch (req_type) {
 	case RPMB_PROGRAM_KEY:
@@ -107,7 +111,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 		struct rpmb_frame *frm_resp = (struct rpmb_frame *)resp;
 
 		memset(frm_resp, 0, sizeof(*frm_resp));
-		frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
 		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
 		if (ret) {
 			dev_err(dev, "Result read request failed with ret=%d\n", ret);
-- 
2.43.0

