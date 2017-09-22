From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 13/13] scsi: bfa: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:45 +0530
Message-ID: <1506073905-12985-14-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37928 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752022AbdIVJw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:56 -0400
Received: by mail-pg0-f65.google.com with SMTP id m30so360341pgn.5
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:56 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/bfa/bfad.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 5caf5f3..d10826a 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -719,9 +719,7 @@ bfad_bfa_tmo(unsigned long data)
 void
 bfad_init_timer(struct bfad_s *bfad)
 {
-	init_timer(&bfad->hal_tmo);
-	bfad->hal_tmo.function = bfad_bfa_tmo;
-	bfad->hal_tmo.data = (unsigned long)bfad;
+	setup_timer(&bfad->hal_tmo, bfad_bfa_tmo, (unsigned long)bfad);
 
 	mod_timer(&bfad->hal_tmo,
 		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
-- 
2.7.4
