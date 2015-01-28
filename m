From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] [PATCH REGRESSION] alua: fix bus detach oops
Date: Wed, 28 Jan 2015 03:46:53 -0600
Message-ID: <1422438413-10273-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33957 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076AbbA1UZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2015 15:25:07 -0500
Received: from rh2.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id t0S9kxEq021259
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2015 03:47:03 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This fixes a regression caused by commit
1d5203284d8acbdfdf9b478d434450b34f338f28

The bug is that the alua detach() callout will try to access the
sddev->scsi_dh_data, but we have already set it to NULL. This patch
moves the clearing of that field to after detach() is called.

It looks like the regression was added during 3.19 development,
so it has not been in a released kernel, and so I did not cc
stable.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---
 drivers/scsi/device_handler/scsi_dh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 1dba62c..1efebc9 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -136,11 +136,12 @@ static void __detach_handler (struct kref *kref)
 	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
 	struct scsi_device *sdev = scsi_dh_data->sdev;
 
+	scsi_dh->detach(sdev);
+
 	spin_lock_irq(sdev->request_queue->queue_lock);
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irq(sdev->request_queue->queue_lock);
 
-	scsi_dh->detach(sdev);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", scsi_dh->name);
 	module_put(scsi_dh->module);
 }
-- 
1.8.3.1

