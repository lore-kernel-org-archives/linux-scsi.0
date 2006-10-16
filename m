From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] libiscsi: fix missed iscsi_task_put in xmit error path
Date: Mon, 16 Oct 2006 18:09:40 -0400
Message-ID: <1161036585226-git-send-email-michaelc@cs.wisc.edu>
References: <11610365823995-git-send-email-michaelc@cs.wisc.edu> <1161036583544-git-send-email-michaelc@cs.wisc.edu> <1161036584778-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:962 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422899AbWJPXJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 19:09:44 -0400
In-Reply-To: <1161036584778-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

from bhalevy@gmail.com:
It looks like change 652 to libiscsi.c added some dead code around line
670
                if (rc) {
                        spin_unlock_bh(&conn->session->lock);
                        goto again;
                }

since 5 lines above we goto again if (rc).

It looks like the previous if (rc) should go away if we want to put the
ctask before
breaking out of the while loop with "goto again" (see following patch).

did I miss anything here?

Benny
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1000fe9..e3a2ec2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -661,8 +661,6 @@ static int iscsi_data_xmit(struct iscsi_
 		spin_unlock_bh(&conn->session->lock);
 
 		rc = tt->xmit_cmd_task(conn, conn->ctask);
-		if (rc)
-			goto again;
 
 		spin_lock_bh(&conn->session->lock);
 		__iscsi_put_ctask(conn->ctask);
-- 
1.4.1

