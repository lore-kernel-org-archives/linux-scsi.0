From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 3/3] Introduce a type for device information flags, namely bflags_t
Date: Tue, 14 Nov 2017 16:57:21 -0800
Message-ID: <20171115005721.11023-4-bart.vanassche@wdc.com>
References: <20171115005721.11023-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rap-us.hgst.com ([199.255.44.250]:32167 "EHLO localhost"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754062AbdKOBD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Nov 2017 20:03:56 -0500
In-Reply-To: <20171115005721.11023-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Additionally, suppress recently introduced sparse warnings related
to blacklist flags.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_devinfo.c       | 20 +++++++--------
 drivers/scsi/scsi_priv.h          |  6 ++---
 drivers/scsi/scsi_scan.c          | 15 +++++------
 drivers/scsi/scsi_sysfs.c         |  4 +--
 drivers/scsi/scsi_transport_spi.c |  6 ++---
 include/scsi/scsi_device.h        |  3 ++-
 include/scsi/scsi_devinfo.h       | 52 ++++++++++++++++++++-------------------
 include/scsi/scsi_types.h         |  6 +++++
 8 files changed, 60 insertions(+), 52 deletions(-)
 create mode 100644 include/scsi/scsi_types.h

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d195560a641c..575da174dad7 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -22,7 +22,7 @@ struct scsi_dev_info_list {
 	struct list_head dev_info_list;
 	char vendor[8];
 	char model[16];
-	unsigned flags;
+	bflags_t flags;
 	unsigned compatible; /* for use with scsi_static_device_list entries */
 };
 
@@ -52,7 +52,7 @@ static struct {
 	char *vendor;
 	char *model;
 	char *revision;	/* revision known to be bad, unused */
-	unsigned flags;
+	bflags_t flags;
 } scsi_static_device_list[] __initdata = {
 	/*
 	 * The following devices are known not to tolerate a lun != 0 scan
@@ -335,7 +335,7 @@ static void scsi_strcpy_devinfo(const char *name, char *to, size_t to_length,
  * Returns: 0 OK, -error on failure.
  **/
 static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
-			    char *strflags, int flags)
+			    char *strflags, bflags_t flags)
 {
 	return scsi_dev_info_list_add_keyed(compatible, vendor, model,
 					    strflags, flags,
@@ -362,7 +362,7 @@ static int scsi_dev_info_list_add(int compatible, char *vendor, char *model,
  **/
 int scsi_dev_info_list_add_keyed(int compatible, const char *vendor,
 				 const char *model, const char *strflags,
-				 int flags, int key)
+				 bflags_t flags, int key)
 {
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
@@ -383,10 +383,8 @@ int scsi_dev_info_list_add_keyed(int compatible, const char *vendor,
 			    model, compatible);
 
 	if (strflags)
-		devinfo->flags = simple_strtoul(strflags, NULL, 0);
-	else
-		devinfo->flags = flags;
-
+		flags = (__force bflags_t)simple_strtoul(strflags, NULL, 0);
+	devinfo->flags = flags;
 	devinfo->compatible = compatible;
 
 	if (compatible)
@@ -574,7 +572,7 @@ static int scsi_dev_info_list_add_str(char *dev_list)
  *     settings.  Called during scan time.
  **/
 int scsi_get_device_flags(struct scsi_device *sdev, const unsigned char *vendor,
-			  const unsigned char *model, unsigned int *flags)
+			  const unsigned char *model, bflags_t *flags)
 {
 	return scsi_get_device_flags_keyed(sdev, vendor, model,
 					   SCSI_DEVINFO_GLOBAL, flags);
@@ -598,7 +596,7 @@ int scsi_get_device_flags(struct scsi_device *sdev, const unsigned char *vendor,
 int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				const unsigned char *vendor,
 				const unsigned char *model,
-				int key, unsigned int *flags)
+				int key, bflags_t *flags)
 {
 	struct scsi_dev_info_list *devinfo;
 	int err;
@@ -620,7 +618,7 @@ int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 	}
 
 	/* except for the global list, where we have an exception */
-	*flags = sdev->sdev_bflags ? : scsi_default_dev_flags;
+	*flags = sdev->sdev_bflags ? : (__force bflags_t)scsi_default_dev_flags;
 	return 0;
 }
 EXPORT_SYMBOL(scsi_get_device_flags_keyed);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b82238577b19..e8b12e2ce2e3 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -53,14 +53,14 @@ enum {
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
 				 const unsigned char *model,
-				 unsigned int *flags);
+				 bflags_t *flags);
 extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				       const unsigned char *vendor,
 				       const unsigned char *model, int key,
-				       unsigned int *flags);
+				       bflags_t *flags);
 extern int scsi_dev_info_list_add_keyed(int compatible, const char *vendor,
 					const char *model, const char *strflags,
-					int flags, int key);
+					bflags_t flags, int key);
 extern int scsi_dev_info_list_del_keyed(char *vendor, char *model, int key);
 extern int scsi_dev_info_add_list(int key, const char *name);
 extern int scsi_dev_info_remove_list(int key);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5b9571f30d82..0a87ad88c6fb 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -566,7 +566,7 @@ EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
  *     are copied to the scsi_device any flags value is stored in *@bflags.
  **/
 static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
