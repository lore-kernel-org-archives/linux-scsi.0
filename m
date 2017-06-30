From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] aacraid: split off host reset
Date: Fri, 30 Jun 2017 19:18:07 +0200
Message-ID: <1498843092-76285-3-git-send-email-hare@suse.de>
References: <1498843092-76285-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59901 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751666AbdF3RTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 13:19:38 -0400
In-Reply-To: <1498843092-76285-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Split off the host reset parts of aac_eh_reset() into a separate
host reset function.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Raghava Aditya Renukunta  <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 9a8a27f..bf21006 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -874,10 +874,6 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	u32 bus, cid;
 	int ret = FAILED;
 	int status = 0;
-	__le32 supported_options2 = 0;
-	bool is_mu_reset;
-	bool is_ignore_reset;
-	bool is_doorbell_reset;
 
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
@@ -923,7 +919,7 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		}
 
 		if (ret == SUCCESS)
-			goto out;
+			return ret;
 
 	} else {
 
@@ -952,8 +948,24 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		dev_err(&aac->pdev->dev, "Adapter health - %d\n", status);
 
 	count = get_num_of_incomplete_fibs(aac);
-	if (count == 0)
-		return SUCCESS;
+	return (count == 0) ? SUCCESS : FAILED;
+}
+
+/*
+ *	aac_eh_host_reset	- Host reset command handling
+ *	@scsi_cmd:	SCSI command block causing the reset
+ *
+ */
+int aac_eh_host_reset(struct scsi_cmnd *cmd)
+{
+	struct scsi_device * dev = cmd->device;
+	struct Scsi_Host * host = dev->host;
+	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
+	int ret = FAILED;
+	__le32 supported_options2 = 0;
+	bool is_mu_reset;
+	bool is_ignore_reset;
+	bool is_doorbell_reset;
 
 	/*
 	 * Check if reset is supported by the firmware
@@ -972,10 +984,8 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	 && (aac_check_reset != -1 || !is_ignore_reset)) {
 		/* Bypass wait for command quiesce */
 		aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
+		ret = SUCCESS;
 	}
-	ret = SUCCESS;
-
-out:
 	return ret;
 }
 
@@ -1399,7 +1409,8 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_attrs			= aac_dev_attrs,
 	.eh_abort_handler		= aac_eh_abort,
-	.eh_host_reset_handler		= aac_eh_reset,
+	.eh_bus_reset_handler		= aac_eh_reset,
+	.eh_host_reset_handler		= aac_eh_host_reset,
 	.can_queue			= AAC_NUM_IO_FIB,
 	.this_id			= MAXIMUM_NUM_CONTAINERS,
 	.sg_tablesize			= 16,
-- 
1.8.5.6
