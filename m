From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 25/36] smartpqi: update device offline
Date: Wed, 3 May 2017 18:54:49 -0500
Message-ID: <149385568935.11043.1261820014743752072.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0074.outbound.protection.outlook.com ([104.47.42.74]:42774
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751927AbdECXy6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:54:58 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

- Improve handling of offline devices.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 57ff80f..f36aace 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -285,6 +285,11 @@ static inline void pqi_ctrl_wait_until_quiesced(struct pqi_ctrl_info *ctrl_info)
 		usleep_range(1000, 2000);
 }
 
+static inline bool pqi_device_offline(struct pqi_scsi_dev *device)
+{
+	return device->device_offline;
+}
+
 static inline void pqi_device_reset_start(struct pqi_scsi_dev *device)
 {
 	device->in_reset = true;
@@ -2399,15 +2404,17 @@ static inline void pqi_take_device_offline(struct scsi_device *sdev, char *path)
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
 
-	if (scsi_device_online(sdev)) {
-		scsi_device_set_state(sdev, SDEV_OFFLINE);
-		ctrl_info = shost_to_hba(sdev->host);
-		schedule_delayed_work(&ctrl_info->rescan_work, 0);
-		device = sdev->hostdata;
-		dev_err(&ctrl_info->pci_dev->dev, "offlined %s scsi %d:%d:%d:%d\n",
-			path, ctrl_info->scsi_host->host_no, device->bus,
-			device->target, device->lun);
-	}
+	device = sdev->hostdata;
+	if (device->device_offline)
+		return;
+
+	device->device_offline = true;
+	scsi_device_set_state(sdev, SDEV_OFFLINE);
+	ctrl_info = shost_to_hba(sdev->host);
+	pqi_schedule_rescan_worker(ctrl_info);
+	dev_err(&ctrl_info->pci_dev->dev, "offlined %s scsi %d:%d:%d:%d\n",
+		path, ctrl_info->scsi_host->host_no, device->bus,
+		device->target, device->lun);
 }
 
 static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
@@ -4598,6 +4605,7 @@ static inline void pqi_schedule_bypass_retry(struct pqi_ctrl_info *ctrl_info)
 static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 {
 	struct scsi_cmnd *scmd;
+	struct pqi_scsi_dev *device;
 	struct pqi_ctrl_info *ctrl_info;
 
 	if (!io_request->raid_bypass)
@@ -4609,6 +4617,10 @@ static bool pqi_raid_bypass_retry_needed(struct pqi_io_request *io_request)
 	if (host_byte(scmd->result) == DID_NO_CONNECT)
 		return false;
 
+	device = scmd->device->hostdata;
+	if (pqi_device_offline(device))
+		return false;
+
 	ctrl_info = shost_to_hba(scmd->device->host);
 	if (pqi_ctrl_offline(ctrl_info))
 		return false;
