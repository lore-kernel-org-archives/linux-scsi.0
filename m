From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 08/11] qla4xxx: fixed NULL pointer dereference in
	eh_device_reset
Date: Fri, 29 Jan 2010 22:29:06 -0800
Message-ID: <20100130062906.GI10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:9034 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0A3G1Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2010 01:27:16 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>


From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Created variables to reference h, b, t, l, because if
scsi passthru command completes within eh_device_reset,
the cmd structure may no longer be valid.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   53 +++++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e5c9b85..b780d29 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1619,16 +1619,34 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
  **/
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
-	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct scsi_qla_host *ha;
+	struct ddb_entry *ddb_entry;
 	int ret = FAILED, stat;
+	struct Scsi_Host *h;
+	unsigned int b, t, l;
+
+	if (cmd == NULL) {
+		DEBUG2(printk("%s: **** SCSI mid-layer passing in NULL cmd"
+				"DEVICE RESET - cmd already completed.\n",
+				__func__));
+		return SUCCESS;
+	}
 
-	if (!ddb_entry)
+	h = cmd->device->host;
+	b = cmd->device->channel;
+	t = cmd->device->id;
+	l = cmd->device->lun;
+	ha = to_qla_host(h);
+	ddb_entry = cmd->device->hostdata;
+
+	if (!ddb_entry) {
+		DEBUG2(printk("scsi%ld: DEVICE RESET - NULL ddb entry.\n"
+				, ha->host_no));
 		return ret;
+	}
 
-	dev_info(&ha->pdev->dev,
-		   "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n", ha->host_no,
-		   cmd->device->channel, cmd->device->id, cmd->device->lun);
+	dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n"
+				 , ha->host_no, b, t, l);
 
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
@@ -1636,8 +1654,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		      cmd, jiffies, cmd->request->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
-	/* FIXME: wait for hba to go online */
-	stat = qla4xxx_reset_lun(ha, ddb_entry, cmd->device->lun);
+	/* wait for hba to go online */
+	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
+		dev_info(&ha->pdev->dev, "%s: DEVICE RESET."
+			 "Adapter Offline.\n", __func__);
+                return FAILED;
+        }
+	stat = qla4xxx_reset_lun(ha, ddb_entry, l);
 	if (stat != QLA_SUCCESS) {
 		dev_info(&ha->pdev->dev, "DEVICE RESET FAILED. %d\n", stat);
 		goto eh_dev_reset_done;
@@ -1652,14 +1675,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* Send marker. */
-	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
-		MM_LUN_RESET) != QLA_SUCCESS)
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, l, MM_LUN_RESET)
+		!= QLA_SUCCESS)
 		goto eh_dev_reset_done;
 
 	dev_info(&ha->pdev->dev,
 		   "scsi(%ld:%d:%d:%d): DEVICE RESET SUCCEEDED.\n",
-		   ha->host_no, cmd->device->channel, cmd->device->id,
-		   cmd->device->lun);
+		   ha->host_no, b, t, l);
 
 	ret = SUCCESS;
 
@@ -1733,6 +1755,13 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	int return_status = FAILED;
 	struct scsi_qla_host *ha;
 
+	if (cmd == NULL) {
+		DEBUG2(printk("%s: **** SCSI mid-layer passing in NULL cmd"
+			      "HOST RESET - cmd already completed.\n",
+			      __func__));
+		return SUCCESS;
+	}
+
 	ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
 
 	dev_info(&ha->pdev->dev,
-- 
1.6.0.2

