From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/25] scsi: hisi_sas: add scsi host registration
Date: Mon, 12 Oct 2015 23:20:16 +0800
Message-ID: <1444663237-238302-5-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:12828 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbbJLPJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:09:01 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add functionality to register device as a scsi host.

The SAS domain transport ops are empty at this point.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  32 +++++++++
 drivers/scsi/hisi_sas/hisi_sas_init.c | 125 ++++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 50204a2..1a90b54 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -21,4 +21,36 @@
 #define DRV_NAME "hisi_sas"
 #define DRV_VERSION "v1.0"
 
+#define HISI_SAS_MAX_PHYS	9
+#define HISI_SAS_MAX_ITCT_ENTRIES 4096
+#define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
+#define HISI_SAS_COMMAND_ENTRIES 8192
+
+
+struct hisi_sas_phy {
+	struct hisi_sas_port	*port;
+	struct asd_sas_phy	sas_phy;
+};
+
+struct hisi_sas_port {
+	struct asd_sas_port	sas_port;
+};
+
+struct hisi_hba {
+	spinlock_t	lock;
+
+	struct platform_device *pdev;
+
+
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	int	n_phy;
+	/* SCSI/SAS glue */
+	struct sas_ha_struct sha;
+	struct Scsi_Host *shost;
+	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
+	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
+};
+
+#define HISI_SAS_SGE_PAGE_CNT SCSI_MAX_SG_SEGMENTS
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index dd83430..2cae458 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -10,20 +10,140 @@
  */
 
 #include "hisi_sas.h"
+static struct scsi_transport_template *hisi_sas_stt;
+
+static struct scsi_host_template hisi_sas_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.queuecommand		= sas_queuecommand,
+	.target_alloc		= sas_target_alloc,
+	.slave_configure	= sas_slave_configure,
+	.change_queue_depth	= sas_change_queue_depth,
+	.bios_param		= sas_bios_param,
+	.can_queue		= 1,
+	.cmd_per_lun		= 1,
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
+static struct sas_domain_function_template hisi_sas_transport_ops = {
+};
+
 
 static const struct of_device_id sas_of_match[] = {
 	{ .compatible = "hisilicon,sas-controller-v1",},
 	{},
 };
 MODULE_DEVICE_TABLE(of, sas_of_match);
+
+static struct hisi_hba *hisi_sas_hba_alloc(
+			struct platform_device *pdev,
+			struct Scsi_Host *shost,
+			struct device_node *np)
+{
+	int interrupt_count, interrupt_cells;
+	struct hisi_hba *hisi_hba;
+
+	hisi_hba = devm_kzalloc(&pdev->dev, sizeof(*hisi_hba), GFP_KERNEL);
+	if (!hisi_hba)
+		goto err_out;
+
+	hisi_hba->pdev = pdev;
+	hisi_hba->shost = shost;
+
+	return hisi_hba;
+err_out:
+	dev_err(&pdev->dev, "hba alloc failed\n");
+	return NULL;
+}
+
 static int hisi_sas_probe(struct platform_device *pdev)
 {
+	struct Scsi_Host *shost;
+	struct hisi_hba *hisi_hba;
+	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	struct sas_ha_struct *sha;
+	int rc, phy_nr, port_nr, i;
+
+	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(void *));
+	if (!shost)
+		return -ENOMEM;
+
+	hisi_hba = hisi_sas_hba_alloc(pdev, shost, np);
+	if (!hisi_hba) {
+		rc = -ENOMEM;
+		goto err_out_ha;
+	}
+
+	sha = SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
+	platform_set_drvdata(pdev, sha);
+
+	phy_nr = port_nr = HISI_SAS_MAX_PHYS;
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
+	rc = scsi_add_host(shost, &pdev->dev);
+	if (rc)
+		goto err_out_ha;
+
+	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
+	if (rc)
+		goto err_out_register_ha;
 
 	return 0;
+
+err_out_register_ha:
+	scsi_remove_host(shost);
+err_out_ha:
+	kfree(shost);
+	return rc;
 }
 
 static int hisi_sas_remove(struct platform_device *pdev)
 {
+	struct sas_ha_struct *sha = platform_get_drvdata(pdev);
+
+	sas_unregister_ha(sha);
+	sas_remove_host(sha->core.shost);
+	scsi_remove_host(sha->core.shost);
+
 	return 0;
 }
 
@@ -40,12 +160,17 @@ static __init int hisi_sas_init(void)
 {
 	pr_info("hisi_sas: driver version %s\n", DRV_VERSION);
 
+	hisi_sas_stt = sas_domain_attach_transport(&hisi_sas_transport_ops);
+	if (!hisi_sas_stt)
+		return -ENOMEM;
+
 	return platform_driver_register(&hisi_sas_driver);
 }
 
 static __exit void hisi_sas_exit(void)
 {
 	platform_driver_unregister(&hisi_sas_driver);
+	sas_release_transport(hisi_sas_stt);
 }
 
 module_init(hisi_sas_init);
-- 
1.9.1

