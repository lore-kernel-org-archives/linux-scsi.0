From: Brian King <brking@us.ibm.com>
Subject: [PATCH 06/16] libata: Stop using host->max_cmd_len
Date: Fri, 17 Feb 2006 16:20:19 -0600
Message-ID: <200602172220.k1HMKJpS015740@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:17300 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751830AbWBQWUU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 17:20:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com


In preparation for SAS attached SATA devices, quit using
the max_cmd_len in the scsi_host struct.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   10 ++--------
 libata-dev-bjking1/drivers/scsi/libata-scsi.c |    6 ++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_cdb_len drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_cdb_len	2006-02-17 15:53:43.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-17 16:04:36.000000000 -0600
@@ -931,7 +931,7 @@ static void ata_dev_identify(struct ata_
 	unsigned int using_edd;
 	struct ata_taskfile tf;
 	unsigned int err_mask;
-	int i, rc;
+	int rc;
 
 	if (!ata_dev_present(dev)) {
 		DPRINTK("ENTER/EXIT (host %u, dev %u) -- nodev\n",
@@ -1108,12 +1108,6 @@ retry:
 		       ata_mode_string(xfer_modes));
 	}
 
-	ap->host->max_cmd_len = 0;
-	for (i = 0; i < ATA_MAX_DEVICES; i++)
-		ap->host->max_cmd_len = max_t(unsigned int,
-					      ap->host->max_cmd_len,
-					      ap->device[i].cdb_len);
-
 	DPRINTK("EXIT, drv_stat = 0x%x\n", ata_chk_status(ap));
 	return;
 
@@ -4442,7 +4436,7 @@ static void ata_host_init(struct ata_por
 	host->max_lun = 1;
 	host->max_channel = 1;
 	host->unique_id = ata_unique_id++;
-	host->max_cmd_len = 12;
+	host->max_cmd_len = ATAPI_CDB_LEN;
 
 	ap->flags = ATA_FLAG_PORT_DISABLED;
 	ap->id = host->unique_id;
diff -puN drivers/scsi/libata-scsi.c~libata_cdb_len drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_cdb_len	2006-02-17 15:53:43.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-02-17 16:04:48.000000000 -0600
@@ -2574,6 +2574,12 @@ static inline void ata_scsi_dump_cdb(str
 static void __ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
 				struct ata_port *ap, struct ata_device *dev)
 {
+	if (unlikely(cmd->cmd_len > dev->cdb_len)) {
+		cmd->result = (DID_ABORT << 16);
+		done(cmd);
+		return;
+	}
+
 	if (dev->class == ATA_DEV_ATA) {
 		ata_xlat_func_t xlat_func = ata_get_xlat_func(dev,
 							      cmd->cmnd[0]);
_
