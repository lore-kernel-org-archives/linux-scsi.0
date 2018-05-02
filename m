From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/11] scsi: hisi_sas: stop controller timer for reset
Date: Wed, 2 May 2018 23:56:29 +0800
Message-ID: <1525276594-92173-7-git-send-email-john.garry@huawei.com>
References: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

We should only have the timer enabled after PHY up after
controller reset, so disable prior to reset.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 24416bb..1f27f84 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1130,6 +1130,9 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 	old_state = hisi_hba->hw->get_phys_state(hisi_hba);
 
 	scsi_block_requests(shost);
+	if (timer_pending(&hisi_hba->timer))
+		del_timer_sync(&hisi_hba->timer);
+
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 	rc = hisi_hba->hw->soft_reset(hisi_hba);
 	if (rc) {
-- 
1.9.1