-			  int result_len, int *bflags)
+			  int result_len, bflags_t *bflags)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
@@ -770,7 +770,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
-		int *bflags, int async)
+		bflags_t *bflags, int async)
 {
 	int ret;
 
@@ -1049,14 +1049,15 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
  *   - SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
-				  u64 lun, int *bflagsp,
+				  u64 lun, bflags_t *bflagsp,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
-	int bflags, res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
+	bflags_t bflags;
+	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	/*
@@ -1202,7 +1203,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
  *     Modifies sdevscan->lun.
  **/
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
-				     int bflags, int scsi_level,
+				     bflags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
 {
 	uint max_dev_lun;
@@ -1293,7 +1294,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: could not scan with REPORT LUN
  **/
-static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
+static int scsi_report_lun_scan(struct scsi_target *starget, bflags_t bflags,
 				enum scsi_scan_mode rescan)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
@@ -1539,7 +1540,7 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 		unsigned int id, u64 lun, enum scsi_scan_mode rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
-	int bflags = 0;
+	bflags_t bflags = 0;
 	int res;
 	struct scsi_target *starget;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index cbc0fe2c5485..1bce5c7305ff 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -967,7 +967,7 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
-#define BLIST_FLAG_NAME(name) [ilog2(BLIST_##name)] = #name
+#define BLIST_FLAG_NAME(name) [ilog2((__force u32)BLIST_##name)] = #name
 static const char *const sdev_bflags_name[] = {
 #include "scsi_devinfo_tbl.c"
 };
@@ -984,7 +984,7 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
 	for (i = 0; i < sizeof(sdev->sdev_bflags) * BITS_PER_BYTE; i++) {
 		const char *name = NULL;
 
-		if (!(sdev->sdev_bflags & BIT(i)))
+		if (!((__force u32)sdev->sdev_bflags & BIT(i)))
 			continue;
 		if (i < ARRAY_SIZE(sdev_bflags_name) && sdev_bflags_name[i])
 			name = sdev_bflags_name[i];
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 5f4cea2d07c8..c4ecdbbd458c 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -50,14 +50,14 @@
 
 /* Our blacklist flags */
 enum {
-	SPI_BLIST_NOIUS = 0x1,
+	SPI_BLIST_NOIUS = (__force bflags_t)0x1,
 };
 
 /* blacklist table, modelled on scsi_devinfo.c */
 static struct {
 	char *vendor;
 	char *model;
-	unsigned flags;
+	bflags_t flags;
 } spi_static_device_list[] __initdata = {
 	{"HP", "Ultrium 3-SCSI", SPI_BLIST_NOIUS },
 	{"IBM", "ULTRIUM-TD3", SPI_BLIST_NOIUS },
@@ -221,7 +221,7 @@ static int spi_device_configure(struct transport_container *tc,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
-	unsigned int bflags = 0;
+	bflags_t bflags = 0;
 
 	scsi_get_device_flags_keyed(sdev, &sdev->inquiry[8], &sdev->inquiry[16],
 				    SCSI_DEVINFO_SPI, &bflags);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 1fb6ad3c5006..13f0def0dbfc 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -7,6 +7,7 @@
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_types.h>
 #include <linux/atomic.h>
 
 struct device;
@@ -141,7 +142,7 @@ struct scsi_device {
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
-	unsigned int	sdev_bflags; /* black/white flags as also found in
+	bflags_t	sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
 				 * pass settings from slave_alloc to scsi
 				 * core. */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 3cf125b56c3a..7e3001b3f262 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -5,56 +5,58 @@
  * Flags for SCSI devices that need special treatment
  */
 
+#include <scsi/scsi_types.h>
+
 /* Only scan LUN 0 */
-#define BLIST_NOLUN		((__force __u32 __bitwise)(1 << 0))
+#define BLIST_NOLUN		((__force bflags_t)(1 << 0))
 /* Known to have LUNs, force scanning.
  * DEPRECATED: Use max_luns=N */
-#define BLIST_FORCELUN		((__force __u32 __bitwise)(1 << 1))
+#define BLIST_FORCELUN		((__force bflags_t)(1 << 1))
 /* Flag for broken handshaking */
-#define BLIST_BORKEN		((__force __u32 __bitwise)(1 << 2))
+#define BLIST_BORKEN		((__force bflags_t)(1 << 2))
 /* unlock by special command */
-#define BLIST_KEY		((__force __u32 __bitwise)(1 << 3))
+#define BLIST_KEY		((__force bflags_t)(1 << 3))
 /* Do not use LUNs in parallel */
-#define BLIST_SINGLELUN		((__force __u32 __bitwise)(1 << 4))
+#define BLIST_SINGLELUN		((__force bflags_t)(1 << 4))
 /* Buggy Tagged Command Queuing */
-#define BLIST_NOTQ		((__force __u32 __bitwise)(1 << 5))
+#define BLIST_NOTQ		((__force bflags_t)(1 << 5))
 /* Non consecutive LUN numbering */
-#define BLIST_SPARSELUN		((__force __u32 __bitwise)(1 << 6))
+#define BLIST_SPARSELUN		((__force bflags_t)(1 << 6))
 /* Avoid LUNS >= 5 */
-#define BLIST_MAX5LUN		((__force __u32 __bitwise)(1 << 7))
+#define BLIST_MAX5LUN		((__force bflags_t)(1 << 7))
 /* Treat as (removable) CD-ROM */
-#define BLIST_ISROM		((__force __u32 __bitwise)(1 << 8))
+#define BLIST_ISROM		((__force bflags_t)(1 << 8))
 /* LUNs past 7 on a SCSI-2 device */
-#define BLIST_LARGELUN		((__force __u32 __bitwise)(1 << 9))
+#define BLIST_LARGELUN		((__force bflags_t)(1 << 9))
 /* override additional length field */
-#define BLIST_INQUIRY_36	((__force __u32 __bitwise)(1 << 10))
+#define BLIST_INQUIRY_36	((__force bflags_t)(1 << 10))
 /* do not do automatic start on add */
-#define BLIST_NOSTARTONADD	((__force __u32 __bitwise)(1 << 12))
+#define BLIST_NOSTARTONADD	((__force bflags_t)(1 << 12))
 /* try REPORT_LUNS even for SCSI-2 devs (if HBA supports more than 8 LUNs) */
-#define BLIST_REPORTLUN2	((__force __u32 __bitwise)(1 << 17))
+#define BLIST_REPORTLUN2	((__force bflags_t)(1 << 17))
 /* don't try REPORT_LUNS scan (SCSI-3 devs) */
-#define BLIST_NOREPORTLUN	((__force __u32 __bitwise)(1 << 18))
+#define BLIST_NOREPORTLUN	((__force bflags_t)(1 << 18))
 /* don't use PREVENT-ALLOW commands */
-#define BLIST_NOT_LOCKABLE	((__force __u32 __bitwise)(1 << 19))
+#define BLIST_NOT_LOCKABLE	((__force bflags_t)(1 << 19))
 /* device is actually for RAID config */
-#define BLIST_NO_ULD_ATTACH	((__force __u32 __bitwise)(1 << 20))
+#define BLIST_NO_ULD_ATTACH	((__force bflags_t)(1 << 20))
 /* select without ATN */
-#define BLIST_SELECT_NO_ATN	((__force __u32 __bitwise)(1 << 21))
+#define BLIST_SELECT_NO_ATN	((__force bflags_t)(1 << 21))
 /* retry HARDWARE_ERROR */
-#define BLIST_RETRY_HWERROR	((__force __u32 __bitwise)(1 << 22))
+#define BLIST_RETRY_HWERROR	((__force bflags_t)(1 << 22))
 /* maximum 512 sector cdb length */
-#define BLIST_MAX_512		((__force __u32 __bitwise)(1 << 23))
+#define BLIST_MAX_512		((__force bflags_t)(1 << 23))
 /* Disable T10 PI (DIF) */
-#define BLIST_NO_DIF		((__force __u32 __bitwise)(1 << 25))
+#define BLIST_NO_DIF		((__force bflags_t)(1 << 25))
 /* Ignore SBC-3 VPD pages */
-#define BLIST_SKIP_VPD_PAGES	((__force __u32 __bitwise)(1 << 26))
+#define BLIST_SKIP_VPD_PAGES	((__force bflags_t)(1 << 26))
 /* Attempt to read VPD pages */
-#define BLIST_TRY_VPD_PAGES	((__force __u32 __bitwise)(1 << 28))
+#define BLIST_TRY_VPD_PAGES	((__force bflags_t)(1 << 28))
 /* don't try to issue RSOC */
-#define BLIST_NO_RSOC		((__force __u32 __bitwise)(1 << 29))
+#define BLIST_NO_RSOC		((__force bflags_t)(1 << 29))
 /* maximum 1024 sector cdb length */
-#define BLIST_MAX_1024		((__force __u32 __bitwise)(1 << 30))
+#define BLIST_MAX_1024		((__force bflags_t)(1 << 30))
 /* Use UNMAP limit for WRITE SAME */
-#define BLIST_UNMAP_LIMIT_WS	((__force __u32 __bitwise)(1 << 31))
+#define BLIST_UNMAP_LIMIT_WS	((__force bflags_t)(1 << 31))
 
 #endif
diff --git a/include/scsi/scsi_types.h b/include/scsi/scsi_types.h
new file mode 100644
index 000000000000..3ed29c31270a
--- /dev/null
+++ b/include/scsi/scsi_types.h
@@ -0,0 +1,6 @@
+#ifndef _SCSI_SCSI_TYPES_H_
+#define _SCSI_SCSI_TYPES_H_
+
+typedef __u32 __bitwise bflags_t;
+
+#endif
-- 
2.15.0
