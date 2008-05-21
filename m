From: michaelc@cs.wisc.edu
Subject: [PATCH 07/25] iscsi: modify iscsi printk so it can take driver data pointers
Date: Wed, 21 May 2008 15:54:02 -0500
Message-ID: <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936333AbYEUUy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:28 -0400
In-Reply-To: <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Some drivers want to be able to just pass in the driver data pointers
to the iscsi objects. To enable this we need the iscsi printk macro
to cast the object.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 include/scsi/libiscsi.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 4e1c14f..f54aeb1 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -369,9 +369,11 @@ extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
+extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
-	iscsi_cls_conn_printk(prefix, _c->cls_conn, fmt, ##a)
+	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
+			      fmt, ##a)
 
 /*
  * pdu and task processing
-- 
1.5.4.1

