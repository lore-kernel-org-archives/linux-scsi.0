From: Brian King <brking@us.ibm.com>
Subject: [PATCH] scsi_remove_device locking
Date: Fri, 02 Jul 2004 15:18:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40E5C32A.3060002@us.ibm.com>
References: <40E49E70.9020504@us.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060905030900050800040309"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:31709 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264904AbUGBUSx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2004 16:18:53 -0400
In-Reply-To: <40E49E70.9020504@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060905030900050800040309
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------060905030900050800040309
Content-Type: text/plain;
 name="scsi_remove_device_locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_remove_device_locking.patch"


The following patch fixes an oops I was seeing on a machine with
misconfigured scsi cables, but could feasibly happen in other paths.
The oops was occurring because scsi_remove_device was getting
called for a device before scsi_add_device had fully completed.
This resulted in sysfs_remove_link being called with a NULL dentry.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.7-bjking1/drivers/scsi/scsi_sysfs.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_sysfs.c~scsi_remove_device_locking drivers/scsi/scsi_sysfs.c
--- linux-2.6.7/drivers/scsi/scsi_sysfs.c~scsi_remove_device_locking	2004-07-02 11:34:25.000000000 -0500
+++ linux-2.6.7-bjking1/drivers/scsi/scsi_sysfs.c	2004-07-02 11:37:00.000000000 -0500
@@ -524,8 +524,13 @@ int scsi_sysfs_add_sdev(struct scsi_devi
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+	struct Scsi_Host *shost = sdev->host;
+	down(&shost->scan_mutex);
+
+	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0) {
+		up(&shost->scan_mutex);
 		return;
+	}
 
 	class_device_unregister(&sdev->sdev_classdev);
 	if (sdev->transport_classdev.class)
@@ -537,6 +542,7 @@ void scsi_remove_device(struct scsi_devi
 	if (sdev->host->transportt->cleanup)
 		sdev->host->transportt->cleanup(sdev);
 	put_device(&sdev->sdev_gendev);
+	up(&shost->scan_mutex);
 }
 
 int scsi_register_driver(struct device_driver *drv)
_

--------------060905030900050800040309--

