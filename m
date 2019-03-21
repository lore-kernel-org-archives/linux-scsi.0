From: Erwan Velu <erwanaliasr1@gmail.com>
Subject: [PATCH] scsi: smartpqi: Reporting unhandled SCSI errors
Date: Thu, 21 Mar 2019 10:49:27 +0100
Message-ID: <20190321094928.4198-1-e.velu@criteo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Erwan Velu <e.velu@criteo.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI
        DRIVER smartpqi" <esc.storagedev@microsemi.com>, "open list:MICROSEMI SMART ARRAY SMARTPQI
        DRIVER smartpqi" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When a HARDWARE_ERROR is triggered for asc=0x3e, the actual code is only considering the case where ascq=0x1.

Following the http://www.t10.org/lists/asc-num.htm#ASC_3E specification, other values may occur like a timeout (ascq=0x2).

This patch is about printing an error message when a non-handled message is received.
This could help diagnose a possible miss-behavior of the controller and/or a missing implementation in the Linux Kernel.

This patch keeps the exact same error handling but prints a message if an ascq != 1 income.

Signed-off-by: Erwan Velu <e.velu@criteo.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 75ec43aa8df3..baf16c138800 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2762,16 +2762,25 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 			scsi_normalize_sense(error_info->data,
 				sense_data_length, &sshdr) &&
 				sshdr.sense_key == HARDWARE_ERROR &&
-				sshdr.asc == 0x3e &&
-				sshdr.ascq == 0x1) {
+				sshdr.asc == 0x3e) {
 			struct pqi_ctrl_info *ctrl_info = shost_to_hba(scmd->device->host);
 			struct pqi_scsi_dev *device = scmd->device->hostdata;
 
-			if (printk_ratelimit())
-				scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
-					ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
-			pqi_take_device_offline(scmd->device, "RAID");
-			host_byte = DID_NO_CONNECT;
+			switch (sshdr.ascq) {
+			case 0x1: /*LOGICAL UNIT FAILURE */
+				if (printk_ratelimit())
+					scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
+						ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+				pqi_take_device_offline(scmd->device, "RAID");
+				host_byte = DID_NO_CONNECT;
+				break;
+
+			default: /* See http://www.t10.org/lists/asc-num.htm#ASC_3E */
+				if (printk_ratelimit())
+					scmd_printk(KERN_ERR, scmd, "received unhandled error %d from controller for scsi %d:%d:%d:%d\n",
+						sshdr.ascq, ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+				break;
+			}
 		}
 
 		if (sense_data_length > SCSI_SENSE_BUFFERSIZE)
-- 
2.20.1
