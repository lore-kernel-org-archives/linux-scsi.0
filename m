From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/36] scsi: Add scsi_vpd_tpg_id()
Date: Tue, 29 Sep 2015 12:47:26 +0200
Message-ID: <1443523658-87622-25-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934693AbbI2Kr7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:59 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Implement scsi_vpd_tpg_id() to extract the target
port group id and the relative port id from
SCSI VPD page 0x83.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 42 ++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 2 files changed, 43 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index de3dcef..fd4203c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -23,6 +23,7 @@
 #include <linux/scatterlist.h>
 #include <linux/blk-mq.h>
 #include <linux/ratelimit.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -3286,3 +3287,44 @@ next_desig:
 	return id_size;
 }
 EXPORT_SYMBOL(scsi_vpd_lun_id);
+
+/*
+ * scsi_vpd_tpg_id - return a target port group identifier
+ * @sdev: SCSI device
+ *
+ * Returns the Target Port Group identifier from the information
+ * froom VPD page 0x83 of the device.
+ *
+ * Returns the identifier or error on failure.
+ */
+int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
+{
+	unsigned char *d;
+	int group_id = -EAGAIN, rel_port = -1;
+
+	if (!sdev->vpd_pg83)
+		return -ENXIO;
+
+	d = sdev->vpd_pg83 + 4;
+	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
+		switch (d[1] & 0xf) {
+		case 0x4:
+			/* Relative target port */
+			rel_port = get_unaligned_be16(&d[6]);
+			break;
+		case 0x5:
+			/* Target port group */
+			group_id = get_unaligned_be16(&d[6]);
+			break;
+		default:
+			break;
+		}
+		d += d[3] + 4;
+	}
+
+	if (group_id >= 0 && rel_id && rel_port != -1)
+		*rel_id = rel_port;
+
+	return group_id;
+}
+EXPORT_SYMBOL(scsi_vpd_tpg_id);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6a9e6b2..cc6e763 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -415,6 +415,7 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
+extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
1.8.5.6

