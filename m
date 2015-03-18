From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: OOPS: unplugging western digital passport drive
Date: Wed, 18 Mar 2015 10:49:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1503181045230.1497-100000@iolanthe.rowland.org>
References: <5508D6B0.3010806@stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50755 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751074AbbCROtP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2015 10:49:15 -0400
In-Reply-To: <5508D6B0.3010806@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: =?UTF-8?B?U3RhbmlzxYJhdyBQaXR1Y2hh?= <viraptor@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 18 Mar 2015, Alan Stern wrote:

> On Tue, 17 Mar 2015, Joe Lawrence wrote:
>=20
> > On 03/11/2015 12:25 AM, Stanis=C3=85=E2=80=9Aaw Pitucha wrote:
> > > Hi linux-scsi,
> > > I've got another case of reproducible crash when unplugging weste=
rn
> > > digital passport drives. This was mentioned before in
> > > http://www.spinics.net/lists/linux-scsi/msg82603.html
>=20
> Like it says in that thread, the problem is somehow related to the se=
s
> driver.  If you remove or blacklist that driver, there won't be any
> more crashes.

Looks like I spoke too soon.  I think the patch below will fix the=20
problem.  Let me know what happens.

Alan Stern




Index: usb-4.0/drivers/scsi/scsi_pm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-4.0.orig/drivers/scsi/scsi_pm.c
+++ usb-4.0/drivers/scsi/scsi_pm.c
@@ -217,14 +217,18 @@ static int sdev_runtime_suspend(struct d
 {
 	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NULL;
 	struct scsi_device *sdev =3D to_scsi_device(dev);
-	int err;
+	struct device *blk_rpm_dev =3D sdev->request_queue->dev;
+	int err =3D 0;
=20
-	err =3D blk_pre_runtime_suspend(sdev->request_queue);
-	if (err)
-		return err;
+	if (blk_rpm_dev) {
+		err =3D blk_pre_runtime_suspend(sdev->request_queue);
+		if (err)
+			return err;
+	}
 	if (pm && pm->runtime_suspend)
 		err =3D pm->runtime_suspend(dev);
-	blk_post_runtime_suspend(sdev->request_queue, err);
+	if (blk_rpm_dev)
+		blk_post_runtime_suspend(sdev->request_queue, err);
=20
 	return err;
 }
@@ -246,12 +250,15 @@ static int sdev_runtime_resume(struct de
 {
 	struct scsi_device *sdev =3D to_scsi_device(dev);
 	const struct dev_pm_ops *pm =3D dev->driver ? dev->driver->pm : NULL;
+	struct device *blk_rpm_dev =3D sdev->request_queue->dev;
 	int err =3D 0;
=20
-	blk_pre_runtime_resume(sdev->request_queue);
+	if (blk_rpm_dev)
+		blk_pre_runtime_resume(sdev->request_queue);
 	if (pm && pm->runtime_resume)
 		err =3D pm->runtime_resume(dev);
-	blk_post_runtime_resume(sdev->request_queue, err);
+	if (blk_rpm_dev)
+		blk_post_runtime_resume(sdev->request_queue, err);
=20
 	return err;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
