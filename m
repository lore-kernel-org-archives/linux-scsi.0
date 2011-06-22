From: Ankit Jain <jankit@suse.de>
Subject: [PATCH v2] scsi_transport_spi: Export host width and HBA id
Date: Wed, 22 Jun 2011 18:44:10 +0530
Message-ID: <4E01EAA2.5010409@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595Ab1FVNMe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2011 09:12:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@parallels.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

This is a slightly updated version of the patch which Hannes had
posted earlier. This changes the host attr name from "width" to
"host_width", as there already exists an attribute named "width".

---
Currently it's impossible to find out if the host supports
wide SCSI unless you're committed to trawl through syslog.
And it's near impossible to find the actual HBA id, which
is settable for some SCSI HBAs (like aic7xxx).
So export them via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Ankit Jain <jankit@suse.de>

---
 drivers/scsi/scsi_transport_spi.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6.32-sle11-sp1/drivers/scsi/scsi_transport_spi.c
===================================================================
--- linux-2.6.32-sle11-sp1.orig/drivers/scsi/scsi_transport_spi.c
+++ linux-2.6.32-sle11-sp1/drivers/scsi/scsi_transport_spi.c
@@ -596,6 +596,28 @@ static DEVICE_ATTR(signalling, S_IRUGO,
 		   show_spi_host_signalling,
 		   store_spi_host_signalling);
 
+static ssize_t show_spi_host_width(struct device *cdev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+
+	return sprintf(buf, "%s\n", shost->max_id == 16 ? "wide" : "narrow");
+}
+static DEVICE_ATTR(host_width, S_IRUGO,
+		   show_spi_host_width, NULL);
+
+static ssize_t show_spi_host_hba_id(struct device *cdev,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);
+
+	return sprintf(buf, "%d\n", shost->this_id);
+}
+static DEVICE_ATTR(hba_id, S_IRUGO,
+		   show_spi_host_hba_id, NULL);
+
 #define DV_SET(x, y)			\
 	if(i->f->set_##x)		\
 		i->f->set_##x(sdev->sdev_target, y)
@@ -1379,6 +1401,8 @@ static DECLARE_ANON_TRANSPORT_CLASS(spi_
 
 static struct attribute *host_attributes[] = {
 	&dev_attr_signalling.attr,
+	&dev_attr_host_width.attr,
+	&dev_attr_hba_id.attr,
 	NULL
 };
 
-- 
Ankit Jain
SUSE Labs
