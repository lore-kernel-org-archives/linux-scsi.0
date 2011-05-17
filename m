From: Ankit Jain <jankit@suse.de>
Subject: [PATCH] aacraid: Add module param to export disks as 'fixed' instead
 of 'removable'
Date: Wed, 18 May 2011 01:05:29 +0530
Message-ID: <4DD2CE01.9090403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1EQTeG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 15:34:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, aacraid@adaptec.com
Cc: Hannes Reinecke <hare@suse.de>

aacraid: Add 'aac_export_fixed' module param to export disks as
'fixed' instead of 'removable'.

Adaptec controllers set the removable flag on devices to
allow for reconfiguration. The fear is that _not_ setting this
flag would inhibit the OS from detecting any device reconfiguration.

This manifested itself in a bug where Paravirtualized NetWare
was not able to boot with more than one PHY disk attached to a Xen
VM. NetWare sees two removable disks (and not CD-ROM), which is
an unsupported configuration. Details can be found at -
https://bugzilla.novell.com/show_bug.cgi?id=667226 .

The module parameter allows overriding that flag.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 7e26ebc..7f1b3e7 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -224,6 +224,11 @@ MODULE_PARM_DESC(wwn, "Select a WWN type for the arrays:\n"
 	"\t1 - Array Meta Data Signature (default)\n"
 	"\t2 - Adapter Serial Number");
 
+int aac_export_fixed;
+module_param_named(export_fixed, aac_export_fixed, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(export_fixed, "Export disks as 'fixed' instead of"
+		 " removable.");
+
 
 static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 		struct fib *fibptr) {
@@ -2212,8 +2217,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			scsi_set_resid(scsicmd,
 				       scsi_bufflen(scsicmd) - alloc_len);
 
-		/* Do not cache partition table for arrays */
-		scsicmd->device->removable = 1;
+		if (!aac_export_fixed)
+			/* Do not cache partition table for arrays */
+			scsicmd->device->removable = 1;
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
@@ -2241,8 +2247,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		cp[6] = 2;
 		cp[7] = 0;
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
-		/* Do not cache partition table for arrays */
-		scsicmd->device->removable = 1;
+		if (!aac_export_fixed)
+			/* Do not cache partition table for arrays */
+			scsicmd->device->removable = 1;
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
 		  SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 929cf67..a68c973 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1913,3 +1913,4 @@ extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
 extern int aac_check_reset;
+extern int aac_export_fixed;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index e9373a2..a5a4f81 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -408,7 +408,7 @@ static int aac_biosparm(struct scsi_device *sdev, struct block_device *bdev,
 static int aac_slave_configure(struct scsi_device *sdev)
 {
 	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
-	if (aac->jbod && (sdev->type == TYPE_DISK))
+	if (!aac_export_fixed && aac->jbod && (sdev->type == TYPE_DISK))
 		sdev->removable = 1;
 	if ((sdev->type == TYPE_DISK) &&
 			(sdev_channel(sdev) != CONTAINER_CHANNEL) &&
