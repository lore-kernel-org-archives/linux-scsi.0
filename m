From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 01/13] scsi: sym53c8xx: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:33 +0530
Message-ID: <1506073905-12985-2-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33618 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdIVJv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:51:59 -0400
Received: by mail-pg0-f68.google.com with SMTP id i130so372066pgc.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:51:59 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d32e3ba..285397d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1351,9 +1351,7 @@ static struct Scsi_Host *sym_attach(struct scsi_host_template *tpnt, int unit,
 	/*
 	 *  Start the timer daemon
 	 */
-	init_timer(&np->s.timer);
-	np->s.timer.data     = (unsigned long) np;
-	np->s.timer.function = sym53c8xx_timer;
+	setup_timer(&np->s.timer, sym53c8xx_timer, (unsigned long)np);
 	np->s.lasttime=0;
 	sym_timer (np);
 
-- 
2.7.4
