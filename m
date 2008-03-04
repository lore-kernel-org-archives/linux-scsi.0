From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] qla4xxx: regression - add start scan callout
Date: Tue,  4 Mar 2008 13:26:54 -0600
Message-ID: <1204658815-6185-3-git-send-email-michaelc@cs.wisc.edu>
References: <1204658815-6185-1-git-send-email-michaelc@cs.wisc.edu>
 <1204658815-6185-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761243AbYCDT1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:27:00 -0500
In-Reply-To: <1204658815-6185-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We are seeing EXIST errors from sysfs during device addition.
We need a start scan callout so we do not start scanning sessions
found during hba setup, before the async scsi scan code is ready.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Acked-by: David C Somayajulu <david.somayajulu@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 10a233e..8b92f34 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -75,6 +75,7 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static int qla4xxx_slave_configure(struct scsi_device *device);
 static void qla4xxx_slave_destroy(struct scsi_device *sdev);
+static void qla4xxx_scan_start(struct Scsi_Host *shost);
 
 static struct scsi_host_template qla4xxx_driver_template = {
 	.module			= THIS_MODULE,
@@ -90,6 +91,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.slave_destroy		= qla4xxx_slave_destroy,
 
 	.scan_finished		= iscsi_scan_finished,
+	.scan_start		= qla4xxx_scan_start,
 
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
@@ -299,6 +301,18 @@ struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha)
 	return ddb_entry;
 }
 
+static void qla4xxx_scan_start(struct Scsi_Host *shost)
+{
+	struct scsi_qla_host *ha = shost_priv(shost);
+	struct ddb_entry *ddb_entry, *ddbtemp;
+
+	/* finish setup of sessions that were already setup in firmware */
+	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
+		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE)
+			qla4xxx_add_sess(ddb_entry);
+	}
+}
+
 /*
  * Timer routines
  */
@@ -1178,7 +1192,6 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	int ret = -ENODEV, status;
 	struct Scsi_Host *host;
 	struct scsi_qla_host *ha;
-	struct ddb_entry *ddb_entry, *ddbtemp;
 	uint8_t init_retry_count = 0;
 	char buf[34];
 
@@ -1297,13 +1310,6 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	if (ret)
 		goto probe_failed;
 
-	/* Update transport device information for all devices. */
-	list_for_each_entry_safe(ddb_entry, ddbtemp, &ha->ddb_list, list) {
-		if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE)
-			if (qla4xxx_add_sess(ddb_entry))
-				goto remove_host;
-	}
-
 	printk(KERN_INFO
 	       " QLogic iSCSI HBA Driver version: %s\n"
 	       "  QLogic ISP%04x @ %s, host#=%ld, fw=%02d.%02d.%02d.%02d\n",
@@ -1313,10 +1319,6 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	scsi_scan_host(host);
 	return 0;
 
-remove_host:
-	qla4xxx_free_ddb_list(ha);
-	scsi_remove_host(host);
-
 probe_failed:
 	qla4xxx_free_adapter(ha);
 	scsi_host_put(ha->host);
-- 
1.5.4.1

