From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 6/8] [SCSI] osduld: use ida_simple_get to handle id.
Date: Fri, 22 Jul 2011 17:41:15 +0100
Message-ID: <1311352886-4047-7-git-send-email-jic23@cam.ac.uk>
References: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1311352886-4047-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: lm-sensors@lm-sensors.org, rtc-linux@googlegroups.com, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, jkosina@suse.cz, naota@elisp.net, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@gmail.com, randy.dunlap@oracle.com, tj@kernel.org, cabarnes@indesign-llc.com, akpm@linux-foundation.org, airlied@redhat.com, thellstrom@vmware.com, johnpol@2ka.mipt.ru, JBottomley@parallels.com, bhalevy@panasas.com, bharrosh@panasas.com, a.zummo@towertech.it, guenter.roeck@ericsson.com, khali@linux-fr.org, airlied@linux.ie, Jonathan Cameron <jic23@cam.ac.uk>
List-Id: linux-scsi@vger.kernel.org

This does involve additional use of the spin lock in idr.c.
Is this an issue?

Also, some error mangling was needed to keep the interface
the same.  Does this matter or can we return -ENOSPC instead
of -EBUSY?

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/scsi/osd/osd_uld.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index b31a8e3..fa849bd 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
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
 
-- 
1.7.3.4
