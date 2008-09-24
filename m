From: michaelc@cs.wisc.edu
Subject: [PATCH 7/7] libiscsi: fix locking in iscsi_eh_device_reset
Date: Wed, 24 Sep 2008 11:46:15 -0500
Message-ID: <1222274775-8834-8-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-4-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-5-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-6-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYIXQqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:36 -0400
In-Reply-To: <1222274775-8834-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We must be using the bh spin locking functions in
iscsi_eh_device_reset becuase the session lock interacts with
a thread and softirq.

This patch also fixes up a bogus comment and check in fail_command,
because no one drops the lock (bnx2i did but it is not going
upstream yet and there were other refcount changes for that).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 5aa0db1..801c7cf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -404,11 +404,6 @@ static void fail_command(struct iscsi_conn *conn, struct iscsi_task *task,
 		conn->session->queued_cmdsn--;
 	else
 		conn->session->tt->cleanup_task(conn, task);
-	/*
-	 * Check if cleanup_task dropped the lock and the command completed,
-	 */
-	if (!task->sc)
-		return;
 
 	sc->result = err;
 	if (!scsi_bidi_cmnd(sc))
@@ -1829,10 +1824,10 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 	iscsi_suspend_tx(conn);
 
-	spin_lock(&session->lock);
+	spin_lock_bh(&session->lock);
 	fail_all_commands(conn, sc->device->lun, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
-	spin_unlock(&session->lock);
+	spin_unlock_bh(&session->lock);
 
 	iscsi_start_tx(conn);
 	goto done;
-- 
1.5.4.1

