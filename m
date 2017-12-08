From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/19] scsi: hisi_sas: add some print to enhance debugging
Date: Sat, 9 Dec 2017 01:16:41 +0800
Message-ID: <1512753410-50924-11-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add some print at some places such as error info and cq
of exception IO, device found etc, and also adjust some
log levels.

All this to assist debugging ability.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 15 ++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 24 +++++++++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 22 +++++++++++++++++-----
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fb162c0..1f6f063 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -580,6 +580,9 @@ static int hisi_sas_dev_found(struct domain_device *device)
 		}
 	}
 
+	dev_info(dev, "dev[%d:%x] found\n",
+		sas_dev->device_id, sas_dev->dev_type);
+
 	return 0;
 }
 
@@ -735,7 +738,7 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
 
-	dev_info(dev, "found dev[%d:%x] is gone\n",
+	dev_info(dev, "dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
 
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
@@ -866,12 +869,13 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
 			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 				struct hisi_sas_slot *slot = task->lldd_task;
 
-				dev_err(dev, "abort tmf: TMF task timeout\n");
+				dev_err(dev, "abort tmf: TMF task timeout and not done\n");
 				if (slot)
 					slot->task = NULL;
 
 				goto ex_err;
-			}
+			} else
+				dev_err(dev, "abort tmf: TMF task timeout\n");
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
@@ -1495,9 +1499,10 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 			if (slot)
 				slot->task = NULL;
-			dev_err(dev, "internal task abort: timeout.\n");
+			dev_err(dev, "internal task abort: timeout and not done.\n");
 			goto exit;
