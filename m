From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 03/13] scsi: esas2r: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:35 +0530
Message-ID: <1506073905-12985-4-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37518 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdIVJwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:08 -0400
Received: by mail-pf0-f195.google.com with SMTP id e69so262052pfg.4
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:08 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/esas2r/esas2r_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 81f226b..590db6d 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1635,10 +1635,8 @@ static void esas2r_timer_callback(unsigned long context);
 
 void esas2r_kickoff_timer(struct esas2r_adapter *a)
 {
-	init_timer(&a->timer);
 
-	a->timer.function = esas2r_timer_callback;
-	a->timer.data = (unsigned long)a;
+	setup_timer(&a->timer, esas2r_timer_callback, (unsigned long)a);
 	a->timer.expires = jiffies +
 			   msecs_to_jiffies(100);
 
-- 
2.7.4
