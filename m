From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] fcoe: add missing destroy_workqueue() on error in fcoe_init()
Date: Fri, 29 Jul 2016 15:54:48 +0000
Message-ID: <1469807688-32470-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34581 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcG2Pyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2016 11:54:54 -0400
Received: by mail-pa0-f67.google.com with SMTP id hh10so5443144pac.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 08:54:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org

Add the missing destroy_workqueue() before return from fcoe_init()
in the fcoe transport register failed error handling case.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/scsi/fcoe/fcoe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 197dc62..9bd41a3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -2495,7 +2495,7 @@ static int __init fcoe_init(void)
 	if (rc) {
 		printk(KERN_ERR "failed to register an fcoe transport, check "
 			"if libfcoe is loaded\n");
-		return rc;
+		goto out_destroy;
 	}
 
 	mutex_lock(&fcoe_config_mutex);
@@ -2518,6 +2518,7 @@ static int __init fcoe_init(void)
 
 out_free:
 	mutex_unlock(&fcoe_config_mutex);
+out_destroy:
 	destroy_workqueue(fcoe_wq);
 	return rc;
 }

