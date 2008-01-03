From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] attribute_container: update to use the group interface
Date: Wed, 02 Jan 2008 18:48:47 -0600
Message-ID: <1199321327.3258.97.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40340 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbYACAst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 19:48:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This patch is the beginning of moving the attribute_containers to use
attribute groups exclusively.  The attr element is now deprecated and
will eventually be removed (along with all the hand rolled code for
doing exactly what attribute groups do) when all the consumers are
converted to attribute groups.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

Would you believe this is another one I'd like to send via the SCSI tree?

James


 drivers/base/attribute_container.c  |   14 ++++++++++++--
 include/linux/attribute_container.h |    1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 7370d7c..5bf25c6 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -320,9 +320,14 @@ attribute_container_add_attrs(struct class_device *classdev)
 	struct class_device_attribute **attrs =	cont->attrs;
 	int i, error;
 
-	if (!attrs)
+	BUG_ON(attrs && cont->grp);
+
+	if (!attrs && !cont->grp)
 		return 0;
 
+	if (cont->grp)
+		return sysfs_create_group(&classdev->kobj, cont->grp);
+
 	for (i = 0; attrs[i]; i++) {
 		error = class_device_create_file(classdev, attrs[i]);
 		if (error)
@@ -378,9 +383,14 @@ attribute_container_remove_attrs(struct class_device *classdev)
 	struct class_device_attribute **attrs =	cont->attrs;
 	int i;
 
-	if (!attrs)
+	if (!attrs && !cont->grp)
 		return;
 
+	if (cont->grp) {
+		sysfs_remove_group(&classdev->kobj, cont->grp);
+		return ;
+	}
+
 	for (i = 0; attrs[i]; i++)
 		class_device_remove_file(classdev, attrs[i]);
 }
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index 8ff2749..f558233 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -17,6 +17,7 @@ struct attribute_container {
 	struct list_head	node;
 	struct klist		containers;
 	struct class		*class;
+	struct attribute_group	*grp;
 	struct class_device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);
 #define	ATTRIBUTE_CONTAINER_NO_CLASSDEVS	0x01
-- 
1.5.3.7



