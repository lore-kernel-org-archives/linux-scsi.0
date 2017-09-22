From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 02/13] scsi: qla2xxx: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:34 +0530
Message-ID: <1506073905-12985-3-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36599 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdIVJwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:04 -0400
Received: by mail-pg0-f65.google.com with SMTP id d8so363532pgt.3
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:04 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/qla2xxx/qla_inline.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 9a2c86e..34cdb5d 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -269,10 +269,9 @@ qla2x00_rel_sp(srb_t *sp)
 static inline void
 qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 {
-	init_timer(&sp->u.iocb_cmd.timer);
+	setup_timer(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout,
+		    (unsigned long)sp);
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
-	sp->u.iocb_cmd.timer.data = (unsigned long)sp;
-	sp->u.iocb_cmd.timer.function = qla2x00_sp_timeout;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
 	if (IS_QLAFX00(sp->vha->hw) && (sp->type == SRB_FXIOCB_DCMD))
-- 
2.7.4
