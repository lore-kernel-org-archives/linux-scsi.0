From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] some sd.c code consolidation
Date: 11 Jun 2003 19:06:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1055376373.3806.6.camel@mulgrave>
References: <20030609162402.GA1890@lst.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-w5A6hzrEgswyufO9QVAv"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:49415 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264612AbTFKXwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2003 19:52:38 -0400
In-Reply-To: <20030609162402.GA1890@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-w5A6hzrEgswyufO9QVAv
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2003-06-09 at 11:24, Christoph Hellwig wrote:
> fold sd_init_onedisk into sd_revalidate_disk and sd_synchronize_cache
> into sd_shutdown.

You didn't actually boot this one, did you?  There's a use before
initialise of gendisk->private_data in sd_revalidate_disk().

James



--=-w5A6hzrEgswyufO9QVAv
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/sd.c 1.120 vs edited =3D=3D=3D=3D=3D
--- 1.120/drivers/scsi/sd.c	Sun Jun  8 15:33:57 2003
+++ edited/drivers/scsi/sd.c	Wed Jun 11 18:59:49 2003
@@ -1340,13 +1340,14 @@
=20
 	strcpy(gd->devfs_name, sdp->devfs_name);
=20
+	gd->private_data =3D &sdkp->driver;
+
 	sd_revalidate_disk(gd);
=20
 	gd->driverfs_dev =3D &sdp->sdev_driverfs_dev;
 	gd->flags =3D GENHD_FL_DRIVERFS;
 	if (sdp->removable)
 		gd->flags |=3D GENHD_FL_REMOVABLE;
-	gd->private_data =3D &sdkp->driver;
 	gd->queue =3D sdkp->device->request_queue;
=20
 	dev_set_drvdata(dev, sdkp);

--=-w5A6hzrEgswyufO9QVAv--

