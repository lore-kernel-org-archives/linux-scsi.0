From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/41] hpsa: add hp_ssd_smart_path_enabled sysfs attribute
Date: Wed, 15 Jan 2014 16:37:45 -0600
Message-ID: <20140115223745.5061.50133.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:45647 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaAOVhv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:37:51 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f88bb73..39500d6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -508,10 +508,34 @@ static ssize_t unique_id_show(struct device *dev,
 			sn[12], sn[13], sn[14], sn[15]);
 }
 
+static ssize_t host_show_hp_ssd_smart_path_enabled(struct device *dev,
+	     struct device_attribute *attr, char *buf)
+{
+	struct ctlr_info *h;
+	struct scsi_device *sdev;
+	struct hpsa_scsi_dev_t *hdev;
+	unsigned long flags;
+	int offload_enabled;
+
+	sdev = to_scsi_device(dev);
+	h = sdev_to_hba(sdev);
+	spin_lock_irqsave(&h->lock, flags);
+	hdev = sdev->hostdata;
+	if (!hdev) {
+		spin_unlock_irqrestore(&h->lock, flags);
+		return -ENODEV;
+	}
+	offload_enabled = hdev->offload_enabled;
+	spin_unlock_irqrestore(&h->lock, flags);
+	return snprintf(buf, 20, "%d\n", offload_enabled);
+}
+
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
 static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, host_store_rescan);
+static DEVICE_ATTR(hp_ssd_smart_path_enabled, S_IRUGO,
+			host_show_hp_ssd_smart_path_enabled, NULL);
 static DEVICE_ATTR(firmware_revision, S_IRUGO,
 	host_show_firmware_revision, NULL);
 static DEVICE_ATTR(commands_outstanding, S_IRUGO,
@@ -525,6 +549,7 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_raid_level,
 	&dev_attr_lunid,
 	&dev_attr_unique_id,
+	&dev_attr_hp_ssd_smart_path_enabled,
 	NULL,
 };
 

