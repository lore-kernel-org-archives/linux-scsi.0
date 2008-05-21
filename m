From: michaelc@cs.wisc.edu
Subject: [PATCH 20/25] iscsi_tcp: hook iscsi_tcp into iscsi_endpoint code
Date: Wed, 21 May 2008 15:54:15 -0500
Message-ID: <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937118AbYEUUyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:36 -0400
In-Reply-To: <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_tcp creates its ep in userspace using sockets because
it is virtual, so we just check if we are sent a ep and fail
if we are.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index aa3c7f0..92d0319 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1838,17 +1838,17 @@ iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 }
 
 static struct iscsi_cls_session *
-iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
+iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 			 uint16_t qdepth, uint32_t initial_cmdsn,
 			 uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
+	struct Scsi_Host *shost;
 	int cmd_i;
 
-	if (shost) {
-		printk(KERN_ERR "iscsi_tcp: invalid shost %d.\n",
-		       shost->host_no);
+	if (ep) {
+		printk(KERN_ERR "iscsi_tcp: invalid ep %p.\n", ep);
 		return NULL;
 	}
 
-- 
1.5.4.1

