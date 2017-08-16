From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: cxgb4i: call neigh_event_send() to update MAC address
Date: Wed, 16 Aug 2017 19:40:32 +0530
Message-ID: <1502892632-6563-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:40439 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751893AbdHPOKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2017 10:10:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

If nud_state is not valid then call neigh_event_send()
to update MAC address.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index a69a9ac..1d02cf9 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1635,6 +1635,9 @@ static int init_act_open(struct cxgbi_sock *csk)
 		goto rel_resource;
 	}
 
+	if (!(n->nud_state & NUD_VALID))
+		neigh_event_send(n, NULL);
+
 	csk->atid = cxgb4_alloc_atid(lldi->tids, csk);
 	if (csk->atid < 0) {
 		pr_err("%s, NO atid available.\n", ndev->name);
-- 
2.0.2
