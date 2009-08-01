From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] ses: fix hotplug with multiple devices and expanders
Date: Sat, 01 Aug 2009 00:39:36 +0000
Message-ID: <1249087176.3922.511.camel@mulgrave.site>
References: <4A71F4DF.1060600@arrisi.com>
	 <1248984308.3880.271.camel@mulgrave.site>
	 <1249087023.3922.503.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37544 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbZHAAjm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 20:39:42 -0400
In-Reply-To: <1249087023.3922.503.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Ptacek <chris.ptacek@arrisi.com>
Cc: dave.romrell@arrisi.com, Michael Galassi <michael.galassi@arrisi.com>, linux-scsi <linux-scsi@vger.kernel.org>

In a situation either with expanders or with multiple enclosure
devices, hot add doesn't always work.  This is because we try to find
a single enclosure device attached to the host.  Fix this by looping
over all enclosure devices attached to the host and also by making the
find loop recognise that the enclosure devices may be expander remote
(i.e. not parented by the host).
---
 drivers/misc/enclosure.c  |   44 ++++++++++++++++++++++++++++++++------------
 drivers/scsi/ses.c        |   10 ++++++----
 include/linux/enclosure.h |    3 ++-
 3 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 348443b..789d121 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -33,24 +33,44 @@ static DEFINE_MUTEX(container_list_lock);
 static struct class enclosure_class;
 
 /**
- * enclosure_find - find an enclosure given a device
- * @dev:	the device to find for
+ * enclosure_find - find an enclosure given a parent device
+ * @dev:	the parent to match against
+ * @start:	Optional enclosure device to start from (NULL if none)
  *
- * Looks through the list of registered enclosures to see
- * if it can find a match for a device.  Returns NULL if no
- * enclosure is found. Obtains a reference to the enclosure class
- * device which must be released with device_put().
+ * Looks through the list of registered enclosures to find all those
+ * with @dev as a parent.  Returns NULL if no enclosure is
+ * found. @start can be used as a starting point to obtain multiple
+ * enclosures per parent (should begin with NULL and then be set to
+ * each returned enclosure device). Obtains a reference to the
+ * enclosure class device which must be released with device_put().
+ * If @start is not NULL, a reference must be taken on it which is
+ * released before returning (this allows a loop through all
+ * enclosures to exit with only the reference on the enclosure of
+ * interest held).  Note that the @dev may correspond to the actual
+ * device housing the enclosure, in which case no iteration via @start
+ * is required.
  */
-struct enclosure_device *enclosure_find(struct device *dev)
+struct enclosure_device *enclosure_find(struct device *dev,
+					struct enclosure_device *start)
 {
 	struct enclosure_device *edev;
 
 	mutex_lock(&container_list_lock);
-	list_for_each_entry(edev, &container_list, node) {
-		if (edev->edev.parent == dev) {
-			get_device(&edev->edev);
-			mutex_unlock(&container_list_lock);
-			return edev;
+	edev = list_prepare_entry(start, &container_list, node);
+	if (start)
+		put_device(&start->edev);
+
+	list_for_each_entry_continue(edev, &container_list, node) {
+		struct device *parent = edev->edev.parent;
+		/* parent might not be immediate, so iterate up to
+		 * the root of the tree if necessary */
+		while (parent) {
+			if (parent == dev) {
+				get_device(&edev->edev);
+				mutex_unlock(&container_list_lock);
+				return edev;
+			}
+			parent = parent->parent;
 		}
 	}
 	mutex_unlock(&container_list_lock);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 4f618f4..e1b8c82 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -413,10 +413,11 @@ static int ses_intf_add(struct device *cdev,
 
 	if (!scsi_device_enclosure(sdev)) {
 		/* not an enclosure, but might be in one */
-		edev = enclosure_find(&sdev->host->shost_gendev);
-		if (edev) {
+		struct enclosure_device *prev = NULL;
+
+		while ((edev = enclosure_find(&sdev->host->shost_gendev, prev)) != NULL) {
 			ses_match_to_enclosure(edev, sdev);
-			put_device(&edev->edev);
+			prev = edev;
 		}
 		return -ENODEV;
 	}
@@ -625,7 +626,8 @@ static void ses_intf_remove(struct device *cdev,
 	if (!scsi_device_enclosure(sdev))
 		return;
 
-	edev = enclosure_find(cdev->parent);
+	/*  exact match to this enclosure */
+	edev = enclosure_find(cdev->parent, NULL);
 	if (!edev)
 		return;
 
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 4332442..d77811e 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -123,7 +123,8 @@ enclosure_component_register(struct enclosure_device *, unsigned int,
 int enclosure_add_device(struct enclosure_device *enclosure, int component,
 			 struct device *dev);
 int enclosure_remove_device(struct enclosure_device *enclosure, int component);
-struct enclosure_device *enclosure_find(struct device *dev);
+struct enclosure_device *enclosure_find(struct device *dev,
+					struct enclosure_device *start);
 int enclosure_for_each_device(int (*fn)(struct enclosure_device *, void *),
 			      void *data);
 
-- 
1.6.3.3



