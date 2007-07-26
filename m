From: michaelc@cs.wisc.edu
Subject: [PATCH 1/4] libiscsi: make sure session is not blocked when removing host
Date: Thu, 26 Jul 2007 12:46:45 -0500
Message-ID: <1185472010604-git-send-email-michaelc@cs.wisc.edu>
References: <11854720083011-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452AbXGZRrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:47:07 -0400
In-Reply-To: <11854720083011-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

When we logout we block the session since we are not taking any more
commands, but when we call remove host we want to make sure any
IO that got queued up and blocked gets failed upwards quickly, so
we unblock the session and fail it.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4d85ce1..271a2d6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1473,6 +1473,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
 	struct module *owner = cls_session->transport->owner;
 
+	iscsi_unblock_session(cls_session);
 	scsi_remove_host(shost);
 
 	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
-- 
1.5.1.2

