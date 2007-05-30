From: michaelc@cs.wisc.edu
Subject: [PATCH 1/19] Check iscsi interface skb allocation return value
Date: Wed, 30 May 2007 12:57:07 -0500
Message-ID: <11805478461587-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478452886-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Let's not oops when we cannot allocate a skb! Add a check
for if alloc_skb fails.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index caf1836..4fbd8e1 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -609,12 +609,10 @@ iscsi_if_send_reply(int pid, int seq, in
 	int t = done ? NLMSG_DONE : type;
 
 	skb = alloc_skb(len, GFP_ATOMIC);
-	/*
-	 * FIXME:
-	 * user is supposed to react on iferror == -ENOMEM;
-	 * see iscsi_if_rx().
-	 */
-	BUG_ON(!skb);
+	if (!skb) {
+		printk(KERN_ERR "Could not allocate skb to send reply.\n");
+		return -ENOMEM;
+	}
 
 	nlh = __nlmsg_put(skb, pid, seq, t, (len - sizeof(*nlh)), 0);
 	nlh->nlmsg_flags = flags;
-- 
1.4.1.1

