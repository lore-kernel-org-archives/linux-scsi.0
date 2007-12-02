From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] SCSI: early detection of medium not present, updated
Date: Sun, 02 Dec 2007 19:10:29 +0200
Message-ID: <1196615429.32348.3.camel@localhost.localdomain>
References: <20071129151842.44c05b18.akpm@linux-foundation.org>
	 <1196519099.5977.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33147 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753091AbXLBRKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2007 12:10:41 -0500
In-Reply-To: <1196519099.5977.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, Albert Lee <albertcc@tw.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>

On Sat, 2007-12-01 at 16:25 +0200, James Bottomley wrote:
> On Thu, 2007-11-29 at 15:18 -0800, Andrew Morton wrote:
> > Guys, I have this marked as needed-in-2.6.24?
>=20
> Could you wait on this a bit ... since it's such an old bug.  The cod=
e
> in question needs to be reworked (as the comment says).  I think the
> best rework is to have the caller pass in an optional struct
> scsi_sense_header into scsi_test_unit_ready() instead of the hacky
> media_may_be_present, so the one place that needs this will be able t=
o
> interpret the sense codes correctly.
>=20
> I can do this when I get back home ... unfortunately, I'm in Aswan to=
day
> at an Internet caf=C3=A9 ... I'll be back in Cairo tomorrow, but my U=
S system
> seems to have fallen off the internet, so I might not be able to test
> any patches I come up with.  Worst case, I'll be back in Chicago on
> Thursday.

Actually, the night train is a good place to do coding.  I know this
compiles, but could someone check it out?  It's the form I think we
should do, since the ASC/ASCQ codes for esoteric conditions which we
might eventually check for are different for CDs and removable discs.

James

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 83e1447..28b19ef 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -244,7 +244,7 @@ int scsi_ioctl(struct scsi_device *sdev, int cmd, v=
oid __user *arg)
 		return scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	case SCSI_IOCTL_TEST_UNIT_READY:
 		return scsi_test_unit_ready(sdev, IOCTL_NORMAL_TIMEOUT,
-					    NORMAL_RETRIES);
+					    NORMAL_RETRIES, NULL);
 	case SCSI_IOCTL_START_UNIT:
 		scsi_cmd[0] =3D START_STOP;
 		scsi_cmd[1] =3D 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1148c40..823df63 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2016,27 +2016,57 @@ scsi_mode_sense(struct scsi_device *sdev, int d=
bd, int modepage,
 }
 EXPORT_SYMBOL(scsi_mode_sense);
=20
+/**
+ *	scsi_test_unit_ready - test if unit is ready
+ *	@sdev:	scsi device to change the state of.
+ *	@timeout: command timeout
+ *	@retries: number of retries before failing
+ *	@sshdr_external: Optional pointer to struct scsi_sense_hdr for
+ *		returning sense. Make sure that this is cleared before passing
+ *		in.
+ *
+ *	Returns zero if unsuccessful or an error if TUR failed.  For
+ *	removable media, a return of NOT_READY or UNIT_ATTENTION is
+ *	translated to success, with the ->changed flag updated.
+ **/
 int
-scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retrie=
s)
+scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retrie=
s,
+		     struct scsi_sense_hdr *sshdr_external)
 {
 	char cmd[] =3D {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
-	struct scsi_sense_hdr sshdr;
+	struct scsi_sense_hdr *sshdr;
 	int result;
-=09
-	result =3D scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
-				  timeout, retries);
+
+	if (!sshdr_external)
+		sshdr =3D kzalloc(sizeof(*sshdr), GFP_KERNEL);
+	else
+		sshdr =3D sshdr_external;
+
+	/* try to eat the UNIT_ATTENTION if there are enough retries */
+	do {
+		result =3D scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
+					  timeout, retries);
+	} while ((driver_byte(result) & DRIVER_SENSE) &&
+		 sshdr && sshdr->sense_key =3D=3D UNIT_ATTENTION &&
+		 --retries);
+
+	if (!sshdr)
+		/* could not allocate sense buffer, so can't process it */
+		return result;
=20
 	if ((driver_byte(result) & DRIVER_SENSE) && sdev->removable) {
=20
-		if ((scsi_sense_valid(&sshdr)) &&
-		    ((sshdr.sense_key =3D=3D UNIT_ATTENTION) ||
-		     (sshdr.sense_key =3D=3D NOT_READY))) {
+		if ((scsi_sense_valid(sshdr)) &&
+		    ((sshdr->sense_key =3D=3D UNIT_ATTENTION) ||
+		     (sshdr->sense_key =3D=3D NOT_READY))) {
 			sdev->changed =3D 1;
 			result =3D 0;
 		}
 	}
+	if (!sshdr_external)
+		kfree(sshdr);
 	return result;
 }
 EXPORT_SYMBOL(scsi_test_unit_ready);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 18343a6..212f6bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -736,6 +736,7 @@ static int sd_media_changed(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp =3D scsi_disk(disk);
 	struct scsi_device *sdp =3D sdkp->device;
+	struct scsi_sense_hdr *sshdr =3D NULL;
 	int retval;
=20
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_media_changed\n"))=
;
@@ -766,8 +767,11 @@ static int sd_media_changed(struct gendisk *disk)
 	 */
 	retval =3D -ENODEV;
=20
-	if (scsi_block_when_processing_errors(sdp))
-		retval =3D scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES);
+	if (scsi_block_when_processing_errors(sdp)) {
+		sshdr  =3D kzalloc(sizeof(*sshdr), GFP_KERNEL);
+		retval =3D scsi_test_unit_ready(sdp, SD_TIMEOUT, SD_MAX_RETRIES,
+					      sshdr);
+	}
=20
 	/*
 	 * Unable to test, unit probably not ready.   This usually
@@ -775,7 +779,9 @@ static int sd_media_changed(struct gendisk *disk)
 	 * and we will figure it out later once the drive is
 	 * available again.
 	 */
-	if (retval) {
+	if (retval || (scsi_sense_valid(sshdr) &&
+		       /* 0x3a is medium not present */
+		       sshdr->asc =3D=3D 0x3a)) {
 		set_media_not_present(sdkp);
 		retval =3D 1;
 		goto out;
@@ -794,6 +800,7 @@ out:
 	if (retval !=3D sdkp->previous_state)
 		sdev_evt_send_simple(sdp, SDEV_EVT_MEDIA_CHANGE, GFP_KERNEL);
 	sdkp->previous_state =3D retval;
+	kfree(sshdr);
 	return retval;
 }
=20
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7702681..896be4a 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -179,18 +179,24 @@ static int sr_media_change(struct cdrom_device_in=
fo *cdi, int slot)
 {
 	struct scsi_cd *cd =3D cdi->handle;
 	int retval;
+	struct scsi_sense_hdr *sshdr;
=20
 	if (CDSL_CURRENT !=3D slot) {
 		/* no changer support */
 		return -EINVAL;
 	}
=20
-	retval =3D scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES);
-	if (retval) {
-		/* Unable to test, unit probably not ready.  This usually
-		 * means there is no disc in the drive.  Mark as changed,
-		 * and we will figure it out later once the drive is
-		 * available again.  */
+	sshdr =3D  kzalloc(sizeof(*sshdr), GFP_KERNEL);
+	retval =3D scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
+				      sshdr);
+	if (retval || (scsi_sense_valid(sshdr) &&
+		       /* 0x3a is medium not present */
+		       sshdr->asc =3D=3D 0x3a)) {
+		/* Media not present or unable to test, unit probably not
+		 * ready. This usually means there is no disc in the drive.
+		 * Mark as changed, and we will figure it out later once
+		 * the drive is available again.
+		 */
 		cd->device->changed =3D 1;
 		/* This will force a flush, if called from check_disk_change */
 		retval =3D 1;
@@ -213,6 +219,7 @@ out:
 		sdev_evt_send_simple(cd->device, SDEV_EVT_MEDIA_CHANGE,
 				     GFP_KERNEL);
 	cd->previous_state =3D retval;
+	kfree(sshdr);
=20
 	return retval;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c7bccf9..b1861c7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -292,7 +292,7 @@ extern int scsi_mode_select(struct scsi_device *sde=
v, int pf, int sp,
 			    struct scsi_mode_data *data,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
-				int retries);
+				int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_ty=
pe,


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
