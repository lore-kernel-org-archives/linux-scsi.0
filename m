From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Wed, 21 Apr 2004 22:57:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422055744.GA7861@us.ibm.com>
References: <1081518779.2203.29.camel@mulgrave> <20040413171208.GA2550@us.ibm.com> <1082568881.1728.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:34779 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263475AbUDVGcL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 02:32:11 -0400
Content-Disposition: inline
In-Reply-To: <1082568881.1728.22.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, greg@kroah.com

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> The slight problem in all this is that the module refcounting model is
> different from the device one (in modules, you can't send a deletion
> (rmmod) unless your "ref" count is zero).
> 
> The best fix would be to move the module model over to the device model.
> So you can rmmod at any point, removal triggers the appropriate
> scsi_remove_device etc calls and the rmmod command hangs around until
> it's safe to remove the module ... for SCSI we could do this before the
> device references are dropped because there's a point where we can
> guarantee no more commands will be sent to the host adapter.

Yes it would be good to convert the module model someday. We already
allow today to hot unplug an adapter with the module ref count positive
and cover almost the same code paths as a rmmod.

> 
> To conform to the existing model, we can simply move the scsi_device_get
> and scsi_device_put under the semaphore in the ULD get and put
> routines.  This adds some assymmetry because now the put in sd_remove()
> can't be the uld wrappered put, it would have to be a direct kref put
> (with the semaphore), but it's doable.

Yes, The addition of this asymmetric put is a side effect that would be
good to avoid. I believe the patch below is similar to what you are
talking about. I only ran a light ref count check on it. I will try a
more complete run tomorrow.

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Move scsi_device_get out of sd probe path to allow module to be unloaded
when devices are not open.
EDESC


 patched-2.6-andmike/drivers/scsi/sd.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/sd.c~sd_ref drivers/scsi/sd.c
--- patched-2.6/drivers/scsi/sd.c~sd_ref	Thu Apr 22 04:52:00 2004
+++ patched-2.6-andmike/drivers/scsi/sd.c	Thu Apr 22 05:20:13 2004
@@ -179,7 +179,16 @@ static struct scsi_disk *scsi_disk_get(s
 		goto out;
 	sdkp = scsi_disk(disk);
 	if (!kref_get(&sdkp->kref))
-		sdkp = NULL;
+		goto out_sdkp;
+	if (scsi_device_get(sdkp->device))
+		goto out_put;
+	up(&sd_ref_sem);
+	return sdkp;
+
+ out_put:
+	kref_put(&sdkp->kref);
+ out_sdkp:
+	sdkp = NULL;
  out:
 	up(&sd_ref_sem);
 	return sdkp;
@@ -188,6 +197,7 @@ static struct scsi_disk *scsi_disk_get(s
 static void scsi_disk_put(struct scsi_disk *sdkp)
 {
 	down(&sd_ref_sem);
+	scsi_device_put(sdkp->device);
 	kref_put(&sdkp->kref);
 	up(&sd_ref_sem);
 }
@@ -1342,16 +1352,13 @@ static int sd_probe(struct device *dev)
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 		goto out;
 
-	if ((error = scsi_device_get(sdp)) != 0)
-		goto out;
-
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
 
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
 	if (!sdkp)
-		goto out_put_sdev;
+		goto out;
 
 	memset (sdkp, 0, sizeof(*sdkp));
 	kref_init(&sdkp->kref, scsi_disk_release);
@@ -1427,8 +1434,6 @@ out_put:
 	put_disk(gd);
 out_free:
 	kfree(sdkp);
-out_put_sdev:
-	scsi_device_put(sdp);
 out:
 	return error;
 }
@@ -1450,7 +1455,9 @@ static int sd_remove(struct device *dev)
 
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
-	scsi_disk_put(sdkp);
+	down(&sd_ref_sem);
+	kref_put(&sdkp->kref);
+	up(&sd_ref_sem);
 
 	return 0;
 }
@@ -1479,8 +1486,6 @@ static void scsi_disk_release(struct kre
 	put_disk(disk);
 
 	kfree(sdkp);
-
-	scsi_device_put(sdev);
 }
 
 /*

_