-		}
+		} else
+			dev_err(dev, "internal task abort: timeout.\n");
 	}
 
 	if (task->task_status.resp == SAS_TASK_COMPLETE &&
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index cd9cd84..8d6886a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2361,6 +2361,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	ts->resp = SAS_TASK_COMPLETE;
 
 	if (unlikely(aborted)) {
+		dev_dbg(dev, "slot_complete: task(%p) aborted\n", task);
 		ts->stat = SAS_ABORTED_TASK;
 		spin_lock_irqsave(&hisi_hba->lock, flags);
 		hisi_sas_slot_task_free(hisi_hba, task, slot);
@@ -2405,6 +2406,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		(!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))) {
 		u32 err_phase = (complete_hdr->dw0 & CMPLT_HDR_ERR_PHASE_MSK)
 				>> CMPLT_HDR_ERR_PHASE_OFF;
+		u32 *error_info = hisi_sas_status_buf_addr_mem(slot);
 
 		/* Analyse error happens on which phase TX or RX */
 		if (ERR_ON_TX_PHASE(err_phase))
@@ -2412,6 +2414,16 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		else if (ERR_ON_RX_PHASE(err_phase))
 			slot_err_v2_hw(hisi_hba, task, slot, 2);
 
+		if (ts->stat != SAS_DATA_UNDERRUN)
+			dev_info(dev, "erroneous completion iptt=%d task=%p "
+				"CQ hdr: 0x%x 0x%x 0x%x 0x%x "
+				"Error info: 0x%x 0x%x 0x%x 0x%x\n",
+				slot->idx, task,
+				complete_hdr->dw0, complete_hdr->dw1,
+				complete_hdr->act, complete_hdr->dw3,
+				error_info[0], error_info[1],
+				error_info[2], error_info[3]);
+
 		if (unlikely(slot->abort))
 			return ts->stat;
 		goto out;
@@ -2461,7 +2473,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 	if (!slot->port->port_attached) {
-		dev_err(dev, "slot complete: port %d has removed\n",
+		dev_warn(dev, "slot complete: port %d has removed\n",
 			slot->port->sas_port.id);
 		ts->stat = SAS_PHY_DOWN;
 	}
@@ -2718,10 +2730,12 @@ static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	u32 phy_state, sl_ctrl, txid_auto;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct hisi_sas_port *port = phy->port;
+	struct device *dev = hisi_hba->dev;
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
 
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
+	dev_info(dev, "phydown: phy%d phy_state=0x%x\n", phy_no, phy_state);
 	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0);
 
 	sl_ctrl = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
@@ -2911,7 +2925,7 @@ static void multi_bit_ecc_error_process_v2_hw(struct hisi_hba *hisi_hba,
 			val = hisi_sas_read32(hisi_hba, ecc_error->reg);
 			val &= ecc_error->msk;
 			val >>= ecc_error->shift;
-			dev_warn(dev, ecc_error->msg, irq_value, val);
+			dev_err(dev, ecc_error->msg, irq_value, val);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
 	}
@@ -3020,12 +3034,12 @@ static irqreturn_t fatal_axi_int_v2_hw(int irq_no, void *p)
 			for (; sub->msk || sub->msg; sub++) {
 				if (!(err_value & sub->msk))
 					continue;
-				dev_warn(dev, "%s (0x%x) found!\n",
+				dev_err(dev, "%s (0x%x) found!\n",
 					 sub->msg, irq_value);
 				queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 			}
 		} else {
-			dev_warn(dev, "%s (0x%x) found!\n",
+			dev_err(dev, "%s (0x%x) found!\n",
 				 axi_error->msg, irq_value);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
@@ -3397,7 +3411,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 
 		udelay(10);
 		if (cnt++ > 10) {
-			dev_info(dev, "wait axi bus state to idle timeout!\n");
+			dev_err(dev, "wait axi bus state to idle timeout!\n");
 			return -1;
 		}
 	}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d356e12..67020bd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1149,7 +1149,7 @@ static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 		struct dev_to_host_fis *fis;
 		u8 attached_sas_addr[SAS_ADDR_SIZE] = {0};
 
-		dev_info(dev, "phyup: phy%d link_rate=%d\n", phy_no, link_rate);
+		dev_info(dev, "phyup: phy%d link_rate=%d(sata)\n", phy_no, link_rate);
 		initial_fis = &hisi_hba->initial_fis[phy_no];
 		fis = &initial_fis->fis;
 		sas_phy->oob_mode = SATA_OOB_MODE;
@@ -1333,7 +1333,7 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 				if (!(irq_value1 & error->irq_msk))
 					continue;
 
-				dev_warn(dev, "%s error (phy%d 0x%x) found!\n",
+				dev_err(dev, "%s error (phy%d 0x%x) found!\n",
 					error->msg, phy_no, irq_value1);
 				queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 			}
@@ -1443,12 +1443,12 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 				if (!(err_value & sub->msk))
 					continue;
 
-				dev_warn(dev, "%s error (0x%x) found!\n",
+				dev_err(dev, "%s error (0x%x) found!\n",
 					sub->msg, irq_value);
 				queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 			}
 		} else {
-			dev_warn(dev, "%s error (0x%x) found!\n",
+			dev_err(dev, "%s error (0x%x) found!\n",
 				error->msg, irq_value);
 			queue_work(hisi_hba->wq, &hisi_hba->rst_work);
 		}
@@ -1553,6 +1553,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
 	if (unlikely(aborted)) {
+		dev_dbg(dev, "slot complete: task(%p) aborted\n", task);
 		ts->stat = SAS_ABORTED_TASK;
 		spin_lock_irqsave(&hisi_hba->lock, flags);
 		hisi_sas_slot_task_free(hisi_hba, task, slot);
@@ -1594,7 +1595,18 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 
 	/* check for erroneous completion */
 	if ((complete_hdr->dw0 & CMPLT_HDR_CMPLT_MSK) == 0x3) {
+		u32 *error_info = hisi_sas_status_buf_addr_mem(slot);
+
 		slot_err_v3_hw(hisi_hba, task, slot);
+		if (ts->stat != SAS_DATA_UNDERRUN)
+			dev_info(dev, "erroneous completion iptt=%d task=%p "
+				"CQ hdr: 0x%x 0x%x 0x%x 0x%x "
+				"Error info: 0x%x 0x%x 0x%x 0x%x\n",
+				slot->idx, task,
+				complete_hdr->dw0, complete_hdr->dw1,
+				complete_hdr->act, complete_hdr->dw3,
+				error_info[0], error_info[1],
+				error_info[2], error_info[3]);
 		if (unlikely(slot->abort))
 			return ts->stat;
 		goto out;
@@ -1639,7 +1651,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	}
 
 	if (!slot->port->port_attached) {
-		dev_err(dev, "slot complete: port %d has removed\n",
+		dev_warn(dev, "slot complete: port %d has removed\n",
 			slot->port->sas_port.id);
 		ts->stat = SAS_PHY_DOWN;
 	}
-- 
1.9.1
