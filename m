From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/5] SES: add enclosure logical id
Date: Mon, 25 Aug 2014 17:34:41 +0000
Message-ID: <C709E4D363AAB64590BFAC54D4C478AAEBC4ABC4@PRN-MBX02-4.TheFacebook.com>
References: <1408987546-2418-1-git-send-email-songliubraving@fb.com>
 <1408987546-2418-4-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11376 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933017AbaHYRjr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2014 13:39:47 -0400
In-Reply-To: <1408987546-2418-4-git-send-email-songliubraving@fb.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>

From: Song Liu [mailto:songliubraving@fb.com] 
Sent: Monday, August 25, 2014 10:26 AM
To: Song Liu
Cc: Dan Williams; Hannes Reinecke
Subject: [PATCH 3/5] SES: add enclosure logical id

From: Dan Williams <dan.j.williams@intel.com>

Export the NAA logical id for the enclosure.  This is optionally available from the sas_transport_class, but it is really a property of the enclosure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 13 +++++++++++++
 drivers/scsi/ses.c        |  9 +++++++++
 include/linux/enclosure.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c index 15faf61..646068a 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -395,8 +395,21 @@ static ssize_t components_show(struct device *cdev,  }  static DEVICE_ATTR_RO(components);
 
+static ssize_t id_show(struct device *cdev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev);
+
+	if (edev->cb->show_id)
+		return edev->cb->show_id(edev, buf);
+	return 0;
+}
+static DEVICE_ATTR_RO(id);
+
 static struct attribute *enclosure_class_attrs[] = {
 	&dev_attr_components.attr,
+	&dev_attr_id.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(enclosure_class);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c index 8f0a62a..61deb4e 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -258,6 +258,14 @@ static int ses_set_active(struct enclosure_device *edev,
 	return ses_set_page2_descriptor(edev, ecomp, desc);  }
 
+static int ses_show_id(struct enclosure_device *edev, char *buf) {
+	struct ses_device *ses_dev = edev->scratch;
+	unsigned long long id = get_unaligned_be64(ses_dev->page1+8+4);
+
+	return sprintf(buf, "%#llx\n", id);
+}
+
 static struct enclosure_component_callbacks ses_enclosure_callbacks = {
 	.get_fault		= ses_get_fault,
 	.set_fault		= ses_set_fault,
@@ -265,6 +273,7 @@ static struct enclosure_component_callbacks ses_enclosure_callbacks = {
 	.get_locate		= ses_get_locate,
 	.set_locate		= ses_set_locate,
 	.set_active		= ses_set_active,
+	.show_id		= ses_show_id,
 };
 
 struct ses_host_edev {
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h index a835d33..807622b 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -79,6 +79,7 @@ struct enclosure_component_callbacks {
 	int (*set_locate)(struct enclosure_device *,
 			  struct enclosure_component *,
 			  enum enclosure_component_setting);
+	int (*show_id)(struct enclosure_device *, char *buf);
 };
 
 
--
1.8.1

