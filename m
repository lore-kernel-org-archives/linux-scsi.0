From: John Garry <john.garry@huawei.com>
Subject: [PATCH 8/9] scsi: hisi_sas: Add missing PHY spinlock init
Date: Thu, 31 May 2018 20:50:49 +0800
Message-ID: <1527771050-200916-9-git-send-email-john.garry@huawei.com>
References: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

The init is missed for hisi_sas_phy spinlock, so add it.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 20aab10..781b2af 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -808,6 +808,8 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 
 	for (i = 0; i < HISI_PHYES_NUM; i++)
 		INIT_WORK(&phy->works[i], hisi_sas_phye_fns[i]);
+
+	spin_lock_init(&phy->lock);
 }
 
 static void hisi_sas_port_notify_formed(struct asd_sas_phy *sas_phy)
-- 
1.9.1
