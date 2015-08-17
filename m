From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: Fix NULL pointer dereference in runtime PM
Date: Mon, 17 Aug 2015 11:02:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1508171059320.1706-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57939 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754862AbbHQPCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2015 11:02:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ilan Cohen <ilanco@gmail.com>, Joe Lawrence <joe.lawrence@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

The routines in scsi_rpm.c assume that if a runtime-PM callback is
invoked for a SCSI device, it can only mean that the device's driver=20
has asked the block layer to handle the runtime power management (by
calling blk_pm_runtime_init(), which among other things sets q->dev).

However, this assumption turns out to be wrong for things like the ses
driver.  Normally ses devices are not allowed to do runtime PM, but
userspace can override this setting.  If this happens, the kernel gets
a NULL pointer dereference when blk_post_runtime_resume() tries to use
the uninitialized q->dev pointer.

This patch fixes the problem by calling the block layer's runtime-PM
routines only if the device's driver really does have a runtime-PM
callback routine.  Since ses doesn't define any such callbacks, the
crash won't occur.

This fixes Bugzilla #101371.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Stanis=C5=82aw Pitucha <viraptor@gmail.com>
Reported-by: Ilan Cohen <ilanco@gmail.com>
Tested-by: Ilan Cohen <ilanco@gmail.com>

---


[as1784]


 drivers/scsi/scsi_pm.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: usb-4.0/drivers/scsi/scsi_pm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-4.0.orig/drivers/scsi/scsi_pm.c
+++ usb-4.0/drivers/scsi/scsi_pm.c
@@ -217,15 +217,15 @@ static int sdev_runtime_suspend(struct d
 {
 	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NULL;
 	struct scsi_device *sdev =3D to_scsi_device(dev);
-	int err;
+	int err =3D 0;
=20
-	err =3D blk_pre_runtime_suspend(sdev->request_queue);
-	if (err)
-		return err;
-	if (pm && pm->runtime_suspend)
+	if (pm && pm->runtime_suspend) {
+		err =3D blk_pre_runtime_suspend(sdev->request_queue);
+		if (err)
+			return err;
 		err =3D pm->runtime_suspend(dev);
-	blk_post_runtime_suspend(sdev->request_queue, err);
-
+		blk_post_runtime_suspend(sdev->request_queue, err);
+	}
 	return err;
 }
=20
@@ -248,11 +248,11 @@ static int sdev_runtime_resume(struct de
 	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NULL;
 	int err =3D 0;
=20
-	blk_pre_runtime_resume(sdev->request_queue);
-	if (pm && pm->runtime_resume)
+	if (pm && pm->runtime_resume) {
+		blk_pre_runtime_resume(sdev->request_queue);
 		err =3D pm->runtime_resume(dev);
-	blk_post_runtime_resume(sdev->request_queue, err);
-
+		blk_post_runtime_resume(sdev->request_queue, err);
+	}
 	return err;
 }
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
