From: michaelc@cs.wisc.edu
Subject: [PATCH 12/19] libiscsi: don't bugon when if user sets markers
Date: Mon, 25 Jul 2011 13:48:48 -0500
Message-ID: <1311619735-15323-13-git-send-email-michaelc@cs.wisc.edu>
References: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1GYSqL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 14:46:11 -0400
In-Reply-To: <1311619735-15323-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

libiscsi does not support markers and if someone tries
to set them the driver does a BUG(). There is not need
to be that extreme. Just return -ENOSYS.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d7a4120..49e1819 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3179,7 +3179,6 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
-	uint32_t value;
 
 	switch(param) {
 	case ISCSI_PARAM_FAST_ABORT:
@@ -3236,14 +3235,6 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_ERL:
 		sscanf(buf, "%d", &session->erl);
 		break;
-	case ISCSI_PARAM_IFMARKER_EN:
-		sscanf(buf, "%d", &value);
-		BUG_ON(value);
-		break;
-	case ISCSI_PARAM_OFMARKER_EN:
-		sscanf(buf, "%d", &value);
-		BUG_ON(value);
-		break;
 	case ISCSI_PARAM_EXP_STATSN:
 		sscanf(buf, "%u", &conn->exp_statsn);
 		break;
-- 
1.7.2.3

