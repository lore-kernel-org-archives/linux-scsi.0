From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/2] scsi: Add scsi_device max_cmd_len
Date: Tue, 28 Mar 2006 16:17:18 -0600
Message-ID: <200603282217.k2SMHJTH032251@d03av04.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Add a max_cmd_len field to the scsi_device struct
to allow for per device limits of allowable command
lengths. This will be used by libata, which is currently
using the max_cmd_len field in the scsi_host struct,
which doesn't work for attaching libata controlled
SATA devices to SAS HBAs.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/scsi.c        |    3 ++-
 libata-dev-bjking1/drivers/scsi/scsi_scan.c   |    1 +
 libata-dev-bjking1/include/scsi/scsi_device.h |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/scsi/scsi_device.h~scsi_device_cdb_len include/scsi/scsi_device.h
--- libata-dev/include/scsi/scsi_device.h~scsi_device_cdb_len	2006-03-27 13:24:04.000000000 -0600
+++ libata-dev-bjking1/include/scsi/scsi_device.h	2006-03-27 13:24:48.000000000 -0600
@@ -72,6 +72,7 @@ struct scsi_device {
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */
+	unsigned char max_cmd_len;
 
 	void *hostdata;		/* available to low-level driver */
 	char type;
diff -puN drivers/scsi/scsi_scan.c~scsi_device_cdb_len drivers/scsi/scsi_scan.c
--- libata-dev/drivers/scsi/scsi_scan.c~scsi_device_cdb_len	2006-03-27 13:25:39.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/scsi_scan.c	2006-03-27 13:28:24.000000000 -0600
@@ -218,6 +218,7 @@ static struct scsi_device *scsi_alloc_sd
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
 	sdev->sdev_state = SDEV_CREATED;
+	sdev->max_cmd_len = MAX_COMMAND_SIZE;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
diff -puN drivers/scsi/scsi.c~scsi_device_cdb_len drivers/scsi/scsi.c
--- libata-dev/drivers/scsi/scsi.c~scsi_device_cdb_len	2006-03-27 13:29:23.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/scsi.c	2006-03-27 13:30:03.000000000 -0600
@@ -610,7 +610,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	 * Before we queue this command, check if the command
 	 * length exceeds what the host adapter can handle.
 	 */
-	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
+	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len ||
+	    CDB_SIZE(cmd) > cmd->device->max_cmd_len) {
 		SCSI_LOG_MLQUEUE(3,
 				printk("queuecommand : command too long.\n"));
 		cmd->result = (DID_ABORT << 16);
_
