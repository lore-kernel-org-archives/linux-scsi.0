From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 12/13] scsi: qla2xxx: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:44 +0530
Message-ID: <1506073905-12985-13-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35242 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752295AbdIVJwv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:51 -0400
Received: by mail-pg0-f65.google.com with SMTP id j16so367099pga.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:51 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5b2437a..8058eeb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -332,10 +332,9 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
 __inline__ void
 qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
 {
-	init_timer(&vha->timer);
+	setup_timer(&vha->timer, (void(*)(unsigned long))func,
+		    (unsigned long)vha);
 	vha->timer.expires = jiffies + interval * HZ;
-	vha->timer.data = (unsigned long)vha;
-	vha->timer.function = (void (*)(unsigned long))func;
 	add_timer(&vha->timer);
 	vha->timer_active = 1;
 }
-- 
2.7.4
