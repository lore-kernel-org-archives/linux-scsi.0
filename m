From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Fri, 01 Jul 2011 14:33:17 -0500
Message-ID: <1309548797.2722.37.camel@mulgrave>
References: <20110701170531.GA3693@tassilo.jf.intel.com>
	 <1309548044.2722.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49087 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab1GATdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2011 15:33:19 -0400
In-Reply-To: <1309548044.2722.35.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl

On Fri, 2011-07-01 at 14:20 -0500, James Bottomley wrote:
> I'll see if I can find the refcounting problem.
> 
> Likely it's a longstanding bug which we didn't actually notice until
> now.

OK, so it looks like we have correct refcounting on the sr_block ops,
but not on the actual cdrom ops, so the device is already gone by the
time the cdrom release function gets called.

This is my best guess at the fix (just add a get into the cdrom ops),
does it work?

James

---

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 4778e27..ee75983 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -575,7 +575,10 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
 {
 	struct scsi_cd *cd = cdi->handle;
 	struct scsi_device *sdev = cd->device;
-	int retval;
+	int retval = scsi_device_get(sdev);
+
+	if (!retval)
+		return retval;
 
 	/*
 	 * If the device is in error recovery, wait until it is done.
@@ -588,6 +591,7 @@ static int sr_open(struct cdrom_device_info *cdi, int purpose)
 	return 0;
 
 error_out:
+	scsi_device_put(sdev);
 	return retval;	
 }
 
@@ -598,6 +602,7 @@ static void sr_release(struct cdrom_device_info *cdi)
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
 
+	scsi_device_put(cd->device);
 }
 
 static int sr_probe(struct device *dev)


