Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4FA283FE5
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2025 10:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749031449; cv=none; b=JhrJ17bAvzbs2sWrEMN8xBAS8VOMQYH9iNEEKKTd9To/G+wAHcAq/zsSIGYbS8BIiIhwVBtZkHp4kiiafgMs5yBCWgDqwMjOs9Gzc4G/ip7dcsWp23Lx7Jd/hQGGALQiPUvau8YDckQMu7bNG6zNgNZ4cQs9Fxux3DbHw2ozUbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749031449; c=relaxed/simple;
	bh=YBHPi8pMtQ1DVcIaBi1fzoZwSQbZj0sVip/mtnVjshU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=VilBAwZKg4618IBD6ZEUKkHWFDXgyx2oWIfhJx3mLREY0jw7aLSbfzmTWm3/FC9VkBltyWGeCHgp9nCIYuoN00kcY3o8BkuKcboptq3QDgnEIw69ekv17qfL1qKgVCXWkAwtXEWy3VrxsoIV/CsBpegkth9fgVcKx2P44ZPjiIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3b49bd3c412b11f0b29709d653e92f7d-20250604
X-CTIC-Tags:
	HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE
	HR_FROM_DIGIT_LEN, HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:ef5fc255-2a4d-4a2f-93f7-6af5513d8aec,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:15
X-CID-INFO: VERSION:1.1.45,REQID:ef5fc255-2a4d-4a2f-93f7-6af5513d8aec,IP:0,URL
	:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-META: VersionHash:6493067,CLOUDID:5e5a406c31d9e2aaa265f2dc99159afe,BulkI
	D:250604180401QWA8UE6M,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102,TC:n
	il,Content:0|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 3b49bd3c412b11f0b29709d653e92f7d-20250604
X-User: lijun01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijun01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1048058123; Wed, 04 Jun 2025 18:03:58 +0800
From: Li Jun <lijun01@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	lijun01@kylinos.cn
Subject: [PATCH] scsi: arcmsr: return the value of fun directly
Date: Wed,  4 Jun 2025 18:03:42 +0800
Message-Id: <20250604100342.128769-1-lijun01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

return pci_register_driver directly,just look clean.

Signed-off-by: Li Jun <lijun01@kylinos.cn>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index b450b1fc6bbb..c3a71a3fdcd0 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1777,9 +1777,7 @@ static void arcmsr_shutdown(struct pci_dev *pdev)
 
 static int __init arcmsr_module_init(void)
 {
-	int error = 0;
-	error = pci_register_driver(&arcmsr_pci_driver);
-	return error;
+	return pci_register_driver(&arcmsr_pci_driver);
 }
 
 static void __exit arcmsr_module_exit(void)
-- 
2.25.1

