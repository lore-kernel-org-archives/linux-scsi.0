From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 10/13] scsi: libiscsi: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:42 +0530
Message-ID: <1506073905-12985-11-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35171 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752243AbdIVJwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:41 -0400
Received: by mail-pf0-f193.google.com with SMTP id i23so268679pfi.2
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:41 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/libiscsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index bd4605a..f485280 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2913,9 +2913,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	conn->exp_statsn = 0;
 	conn->tmf_state = TMF_INITIAL;
 
-	init_timer(&conn->transport_timer);
-	conn->transport_timer.data = (unsigned long)conn;
-	conn->transport_timer.function = iscsi_check_transport_timeouts;
+	setup_timer(&conn->transport_timer, iscsi_check_transport_timeouts,
+		    (unsigned long)conn);
 
 	INIT_LIST_HEAD(&conn->mgmtqueue);
 	INIT_LIST_HEAD(&conn->cmdqueue);
-- 
2.7.4
