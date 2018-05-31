From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/9] scsi: hisi_sas: Adjust task reject period during host reset
Date: Thu, 31 May 2018 20:50:45 +0800
Message-ID: <1527771050-200916-5-git-send-email-john.garry@huawei.com>
References: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

After soft_reset() for host reset, we should not be allowed to send
commands to the HW before the PHYs have come up and the port ids have been
refreshed.

Prior to this point, any commands cannot be successfully completed.

This exclusion is achieved by grabbing the host reset semaphore.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 21 ++++++++++++---------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +++-
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 823386f..090d3e0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -536,8 +536,13 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	struct device *dev = hisi_hba->dev;
 	struct hisi_sas_dq *dq = NULL;
 
-	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags)))
-		return -EINVAL;
+	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags))) {
+		if (in_softirq())
+			return -EINVAL;
+
+		down(&hisi_hba->sem);
+		up(&hisi_hba->sem);
+	}
 
 	/* protect task_prep and start_delivery sequence */
 	rc = hisi_sas_task_prep(task, &dq, is_tmf, tmf, &pass);
@@ -1383,30 +1388,28 @@ static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
 		clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 		up(&hisi_hba->sem);
 		scsi_unblock_requests(shost);
-		goto out;
+		clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+		return rc;
 	}
 
-	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
-
 	/* Init and wait for PHYs to come up and all libsas event finished. */
 	hisi_hba->hw->phys_init(hisi_hba);
 	msleep(1000);
 	hisi_sas_refresh_port_id(hisi_hba);
+	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 	up(&hisi_hba->sem);
 
 	if (hisi_hba->reject_stp_links_msk)
 		hisi_sas_terminate_stp_reject(hisi_hba);
 	hisi_sas_reset_init_all_devices(hisi_hba);
 	scsi_unblock_requests(shost);
+	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
 
 	state = hisi_hba->hw->get_phys_state(hisi_hba);
 	hisi_sas_rescan_topology(hisi_hba, old_state, state);
 	dev_info(dev, "controller reset complete\n");
 
-out:
-	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
-
-	return rc;
+	return 0;
 }
 
 static int hisi_sas_abort_task(struct sas_task *task)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0a126a82..c40fdb8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2459,7 +2459,9 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 		return -ENODEV;
 	}
 
-	set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+	if (test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
+		return -1;
+
 	scsi_block_requests(shost);
 	set_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 	flush_workqueue(hisi_hba->wq);
-- 
1.9.1
