From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Use 'blist_flags_t' for scsi_devinfo flags
Date: Wed, 15 Nov 2017 12:07:30 +0100
Message-ID: <1510744050-53682-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757704AbdKOLIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Nov 2017 06:08:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

As per recommendation from Linus we should be using a distinct
type for blacklist flags.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 18 ++++++++---------
 drivers/scsi/scsi_priv.h    | 15 +++++++-------
 drivers/scsi/scsi_scan.c    |  2 +-
 include/scsi/scsi_device.h  |  4 +++-
 include/scsi/scsi_devinfo.h | 48 ++++++++++++++++++++++-----------------------
 5 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 555269b..1ecd8cd 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -21,7 +21,7 @@ struct scsi_dev_info_list {
 	struct list_head dev_info_list;
 	char vendor[8];
 	char model[16];
-	unsigned flags;
+	blist_flags_t flags;
 	unsigned compatible; /* for use with scsi_static_device_list entries */
 };
 
@@ -34,7 +34,7 @@ struct scsi_dev_info_list_table {
 
 
 static const char spaces[] = "                "; /* 16 of them */
-static unsigned scsi_default_dev_flags;
+static blist_flags_t scsi_default_dev_flags;
 static LIST_HEAD(scsi_dev_info_list);
 static char scsi_dev_flags[256];
 
@@ -51,7 +51,7 @@ struct scsi_dev_info_list_table {
 	char *vendor;
 	char *model;
 	char *revision;	/* revision known to be bad, unused */
-	unsigned flags;
+	blist_flags_t flags;
 } scsi_static_device_list[] __initdata = {
 	/*
 	 * The following devices are known not to tolerate a lun != 0 scan
@@ -334,7 +334,7 @@ static void scsi_strcpy_devinfo(char *name, char *to, size_t to_length,
  * Returns: 0 OK, -error on failure.
  **/
 static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
-			    char *strflags, int flags)
+			    char *strflags, blist_flags_t flags)
 {
 	return scsi_dev_info_list_add_keyed(compatible, vendor, model,
 					    strflags, flags,
@@ -360,7 +360,7 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
  * Returns: 0 OK, -error on failure.
  **/
 int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
-				 char *strflags, int flags, int key)
+				 char *strflags, blist_flags_t flags, int key)
 {
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
@@ -570,9 +570,9 @@ static int scsi_dev_info_list_add_str(char *dev_list)
  *     matching flags value, else return the host or global default
  *     settings.  Called during scan time.
  **/
-int scsi_get_device_flags(struct scsi_device *sdev,
-			  const unsigned char *vendor,
-			  const unsigned char *model)
+blist_flags_t scsi_get_device_flags(struct scsi_device *sdev,
+				    const unsigned char *vendor,
+				    const unsigned char *model)
 {
 	return scsi_get_device_flags_keyed(sdev, vendor, model,
 					   SCSI_DEVINFO_GLOBAL);
@@ -592,7 +592,7 @@ int scsi_get_device_flags(struct scsi_device *sdev,
  *     flags value, else return the host or global default settings.
  *     Called during scan time.
  **/
-int scsi_get_device_flags_keyed(struct scsi_device *sdev,
+blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				const unsigned char *vendor,
 				const unsigned char *model,
 				int key)
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 9125e01..29f162e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -49,15 +49,16 @@ enum {
 	SCSI_DEVINFO_SPI,
 };
 
-extern int scsi_get_device_flags(struct scsi_device *sdev,
-				 const unsigned char *vendor,
-				 const unsigned char *model);
-extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
-				       const unsigned char *vendor,
-				       const unsigned char *model, int key);
+extern blist_flags_t scsi_get_device_flags(struct scsi_device *sdev,
+					   const unsigned char *vendor,
+					   const unsigned char *model);
+extern blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
+						 const unsigned char *vendor,
+						 const unsigned char *model,
+						 int key);
 extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 					char *model, char *strflags,
-					int flags, int key);
+					blist_flags_t flags, int key);
 extern int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key);
 extern int scsi_dev_info_add_list(int key, const char *name);
 extern int scsi_dev_info_remove_list(int key);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 26edd61..a9ebbdc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -565,7 +565,7 @@ void scsi_sanitize_inquiry_string(unsigned char *s, int len)
  *     are copied to the scsi_device any flags value is stored in *@bflags.
  **/
 static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
-			  int result_len, int *bflags)
+			  int result_len, blist_flags_t *bflags)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d68985c..ddcd3a7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -14,6 +14,8 @@
 struct scsi_lun;
 struct scsi_sense_hdr;
 
