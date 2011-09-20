From: akpm@google.com
Subject: [patch 5/8] drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id
Date: Tue, 20 Sep 2011 14:20:18 -0700
Message-ID: <201109202120.p8KLKIUa000949@wpaz13.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1ITVVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 17:21:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@google.com, jic23@cam.ac.uk, bhalevy@panasas.com, bharrosh@panasas.com, rusty@rustcorp.com.au, tj@kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: drivers/scsi/osd/osd_uld.c: use ida_simple_get() to handle id

This does involve additional use of the spin lock in idr.c.  Is this an
issue?

Also, some error mangling was needed to keep the interface the same.  Does
this matter or can we return -ENOSPC instead of -EBUSY?

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 drivers/scsi/osd/osd_uld.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/osd/osd_uld.c~drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id drivers/scsi/osd/osd_uld.c
--- a/drivers/scsi/osd/osd_uld.c~drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id
+++ a/drivers/scsi/osd/osd_uld.c
@@ -387,7 +387,7 @@ static void __remove(struct device *dev)
 
 	if (oud->disk)
 		put_disk(oud->disk);
-	ida_remove(&osd_minor_ida, oud->minor);
+	ida_simple_remove(&osd_minor_ida, oud->minor);
 
 	kfree(oud);
 }
@@ -403,18 +403,12 @@ static int osd_probe(struct device *dev)
 	if (scsi_device->type != TYPE_OSD)
 		return -ENODEV;
 
-	do {
-		if (!ida_pre_get(&osd_minor_ida, GFP_KERNEL))
-			return -ENODEV;
-
-		error = ida_get_new(&osd_minor_ida, &minor);
-	} while (error == -EAGAIN);
-
-	if (error)
-		return error;
-	if (minor >= SCSI_OSD_MAX_MINOR) {
-		error = -EBUSY;
-		goto err_retract_minor;
+	minor = ida_simple_get(&osd_minor_ida, 0,
+			       SCSI_OSD_MAX_MINOR, GFP_KERNEL);
+	if (minor < 0) {
+		if (minor == -ENOSPC)
+			return -EBUSY;
+		return minor;
 	}
 
 	error = -ENOMEM;
@@ -491,7 +485,7 @@ err_free_osd:
 	dev_set_drvdata(dev, NULL);
 	kfree(oud);
 err_retract_minor:
-	ida_remove(&osd_minor_ida, minor);
+	ida_simple_remove(&osd_minor_ida, minor);
 	return error;
 }
 
_
