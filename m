From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 5/5] SES: Add power_status to SES enclosure component
Date: Mon, 25 Aug 2014 17:34:44 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABD3@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
 <1408987546-2418-6-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43551 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756317AbaHYReu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 13:34:50 -0400
In-Reply-To: <1408987546-2418-6-git-send-email-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>

From: Song Liu [mailto:songliubraving@fb.com] 
Sent: Monday, August 25, 2014 10:26 AM
To: Song Liu
Cc: Hannes Reinecke
Subject: [PATCH 5/5] SES: Add power_status to SES enclosure component

Add power_status to SES enclosure component, so we can power on/off the HDDs behind the enclosure.

Check firmware status in ses_set_* before sending control pages to firmware.

Signed-off-by: Song Liu <songliubraving@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 29 ++++++++++++++
 drivers/scsi/ses.c        | 98 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/enclosure.h |  6 +++
 3 files changed, 124 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c index de335bc..0331dfe 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -148,6 +148,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	for (i = 0; i < components; i++) {
 		edev->component[i].number = -1;
 		edev->component[i].slot = -1;
+		edev->component[i].power_status = 1;
 	}
 
 	mutex_lock(&container_list_lock);
@@ -546,6 +547,31 @@ static ssize_t set_component_locate(struct device *cdev,
 	return count;
 }
 
+static ssize_t get_component_power_status(struct device *cdev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp = to_enclosure_component(cdev);
+
+	if (edev->cb->get_power_status)
+		edev->cb->get_power_status(edev, ecomp);
+	return snprintf(buf, 40, "%d\n", ecomp->power_status); }
+
+static ssize_t set_component_power_status(struct device *cdev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp = to_enclosure_component(cdev);
+	int val = simple_strtoul(buf, NULL, 0);
+
+	if (edev->cb->set_power_status)
+		edev->cb->set_power_status(edev, ecomp, val);
+	return count;
+}
+
 static ssize_t get_component_type(struct device *cdev,
 				  struct device_attribute *attr, char *buf)  { @@ -577,6 +603,8 @@ static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
 		   set_component_active);
 static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
 		   set_component_locate);
+static DEVICE_ATTR(power_status, S_IRUGO | S_IWUSR, get_component_power_status,
+		   set_component_power_status);
 static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);  static DEVICE_ATTR(slot, S_IRUGO, get_component_slot, NULL);
 
@@ -585,6 +613,7 @@ static struct attribute *enclosure_component_attrs[] = {
 	&dev_attr_status.attr,
 	&dev_attr_active.attr,
 	&dev_attr_locate.attr,
+	&dev_attr_power_status.attr,
 	&dev_attr_type.attr,
 	&dev_attr_slot.attr,
 	NULL
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index bafa301..ea6b262 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -67,6 +67,20 @@ static int ses_probe(struct device *dev)  #define SES_TIMEOUT (30 * HZ)  #define SES_RETRIES 3
 
+static void init_device_slot_control(unsigned char *dest_desc,
+				     struct enclosure_component *ecomp,
+				     unsigned char *status)
+{
+	memcpy(dest_desc, status, 4);
+	dest_desc[0] = 0;
+	/* only clear byte 1 for ENCLOSURE_COMPONENT_DEVICE */
+	if (ecomp->type == ENCLOSURE_COMPONENT_DEVICE)
+		dest_desc[1] = 0;
+	dest_desc[2] &= 0xde;
+	dest_desc[3] &= 0x3c;
+}
+
+
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
 {
@@ -178,14 +192,22 @@ static int ses_set_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp,
 			 enum enclosure_component_setting val)  {
-	unsigned char desc[4] = {0 };
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
+ 
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
 
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
-		/* zero is disabled */
+		desc[3] &= 0xdf;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[3] = 0x20;
+		desc[3] |= 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */ @@ -219,14 +241,22 @@ static int ses_set_locate(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp,
 			  enum enclosure_component_setting val)  {
-	unsigned char desc[4] = {0 };
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+ 
+	init_device_slot_control(desc, ecomp, desc_ptr);
 
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
-		/* zero is disabled */
+		desc[2] &= 0xfd;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x02;
+		desc[2] |= 0x02;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */ @@ -239,15 +269,23 @@ static int ses_set_active(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp,
 			  enum enclosure_component_setting val)  {
-	unsigned char desc[4] = {0 };
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+ 
+	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
 
 	switch (val) {
 	case ENCLOSURE_SETTING_DISABLED:
-		/* zero is disabled */
+		desc[2] &= 0x7f;
 		ecomp->active = 0;
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x80;
+		desc[2] |= 0x80;
 		ecomp->active = 1;
 		break;
 	default:
@@ -265,12 +303,53 @@ static int ses_show_id(struct enclosure_device *edev, char *buf)
 	return sprintf(buf, "%#llx\n", id);
 }
 
+static void ses_get_power_status(struct enclosure_device *edev,
+				 struct enclosure_component *ecomp) {
+	unsigned char *desc;
+
+	desc = ses_get_page2_descriptor(edev, ecomp);
+	if (desc)
+		ecomp->power_status = (desc[3] & 0x10) ? 0 : 1; }
+
+static int ses_set_power_status(struct enclosure_device *edev,
+				struct enclosure_component *ecomp,
+				int val)
+{
+	unsigned char desc[4];
+	unsigned char *desc_ptr;
+
+	desc_ptr = ses_get_page2_descriptor(edev, ecomp);
+
+	if (!desc_ptr)
+		return -EIO;
+
+	init_device_slot_control(desc, ecomp, desc_ptr);
+
+	switch (val) {
+	/* power = 1 is device_off = 0 and vice versa */
+	case 0:
+		desc[3] |= 0x10;
+		break;
+	case 1:
+		desc[3] &= 0xef;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ecomp->power_status = val;
+	return ses_set_page2_descriptor(edev, ecomp, desc); }
+
 static struct enclosure_component_callbacks ses_enclosure_callbacks = {
 	.get_fault		= ses_get_fault,
 	.set_fault		= ses_set_fault,
 	.get_status		= ses_get_status,
 	.get_locate		= ses_get_locate,
 	.set_locate		= ses_set_locate,
+	.get_power_status	= ses_get_power_status,
+	.set_power_status	= ses_set_power_status,
 	.set_active		= ses_set_active,
 	.show_id		= ses_show_id,
 };
@@ -448,6 +527,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 					ecomp = &edev->component[components++];
 
 				if (!IS_ERR(ecomp)) {
+					ses_get_power_status(edev, ecomp);
 					if (addl_desc_ptr)
 						ses_process_descriptor(ecomp,
 								       addl_desc_ptr);
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h index 0f826c1..7be22da 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -79,6 +79,11 @@ struct enclosure_component_callbacks {
 	int (*set_locate)(struct enclosure_device *,
 			  struct enclosure_component *,
 			  enum enclosure_component_setting);
+	void (*get_power_status)(struct enclosure_device *,
+				 struct enclosure_component *);
+	int (*set_power_status)(struct enclosure_device *,
+				struct enclosure_component *,
+				int);
 	int (*show_id)(struct enclosure_device *, char *buf);  };
 
@@ -94,6 +99,7 @@ struct enclosure_component {
 	int locate;
 	int slot;
 	enum enclosure_status status;
+	int power_status;
 };
 
 struct enclosure_device {
--
1.8.1

