From: akpm@osdl.org
Subject: [patch 41/45] drivers/scsi/megaraid.c: Replacing yield() with a better alternative
Date: Fri, 20 Oct 2006 14:48:37 -0700
Message-ID: <200610202148.k9KLmbxl004198@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63366 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992798AbWJTVsx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

For this driver cond_resched() seems to be a better alternative

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a
+++ a/drivers/scsi/megaraid.c
@@ -1753,7 +1753,8 @@ __mega_busywait_mbox (adapter_t *adapter
 	for (counter = 0; counter < 10000; counter++) {
 		if (!mbox->m_in.busy)
 			return 0;
-		udelay(100); yield();
+		udelay(100);
+		cond_resched();
 	}
 	return -1;		/* give up after 1 second */
 }
_
