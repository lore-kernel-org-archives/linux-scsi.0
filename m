From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_transport_spi: Export host width and HBA id
Date: Wed, 01 Jun 2011 15:18:48 +0200
Message-ID: <201106011318.p51DImMr003035@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54844 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1FANTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 09:19:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org


Currently it's impossible to find out if the host supports
wide SCSI unless you're committed to trawl through syslog.
And it's near impossible to find the actual HBA id, which
is settable for some SCSI HBAs (like aic7xxx).
So export them via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 8a172d4..f5a3a68 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -597,6 +597,28 @@ static DEVICE_ATTR(signalling, S_IRUGO,
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
+static DEVICE_ATTR(width, S_IRUGO,
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
@@ -1380,6 +1402,8 @@ static DECLARE_ANON_TRANSPORT_CLASS(spi_device_class,
 
 static struct attribute *host_attributes[] = {
 	&dev_attr_signalling.attr,
+	&dev_attr_width.attr,
+	&dev_attr_hba_id.attr,
 	NULL
 };
 
