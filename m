From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] iscsi regression: check for zero max session cmds
Date: Tue, 26 Feb 2008 12:35:23 -0600
Message-ID: <12040509232412-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbYBZSf2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 13:35:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The old tools did not set max session cmds. This is a regression.
I removed the check when merging the power of 2 patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |    4 ++--
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 59f8445..bdd7de7 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1708,8 +1708,8 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	}
 
-	if (!is_power_of_2(cmds_max) ||
-	    cmds_max >= ISCSI_MGMT_ITT_OFFSET) {
+	if (!is_power_of_2(cmds_max) || cmds_max >= ISCSI_MGMT_ITT_OFFSET ||
+	    cmds_max < 2) {
 		if (cmds_max != 0)
 			printk(KERN_ERR "iscsi: invalid can_queue of %d. "
 			       "can_queue must be a power of 2 and between "
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 9981682..dfb026b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -33,7 +33,7 @@
 #define ISCSI_SESSION_ATTRS 19
 #define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
-#define ISCSI_TRANSPORT_VERSION "2.0-868"
+#define ISCSI_TRANSPORT_VERSION "2.0-869"
 
 struct iscsi_internal {
 	int daemon_pid;
-- 
1.5.1.2

