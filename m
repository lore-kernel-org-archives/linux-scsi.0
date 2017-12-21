From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.15-rc4
Date: Wed, 20 Dec 2017 16:11:09 -0800
Message-ID: <1513815069.3035.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two simple fixes: one for sparse warnings that were introduced by the
merge window conversion to blist_flags_t and the other to fix dropped
I/O during reset in aacraid.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: core: Use blist_flags_t consistently

Prasad B Munirathnam (1):
      scsi: aacraid: Fix I/O drop during reset

And the diffstat:

 drivers/scsi/aacraid/aacraid.h    |  1 +
 drivers/scsi/aacraid/linit.c      |  2 +-
 drivers/scsi/scsi_devinfo.c       |  6 ++----
 drivers/scsi/scsi_scan.c          | 13 +++++++------
 drivers/scsi/scsi_sysfs.c         |  5 +++--
 drivers/scsi/scsi_transport_spi.c | 12 +++++++-----
 6 files changed, 21 insertions(+), 18 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 6e3d81969a77..d52265416da2 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1725,6 +1725,7 @@ struct aac_dev
 #define FIB_CONTEXT_FLAG_NATIVE_HBA		(0x00000010)
 #define FIB_CONTEXT_FLAG_NATIVE_HBA_TMF	(0x00000020)
 #define FIB_CONTEXT_FLAG_SCSI_CMD	(0x00000040)
+#define FIB_CONTEXT_FLAG_EH_RESET	(0x00000080)
 
 /*
  *	Define the command values
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index bdf127aaab41..d55332de08f9 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1037,7 +1037,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 			info = &aac->hba_map[bus][cid];
 			if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
 			    info->devtype != AAC_DEVTYPE_NATIVE_RAW) {
-				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+				fib->flags |= FIB_CONTEXT_FLAG_EH_RESET;
 				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
 			}
 		}
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 449ef5adbb2b..dfb8da83fa50 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -374,10 +374,8 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
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
index 50e7d7e4a861..a9996c16f4ae 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -967,7 +967,8 @@ sdev_show_wwid(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
-#define BLIST_FLAG_NAME(name) [ilog2(BLIST_##name)] = #name
+#define BLIST_FLAG_NAME(name)					\
+	[ilog2((__force unsigned int)BLIST_##name)] = #name
 static const char *const sdev_bflags_name[] = {
 #include "scsi_devinfo_tbl.c"
 };
@@ -984,7 +985,7 @@ sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
 	for (i = 0; i < sizeof(sdev->sdev_bflags) * BITS_PER_BYTE; i++) {
 		const char *name = NULL;
 
-		if (!(sdev->sdev_bflags & BIT(i)))
+		if (!(sdev->sdev_bflags & (__force blist_flags_t)BIT(i)))
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
