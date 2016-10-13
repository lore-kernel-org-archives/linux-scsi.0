From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 1/2] libiscsi: Fix locking in __iscsi_conn_send_pdu
Date: Thu, 13 Oct 2016 12:08:48 +0530
Message-ID: <1476340729-8569-2-git-send-email-jitendra.bhivare@broadcom.com>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35795 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbcJMGsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 02:48:46 -0400
Received: by mail-qt0-f176.google.com with SMTP id f6so34088947qtd.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 23:47:20 -0700 (PDT)
In-Reply-To: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

The code at free_task label in __iscsi_conn_send_pdu can get executed
from blk_timeout_work which takes queue_lock using spin_lock_irq.
back_lock taken with spin_unlock_bh will cause WARN_ON_ONCE.
The code gets executed either with bottom half or IRQ disabled hence
using spin_lock/spin_unlock for back_lock is safe.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/libiscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c051694..f9b6fba 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -791,9 +791,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 free_task:
 	/* regular RX path uses back_lock */
-	spin_lock_bh(&session->back_lock);
+	spin_lock(&session->back_lock);
 	__iscsi_put_task(task);
-	spin_unlock_bh(&session->back_lock);
+	spin_unlock(&session->back_lock);
 	return NULL;
 }
 
-- 
2.7.4

