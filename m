From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/2] usb-storage: add autosuspend support
Date: Mon, 3 Mar 2008 11:12:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803031109270.3611-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45996 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759537AbYCCQMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 11:12:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

This patch (as1043) implements autosuspend for usb-storage.  It relies
on an underlying SCSI dynamic PM implementation for generating
autosuspend and autoresume requests.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

I'm submitting this through the SCSI tree rather than the USB tree, 
because it depends so heavily on the previous SCSI dynamic PM patch.


Index: usb-2.6/drivers/usb/storage/usb.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/usb.c
+++ usb-2.6/drivers/usb/storage/usb.c
@@ -184,16 +184,22 @@ static int storage_suspend(struct usb_in
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
+	US_DEBUGP("%s\n", __FUNCTION__);
+
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+	/* Don't suspend if the host is still active */
+	if (iface->pm_usage_cnt > 0) {
+		US_DEBUGP("host is not suspended!\n");
+		return -EBUSY;
+	}
+#endif
+
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
 
-	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_SUSPEND);
 
-	/* When runtime PM is working, we'll set a flag to indicate
-	 * whether we should autoresume when a SCSI request arrives. */
-
 	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
@@ -202,13 +208,10 @@ static int storage_resume(struct usb_int
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
-	mutex_lock(&us->dev_mutex);
-
 	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
 
-	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
 
@@ -957,6 +960,9 @@ static int storage_probe(struct usb_inte
 		return -ENOMEM;
 	}
 
+	/* Don't autosuspend until the SCSI core tells us */
+	usb_autopm_get_interface(intf);
+
 	/*
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
@@ -1054,6 +1060,7 @@ static struct usb_driver usb_storage_dri
 	.pre_reset =	storage_pre_reset,
 	.post_reset =	storage_post_reset,
 	.id_table =	storage_usb_ids,
+	.supports_autosuspend = 1,
 };
 
 static int __init usb_stor_init(void)
Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -299,10 +299,15 @@ static int device_reset(struct scsi_cmnd
 
 	US_DEBUGP("%s called\n", __FUNCTION__);
 
-	/* lock the device pointers and do the reset */
-	mutex_lock(&(us->dev_mutex));
-	result = us->transport_reset(us);
-	mutex_unlock(&us->dev_mutex);
+	result = usb_autopm_get_interface(us->pusb_intf);
+	if (result == 0) {
+
+		/* lock the device pointers and do the reset */
+		mutex_lock(&(us->dev_mutex));
+		result = us->transport_reset(us);
+		mutex_unlock(&us->dev_mutex);
+		usb_autopm_put_interface(us->pusb_intf);
+	}
 
 	return result < 0 ? FAILED : SUCCESS;
 }
@@ -345,6 +350,32 @@ void usb_stor_report_bus_reset(struct us
 	scsi_unlock(host);
 }
 
+#ifdef CONFIG_SCSI_DYNAMIC_PM
+
+/* The host and its devices are all idle so we can autosuspend */
+static int us_autosuspend(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	usb_autopm_put_interface(us->pusb_intf);
+	return 0;
+}
+
+/* The host needs to be autoresumed */
+static int us_autoresume(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	return usb_autopm_get_interface(us->pusb_intf);
+}
+
+#else
+#define us_autosuspend		NULL
+#define us_autoresume		NULL
+
+#endif /* CONFIG_SCSI_DYNAMIC_PM */
+
+
 /***********************************************************************
  * /proc/scsi/ functions
  ***********************************************************************/
@@ -471,6 +502,10 @@ struct scsi_host_template usb_stor_host_
 	.eh_device_reset_handler =	device_reset,
 	.eh_bus_reset_handler =		bus_reset,
 
+	/* dynamic power management */
+	.autosuspend =			us_autosuspend,
+	.autoresume =			us_autoresume,
+
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
 	.cmd_per_lun =			1,

