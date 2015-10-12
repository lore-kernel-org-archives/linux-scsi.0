From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/25] scsi: hisi_sas: allocate memories and create pools
Date: Mon, 12 Oct 2015 23:20:17 +0800
Message-ID: <1444663237-238302-6-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

The device tree must be examined for relevant fields.

Also set controller id.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 204 ++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_init.c | 191 ++++++++++++++++++++++++++++++-
 2 files changed, 394 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1a90b54..2c15036 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -22,10 +22,18 @@
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
+#define HISI_SAS_NAME_LEN 32
 
 struct hisi_sas_phy {
 	struct hisi_sas_port	*port;
@@ -36,6 +44,26 @@ struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
 };
 
+
+struct hisi_sas_slot {
+	struct list_head entry;
+	struct sas_task *task;
+	struct hisi_sas_port	*port;
+	u64	n_elem;
+	int	dlvry_queue;
+	int	dlvry_queue_slot;
+	int	cmplt_queue;
+	int	cmplt_queue_slot;
+	int	idx;
+	void	*cmd_hdr;
+	dma_addr_t cmd_hdr_dma;
+	void	*status_buffer;
+	dma_addr_t status_buffer_dma;
+	void *command_table;
+	dma_addr_t command_table_dma;
+	struct hisi_sas_sge_page *sge_page;
+	dma_addr_t sge_page_dma;
+};
 struct hisi_hba {
 	spinlock_t	lock;
 
@@ -44,13 +72,189 @@ struct hisi_hba {
 
 	u8 sas_addr[SAS_ADDR_SIZE];
 
+	struct hisi_sas_cmd_hdr	*cmd_hdr[HISI_SAS_MAX_QUEUES];
+	dma_addr_t	cmd_hdr_dma[HISI_SAS_MAX_QUEUES];
+	struct hisi_sas_complete_hdr	*complete_hdr[HISI_SAS_MAX_QUEUES];
+	dma_addr_t	complete_hdr_dma[HISI_SAS_MAX_QUEUES];
+
+	struct hisi_sas_initial_fis *initial_fis;
+	dma_addr_t	initial_fis_dma;
+
 	int	n_phy;
+
+	int slot_index_count;
+	unsigned long *slot_index_tags;
+
+	struct dma_pool *sge_page_pool;
+
 	/* SCSI/SAS glue */
 	struct sas_ha_struct sha;
 	struct Scsi_Host *shost;
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
+	int	id;
+	int	queue_count;
+	char	*int_names;
+	struct dma_pool *command_table_pool;
+	struct dma_pool *status_buffer_pool;
+	struct hisi_sas_itct *itct;
+	dma_addr_t itct_dma;
+	struct hisi_sas_iost *iost;
+	dma_addr_t iost_dma;
+	struct hisi_sas_breakpoint *breakpoint;
+	dma_addr_t breakpoint_dma;
+	struct hisi_sas_breakpoint *sata_breakpoint;
+	dma_addr_t sata_breakpoint_dma;
+	struct hisi_sas_slot	*slot_info;
+};
+
+/* Generic HW DMA host memory structures */
+/* Delivery queue header */
+struct hisi_sas_cmd_hdr {
+	/* dw0 */
+	__le32 dw0;
+
+	/* dw1 */
+	__le32 dw1;
+
+	/* dw2 */
+	__le32 dw2;
+
+	/* dw3 */
+	__le32 transfer_tags;
+
+	/* dw4 */
+	__le32 data_transfer_len;
+
+	/* dw5 */
+	__le32 first_burst_num;
+
+	/* dw6 */
+	__le32 sg_len;
+
+	/* dw7 */
+	__le32 dw7;
+
+	/* dw8 */
+	__le32 cmd_table_addr_lo;
+
+	/* dw9 */
+	__le32 cmd_table_addr_hi;
+
+	/* dw10 */
+	__le32 sts_buffer_addr_lo;
+
+	/* dw11 */
+	__le32 sts_buffer_addr_hi;
+
+	/* dw12 */
+	__le32 prd_table_addr_lo;
+
+	/* dw13 */
+	__le32 prd_table_addr_hi;
+
+	/* dw14 */
+	__le32 dif_prd_table_addr_lo;
+
+	/* dw15 */
+	__le32 dif_prd_table_addr_hi;
+};
+
+/* Completion queue header */
+struct hisi_sas_complete_hdr {
+	__le32 data;
+};
+
+struct hisi_sas_itct {
+	__le64 qw0;
+	__le64 sas_addr;
+	__le64 qw2;
+	__le64 qw3;
+	__le64 qw4;
+	__le64 qw_sata_ncq0_3;
+	__le64 qw_sata_ncq7_4;
+	__le64 qw_sata_ncq11_8;
+	__le64 qw_sata_ncq15_12;
+	__le64 qw_sata_ncq19_16;
+	__le64 qw_sata_ncq23_20;
+	__le64 qw_sata_ncq27_24;
+	__le64 qw_sata_ncq31_28;
+	__le64 qw_non_ncq_iptt;
+	__le64 qw_rsvd0;
+	__le64 qw_rsvd1;
+};
+
+struct hisi_sas_iost {
+	__le64 qw0;
+	__le64 qw1;
+	__le64 qw2;
+	__le64 qw3;
+};
+
+struct hisi_sas_err_record {
+	/* dw0 */
+	__le32 dma_err_type;
+
+	/* dw1 */
+	__le32 trans_tx_fail_type;
+
+	/* dw2 */
+	__le32 trans_rx_fail_type;
+
+	/* dw3 */
+	u32 rsvd;
+};
+
+struct hisi_sas_initial_fis {
+	struct hisi_sas_err_record err_record;
+	struct dev_to_host_fis fis;
+	u32 rsvd[3];
+};
+
+struct hisi_sas_breakpoint {
+	u8	data[128];	/*io128 byte*/
+};
+
+struct hisi_sas_sge {
+	__le32 addr_lo;
+	__le32 addr_hi;
+	__le32 page_ctrl_0;
+	__le32 page_ctrl_1;
+	__le32 data_len;
+	__le32 data_off;
+};
+
+struct hisi_sas_command_table_smp {
+	u8 bytes[44];
+};
+
+struct hisi_sas_command_table_stp {
+	struct	host_to_dev_fis command_fis;
+	u8	dummy[12];
+	u8	atapi_cdb[ATAPI_CDB_LEN];
 };
 
 #define HISI_SAS_SGE_PAGE_CNT SCSI_MAX_SG_SEGMENTS
+struct hisi_sas_sge_page {
+	struct hisi_sas_sge sge[HISI_SAS_SGE_PAGE_CNT];
+};
+
+struct hisi_sas_command_table_ssp {
+	struct ssp_frame_hdr hdr;
+	union {
+		struct {
+			struct ssp_command_iu task;
+			u32 prot[6];
+		};
+		struct ssp_tmf_iu ssp_task;
+		struct xfer_rdy_iu xfer_rdy;
+		struct ssp_response_iu ssp_res;
+	} u;
+};
+
+union hisi_sas_command_table {
+	struct hisi_sas_command_table_ssp ssp;
+	struct hisi_sas_command_table_smp smp;
+	struct hisi_sas_command_table_stp stp;
+};
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 2cae458..0116782 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -35,6 +35,164 @@ static struct scsi_host_template hisi_sas_sht = {
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 };
 
+static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
+{
+	int i, s;
+	char name[32];
+	struct device *dev = &hisi_hba->pdev->dev;
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
+		s = sizeof(struct hisi_sas_complete_hdr) * HISI_SAS_QUEUE_SLOTS;
+		hisi_hba->complete_hdr[i] = dma_alloc_coherent(dev, s,
+				&hisi_hba->complete_hdr_dma[i], GFP_KERNEL);
+		if (!hisi_hba->complete_hdr[i])
+			goto err_out;
+		memset(hisi_hba->complete_hdr[i], 0, s);
+	}
+
+	sprintf(name, "%s%d", "hisi_sas_status_buffer_pool",
+		hisi_hba->id);
+	s = HISI_SAS_STATUS_BUF_SZ;
+	hisi_hba->status_buffer_pool = dma_pool_create(name,
+						       dev, s, 16, 0);
+	if (!hisi_hba->status_buffer_pool)
+		goto err_out;
+
+	sprintf(name, "%s%d", "hisi_sas_command_table_pool",
+		hisi_hba->id);
+	s = HISI_SAS_COMMAND_TABLE_SZ;
+	hisi_hba->command_table_pool = dma_pool_create(name,
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
+	hisi_hba->slot_index_count = HISI_SAS_COMMAND_ENTRIES;
+	s = hisi_hba->slot_index_count / sizeof(unsigned long);
+	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
+	if (!hisi_hba->slot_index_tags)
+		goto err_out;
+
+	sprintf(name, "%s%d", "hisi_sas_status_sge_pool", hisi_hba->id);
+	hisi_hba->sge_page_pool = dma_pool_create(name, dev,
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
+static void hisi_sas_free(struct hisi_hba *hisi_hba)
+{
+	int i, s;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		s = sizeof(struct hisi_sas_cmd_hdr) * HISI_SAS_QUEUE_SLOTS;
+		if (hisi_hba->cmd_hdr[i])
+			dma_free_coherent(dev, s,
+					  hisi_hba->cmd_hdr[i],
+					  hisi_hba->cmd_hdr_dma[i]);
+
+		s = sizeof(struct hisi_sas_complete_hdr) * HISI_SAS_QUEUE_SLOTS;
+		if (hisi_hba->complete_hdr[i])
+			dma_free_coherent(dev, s,
+					  hisi_hba->complete_hdr[i],
+					  hisi_hba->complete_hdr_dma[i]);
+	}
+
+	if (hisi_hba->status_buffer_pool)
+		dma_pool_destroy(hisi_hba->status_buffer_pool);
+
+	if (hisi_hba->command_table_pool)
+		dma_pool_destroy(hisi_hba->command_table_pool);
+
+	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
+	if (hisi_hba->itct)
+		dma_free_coherent(dev, s,
+				  hisi_hba->itct, hisi_hba->itct_dma);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_iost);
+	if (hisi_hba->iost)
+		dma_free_coherent(dev, s,
+				  hisi_hba->iost, hisi_hba->iost_dma);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint);
+	if (hisi_hba->breakpoint)
+		dma_free_coherent(dev, s,
+				  hisi_hba->breakpoint,
+				  hisi_hba->breakpoint_dma);
+
+	if (hisi_hba->sge_page_pool)
+		dma_pool_destroy(hisi_hba->sge_page_pool);
+
+	s = sizeof(struct hisi_sas_initial_fis) * HISI_SAS_MAX_PHYS;
+	if (hisi_hba->initial_fis)
+		dma_free_coherent(dev, s,
+				  hisi_hba->initial_fis,
+				  hisi_hba->initial_fis_dma);
+
+	s = HISI_SAS_COMMAND_ENTRIES * sizeof(struct hisi_sas_breakpoint) * 2;
+	if (hisi_hba->sata_breakpoint)
+		dma_free_coherent(dev, s,
+				  hisi_hba->sata_breakpoint,
+				  hisi_hba->sata_breakpoint_dma);
+}
+
 
 static const struct of_device_id sas_of_match[] = {
 	{ .compatible = "hisilicon,sas-controller-v1",},
@@ -55,8 +213,37 @@ static struct hisi_hba *hisi_sas_hba_alloc(
 		goto err_out;
 
 	hisi_hba->pdev = pdev;
+
+	if (of_property_read_u32(np, "phy-count", &hisi_hba->n_phy))
+		goto err_out;
+
+	if (of_property_read_u32(np, "queue-count", &hisi_hba->queue_count))
+		goto err_out;
+
+	if (of_property_read_u32(np, "controller-id", &hisi_hba->id))
+		goto err_out;
+
+	interrupt_count = of_property_count_u32_elems(np, "interrupts");
+	if (interrupt_count < 0)
+		goto err_out;
+
+	if (of_property_read_u32(np, "#interrupt-cells", &interrupt_cells))
+		goto err_out;
+
+	hisi_hba->int_names = devm_kcalloc(&pdev->dev,
+					   interrupt_count / interrupt_cells,
+					   HISI_SAS_NAME_LEN,
+					   GFP_KERNEL);
+	if (!hisi_hba->int_names)
+		goto err_out;
+
 	hisi_hba->shost = shost;
 
+	if (hisi_sas_alloc(hisi_hba, shost)) {
+		hisi_sas_free(hisi_hba);
+		goto err_out;
+	}
+
 	return hisi_hba;
 err_out:
 	dev_err(&pdev->dev, "hba alloc failed\n");
@@ -87,7 +274,7 @@ static int hisi_sas_probe(struct platform_device *pdev)
 	sha = SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
 	platform_set_drvdata(pdev, sha);
 
-	phy_nr = port_nr = HISI_SAS_MAX_PHYS;
+	phy_nr = port_nr = hisi_hba->n_phy;
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
 	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
@@ -139,11 +326,13 @@ err_out_ha:
 static int hisi_sas_remove(struct platform_device *pdev)
 {
 	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
+	struct hisi_hba *hisi_hba = (struct hisi_hba *)sha->lldd_ha;
 
 	sas_unregister_ha(sha);
 	sas_remove_host(sha->core.shost);
 	scsi_remove_host(sha->core.shost);
 
+	hisi_sas_free(hisi_hba);
 	return 0;
 }
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
