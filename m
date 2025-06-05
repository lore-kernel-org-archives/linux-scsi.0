Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1F11F4176
	for <linux-scsi@vger.kernel.org>; Thu,  5 Jun 2025 07:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749109872; cv=none; b=QMvjEgMKH/wnzAjwEE01oOCOhmTYNG0TbXotu+vCVKiSdRtM5DzTMbEvy1YLg3PgkfkYr2PPFD/qQ5JjXJVbLMwTFrnyRCIqEvVA8zgKVAcU0PbKvDuLd0NQizT97ky2a8D1Rld0M5yaz98WNTOCfe2kWmgMCdU6nRtirZHZVSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749109872; c=relaxed/simple;
	bh=VjvAhoL/vTPClVJ+IQh2kT3nlCQRlhpVeZ/Kb8+D124=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=i2zV4TPWoQ8NL8IJSMedS0AvQgc9QV3JSYGL5N4KhhDRXKXoVG7tWph5lReajyv6sYk9Xhi0aVbHc46x5UBcgtgDUT4F3vD9hTqHjlyIJSLl9+G0zcWOmLfzD01j420vftBWBCILeLvofSfsKeGU0wnKG/4rsqNjlOZx6IX8PTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d3defce041e111f0b29709d653e92f7d-20250605
X-CTIC-Tags:
	HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE
	HR_FROM_DIGIT_LEN, HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN
	HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS
	HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED
	DN_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:01a7859e-d677-4703-a01e-4bf02c7234f5,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:15
X-CID-INFO: VERSION:1.1.45,REQID:01a7859e-d677-4703-a01e-4bf02c7234f5,IP:0,URL
	:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-META: VersionHash:6493067,CLOUDID:6bb68523192d489ab21e498317cd6db8,BulkI
	D:250605155103PJXT8XHN,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102,TC:n
	il,Content:0|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: d3defce041e111f0b29709d653e92f7d-20250605
X-User: lijun01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lijun01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1956813705; Thu, 05 Jun 2025 15:51:02 +0800
From: Li Jun <lijun01@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	lijun01@kylinos.cn
Subject: [PATCH v2] scsi: arcmsr: return the value of fun directly
Date: Thu,  5 Jun 2025 15:50:47 +0800
Message-Id: <20250605075047.218827-1-lijun01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Maybe the 'error' variable is not needed,as arcmsr_module_init
can return the result of pci_register_driver(&arcmsr_pci_driver)
directly.

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

