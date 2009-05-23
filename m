From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/3] sd: Detect non-rotational devices
Date: Sat, 23 May 2009 11:43:38 -0400
Message-ID: <1243093419-14371-3-git-send-email-martin.petersen@oracle.com>
References: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:36017 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZEWPnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 May 2009 11:43:51 -0400
In-Reply-To: <1243093419-14371-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Detect non-rotational devices and set the queue flag accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fd5c580..2f3a78e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1795,6 +1795,29 @@ void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
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
@@ -1831,6 +1854,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
+		sd_read_block_characteristics(sdkp);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
@@ -1971,6 +1995,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	add_disk(gd);
 	sd_dif_config_host(sdkp);
 
+	sd_revalidate_disk(gd);
+
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
 
-- 
1.6.0.6

