From: Brian King <brking@us.ibm.com>
Subject: [PATCH 4/4] libata: Check per device max cdb length for SAS
Date: Wed, 28 Jun 2006 08:30:52 -0500
Message-ID: <200606281330.k5SDUrOv021506@d03av04.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Since libata does not own any scsi_host struct for
SAS attached SATA devices, libata cannot rely on scsi
core checking the max_cmd_len. This patch adds additional
checking into the SAS queuecommand path to prevent
too large of a cdb from being issued to an ATA or ATAPI device.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-scsi.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/libata-scsi.c~libata_sas_cdb_len drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_sas_cdb_len	2006-06-27 14:43:35.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-06-27 14:43:35.000000000 -0500
@@ -3207,9 +3207,13 @@ int ata_sas_queuecmd(struct scsi_cmnd *c
 {
 	ata_scsi_dump_cdb(ap, cmd);
 
-	if (likely(ata_scsi_dev_enabled(ap->device)))
-		__ata_scsi_queuecmd(cmd, done, ap->device);
-	else {
+	if (likely(ata_scsi_dev_enabled(ap->device))) {
+		if (unlikely(cmd->cmd_len > ap->device->cdb_len)) {
+			cmd->result = (DID_ABORT << 16);
+			done(cmd);
+		} else
+			__ata_scsi_queuecmd(cmd, done, ap->device);
+	} else {
 		cmd->result = (DID_BAD_TARGET << 16);
 		done(cmd);
 	}
_
