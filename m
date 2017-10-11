From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: cxgb4i: fix Tx skb leak
Date: Wed, 11 Oct 2017 19:33:07 +0530
Message-ID: <1507730587-6655-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:52934 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753574AbdJKODU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 10:03:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

In case of connection reset Tx skb queue can have some
skbs which are not transmitted so purge Tx skb queue in
release_offload_resources() to avoid skb leak.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 1d02cf9..30d5f0e 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1575,6 +1575,7 @@ static void release_offload_resources(struct cxgbi_sock *csk)
 		csk, csk->state, csk->flags, csk->tid);
 
 	cxgbi_sock_free_cpl_skbs(csk);
+	cxgbi_sock_purge_write_queue(csk);
 	if (csk->wr_cred != csk->wr_max_cred) {
 		cxgbi_sock_purge_wr_queue(csk);
 		cxgbi_sock_reset_wr_list(csk);
-- 
2.0.2
