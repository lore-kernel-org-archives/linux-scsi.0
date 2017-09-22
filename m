From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 09/13] scsi: arm: fas216: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:41 +0530
Message-ID: <1506073905-12985-10-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34189 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752108AbdIVJwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:37 -0400
Received: by mail-pf0-f195.google.com with SMTP id g65so270622pfe.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:37 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/arm/fas216.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2438879..7304d5a 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2849,9 +2849,7 @@ int fas216_init(struct Scsi_Host *host)
 	info->rst_dev_status = -1;
 	info->rst_bus_status = -1;
 	init_waitqueue_head(&info->eh_wait);
-	init_timer(&info->eh_timer);
-	info->eh_timer.data  = (unsigned long)info;
-	info->eh_timer.function = fas216_eh_timer;
+	setup_timer(&info->eh_timer, fas216_eh_timer, (unsigned long)info);
 	
 	spin_lock_init(&info->host_lock);
 
-- 
2.7.4
