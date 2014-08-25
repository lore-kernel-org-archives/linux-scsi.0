From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/5] SES: close potential registration race
Date: Mon, 25 Aug 2014 17:34:38 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABB1@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26278 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756306AbaHYReo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 13:34:44 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>

From: Song Liu [mailto:songliubraving@fb.com] 
Sent: Monday, August 25, 2014 10:26 AM
To: Song Liu
Cc: Dan Williams; Hannes Reinecke
Subject: [PATCH 1/5] SES: close potential registration race

From: Dan Williams <dan.j.williams@intel.com>

The slot and address fields have a small window of instability when userspace can read them before initialization. Separate enclosure_component allocation from registration.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 36 +++++++++++++++++++++++++-----------
 drivers/scsi/ses.c        | 18 +++++++++++-------
 include/linux/enclosure.h |  5 +++--
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c index 2cf2bbc..15faf61 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -249,27 +249,25 @@ static void enclosure_component_release(struct device *dev)  static const struct attribute_group *enclosure_component_groups[];
 
 /**
- * enclosure_component_register - add a particular component to an enclosure
+ * enclosure_component_alloc - prepare a new enclosure component
  * @edev:	the enclosure to add the component
  * @num:	the device number
  * @type:	the type of component being added
  * @name:	an optional name to appear in sysfs (leave NULL if none)
  *
- * Registers the component.  The name is optional for enclosures that
- * give their components a unique name.  If not, leave the field NULL
- * and a name will be assigned.
+ * The name is optional for enclosures that give their components a 
+ unique
+ * name.  If not, leave the field NULL and a name will be assigned.
  *
  * Returns a pointer to the enclosure component or an error.
  */
 struct enclosure_component *
-enclosure_component_register(struct enclosure_device *edev,
-			     unsigned int number,
-			     enum enclosure_component_type type,
-			     const char *name)
+enclosure_component_alloc(struct enclosure_device *edev,
+			  unsigned int number,
+			  enum enclosure_component_type type,
+			  const char *name)
 {
 	struct enclosure_component *ecomp;
 	struct device *cdev;
-	int err;
 
 	if (number >= edev->components)
 		return ERR_PTR(-EINVAL);
@@ -291,14 +289,30 @@ enclosure_component_register(struct enclosure_device *edev,
 	cdev->release = enclosure_component_release;
 	cdev->groups = enclosure_component_groups;
 
+	return ecomp;
+}
+EXPORT_SYMBOL_GPL(enclosure_component_alloc);
+
+/**
+ * enclosure_component_register - publishes an initialized enclosure component
+ * @ecomp:	component to add
+ *
+ * Returns 0 on successful registration, releases the component 
+otherwise  */ int enclosure_component_register(struct 
+enclosure_component *ecomp) {
+	struct device *cdev;
+	int err;
+
+	cdev = &ecomp->cdev;
 	err = device_register(cdev);
 	if (err) {
 		ecomp->number = -1;
 		put_device(cdev);
-		return ERR_PTR(err);
+		return err;
 	}
 
-	return ecomp;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(enclosure_component_register);
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index 80bfece..c2e8a98 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -423,16 +423,20 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
 
 				if (create)
-					ecomp =	enclosure_component_register(edev,
-									     components++,
-									     type_ptr[0],
-									     name);
+					ecomp =	enclosure_component_alloc(edev,
+									  components++,
+									  type_ptr[0],
+									  name);
 				else
 					ecomp = &edev->component[components++];
 
-				if (!IS_ERR(ecomp) && addl_desc_ptr)
-					ses_process_descriptor(ecomp,
-							       addl_desc_ptr);
+				if (!IS_ERR(ecomp)) {
+					if (addl_desc_ptr)
+						ses_process_descriptor(ecomp,
+								       addl_desc_ptr);
+					if (create)
+						enclosure_component_register(ecomp);
+				}
 			}
 			if (desc_ptr)
 				desc_ptr += len;
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h index 9a33c5f..a835d33 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -120,8 +120,9 @@ enclosure_register(struct device *, const char *, int,
 		   struct enclosure_component_callbacks *);  void enclosure_unregister(struct enclosure_device *);  struct enclosure_component * -enclosure_component_register(struct enclosure_device *, unsigned int,
-				 enum enclosure_component_type, const char *);
+enclosure_component_alloc(struct enclosure_device *, unsigned int,
+			  enum enclosure_component_type, const char *); int 
+enclosure_component_register(struct enclosure_component *);
 int enclosure_add_device(struct enclosure_device *enclosure, int component,
 			 struct device *dev);
 int enclosure_remove_device(struct enclosure_device *, struct device *);
--
1.8.1

