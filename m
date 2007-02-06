From: akpm@linux-foundation.org
Subject: [patch 15/33] drivers/scsi/megaraid.c: Replacing yield() with a better alternative
Date: Mon, 05 Feb 2007 16:38:51 -0800
Message-ID: <200702060039.l160dsEv004992@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41813 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965371AbXBFAkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

For this driver cond_resched() seems to be a better alternative

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-replacing-yield-with-a
+++ a/drivers/scsi/megaraid.c
@@ -1754,7 +1754,8 @@ __mega_busywait_mbox (adapter_t *adapter
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
