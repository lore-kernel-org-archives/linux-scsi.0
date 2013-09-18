From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/5] scsi_debug: fix invalid value check for guard module parameter
Date: Wed, 18 Sep 2013 21:27:27 +0900
Message-ID: <1379507248-15929-5-git-send-email-akinobu.mita@gmail.com>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61912 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3IRM2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 08:28:40 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so8197577pab.35
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2013 05:28:39 -0700 (PDT)
In-Reply-To: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Joe Perches <joe@perches.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

In the module initialization, invalid value for guard module parameter
is detected by the following check:

        if (scsi_debug_guard > 1) {
                printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
                return -EINVAL;
        }

But this check isn't enough, because the type of scsi_debug_guard is
'int' and scsi_debug_guard could be a negative value.

This fixes it by changing the type of scsi_debug_guard to 'unsigned int'
instead of adding extra check for a negative value.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 43369e9..a21322d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -169,7 +169,7 @@ static int scsi_debug_dix = DEF_DIX;
 static int scsi_debug_dsense = DEF_D_SENSE;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
 static int scsi_debug_fake_rw = DEF_FAKE_RW;
-static int scsi_debug_guard = DEF_GUARD;
+static unsigned int scsi_debug_guard = DEF_GUARD;
 static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int scsi_debug_max_luns = DEF_MAX_LUNS;
 static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
@@ -2754,7 +2754,7 @@ module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
 module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
-module_param_named(guard, scsi_debug_guard, int, S_IRUGO);
+module_param_named(guard, scsi_debug_guard, uint, S_IRUGO);
 module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
@@ -3184,7 +3184,7 @@ DRIVER_ATTR(dif, S_IRUGO, sdebug_dif_show, NULL);
 
 static ssize_t sdebug_guard_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_guard);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_guard);
 }
 DRIVER_ATTR(guard, S_IRUGO, sdebug_guard_show, NULL);
 
-- 
1.8.3.1

