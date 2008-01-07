From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: [RFC] Autosuspend for usb-storage (based on SCSI dynamic PM)
Date: Mon, 7 Jan 2008 14:42:26 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801071438110.6739-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-pm mailing list <linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch implements autosuspend and autoresume for usb-storage.  It 
is based on the SCSI Dynamic PM patch just posted on linux-scsi and 
linux-pm.

Note: For testing, you will have to set the power/level attribute (and 
possibly also power/autosuspend) for both the SCSI device and the USB 
device.

Alan Stern



Index: usb-2.6/drivers/usb/storage/usb.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/usb.c
+++ usb-2.6/drivers/usb/storage/usb.c
@@ -184,16 +184,14 @@ static int storage_suspend(struct usb_in
 {
 	struct us_data *us = usb_get_intfdata(iface);
 
+	US_DEBUGP("%s\n", __FUNCTION__);
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
@@ -202,13 +200,10 @@ static int storage_resume(struct usb_int
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
 
@@ -928,6 +923,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	usb_autopm_put_interface(us->pusb_intf);
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -957,6 +953,9 @@ static int storage_probe(struct usb_inte
 		return -ENOMEM;
 	}
 
+	/* Don't autosuspend until the SCSI core tells us */
+	usb_autopm_get_interface(intf);
+
 	/*
 	 * Allow 16-byte CDBs and thus > 2TB
 	 */
@@ -1017,6 +1016,7 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
+	usb_autopm_get_interface(intf); /* dropped in the scanning thread */
 	wake_up_process(th);
 
 	return 0;
@@ -1054,6 +1054,7 @@ static struct usb_driver usb_storage_dri
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
@@ -295,10 +295,15 @@ static int device_reset(struct scsi_cmnd
 
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
@@ -341,6 +346,24 @@ void usb_stor_report_bus_reset(struct us
 	scsi_unlock(host);
 }
 
+/* The host and its devices are all idle so we can autosuspend */
+static int autosuspend(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	usb_autopm_put_interface(us->pusb_intf);
+	return 0;
+}
+
+/* The host needs to be autoresumed */
+static int autoresume(struct Scsi_Host *host)
+{
+	struct us_data *us = host_to_us(host);
+
+	return usb_autopm_get_interface(us->pusb_intf);
+}
+
+
 /***********************************************************************
  * /proc/scsi/ functions
  ***********************************************************************/
@@ -467,6 +490,10 @@ struct scsi_host_template usb_stor_host_
 	.eh_device_reset_handler =	device_reset,
 	.eh_bus_reset_handler =		bus_reset,
 
+	/* dynamic power management */
+	.autosuspend =			autosuspend,
+	.autoresume =			autoresume,
+
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
 	.cmd_per_lun =			1,


-
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
