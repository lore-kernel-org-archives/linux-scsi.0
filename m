From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/6] [Target_Core_Mod]: Add support for configurable EVPD
	Unit Serial Numbers
Date: Fri, 23 Jan 2009 17:56:32 -0800
Message-ID: <1232762192.24642.14.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:21167 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753716AbZAXB44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2009 20:56:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 4578472235a71a32e8d3b02b8d729787344e8c53 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 23 Jan 2009 17:15:15 -0800
Subject: [PATCH 1/6] [Target_Core_Mod]: Add support for configurable EVPD Unit Serial Numbers

This patch updates transport_generic_emulate_inquiry() to use
se_subsystem_dev_t->t10_wwn information when building an INQUIRY
EVPD response.  This code is used by the virtual hba/block subsystem
drivers (IBLOCK, FILEIO and RAMDISK, (but not target_core_mod/pSCSI)
with target_core_mod/ConfigFS $STORAGE_OBJECTS

This patch also adds se_subsystem_dev_t->su_dev_flags the following two defines:

+ * se_subsystem_dev_t->su_dev_flags
+*/
+#define SDF_FIRMWARE_EVPD_UNIT_SERIAL          0x00000001
+#define SDF_EMULATED_EVPD_UNIT_SERIAL          0x00000002

SDF_FIRMWARE_EVPD_UNIT_SERIAL is used when the EVPD is actually coming from
firmware (or emulated below target_core_mod/pSCSI in drivers/scsi), and
SDF_EMULATED_EVPD_UNIT_SERIAL is used by Target_Core_Mod/ConfigFS.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |    2 ++
 drivers/lio-core/target_core_transport.c |   20 +++++++++++---------
 drivers/lio-core/target_core_transport.h |   13 +++++++++----
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 99d2373..5654018 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -362,6 +362,7 @@ typedef struct se_task_s {
 } ____cacheline_aligned se_task_t;
 
 #define TASK_CMD(task)	((struct se_cmd_s *)task->task_se_cmd)
+#define TASK_DEV(task)	((struct se_device_s *)task->se_dev)
 
 typedef struct se_transform_info_s {
         int             ti_set_counts;
@@ -549,6 +550,7 @@ typedef struct se_dev_attrib_s {
 } ____cacheline_aligned se_dev_attrib_t;
 
 typedef struct se_subsystem_dev_s {
+	u32			su_dev_flags;
         struct se_hba_s *se_dev_hba;
         struct se_device_s *se_dev_ptr;
         se_dev_attrib_t se_dev_attrib;
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index 1cc0a59..c83ed5d 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -3988,13 +3988,13 @@ extern int transport_generic_emulate_inquiry (
 	unsigned char type,
 	unsigned char *prod,
 	unsigned char *version,
-	unsigned char *se_location,
-	unsigned char *sub_sn)
+	unsigned char *se_location)
 {
-	u32 len = 0;
+	se_device_t *dev = SE_DEV(cmd);
 	unsigned char *dst = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
 	unsigned char *iqn_sn, buf[EVPD_BUF_LEN];
+	u32 len = 0;
 	
 	memset(dst, 0, cmd->data_length);
 	memset(buf, 0, EVPD_BUF_LEN);
@@ -4028,8 +4028,9 @@ extern int transport_generic_emulate_inquiry (
 		break;
 	case 0x80: /* unit serial number */
 		buf[1] = 0x80;
-		if (sub_sn)
-			len += sprintf((unsigned char *)&buf[4], "%s", sub_sn);
+		if (dev->se_sub_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL)
+			len += sprintf((unsigned char *)&buf[4], "%s",
+				&DEV_T10_WWN(dev)->unit_serial[0]);
 		else {
 			iqn_sn = transport_get_iqn_sn();
 			len += sprintf((unsigned char *)&buf[4], "%s:%s",
@@ -4046,12 +4047,13 @@ extern int transport_generic_emulate_inquiry (
 		
 		len += sprintf((unsigned char *)&buf[8], "%-8s", "LIO-ORG");
 		
-		if (sub_sn)
-			len += sprintf((unsigned char *)&buf[16], "%s:%s", prod, sub_sn);
+		if (dev->se_sub_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL)
+			len += sprintf((unsigned char *)&buf[16], "%s:%s", prod,
+					&DEV_T10_WWN(dev)->unit_serial[0]);
 		else {
 			iqn_sn = transport_get_iqn_sn();
-			len += sprintf((unsigned char *)&buf[16], "%s:%s:%s", prod,
-					iqn_sn, se_location);
+			len += sprintf((unsigned char *)&buf[16], "%s:%s:%s",
+					prod, iqn_sn, se_location);
 		}
 		buf[7] = len; /* Identifier Length */
 		len += 4;
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 5087280..27a127c 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -69,11 +69,17 @@
 #define TRANSPORT_TIMEOUT_TYPE_TAPE		600
 #define TRANSPORT_TIMEOUT_TYPE_OTHER		300
 
-/* For iscsi_task->task_state_flags */
+/* For se_task->task_state_flags */
 #define TSF_EXCEPTION_CLEARED			0x01
 
 /*
- * iSCSI Device related Transport flags
+ * se_subsystem_dev_t->su_dev_flags
+*/
+#define SDF_FIRMWARE_EVPD_UNIT_SERIAL		0x00000001
+#define SDF_EMULATED_EVPD_UNIT_SERIAL		0x00000002
+
+/*
+ * se_device_t->dev_flags
  */
 #define DF_READAHEAD_ACTIVE                     0x00000001
 #define DF_TRANSPORT_DMA_ALLOC			0x00000002
@@ -93,7 +99,6 @@
 #define DA_STATUS_MAX_SECTORS_MAX		8192
 
 #define SE_MODE_PAGE_BUF			512
-#define SE_LVM_UUID_LEN				48 /* Must match PARAM_LVM_UUID_LEN */
 #define SE_UDEV_PATH_LEN			256 /* Must match PARAM_UDEV_PATH_LEN */
 
 #define MOD_MAX_SECTORS(ms, bs)			(ms % (PAGE_SIZE / bs))
@@ -161,7 +166,7 @@ extern void __transport_stop_task_timer (struct se_task_s *, unsigned long *);
 extern void transport_stop_task_timer (struct se_task_s *);
 extern void transport_stop_all_task_timers (struct se_cmd_s *);
 extern int transport_execute_tasks (struct se_cmd_s *);
-extern int transport_generic_emulate_inquiry (struct se_cmd_s *, unsigned char, unsigned char *, unsigned char *, unsigned char *, unsigned char *);
+extern int transport_generic_emulate_inquiry (struct se_cmd_s *, unsigned char, unsigned char *, unsigned char *, unsigned char *);
 extern int transport_generic_emulate_readcapacity (struct se_cmd_s *, u32, u32);
 extern int transport_generic_emulate_readcapacity_16 (struct se_cmd_s *, unsigned long long, u32);
 extern int transport_generic_emulate_modesense (struct se_cmd_s *, unsigned char *, unsigned char *, int, int);
-- 
1.5.4.1



