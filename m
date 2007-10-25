From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] iscsi: fix compile error when debug enabled
Date: Thu, 25 Oct 2007 16:04:29 -0400
Message-ID: <4720F6CD.1000907@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host06.cybernetics.com ([206.246.200.22]:4840 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760975AbXJYUEZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 16:04:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

This patch fixes a compile error in iSCSI when DEBUG_SCSI is defined.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24-rc1/drivers/scsi/libiscsi.c.orig	2007-10-25 15:56:32.000000000 -0400
+++ linux-2.6.24-rc1/drivers/scsi/libiscsi.c	2007-10-25 15:56:49.000000000 -0400
@@ -1058,7 +1058,7 @@ static int iscsi_exec_abort_task(struct 
 	if (!ctask->mtask) {
 		spin_unlock_bh(&session->lock);
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
-		spin_lock_bh(&session->lock)
+		spin_lock_bh(&session->lock);
 		debug_scsi("abort sent failure [itt 0x%x]\n", ctask->itt);
 		return -EPERM;
 	}


