From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: esas2r: Use setup_timer and mod_timer
Date: Fri, 29 Sep 2017 01:45:25 +0530
Message-ID: <1506629725-11620-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: jejb@linux.vnet.ibm.com, linuxdrivers@attotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use setup_timer and mod_timer API instead of structure assignments.

This is done using Coccinelle and semantic patch used
for this as follows:

@@
expression x,y,z,a,b;
@@

-init_timer (&x);
+setup_timer (&x, y, z);
+mod_timer (&a, b);
-x.function = y;
-x.data = z;
-x.expires = b;
-add_timer(&a);

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/esas2r/esas2r_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 81f226b..1866ba0 100644
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
