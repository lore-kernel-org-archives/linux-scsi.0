From: akpm@osdl.org
Subject: [patch 18/26] drivers/scsi/megaraid.c: Replacing yield() with a better alternative
Date: Wed, 08 Nov 2006 19:56:22 -0800
Message-ID: <200611090356.kA93uNYY003976@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61873 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424007AbWKID43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:29 -0500
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
 1 file changed, 2 insertions(+), 1 deletion(-)

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
