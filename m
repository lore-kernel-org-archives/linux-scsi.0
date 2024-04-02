Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7629BA3F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Apr 2024 03:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030383; cv=none; b=OVSO5Vf41MUThH0AML9/cmXstMHME+smGjGsjQFHSImxARzQ9+N9Gg1myCoUVPc5KXplCngflb45eu1k0q+KcOMHNtpOOM8MAykXZda41vRbennLhtw992VvE2fMd2V3PU3aARKStiUMnbdFBlcXp/O857aKoyVxUZNURMvmFIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030383; c=relaxed/simple;
	bh=VHW4/JKm5vgh5Tlmep3gWPcKsdnecZxTHjKRKmhti4Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tvcsZ8PMQ76pLo84OyM8Ylcjii/u7oWyf33iNnbjThJHyLUb/hIOenWztoCa8J/DTK/yyAE+DOL3fosYGy9mlwhyTFJc7TEnncZFp6F5h6TRbPM+pqY/shAb2yudkBu/vCVt920AHqaaopnJJ0G4RNzOo7FIz8rDEcElQRgbo98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4V7vJ708V8z1wnrX;
	Tue,  2 Apr 2024 11:58:47 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id CB7DC140133;
	Tue,  2 Apr 2024 11:59:38 +0800 (CST)
Received: from huawei.com (10.67.165.2) by kwepemd200015.china.huawei.com
 (7.221.188.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Tue, 2 Apr
 2024 11:59:38 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 2/2] scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()
Date: Tue, 2 Apr 2024 11:55:13 +0800
Message-ID: <20240402035513.2024241-3-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
References: <20240402035513.2024241-1-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200015.china.huawei.com (7.221.188.21)

From: Xiang Chen <chenxiang66@hisilicon.com>

We found that the second parameter of function ata_wait_after_reset() is
incorrectly used. We call smp_ata_check_ready_type() to poll the device
type until the 30s timeout, so the correct deadline should be (jiffies +
30000).

Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Signed-off-by: xiabing <xiabing12@h-partners.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 097dfe4b620d..35f8e00850d6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1797,7 +1797,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 	if (dev_is_sata(device)) {
 		struct ata_link *link = &device->sata_dev.ap->link;
 
-		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+		rc = ata_wait_after_reset(link, jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT,
 					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
-- 
2.30.0

