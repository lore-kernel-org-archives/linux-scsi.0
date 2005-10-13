From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/12] qla2xxx: Correct fw-loader module-use referencing.
Date: Thu, 13 Oct 2005 16:17:14 -0700 (PDT)
Message-ID: <20051013231714.27191.14514.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28841 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932536AbVJMXRO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:17:14 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Subject: Correct fw-loader module-use referencing.

Original implementation would allow a firmware-loader module
to be removed during I/O.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/ql2100.c  |    5 ++
 drivers/scsi/qla2xxx/ql2200.c  |    5 ++
 drivers/scsi/qla2xxx/ql2300.c  |    6 +++
 drivers/scsi/qla2xxx/ql2322.c  |    5 ++
 drivers/scsi/qla2xxx/ql2400.c  |    8 +++-
 drivers/scsi/qla2xxx/ql6312.c  |    6 +++
 drivers/scsi/qla2xxx/qla_def.h |    2 -
 drivers/scsi/qla2xxx/qla_os.c  |   85 ++++++++++++++--------------------------
 8 files changed, 63 insertions(+), 59 deletions(-)

applies-to: 5b9c41f9a7562c87e6dbaa6a602b0842d9694896
efa63354c35d8eccf0a7a30a0a9902dd9c461843
diff --git a/drivers/scsi/qla2xxx/ql2100.c b/drivers/scsi/qla2xxx/ql2100.c
index f5db223..8050140 100644
--- a/drivers/scsi/qla2xxx/ql2100.c
+++ b/drivers/scsi/qla2xxx/ql2100.c
@@ -30,11 +30,16 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
+static struct scsi_host_template qla_driver_template = {
+	.module = THIS_MODULE,
+};
+
 static struct qla_board_info qla_board_tbl = {
 	.drv_name	= qla_driver_name,
 
 	.isp_name	= "ISP2100",
 	.fw_info	= qla_fw_tbl,
+	.sht		= &qla_driver_template,
 };
 
 static struct pci_device_id qla2100_pci_tbl[] = {
diff --git a/drivers/scsi/qla2xxx/ql2200.c b/drivers/scsi/qla2xxx/ql2200.c
index 0eef72d..e8f2af2 100644
--- a/drivers/scsi/qla2xxx/ql2200.c
+++ b/drivers/scsi/qla2xxx/ql2200.c
@@ -30,11 +30,16 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
+static struct scsi_host_template qla_driver_template = {
+	.module = THIS_MODULE,
+};
+
 static struct qla_board_info qla_board_tbl = {
 	.drv_name	= qla_driver_name,
 
 	.isp_name	= "ISP2200",
 	.fw_info	= qla_fw_tbl,
+	.sht		= &qla_driver_template,
 };
 
 static struct pci_device_id qla2200_pci_tbl[] = {
diff --git a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
index fd2f4b7..22e13f8 100644
--- a/drivers/scsi/qla2xxx/ql2300.c
+++ b/drivers/scsi/qla2xxx/ql2300.c
@@ -29,16 +29,22 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
+static struct scsi_host_template qla_driver_template = {
+	.module = THIS_MODULE,
+};
+
 static struct qla_board_info qla_board_tbl[] = {
 	{
 		.drv_name	= qla_driver_name,
 		.isp_name	= "ISP2300",
 		.fw_info	= qla_fw_tbl,
+		.sht		= &qla_driver_template,
 	},
 	{
 		.drv_name	= qla_driver_name,
 		.isp_name	= "ISP2312",
 		.fw_info	= qla_fw_tbl,
+		.sht		= &qla_driver_template,
 	},
 };
 
diff --git a/drivers/scsi/qla2xxx/ql2322.c b/drivers/scsi/qla2xxx/ql2322.c
index b7affb9..f335470 100644
--- a/drivers/scsi/qla2xxx/ql2322.c
+++ b/drivers/scsi/qla2xxx/ql2322.c
@@ -46,10 +46,15 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
+static struct scsi_host_template qla_driver_template = {
+	.module = THIS_MODULE,
+};
+
 static struct qla_board_info qla_board_tbl = {
 	.drv_name	= qla_driver_name,
 	.isp_name	= "ISP2322",
 	.fw_info	= qla_fw_tbl,
+	.sht		= &qla_driver_template,
 };
 
 static struct pci_device_id qla2322_pci_tbl[] = {
diff --git a/drivers/scsi/qla2xxx/ql2400.c b/drivers/scsi/qla2xxx/ql2400.c
index 76a48ed..a7ace67 100644
--- a/drivers/scsi/qla2xxx/ql2400.c
+++ b/drivers/scsi/qla2xxx/ql2400.c
@@ -36,20 +36,24 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
+static struct scsi_host_template qla_driver_template = {
+	.module = THIS_MODULE,
+};
+
 static struct qla_board_info qla_board_tbl[] = {
 	{
 		.drv_name	= qla_driver_name,
 		.isp_name	= "ISP2422",
 		.fw_info	= qla_fw_tbl,
 		.fw_fname	= "ql2400_fw.bin",
-		.alternate_sht	= 1,
+		.sht		= &qla_driver_template,
 	},
 	{
 		.drv_name	= qla_driver_name,
 		.isp_name	= "ISP2432",
 		.fw_info	= qla_fw_tbl,
 		.fw_fname	= "ql2400_fw.bin",
-		.alternate_sht	= 1,
+		.sht		= &qla_driver_template,
 	},
 };
 
diff --git a/drivers/scsi/qla2xxx/ql6312.c b/drivers/scsi/qla2xxx/ql6312.c
index de55397..274b337 100644
--- a/drivers/scsi/qla2xxx/ql6312.c
+++ b/drivers/scsi/qla2xxx/ql6312.c
@@ -28,16 +28,22 @@ static struct qla_fw_info qla_fw_tbl[] =
 	{ FW_INFO_ADDR_NOMORE, },
 };
 
+static struct scsi_host_template qla_driver_template = {
+	.module = THIS_MODULE,
+};
+
 static struct qla_board_info qla_board_tbl[] = {
 	{
 		.drv_name	= qla_driver_name,
 		.isp_name	= "ISP6312",
 		.fw_info	= qla_fw_tbl,
+		.sht		= &qla_driver_template,
 	},
 	{
 		.drv_name	= qla_driver_name,
 		.isp_name	= "ISP6322",
 		.fw_info	= qla_fw_tbl,
+		.sht		= &qla_driver_template,
 	},
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1dcb69e..1763081 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2119,7 +2119,7 @@ struct qla_board_info {
 	char isp_name[8];
 	struct qla_fw_info *fw_info;
 	char *fw_fname;
-	int alternate_sht;
+	struct scsi_host_template *sht;
 };
 
 struct fw_blob {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2daba58..d73485e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -94,60 +94,6 @@ static int qla2x00_device_reset(scsi_qla
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 
-static struct scsi_host_template qla2x00_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= "qla2xxx",
-	.queuecommand		= qla2x00_queuecommand,
-
-	.eh_abort_handler	= qla2xxx_eh_abort,
-	.eh_device_reset_handler = qla2xxx_eh_device_reset,
-	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
-	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
-
-	.slave_configure	= qla2xxx_slave_configure,
-
-	.slave_alloc		= qla2xxx_slave_alloc,
-	.slave_destroy		= qla2xxx_slave_destroy,
-	.change_queue_depth	= qla2x00_change_queue_depth,
-	.change_queue_type	= qla2x00_change_queue_type,
-	.this_id		= -1,
-	.cmd_per_lun		= 3,
-	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
-
-	/*
-	 * The RISC allows for each command to transfer (2^32-1) bytes of data,
-	 * which equates to 0x800000 sectors.
-	 */
-	.max_sectors		= 0xFFFF,
-	.shost_attrs		= qla2x00_host_attrs,
-};
-
-static struct scsi_host_template qla24xx_driver_template = {
-	.module			= THIS_MODULE,
-	.name			= "qla2xxx",
-	.queuecommand		= qla24xx_queuecommand,
-
-	.eh_abort_handler	= qla2xxx_eh_abort,
-	.eh_device_reset_handler = qla2xxx_eh_device_reset,
-	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
-	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
-
-	.slave_configure	= qla2xxx_slave_configure,
-
-	.slave_alloc		= qla2xxx_slave_alloc,
-	.slave_destroy		= qla2xxx_slave_destroy,
-	.change_queue_depth	= qla2x00_change_queue_depth,
-	.change_queue_type	= qla2x00_change_queue_type,
-	.this_id		= -1,
-	.cmd_per_lun		= 3,
-	.use_clustering		= ENABLE_CLUSTERING,
-	.sg_tablesize		= SG_ALL,
-
-	.max_sectors		= 0xFFFF,
-	.shost_attrs		= qla2x00_host_attrs,
-};
-
 static struct scsi_transport_template *qla2xxx_transport_template = NULL;
 
 /* TODO Convert to inlines
@@ -1197,6 +1143,34 @@ qla24xx_disable_intrs(scsi_qla_host_t *h
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
+static struct scsi_host_template *
+qla2x00_prep_sht(struct pci_dev *pdev, struct scsi_host_template *sht)
+{
+	sht->name		= "qla2xxx";
+	sht->queuecommand	= qla2x00_queuecommand;
+	sht->eh_abort_handler	= qla2xxx_eh_abort;
+	sht->eh_device_reset_handler = qla2xxx_eh_device_reset;
+	sht->eh_bus_reset_handler = qla2xxx_eh_bus_reset;
+	sht->eh_host_reset_handler = qla2xxx_eh_host_reset;
+	sht->slave_configure	= qla2xxx_slave_configure;
+	sht->slave_alloc	= qla2xxx_slave_alloc;
+	sht->slave_destroy	= qla2xxx_slave_destroy;
+	sht->change_queue_depth	= qla2x00_change_queue_depth;
+	sht->change_queue_type	= qla2x00_change_queue_type;
+	sht->this_id		= -1;
+	sht->cmd_per_lun	= 3;
+	sht->use_clustering	= ENABLE_CLUSTERING;
+	sht->sg_tablesize	= SG_ALL;
+	sht->max_sectors	= 0xffff;
+	sht->shost_attrs	= qla2x00_host_attrs;
+
+	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432)
+		sht->queuecommand	= qla24xx_queuecommand;
+
+	return sht;
+}
+
 /*
  * PCI driver interface
  */
@@ -1215,8 +1189,7 @@ int qla2x00_probe_one(struct pci_dev *pd
 	if (pci_enable_device(pdev))
 		goto probe_out;
 
-	host = scsi_host_alloc(brd_info->alternate_sht ?
-	    &qla24xx_driver_template: &qla2x00_driver_template,
+	host = scsi_host_alloc(qla2x00_prep_sht(pdev, brd_info->sht),
 	    sizeof(scsi_qla_host_t));
 	if (host == NULL) {
 		printk(KERN_WARNING
---
0.99.8.GIT

-- 
Andrew Vasquez
