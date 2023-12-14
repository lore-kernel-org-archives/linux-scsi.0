Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ACEF4
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 20:00:29 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4SrJ5c0lZfz1wnV5;
	Thu, 14 Dec 2023 11:40:20 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id E62BF1800C7;
	Thu, 14 Dec 2023 11:40:27 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 11:40:27 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [RESEND PATCH 2/5] scsi: hisi_sas: Replace with standard error code return value
Date: Thu, 14 Dec 2023 11:45:13 +0800
Message-ID: <1702525516-51258-3-git-send-email-chenxiang66@hisilicon.com>
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

In function hisi_sas_controller_prereset(), -ENOSYS (Function not
implemented) should be returned if the driver does not support .soft_reset.
Returns -EPERM (Operation not permitted) if HISI_SAS_RESETTING_BIT is
already be set.

In function _suspend_v3_hw(), returns -EPERM (Operation not permitted) if
HISI_SAS_RESETTING_BIT is already be set.

Fixes: 4522204ab218 ("scsi: hisi_sas: tidy host controller reset function a bit")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d50058b..1601706 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1565,12 +1565,12 @@ EXPORT_SYMBOL_GPL(hisi_sas_controller_reset_done);
 static int hisi_sas_controller_prereset(struct hisi_hba *hisi_hba)
 {
 	if (!hisi_hba->hw->soft_reset)
-		return -1;
+		return -ENOENT;
 
 	down(&hisi_hba->sem);
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags)) {
 		up(&hisi_hba->sem);
-		return -1;
+		return -EPERM;
 	}
 
 	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f3eb5cd..af2cc08 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -5018,7 +5018,7 @@ static int _suspend_v3_hw(struct device *device)
 	}
 
 	if (test_and_set_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags))
-		return -1;
+		return -EPERM;
 
 	dev_warn(dev, "entering suspend state\n");
 
-- 
2.8.1

