From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Drop legacy struct se_subsystem_api->get_dev_info() caller
Date: Mon,  8 Nov 2010 22:53:04 -0800
Message-ID: <1289285584-28185-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.105]:20633 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751204Ab0KIGxI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 01:53:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Joel Becker <Joel.Becker@oracle.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch drops the last of the v2.x IOCTL inspired informational code
for backend plugins that has long since gone the way of /dev/null in practice,
but contines to live on in a currently PAGE_SIZE limited existence in:

	 /sys/kernel/config/target/core/$HBA/$DEV/info

This patch follow hch's recommendation to fix up the backend code for the
struct se_subsystem_api->show_configfs_dev_params() caller and drops all legacy
*_get_dev_info() cruft.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reported-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c      |   33 ++++----------
 drivers/target/target_core_iblock.c    |   44 ++++++------------
 drivers/target/target_core_pscsi.c     |   55 +++++++++---------------
 drivers/target/target_core_rd.c        |   36 +++------------
 drivers/target/target_core_stgt.c      |   74 +++----------------------------
 drivers/target/target_core_transport.c |   58 -------------------------
 include/target/target_core_transport.h |    4 --
 7 files changed, 60 insertions(+), 244 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 34ab402..f9bcaa7 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -56,8 +56,6 @@
 
 static struct se_subsystem_api fileio_template;
 
