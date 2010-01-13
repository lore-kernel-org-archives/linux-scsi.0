From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi_tcp regression: remove bogus warn on in write path
Date: Tue, 12 Jan 2010 22:48:00 -0600
Message-ID: <1263358080-5265-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0AMEsJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2010 23:48:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

An empty r2tqueue is a valid state. It just means that we have
processed all that there was to do. This patch removes the WARN_ON
that was added when the kfifo changes were merged.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi_tcp.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index db6856c..4ad87fd 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -992,12 +992,10 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 		if (r2t == NULL) {
 			if (kfifo_out(&tcp_task->r2tqueue,
 			    (void *)&tcp_task->r2t, sizeof(void *)) !=
-			    sizeof(void *)) {
-				WARN_ONCE(1, "unexpected fifo state");
+			    sizeof(void *))
 				r2t = NULL;
-			}
-
-			r2t = tcp_task->r2t;
+			else
+				r2t = tcp_task->r2t;
 		}
 		spin_unlock_bh(&session->lock);
 	}
-- 
1.6.5.2

