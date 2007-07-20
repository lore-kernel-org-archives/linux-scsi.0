From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] buggered kmalloc()
Date: Fri, 20 Jul 2007 16:03:40 +0100
Message-ID: <20070720150340.GF21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48356 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762470AbXGTPDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 11:03:45 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index aebcd5f..7829ab1 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1885,7 +1885,7 @@ static int iscsi_tcp_get_addr(struct iscsi_conn *conn, struct socket *sock,
 	struct sockaddr_in *sin;
 	int rc = 0, len;
 
-	addr = kmalloc(GFP_KERNEL, sizeof(*addr));
+	addr = kmalloc(sizeof(*addr), GFP_KERNEL);
 	if (!addr)
 		return -ENOMEM;
 
