From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down disk
Date: Thu, 27 Sep 2007 13:40:46 +0200
Message-ID: <200709271340.46496.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709251039550.3909-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:60849 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXI0Ljt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 07:39:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.0709251039550.3909-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Am Dienstag 25 September 2007 schrieb Alan Stern:
> Getting all this to work will be tricky, because sd is a block device
> driven by requests issued through the block layer in atomic context,
> whereas suspend and resume require a process context. =A0Probably the=
=20
> SCSI core would have to get involved in managing the synchronization.


Well,

here's a patch that seems to do what needs to be done to make it work.

	Regards
		Oliver

----

--- a/drivers/usb/storage/usb.c	2007-09-27 13:33:31.000000000 +0200
+++ b/drivers/usb/storage/usb.c	2007-09-27 13:30:21.000000000 +0200
@@ -182,33 +182,100 @@ static struct us_unusual_dev us_unusual_
=20
 static int storage_suspend(struct usb_interface *iface, pm_message_t m=
essage)
 {
+	struct device *child;
 	struct us_data *us =3D usb_get_intfdata(iface);
+	struct Scsi_Host *host =3D us_to_host(us);
+	struct scsi_device *sdev, *sdev2 =3D NULL;
+	int err =3D 0;
+
+	/* In case of autosuspend we need to do extra work to flush
+	 * buffers and spin down disks. */
+	if (us->pusb_dev->auto_pm) {
+		US_DEBUGP("Autosuspend code path.\n");
+		/* block all devices against block and user space io */
+		shost_for_each_device(sdev, host) {
+			US_DEBUGP("Quiescing device.\n");
+			err =3D scsi_device_quiesce(sdev);
+			US_DEBUGP("Quiesced device with result %d.\n", err);
+			if (err < 0) {
+				sdev2 =3D sdev;
+				err =3D -EIO;
+				scsi_device_put(sdev);
+				goto err_unblock;
+			}
+			child =3D &sdev->sdev_gendev;
+			if (!child->driver || !child->driver->suspend)
+				continue;
+			US_DEBUGP("About to suspend disk.\n");
+			/* flush the buffers and spin down */
+			err =3D (child->driver->suspend)(child, message);
+			if (err < 0) {
+				US_DEBUGP("Could not suspend disk.\n");
+				sdev2 =3D sdev;
+				shost_for_each_device(sdev, host) {
+					if (sdev =3D=3D sdev2) {
+						scsi_device_put(sdev);
+						break;
+					}
+					child =3D &sdev->sdev_gendev;
+					if (!child->driver || !child->driver->resume)
+						continue;
+					(child->driver->resume)(child);
+				}
+				err =3D -EIO;
+				sdev2 =3D NULL;
+				scsi_device_put(sdev);
+				goto err_unblock;
+			}
+		}
+	}
+
+	US_DEBUGP("%s\n", __FUNCTION__);
=20
 	/* Wait until no command is running */
 	mutex_lock(&us->dev_mutex);
=20
-	US_DEBUGP("%s\n", __FUNCTION__);
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_SUSPEND);
=20
-	/* When runtime PM is working, we'll set a flag to indicate
-	 * whether we should autoresume when a SCSI request arrives. */
-
 	mutex_unlock(&us->dev_mutex);
-	return 0;
+
+	/* In case of autosuspend device must be unblocked again */
+	if (us->pusb_dev->auto_pm) {
+err_unblock:
+		shost_for_each_device(sdev, host) {
+			if (sdev =3D=3D sdev2) {
+				scsi_device_put(sdev);
+				break;
+			}
+			scsi_device_resume(sdev);
+		}
+	}
+	return err;
 }
