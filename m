From: Song Liu <songliubraving@fb.com>
Subject: [PATCH RESEND 5/5] SES: Add power_status to SES enclosure component
Date: Sat, 6 Dec 2014 00:27:09 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBCC5C4B@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20494 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbaLFA1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 19:27:35 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>

Add power_status to SES enclosure component, so we can power on/off the HDDs behind the enclosure.

Check firmware status in ses_set_* before sending control pages to firmware.

Signed-off-by: Song Liu <songliubraving@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 38 ++++++++++++++++++
 drivers/scsi/ses.c        | 98 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/enclosure.h |  6 +++
 3 files changed, 133 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c index 2e3eafa..819f2f2 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -148,6 +148,7 @@ enclosure_register(struct device *dev, const char *name, int components,
 	for (i = 0; i < components; i++) {
 		edev->component[i].number = -1;
 		edev->component[i].slot = -1;
+		edev->component[i].power_status = 1;
 	}
 
 	mutex_lock(&container_list_lock);
@@ -546,6 +547,40 @@ static ssize_t set_component_locate(struct device *cdev,
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
+	return snprintf(buf, 40, "%s\n", ecomp->power_status ? "on" : "off"); 
+}
+
+static ssize_t set_component_power_status(struct device *cdev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
+	struct enclosure_component *ecomp = to_enclosure_component(cdev);
+	int val;
+
+	if (strncmp(buf, "on", 2) == 0 &&
+	    (buf[2] == '\n' || buf[2] == '\0'))
+		val = 1;
+	else if (strncmp(buf, "off", 3) == 0 &&
+	    (buf[3] == '\n' || buf[3] == '\0'))
+		val = 0;
+	else
+		return -EINVAL;
+
+	if (edev->cb->set_power_status)
+		edev->cb->set_power_status(edev, ecomp, val);
+	return count;
+}
+
 static ssize_t get_component_type(struct device *cdev,
 				  struct device_attribute *attr, char *buf)  { @@ -577,6 +612,8 @@ static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
 		   set_component_active);
 static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
 		   set_component_locate);
+static DEVICE_ATTR(power_status, S_IRUGO | S_IWUSR, get_component_power_status,
+		   set_component_power_status);
 static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);  static DEVICE_ATTR(slot, S_IRUGO, get_component_slot, NULL);
 
@@ -585,6 +622,7 @@ static struct attribute *enclosure_component_attrs[] = {
 	&dev_attr_status.attr,
 	&dev_attr_active.attr,
 	&dev_attr_locate.attr,
+	&dev_attr_power_status.attr,
 	&dev_attr_type.attr,
 	&dev_attr_slot.attr,
 	NULL
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index 3e59a5d..8ba3c78 100644
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
@@ -449,6 +528,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 					ecomp = &edev->component[components++];
 
 				if (!IS_ERR(ecomp)) {
+					ses_get_power_status(edev, ecomp);
 					if (addl_desc_ptr)
 						ses_process_descriptor(
 							ecomp,
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

