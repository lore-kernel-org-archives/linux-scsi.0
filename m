From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 09/13] sd: Detect non-rotational devices
Date: Fri, 15 May 2009 00:40:31 -0400
Message-ID: <1242362435-11953-10-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Detect non-rotational devices and set the queue flag accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 86a8b12..ee61136 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1800,6 +1801,29 @@ void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 }
 
 /**
+ * sd_read_block_characteristics - Query block dev. characteristics
+ * @disk: disk to query
+ */
+static void sd_read_block_characteristics(struct scsi_disk *sdkp)
+{
+	char *buffer;
+	u16 rot;
+
+	/* Block Device Characteristics VPD */
+	buffer = scsi_get_vpd_page(sdkp->device, 0xb1);
+
+	if (buffer == NULL)
+		return;
+
+	rot = get_unaligned_be16(&buffer[4]);
+
+	if (rot == 1)
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
+
+	kfree(buffer);
+}
+
+/**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
  *	@disk: struct gendisk we care about
@@ -1836,6 +1860,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_read_block_characteristics(sdkp);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
@@ -1976,6 +2001,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	add_disk(gd);
 	sd_dif_config_host(sdkp);
 
+	sd_revalidate_disk(gd);
+
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
-- 
1.6.0.6

