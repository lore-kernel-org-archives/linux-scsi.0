From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/18] scsi: Add scsi_vpd_tpg_id()
Date: Tue,  1 Dec 2015 10:16:57 +0100
Message-ID: <1448961418-29013-18-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41602 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891AbbLAJRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:12 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Implement scsi_vpd_tpg_id() to extract the target
port group id and the relative port id from
SCSI VPD page 0x83.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c    | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5bd8a19..99d087b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -23,6 +23,7 @@
 #include <linux/scatterlist.h>
 #include <linux/blk-mq.h>
 #include <linux/ratelimit.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -3294,3 +3295,50 @@ next_desig:
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
+	unsigned char __rcu *vpd_pg83;
+	int group_id = -EAGAIN, rel_port = -1;
+
+	rcu_read_lock();
+	vpd_pg83 = rcu_dereference(sdev->vpd_pg83);
+	if (!vpd_pg83) {
+		rcu_read_unlock();
+		return -ENXIO;
+	}
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
+	rcu_read_unlock();
+
+	if (group_id >= 0 && rel_id && rel_port != -1)
+		*rel_id = rel_port;
+
+	return group_id;
+}
+EXPORT_SYMBOL(scsi_vpd_tpg_id);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4c49cfa..f63a167 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -416,6 +416,7 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
+extern int scsi_vpd_tpg_id(struct scsi_device *, int *);
 
 #ifdef CONFIG_PM
 extern int scsi_autopm_get_device(struct scsi_device *);
-- 
1.8.5.6

