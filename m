From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: fix crashes in sd and sr runtime PM
Date: Wed, 20 Jan 2016 11:26:01 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601201123020.1675-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52342 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934015AbcATQ0C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2016 11:26:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Paul Menzel <paul.menzel@giantmonkey.de>, Erich Schubert <erich@debian.org>, Alexandre Rossi <alexandre.rossi@gmail.com>, Ben Hutchings <ben@decadent.org.uk>, SCSI development list <linux-scsi@vger.kernel.org>

Runtime suspend during driver probe and removal can cause problems.
The driver's runtime_suspend or runtime_resume callbacks may invoked
before the driver has finished binding to the device or after the
driver has unbound from the device.

This problem shows up with the sd and sr drivers, and can cause disk
or CD/DVD drives to become unusable as a result.  The fix is simple.
The drivers store a pointer to the scsi_disk or scsi_cd structure as
their private device data when probing is finished, so we simply have
to be sure to clear the private data during removal and test it during
runtime suspend/resume.

This fixes <https://bugs.debian.org/801925>.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Paul Menzel <paul.menzel@giantmonkey.de>
Reported-by: Erich Schubert <erich@debian.org>
Reported-by: Alexandre Rossi <alexandre.rossi@gmail.com>
Tested-by: Paul Menzel <paul.menzel@giantmonkey.de>
CC: "James E.J. Bottomley" <JBottomley@odin.com>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: <stable@vger.kernel.org>

---


[as1795]


 drivers/scsi/sd.c |    7 +++++--
 drivers/scsi/sr.c |    4 ++++
 2 files changed, 9 insertions(+), 2 deletions(-)

Index: usb-4.4/drivers/scsi/sd.c
===================================================================
--- usb-4.4.orig/drivers/scsi/sd.c
+++ usb-4.4/drivers/scsi/sd.c
@@ -3275,8 +3275,8 @@ static int sd_suspend_common(struct devi
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	int ret = 0;
 
-	if (!sdkp)
-		return 0;	/* this can happen */
+	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
+		return 0;
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
@@ -3315,6 +3315,9 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
+		return 0;
+
 	if (!sdkp->device->manage_start_stop)
 		return 0;
 
Index: usb-4.4/drivers/scsi/sr.c
===================================================================
--- usb-4.4.orig/drivers/scsi/sr.c
+++ usb-4.4/drivers/scsi/sr.c
@@ -144,6 +144,9 @@ static int sr_runtime_suspend(struct dev
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	if (!cd)	/* E.g.: runtime suspend following sr_remove() */
+		return 0;
+
 	if (cd->media_present)
 		return -EBUSY;
 	else
@@ -985,6 +988,7 @@ static int sr_remove(struct device *dev)
 	scsi_autopm_get_device(cd->device);
 
 	del_gendisk(cd->disk);
+	dev_set_drvdata(dev, NULL);
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);

