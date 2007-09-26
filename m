From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] fix leftover from default sdev attribute switch
Date: Wed, 26 Sep 2007 19:54:49 +0200
Message-ID: <1190829289.3773.74.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:41176 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756034AbXIZRye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 13:54:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi James,
seems we miss the following fix in the current tree.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [SCSI] fix scsi_is_sdev_device() after switch to default sdev attributes

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0088c4d..8e880ef 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -995,7 +995,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 
 int scsi_is_sdev_device(const struct device *dev)
 {
-	return dev->release == scsi_device_dev_release;
+	return dev->type == &scsi_dev_type;
 }
 EXPORT_SYMBOL(scsi_is_sdev_device);
 

