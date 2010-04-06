From: Ravi Anand <ravi.anand@qlogic.com>
Subject: [PATCH 06/12] qla4xxx: fixed NULL pointer dereference in
	eh_device_reset
Date: Tue, 6 Apr 2010 03:14:13 -0700
Message-ID: <20100406101413.GM22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27589 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab0DFKPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 06:15:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Created variables to reference h, b, t, l, because if
scsi passthru command completes within eh_device_reset,
the cmd structure may no longer be valid.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   55 +++++++++++++++++++++++++++++++---------
 1 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9ff4cae..ca1d293 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1587,16 +1587,34 @@ static int qla4xxx_eh_wait_for_commands(struct scsi_qla_host *ha,
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
+		DEBUG2(printk(KERN_INFO "%s: **** SCSI mid-layer passing in"
+				" NULL cmd DEVICE RESET - cmd already"
+				" completed.\n", __func__));
+		return SUCCESS;
+	}
 
-	if (!ddb_entry)
-		return ret;
+	h = cmd->device->host;
+	b = cmd->device->channel;
+	t = cmd->device->id;
+	l = cmd->device->lun;
+	ha = to_qla_host(h);
+	ddb_entry = cmd->device->hostdata;
 
-	dev_info(&ha->pdev->dev,
-		   "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n", ha->host_no,
-		   cmd->device->channel, cmd->device->id, cmd->device->lun);
+	if (!ddb_entry) {
+		DEBUG2(printk("scsi%ld: DEVICE RESET - NULL ddb entry.\n"
+				, ha->host_no));
+		return FAILED;
+	}
+
+	dev_info(&ha->pdev->dev, "scsi%ld:%d:%d:%d: DEVICE RESET ISSUED.\n"
+				 , ha->host_no, b, t, l);
 
 	DEBUG2(printk(KERN_INFO
 		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
@@ -1604,8 +1622,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		      cmd, jiffies, cmd->request->timeout / HZ,
 		      ha->dpc_flags, cmd->result, cmd->allowed));
 
-	/* FIXME: wait for hba to go online */
-	stat = qla4xxx_reset_lun(ha, ddb_entry, cmd->device->lun);
+	/* wait for hba to go online */
+	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
+		dev_info(&ha->pdev->dev, "%s: DEVICE RESET."
+			 "Adapter Offline.\n", __func__);
+		return FAILED;
+	}
+	stat = qla4xxx_reset_lun(ha, ddb_entry, l);
 	if (stat != QLA_SUCCESS) {
 		dev_info(&ha->pdev->dev, "DEVICE RESET FAILED. %d\n", stat);
 		goto eh_dev_reset_done;
@@ -1620,14 +1643,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
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
 
@@ -1701,6 +1723,13 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	int return_status = FAILED;
 	struct scsi_qla_host *ha;
 
+	if (cmd == NULL) {
+		DEBUG2(printk(KERN_INFO "%s: **** SCSI mid-layer passing in"
+				" NULL cmd HOST RESET - cmd already"
+				" completed.\n", __func__));
+		return SUCCESS;
+	}
+
 	ha = (struct scsi_qla_host *) cmd->device->host->hostdata;
 
 	dev_info(&ha->pdev->dev,
-- 
1.6.0.2

----- End forwarded message -----
