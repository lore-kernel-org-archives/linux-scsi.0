From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2 11/12] scsi: sd: Introduce scsi_disk_from_queue()
Date: Fri,  8 Sep 2017 01:16:39 +0900
Message-ID: <20170907161640.30465-12-damien.lemoal@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20811 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932303AbdIGQTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Sep 2017 12:19:17 -0400
In-Reply-To: <20170907161640.30465-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Using scsi_device_from_queue(), return the scsi_disk structure
associated with a request queue if the device is a disk.
Export this function to make it available to modules.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 32 ++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1cd113df2d3a..ff9fff4de3e6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -631,6 +631,38 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
+static int scsi_disk_lookup(struct device *dev, void *data)
+{
+	struct scsi_disk **sdkp = data;
+
+	if (!*sdkp && dev->class == &sd_disk_class)
+		*sdkp = to_scsi_disk(dev);
+
+	return 0;
+}
+
+/**
+ * scsi_disk_from_queue - return scsi disk associated with a request_queue
+ * @q: The request queue to return the scsi disk from
+ *
+ * Return the struct scsi_disk associated with a request queue or NULL if the
+ * request_queue does not reference a SCSI device or a if the device is
+ * not a disk.
+ */
+struct scsi_disk *scsi_disk_from_queue(struct request_queue *q)
+{
+	struct scsi_device *sdev = scsi_device_from_queue(q);
+	struct scsi_disk *sdkp = NULL;
+
+	if (!sdev)
+		return NULL;
+
+	device_for_each_child(&sdev->sdev_gendev, &sdkp, scsi_disk_lookup);
+
+	return sdkp;
+}
+EXPORT_SYMBOL_GPL(scsi_disk_from_queue);
+
 #ifdef CONFIG_BLK_SED_OPAL
 static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 		size_t len, bool send)
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 3ea82c8cecd5..92113a9e2b20 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -126,6 +126,8 @@ static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
+struct scsi_disk *scsi_disk_from_queue(struct request_queue *q);
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	      sdev_prefix_printk(prefix, (sdsk)->device,		\
-- 
2.13.5
