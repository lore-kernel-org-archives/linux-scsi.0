From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/5] ses: close potential registration race
Date: Tue, 30 Dec 2014 14:46:14 -0800
Message-ID: <1419979578-3793574-2-git-send-email-songliubraving@fb.com>
References: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63186 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128AbaL3Wq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2014 17:46:59 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBUMkwET015755
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:46:59 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1rkxvpgv7j-3
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:46:59 -0800
Received: from facebook.com (2401:db00:20:701c:face:0:3f:0)	by
 mx-out.facebook.com (10.212.236.89) with ESMTP	id
 b525152e907511e4a00f0002c95209d8-5bddb390 for <linux-scsi@vger.kernel.org>;
	Tue, 30 Dec 2014 14:46:35 -0800
In-Reply-To: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, hare@suse.de, dgilbert@interlog.com, Dan Williams <dan.j.williams@intel.com>, Song Liu <songliubraving@fb.com>

From: Dan Williams <dan.j.williams@intel.com>

The slot and address fields have a small window of instability when
userspace can read them before initialization. Separate
enclosure_component
allocation from registration.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 35 +++++++++++++++++++++++++----------
 drivers/scsi/ses.c        | 21 ++++++++++++++-------
 include/linux/enclosure.h |  5 +++--
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 180a544..d566f0f 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -273,23 +273,22 @@ enclosure_component_find_by_name(struct enclosure_device *edev,
 static const struct attribute_group *enclosure_component_groups[];
 
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
+ * The name is optional for enclosures that give their components a unique
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
@@ -327,14 +326,30 @@ enclosure_component_register(struct enclosure_device *edev,
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
+ * Returns 0 on successful registration, releases the component otherwise
+ */
+int enclosure_component_register(struct enclosure_component *ecomp)
+{
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
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index b7e79e7..7dd9cf5 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -423,16 +423,23 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE) {
 
 				if (create)
-					ecomp =	enclosure_component_register(edev,
-									     components++,
-									     type_ptr[0],
-									     name);
+					ecomp =	enclosure_component_alloc(
+						edev,
+						components++,
+						type_ptr[0],
+						name);
 				else
 					ecomp = &edev->component[components++];
 
-				if (!IS_ERR(ecomp) && addl_desc_ptr)
-					ses_process_descriptor(ecomp,
-							       addl_desc_ptr);
+				if (!IS_ERR(ecomp)) {
+					if (addl_desc_ptr)
+						ses_process_descriptor(
+							ecomp,
+							addl_desc_ptr);
+					if (create)
+						enclosure_component_register(
+							ecomp);
+				}
 			}
 			if (desc_ptr)
 				desc_ptr += len;
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 9a33c5f..a835d33 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -120,8 +120,9 @@ enclosure_register(struct device *, const char *, int,
 		   struct enclosure_component_callbacks *);
 void enclosure_unregister(struct enclosure_device *);
 struct enclosure_component *
-enclosure_component_register(struct enclosure_device *, unsigned int,
-				 enum enclosure_component_type, const char *);
+enclosure_component_alloc(struct enclosure_device *, unsigned int,
+			  enum enclosure_component_type, const char *);
+int enclosure_component_register(struct enclosure_component *);
 int enclosure_add_device(struct enclosure_device *enclosure, int component,
 			 struct device *dev);
 int enclosure_remove_device(struct enclosure_device *, struct device *);
-- 
1.8.1

