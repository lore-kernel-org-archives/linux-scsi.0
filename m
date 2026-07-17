Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089C0367F26;
	Fri, 17 Jul 2026 15:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302785; cv=none; b=NkcQctwttnzpdDudRkxdN+aV6GOr7ulUajPGb83GVIJhQk127GcSBCunXdDaS92SeMyHUipzNOa7EJU9Q536uTtAhJ0Rl5DtGtA8HEChSTA98l4NRyNxzHwwGNLdA6wAhC8OaiilB/omGpSTKZxnLlIjEdb4f8hJGir2OQNgZ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302785; c=relaxed/simple;
	bh=yU2xbCaoZNStlsFxUYW5hUX1bWR5QLoHSQqtPhxddLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ9HEKEUoyPgBzYGbXn+1eRWvsUOi9/3zspoBUqQYsvPUOtxH8ZK47PoEbsCi2orfdw7gs5DDsuEfi5ka8+xD8D+cWEOYR2quSr6kiv4H+II9AQAxUF70PhJtFNwcqN2+xLbP4iA0ggBBym+Q1vT8Eh2u+tgK3i6ngDR1GBx6JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b62888ec81f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:ae611860-979a-4178-9bcd-60614607ebe4,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:ae611860-979a-4178-9bcd-60614607ebe4,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:d658da891c7d306f38e2fd0b8323e121,BulkI
	D:260717233935CX29LHP2,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b62888ec81f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 371168088; Fri, 17 Jul 2026 23:39:34 +0800
From: Li Qiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH v2 5/6] scsi: ufs: rpmb: Use unaligned accessors for RPMB frames
Date: Fri, 17 Jul 2026 23:39:12 +0800
Message-ID: <20260717153914.26321-6-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717153914.26321-1-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RPMB frame buffers are passed as u8 pointers and do not have an

alignment guarantee. Use unaligned accessors for the req_resp field.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufs-rpmb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 431f85b36876..53f66b274aca 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -73,7 +73,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 	if (req_len < sizeof(*frm_out))
 		return -EINVAL;
 
-	req_type = be16_to_cpu(frm_out->req_resp);
+	req_type = get_unaligned_be16(&frm_out->req_resp);
 
 	switch (req_type) {
 	case RPMB_PROGRAM_KEY:
@@ -111,7 +111,7 @@ static int ufs_rpmb_route_frames(struct device *dev, u8 *req, unsigned int req_l
 		struct rpmb_frame *frm_resp = (struct rpmb_frame *)resp;
 
 		memset(frm_resp, 0, sizeof(*frm_resp));
-		frm_resp->req_resp = cpu_to_be16(RPMB_RESULT_READ);
+		put_unaligned_be16(RPMB_RESULT_READ, &frm_resp->req_resp);
 		ret = ufs_sec_submit(hba, protocol_id, resp, resp_len, true);
 		if (ret) {
 			dev_err(dev, "Result read request failed with ret=%d\n", ret);
-- 
2.43.0

