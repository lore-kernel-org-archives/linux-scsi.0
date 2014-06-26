From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] beiscsi: the custom_length field has been set to a wrong value.
Date: Thu, 26 Jun 2014 11:16:26 +0200
Message-ID: <1403774186-4751-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbaFZJSW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 05:18:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hch@infradead.org, JBottomley@parallels.com

In the beiscsi_conn_get_stats() function, custom_length should be set
to 1 to take into account the "eh_abort_cnt" field at custom[0].

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index fd284ff..8616281 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -914,7 +914,7 @@ void beiscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	stats->r2t_pdus = conn->r2t_pdus_cnt;
 	stats->digest_err = 0;
 	stats->timeout_err = 0;
-	stats->custom_length = 0;
+	stats->custom_length = 1;
 	strcpy(stats->custom[0].desc, "eh_abort_cnt");
 	stats->custom[0].value = conn->eh_abort_cnt;
 }
-- 
Maurizio Lombardi

