From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 10/35] hpsa: add hp_ssd_smart_path_enabled sysfs attribute
Date: Tue, 18 Feb 2014 13:55:54 -0600
Message-ID: <20140218195554.15787.37119.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43516 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaBRT5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:57:21 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id CA2BB60CE1
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:57:19 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f882b18..31ce73f 100644
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
 

