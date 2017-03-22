From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/23] scsi: hisi_sas: add controller reset
Date: Thu, 23 Mar 2017 01:25:18 +0800
Message-ID: <1490203539-228029-3-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4367 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1760826AbdCVQ6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:58:25 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiang Chen <chenxiang66@hisilicon.com>

There are some scenarios that we need to warm-rest to
reset registers of SAS controller. During reset we disable
interrupts/DQs/PHYs, and after reset we re-init the hardware
and rescan the topology to see if anything changed.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   7 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 134 +++++++++++++++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  94 +++++++++++++++++++++++
 3 files changed, 227 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a018a8a..fd76a02 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -31,6 +31,7 @@
 #define HISI_SAS_QUEUE_SLOTS 512
 #define HISI_SAS_MAX_ITCT_ENTRIES 2048
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
+#define HISI_SAS_RESET_BIT	0
 
 #define HISI_SAS_STATUS_BUF_SZ \
 		(sizeof(struct hisi_sas_err_record) + 1024)
@@ -175,6 +176,7 @@ struct hisi_sas_hw {
 	void (*free_device)(struct hisi_hba *hisi_hba,
 			    struct hisi_sas_device *dev);
 	int (*get_wideport_bitmap)(struct hisi_hba *hisi_hba, int port_id);
+	int (*soft_reset)(struct hisi_hba *hisi_hba);
 	int max_command_entries;
 	int complete_hdr_size;
 };
@@ -233,7 +235,9 @@ struct hisi_hba {
 	struct hisi_sas_breakpoint *sata_breakpoint;
 	dma_addr_t sata_breakpoint_dma;
 	struct hisi_sas_slot	*slot_info;
+	unsigned long flags;
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
+	struct work_struct rst_work;
 };
 
 /* Generic HW DMA host memory structures */
@@ -356,4 +360,7 @@ extern int hisi_sas_probe(struct platform_device *pdev,
 extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct sas_task *task,
 				    struct hisi_sas_slot *slot);
+extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
+extern void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
+				     u32 state);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 11f32d2..cbaef90 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -351,6 +351,9 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
 	struct device *dev = &hisi_hba->pdev->dev;
 
+	if (unlikely(test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)))
+		return -EINVAL;
+
 	/* protect task_prep and start_delivery sequence */
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	rc = hisi_sas_task_prep(task, hisi_hba, is_tmf, tmf, &pass);
@@ -613,6 +616,20 @@ static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
 		hisi_sas_do_release_task(hisi_hba, sas_phy->id, device);
 }
 
+static void hisi_sas_release_tasks(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < HISI_SAS_MAX_PHYS; i++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[i];
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+		if (!sas_phy->port)
+			continue;
+		hisi_sas_port_notify_deformed(sas_phy);
+	}
+}
+
 static void hisi_sas_dev_gone(struct domain_device *device)
 {
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
@@ -803,6 +820,40 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 				sizeof(ssp_task), tmf);
 }
 
+static int hisi_sas_controller_reset(struct hisi_hba *hisi_hba)
+{
+	int rc;
+
+	if (!hisi_hba->hw->soft_reset)
+		return -1;
+
+	if (!test_and_set_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
+		struct device *dev = &hisi_hba->pdev->dev;
+		struct sas_ha_struct *sas_ha = &hisi_hba->sha;
+		unsigned long flags;
+
+		dev_dbg(dev, "controller reset begins!\n");
+		scsi_block_requests(hisi_hba->shost);
+		rc = hisi_hba->hw->soft_reset(hisi_hba);
+		if (rc) {
+			dev_warn(dev, "controller reset failed (%d)\n", rc);
+			goto out;
+		}
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+		hisi_sas_release_tasks(hisi_hba);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+		sas_ha->notify_ha_event(sas_ha, HAE_RESET);
+		dev_dbg(dev, "controller reset successful!\n");
+	} else
+		return -1;
+
+out:
+	scsi_unblock_requests(hisi_hba->shost);
+	clear_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags);
+	return rc;
+}
+
 static int hisi_sas_abort_task(struct sas_task *task)
 {
 	struct scsi_lun lun;
@@ -1002,6 +1053,9 @@ static int hisi_sas_query_task(struct sas_task *task)
 	struct hisi_sas_cmd_hdr *cmd_hdr_base;
 	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
 
+	if (unlikely(test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)))
+		return -EINVAL;
+
 	if (!device->port)
 		return -1;
 
