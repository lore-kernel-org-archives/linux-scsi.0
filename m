From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/6] [Target_Core_Mod/FILEIO): Update for EVPD and remove
	legacy parameter code
Date: Fri, 23 Jan 2009 17:57:54 -0800
Message-ID: <1232762274.24642.18.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:28232 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754112AbZAXB6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 20:58:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 984076ed2e111136e882b9aed68b0cd86b7c30ef Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 23 Jan 2009 17:23:59 -0800
Subject: [PATCH 3/6] [Target_Core_Mod/FILEIO): Update for EVPD and remove legacy parameter code

This patch removes FILEIO specific usage of lvm_uuid= and md_uuid= parameters
from legacy v2.9 code.  Usage of this information including from 'lvs -v'
and 'mdadm -D /dev/mdX' can now be directly echoed into
/sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT/wwn/evpd_unit_serial

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c |   39 +---------------------------------
 drivers/lio-core/target_core_file.h |    8 +-----
 2 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 1a1034f..b7199d4 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -254,23 +254,6 @@ extern se_device_t *fd_create_virtdevice (
 		fd_dev->fd_major = di->iblock_major;
 		fd_dev->fd_minor = di->iblock_minor;
 		
-		if ((di->uu_id[0] != 0) && (di->uu_id[1] != 0) && (di->uu_id[2] != 0) &&
-		    (di->uu_id[3] != 0)) {
-			PYXPRINT("FILEIO: Referencing MD Universal Unit Identifier "
-				"<%x %x %x %x>\n", di->uu_id[0], di->uu_id[1], di->uu_id[2],
-					 di->uu_id[3]);
-			fd_dev->fbd_uu_id[0] = di->uu_id[0];
-			fd_dev->fbd_uu_id[1] = di->uu_id[1];
-			fd_dev->fbd_uu_id[2] = di->uu_id[2];
-			fd_dev->fbd_uu_id[3] = di->uu_id[3];
-			fd_dev->fbd_flags |= FBDF_HAS_MD_UUID;
-		} else if (strlen(di->lvm_uuid)) {
-			snprintf(fd_dev->fbd_lvm_uuid, SE_LVM_UUID_LEN, "%s", di->lvm_uuid);
-			PYXPRINT("FILEIO: Referencing LVM Universal Unit Identifier "
-				"<%s>\n", fd_dev->fbd_lvm_uuid);
-			fd_dev->fbd_flags |= FBDF_HAS_LVM_UUID;
-		}	
-
 		PYXPRINT("FILEIO: Claiming %p Major:Minor - %d:%d\n", fd_dev,
 			fd_dev->fd_major, fd_dev->fd_minor);
 
@@ -431,7 +414,6 @@ extern void fd_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
 extern int fd_emulate_inquiry (se_task_t *task)
 {
 	unsigned char prod[64], se_location[128];
-	unsigned char *sub_sn = NULL;
 	se_cmd_t *cmd = TASK_CMD(task);
 	fd_dev_t *fdev = (fd_dev_t *) task->se_dev->dev_ptr;
 	se_hba_t *hba = task->se_dev->se_hba;
@@ -440,19 +422,10 @@ extern int fd_emulate_inquiry (se_task_t *task)
 	memset(se_location, 0, 128);
 	
 	sprintf(prod, "FILEIO");
-
-	if (fdev->fbd_flags & FBDF_HAS_MD_UUID) {
-		snprintf(se_location, 128, "%x%x%x%x", fdev->fbd_uu_id[0],
-			fdev->fbd_uu_id[1], fdev->fbd_uu_id[2], fdev->fbd_uu_id[3]);
-		sub_sn = &se_location[0];
-	} else if (fdev->fbd_flags & FBDF_HAS_LVM_UUID) {
-		snprintf(se_location, 128, "%s", fdev->fbd_lvm_uuid);
-		sub_sn = &se_location[0];
-	} else 
-		sprintf(se_location, "%u_%u", hba->hba_id, fdev->fd_dev_id);
+	sprintf(se_location, "%u_%u", hba->hba_id, fdev->fd_dev_id);
 		
 	return(transport_generic_emulate_inquiry(cmd, TYPE_DISK, prod, FD_VERSION,
-		se_location, sub_sn));
+		se_location));
 }
 
 /*	fd_emulate_read_cap():
@@ -932,7 +905,6 @@ extern ssize_t fd_set_configfs_dev_params (se_hba_t *hba,
 	memcpy(buf, page, count);
 	cur = buf;
 
-#warning FIXME: Finish UUID for FILEIO
 #warning FIXME: Finish major/minor for real backend blockdevice
 	while (cur) {
 		if (!(ptr = strstr(cur, "=")))
@@ -1017,13 +989,6 @@ extern void fd_get_dev_info (se_device_t *dev, char *b, int *bl)
 extern void __fd_get_dev_info (fd_dev_t *fd_dev, char *b, int *bl)
 {
 	*bl += sprintf(b+*bl, "LIO FILEIO ID: %u", fd_dev->fd_dev_id);
-	if (fd_dev->fbd_flags & FBDF_HAS_MD_UUID) {
-		*bl += sprintf(b+*bl, "  MD UUID: %x:%x:%x:%x\n",
-			fd_dev->fbd_uu_id[0], fd_dev->fbd_uu_id[1],
-			fd_dev->fbd_uu_id[2], fd_dev->fbd_uu_id[3]);
-	} else if (fd_dev->fbd_flags & FBDF_HAS_LVM_UUID)
-		*bl += sprintf(b+*bl, "  LVM UUID: %s\n", fd_dev->fbd_lvm_uuid);
-
 	*bl += sprintf(b+*bl, "        File: %s  Size: %llu  ",
 		fd_dev->fd_dev_name, fd_dev->fd_dev_size);	
 
diff --git a/drivers/lio-core/target_core_file.h b/drivers/lio-core/target_core_file.h
index 7925f1d..7301ac4 100644
--- a/drivers/lio-core/target_core_file.h
+++ b/drivers/lio-core/target_core_file.h
@@ -111,14 +111,10 @@ typedef struct fd_dev_sg_table_s {
 	struct scatterlist *sg_table;
 } ____cacheline_aligned fd_dev_sg_table_t;
 
-#define FBDF_HAS_MD_UUID	0x01
-#define FBDF_HAS_LVM_UUID	0x02
-#define FBDF_HAS_PATH		0x04
-#define FBDF_HAS_SIZE		0x08
+#define FBDF_HAS_PATH		0x01
+#define FBDF_HAS_SIZE		0x02
 
 typedef struct fd_dev_s {
-	unsigned char	fbd_lvm_uuid[SE_LVM_UUID_LEN];
-	u32		fbd_uu_id[4];
 	u32		fbd_flags;
 	unsigned char	fd_dev_name[FD_MAX_DEV_NAME];
 	int		fd_claim_bd;
-- 
1.5.4.1



