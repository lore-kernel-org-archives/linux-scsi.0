From: jeffm@suse.de (Jeff Mahoney)
Subject: [patch 2/5] [PATCH 2/5] st: clean up dev cleanup in st_probe
Date: Sat, 18 Aug 2012 15:20:38 -0400
Message-ID: <20120818192044.204705473@suse.com>
References: <20120818192036.751334179@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab2HRTVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2012 15:21:50 -0400
Content-Disposition: inline; filename=st-clean-up-dev-cleanup-in-st_probe
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Lee Duncan <lduncan@suse.com>, Rob Evers <revers@redhat.com>

st_probe leaves a cdev pointer hanging around that is compared
during the error path and freed later. There's no need for the pointer
to hang around at all. So we free it immediately and simplify the error
handling.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/scsi/st.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4156,6 +4156,7 @@ static int st_probe(struct device *dev)
 				printk(KERN_ERR
 				       "st%d: out of memory. Device not attached.\n",
 				       dev_num);
+				cdev_del(cdev);
 				goto out_free_tape;
 			}
 			cdev->owner = THIS_MODULE;
@@ -4194,17 +4195,13 @@ out_free_tape:
 				  "tape");
 		for (j=0; j < 2; j++) {
 			if (STm->cdevs[j]) {
-				if (cdev == STm->cdevs[j])
-					cdev = NULL;
-					device_destroy(&st_sysfs_class,
-						       MKDEV(SCSI_TAPE_MAJOR,
-							     TAPE_MINOR(i, mode, j)));
+				device_destroy(&st_sysfs_class,
+					       MKDEV(SCSI_TAPE_MAJOR,
+						     TAPE_MINOR(i, mode, j)));
 				cdev_del(STm->cdevs[j]);
 			}
 		}
 	}
-	if (cdev)
-		cdev_del(cdev);
 	write_lock(&st_dev_arr_lock);
 	scsi_tapes[dev_num] = NULL;
 	st_nr_dev--;


