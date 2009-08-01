From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/3] ses: add support for enclosure component hot removal
Date: Sat, 01 Aug 2009 00:41:22 +0000
Message-ID: <1249087282.3922.515.camel@mulgrave.site>
References: <4A71F4DF.1060600@arrisi.com>
	 <1248984308.3880.271.camel@mulgrave.site>
	 <1249087023.3922.503.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37558 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbZHAAl0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 20:41:26 -0400
In-Reply-To: <1249087023.3922.503.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Ptacek <chris.ptacek@arrisi.com>
Cc: dave.romrell@arrisi.com, Michael Galassi <michael.galassi@arrisi.com>, linux-scsi <linux-scsi@vger.kernel.org>

Right at the moment, hot removal of a device within an enclosure does
nothing (because the intf_remove only copes with enclosure removal not
with component removal). Fix this by adding a function to remove the
component.  Also needed to fix the prototype of
enclosure_remove_device, since we know the device we've removed but
not the internal component number
---
 drivers/misc/enclosure.c  |   22 ++++++++++++++--------
 drivers/scsi/ses.c        |   33 ++++++++++++++++++++++++++-------
 include/linux/enclosure.h |    2 +-
 3 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 789d121..850706a 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -332,19 +332,25 @@ EXPORT_SYMBOL_GPL(enclosure_add_device);
  * Returns zero on success or an error.
  *
  */
-int enclosure_remove_device(struct enclosure_device *edev, int component)
+int enclosure_remove_device(struct enclosure_device *edev, struct device *dev)
 {
 	struct enclosure_component *cdev;
+	int i;
 
-	if (!edev || component >= edev->components)
+	if (!edev || !dev)
 		return -EINVAL;
 
-	cdev = &edev->component[component];
-
-	device_del(&cdev->cdev);
-	put_device(cdev->dev);
-	cdev->dev = NULL;
-	return device_add(&cdev->cdev);
+	for (i = 0; i < edev->components; i++) {
+		cdev = &edev->component[i];
+		if (cdev->dev == dev) {
+			enclosure_remove_links(cdev);
+			device_del(&cdev->cdev);
+			put_device(dev);
+			cdev->dev = NULL;
+			return device_add(&cdev->cdev);
+		}
+	}
+	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(enclosure_remove_device);
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index e1b8c82..be593c8 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -616,18 +616,26 @@ static int ses_remove(struct device *dev)
 	return 0;
 }
 
-static void ses_intf_remove(struct device *cdev,
-			    struct class_interface *intf)
+static void ses_intf_remove_component(struct scsi_device *sdev)
+{
+	struct enclosure_device *edev, *prev = NULL;
+
+	while ((edev = enclosure_find(&sdev->host->shost_gendev, prev)) != NULL) {
+		prev = edev;
+		if (!enclosure_remove_device(edev, &sdev->sdev_gendev))
+			break;
+	}
+	if (edev)
+		put_device(&edev->edev);
+}
+
+static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = to_scsi_device(cdev->parent);
 	struct enclosure_device *edev;
 	struct ses_device *ses_dev;
 
-	if (!scsi_device_enclosure(sdev))
-		return;
-
 	/*  exact match to this enclosure */
-	edev = enclosure_find(cdev->parent, NULL);
+	edev = enclosure_find(&sdev->sdev_gendev, NULL);
 	if (!edev)
 		return;
 
@@ -645,6 +653,17 @@ static void ses_intf_remove(struct device *cdev,
 	enclosure_unregister(edev);
 }
 
+static void ses_intf_remove(struct device *cdev,
+			    struct class_interface *intf)
+{
+	struct scsi_device *sdev = to_scsi_device(cdev->parent);
+
+	if (!scsi_device_enclosure(sdev))
+		ses_intf_remove_component(sdev);
+	else
+		ses_intf_remove_enclosure(sdev);
+}
+
 static struct class_interface ses_interface = {
 	.add_dev	= ses_intf_add,
 	.remove_dev	= ses_intf_remove,
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index d77811e..90d1c21 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -122,7 +122,7 @@ enclosure_component_register(struct enclosure_device *, unsigned int,
 				 enum enclosure_component_type, const char *);
 int enclosure_add_device(struct enclosure_device *enclosure, int component,
 			 struct device *dev);
-int enclosure_remove_device(struct enclosure_device *enclosure, int component);
+int enclosure_remove_device(struct enclosure_device *, struct device *);
 struct enclosure_device *enclosure_find(struct device *dev,
 					struct enclosure_device *start);
 int enclosure_for_each_device(int (*fn)(struct enclosure_device *, void *),
-- 
1.6.3.3



