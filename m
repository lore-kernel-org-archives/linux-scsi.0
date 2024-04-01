Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF138F5C
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2024 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711950829; cv=none; b=dzq8yWjVzaVqX08coN06jrZ/r166vPDgWMZcFxU+t/T7ibE46ylOXb0wGdTEvz1+MKVo0IdokH6Fq4Xc80HLL38Jy1gTFobLlgUEHpGHWzcdeGMMpDCABIoWvMUChs644bNoTN4ulOsc1mke+UskhmbMUJ9fKqiZl8NInhkVTgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711950829; c=relaxed/simple;
	bh=JZVI8UYINDYADXlHQvgofMOzMm02S6wJuzzLP8vlub8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jMCvEjAPu7PRrSZFIjVZeKAAayxdDvAiFGEsAXF/MP2+3rEf0FIsFXlFRjJDWvqmkUjshcSixDebScE0X+Fr2lvXv9DHwJbXy+vXyNzKsOt1IIGMreGmzvUbGZI43uVPwXtDt7to0JqA5wVG3C+z0O4qPA35yh9n0mhTMXrFZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4V7Kqz27KDz1R9dJ;
	Mon,  1 Apr 2024 13:50:55 +0800 (CST)
Received: from kwepemd200015.china.huawei.com (unknown [7.221.188.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 66437180060;
	Mon,  1 Apr 2024 13:53:39 +0800 (CST)
Received: from huawei.com (10.67.165.2) by kwepemd200015.china.huawei.com
 (7.221.188.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 1 Apr
 2024 13:53:38 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/2] scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()
Date: Mon, 1 Apr 2024 13:49:14 +0800
Message-ID: <20240401054914.721093-3-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20240401054914.721093-1-chenxiang66@hisilicon.com>
References: <20240401054914.721093-1-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200015.china.huawei.com (7.221.188.21)

From: Yihang Li <liyihang9@huawei.com>

We found that the second parameter of function ata_wait_after_reset() is
incorrectly used. We call smp_ata_check_ready_type() to poll the device
type until the 30s timeout, so the correct deadline should be (jiffies +
30000).

Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Signed-off-by: xiabing <xiabing12@h-partners.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 097dfe4b620d..7245600aedb2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1796,8 +1796,10 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 
 	if (dev_is_sata(device)) {
 		struct ata_link *link = &device->sata_dev.ap->link;
+		unsigned long deadline = ata_deadline(jiffies,
+				HISI_SAS_WAIT_PHYUP_TIMEOUT / HZ * 1000);
 
-		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+		rc = ata_wait_after_reset(link, deadline,
 					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
-- 
2.30.0