@@ -1190,6 +1244,37 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_phy_down);
 
+void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
+			      u32 state)
+{
+	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
+	int phy_no;
+
+	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+		struct asd_sas_port *sas_port = sas_phy->port;
+		struct domain_device *dev;
+
+		if (sas_phy->enabled) {
+			/* Report PHY state change to libsas */
+			if (state & (1 << phy_no))
+				continue;
+
+			if (old_state & (1 << phy_no))
+				/* PHY down but was up before */
+				hisi_sas_phy_down(hisi_hba, phy_no, 0);
+		}
+		if (!sas_port)
+			continue;
+		dev = sas_port->port_dev;
+
+		if (DEV_IS_EXPANDER(dev->dev_type))
+			sas_ha->notify_phy_event(sas_phy, PORTE_BROADCAST_RCVD);
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_rescan_topology);
+
 static struct scsi_transport_template *hisi_sas_stt;
 
 static struct scsi_host_template hisi_sas_sht = {
@@ -1228,6 +1313,37 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 	.lldd_port_deformed	= hisi_sas_port_deformed,
 };
 
+void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
+{
+	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+		struct hisi_sas_dq *dq = &hisi_hba->dq[i];
+
+		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
+		memset(hisi_hba->cmd_hdr[i], 0, s);
+		dq->wr_point = 0;
+
+		s = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
+		memset(hisi_hba->complete_hdr[i], 0, s);
+		cq->rd_point = 0;
+	}
+
+	s = sizeof(struct hisi_sas_initial_fis) * hisi_hba->n_phy;
+	memset(hisi_hba->initial_fis, 0, s);
+
+	s = max_command_entries * sizeof(struct hisi_sas_iost);
+	memset(hisi_hba->iost, 0, s);
+
+	s = max_command_entries * sizeof(struct hisi_sas_breakpoint);
+	memset(hisi_hba->breakpoint, 0, s);
+
+	s = max_command_entries * sizeof(struct hisi_sas_breakpoint) * 2;
+	memset(hisi_hba->sata_breakpoint, 0, s);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_init_mem);
+
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 {
 	struct platform_device *pdev = hisi_hba->pdev;
@@ -1266,7 +1382,6 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 					&hisi_hba->cmd_hdr_dma[i], GFP_KERNEL);
 		if (!hisi_hba->cmd_hdr[i])
 			goto err_out;
-		memset(hisi_hba->cmd_hdr[i], 0, s);
 
 		/* Completion queue */
 		s = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
@@ -1274,7 +1389,6 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 				&hisi_hba->complete_hdr_dma[i], GFP_KERNEL);
 		if (!hisi_hba->complete_hdr[i])
 			goto err_out;
-		memset(hisi_hba->complete_hdr[i], 0, s);
 	}
 
 	s = HISI_SAS_STATUS_BUF_SZ;
@@ -1309,16 +1423,12 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	if (!hisi_hba->iost)
 		goto err_out;
 
-	memset(hisi_hba->iost, 0, s);
-
 	s = max_command_entries * sizeof(struct hisi_sas_breakpoint);
 	hisi_hba->breakpoint = dma_alloc_coherent(dev, s,
 				&hisi_hba->breakpoint_dma, GFP_KERNEL);
 	if (!hisi_hba->breakpoint)
 		goto err_out;
 
-	memset(hisi_hba->breakpoint, 0, s);
-
 	hisi_hba->slot_index_count = max_command_entries;
 	s = hisi_hba->slot_index_count / BITS_PER_BYTE;
 	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
@@ -1335,14 +1445,13 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 				&hisi_hba->initial_fis_dma, GFP_KERNEL);
 	if (!hisi_hba->initial_fis)
 		goto err_out;
-	memset(hisi_hba->initial_fis, 0, s);
 
 	s = max_command_entries * sizeof(struct hisi_sas_breakpoint) * 2;
 	hisi_hba->sata_breakpoint = dma_alloc_coherent(dev, s,
 				&hisi_hba->sata_breakpoint_dma, GFP_KERNEL);
 	if (!hisi_hba->sata_breakpoint)
 		goto err_out;
-	memset(hisi_hba->sata_breakpoint, 0, s);
+	hisi_sas_init_mem(hisi_hba);
 
 	hisi_sas_slot_index_init(hisi_hba);
 
