From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 3/5] ses: add enclosure logical id
Date: Tue, 30 Dec 2014 14:46:16 -0800
Message-ID: <1419979578-3793574-4-git-send-email-songliubraving@fb.com>
References: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11507 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbaL3Wqj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2014 17:46:39 -0500
Received: from pps.filterd (m0004346 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBUMiW9Y005470
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:46:38 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1rkvwt94w3-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2014 14:46:38 -0800
Received: from facebook.com (2401:db00:20:701c:face:0:3f:0)	by
 mx-out.facebook.com (10.212.236.87) with ESMTP	id
 b53cc6ce907511e48bdc0002c9521c9e-810ee390 for <linux-scsi@vger.kernel.org>;
	Tue, 30 Dec 2014 14:46:35 -0800
In-Reply-To: <1419979578-3793574-1-git-send-email-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, hare@suse.de, dgilbert@interlog.com, Dan Williams <dan.j.williams@intel.com>, Song Liu <songliubraving@fb.com>

From: Dan Williams <dan.j.williams@intel.com>

Export the NAA logical id for the enclosure.  This is optionally
available from the sas_transport_class, but it is really a property of
the enclosure.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/misc/enclosure.c  | 13 +++++++++++++
 drivers/scsi/ses.c        |  9 +++++++++
 include/linux/enclosure.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index d566f0f..ab4de85 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -432,8 +432,21 @@ static ssize_t components_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(components);
 
+static ssize_t id_show(struct device *cdev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct enclosure_device *edev = to_enclosure_device(cdev);
+
+	if (edev->cb->show_id)
+		return edev->cb->show_id(edev, buf);
+	return -EINVAL;
+}
+static DEVICE_ATTR_RO(id);
+
 static struct attribute *enclosure_class_attrs[] = {
 	&dev_attr_components.attr,
+	&dev_attr_id.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(enclosure_class);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 6662b0c..1041556 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -258,6 +258,14 @@ static int ses_set_active(struct enclosure_device *edev,
 	return ses_set_page2_descriptor(edev, ecomp, desc);
 }
 
+static int ses_show_id(struct enclosure_device *edev, char *buf)
+{
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
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index a835d33..807622b 100644
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

