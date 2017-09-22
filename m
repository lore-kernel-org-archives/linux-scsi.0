From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 04/13] scsi: bnx2i: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:21:36 +0530
Message-ID: <1506073905-12985-5-git-send-email-allen.lkml@gmail.com>
References: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37344 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdIVJwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 05:52:13 -0400
Received: by mail-pg0-f67.google.com with SMTP id v5so361381pgn.4
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2017 02:52:13 -0700 (PDT)
In-Reply-To: <1506073905-12985-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux@armlinux.org.uk, oliver@neukum.org, aliakc@web.de, lenehan@twibble.org, lduncan@suse.com, cleech@redhat.com, matthew@wil.cx, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 03c104b..bffc7e9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1729,10 +1729,8 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
 	}
 
 	ep->state = EP_STATE_CLEANUP_START;
-	init_timer(&ep->ofld_timer);
+	setup_timer(&ep->ofld_timer, bnx2i_ep_ofld_timer, (unsigned long)ep);
 	ep->ofld_timer.expires = hba->conn_ctx_destroy_tmo + jiffies;
-	ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	ep->ofld_timer.data = (unsigned long) ep;
 	add_timer(&ep->ofld_timer);
 
 	bnx2i_ep_destroy_list_add(hba, ep);
@@ -1835,10 +1833,9 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	bnx2i_ep->state = EP_STATE_OFLD_START;
 	bnx2i_ep_ofld_list_add(hba, bnx2i_ep);
 
-	init_timer(&bnx2i_ep->ofld_timer);
+	setup_timer(&bnx2i_ep->ofld_timer, bnx2i_ep_ofld_timer,
+		    (unsigned long)bnx2i_ep);
 	bnx2i_ep->ofld_timer.expires = 2 * HZ + jiffies;
-	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
 
 	if (bnx2i_send_conn_ofld_req(hba, bnx2i_ep)) {
@@ -2054,10 +2051,9 @@ int bnx2i_hw_ep_disconnect(struct bnx2i_endpoint *bnx2i_ep)
 		session = conn->session;
 	}
 
-	init_timer(&bnx2i_ep->ofld_timer);
+	setup_timer(&bnx2i_ep->ofld_timer, bnx2i_ep_ofld_timer,
+		    (unsigned long)bnx2i_ep);
 	bnx2i_ep->ofld_timer.expires = hba->conn_teardown_tmo + jiffies;
-	bnx2i_ep->ofld_timer.function = bnx2i_ep_ofld_timer;
-	bnx2i_ep->ofld_timer.data = (unsigned long) bnx2i_ep;
 	add_timer(&bnx2i_ep->ofld_timer);
 
 	if (!test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic))
-- 
2.7.4
