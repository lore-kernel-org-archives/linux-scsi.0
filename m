From: michaelc@cs.wisc.edu
Subject: [PATCH 08/12] libiscsi: fix setting of nop timer
Date: Thu, 31 Jan 2008 13:36:50 -0600
Message-ID: <1201808217738-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
 <12018082161847-git-send-email-michaelc@cs.wisc.edu>
 <1201808216137-git-send-email-michaelc@cs.wisc.edu>
 <12018082174157-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759629AbYAaThB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:37:01 -0500
In-Reply-To: <12018082174157-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we rollover then we could get a next_timeout of zero, so we need
to set the new timer to that value.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8c41ddb..7e781fd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1385,14 +1385,11 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 			iscsi_send_nopout(conn, NULL);
 		}
 		next_timeout = last_recv + timeout + (conn->ping_timeout * HZ);
-	} else {
+	} else
 		next_timeout = last_recv + timeout;
-	}
 
-	if (next_timeout) {
-		debug_scsi("Setting next tmo %lu\n", next_timeout);
-		mod_timer(&conn->transport_timer, next_timeout);
-	}
+	debug_scsi("Setting next tmo %lu\n", next_timeout);
+	mod_timer(&conn->transport_timer, next_timeout);
 done:
 	spin_unlock(&session->lock);
 }
-- 
1.5.2.1

