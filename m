From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH] drivers: scsi: esas2r: Use setup_timer() and mod_timer()
Date: Fri, 23 Dec 2016 17:09:35 +0530
Message-ID: <1482493175-10179-1-git-send-email-mayhs11saini@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34084 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbcLWLkB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2016 06:40:01 -0500
Received: by mail-pf0-f196.google.com with SMTP id y68so13885245pfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2016 03:40:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxdrivers@attotech.com
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>

Use setup_timer instead of structure field assignments
to initialize a timer.

mod_timer is a more efficient way to update the expire field of
an active timer (if the timer is inactive it will be activated)

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/scsi/esas2r/esas2r_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 5092c82..6ee4315 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1635,14 +1635,8 @@ static void esas2r_timer_callback(unsigned long context);
 
 void esas2r_kickoff_timer(struct esas2r_adapter *a)
 {
-	init_timer(&a->timer);
-
-	a->timer.function = esas2r_timer_callback;
-	a->timer.data = (unsigned long)a;
-	a->timer.expires = jiffies +
-			   msecs_to_jiffies(100);
-
-	add_timer(&a->timer);
+	setup_timer(&a->timer, esas2r_timer_callback, (unsigned long)a);
+	mod_timer(&a->timer, jiffies + msecs_to_jiffies(100));
 }
 
 static void esas2r_timer_callback(unsigned long context)
-- 
2.7.4

