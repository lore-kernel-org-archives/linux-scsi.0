From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libiscsi regression in 2.6.25: fix setting of recv timer
Date: Thu,  8 May 2008 20:15:34 -0500
Message-ID: <1210295734-6278-2-git-send-email-michaelc@cs.wisc.edu>
References: <1210295734-6278-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbYEIBPi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2008 21:15:38 -0400
In-Reply-To: <1210295734-6278-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the ping tmo is longer than the recv tmo then we could miss a window
where we were supposed to check the recv tmo. This happens because
the ping code will set the next timeout for the ping timeout, and if the
ping executes quickly there will be a long chunk of time before the
timer wakes up again.

This patch has the ping processing code kick off a recv
tmo check when getting a nop in response to our ping.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 98164f3..b43bf1d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -730,7 +730,9 @@ static int __iscsi_complete_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 				if (iscsi_recv_pdu(conn->cls_conn, hdr, data,
 						   datalen))
 					rc = ISCSI_ERR_CONN_FAILED;
-			}
+			} else
+				mod_timer(&conn->transport_timer,
+					  jiffies + conn->recv_timeout);
 			iscsi_free_mgmt_task(conn, mtask);
 			break;
 		default:
@@ -1478,11 +1480,9 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	}
 
 	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
-		if (time_before_eq(conn->last_ping, last_recv)) {
-			/* send a ping to try to provoke some traffic */
-			debug_scsi("Sending nopout as ping on conn %p\n", conn);
-			iscsi_send_nopout(conn, NULL);
-		}
+		/* send a ping to try to provoke some traffic */
+		debug_scsi("Sending nopout as ping on conn %p\n", conn);
+		iscsi_send_nopout(conn, NULL);
 		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
 		next_timeout = last_recv + recv_timeout;
-- 
1.5.4.1

