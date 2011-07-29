From: Ankit Jain <jankit@suse.de>
Subject: [PATCH v2] ses: Handle non-unique element descriptors
Date: Fri, 29 Jul 2011 16:32:42 +0530
Message-ID: <4E329352.1060208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab1G2LAd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 07:00:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>

Some SES devices give non-unique Element Descriptors as part of the
Element Descriptor diag page. Since we use these for creating sysfs
entries, they need to be unique. The specification doesn't require
these to be unique.

Eg:
$ sg_ses -p 7 /dev/sg0
  FTS CORP  TXS6_SAS20BPX12   0500
    enclosure services device
Element descriptor In diagnostic page:
  generation code: 0x0
  element descriptor by type list
    Element type: Array device, subenclosure id: 0
      Overall descriptor: ArrayDevicesInSubEnclsr0
      Element 1 descriptor: ArrayDevice00
      Element 2 descriptor: ArrayDevice01
      Element 3 descriptor: ArrayDevice02
      Element 4 descriptor: ArrayDevice03
      Element 5 descriptor: ArrayDevice03
      Element 6 descriptor: ArrayDevice03
      Element 7 descriptor: ArrayDevice03
      Element 8 descriptor: ArrayDevice03
      Element 9 descriptor: ArrayDevice03
      Element 10 descriptor: ArrayDevice03
      Element 11 descriptor: ArrayDevice03
      Element 12 descriptor: ArrayDevice03

Changes in v2:
- Based on James' comments, in case of a non-unique name, it gets
  named <elem_desc>_<elem_number>.

Based on scsi-misc

Signed-off-by: Ankit Jain <jankit@suse.de>

---
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fcac8..f4b53fd 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -239,6 +239,23 @@ static void enclosure_component_release(struct device *dev)
 	put_device(dev->parent);
 }
 
+static struct enclosure_component *
+enclosure_component_find_by_name(struct enclosure_device *edev,
+				const char *name)
+{
+	int i;
+	if (!edev || !name || !name[0])
+		return NULL;
+
+	for (i=0; i<edev->components; i++) {
+		struct enclosure_component *ecomp = &edev->component[i];
+		if (ecomp->number != -1 && !strcmp(dev_name(&ecomp->cdev), name))
+			return ecomp;
+	}
+
+	return NULL;
+}
+
 static const struct attribute_group *enclosure_groups[];
 
 /**
@@ -276,9 +293,13 @@ enclosure_component_register(struct enclosure_device *edev,
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name && name[0])
-		dev_set_name(cdev, "%s", name);
-	else
+
+	if (name && name[0]) {
+		if (enclosure_component_find_by_name (edev, name))
+			dev_set_name(cdev, "%s_%u", name, number);
+		else
+			dev_set_name(cdev, "%s", name);
+	} else
 		dev_set_name(cdev, "%u", number);
 
 	cdev->release = enclosure_component_release;
-- 
Ankit Jain
SUSE Labs
