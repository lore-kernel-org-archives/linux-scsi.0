From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 4/7] allow activation of eh on DID_NO_CONNECT
Date: Wed, 26 Nov 2008 19:26:57 +0100
Message-ID: <200811261926.57938.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:57790 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbYKZS1E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:27:04 -0500
In-Reply-To: <200811261840.45360.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Introduce a sysfs attribute to allow to activate the error handler for
these devices in case of DID_NO_CONNECT. This is useful for our parallel
scsi devices.

Signed-off-by: Bernd Schubert: <bs@q-leap.de>

---
 drivers/scsi/scsi_error.c  |    2 ++
 drivers/scsi/scsi_sysfs.c  |   28 ++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |    1 +
 3 files changed, 31 insertions(+)

Index: linux-2.6/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_device.h
+++ linux-2.6/include/scsi/scsi_device.h
@@ -145,6 +145,7 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned eh_did_no_connect:1;	/* eh on DID_NO_CONNECT */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c
+++ linux-2.6/drivers/scsi/scsi_error.c
@@ -1359,6 +1359,8 @@ int scsi_decide_disposition(struct scsi_
 		 */
 		break;
 	case DID_NO_CONNECT:
+		if (scmd->device->eh_did_no_connect)
+			return FAILED;
 	case DID_BAD_TARGET:
 	case DID_ABORT:
 		/*
Index: linux-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6/drivers/scsi/scsi_sysfs.c
@@ -565,6 +565,33 @@ sdev_rd_attr (rev, "%.4s\n");
  * TODO: can we make these symlinks to the block layer ones?
  */
 static ssize_t
+sdev_show_eh_dnc(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%d\n", sdev->eh_did_no_connect);
+}
+
+static ssize_t
+sdev_store_eh_dnc(struct device *dev, struct device_attribute *attr,
+		  const char *buf, size_t count)
+{
+	struct scsi_device *sdev;
+	int eh_dnc;
+	sdev = to_scsi_device(dev);
+	sscanf(buf, "%d\n", &eh_dnc);
+
+	if (eh_dnc != 0 && eh_dnc != 1)
+		return -EINVAL;
+
+	sdev->eh_did_no_connect = eh_dnc;
+	return count;
+}
+static DEVICE_ATTR(eh_did_no_connect, S_IRUGO | S_IWUSR,
+		   sdev_show_eh_dnc, sdev_store_eh_dnc);
+
+
+static ssize_t
 sdev_show_timeout (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev;
@@ -755,6 +782,7 @@ static struct attribute *scsi_sdev_attrs
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
 	REF_EVT(media_change),
+	&dev_attr_eh_did_no_connect,
 	NULL
 };
 


