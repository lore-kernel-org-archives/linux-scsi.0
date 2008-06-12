From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi_host regression: fix scsi host leak
Date: Wed, 11 Jun 2008 19:21:00 -0500
Message-ID: <1213230060-11388-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYFLAVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2008 20:21:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

In 2.6.25 we started using class_find_child instead of implementing
our own loop and lookup. The problem is that class_find_child would get a
reference to the host's device, then scsi_host_lookup would get an extra
reference to it when it called scsi_host_get().

In 2.6.26 we started using class_find_device, and this function also
gets a reference to the device, so we end up with an extra ref
and the host will not get released.

This patch is made against scsi-rc-fixes and adds a put_device to
balance the class_find_device() get. I kept the scsi_host_get in
scsi_host_lookup, because the target layer is using scsi_host_lookup
and it looks like it needs the SHOST_DEL check.

For 2.6.25 we need a similar patch, but instead of calling
put_device we have to call class_device_put() due to the differences
in the the driver model device/class_device between 2.6.25 and
2.6.26. I can send a patch for 2.6.25 in a seperate mail.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/hosts.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3690360..c6457bf 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -456,6 +456,10 @@ static int __scsi_host_match(struct device *dev, void *data)
  *
  * Return value:
  *	A pointer to located Scsi_Host or NULL.
+ *
+ *	The caller must do a scsi_host_put() to drop the reference
+ *	that scsi_host_get() took. The put_device() below dropped
+ *	the reference from class_find_device().
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
@@ -463,9 +467,10 @@ struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
 	cdev = class_find_device(&shost_class, &hostnum, __scsi_host_match);
-	if (cdev)
+	if (cdev) {
 		shost = scsi_host_get(class_to_shost(cdev));
-
+		put_device(cdev);
+	}
 	return shost;
 }
 EXPORT_SYMBOL(scsi_host_lookup);
-- 
1.5.4.1

