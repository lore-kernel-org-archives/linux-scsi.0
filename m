From: Brian King <brking@us.ibm.com>
Subject: [PATCH 06/15] libata: Stop using host->max_cmd_len
Date: Fri, 17 Mar 2006 17:04:34 -0600
Message-ID: <200603172304.k2HN4YEF019986@d03av01.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


In preparation for SAS attached SATA devices, quit using
the max_cmd_len in the scsi_host struct.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |   10 ++--------
 libata-dev-bjking1/drivers/scsi/libata-scsi.c |    6 ++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/libata-core.c~libata_cdb_len drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_cdb_len	2006-03-17 15:35:35.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-17 15:35:35.000000000 -0600
@@ -1189,7 +1189,7 @@ static int ata_dev_configure(struct ata_
 {
 	const u16 *id = dev->id;
 	unsigned int xfer_mask;
-	int i, rc;
+	int rc;
 
 	if (!ata_dev_present(dev)) {
 		DPRINTK("ENTER/EXIT (host %u, dev %u) -- nodev\n",
@@ -1299,12 +1299,6 @@ static int ata_dev_configure(struct ata_
 			       ap->id, dev->devno, ata_mode_string(xfer_mask));
 	}
 
-	ap->host->max_cmd_len = 0;
-	for (i = 0; i < ATA_MAX_DEVICES; i++)
-		ap->host->max_cmd_len = max_t(unsigned int,
-					      ap->host->max_cmd_len,
-					      ap->device[i].cdb_len);
-
 	/* limit bridge transfers to udma5, 200 sectors */
 	if (ata_dev_knobble(ap, dev)) {
 		if (print_info)
@@ -4595,7 +4589,7 @@ static void ata_host_init(struct ata_por
 	host->max_lun = 1;
 	host->max_channel = 1;
 	host->unique_id = ata_unique_id++;
-	host->max_cmd_len = 12;
+	host->max_cmd_len = ATAPI_CDB_LEN;
 
 	ap->flags = ATA_FLAG_PORT_DISABLED;
 	ap->id = host->unique_id;
diff -puN drivers/scsi/libata-scsi.c~libata_cdb_len drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_cdb_len	2006-03-17 15:35:35.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-03-17 15:35:35.000000000 -0600
@@ -2578,6 +2578,12 @@ static inline void ata_scsi_dump_cdb(str
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
