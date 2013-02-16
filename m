From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 5/5] pmcraid: check error from device_create()
Date: Sat, 16 Feb 2013 23:27:59 +0900
Message-ID: <1361024879-12934-5-git-send-email-akinobu.mita@gmail.com>
References: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:64452 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab3BPO2f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2013 09:28:35 -0500
Received: by mail-da0-f53.google.com with SMTP id w3so1804117dad.26
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2013 06:28:35 -0800 (PST)
In-Reply-To: <1361024879-12934-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Fix an unchecked error from device_create() and convert to use standard
goto based unwinding for error cleanup.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/pmcraid.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e3b68d9..d3034a8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5399,6 +5399,7 @@ static int pmcraid_setup_chrdev(struct pmcraid_instance *pinstance)
 {
 	int minor;
 	int error;
+	struct device *device;
 
 	minor = pmcraid_get_minor();
 	if (minor >= PMCRAID_MAX_ADAPTERS)
@@ -5408,12 +5409,23 @@ static int pmcraid_setup_chrdev(struct pmcraid_instance *pinstance)
 	pinstance->cdev.owner = THIS_MODULE;
 
 	error = cdev_add(&pinstance->cdev, MKDEV(pmcraid_major, minor), 1);
-
 	if (error)
-		pmcraid_release_minor(minor);
-	else
-		device_create(pmcraid_class, NULL, MKDEV(pmcraid_major, minor),
+		goto out_release_minor;
+
+	device = device_create(pmcraid_class, NULL, MKDEV(pmcraid_major, minor),
 			      NULL, "%s%u", PMCRAID_DEVFILE, minor);
+	if (IS_ERR(device)) {
+		error = PTR_ERR(device);
+		goto out_cdev_del;
+	}
+
+	return 0;
+
+out_cdev_del:
+	cdev_del(&pinstance->cdev);
+out_release_minor:
+	pmcraid_release_minor(minor);
+
 	return error;
 }
 
-- 
1.8.1

