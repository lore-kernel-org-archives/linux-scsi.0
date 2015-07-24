From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 4/4] iser-target: Fix REJECT CM event use-after-free OOPs
Date: Fri, 24 Jul 2015 02:51:19 +0000
Message-ID: <1437706279-10580-5-git-send-email-nab@daterainc.com>
References: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34861 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbbGXC4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2015 22:56:07 -0400
Received: by obbop1 with SMTP id op1so8680392obb.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2015 19:56:07 -0700 (PDT)
In-Reply-To: <1437706279-10580-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in iser-target code where the REJECT CM event
handler code currently performs a isert_put_conn() for the final
isert_conn->kref put, while iscsi_np process context is still blocked
in isert_get_login_rx().

Once isert_get_login_rx() is awoking due to login timeout, iscsi_np
process context will attempt to invoke iscsi_target_login_sess_out()
to cleanup iscsi_conn as expected, and calls isert_wait_conn() +
isert_free_conn() which triggers the use-after-free OOPs.

To address this bug, move the kref_get_unless_zero() call from
isert_connected_handler() into isert_connect_request() immediately
preceeding isert_rdma_accept() to ensure the CM handler cleanup
paths and isert_free_conn() are always operating with two refs.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: <stable@vger.kernel.org> # v3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 7717009..d851e18 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -775,6 +775,17 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	ret = isert_rdma_post_recvl(isert_conn);
 	if (ret)
 		goto out_conn_dev;
+	/*
+	 * Obtain the second reference now before isert_rdma_accept() to
+	 * ensure that any initiator generated REJECT CM event that occurs
+	 * asynchronously won't drop the last reference until the error path
+	 * in iscsi_target_login_sess_out() does it's ->iscsit_free_conn() ->
+	 * isert_free_conn() -> isert_put_conn() -> kref_put().
+	 */
+	if (!kref_get_unless_zero(&isert_conn->kref)) {
+		isert_warn("conn %p connect_release is running\n", isert_conn);
+		goto out_conn_dev;
+	}
 
 	ret = isert_rdma_accept(isert_conn);
 	if (ret)
@@ -836,11 +847,6 @@ isert_connected_handler(struct rdma_cm_id *cma_id)
 
 	isert_info("conn %p\n", isert_conn);
 
-	if (!kref_get_unless_zero(&isert_conn->kref)) {
-		isert_warn("conn %p connect_release is running\n", isert_conn);
-		return;
-	}
-
 	mutex_lock(&isert_conn->mutex);
 	if (isert_conn->state != ISER_CONN_FULL_FEATURE)
 		isert_conn->state = ISER_CONN_UP;
-- 
1.9.1

