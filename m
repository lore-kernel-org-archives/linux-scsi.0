From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 04/32] scsi: hisi_sas: add scsi host registration
Date: Tue, 10 Nov 2015 00:32:09 +0800
Message-ID: <1447086757-147706-5-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add functionality to register device as a scsi host.

The SAS domain transport ops are empty at this point.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  34 ++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 116 ++++++++++++++++++++++++++++++++++
 2 files changed, 150 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a5cec22..6f57fd1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -23,4 +23,38 @@
 
 #define DRV_VERSION "v1.0"
 
+#define HISI_SAS_MAX_PHYS	9
+#define HISI_SAS_MAX_ITCT_ENTRIES 4096
+#define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
+#define HISI_SAS_COMMAND_ENTRIES 8192
+
+struct hisi_sas_phy {
+	struct asd_sas_phy	sas_phy;
+};
+
+struct hisi_sas_port {
+	struct asd_sas_port	sas_port;
+};
+
+struct hisi_sas_hw {
+};
+
+struct hisi_hba {
+	/* This must be the first element, used by SHOST_TO_SAS_HA */
+	struct sas_ha_struct *p;
+
+	struct platform_device *pdev;
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	int n_phy;
+
+	/* SCSI/SAS glue */
+	struct sas_ha_struct sha;
+	struct Scsi_Host *shost;
+	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
+	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
+	const struct hisi_sas_hw *hw;	/* Low level hw interface */
+};
+
+#define HISI_SAS_SGE_PAGE_CNT SCSI_MAX_SG_SEGMENTS
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7201363..4fd000e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -14,9 +14,125 @@
 
 static struct scsi_transport_template *hisi_sas_stt;
 
+static struct scsi_host_template hisi_sas_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.queuecommand		= sas_queuecommand,
+	.target_alloc		= sas_target_alloc,
+	.slave_configure	= sas_slave_configure,
+	.change_queue_depth	= sas_change_queue_depth,
+	.bios_param		= sas_bios_param,
+	.can_queue		= 1,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.eh_device_reset_handler = sas_eh_device_reset_handler,
+	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.target_destroy		= sas_target_destroy,
+	.ioctl			= sas_ioctl,
+};
+
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 };
 
+static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
+					      const struct hisi_sas_hw *hw)
+{
+	struct Scsi_Host *shost;
+	struct hisi_hba *hisi_hba;
+	struct device *dev = &pdev->dev;
+
+	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
+	if (!shost)
+		goto err_out;
+	hisi_hba = shost_priv(shost);
+
+	hisi_hba->hw = hw;
+	hisi_hba->pdev = pdev;
+	hisi_hba->shost = shost;
+	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
+
+	return shost;
+err_out:
+	dev_err(dev, "shost alloc failed\n");
+	return NULL;
+}
+
+int hisi_sas_probe(struct platform_device *pdev,
+			 const struct hisi_sas_hw *hw)
+{
+	struct Scsi_Host *shost;
+	struct hisi_hba *hisi_hba;
+	struct device *dev = &pdev->dev;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	struct sas_ha_struct *sha;
+	int rc, phy_nr, port_nr, i;
+
+	shost = hisi_sas_shost_alloc(pdev, hw);
+	if (!shost) {
+		rc = -ENOMEM;
+		goto err_out_ha;
+	}
+
+	sha = SHOST_TO_SAS_HA(shost);
+	hisi_hba = shost_priv(shost);
+	platform_set_drvdata(pdev, sha);
+	hisi_hba->n_phy = HISI_SAS_MAX_PHYS;
+	phy_nr = port_nr = hisi_hba->n_phy;
+
+	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
+	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
+	if (!arr_phy || !arr_port)
+		return -ENOMEM;
+
+	sha->sas_phy = arr_phy;
+	sha->sas_port = arr_port;
+	sha->core.shost = shost;
+	sha->lldd_ha = hisi_hba;
+
+	shost->transportt = hisi_sas_stt;
+	shost->max_id = HISI_SAS_MAX_DEVICES;
+	shost->max_lun = ~0;
+	shost->max_channel = 1;
+	shost->max_cmd_len = 16;
+	shost->sg_tablesize = min_t(u16, SG_ALL, HISI_SAS_SGE_PAGE_CNT);
+	shost->can_queue = HISI_SAS_COMMAND_ENTRIES;
+	shost->cmd_per_lun = HISI_SAS_COMMAND_ENTRIES;
+
+	sha->sas_ha_name = DRV_NAME;
+	sha->dev = &hisi_hba->pdev->dev;
+	sha->lldd_module = THIS_MODULE;
+	sha->sas_addr = &hisi_hba->sas_addr[0];
+	sha->num_phys = hisi_hba->n_phy;
+	sha->core.shost = hisi_hba->shost;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		sha->sas_phy[i] = &hisi_hba->phy[i].sas_phy;
+		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
+	}
+
+	rc = scsi_add_host(shost, &pdev->dev);
+	if (rc)
+		goto err_out_ha;
+
+	rc = sas_register_ha(sha);
+	if (rc)
+		goto err_out_register_ha;
+
+	scsi_scan_host(shost);
+
+	return 0;
+
+err_out_register_ha:
+	scsi_remove_host(shost);
+err_out_ha:
+	kfree(shost);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_probe);
+
 static __init int hisi_sas_init(void)
 {
 	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
-- 
1.9.1
