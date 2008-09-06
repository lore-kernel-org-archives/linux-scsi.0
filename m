From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] libiscsi: return error passed in during iscsi recovery
Date: Sat,  6 Sep 2008 08:39:15 -0500
Message-ID: <1220708356-5225-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYIFNj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2008 09:39:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Due to patch building error on my side, we are still passing DID_BUS_BUSY
for commands that are running, when we want to return whatever the caller
of fail_all_commands wanted. This replaces the hardcoded error code with
the value that is passed in.

Patch was made over scsi-post, but is applyable over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3f1b492..0e8f26b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1454,7 +1454,7 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 		if (lun == task->sc->device->lun || lun == -1) {
 			debug_scsi("failing in progress sc %p itt 0x%x\n",
 				   task->sc, task->itt);
-			fail_command(conn, task, DID_BUS_BUSY << 16);
+			fail_command(conn, task, error << 16);
 		}
 	}
 }
-- 
1.5.4.1

