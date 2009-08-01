From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: ses: update enclosure data on hot add
Date: Sat, 01 Aug 2009 00:43:59 +0000
Message-ID: <1249087439.3922.524.camel@mulgrave.site>
References: <4A71F4DF.1060600@arrisi.com>
	 <1248984308.3880.271.camel@mulgrave.site>
	 <1249087023.3922.503.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37568 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbZHAAoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2009 20:44:03 -0400
In-Reply-To: <1249087023.3922.503.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Ptacek <chris.ptacek@arrisi.com>
Cc: dave.romrell@arrisi.com, Michael Galassi <michael.galassi@arrisi.com>, linux-scsi <linux-scsi@vger.kernel.org>

Now that hot add works correctly, if a new device is added, we're still
operating on stale enclosure data, so fix that by updating the enclosure
diagnostic pages when we get notified of a device hot add

---
 drivers/misc/enclosure.c |    3 +
 drivers/scsi/ses.c       |  168 ++++++++++++++++++++++++++-------------------
 2 files changed, 100 insertions(+), 71 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 850706a..7b03930 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -315,6 +315,9 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 
 	cdev = &edev->component[component];
 
+	if (cdev->dev == dev)
+		return -EEXIST;
+
 	if (cdev->dev)
 		enclosure_remove_links(cdev);
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index be593c8..55b034b 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -347,6 +347,97 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	return 0;
 }
 
+#define INIT_ALLOC_SIZE 32
+
+static void ses_enclosure_data_process(struct enclosure_device *edev,
+				       struct scsi_device *sdev,
+				       int create)
+{
+	u32 result;
+	unsigned char *buf = NULL, *type_ptr, *desc_ptr, *addl_desc_ptr = NULL;
+	int i, j, page7_len, len, components;
+	struct ses_device *ses_dev = edev->scratch;
+	int types = ses_dev->page1[10];
+	unsigned char *hdr_buf = kzalloc(INIT_ALLOC_SIZE, GFP_KERNEL);
+
+	if (!hdr_buf)
+		goto simple_populate;
+
+	/* re-read page 10 */
+	if (ses_dev->page10)
+		ses_recv_diag(sdev, 10, ses_dev->page10, ses_dev->page10_len);
+	/* Page 7 for the descriptors is optional */
+	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
+	if (result)
+		goto simple_populate;
+
+	page7_len = len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
+	/* add 1 for trailing '\0' we'll use */
+	buf = kzalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		goto simple_populate;
+	result = ses_recv_diag(sdev, 7, buf, len);
+	if (result) {
+ simple_populate:
+		kfree(buf);
+		buf = NULL;
+		desc_ptr = NULL;
+		len = 0;
+		page7_len = 0;
+	} else {
+		desc_ptr = buf + 8;
+		len = (desc_ptr[2] << 8) + desc_ptr[3];
+		/* skip past overall descriptor */
+		desc_ptr += len + 4;
+		if (ses_dev->page10)
+			addl_desc_ptr = ses_dev->page10 + 8;
+	}
+	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
+	components = 0;
+	for (i = 0; i < types; i++, type_ptr += 4) {
+		for (j = 0; j < type_ptr[1]; j++) {
+			char *name = NULL;
+			struct enclosure_component *ecomp;
+
+			if (desc_ptr) {
+				if (desc_ptr >= buf + page7_len) {
+					desc_ptr = NULL;
+				} else {
+					len = (desc_ptr[2] << 8) + desc_ptr[3];
+					desc_ptr += 4;
+					/* Add trailing zero - pushes into
+					 * reserved space */
+					desc_ptr[len] = '\0';
+					name = desc_ptr;
+				}
+			}
+			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
+			    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
+
+				if (create)
+					ecomp =	enclosure_component_register(edev,
+									     components++,
+									     type_ptr[0],
+									     name);
+				else
+					ecomp = &edev->component[components++];
+
+				if (!IS_ERR(ecomp) && addl_desc_ptr)
+					ses_process_descriptor(ecomp,
+							       addl_desc_ptr);
+			}
+			if (desc_ptr)
+				desc_ptr += len;
+
+			if (addl_desc_ptr)
+				addl_desc_ptr += addl_desc_ptr[1] + 2;
+
+		}
+	}
+	kfree(buf);
+	kfree(hdr_buf);
+}
+
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
@@ -361,6 +452,8 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	if (!buf)
 		return;
 
