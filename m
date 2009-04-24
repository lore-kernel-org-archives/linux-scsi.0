From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5 of 9] sd: Detect non-rotational devices
Date: Fri, 24 Apr 2009 01:32:26 -0400
Message-ID: <9e8b201b1de063253b42.1240551146@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:42231 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZDXFgM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2009 01:36:12 -0400
In-Reply-To: <patchbomb.1240551141@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide

Detect non-rotational devices and set the queue flag accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 27 insertions(+)
drivers/scsi/sd.c |   27 +++++++++++++++++++++++++++



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/string_helpers.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1800,6 +1801,29 @@ void sd_read_app_tag_own(struct scsi_dis
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
@@ -1836,6 +1860,7 @@ static int sd_revalidate_disk(struct gen
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_read_block_characteristics(sdkp);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
@@ -1976,6 +2001,8 @@ static void sd_probe_async(void *data, a
 	add_disk(gd);
 	sd_dif_config_host(sdkp);
 
+	sd_revalidate_disk(gd);
+
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 


