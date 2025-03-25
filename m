Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165F7149E13;
	Tue, 25 Mar 2025 06:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742883556; cv=none; b=Woqx+CbLAXQeGg0unr+QEqG9fSdWYuwWlykEddGconJGj1Qlf+gwgM/QiseCscKCw2/cya+u+TmmUkI0OG6cxfZ9mCMARGuX6nmYq+VAjOI0FYhjbkwNN6MgdpSriqsAUCB0i+xsyKjXfMYjUCsm3herKOUd580IZOCe5Janjdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742883556; c=relaxed/simple;
	bh=TO2lEut0XDqrCR4bqwS+85PxH2Zzvo42jRmIrs7h3yA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CamvsRdyHUHBxd7NGtZVV5rCXAjEQIOrL9hdu26D0Bq1YB6neC9J70eTmp4Bp792GhCcfMGLft5gv5QwzxrNuIp3896A9CsdufvZkZDIhKbmmvkVe0uq7B15594UvmEYP1oeP+f3w6VL/FbrtHviibGcg9HzKgca8+8Zo/7Q8XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0c1f444a094111f0a216b1d71e6e1362-20250325
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:7078d6c1-95f9-42bf-9991-d4f1195ba71d,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:14,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:24
X-CID-INFO: VERSION:1.1.45,REQID:7078d6c1-95f9-42bf-9991-d4f1195ba71d,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:14,FILE:0,BULK:0,RULE:Release_HamU,ACTION
	:release,TS:24
X-CID-META: VersionHash:6493067,CLOUDID:941d9d141db511915ec5b711ac73168f,BulkI
	D:250325141904QGK09D20,BulkQuantity:0,Recheck:0,SF:16|19|24|38|43|66|74|78
	|102,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:ni
	l,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:
	0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_USA,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 0c1f444a094111f0a216b1d71e6e1362-20250325
X-User: mengfanhui@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2114292732; Tue, 25 Mar 2025 14:19:02 +0800
From: Fanhui Meng <mengfanhui@kylinos.cn>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	mengfanhui@kylinos.cn
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid_sas: Add write permissions to the scmd_timeout interface
Date: Tue, 25 Mar 2025 14:18:35 +0800
Message-Id: <20250325061835.112404-1-mengfanhui@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Due to the different response capabilities of different RAID cards to commands,
the timeout of each RAID card is adjusted to the optimal value, thus add write
permissions to the scmd_timeout interface.

Signed-off-by: Fanhui Meng <mengfanhui@kylinos.cn>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d85f990aec88..dfe065dd0c75 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -90,7 +90,7 @@ module_param(dual_qdepth_disable, int, 0444);
 MODULE_PARM_DESC(dual_qdepth_disable, "Disable dual queue depth feature. Default: 0");
 
 static unsigned int scmd_timeout = MEGASAS_DEFAULT_CMD_TIMEOUT;
-module_param(scmd_timeout, int, 0444);
+module_param(scmd_timeout, int, 0644);
 MODULE_PARM_DESC(scmd_timeout, "scsi command timeout (10-90s), default 90s. See megasas_reset_timer.");
 
 int perf_mode = -1;
-- 
2.25.1

