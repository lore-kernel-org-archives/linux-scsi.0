From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/6] [Target_Core_Mod/IBLOCK): Update for EVPD and remove
	legacy parameter code
Date: Fri, 23 Jan 2009 17:58:23 -0800
Message-ID: <1232762303.24642.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:48948 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753852AbZAXB6s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 20:58:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 9081454c3b49a9603463155ef59d269cc8e9622c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 23 Jan 2009 17:26:42 -0800
Subject: [PATCH 4/6] [Target_Core_Mod/IBLOCK): Update for EVPD and remove legacy parameter code

This patch removes IBLOCK specific usage of lvm_uuid= and md_uuid= parameters
from legacy v2.9 code.  Usage of this information including from 'lvs -v'
and 'mdadm -D /dev/mdX' can now be directly echoed into
/sys/kernel/config/target/core/$HBA/$STORAGE_OBJECT/wwn/evpd_unit_serial

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_iblock.c |   45 +++------------------------------
 drivers/lio-core/target_core_iblock.h |   12 +++------
 2 files changed, 8 insertions(+), 49 deletions(-)

diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 0db23b6..25e2318 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -354,25 +354,15 @@ static int iblock_emulate_inquiry (se_task_t *task)
 	se_cmd_t *cmd = TASK_CMD(task);
 	iblock_dev_t *ibd = (iblock_dev_t *) task->se_dev->dev_ptr;
 	se_hba_t *hba = task->se_dev->se_hba;
-	unsigned char *sub_sn = NULL;
 
 	memset(prod, 0, 64);
 	memset(se_location, 0, 128);
 
 	sprintf(prod, "IBLOCK");
-
-	if (ibd->ibd_flags & IBDF_HAS_MD_UUID) {
-		snprintf(se_location, 128, "%x%x%x%x", ibd->ibd_uu_id[0],
-			ibd->ibd_uu_id[1], ibd->ibd_uu_id[2], ibd->ibd_uu_id[3]);
-		sub_sn = &se_location[0];
-	} else if (ibd->ibd_flags & IBDF_HAS_LVM_UUID) {
-		snprintf(se_location, 128, "%s", ibd->ibd_lvm_uuid);
-		sub_sn = &se_location[0];
-	} else
-		sprintf(se_location, "%u_%u_%u", hba->hba_id, ibd->ibd_major, ibd->ibd_minor);
+	sprintf(se_location, "%u_%u_%u", hba->hba_id, ibd->ibd_major, ibd->ibd_minor);
 
 	return(transport_generic_emulate_inquiry(cmd, TYPE_DISK, prod, IBLOCK_VERSION,
-	       se_location, sub_sn));
+	       se_location));
 }
 
 static int iblock_emulate_read_cap (se_task_t *task)
@@ -518,28 +508,7 @@ extern ssize_t iblock_set_configfs_dev_params (se_hba_t *hba,
 		*ptr = '\0';
 		ptr++;
 
-#warning FIXME: md_uuid= parameter 
-		if ((ptr2 = strstr(cur, "md_uuid"))) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ib_dev->ibd_uu_id[0] = 0;
-			ib_dev->ibd_uu_id[1] = 0;
-			ib_dev->ibd_uu_id[2] = 0;
-			ib_dev->ibd_uu_id[3] = 0;
-			PYXPRINT("IBLOCK: Referencing MD Universal Unit Identifier "
-				"<%x %x %x %x>\n", ib_dev->ibd_uu_id[0],
-				ib_dev->ibd_uu_id[1], ib_dev->ibd_uu_id[2], 
-				ib_dev->ibd_uu_id[3]);
-			ib_dev->ibd_flags |= IBDF_HAS_MD_UUID;
-			params++;
-		} else if ((ptr2 = strstr(cur, "lvm_uuid"))) {
-			transport_check_dev_params_delim(ptr, &cur);
-			ptr = strstrip(ptr);
-			ret = snprintf(ib_dev->ibd_lvm_uuid, SE_LVM_UUID_LEN, "%s", ptr);
-			PYXPRINT("IBLOCK: Referencing LVM Universal Unit Identifier "
-				"<%s>\n", ib_dev->ibd_lvm_uuid);
-			ib_dev->ibd_flags |= IBDF_HAS_LVM_UUID;
-			params++;
-		} else if ((ptr2 = strstr(cur, "udev_path"))) {
+		if ((ptr2 = strstr(cur, "udev_path"))) {
 			transport_check_dev_params_delim(ptr, &cur);
 			ptr = strstrip(ptr);
 			ret = snprintf(ib_dev->ibd_udev_path, SE_UDEV_PATH_LEN, "%s", ptr);
@@ -680,13 +649,7 @@ extern void __iblock_get_dev_info (iblock_dev_t *ibd, char *b, int *bl)
 
 	if (bd)
 		*bl += sprintf(b+*bl, "iBlock device: %s", bdevname(bd, buf));
-	if (ibd->ibd_flags & IBDF_HAS_MD_UUID) {
-		*bl += sprintf(b+*bl, "  MD UUID: %x:%x:%x:%x\n",
-			ibd->ibd_uu_id[0], ibd->ibd_uu_id[1],
-			ibd->ibd_uu_id[2], ibd->ibd_uu_id[3]);
-	} else if (ibd->ibd_flags & IBDF_HAS_LVM_UUID)
-		*bl += sprintf(b+*bl, "  LVM UUID: %s\n", ibd->ibd_lvm_uuid);
-	else if (ibd->ibd_flags & IBDF_HAS_UDEV_PATH)
+	if (ibd->ibd_flags & IBDF_HAS_UDEV_PATH)
 		*bl += sprintf(b+*bl, "  UDEV PATH: %s\n", ibd->ibd_udev_path);
 	else 
 		*bl += sprintf(b+*bl, "\n");
diff --git a/drivers/lio-core/target_core_iblock.h b/drivers/lio-core/target_core_iblock.h
index 20da47e..ea5b8f3 100644
--- a/drivers/lio-core/target_core_iblock.h
+++ b/drivers/lio-core/target_core_iblock.h
@@ -90,22 +90,18 @@ typedef struct iblock_req_s {
 	struct iblock_dev_s *ib_dev;
 } ____cacheline_aligned iblock_req_t;
 
-#define IBDF_HAS_MD_UUID		0x01
-#define IBDF_HAS_LVM_UUID		0x02
-#define IBDF_HAS_UDEV_PATH		0x04
-#define IBDF_HAS_MAJOR			0x08
-#define IBDF_HAS_MINOR			0x10
-#define IBDF_HAS_FORCE			0x20
+#define IBDF_HAS_UDEV_PATH		0x01
+#define IBDF_HAS_MAJOR			0x02
+#define IBDF_HAS_MINOR			0x04
+#define IBDF_HAS_FORCE			0x08
 
 typedef struct iblock_dev_s {
-	unsigned char ibd_lvm_uuid[SE_LVM_UUID_LEN];
 	unsigned char ibd_udev_path[SE_UDEV_PATH_LEN];
 	int	ibd_force;
 	int	ibd_major;
 	int	ibd_minor;
 	u32	ibd_depth;
 	u32	ibd_flags;
-	u32	ibd_uu_id[4];
 	struct bio_set	*ibd_bio_set;
 	struct block_device *ibd_bd;
 	struct iblock_hba_s *ibd_host;
-- 
1.5.4.1