+typedef unsigned int __bitwise blist_flags_t;
+
 struct scsi_mode_data {
 	__u32	length;
 	__u16	block_descriptor_length;
@@ -140,7 +142,7 @@ struct scsi_device {
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-	unsigned int	sdev_bflags; /* black/white flags as also found in
+	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
 				 * pass settings from slave_alloc to scsi
 				 * core. */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 7a2329c..9c43b68 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -5,53 +5,53 @@
  */
 
 /* Only scan LUN 0 */
-#define BLIST_NOLUN		((__force __u32 __bitwise)(1 << 0))
+#define BLIST_NOLUN		((__force blist_flags_t)(1 << 0))
 /* Known to have LUNs, force scanning.
  * DEPRECATED: Use max_luns=N */
-#define BLIST_FORCELUN		((__force __u32 __bitwise)(1 << 1))
+#define BLIST_FORCELUN		((__force blist_flags_t)(1 << 1))
 /* Flag for broken handshaking */
-#define BLIST_BORKEN		((__force __u32 __bitwise)(1 << 2))
+#define BLIST_BORKEN		((__force blist_flags_t)(1 << 2))
 /* unlock by special command */
-#define BLIST_KEY		((__force __u32 __bitwise)(1 << 3))
+#define BLIST_KEY		((__force blist_flags_t)(1 << 3))
 /* Do not use LUNs in parallel */
-#define BLIST_SINGLELUN		((__force __u32 __bitwise)(1 << 4))
+#define BLIST_SINGLELUN		((__force blist_flags_t)(1 << 4))
 /* Buggy Tagged Command Queuing */
-#define BLIST_NOTQ		((__force __u32 __bitwise)(1 << 5))
+#define BLIST_NOTQ		((__force blist_flags_t)(1 << 5))
 /* Non consecutive LUN numbering */
-#define BLIST_SPARSELUN		((__force __u32 __bitwise)(1 << 6))
+#define BLIST_SPARSELUN		((__force blist_flags_t)(1 << 6))
 /* Avoid LUNS >= 5 */
-#define BLIST_MAX5LUN		((__force __u32 __bitwise)(1 << 7))
+#define BLIST_MAX5LUN		((__force blist_flags_t)(1 << 7))
 /* Treat as (removable) CD-ROM */
-#define BLIST_ISROM		((__force __u32 __bitwise)(1 << 8))
+#define BLIST_ISROM		((__force blist_flags_t)(1 << 8))
 /* LUNs past 7 on a SCSI-2 device */
-#define BLIST_LARGELUN		((__force __u32 __bitwise)(1 << 9))
+#define BLIST_LARGELUN		((__force blist_flags_t)(1 << 9))
 /* override additional length field */
-#define BLIST_INQUIRY_36	((__force __u32 __bitwise)(1 << 10))
+#define BLIST_INQUIRY_36	((__force blist_flags_t)(1 << 10))
 /* do not do automatic start on add */
-#define BLIST_NOSTARTONADD	((__force __u32 __bitwise)(1 << 12))
+#define BLIST_NOSTARTONADD	((__force blist_flags_t)(1 << 12))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
-#define BLIST_REPORTLUN2	((__force __u32 __bitwise)(1 << 17))
+#define BLIST_REPORTLUN2	((__force blist_flags_t)(1 << 17))
 /* don't try REPORT_LUNS scan (SCSI-3 devs) */
-#define BLIST_NOREPORTLUN	((__force __u32 __bitwise)(1 << 18))
+#define BLIST_NOREPORTLUN	((__force blist_flags_t)(1 << 18))
 /* don't use PREVENT-ALLOW commands */
-#define BLIST_NOT_LOCKABLE	((__force __u32 __bitwise)(1 << 19))
+#define BLIST_NOT_LOCKABLE	((__force blist_flags_t)(1 << 19))
 /* device is actually for RAID config */
-#define BLIST_NO_ULD_ATTACH	((__force __u32 __bitwise)(1 << 20))
+#define BLIST_NO_ULD_ATTACH	((__force blist_flags_t)(1 << 20))
 /* select without ATN */
-#define BLIST_SELECT_NO_ATN	((__force __u32 __bitwise)(1 << 21))
+#define BLIST_SELECT_NO_ATN	((__force blist_flags_t)(1 << 21))
 /* retry HARDWARE_ERROR */
-#define BLIST_RETRY_HWERROR	((__force __u32 __bitwise)(1 << 22))
+#define BLIST_RETRY_HWERROR	((__force blist_flags_t)(1 << 22))
 /* maximum 512 sector cdb length */
-#define BLIST_MAX_512		((__force __u32 __bitwise)(1 << 23))
+#define BLIST_MAX_512		((__force blist_flags_t)(1 << 23))
 /* Disable T10 PI (DIF) */
-#define BLIST_NO_DIF		((__force __u32 __bitwise)(1 << 25))
+#define BLIST_NO_DIF		((__force blist_flags_t)(1 << 25))
 /* Ignore SBC-3 VPD pages */
-#define BLIST_SKIP_VPD_PAGES	((__force __u32 __bitwise)(1 << 26))
+#define BLIST_SKIP_VPD_PAGES	((__force blist_flags_t)(1 << 26))
 /* Attempt to read VPD pages */
-#define BLIST_TRY_VPD_PAGES	((__force __u32 __bitwise)(1 << 28))
+#define BLIST_TRY_VPD_PAGES	((__force blist_flags_t)(1 << 28))
 /* don't try to issue RSOC */
-#define BLIST_NO_RSOC		((__force __u32 __bitwise)(1 << 29))
+#define BLIST_NO_RSOC		((__force blist_flags_t)(1 << 29))
 /* maximum 1024 sector cdb length */
-#define BLIST_MAX_1024		((__force __u32 __bitwise)(1 << 30))
+#define BLIST_MAX_1024		((__force blist_flags_t)(1 << 30))
 
 #endif
-- 
1.8.5.6
