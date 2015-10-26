From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 07/32] scsi: hisi_sas: allocate memories and create pools
Date: Mon, 26 Oct 2015 22:14:38 +0800
Message-ID: <1445868903-183817-8-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Allocate DMA and non-DMA memories for the controller. Also
create DMA pools.

These include:
- Delivery queues
- Completion queues
- Command status buffer
- Command table
- ITCT (For device context)
- Host slot info
- IO status
- Breakpoint
- host slot indexing
- SG data
- FIS
- interrupts names
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 31 ++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 95 +++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d93e55a..c320c10 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -24,10 +24,17 @@
 #define DRV_VERSION "v1.0"
 
 #define HISI_SAS_MAX_PHYS	9
+#define HISI_SAS_MAX_QUEUES	32
+#define HISI_SAS_QUEUE_SLOTS 512
 #define HISI_SAS_MAX_ITCT_ENTRIES 4096
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
 #define HISI_SAS_COMMAND_ENTRIES 8192
 
+#define HISI_SAS_STATUS_BUF_SZ \
+		(sizeof(struct hisi_sas_err_record) + 1024)
+#define HISI_SAS_COMMAND_TABLE_SZ \
+		(((sizeof(union hisi_sas_command_table)+3)/4)*4)
+
 #define HISI_SAS_NAME_LEN 32
 #define HISI_SAS_CTRL_REG_CNT 5
 
@@ -39,7 +46,11 @@ struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
 };
 
+struct hisi_sas_slot {
+};
+
 struct hisi_sas_hw {
+	int complete_hdr_size;
 };
 
 struct hisi_hba {
@@ -52,6 +63,7 @@ struct hisi_hba {
 	u32 ctrl_reg[HISI_SAS_CTRL_REG_CNT];
 	u8 sas_addr[SAS_ADDR_SIZE];
 
+
 	int n_phy;
 
 	/* SCSI/SAS glue */
@@ -62,6 +74,25 @@ struct hisi_hba {
 
 	int	queue_count;
 	char	*int_names;
+
+	struct dma_pool *sge_page_pool;
+	struct dma_pool *command_table_pool;
+	struct dma_pool *status_buffer_pool;
+	struct hisi_sas_cmd_hdr	*cmd_hdr[HISI_SAS_MAX_QUEUES];
+	dma_addr_t cmd_hdr_dma[HISI_SAS_MAX_QUEUES];
+	void *complete_hdr[HISI_SAS_MAX_QUEUES];
+	dma_addr_t complete_hdr_dma[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_initial_fis *initial_fis;
+	dma_addr_t initial_fis_dma;
+	struct hisi_sas_itct *itct;
+	dma_addr_t itct_dma;
+	struct hisi_sas_iost *iost;
+	dma_addr_t iost_dma;
+	struct hisi_sas_breakpoint *breakpoint;
+	dma_addr_t breakpoint_dma;
+	struct hisi_sas_breakpoint *sata_breakpoint;
+	dma_addr_t sata_breakpoint_dma;
+	struct hisi_sas_slot	*slot_info;
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 91f6504..e03a62b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -37,6 +37,98 @@ static struct scsi_host_template hisi_sas_sht = {
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 };
 
+static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
+{
+	int i, s;
+	struct platform_device *pdev = hisi_hba->pdev;
+	struct device *dev = &pdev->dev;
+
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		/* Delivery queue */
+		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
+		hisi_hba->cmd_hdr[i] = dma_alloc_coherent(dev, s,
+					&hisi_hba->cmd_hdr_dma[i], GFP_KERNEL);
+		if (!hisi_hba->cmd_hdr[i])
+			goto err_out;
+		memset(hisi_hba->cmd_hdr[i], 0, s);
+
+		/* Completion queue */
+		s = hisi_hba->hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
+		hisi_hba->complete_hdr[i] = dma_alloc_coherent(dev, s,
+				&hisi_hba->complete_hdr_dma[i], GFP_KERNEL);
+		if (!hisi_hba->complete_hdr[i])
+			goto err_out;
+		memset(hisi_hba->complete_hdr[i], 0, s);
+	}
+
+	s = HISI_SAS_STATUS_BUF_SZ;
+	hisi_hba->status_buffer_pool = dma_pool_create("status_buffer",
+						       dev, s, 16, 0);
+	if (!hisi_hba->status_buffer_pool)
+		goto err_out;
+
+	s = HISI_SAS_COMMAND_TABLE_SZ;
+	hisi_hba->command_table_pool = dma_pool_create("command_table",
+						       dev, s, 16, 0);
+	if (!hisi_hba->command_table_pool)
+		goto err_out;
+
+	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
+	hisi_hba->itct = dma_alloc_coherent(dev, s, &hisi_hba->itct_dma,
+					    GFP_KERNEL);
+	if (!hisi_hba->itct)
+		goto err_out;
+
+	memset(hisi_hba->itct, 0, s);
+
+	hisi_hba->slot_info = devm_kcalloc(dev, HISI_SAS_COMMAND_ENTRIES,
+					   sizeof(struct hisi_sas_slot),
+					   GFP_KERNEL);
+	if (!hisi_hba->slot_info)
+		goto err_out;
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_iost);
+	hisi_hba->iost = dma_alloc_coherent(dev, s, &hisi_hba->iost_dma,
+					    GFP_KERNEL);
+	if (!hisi_hba->iost)
+		goto err_out;
+
+	memset(hisi_hba->iost, 0, s);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint);
+	hisi_hba->breakpoint = dma_alloc_coherent(dev, s,
+				&hisi_hba->breakpoint_dma, GFP_KERNEL);
+	if (!hisi_hba->breakpoint)
+		goto err_out;
+
+	memset(hisi_hba->breakpoint, 0, s);
+
+	hisi_hba->sge_page_pool = dma_pool_create("status_sge", dev,
+				sizeof(struct hisi_sas_sge_page), 16, 0);
+	if (!hisi_hba->sge_page_pool)
+		goto err_out;
+
+	s = sizeof(struct hisi_sas_initial_fis) * HISI_SAS_MAX_PHYS;
+	hisi_hba->initial_fis = dma_alloc_coherent(dev, s,
+				&hisi_hba->initial_fis_dma, GFP_KERNEL);
+	if (!hisi_hba->initial_fis)
+		goto err_out;
+	memset(hisi_hba->initial_fis, 0, s);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint) * 2;
+	hisi_hba->sata_breakpoint = dma_alloc_coherent(dev, s,
+				&hisi_hba->sata_breakpoint_dma, GFP_KERNEL);
+	if (!hisi_hba->sata_breakpoint)
+		goto err_out;
+	memset(hisi_hba->sata_breakpoint, 0, s);
+
+	return 0;
+err_out:
+	return -ENOMEM;
+}
+
+
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 					      const struct hisi_sas_hw *hw)
 {
@@ -91,6 +183,9 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	if (IS_ERR(hisi_hba->ctrl))
 		goto err_out;
 
+	if (hisi_sas_alloc(hisi_hba, shost))
+		goto err_out;
+
 	return shost;
 err_out:
 	dev_err(dev, "shost alloc failed\n");
-- 
1.9.1