-static void __fd_get_dev_info(struct fd_dev *, char *, int *);
-
 /*	fd_attach_hba(): (Part of se_subsystem_api_t template)
  *
  *
@@ -735,18 +733,6 @@ static ssize_t fd_check_configfs_dev_params(struct se_hba *hba, struct se_subsys
 	return 0;
 }
 
-static ssize_t fd_show_configfs_dev_params(
-	struct se_hba *hba,
-	struct se_subsystem_dev *se_dev,
-	char *page)
-{
-	struct fd_dev *fd_dev = (struct fd_dev *) se_dev->se_dev_su_ptr;
-	int bl = 0;
-
-	__fd_get_dev_info(fd_dev, page, &bl);
-	return (ssize_t)bl;
-}
-
 static void fd_get_plugin_info(void *p, char *b, int *bl)
 {
 	*bl += sprintf(b + *bl, "TCM FILEIO Plugin %s\n", FD_VERSION);
@@ -761,20 +747,20 @@ static void fd_get_hba_info(struct se_hba *hba, char *b, int *bl)
 	*bl += sprintf(b + *bl, "        TCM FILEIO HBA\n");
 }
 
-static void fd_get_dev_info(struct se_device *dev, char *b, int *bl)
+static ssize_t fd_show_configfs_dev_params(
+	struct se_hba *hba,
+	struct se_subsystem_dev *se_dev,
+	char *b)
 {
-	struct fd_dev *fd_dev = dev->dev_ptr;
-
-	__fd_get_dev_info(fd_dev, b, bl);
-}
+	struct fd_dev *fd_dev = se_dev->se_dev_su_ptr;
+	ssize_t bl = 0;
 
-static void __fd_get_dev_info(struct fd_dev *fd_dev, char *b, int *bl)
-{
-	*bl += sprintf(b + *bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	*bl += sprintf(b + *bl, "        File: %s  Size: %llu  Mode: %s\n",
+	bl = sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
+	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
 		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
 		(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) ?
 		"Buffered" : "Synchronous");
+	return bl;
 }
 
 /*	fd_map_task_non_SG():
@@ -972,7 +958,6 @@ static struct se_subsystem_api fileio_template = {
 	.show_configfs_dev_params = fd_show_configfs_dev_params,
 	.get_plugin_info	= fd_get_plugin_info,
 	.get_hba_info		= fd_get_hba_info,
-	.get_dev_info		= fd_get_dev_info,
 	.check_lba		= fd_check_lba,
 	.check_for_SG		= fd_check_for_SG,
 	.get_cdb		= fd_get_cdb,
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 890db59..93d8c62 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -55,7 +55,6 @@
 
 static struct se_subsystem_api iblock_template;
 
-static void __iblock_get_dev_info(struct iblock_dev *, char *, int *);
 static void iblock_bio_done(struct bio *, int);
 
 /*	iblock_attach_hba(): (Part of se_subsystem_api_t template)
@@ -590,18 +589,6 @@ static ssize_t iblock_check_configfs_dev_params(
 	return 0;
 }
 
-static ssize_t iblock_show_configfs_dev_params(
-	struct se_hba *hba,
-	struct se_subsystem_dev *se_dev,
-	char *page)
-{
-	struct iblock_dev *ibd = se_dev->se_dev_su_ptr;
-	int bl = 0;
-
-	__iblock_get_dev_info(ibd, page, &bl);
-	return (ssize_t)bl;
-}
-
 static void iblock_get_plugin_info(void *p, char *b, int *bl)
 {
 	*bl += sprintf(b + *bl, "TCM iBlock Plugin %s\n", IBLOCK_VERSION);
@@ -616,37 +603,37 @@ static void iblock_get_hba_info(struct se_hba *hba, char *b, int *bl)
 	*bl += sprintf(b + *bl, "        TCM iBlock HBA\n");
 }
 
-static void iblock_get_dev_info(struct se_device *dev, char *b, int *bl)
-{
-	struct iblock_dev *ibd = dev->dev_ptr;
-
-	__iblock_get_dev_info(ibd, b, bl);
-}
-
-static void __iblock_get_dev_info(struct iblock_dev *ibd, char *b, int *bl)
+static ssize_t iblock_show_configfs_dev_params(
+	struct se_hba *hba,
+	struct se_subsystem_dev *se_dev,
+	char *b)
 {
-	char buf[BDEVNAME_SIZE];
+	struct iblock_dev *ibd = se_dev->se_dev_su_ptr;
 	struct block_device *bd = ibd->ibd_bd;
+	char buf[BDEVNAME_SIZE];
+	ssize_t bl = 0;
 
 	if (bd)
-		*bl += sprintf(b + *bl, "iBlock device: %s",
+		bl += sprintf(b + bl, "iBlock device: %s",
 				bdevname(bd, buf));
 	if (ibd->ibd_flags & IBDF_HAS_UDEV_PATH) {
-		*bl += sprintf(b + *bl, "  UDEV PATH: %s\n",
+		bl += sprintf(b + bl, "  UDEV PATH: %s\n",
 				ibd->ibd_udev_path);
 	} else
-		*bl += sprintf(b + *bl, "\n");
+		bl += sprintf(b + bl, "\n");
 
-	*bl += sprintf(b + *bl, "        ");
+	bl += sprintf(b + bl, "        ");
 	if (bd) {
-		*bl += sprintf(b + *bl, "Major: %d Minor: %d  %s\n",
+		bl += sprintf(b + bl, "Major: %d Minor: %d  %s\n",
 			ibd->ibd_major, ibd->ibd_minor, (!bd->bd_contains) ?
 			"" : (bd->bd_holder == (struct iblock_dev *)ibd) ?
 			"CLAIMED: IBLOCK" : "CLAIMED: OS");
 	} else {
-		*bl += sprintf(b + *bl, "Major: %d Minor: %d\n",
+		bl += sprintf(b + bl, "Major: %d Minor: %d\n",
 			ibd->ibd_major, ibd->ibd_minor);
 	}
+
+	return bl;
 }
 
 static void iblock_bio_destructor(struct bio *bio)
@@ -923,7 +910,6 @@ static struct se_subsystem_api iblock_template = {
 	.show_configfs_dev_params = iblock_show_configfs_dev_params,
 	.get_plugin_info	= iblock_get_plugin_info,
 	.get_hba_info		= iblock_get_hba_info,
-	.get_dev_info		= iblock_get_dev_info,
 	.check_lba		= iblock_check_lba,
 	.check_for_SG		= iblock_check_for_SG,
 	.get_cdb		= iblock_get_cdb,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 7387350..6a2db0b 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -54,7 +54,6 @@
 static struct se_subsystem_api pscsi_template;
 
 static void pscsi_req_done(struct request *, int);
-static void __pscsi_get_dev_info(struct pscsi_dev_virt *, char *, int *);
 
 /*	pscsi_get_sh():
  *
@@ -934,18 +933,6 @@ static ssize_t pscsi_check_configfs_dev_params(
 	return 0;
 }
 
-static ssize_t pscsi_show_configfs_dev_params(
-	struct se_hba *hba,
-	struct se_subsystem_dev *se_dev,
-	char *page)
-{
-	struct pscsi_dev_virt *pdv = se_dev->se_dev_su_ptr;
-	int bl = 0;
-
-	__pscsi_get_dev_info(pdv, page, &bl);
-	return (ssize_t)bl;
-}
-
 static void pscsi_get_plugin_info(void *p, char *b, int *bl)
 {
 	*bl += sprintf(b + *bl, "TCM SCSI Plugin %s\n", PSCSI_VERSION);
@@ -964,18 +951,16 @@ static void pscsi_get_hba_info(struct se_hba *hba, char *b, int *bl)
 			(sh->hostt->name) : "Unknown");
 }
 
-static void pscsi_get_dev_info(struct se_device *dev, char *b, int *bl)
-{
-	struct pscsi_dev_virt *pdv = dev->dev_ptr;
-
-	__pscsi_get_dev_info(pdv, b, bl);
-}
-
-static void __pscsi_get_dev_info(struct pscsi_dev_virt *pdv, char *b, int *bl)
+static ssize_t pscsi_show_configfs_dev_params(
+        struct se_hba *hba,
+        struct se_subsystem_dev *se_dev,
+        char *b)
 {
-	struct pscsi_hba_virt *phv = pdv->pdv_se_hba->hba_ptr;
+	struct pscsi_hba_virt *phv = hba->hba_ptr;
+        struct pscsi_dev_virt *pdv = se_dev->se_dev_su_ptr;
 	struct scsi_device *sd = pdv->pdv_sd;
 	unsigned char host_id[16];
+	ssize_t bl;
 	int i;
 
 	if (phv->phv_mode == PHV_VIRUTAL_HOST_ID)
@@ -983,36 +968,37 @@ static void __pscsi_get_dev_info(struct pscsi_dev_virt *pdv, char *b, int *bl)
 	else
 		snprintf(host_id, 16, "PHBA Mode");
 
-	*bl += sprintf(b + *bl, "SCSI Device Bus Location:"
+	bl = sprintf(b, "SCSI Device Bus Location:"
 		" Channel ID: %d Target ID: %d LUN: %d Host ID: %s\n",
 		pdv->pdv_channel_id, pdv->pdv_target_id, pdv->pdv_lun_id,
 		host_id);
 
 	if (sd) {
-		*bl += sprintf(b + *bl, "        ");
-		*bl += sprintf(b + *bl, "Vendor: ");
+		bl += sprintf(b + bl, "        ");
+		bl += sprintf(b + bl, "Vendor: ");
 		for (i = 0; i < 8; i++) {
 			if (ISPRINT(sd->vendor[i]))   /* printable character? */
