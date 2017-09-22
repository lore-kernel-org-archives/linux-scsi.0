From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 11/13] scsi: dc395x: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:43 +0530
Message-ID: <1506073905-12985-12-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37893 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbdIVJwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:46 -0400
Received: by mail-pg0-f65.google.com with SMTP id m30so360120pgn.5
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:46 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/dc395x.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44..f9aaa8b 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -857,9 +857,7 @@ static void waiting_set_timer(struct AdapterCtlBlk *acb, unsigned long to)
 {
 	if (timer_pending(&acb->waiting_timer))
 		return;
-	init_timer(&acb->waiting_timer);
-	acb->waiting_timer.function = waiting_timeout;
-	acb->waiting_timer.data = (unsigned long) acb;
+	setup_timer(&acb->waiting_timer, waiting_timeout, (unsigned long)acb);
 	if (time_before(jiffies + to, acb->last_reset - HZ / 2))
 		acb->waiting_timer.expires =
 		    acb->last_reset - HZ / 2 + 1;
-- 
2.7.4
