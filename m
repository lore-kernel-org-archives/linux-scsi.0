From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: pm8001: clean up various indentation issues
Date: Sun, 17 Mar 2019 18:15:32 +0000
Message-ID: <20190317181532.27477-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu@usish.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several lines of code where the indentation is
at an incorrect level; fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  8 +++---
 drivers/scsi/pm8001/pm8001_sas.c |  4 +--
 drivers/scsi/pm8001/pm80xx_hwi.c | 44 ++++++++++++++++----------------
 3 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index d0bb357034d8..e0fee3d91d23 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -960,9 +960,9 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 		return -1;
 	}
 	regVal = pm8001_cr32(pm8001_ha, 2, GPIO_GPIO_0_0UTPUT_CTL_OFFSET);
-		PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("GPIO Output Control Register:"
-				" = 0x%x\n", regVal));
+	PM8001_INIT_DBG(pm8001_ha,
+			pm8001_printk("GPIO Output Control Register:"
+			" = 0x%x\n", regVal));
 	/* set GPIO-0 output control to tri-state */
 	regVal &= 0xFFFFFFFC;
 	pm8001_cw32(pm8001_ha, 2, GPIO_GPIO_0_0UTPUT_CTL_OFFSET, regVal);
@@ -2928,7 +2928,7 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAM_STAT_GOOD;
-	if (pm8001_dev)
+		if (pm8001_dev)
 			pm8001_dev->running_req--;
 		break;
 	case IO_ABORTED:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 084f2fcced0a..88eef3b18e41 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -740,8 +740,8 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		wait_for_completion(&task->slow_task->completion);
 		if (pm8001_ha->chip_id != chip_8001) {
 			pm8001_dev->setds_completion = &completion_setstate;
-				PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
-					pm8001_dev, 0x01);
+			PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
+				pm8001_dev, 0x01);
 			wait_for_completion(&completion_setstate);
 		}
 		res = -TMF_RESP_FUNC_FAILED;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 63e4f7d34d6c..536d2b4384f8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1316,7 +1316,7 @@ pm80xx_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 
 static void pm80xx_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 {
-	 u32 i;
+	u32 i;
 
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("chip reset start\n"));
@@ -4381,27 +4381,27 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			sata_cmd.len = cpu_to_le32(task->total_xfer_len);
 			sata_cmd.esgl = 0;
 		}
-			/* scsi cdb */
-			sata_cmd.atapi_scsi_cdb[0] =
-				cpu_to_le32(((task->ata_task.atapi_packet[0]) |
-				(task->ata_task.atapi_packet[1] << 8) |
-				(task->ata_task.atapi_packet[2] << 16) |
-				(task->ata_task.atapi_packet[3] << 24)));
-			sata_cmd.atapi_scsi_cdb[1] =
-				cpu_to_le32(((task->ata_task.atapi_packet[4]) |
-				(task->ata_task.atapi_packet[5] << 8) |
-				(task->ata_task.atapi_packet[6] << 16) |
-				(task->ata_task.atapi_packet[7] << 24)));
-			sata_cmd.atapi_scsi_cdb[2] =
-				cpu_to_le32(((task->ata_task.atapi_packet[8]) |
-				(task->ata_task.atapi_packet[9] << 8) |
-				(task->ata_task.atapi_packet[10] << 16) |
-				(task->ata_task.atapi_packet[11] << 24)));
-			sata_cmd.atapi_scsi_cdb[3] =
-				cpu_to_le32(((task->ata_task.atapi_packet[12]) |
-				(task->ata_task.atapi_packet[13] << 8) |
-				(task->ata_task.atapi_packet[14] << 16) |
-				(task->ata_task.atapi_packet[15] << 24)));
+		/* scsi cdb */
+		sata_cmd.atapi_scsi_cdb[0] =
+			cpu_to_le32(((task->ata_task.atapi_packet[0]) |
+			(task->ata_task.atapi_packet[1] << 8) |
+			(task->ata_task.atapi_packet[2] << 16) |
+			(task->ata_task.atapi_packet[3] << 24)));
+		sata_cmd.atapi_scsi_cdb[1] =
+			cpu_to_le32(((task->ata_task.atapi_packet[4]) |
+			(task->ata_task.atapi_packet[5] << 8) |
+			(task->ata_task.atapi_packet[6] << 16) |
+			(task->ata_task.atapi_packet[7] << 24)));
+		sata_cmd.atapi_scsi_cdb[2] =
+			cpu_to_le32(((task->ata_task.atapi_packet[8]) |
+			(task->ata_task.atapi_packet[9] << 8) |
+			(task->ata_task.atapi_packet[10] << 16) |
+			(task->ata_task.atapi_packet[11] << 24)));
+		sata_cmd.atapi_scsi_cdb[3] =
+			cpu_to_le32(((task->ata_task.atapi_packet[12]) |
+			(task->ata_task.atapi_packet[13] << 8) |
+			(task->ata_task.atapi_packet[14] << 16) |
+			(task->ata_task.atapi_packet[15] << 24)));
 	}
 
 	/* Check for read log for failed drive and return */
-- 
2.20.1
