From: michaelc@cs.wisc.edu
Subject: [PATCH 03/12] qla4xxx: have qla4xxx use iscsi class session state check ready
Date: Thu, 31 Jan 2008 13:36:45 -0600
Message-ID: <1201808215955-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759231AbYAaTg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:36:59 -0500
In-Reply-To: <1201808215968-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This has qla4xxx use the iscsi class's check ready function
in the queue command function, so all iscsi drivers return the
same error value for common problems.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a87fb9f..437d169 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -398,9 +398,21 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
 	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct iscsi_cls_session *sess = ddb_entry->sess;
 	struct srb *srb;
 	int rval;
 
+	if (!sess) {
+		cmd->result = DID_IMM_RETRY << 16;
+		goto qc_fail_command;
+	}
+
+	rval = iscsi_session_chkready(sess);
+	if (rval) {
+		cmd->result = rval;
+		goto qc_fail_command;
+	}
+
 	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
 		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
-- 
1.5.2.1