@@ -1413,6 +1522,14 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 		destroy_workqueue(hisi_hba->wq);
 }
 
+static void hisi_sas_rst_work_handler(struct work_struct *work)
+{
+	struct hisi_hba *hisi_hba =
+		container_of(work, struct hisi_hba, rst_work);
+
+	hisi_sas_controller_reset(hisi_hba);
+}
+
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 					      const struct hisi_sas_hw *hw)
 {
@@ -1430,6 +1547,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	}
 	hisi_hba = shost_priv(shost);
 
+	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
 	hisi_hba->hw = hw;
 	hisi_hba->pdev = pdev;
 	hisi_hba->shost = shost;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 1590e2f..53651cf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -257,6 +257,10 @@
 #define AM_CFG_MAX_TRANS		(0x5010)
 #define AM_CFG_SINGLE_PORT_MAX_TRANS	(0x5014)
 
+#define AXI_MASTER_CFG_BASE		(0x5000)
+#define AM_CTRL_GLOBAL			(0x0)
+#define AM_CURR_TRANS_RETURN	(0x150)
+
 /* HW dma structures */
 /* Delivery queue header */
 /* dw0 */
@@ -1079,6 +1083,14 @@ static void stop_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	disable_phy_v2_hw(hisi_hba, phy_no);
 }
 
+static void stop_phys_v2_hw(struct hisi_hba *hisi_hba)
+{
+	int i;
+
+	for (i = 0; i < hisi_hba->n_phy; i++)
+		stop_phy_v2_hw(hisi_hba, i);
+}
+
 static void phy_hard_reset_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
@@ -2857,6 +2869,87 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
+static void interrupt_disable_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct platform_device *pdev = hisi_hba->pdev;
+	int i;
+
+	for (i = 0; i < hisi_hba->queue_count; i++)
+		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK + 0x4 * i, 0x1);
+
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0xffffffff);
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, 0xffffffff);
+	hisi_sas_write32(hisi_hba, SAS_ECC_INTR_MSK, 0xffffffff);
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT1_MSK, 0xffffffff);
+		hisi_sas_phy_write32(hisi_hba, i, CHL_INT2_MSK, 0xffffffff);
+	}
+
+	for (i = 0; i < 128; i++)
+		synchronize_irq(platform_get_irq(pdev, i));
+}
+
+static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 old_state, state;
+	int rc, cnt;
+	int phy_no;
+
+	old_state = hisi_sas_read32(hisi_hba, PHY_STATE);
+
+	interrupt_disable_v2_hw(hisi_hba);
+	hisi_sas_write32(hisi_hba, DLVRY_QUEUE_ENABLE, 0x0);
+
+	stop_phys_v2_hw(hisi_hba);
+
+	mdelay(10);
+
+	hisi_sas_write32(hisi_hba, AXI_MASTER_CFG_BASE + AM_CTRL_GLOBAL, 0x1);
+
+	/* wait until bus idle */
+	cnt = 0;
+	while (1) {
+		u32 status = hisi_sas_read32_relaxed(hisi_hba,
+				AXI_MASTER_CFG_BASE + AM_CURR_TRANS_RETURN);
+
+		if (status == 0x3)
+			break;
+
+		udelay(10);
+		if (cnt++ > 10) {
+			dev_info(dev, "wait axi bus state to idle timeout!\n");
+			return -1;
+		}
+	}
+
+	hisi_sas_init_mem(hisi_hba);
+
+	rc = hw_init_v2_hw(hisi_hba);
+	if (rc)
+		return rc;
+
+	/* Re-enable the PHYs */
+	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
+		struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+		if (sas_phy->enabled)
+			start_phy_v2_hw(hisi_hba, phy_no);
+	}
+
+	/* Wait for the PHYs to come up and read the PHY state */
+	msleep(1000);
+
+	state = hisi_sas_read32(hisi_hba, PHY_STATE);
+
+	hisi_sas_rescan_topology(hisi_hba, old_state, state);
+
+	return 0;
+}
+
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.setup_itct = setup_itct_v2_hw,
@@ -2879,6 +2972,7 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 	.phy_get_max_linkrate = phy_get_max_linkrate_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
+	.soft_reset = soft_reset_v2_hw,
 };
 
 static int hisi_sas_v2_probe(struct platform_device *pdev)
-- 
1.9.1