-				*bl += sprintf(b + *bl, "%c", sd->vendor[i]);
+				bl += sprintf(b + bl, "%c", sd->vendor[i]);
 			else
-				*bl += sprintf(b + *bl, " ");
+				bl += sprintf(b + bl, " ");
 		}
-		*bl += sprintf(b + *bl, " Model: ");
+		bl += sprintf(b + bl, " Model: ");
 		for (i = 0; i < 16; i++) {
 			if (ISPRINT(sd->model[i]))   /* printable character ? */
-				*bl += sprintf(b + *bl, "%c", sd->model[i]);
+				bl += sprintf(b + bl, "%c", sd->model[i]);
 			else
-				*bl += sprintf(b + *bl, " ");
+				bl += sprintf(b + bl, " ");
 		}
-		*bl += sprintf(b + *bl, " Rev: ");
+		bl += sprintf(b + bl, " Rev: ");
 		for (i = 0; i < 4; i++) {
 			if (ISPRINT(sd->rev[i]))   /* printable character ? */
-				*bl += sprintf(b + *bl, "%c", sd->rev[i]);
+				bl += sprintf(b + bl, "%c", sd->rev[i]);
 			else
-				*bl += sprintf(b + *bl, " ");
+				bl += sprintf(b + bl, " ");
 		}
-		*bl += sprintf(b + *bl, "\n");
+		bl += sprintf(b + bl, "\n");
 	}
