From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] scsi: Add VPD helper
Date: Wed, 31 Dec 2008 13:12:46 -0500
Message-ID: <1230747167-31677-1-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-noauth6.primus.ca ([216.254.180.37]:37742 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752260AbYLaTNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 14:13:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Based on prior work by Martin Petersen and James Bottomley, this patch
adds a generic helper for retrieving VPD pages from SCSI devices.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/scsi.c        |  104 ++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |    1 +
 2 files changed, 105 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f8b79d4..46b7942 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -971,6 +971,110 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 EXPORT_SYMBOL(scsi_track_queue_full);
 
 /**
+ * scsi_vpd_inquiry - Request a device provide us with a VPD page
+ * @sdev: The device to ask
+ * @buffer: Where to put the result
+ * @page: Which Vital Product Data to return
+ * @len: The length of the buffer
+ *
+ * This is an internal helper function.  You probably want to use
+ * scsi_get_vpd_page instead.
+ *
+ * Returns 0 on success or a negative error number.
+ */
+static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
+							u8 page, unsigned len)
+{
+	int result;
+	unsigned char cmd[16];
+
+	cmd[0] = INQUIRY;
+	cmd[1] = 1;		/* EVPD */
+	cmd[2] = page;
+	cmd[3] = len >> 8;
+	cmd[4] = len & 0xff;
+	cmd[5] = 0;		/* Control byte */
+
+	/*
+	 * I'm not convinced we need to try quite this hard to get VPD, but
+	 * all the existing users tried this hard.
+	 */
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
+				  len + 4, NULL, 30 * HZ, 3, NULL);
+	if (result)
+		return result;
+
+	/* Sanity check that we got the page back that we asked for */
+	if (buffer[1] != page)
+		return -EIO;
+
+	return 0;
+}
+
+/**
+ * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
+ * @sdev: The device to ask
+ * @page: Which Vital Product Data to return
+ *
+ * SCSI devices may optionally supply Vital Product Data.  Each 'page'
+ * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
+ * If the device supports this VPD page, this routine returns a pointer
+ * to a buffer containing the data from that page.  The caller is
+ * responsible for calling kfree() on this pointer when it is no longer
+ * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
+ */
+unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
+{
+	int i, result;
+	unsigned int len;
+	unsigned char *buf = kmalloc(259, GFP_KERNEL);
+
+	if (!buf)
+		return NULL;
+
+	/* Ask for all the pages supported by this device */ 
+	result = scsi_vpd_inquiry(sdev, buf, 0, 255);
+	if (result)
+		goto fail;
+
+	/* If the user actually wanted this page, we can skip the rest */
+	if (page == 0)
+		return buf;
+
+	for (i = 0; i < buf[3]; i++)
+		if (buf[i + 4] == page)
+			goto found;
+	/* The device claims it doesn't support the requested page */
+	goto fail;
+
+ found:
+	result = scsi_vpd_inquiry(sdev, buf, page, 255);
+	if (result)
+		goto fail;
+
+	/*
+	 * Some pages are longer than 255 bytes.  The actual length of
+	 * the page is returned in the header.
+	 */
+	len = (buf[2] << 8) | buf[3];
+	if (len <= 255)
+		return buf;
+
+	kfree(buf);
+	buf = kmalloc(len + 4, GFP_KERNEL);
+	result = scsi_vpd_inquiry(sdev, buf, page, len);
+	if (result)
+		goto fail;
+
+	return buf;
+
+ fail:
+	kfree(buf);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
+
+/**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 01a4c58..9576690 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -340,6 +340,7 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
+extern unsigned char *scsi_get_vpd_page(struct scsi_device *, u8 page);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
1.5.6.5

