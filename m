From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH for-3.15] scsi/libiscsi: Fix static checker warning on bh locking
Date: Sun, 30 Mar 2014 15:26:29 +0300
Message-ID: <1396182389-4910-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:55017 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751043AbaC3M0k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2014 08:26:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Shlomo Pongratz <shlomop@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>

From: Shlomo Pongratz <shlomop@mellanox.com>

Commit 659743b "[SCSI] libiscsi: Reduce locking contention in fast path" introduced a
new smatch warning on libiscsi.c "iscsi_xmit_task() warn: inconsistent returns
bottom_half:: locked (1410 [(-61)]) unlocked (1425 [0], 1425 [s32min-(-1),1-s32max])",
which we can eliminate by using non bh locking on the nested spin_lock call.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Shlomo Pongratz <shlomop@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
---

 drivers/scsi/libiscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5b8605c..5087957 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1411,9 +1411,9 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
 		conn->task = NULL;
 	}
 	/* regular RX path uses back_lock */
-	spin_lock_bh(&conn->session->back_lock);
+	spin_lock(&conn->session->back_lock);
 	__iscsi_put_task(task);
-	spin_unlock_bh(&conn->session->back_lock);
+	spin_unlock(&conn->session->back_lock);
 	return rc;
 }
 
-- 
1.7.1