+	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent), 0);
+
 	vpd_len = ((buf[2] << 8) | buf[3]) + 4;
 
 	desc = buf + 4;
@@ -395,18 +488,15 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	kfree(buf);
 }
 
-#define INIT_ALLOC_SIZE 32
-
 static int ses_intf_add(struct device *cdev,
 			struct class_interface *intf)
 {
 	struct scsi_device *sdev = to_scsi_device(cdev->parent);
 	struct scsi_device *tmp_sdev;
-	unsigned char *buf = NULL, *hdr_buf, *type_ptr, *desc_ptr = NULL,
-		*addl_desc_ptr = NULL;
+	unsigned char *buf = NULL, *hdr_buf, *type_ptr;
 	struct ses_device *ses_dev;
 	u32 result;
-	int i, j, types, len, page7_len = 0, components = 0;
+	int i, types, len, components = 0;
 	int err = -ENOMEM;
 	struct enclosure_device *edev;
 	struct ses_component *scomp = NULL;
@@ -501,6 +591,7 @@ static int ses_intf_add(struct device *cdev,
 		ses_dev->page10_len = len;
 		buf = NULL;
 	}
+	kfree(hdr_buf);
 
 	scomp = kzalloc(sizeof(struct ses_component) * components, GFP_KERNEL);
 	if (!scomp)
@@ -517,72 +608,7 @@ static int ses_intf_add(struct device *cdev,
 	for (i = 0; i < components; i++)
 		edev->component[i].scratch = scomp + i;
 
-	/* Page 7 for the descriptors is optional */
-	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
-	if (result)
-		goto simple_populate;
-
-	page7_len = len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
-	/* add 1 for trailing '\0' we'll use */
-	buf = kzalloc(len + 1, GFP_KERNEL);
-	if (!buf)
-		goto simple_populate;
-	result = ses_recv_diag(sdev, 7, buf, len);
-	if (result) {
- simple_populate:
-		kfree(buf);
-		buf = NULL;
-		desc_ptr = NULL;
-		addl_desc_ptr = NULL;
-	} else {
-		desc_ptr = buf + 8;
-		len = (desc_ptr[2] << 8) + desc_ptr[3];
-		/* skip past overall descriptor */
-		desc_ptr += len + 4;
-		if (ses_dev->page10)
-			addl_desc_ptr = ses_dev->page10 + 8;
-	}
-	type_ptr = ses_dev->page1 + 12 + ses_dev->page1[11];
-	components = 0;
-	for (i = 0; i < types; i++, type_ptr += 4) {
-		for (j = 0; j < type_ptr[1]; j++) {
-			char *name = NULL;
-			struct enclosure_component *ecomp;
-
-			if (desc_ptr) {
-				if (desc_ptr >= buf + page7_len) {
-					desc_ptr = NULL;
-				} else {
-					len = (desc_ptr[2] << 8) + desc_ptr[3];
-					desc_ptr += 4;
-					/* Add trailing zero - pushes into
-					 * reserved space */
-					desc_ptr[len] = '\0';
-					name = desc_ptr;
-				}
-			}
-			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
-			    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
-
-				ecomp =	enclosure_component_register(edev,
-							     components++,
-							     type_ptr[0],
-							     name);
-
-				if (!IS_ERR(ecomp) && addl_desc_ptr)
-					ses_process_descriptor(ecomp,
-							       addl_desc_ptr);
-			}
-			if (desc_ptr)
-				desc_ptr += len;
-
-			if (addl_desc_ptr)
-				addl_desc_ptr += addl_desc_ptr[1] + 2;
-
-		}
-	}
-	kfree(buf);
-	kfree(hdr_buf);
+	ses_enclosure_data_process(edev, sdev, 1);
 
 	/* see if there are any devices matching before
 	 * we found the enclosure */
-- 
1.6.3.3



