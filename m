Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A53F10F
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 19:40:30 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SrJ5h3blbzZdPJ;
	Thu, 14 Dec 2023 11:40:24 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id D34AA180066;
	Thu, 14 Dec 2023 11:40:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 11:40:28 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [RESEND PATCH 5/5] scsi: hisi_sas: Correct the number of global debugfs registers
Date: Thu, 14 Dec 2023 11:45:16 +0800
Message-ID: <1702525516-51258-6-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
References: <1702525516-51258-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500025.china.huawei.com (7.221.188.170)

From: Yihang Li <liyihang9@huawei.com>

In function debugfs_debugfs_snapshot_global_reg_v3_hw() it uses
debugfs_axi_reg.count (which is the number of axi debugfs registers) to
acquire the number of global debugfs registers.

Use debugfs_global_reg.count to acquire the number of global debugfs
registers instead.

Fixes: 623a4b6d5c2a ("scsi: hisi_sas: Move debugfs code to v3 hw driver")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8473060..b56fbc6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3476,7 +3476,7 @@ static void debugfs_snapshot_global_reg_v3_hw(struct hisi_hba *hisi_hba)
 	u32 *databuf = hisi_hba->debugfs_regs[dump_index][DEBUGFS_GLOBAL].data;
 	int i;
 
-	for (i = 0; i < debugfs_axi_reg.count; i++, databuf++)
+	for (i = 0; i < debugfs_global_reg.count; i++, databuf++)
 		*databuf = hisi_sas_read32(hisi_hba, 4 * i);
 }
 
-- 
2.8.1

