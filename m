From: michaelc@cs.wisc.edu
Subject: [PATCH 19/23] libiscsi, iscsi class: set tmf to a safe default and export in sysfs
Date: Tue,  4 Dec 2007 18:42:33 -0600
Message-ID: <11968153871693-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
 <11968153831244-git-send-email-michaelc@cs.wisc.edu>
 <11968153842186-git-send-email-michaelc@cs.wisc.edu>
 <11968153853971-git-send-email-michaelc@cs.wisc.edu>
 <1196815386656-git-send-email-michaelc@cs.wisc.edu>
 <11968153873372-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbXLEAnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:12 -0500
In-Reply-To: <11968153873372-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Older tools will not be setting the tmf time outs since they
did not exists, so set them to a safe default.

And export abort and lu reset timeout values in sysfs.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |    2 ++
 drivers/scsi/scsi_transport_iscsi.c |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f15df8d..6573223 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1732,6 +1732,8 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 	session->host = shost;
 	session->state = ISCSI_STATE_FREE;
 	session->fast_abort = 1;
+	session->lu_reset_timeout = 15;
+	session->abort_timeout = 10;
 	session->mgmtpool_max = ISCSI_MGMT_CMDS_MAX;
 	session->cmds_max = cmds_max;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fb8a765..d3db318 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -30,7 +30,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 16
+#define ISCSI_SESSION_ATTRS 18
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 4
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
@@ -1241,7 +1241,9 @@ iscsi_session_attr(username, ISCSI_PARAM_USERNAME, 1);
 iscsi_session_attr(username_in, ISCSI_PARAM_USERNAME_IN, 1);
 iscsi_session_attr(password, ISCSI_PARAM_PASSWORD, 1);
 iscsi_session_attr(password_in, ISCSI_PARAM_PASSWORD_IN, 1);
-iscsi_session_attr(fast_abort, ISCSI_PARAM_FAST_ABORT, 1);
+iscsi_session_attr(fast_abort, ISCSI_PARAM_FAST_ABORT, 0);
+iscsi_session_attr(abort_tmo, ISCSI_PARAM_ABORT_TMO, 0);
+iscsi_session_attr(lu_reset_tmo, ISCSI_PARAM_LU_RESET_TMO, 0);
 
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
@@ -1466,6 +1468,8 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(username, ISCSI_PASSWORD);
 	SETUP_SESSION_RD_ATTR(username_in, ISCSI_PASSWORD_IN);
 	SETUP_SESSION_RD_ATTR(fast_abort, ISCSI_FAST_ABORT);
+	SETUP_SESSION_RD_ATTR(abort_tmo, ISCSI_ABORT_TMO);
+	SETUP_SESSION_RD_ATTR(lu_reset_tmo,ISCSI_LU_RESET_TMO);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
-- 
1.5.1.2

