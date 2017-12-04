From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 2/3] Use blist_flags_t consistently
Date: Mon,  4 Dec 2017 10:36:32 -0800
Message-ID: <20171204183633.32139-3-bart.vanassche@wdc.com>
References: <20171204183633.32139-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31911 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdLDSgf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 13:36:35 -0500
In-Reply-To: <20171204183633.32139-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Use the type blist_flags_t for all variables that represent blacklist
flags. Additionally, suppress recently introduced sparse warnings related
to blacklist flags.

Fixes: commit c6b54164508a ("scsi: Use 'blist_flags_t' for scsi_devinfo flags")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_devinfo.c       |  8 +++-----
 drivers/scsi/scsi_scan.c          | 13 +++++++------
 drivers/scsi/scsi_sysfs.c         |  4 ++--
 drivers/scsi/scsi_transport_spi.c | 12 +++++++-----
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2fed250e87bf..4b33c001ae23 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -382,10 +382,8 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
 			    model, compatible);
 
 	if (strflags)
-		devinfo->flags = simple_strtoul(strflags, NULL, 0);
-	else
-		devinfo->flags = flags;
-
+		flags = (__force blist_flags_t)simple_strtoul(strflags, NULL, 0);
+	devinfo->flags = flags;
 	devinfo->compatible = compatible;
 
 	if (compatible)
@@ -612,7 +610,7 @@ blist_flags_t scsi_get_device_flags_keyed(struct scsi_device *sdev,
 	if (sdev->sdev_bflags)
 		return sdev->sdev_bflags;
 
-	return scsi_default_dev_flags;
+	return (__force blist_flags_t)scsi_default_dev_flags;
 }
 EXPORT_SYMBOL(scsi_get_device_flags_keyed);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index be5e919db0e8..0880d975eed3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -770,7 +770,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
  *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
-		int *bflags, int async)
+		blist_flags_t *bflags, int async)
 {
 	int ret;
 
@@ -1049,14 +1049,15 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
  *   - SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
-				  u64 lun, int *bflagsp,
+				  u64 lun, blist_flags_t *bflagsp,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
-	int bflags, res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
+	blist_flags_t bflags;
+	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	/*
@@ -1201,7 +1202,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
  *     Modifies sdevscan->lun.
  **/
 static void scsi_sequential_lun_scan(struct scsi_target *starget,
-				     int bflags, int scsi_level,
+				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
 {
 	uint max_dev_lun;
@@ -1292,7 +1293,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: could not scan with REPORT LUN
  **/
-static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
+static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflags,
 				enum scsi_scan_mode rescan)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
@@ -1538,7 +1539,7 @@ static void __scsi_scan_target(struct device *parent, unsigned int channel,
 		unsigned int id, u64 lun, enum scsi_scan_mode rescan)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
-	int bflags = 0;
+	blist_flags_t bflags = 0;
 	int res;
 	struct scsi_target *starget;
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 50e7d7e4a861..6ee964643531 100644
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
index d0219e36080c..10ebb213ddb3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -50,14 +50,14 @@
 
 /* Our blacklist flags */
 enum {
-	SPI_BLIST_NOIUS = 0x1,
+	SPI_BLIST_NOIUS = (__force blist_flags_t)0x1,
 };
 
 /* blacklist table, modelled on scsi_devinfo.c */
 static struct {
 	char *vendor;
 	char *model;
-	unsigned flags;
+	blist_flags_t flags;
 } spi_static_device_list[] __initdata = {
 	{"HP", "Ultrium 3-SCSI", SPI_BLIST_NOIUS },
 	{"IBM", "ULTRIUM-TD3", SPI_BLIST_NOIUS },
@@ -221,9 +221,11 @@ static int spi_device_configure(struct transport_container *tc,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
-	unsigned bflags = scsi_get_device_flags_keyed(sdev, &sdev->inquiry[8],
-						      &sdev->inquiry[16],
-						      SCSI_DEVINFO_SPI);
+	blist_flags_t bflags;
+
+	bflags = scsi_get_device_flags_keyed(sdev, &sdev->inquiry[8],
+					     &sdev->inquiry[16],
+					     SCSI_DEVINFO_SPI);
 
 	/* Populate the target capability fields with the values
 	 * gleaned from the device inquiry */
-- 
2.15.0
