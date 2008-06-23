From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 3/4] scsi_get_vpd_page
Date: Mon, 23 Jun 2008 09:17:12 -0600
Message-ID: <20080623151712.GF4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58726 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbYFWPRN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 11:17:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Based on prior work by Martin Petersen and James Bottomley, this patch
adds a generic helper for retrieving VPD pages from SCSI devices within
the kernel.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 110e776..7e95626 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -972,6 +972,100 @@ int scsi_track_queue_full(struct scsi_device *sdev, int depth)
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
+ * Returns 0 on success and -EIO if an error occurs.
+ */
+static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
+							u8 page, u16 len)
+{
+	int result;
+	unsigned char cmd[16];
+
+	cmd[0] = INQUIRY;
+	cmd[1] = 1;		/* EVPD */
+	cmd[2] = page;
+	scsi_put_u16(len, &cmd[3]);
+	cmd[5] = 0;		/* Control byte */
+
+	/*
+	 * I'm not convinced we need to try quite this hard to get VPD, but
+	 * all the existing users tried this hard.
+	 */
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
+				  len, NULL, 30 * HZ, 3);
+	if (result)
+		return -EIO;
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
+ * @buffer: Where to put the result
+ * @page: Which Vital Product Data to return
+ * @len: The length of the buffer
+ *
+ * SCSI devices may optionally supply Vital Product Data.  Each 'page'
+ * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
+ * This routine returns 0 on success and fills in the buffer with up to
+ * 'len' bytes of data returned from the device.  If the device fails to
+ * respond to the request, or returns invalid data, this routine returns
+ * -EIO.  If the device does not provide this kind of VPD, this routine
+ * returns -ENOTTY.
+ */
+int scsi_get_vpd_page(struct scsi_device *sdev, unsigned char *buffer,
+							u8 page, u16 len)
+{
+	int i, result;
+	unsigned char *pages = NULL;
+
+	if (page == 0)
+		goto found;
+
+	if (len > 255) {
+		pages = buffer;
+	} else {
+		pages = kmalloc(256, GFP_KERNEL);
+		if (!pages)
+			return -ENOMEM;
+	}
+
+	/* Ask for all the pages supported by this device */ 
+	result = scsi_vpd_inquiry(sdev, pages, 0, 255);
+	if (result)
+		goto out;
+
+	for (i = 0; i < pages[3]; i++)
+		if (pages[i + 4] == page)
+			goto found;
+
+	result = -ENOTTY;
+	goto out;
+
+ found:
+	result = scsi_vpd_inquiry(sdev, buffer, page, len);
+
+ out:
+	if (pages != buffer)
+		kfree(pages);
+	return result;
+}
+EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
+
+/**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6a9fe0..06382a1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -298,6 +298,8 @@ extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
+extern int scsi_get_vpd_page(struct scsi_device *, unsigned char *buf,
+				u8 page, u16 len);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