=20
 static int storage_resume(struct usb_interface *iface)
 {
 	struct us_data *us =3D usb_get_intfdata(iface);
+	struct Scsi_Host *host;
+	struct scsi_device *sdev;
+	struct device *child;
=20
-	mutex_lock(&us->dev_mutex);
+	if (us->pusb_dev->auto_pm) {
+		host =3D us_to_host(us);
+		shost_for_each_device(sdev, host) {
+			child =3D &sdev->sdev_gendev;
+			if (!child->driver || !child->driver->resume)
+				continue;
+			(child->driver->resume)(child);
+		}
+	}
=20
 	US_DEBUGP("%s\n", __FUNCTION__);
+
 	if (us->suspend_resume_hook)
 		(us->suspend_resume_hook)(us, US_RESUME);
=20
-	mutex_unlock(&us->dev_mutex);
 	return 0;
 }
=20
@@ -306,6 +373,7 @@ static int usb_stor_control_thread(void=20
 {
 	struct us_data *us =3D (struct us_data *)__us;
 	struct Scsi_Host *host =3D us_to_host(us);
+	int autopm_rc;
=20
 	for(;;) {
 		US_DEBUGP("*** thread sleeping.\n");
@@ -314,6 +382,9 @@ static int usb_stor_control_thread(void=20
 		=09
 		US_DEBUGP("*** thread awakened.\n");
=20
+		/* Autoresume the device */
+		autopm_rc =3D usb_autopm_get_interface(us->pusb_intf);
+
 		/* lock the device pointers */
 		mutex_lock(&(us->dev_mutex));
=20
@@ -372,6 +443,12 @@ static int usb_stor_control_thread(void=20
 			us->srb->result =3D SAM_STAT_GOOD;
 		}
=20
+		/* Did the autoresume fail? */
+		else if (autopm_rc < 0) {
+			US_DEBUGP("Could not wake device\n");
+			us->srb->result =3D DID_ERROR << 16;
+		}
+
 		/* we've got a command, let's do it! */
 		else {
 			US_DEBUG(usb_stor_show_command(us->srb));
@@ -414,6 +491,10 @@ SkipForAbort:
=20
 		/* unlock the device pointers */
 		mutex_unlock(&us->dev_mutex);
+
+		/* Start an autosuspend */
+		if (autopm_rc =3D=3D 0)
+			usb_autopm_put_interface(us->pusb_intf);
 	} /* for (;;) */
=20
 	/* Wait until we are told to stop */
@@ -931,6 +1012,7 @@ retry:
 		/* Should we unbind if no devices were detected? */
 	}
=20
+	usb_autopm_put_interface(us->pusb_intf);
 	complete_and_exit(&us->scanning_done, 0);
 }
=20
@@ -1016,6 +1098,7 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
=20
+	usb_autopm_get_interface(intf); /* dropped in the scanning thread */
 	wake_up_process(th);
=20
 	return 0;
@@ -1053,6 +1136,7 @@ static struct usb_driver usb_storage_dri
 	.pre_reset =3D	storage_pre_reset,
 	.post_reset =3D	storage_post_reset,
 	.id_table =3D	storage_usb_ids,
+	.supports_autosuspend =3D 1,
 };
=20
 static int __init usb_stor_init(void)
--- a/drivers/usb/storage/scsiglue.c	2007-09-27 13:33:31.000000000 +020=
0
+++ b/drivers/usb/storage/scsiglue.c	2007-09-25 13:24:20.000000000 +020=
0
@@ -285,10 +285,15 @@ static int device_reset(struct scsi_cmnd
=20
 	US_DEBUGP("%s called\n", __FUNCTION__);
=20
-	/* lock the device pointers and do the reset */
-	mutex_lock(&(us->dev_mutex));
-	result =3D us->transport_reset(us);
-	mutex_unlock(&us->dev_mutex);
+	result =3D usb_autopm_get_interface(us->pusb_intf);
+	if (result =3D=3D 0) {
+
+		/* lock the device pointers and do the reset */
+		mutex_lock(&(us->dev_mutex));
+		result =3D us->transport_reset(us);
+		mutex_unlock(&us->dev_mutex);
+		usb_autopm_put_interface(us->pusb_intf);
+	}
=20
 	return result < 0 ? FAILED : SUCCESS;
 }
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
