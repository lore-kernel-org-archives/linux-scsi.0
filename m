From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/47] pmcraid: Select device in pmcraid_eh_bus_reset_handler()
Date: Wed, 28 Jun 2017 10:32:45 +0200
Message-ID: <1498638793-44672-20-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53825 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751613AbdF1IdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:21 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The reset code requires a device to be selected, but we shouldn't
rely on the command to provide a device for us. So select the first
device on the bus when sending down a bus reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/pmcraid.c | 46 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4b66b92..9f0517d 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -2733,7 +2733,7 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
  *	SUCCESS / FAILED
  */
 static int pmcraid_reset_device(
-	struct scsi_cmnd *scsi_cmd,
+	struct scsi_device *scsi_dev,
 	unsigned long timeout,
 	u8 modifier
 )
@@ -2746,11 +2746,11 @@ static int pmcraid_reset_device(
 	u32 ioasc;
 
 	pinstance =
-		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
-	res = scsi_cmd->device->hostdata;
+		(struct pmcraid_instance *)scsi_dev->host->hostdata;
+	res = scsi_dev->hostdata;
 
 	if (!res) {
-		sdev_printk(KERN_ERR, scsi_cmd->device,
+		sdev_printk(KERN_ERR, scsi_dev,
 			    "reset_device: NULL resource pointer\n");
 		return FAILED;
 	}
@@ -3063,16 +3063,46 @@ static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 {
 	scmd_printk(KERN_INFO, scmd,
 		    "resetting device due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd,
+	return pmcraid_reset_device(scmd->device,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_LUN);
 }
 
 static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 {
-	scmd_printk(KERN_INFO, scmd,
+	struct Scsi_Host *host = scmd->device->host;
+	struct pmcraid_instance *pinstance =
+		(struct pmcraid_instance *)host->hostdata;
+	struct pmcraid_resource_entry *res = NULL;
+	struct pmcraid_resource_entry *temp;
+	struct scsi_device *sdev = NULL;
+	unsigned long lock_flags;
+
+	/*
+	 * The reset device code insists on us passing down
+	 * a device, so grab the first device on the bus.
+	 */
+	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
+	list_for_each_entry(temp, &pinstance->used_res_q, queue) {
+		if (scmd->device->channel == PMCRAID_VSET_BUS_ID &&
+		    RES_IS_VSET(temp->cfg_entry)) {
+			res = temp;
+			break;
+		} else if (scmd->device->channel == PMCRAID_PHYS_BUS_ID &&
+			   RES_IS_GSCSI(temp->cfg_entry)) {
+			res = temp;
+			break;
+		}
+	}
+	if (res)
+		sdev = res->scsi_dev;
+	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
+	if (!sdev)
+		return FAILED;
+
+	sdev_printk(KERN_INFO, sdev,
 		    "Doing bus reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd,
+	return pmcraid_reset_device(sdev,
 				    PMCRAID_RESET_BUS_TIMEOUT,
 				    RESET_DEVICE_BUS);
 }
@@ -3081,7 +3111,7 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 {
 	scmd_printk(KERN_INFO, scmd,
 		    "Doing target reset due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd,
+	return pmcraid_reset_device(scmd->device,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_TARGET);
 }
-- 
1.8.5.6
