Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4995F10D
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2023 19:40:30 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SrJ5c0zlpzMnlt;
	Thu, 14 Dec 2023 11:40:20 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 64396140496;
	Thu, 14 Dec 2023 11:40:28 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Dec 2023 11:40:28 +0800
From: chenxiang <chenxiang66@hisilicon.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>, Yihang Li
	<liyihang9@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [RESEND PATCH 4/5] scsi: hisi_sas: Rollback some operations if FLR failed
Date: Thu, 14 Dec 2023 11:45:15 +0800
Message-ID: <1702525516-51258-5-git-send-email-chenxiang66@hisilicon.com>
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

We obtain the semaphore and set HISI_SAS_RESETTING_BIT in
hisi_sas_reset_prepare_v3_hw(), block the scsi host and set
HISI_SAS_REJECT_CMD_BIT in hisi_sas_controller_reset_prepare(),
released them in hisi_sas_controller_reset_done(). However, if the HW
reset failure in FLR results in early return, the semaphore and flag bits
will not be release.

Rollback some operations including clearing flags / releasing semaphore
when FLR is failed.

Fixes: e5ea48014adc ("scsi: hisi_sas: Implement handlers of PCIe FLR for v3 hw")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index af2cc08..8473060 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4968,6 +4968,7 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
+	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	int rc;
 
@@ -4976,6 +4977,10 @@ static void hisi_sas_reset_done_v3_hw(struct pci_dev *pdev)
 	rc = hw_init_v3_hw(hisi_hba);
 	if (rc) {
 		dev_err(dev, "FLR: hw init failed rc=%d\n", rc);
+		clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
+		scsi_unblock_requests(shost);
+		clear_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags);
+		up(&hisi_hba->sem);
 		return;
 	}
 
-- 
2.8.1