+	return bl;
 }
 
 static void pscsi_bi_endio(struct bio *bio, int error)
@@ -1468,7 +1454,6 @@ static struct se_subsystem_api pscsi_template = {
 	.show_configfs_dev_params = pscsi_show_configfs_dev_params,
 	.get_plugin_info	= pscsi_get_plugin_info,
 	.get_hba_info		= pscsi_get_hba_info,
-	.get_dev_info		= pscsi_get_dev_info,
 	.check_lba		= pscsi_check_lba,
 	.check_for_SG		= pscsi_check_for_SG,
 	.get_cdb		= pscsi_get_cdb,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 226c8ca..9740e32 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -47,8 +47,6 @@
 static struct se_subsystem_api rd_dr_template;
 static struct se_subsystem_api rd_mcp_template;
 
-static void __rd_get_dev_info(struct rd_dev *, char *, int *);
-
 /* #define DEBUG_RAMDISK_MCP */
 /* #define DEBUG_RAMDISK_DR */
 
@@ -1057,18 +1055,6 @@ static ssize_t rd_check_configfs_dev_params(struct se_hba *hba, struct se_subsys
 	return 0;
 }
 
-static ssize_t rd_show_configfs_dev_params(
-	struct se_hba *hba,
-	struct se_subsystem_dev *se_dev,
-	char *page)
-{
-	struct rd_dev *rd_dev = se_dev->se_dev_su_ptr;
-	int bl = 0;
-
-	 __rd_get_dev_info(rd_dev, page, &bl);
-	return (ssize_t)bl;
-}
-
 static void rd_dr_get_plugin_info(void *p, char *b, int *bl)
 {
 	*bl += sprintf(b + *bl, "TCM RAMDISK_DR Plugin %s\n", RD_DR_VERSION);
@@ -1088,23 +1074,19 @@ static void rd_get_hba_info(struct se_hba *hba, char *b, int *bl)
 	*bl += sprintf(b + *bl, "        TCM RamDisk HBA\n");
 }
 
-static void rd_get_dev_info(struct se_device *dev, char *b, int *bl)
-{
-	struct rd_dev *rd_dev = dev->dev_ptr;
-
-	__rd_get_dev_info(rd_dev, b, bl);
-}
-
-static void __rd_get_dev_info(struct rd_dev *rd_dev, char *b, int *bl)
+static ssize_t rd_show_configfs_dev_params(
+	struct se_hba *hba,
+	struct se_subsystem_dev *se_dev,
+	char *b)
 {
-	*bl += sprintf(b + *bl, "TCM RamDisk ID: %u  RamDisk Makeup: %s\n",
+	struct rd_dev *rd_dev = se_dev->se_dev_su_ptr;
+	ssize_t bl = sprintf(b, "TCM RamDisk ID: %u  RamDisk Makeup: %s\n",
 			rd_dev->rd_dev_id, (rd_dev->rd_direct) ?
 			"rd_direct" : "rd_mcp");
-	*bl += sprintf(b + *bl, "        PAGES/PAGE_SIZE: %u*%lu"
+	bl += sprintf(b + bl, "        PAGES/PAGE_SIZE: %u*%lu"
 			"  SG_table_count: %u\n", rd_dev->rd_page_count,
 			PAGE_SIZE, rd_dev->sg_table_count);
-
-	return;
+	return bl;
 }
 
 /*	rd_map_task_non_SG():
@@ -1300,7 +1282,6 @@ static struct se_subsystem_api rd_dr_template = {
 	.show_configfs_dev_params = rd_show_configfs_dev_params,
 	.get_plugin_info	= rd_dr_get_plugin_info,
 	.get_hba_info		= rd_get_hba_info,
-	.get_dev_info		= rd_get_dev_info,
 	.check_lba		= rd_DIRECT_check_lba,
 	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
@@ -1334,7 +1315,6 @@ static struct se_subsystem_api rd_mcp_template = {
 	.show_configfs_dev_params = rd_show_configfs_dev_params,
 	.get_plugin_info	= rd_mcp_get_plugin_info,
 	.get_hba_info		= rd_get_hba_info,
-	.get_dev_info		= rd_get_dev_info,
 	.check_lba		= rd_MEMCPY_check_lba,
 	.check_for_SG		= rd_check_for_SG,
 	.get_cdb		= rd_get_cdb,
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index c662939..3b78333 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -54,7 +54,6 @@
 static int stgt_host_no_cnt;
 static struct se_subsystem_api stgt_template ;
 
-static void __stgt_get_dev_info(struct stgt_dev_virt *, char *, int *);
 static int stgt_transfer_response(struct scsi_cmnd *,
                            void (*done)(struct scsi_cmnd *));
 
@@ -522,18 +521,6 @@ static ssize_t stgt_check_configfs_dev_params(
 	return 0;
 }
 
-static ssize_t stgt_show_configfs_dev_params(
-	struct se_hba *hba,
-	struct se_subsystem_dev *se_dev,
-	char *page)
-{
-	struct stgt_dev_virt *sdv = se_dev->se_dev_su_ptr;
-	int bl = 0;
-
-	__stgt_get_dev_info(sdv, page, &bl);
-	return (ssize_t)bl;
-}
-
 static void stgt_get_plugin_info(void *p, char *b, int *bl)
 {
 	*bl += sprintf(b + *bl, "TCM STGT <-> Target_Core_Mod Plugin %s\n",
@@ -550,63 +537,19 @@ static void stgt_get_hba_info(struct se_hba *hba, char *b, int *bl)
 		(sh->hostt->name) ? (sh->hostt->name) : "Unknown");
 }
 
-static void stgt_get_dev_info(struct se_device *dev, char *b, int *bl)
-{
-	struct stgt_dev_virt *sdv = dev->dev_ptr;
-
-	__stgt_get_dev_info(sdv, b, bl);
-}
-
-static void __stgt_get_dev_info(struct stgt_dev_virt *sdv, char *b, int *bl)
+static ssize_t stgt_show_configfs_dev_params(
+	struct se_hba *hba,
+	struct se_subsystem_dev *se_dev,
+	char *b)
 {
-	int i;
-	struct scsi_device *sd = sdv->sdv_sd;
+	struct stgt_dev_virt *sdv = se_dev->se_dev_su_ptr;
+	ssize_t bl = 0;
 
-	*bl += sprintf(b + *bl, "STGT SCSI Device Bus Location:"
+	bl = sprintf(b + bl, "STGT SCSI Device Bus Location:"
 		" Channel ID: %d Target ID: %d LUN: %d\n",
 		sdv->sdv_channel_id, sdv->sdv_target_id, sdv->sdv_lun_id);
 
-	if (sd) {
-		*bl += sprintf(b + *bl, "        ");
-		*bl += sprintf(b + *bl, "Vendor: ");
-		for (i = 0; i < 8; i++) {
-			if (ISPRINT(sd->vendor[i]))   /* printable character? */
-				*bl += sprintf(b + *bl, "%c", sd->vendor[i]);
-			else
-				*bl += sprintf(b + *bl, " ");
-		}
-		*bl += sprintf(b + *bl, " Model: ");
-		for (i = 0; i < 16; i++) {
-			if (ISPRINT(sd->model[i]))   /* printable character ? */
-				*bl += sprintf(b + *bl, "%c", sd->model[i]);
-			else
-				*bl += sprintf(b + *bl, " ");
-		}
-		*bl += sprintf(b + *bl, " Rev: ");
-		for (i = 0; i < 4; i++) {
-			if (ISPRINT(sd->rev[i]))   /* printable character ? */
-				*bl += sprintf(b + *bl, "%c", sd->rev[i]);
-			else
-				*bl += sprintf(b + *bl, " ");
-		}
-
-		if (sd->type == TYPE_DISK) {
-			struct scsi_disk *sdisk =
-					dev_get_drvdata(&sd->sdev_gendev);
-			struct gendisk *disk = (struct gendisk *) sdisk->disk;
-			struct block_device *bdev = bdget(MKDEV(disk->major,
-						disk->first_minor));
-
-			bdev->bd_disk = disk;
-			*bl += sprintf(b + *bl, "   %s\n", (!bdev->bd_holder) ?
-					"" : (bdev->bd_holder ==
-					(struct scsi_device *)sd) ?
-					"CLAIMED: PSCSI" : "CLAIMED: OS");
-		} else
-			*bl += sprintf(b + *bl, "\n");
-	}
-
-	return;
+	return bl;
 }
 
 /*      stgt_map_task_SG():
@@ -857,7 +800,6 @@ static struct se_subsystem_api stgt_template = {
 	.plugin_free		= stgt_plugin_free,
 	.get_plugin_info	= stgt_get_plugin_info,
 	.get_hba_info		= stgt_get_hba_info,
-	.get_dev_info		= stgt_get_dev_info,
 	.check_lba		= stgt_check_lba,
 	.check_for_SG		= stgt_check_for_SG,
 	.get_cdb		= stgt_get_cdb,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 150c0f8..43c15f9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1560,64 +1560,6 @@ void transport_dump_dev_state(
 	*bl += sprintf(b + *bl, "        ");
 }
 
-void transport_dump_dev_info(
-	struct se_device *dev,
-	struct se_lun *lun,
-	unsigned long long total_bytes,
-	char *b,        /* Pointer to info buffer */
-	int *bl)
-{
-	struct se_hba *hba = dev->se_hba;
-	struct se_subsystem_api *t = hba->transport;
-
-	t->get_dev_info(dev, b, bl);
-	*bl += sprintf(b + *bl, "        ");
-	*bl += sprintf(b + *bl, "Type: %s ",
-		scsi_device_type(TRANSPORT(dev)->get_device_type(dev)));
-	*bl += sprintf(b + *bl, "ANSI SCSI revision: %02x  ",
-		TRANSPORT(dev)->get_device_rev(dev));
-
-	if (DEV_T10_WWN(dev)) {
-		struct t10_wwn *wwn = DEV_T10_WWN(dev);
-
-		*bl += sprintf(b + *bl, "Unit Serial: %s  ",
-			((strlen(wwn->unit_serial) != 0) ?
-			(char *)wwn->unit_serial : "None"));
-	}
-	*bl += sprintf(b + *bl, "%s", "DIRECT");
-
-	if (atomic_read(&dev->dev_access_obj.obj_access_count))
-		*bl += sprintf(b + *bl, "  ACCESSED\n");
-	else if (atomic_read(&dev->dev_export_obj.obj_access_count))
-		*bl += sprintf(b + *bl, "  EXPORTED\n");
-	else
-		*bl += sprintf(b + *bl, "  FREE\n");
-
-	if (lun) {
-		*bl += sprintf(b + *bl, "        Core Host ID: %u LUN: %u",
-			dev->se_hba->hba_id, lun->unpacked_lun);
-		if (!(TRANSPORT(dev)->get_device_type(dev))) {
-			*bl += sprintf(b + *bl, "  Active Cmds: %d  Total Bytes"
-				": %llu\n", atomic_read(&dev->active_cmds),
-			total_bytes);
-		} else {
-			*bl += sprintf(b + *bl, "  Active Cmds: %d\n",
-				atomic_read(&dev->active_cmds));
-		}
-	} else {
-		if (!(TRANSPORT(dev)->get_device_type(dev))) {
-			*bl += sprintf(b + *bl, "        Core Host ID: %u"
-				"  Active Cmds: %d  Total Bytes: %llu\n",
-				dev->se_hba->hba_id,
-				atomic_read(&dev->active_cmds), total_bytes);
-		} else {
-			*bl += sprintf(b + *bl, "        CoreI Host ID: %u"
-				"  Active Cmds: %d\n", dev->se_hba->hba_id,
-				atomic_read(&dev->active_cmds));
-		}
-	}
-}
-
 /*	transport_release_all_cmds():
  *
  *
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index a2e6ef9..dbf4f59 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -475,10 +475,6 @@ struct se_subsystem_api {
 	 */
 	void (*get_hba_info)(struct se_hba *, char *, int *);
 	/*
-	 * get_dev_info():
-	 */
-	void (*get_dev_info)(struct se_device *, char *, int *);
-	/*
 	 * check_lba():
 	 */
 	int (*check_lba)(unsigned long long lba, struct se_device *);
-- 
1.5.6.5

