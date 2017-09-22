From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 08/13] scsi: ncr53c8xx: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:40 +0530
Message-ID: <1506073905-12985-9-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38873 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdIVJwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:32 -0400
Received: by mail-pg0-f66.google.com with SMTP id m30so359910pgn.5
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:32 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/ncr53c8xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 5b93ed8..017216f 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8357,9 +8357,7 @@ struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 	if (!np->scripth0)
 		goto attach_error;
 
-	init_timer(&np->timer);
-	np->timer.data     = (unsigned long) np;
-	np->timer.function = ncr53c8xx_timeout;
+	setup_timer(&np->timer, ncr53c8xx_timeout, (unsigned long)np);
 
 	/* Try to map the controller chip to virtual and physical memory. */
 
-- 
2.7.4
