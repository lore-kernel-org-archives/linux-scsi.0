From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 16/18] scsi: Add scsi_host_template.slave_delete callback
Date: Sat, 14 Jan 2012 12:55:25 +0000
Message-ID: <12084055.3HXOlOaeVy@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:47638 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2ANMz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 07:55:27 -0500
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <JBottomley@parallels.com>, David Dillow <dillowda@ornl.gov>

Add a callback function in the SCSI host template that is invoked
just before device removal. This allows drivers that keep a
reference to the device itself to remove that reference.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: David Dillow <dillowda@ornl.gov>
---
 drivers/scsi/scsi_sysfs.c |    7 ++++++-
 include/scsi/scsi_host.h  |    9 +++++++++
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..ea5658d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -572,7 +572,12 @@ static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
 static void sdev_store_delete_callback(struct device *dev)
 {
-	scsi_remove_device(to_scsi_device(dev));
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_host_template *sht = sdev->host->hostt;
+
+	if (sht->slave_delete)
+		sht->slave_delete(sdev);
+	scsi_remove_device(sdev);
 }
 
 static ssize_t
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5f7d5b3..7c92948 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -233,6 +233,15 @@ struct scsi_host_template {
 	 */
 	int (* slave_configure)(struct scsi_device *);
 
+	/**
+	 * Callback invoked just before scsi_remove_device() will be invoked
+	 * e.g. if device removal has been requested via the sdev "delete"
+	 * sysfs attribute.
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (* slave_delete)(struct scsi_device *);
+
 	/*
 	 * Immediately prior to deallocating the device and after all activity
 	 * has ceased the mid layer calls this point so that the low level
-- 
1.7.7


