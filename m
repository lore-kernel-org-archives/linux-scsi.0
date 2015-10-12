From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/25] scsi: hisi_sas: add misc HBA initialization
Date: Mon, 12 Oct 2015 23:20:22 +0800
Message-ID: <1444663237-238302-11-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12577 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbbJLPIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:08:31 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

This includes:
- host port structure initialisation
- host device structure initialisation
- wq initialisation
- host structure timer init
- DMA mask configuration
- call to scan host

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 56 +++++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_init.c | 35 ++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 31 +++++++++++++++++++
 3 files changed, 122 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6c5d22a..1a26f27 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -35,13 +35,36 @@
 
 #define HISI_SAS_NAME_LEN 32
 
+
+enum dev_status {
+	HISI_SAS_DEV_NORMAL,
+	HISI_SAS_DEV_EH,
+};
+
 struct hisi_sas_phy {
+	struct hisi_hba	*hisi_hba;
 	struct hisi_sas_port	*port;
 	struct asd_sas_phy	sas_phy;
+	struct sas_identify	identify;
+	struct timer_list	timer;
+	u64		port_id; /* from hw */
+	u64		dev_sas_addr;
+	u64		phy_type;
+	u64		frame_rcvd_size;
+	u8		frame_rcvd[32];
+	u8		phy_attached;
+	u8		reserved[3];
+	u64		phy_event;
+	int		eye_diag_done;
+	enum sas_linkrate	minimum_linkrate;
+	enum sas_linkrate	maximum_linkrate;
 };
 
 struct hisi_sas_port {
 	struct asd_sas_port	sas_port;
+	u8	port_attached;
+	u8	id; /* from hw */
+	struct list_head	list;
 };
 
 struct hisi_sas_cq {
@@ -49,6 +72,18 @@ struct hisi_sas_cq {
 	int	id;
 };
 
+struct hisi_sas_device {
+	enum sas_device_type	dev_type;
+	struct hisi_hba		*hisi_hba;
+	struct domain_device	*sas_device;
+	u64 attached_phy;
+	u64 device_id;
+	u64 running_req;
+	struct hisi_sas_itct *itct;
+	u8 dev_status;
+	u64 reserved;
+};
+
 struct hisi_sas_slot {
 	struct list_head entry;
 	struct sas_task *task;
@@ -68,6 +103,19 @@ struct hisi_sas_slot {
 	struct hisi_sas_sge_page *sge_page;
 	dma_addr_t sge_page_dma;
 };
+
+enum hisi_sas_wq_event {
+	PHYUP,
+};
+
+struct hisi_sas_wq {
+	struct work_struct	work_struct;
+	struct hisi_hba *hisi_hba;
+	int phy_no;
+	int event;
+	int data;
+};
+
 struct hisi_hba {
 	spinlock_t	lock;
 
@@ -88,6 +136,10 @@ struct hisi_hba {
 
 	int	n_phy;
 
+
+	struct timer_list timer;
+	struct workqueue_struct *wq;
+
 	int slot_index_count;
 	unsigned long *slot_index_tags;
 
@@ -103,6 +155,8 @@ struct hisi_hba {
 	int	id;
 	int	queue_count;
 	char	*int_names;
+
+	struct hisi_sas_device	devices[HISI_SAS_MAX_DEVICES];
 	struct dma_pool *command_table_pool;
 	struct dma_pool *status_buffer_pool;
 	struct hisi_sas_itct *itct;
@@ -267,4 +321,6 @@ union hisi_sas_command_table {
 };
 
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
+void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
+void hisi_sas_wq_process(struct work_struct *work);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index c295c39..558e0e7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -41,6 +41,20 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	char name[32];
 	struct device *dev = &hisi_hba->pdev->dev;
 
+	spin_lock_init(&hisi_hba->lock);
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		hisi_sas_phy_init(hisi_hba, i);
+		hisi_hba->port[i].port_attached = 0;
+		hisi_hba->port[i].id = -1;
+		INIT_LIST_HEAD(&hisi_hba->port[i].list);
+	}
+
+	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
+		hisi_hba->devices[i].dev_type = SAS_PHY_UNUSED;
+		hisi_hba->devices[i].device_id = i;
+		hisi_hba->devices[i].dev_status = HISI_SAS_DEV_NORMAL;
+	}
+
 	for (i = 0; i < hisi_hba->queue_count; i++) {
 		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
 
@@ -139,6 +153,13 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	hisi_sas_slot_index_init(hisi_hba);
 
+	sprintf(name, "%s%d", "hisi_sas", hisi_hba->id);
+	hisi_hba->wq = create_singlethread_workqueue(name);
+	if (!hisi_hba->wq) {
+		dev_err(dev, "sas_alloc: failed to create workqueue\n");
+		goto err_out;
+	}
+
 	return 0;
 err_out:
 	return -ENOMEM;
@@ -199,6 +220,9 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 		dma_free_coherent(dev, s,
 				  hisi_hba->sata_breakpoint,
 				  hisi_hba->sata_breakpoint_dma);
+
+	if (hisi_hba->wq)
+		destroy_workqueue(hisi_hba->wq);
 }
 
 int hisi_sas_ioremap(struct hisi_hba *hisi_hba)
@@ -244,6 +268,8 @@ static struct hisi_hba *hisi_sas_hba_alloc(
 
 	hisi_hba->pdev = pdev;
 
+	init_timer(&hisi_hba->timer);
+
 	if (of_property_read_u32(np, "phy-count", &hisi_hba->n_phy))
 		goto err_out;
 
@@ -320,6 +346,13 @@ static int hisi_sas_probe(struct platform_device *pdev)
 	sha = SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
 	platform_set_drvdata(pdev, sha);
 
+	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
+	    dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32))) {
+		dev_err(dev, "No usable DMA addressing method\n");
+		rc = -EIO;
+		goto err_out_ha;
+	}
+
 	phy_nr = port_nr = hisi_hba->n_phy;
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
@@ -362,6 +395,8 @@ static int hisi_sas_probe(struct platform_device *pdev)
 	if (rc)
 		goto err_out_register_ha;
 
+	scsi_scan_host(shost);
+
 	return 0;
 
 err_out_register_ha:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 721412e..882ff79 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -26,3 +26,34 @@ void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 	for (i = 0; i < hisi_hba->slot_index_count; ++i)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
+
+void hisi_sas_wq_process(struct work_struct *work)
+{
+	struct hisi_sas_wq *wq =
+		container_of(work, struct hisi_sas_wq, work_struct);
+
+	kfree(wq);
+}
+
+void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	phy->hisi_hba = hisi_hba;
+	phy->port = NULL;
+	init_timer(&phy->timer);
+	sas_phy->enabled = (phy_no < hisi_hba->n_phy) ? 1 : 0;
+	sas_phy->class = SAS;
+	sas_phy->iproto = SAS_PROTOCOL_ALL;
+	sas_phy->tproto = 0;
+	sas_phy->type = PHY_TYPE_PHYSICAL;
+	sas_phy->role = PHY_ROLE_INITIATOR;
+	sas_phy->oob_mode = OOB_NOT_CONNECTED;
+	sas_phy->linkrate = SAS_LINK_RATE_UNKNOWN;
+	sas_phy->id = phy_no;
+	sas_phy->sas_addr = &hisi_hba->sas_addr[0];
+	sas_phy->frame_rcvd = &phy->frame_rcvd[0];
+	sas_phy->ha = (struct sas_ha_struct *)hisi_hba->shost->hostdata;
+	sas_phy->lldd_phy = phy;
+}
-- 
1.9.1

