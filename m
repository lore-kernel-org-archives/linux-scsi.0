From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 18/37] smartpqi: cleanup messages
Date: Tue, 25 Apr 2017 14:47:41 -0500
Message-ID: <149314966189.13903.16638515102195812930.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:25571
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1167899AbdDYTsO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:48:14 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

- improve some error messages.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   40 +++++++++++++++------------------
 drivers/scsi/smartpqi/smartpqi_sis.c  |    3 ++
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 10c232e..3ffca17 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -992,7 +992,10 @@ static int pqi_validate_raid_map(struct pqi_ctrl_info *ctrl_info,
 	return 0;
 
 bad_raid_map:
-	dev_warn(&ctrl_info->pci_dev->dev, "%s\n", err_msg);
+	dev_warn(&ctrl_info->pci_dev->dev,
+		"scsi %d:%d:%d:%d %s\n",
+		ctrl_info->scsi_host->host_no,
+		device->bus, device->target, device->lun, err_msg);
 
 	return -EINVAL;
 }
@@ -1251,7 +1254,7 @@ static void pqi_show_volume_status(struct pqi_ctrl_info *ctrl_info,
 		break;
 	case CISS_LV_ENCRYPTED_IN_NON_ENCRYPTED_CONTROLLER:
 		status =
-			"Encrypted volume inaccessible - disabled on ctrl";
+		"Volume encrypted but encryption disabled on controller";
 		break;
 	case CISS_LV_PENDING_ENCRYPTION:
 		status = "Volume pending migration to encrypted state";
@@ -2429,7 +2432,7 @@ static inline void pqi_aio_path_disabled(struct pqi_io_request *io_request)
 	device->offload_enabled = false;
 }
 
-static inline void pqi_take_device_offline(struct scsi_device *sdev)
+static inline void pqi_take_device_offline(struct scsi_device *sdev, char *path)
 {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
@@ -2439,8 +2442,8 @@ static inline void pqi_take_device_offline(struct scsi_device *sdev)
 		ctrl_info = shost_to_hba(sdev->host);
 		schedule_delayed_work(&ctrl_info->rescan_work, 0);
 		device = sdev->hostdata;
-		dev_err(&ctrl_info->pci_dev->dev, "offlined scsi %d:%d:%d:%d\n",
-			ctrl_info->scsi_host->host_no, device->bus,
+		dev_err(&ctrl_info->pci_dev->dev, "offlined %s scsi %d:%d:%d:%d\n",
+			path, ctrl_info->scsi_host->host_no, device->bus,
 			device->target, device->lun);
 	}
 }
@@ -2487,7 +2490,7 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 				sshdr.sense_key == HARDWARE_ERROR &&
 				sshdr.asc == 0x3e &&
 				sshdr.ascq == 0x1) {
-			pqi_take_device_offline(scmd->device);
+			pqi_take_device_offline(scmd->device, "RAID");
 			host_byte = DID_NO_CONNECT;
 		}
 
@@ -2547,7 +2550,7 @@ static void pqi_process_aio_io_error(struct pqi_io_request *io_request)
 		case PQI_AIO_STATUS_NO_PATH_TO_DEVICE:
 		case PQI_AIO_STATUS_INVALID_DEVICE:
 			device_offline = true;
-			pqi_take_device_offline(scmd->device);
+			pqi_take_device_offline(scmd->device, "AIO");
 			host_byte = DID_NO_CONNECT;
 			scsi_status = SAM_STAT_CHECK_CONDITION;
 			break;
@@ -3203,11 +3206,8 @@ static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 			alloc_length,
 			&ctrl_info->queue_memory_base_dma_handle, GFP_KERNEL);
 
-	if (!ctrl_info->queue_memory_base) {
-		dev_err(&ctrl_info->pci_dev->dev,
-			"unable to allocate memory for PQI admin queues\n");
+	if (!ctrl_info->queue_memory_base)
 		return -ENOMEM;
-	}
 
 	ctrl_info->queue_memory_length = alloc_length;
 
@@ -3576,7 +3576,6 @@ static int pqi_wait_for_completion_io(struct pqi_ctrl_info *ctrl_info,
 	struct completion *wait)
 {
 	int rc;
-	unsigned int wait_secs = 0;
 
 	while (1) {
 		if (wait_for_completion_io_timeout(wait,
@@ -3590,12 +3589,6 @@ static int pqi_wait_for_completion_io(struct pqi_ctrl_info *ctrl_info,
 			rc = -ENXIO;
 			break;
 		}
-
-		wait_secs += PQI_WAIT_FOR_COMPLETION_IO_TIMEOUT_SECS;
-
-		dev_err(&ctrl_info->pci_dev->dev,
-			"waiting %u seconds for completion\n",
-			wait_secs);
 	}
 
 	return rc;
@@ -5700,7 +5693,7 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 	config_table = kmalloc(table_length, GFP_KERNEL);
 	if (!config_table) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"unable to allocate memory for PQI configuration table\n");
+			"failed to allocate memory for PQI configuration table\n");
 		return -ENOMEM;
 	}
 
@@ -5851,7 +5844,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	rc = pqi_alloc_admin_queues(ctrl_info);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"error allocating admin queues\n");
+			"failed to allocate admin queues\n");
 		return rc;
 	}
 
@@ -5890,8 +5883,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 		return rc;
 
 	rc = pqi_alloc_operational_queues(ctrl_info);
-	if (rc)
+	if (rc) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"failed to allocate operational queues\n");
 		return rc;
+	}
 
 	pqi_init_operational_queues(ctrl_info);
 
@@ -6031,7 +6027,7 @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
 	rc = pqi_enable_events(ctrl_info);
 	if (rc) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"error configuring events\n");
+			"error enabling events\n");
 		return rc;
 	}
 
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 7a8c0a6..e5a5d50 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -104,7 +104,8 @@ static int sis_wait_for_ctrl_ready_with_timeout(struct pqi_ctrl_info *ctrl_info,
 		}
 		if (time_after(jiffies, timeout)) {
 			dev_err(&ctrl_info->pci_dev->dev,
-				"controller not ready\n");
+				"controller not ready after %u seconds\n",
+				timeout_secs);
 			return -ETIMEDOUT;
 		}
 		msleep(SIS_CTRL_READY_POLL_INTERVAL_MSECS);
