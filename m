From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/15] qla2xxx: Consolidate "qla2xxx" string usage to a #define.
Date: Wed, 17 May 2006 15:09:45 -0700
Message-ID: <11479037803635-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26811 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1751217AbWEQWJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:09:46 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

72564d4fff298e0b272c9284de9925567956dd3b
 drivers/scsi/qla2xxx/qla_def.h |    2 ++
 drivers/scsi/qla2xxx/qla_os.c  |   15 ++++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

72564d4fff298e0b272c9284de9925567956dd3b
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c4136bf..30a9319 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -31,6 +31,8 @@ #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_transport_fc.h>
 
+#define QLA2XXX_DRIVER_NAME  "qla2xxx"
+
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
  * but that's fine as we don't look at the last 24 ones for
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f1525dd..56e09fc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -86,7 +86,7 @@ static int qla2x00_change_queue_type(str
 
 static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
-	.name			= "qla2xxx",
+	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla2x00_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
@@ -115,7 +115,7 @@ static struct scsi_host_template qla2x00
 
 static struct scsi_host_template qla24xx_driver_template = {
 	.module			= THIS_MODULE,
-	.name			= "qla2xxx",
+	.name			= QLA2XXX_DRIVER_NAME,
 	.queuecommand		= qla24xx_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
@@ -1242,7 +1242,7 @@ qla2x00_iospace_config(scsi_qla_host_t *
 		goto iospace_error_exit;
 	}
 
-	if (pci_request_regions(ha->pdev, "qla2xxx")) {
+	if (pci_request_regions(ha->pdev, QLA2XXX_DRIVER_NAME)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve PIO/MMIO regions (%s)\n",
 		    pci_name(ha->pdev));
@@ -1358,7 +1358,7 @@ static int qla2x00_probe_one(struct pci_
 	ha->pdev = pdev;
 	ha->host = host;
 	ha->host_no = host->host_no;
-	sprintf(ha->host_str, "qla2xxx_%ld", ha->host_no);
+	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, ha->host_no);
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
@@ -1541,7 +1541,7 @@ static int qla2x00_probe_one(struct pci_
 	host->transportt = qla2xxx_transport_template;
 
 	ret = request_irq(pdev->irq, ha->isp_ops.intr_handler,
-	    SA_INTERRUPT|SA_SHIRQ, "qla2xxx", ha);
+	    SA_INTERRUPT|SA_SHIRQ, QLA2XXX_DRIVER_NAME, ha);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
@@ -1871,7 +1871,8 @@ qla2x00_mem_alloc(scsi_qla_host_t *ha)
 			continue;
 		}
 
-		snprintf(name, sizeof(name), "qla2xxx_%ld", ha->host_no);
+		snprintf(name, sizeof(name), "%s_%ld", QLA2XXX_DRIVER_NAME,
+		    ha->host_no);
 		ha->s_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 		    DMA_POOL_SIZE, 8, 0);
 		if (ha->s_dma_pool == NULL) {
@@ -2634,7 +2635,7 @@ qla2xxx_remove_one(struct pci_dev *pdev)
 }
 
 static struct pci_driver qla2xxx_pci_driver = {
-	.name		= "qla2xxx",
+	.name		= QLA2XXX_DRIVER_NAME,
 	.driver		= {
 		.owner		= THIS_MODULE,
 	},
-- 
1.3.3.g63df


