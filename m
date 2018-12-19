From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/8] scsi: hisi_sas: Alloc debugfs snapshot buffer memory for all registers
Date: Wed, 19 Dec 2018 23:56:40 +0800
Message-ID: <1545235006-151716-3-git-send-email-john.garry@huawei.com>
References: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545235006-151716-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

This patch allocates snapshot memory for global reg, port regs, CQ, DQ,
IOST, ITCT.

When we fail to allocate memory for some registers, we free the memory
and set hisi_sas_debugfs_enable as 0 to stop loading debugfs from running.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 15 +++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 76 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  8 ++++
 3 files changed, 99 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3ad8746..eca7e47 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -221,6 +221,10 @@ struct hisi_sas_slot {
 	u16	idx;
 };
 
+struct hisi_sas_debugfs_reg {
+	int count;
+};
+
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
@@ -265,6 +269,9 @@ struct hisi_sas_hw {
 	int max_command_entries;
 	int complete_hdr_size;
 	struct scsi_host_template *sht;
+
+	const struct hisi_sas_debugfs_reg *debugfs_reg_global;
+	const struct hisi_sas_debugfs_reg *debugfs_reg_port;
 };
 
 struct hisi_hba {
@@ -334,6 +341,14 @@ struct hisi_hba {
 	u32 intr_coal_ticks;	/* Time of interrupt coalesce in us */
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
 
+	/* debugfs memories */
+	void *debugfs_global_reg;
+	void *debugfs_port_reg[HISI_SAS_MAX_PHYS];
+	void *debugfs_complete_hdr[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_cmd_hdr	*debugfs_cmd_hdr[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_iost *debugfs_iost;
+	struct hisi_sas_itct *debugfs_itct;
+
 	struct dentry *debugfs_dir;
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 919cd3b..0b0dbaab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2461,10 +2461,86 @@ int hisi_sas_probe(struct platform_device *pdev,
 
 void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 {
+	int max_command_entries = hisi_hba->hw->max_command_entries;
 	struct device *dev = hisi_hba->dev;
+	int p, i, c, d;
+	size_t sz;
 
 	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
 						   hisi_sas_debugfs_dir);
+
+	if (!hisi_hba->debugfs_dir)
+		return;
+
+	/* Alloc buffer for global */
+	sz = hisi_hba->hw->debugfs_reg_global->count * 4;
+	hisi_hba->debugfs_global_reg =
+		devm_kmalloc(dev, sz, GFP_KERNEL);
+
+	if (!hisi_hba->debugfs_global_reg)
+		goto fail_global;
+
+	/* Alloc buffer for port */
+	sz = hisi_hba->hw->debugfs_reg_port->count * 4;
+	for (p = 0; p < hisi_hba->n_phy; p++) {
+		hisi_hba->debugfs_port_reg[p] =
+			devm_kmalloc(dev, sz, GFP_KERNEL);
+
+		if (!hisi_hba->debugfs_port_reg[p])
+			goto fail_port;
+	}
+
+	/* Alloc buffer for cq */
+	sz = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
+	for (c = 0; c < hisi_hba->queue_count; c++) {
+		hisi_hba->debugfs_complete_hdr[c] =
+			devm_kmalloc(dev, sz, GFP_KERNEL);
+
+		if (!hisi_hba->debugfs_complete_hdr[c])
+			goto fail_cq;
+	}
+
+	/* Alloc buffer for dq */
+	sz = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
+	for (d = 0; d < hisi_hba->queue_count; d++) {
+		hisi_hba->debugfs_cmd_hdr[d] =
+			devm_kmalloc(dev, sz, GFP_KERNEL);
+
+		if (!hisi_hba->debugfs_cmd_hdr[d])
+			goto fail_iost_dq;
+	}
+
+	/* Alloc buffer for iost */
+	sz = max_command_entries * sizeof(struct hisi_sas_iost);
+
+	hisi_hba->debugfs_iost = devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_iost)
+		goto fail_iost_dq;
+
+	/* Alloc buffer for itct */
+	/* New memory allocation must be locate before itct */
+	sz = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
+
+	hisi_hba->debugfs_itct = devm_kmalloc(dev, sz, GFP_KERNEL);
+	if (!hisi_hba->debugfs_itct)
+		goto fail_itct;
+
+	return;
+fail_itct:
+	devm_kfree(dev, hisi_hba->debugfs_iost);
+fail_iost_dq:
+	for (i = 0; i < d; i++)
+		devm_kfree(dev, hisi_hba->debugfs_cmd_hdr[i]);
+fail_cq:
+	for (i = 0; i < c; i++)
+		devm_kfree(dev, hisi_hba->debugfs_complete_hdr[i]);
+fail_port:
+	for (i = 0; i < p; i++)
+		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
+	devm_kfree(dev, hisi_hba->debugfs_global_reg);
+fail_global:
+	debugfs_remove_recursive(hisi_hba->debugfs_dir);
+	dev_dbg(dev, "failed to init debugfs!\n");
 }
 EXPORT_SYMBOL_GPL(hisi_sas_debugfs_init);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d2e1c85..6efa61e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2334,6 +2334,12 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	NULL
 };
 
+static const struct hisi_sas_debugfs_reg debugfs_port_reg = {
+};
+
+static const struct hisi_sas_debugfs_reg debugfs_global_reg = {
+};
+
 static struct scsi_host_template sht_v3_hw = {
 	.name			= DRV_NAME,
 	.module			= THIS_MODULE,
@@ -2382,6 +2388,8 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	.get_events = phy_get_events_v3_hw,
 	.write_gpio = write_gpio_v3_hw,
 	.wait_cmds_complete_timeout = wait_cmds_complete_timeout_v3_hw,
+	.debugfs_reg_global = &debugfs_global_reg,
+	.debugfs_reg_port = &debugfs_port_reg,
 };
 
 static struct Scsi_Host *
-- 
1.9.1
