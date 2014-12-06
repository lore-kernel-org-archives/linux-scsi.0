From: Song Liu <songliubraving@fb.com>
Subject: [PATCH RESEND 4/5] SES: add reliable slot attribute
Date: Sat, 6 Dec 2014 00:27:07 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBCC5C2C@PRN-MBX02-4.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3767 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198AbaLFA1d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2014 19:27:33 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.de>, "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>

From: Dan Williams <dan.j.williams@intel.com>

The name provided by firmware is in a vendor specific format, publish the slot number to have a reliable mechanism for identifying slots across firmware implementations.  If the enclosure does not provide a slot number fallback to the component number which is guaranteed unique, and usually mirrors the slot number.

Cleaned up the unused ses_component.desc in the process.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 20 +++++++++++++++++++-
 drivers/scsi/ses.c        | 17 ++++++++++++-----
 include/linux/enclosure.h |  1 +
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c index 18b87de..2e3eafa 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -145,8 +145,10 @@ enclosure_register(struct device *dev, const char *name, int components,
 	if (err)
 		goto err;
 
-	for (i = 0; i < components; i++)
+	for (i = 0; i < components; i++) {
 		edev->component[i].number = -1;
+		edev->component[i].slot = -1;
+	}
 
 	mutex_lock(&container_list_lock);
 	list_add_tail(&edev->node, &container_list); @@ -552,6 +554,20 @@ static ssize_t get_component_type(struct device *cdev,
 	return snprintf(buf, 40, "%s\n", enclosure_type[ecomp->type]);  }
 
+static ssize_t get_component_slot(struct device *cdev,
+				  struct device_attribute *attr, char *buf) {
+	struct enclosure_component *ecomp = to_enclosure_component(cdev);
+	int slot;
+
+	/* if the enclosure does not override then use 'number' as a stand-in */
+	if (ecomp->slot >= 0)
+		slot = ecomp->slot;
+	else
+		slot = ecomp->number;
+
+	return snprintf(buf, 40, "%d\n", slot); }
 
 static DEVICE_ATTR(fault, S_IRUGO | S_IWUSR, get_component_fault,
 		    set_component_fault);
@@ -562,6 +578,7 @@ static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_component_active,  static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
 		   set_component_locate);
 static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);
+static DEVICE_ATTR(slot, S_IRUGO, get_component_slot, NULL);
 
 static struct attribute *enclosure_component_attrs[] = {
 	&dev_attr_fault.attr,
@@ -569,6 +586,7 @@ static struct attribute *enclosure_component_attrs[] = {
 	&dev_attr_active.attr,
 	&dev_attr_locate.attr,
 	&dev_attr_type.attr,
+	&dev_attr_slot.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(enclosure_component);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index 696d5d8..3e59a5d 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -47,7 +47,6 @@ struct ses_device {
 
 struct ses_component {
 	u64 addr;
-	unsigned char *desc;
 };
 
 static int ses_probe(struct device *dev) @@ -307,19 +306,26 @@ static void ses_process_descriptor(struct enclosure_component *ecomp,
 	int invalid = desc[0] & 0x80;
 	enum scsi_protocol proto = desc[0] & 0x0f;
 	u64 addr = 0;
+	int slot = -1;
 	struct ses_component *scomp = ecomp->scratch;
 	unsigned char *d;
 
-	scomp->desc = desc;
-
 	if (invalid)
 		return;
 
 	switch (proto) {
+	case SCSI_PROTOCOL_FCP:
+		if (eip) {
+			d = desc + 4;
+			slot = d[3];
+		}
+		break;
 	case SCSI_PROTOCOL_SAS:
-		if (eip)
+		if (eip) {
+			d = desc + 4;
+			slot = d[3];
 			d = desc + 8;
-		else
+		} else
 			d = desc + 4;
 		/* only take the phy0 addr */
 		addr = (u64)d[12] << 56 |
@@ -335,6 +341,7 @@ static void ses_process_descriptor(struct enclosure_component *ecomp,
 		/* FIXME: Need to add more protocols than just SAS */
 		break;
 	}
+	ecomp->slot = slot;
 	scomp->addr = addr;
 }
 
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h index 807622b..0f826c1 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -92,6 +92,7 @@ struct enclosure_component {
 	int fault;
 	int active;
 	int locate;
+	int slot;
 	enum enclosure_status status;
 };
 
--
1.8.1

