From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 07/19] Fix RCU handling of scsi_device.vpd_pg8[03]
Date: Wed, 23 Aug 2017 14:39:57 -0700
Message-ID: <20170823214009.15015-8-bart.vanassche@wdc.com>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45883 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdHWVl4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 17:41:56 -0400
In-Reply-To: <20170823214009.15015-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane Seymour <shane.seymour@hpe.com>

Only annotate pointers that are shared across threads with __rcu.
Use rcu_dereference() when dereferencing an RCU pointer. Protect
also the RCU pointer dereferences when freeing RCU pointers. This
patch suppresses about twenty sparse complaints about the vpd_pg8[03]
pointers.

Fixes: commit 09e2b0b14690 ("scsi: rescan VPD attributes")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Shane Seymour <shane.seymour@hpe.com>
---
 drivers/scsi/scsi.c       | 6 +++---
 drivers/scsi/scsi_lib.c   | 8 ++++----
 drivers/scsi/scsi_sysfs.c | 7 +++++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d38c6d463b8..5bb15e698969 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -426,7 +426,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	int vpd_len = SCSI_VPD_PG_LEN;
 	int pg80_supported = 0;
 	int pg83_supported = 0;
-	unsigned char __rcu *vpd_buf, *orig_vpd_buf = NULL;
+	unsigned char *vpd_buf, *orig_vpd_buf = NULL;
 
 	if (!scsi_device_supports_vpd(sdev))
 		return;
@@ -474,7 +474,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 			goto retry_pg80;
 		}
 		mutex_lock(&sdev->inquiry_mutex);
-		orig_vpd_buf = sdev->vpd_pg80;
+		orig_vpd_buf = rcu_dereference(sdev->vpd_pg80);
 		sdev->vpd_pg80_len = result;
 		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
 		mutex_unlock(&sdev->inquiry_mutex);
@@ -503,7 +503,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 			goto retry_pg83;
 		}
 		mutex_lock(&sdev->inquiry_mutex);
-		orig_vpd_buf = sdev->vpd_pg83;
+		orig_vpd_buf = rcu_dereference(sdev->vpd_pg83);
 		sdev->vpd_pg83_len = result;
 		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
 		mutex_unlock(&sdev->inquiry_mutex);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1905962fb992..2ca91d251c5f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3282,7 +3282,7 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, char *id, size_t id_len)
 	u8 cur_id_type = 0xff;
 	u8 cur_id_size = 0;
 	unsigned char *d, *cur_id_str;
-	unsigned char __rcu *vpd_pg83;
+	unsigned char *vpd_pg83;
 	int id_size = -EINVAL;
 
 	rcu_read_lock();
@@ -3431,7 +3431,7 @@ EXPORT_SYMBOL(scsi_vpd_lun_id);
 int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 {
 	unsigned char *d;
-	unsigned char __rcu *vpd_pg83;
+	unsigned char *vpd_pg83;
 	int group_id = -EAGAIN, rel_port = -1;
 
 	rcu_read_lock();
@@ -3441,8 +3441,8 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int *rel_id)
 		return -ENXIO;
 	}
 
-	d = sdev->vpd_pg83 + 4;
-	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
+	d = vpd_pg83 + 4;
+	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
 		switch (d[1] & 0xf) {
 		case 0x4:
 			/* Relative target port */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5ed473a87589..cf8a2088a9ba 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -456,8 +456,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	kfree(sdev->vpd_pg83);
-	kfree(sdev->vpd_pg80);
+	mutex_lock(&sdev->inquiry_mutex);
+	kfree(rcu_dereference(sdev->vpd_pg83));
+	kfree(rcu_dereference(sdev->vpd_pg80));
+	mutex_unlock(&sdev->inquiry_mutex);
+
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
-- 
2.14.0
