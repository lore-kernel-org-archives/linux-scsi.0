From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/5] osduld: Ref-counting bug fix
Date: Mon, 26 Oct 2009 18:57:31 +0200
Message-ID: <1256576251-10404-1-git-send-email-bharrosh@panasas.com>
References: <4AE5D374.80400@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:49057 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753844AbZJZQ52 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2009 12:57:28 -0400
In-Reply-To: <4AE5D374.80400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

If scsi has released the device (logout), and exofs has last
reference on the osduld_device it will be freed by
osd_uld_release() within the call to fput(). But this will
oops in cdev_release() which is called after the fops->release.
(cdev is embedded within osduld_device). __uld_get/put pair
makes sure we have a cdev for the duration of fput()

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_uld.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 0bdef33..1ea6447 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -224,7 +224,15 @@ void osduld_put_device(struct osd_dev *od)
 
 		BUG_ON(od->scsi_device != oud->od.scsi_device);
 
+		/* If scsi has released the device (logout), and exofs has last
+		 * reference on oud it will be freed by above osd_uld_release
+		 * within fput below. But this will oops in cdev_release which
+		 * is called after the fops->release. __uld_get/put pair makes
+		 * sure we have a cdev for the duration of fput
+		 */
+		__uld_get(oud);
 		fput(od->file);
+		__uld_put(oud);
 		kfree(od);
 	}
 }
-- 
1.6.5.1

