From: michaelc@cs.wisc.edu
Subject: [PATCH 3/6] libiscsi: remove unneeded queue work when max_cmdsn is increased
Date: Fri,  7 Feb 2014 00:41:39 -0600
Message-ID: <1391755302-57206-4-git-send-email-michaelc@cs.wisc.edu>
References: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40277 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaBGGl5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 01:41:57 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s176fqtZ015126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 7 Feb 2014 00:41:56 -0600
In-Reply-To: <1391755302-57206-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_queuecommand will only take in commands that can fit in the
current window. So, if a command is on the cmdqueue then it can
fit in the current window. If a command is on the mgmtqueue, then
we are setting the immediate bit so they will also fit in the
window. As a result, we never need to to do a iscsi_conn_queue_work
when the maxCmdSn is increased.

What should happen is that a command will complete the window will
be increased, then the scsi layer will send us more commands by
running the scsi_device queues.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 6afb6fc..9ca42a2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -110,16 +110,8 @@ static void __iscsi_update_cmdsn(struct iscsi_session *session,
 		session->exp_cmdsn = exp_cmdsn;
 
 	if (max_cmdsn != session->max_cmdsn &&
-	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn)) {
+	    !iscsi_sna_lt(max_cmdsn, session->max_cmdsn))
 		session->max_cmdsn = max_cmdsn;
-		/*
-		 * if the window closed with IO queued, then kick the
-		 * xmit thread
-		 */
-		if (!list_empty(&session->leadconn->cmdqueue) ||
-		    !list_empty(&session->leadconn->mgmtqueue))
-			iscsi_conn_queue_work(session->leadconn);
-	}
 }
 
 void iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
-- 
1.7.1

