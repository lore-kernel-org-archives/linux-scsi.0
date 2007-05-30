From: michaelc@cs.wisc.edu
Subject: [PATCH 17/19] iscsi_tcp: fix fd leak
Date: Wed, 30 May 2007 12:57:23 -0500
Message-ID: <11805478632103-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu> <11805478472375-git-send-email-michaelc@cs.wisc.edu> <11805478483268-git-send-email-michaelc@cs.wisc.edu> <1180547849438-git-send-email-michaelc@cs.wisc.edu> <11805478511328-git-send-email-michaelc@cs.wisc.edu> <11805478523188-git-send-email-michaelc@cs.wisc.edu> <11805478531743-git-send-email-michaelc@cs.wisc.edu> <11805478543860-git-send-email-michaelc@cs.wisc.edu> <11805478564182-git-send-email-michaelc@cs.wisc.edu> <1180547857548-git-send-email-michaelc@cs.wisc.edu> <118054785852-git-send-email-michaelc@cs.wisc.edu> <11805478592848-git-send-email-michaelc@cs.wisc.edu> <11805478601019-git-send-email-michaelc@cs.wisc.edu> <11805478611832-git-send-email-michaelc@cs.wisc.edu> <11805478623536-git-send-email-michaelc@cs.wisc.edu> <11805478623287-git-send-email-michaelc@cs.w
 isc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbXE3R5u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:50 -0400
In-Reply-To: <11805478623287-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch should fix the file descriptor leak problem. A quick look
through the kernel shows that users of sockfd_lookup use sockfd_put to
release their handle. We were using sock_release which from the comments
and code look like it does not release the get() on the file from the
lookup.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4e9f0d9..7ce177e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/inet.h>
+#include <linux/file.h>
 #include <linux/blkdev.h>
 #include <linux/crypto.h>
 #include <linux/delay.h>
@@ -1878,7 +1879,7 @@ iscsi_tcp_release_conn(struct iscsi_conn
 	iscsi_conn_restore_callbacks(tcp_conn);
 	sock_put(tcp_conn->sock->sk);
 
-	sock_release(tcp_conn->sock);
+	sockfd_put(tcp_conn->sock);
 	tcp_conn->sock = NULL;
 	conn->recv_lock = NULL;
 }
-- 
1.4.1.1

