From: michaelc@cs.wisc.edu
Subject: [PATCH 3/6] qla4xxx: add timeout handler
Date: Mon, 13 Jul 2009 22:24:05 -0500
Message-ID: <1247541848-30412-3-git-send-email-michaelc@cs.wisc.edu>
References: <1247541848-30412-1-git-send-email-michaelc@cs.wisc.edu>
 <1247541848-30412-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38069 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbZGNDYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jul 2009 23:24:14 -0400
In-Reply-To: <1247541848-30412-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Recently dm-multipath began calling blk_abort_queue. This causes all the
commands/request running on the path to have the timeout function called.
If a path does go down, and the LLD returns DID_*, dm-multpiath will eventually
get this error and begin to call the cmd timeout handler. qla4xxx currently
does not set a timed out handler and so the default one could return
BLK_EH_NOT_HANDLED and end up firing the scsi eh and stopping IO to all
paths on the host when only one path is affected.

For software and offload iscsi we have a timed out handler already.
This patch adds a driver specific one to qla4xxx because there
are some ddb->state and session->state and command completion races
that are better handled in the LLD.

This also handles the problem where if the session is down,
we do not need the scsi eh to run until the transport code
has tried to reconnect us.

Patch was made over scsi-rc-fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ec9da6c..6841883 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -66,6 +66,7 @@ static int qla4xxx_sess_get_param(struct iscsi_cls_session *sess,
 static int qla4xxx_host_get_param(struct Scsi_Host *shost,
 				  enum iscsi_host_param param, char *buf);
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session);
+static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
 /*
  * SCSI host template entry points
@@ -89,6 +90,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
 	.eh_target_reset_handler = qla4xxx_eh_target_reset,
 	.eh_host_reset_handler	= qla4xxx_eh_host_reset,
+	.eh_timed_out		= qla4xxx_eh_cmd_timed_out,
 
 	.slave_configure	= qla4xxx_slave_configure,
 	.slave_alloc		= qla4xxx_slave_alloc,
@@ -124,6 +126,21 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 
 static struct scsi_transport_template *qla4xxx_scsi_transport;
 
+static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
+{
+	struct iscsi_cls_session *session;
+	struct ddb_entry *ddb_entry;
+
+	session = starget_to_session(scsi_target(sc->device));
+	ddb_entry = session->dd_data;
+
+	/* if we are not logged in then the LLD is going to clean up the cmd */
+	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE)
+		return BLK_EH_RESET_TIMER;
+	else
+		return BLK_EH_NOT_HANDLED;
+}
+
 static void qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
 {
 	struct ddb_entry *ddb_entry = session->dd_data;
-- 
1.6.2.2

