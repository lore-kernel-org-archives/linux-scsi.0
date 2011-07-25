From: michaelc@cs.wisc.edu
Subject: [PATCH 10/19] be2iscsi: remove host and session casts
Date: Mon, 25 Jul 2011 13:48:46 -0500
Message-ID: <1311619735-15323-11-git-send-email-michaelc@cs.wisc.edu>
References: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1GYSqJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 14:46:09 -0400
In-Reply-To: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_session_to_shost is a macro around dev_to_shost which returns a
Scsi_Host so there is no need to cast.

iscsi_session_to_shost is a macro around shost_priv which
returns a void pointer so no need to cast.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index feadaa2..8b002f6 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -177,9 +177,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
-	struct Scsi_Host *shost =
-		(struct Scsi_Host *)iscsi_session_to_shost(cls_session);
-	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_endpoint *ep;
 
@@ -290,7 +289,7 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf)
 {
-	struct beiscsi_hba *phba = (struct beiscsi_hba *)iscsi_host_priv(shost);
+	struct beiscsi_hba *phba = iscsi_host_priv(shost);
 	int status = 0;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_get_host_param, param= %d\n", param);
-- 
1.7.2.3

