From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 07/13] scsi: qla4xxx: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:39 +0530
Message-ID: <1506073905-12985-8-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35154 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdIVJw1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:27 -0400
Received: by mail-pg0-f68.google.com with SMTP id j16so366645pga.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:27 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa5..32b3e0e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3961,10 +3961,9 @@ static void qla4xxx_start_timer(struct scsi_qla_host *ha, void *func,
 {
 	DEBUG(printk("scsi: %s: Starting timer thread for adapter %d\n",
 		     __func__, ha->host->host_no));
-	init_timer(&ha->timer);
+	setup_timer(&ha->timer, (void(*)(unsigned long))func,
+		    (unsigned long)ha);
 	ha->timer.expires = jiffies + interval * HZ;
-	ha->timer.data = (unsigned long)ha;
-	ha->timer.function = (void (*)(unsigned long))func;
 	add_timer(&ha->timer);
 	ha->timer_active = 1;
 }
-- 
2.7.4
