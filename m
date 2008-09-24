From: michaelc@cs.wisc.edu
Subject: [PATCH 6/7] libiscsi: check reason why we are stopping iscsi session to determine error value
Date: Wed, 24 Sep 2008 11:46:14 -0500
Message-ID: <1222274775-8834-7-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-4-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-5-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53706 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbYIXQqb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:31 -0400
In-Reply-To: <1222274775-8834-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Some wires got crossed on some patches and I messed up in the code
below when rebuilding a patch. We want to be checking if flag
equaled the value indicating if we killing the session due to
final logout or if we just trying to relogin.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e3e57cc..5aa0db1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2453,7 +2453,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->lock);
-	if (STOP_CONN_RECOVER)
+	if (flag == STOP_CONN_RECOVER)
 		fail_all_commands(conn, -1, DID_TRANSPORT_DISRUPTED);
 	else
 		fail_all_commands(conn, -1, DID_ERROR);
-- 
1.5.4.1

