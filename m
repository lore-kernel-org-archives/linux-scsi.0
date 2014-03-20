From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fixup vpd page length calculation
Date: Thu, 20 Mar 2014 08:19:24 +0100
Message-ID: <1395299964-56537-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaCTHT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2014 03:19:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The VPD page length parameter is not only used for the length,
but also to hold any error code. So it needs to be moved to an
integer.
And we should be resetting the default VPD page length after
each iteration so that we do not allocate overly large buffers.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 4 +++-
 include/scsi/scsi_device.h | 7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ae780ef..81ab805 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1041,7 +1041,7 @@ EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 void scsi_attach_vpd(struct scsi_device *sdev)
 {
 	int result, i;
-	int vpd_len = 255;
+	int vpd_len = SCSI_VPD_PG_LEN;
 	int pg80_supported = 0;
 	int pg83_supported = 0;
 	unsigned char *vpd_buf, *tmp_pg;
@@ -1073,6 +1073,7 @@ retry_pg0:
 			pg83_supported = 1;
 	}
 	kfree(vpd_buf);
+	vpd_len = SCSI_VPD_PG_LEN;
 
 retry_pg80:
 	if (pg80_supported) {
@@ -1106,6 +1107,7 @@ retry_pg80:
 			sdev->vpd_pg80_len = result;
 			spin_unlock(&sdev->reconfig_lock);
 		}
+		vpd_len = SCSI_VPD_PG_LEN;
 	} else {
 		spin_lock(&sdev->reconfig_lock);
 		tmp_pg = sdev->vpd_pg80;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3ea6220..d51c41d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -113,10 +113,13 @@ struct scsi_device {
 	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
-	unsigned char vpd_pg83_len;
+
+#define SCSI_VPD_PG_LEN		255
+	int vpd_pg83_len;
 	unsigned char *vpd_pg83;
-	unsigned char vpd_pg80_len;
+	int vpd_pg80_len;
 	unsigned char *vpd_pg80;
+
 	spinlock_t reconfig_lock;
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
-- 
1.7.12.4

