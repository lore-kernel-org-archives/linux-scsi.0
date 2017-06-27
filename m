From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] ses: do not add a device to an enclosure if enclosure_add_links() fails.
Date: Tue, 27 Jun 2017 11:53:27 +0200
Message-ID: <1498557207-12364-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751632AbdF0Jxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Jun 2017 05:53:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

The enclosure_add_device() function should fail if it can't
create the relevant sysfs links.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/misc/enclosure.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index d3fe3ea..eb29113 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -375,6 +375,7 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 			 struct device *dev)
 {
 	struct enclosure_component *cdev;
+	int err;
 
 	if (!edev || component >= edev->components)
 		return -EINVAL;
@@ -384,12 +385,17 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 	if (cdev->dev == dev)
 		return -EEXIST;
 
-	if (cdev->dev)
+	if (cdev->dev) {
 		enclosure_remove_links(cdev);
-
-	put_device(cdev->dev);
+		put_device(cdev->dev);
+	}
 	cdev->dev = get_device(dev);
-	return enclosure_add_links(cdev);
+	err = enclosure_add_links(cdev);
+	if (err) {
+		put_device(cdev->dev);
+		cdev->dev = NULL;
+	}
+	return err;
 }
 EXPORT_SYMBOL_GPL(enclosure_add_device);
 
-- 
Maurizio Lombardi
