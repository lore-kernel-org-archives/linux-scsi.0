From: akpm@osdl.org
Subject: [patch 40/45] drivers/scsi/NCR5380.c: Replacing yield() with a better alternative
Date: Fri, 20 Oct 2006 14:48:36 -0700
Message-ID: <200610202148.k9KLma5r004195@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:59014 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992785AbWJTVst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk

From: Amol Lad <amol@verismonetworks.com>

Replaced yield() with cond_resched()

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/NCR5380.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/NCR5380.c~drivers-scsi-ncr5380c-replacing-yield-with-a drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~drivers-scsi-ncr5380c-replacing-yield-with-a
+++ a/drivers/scsi/NCR5380.c
@@ -347,7 +347,7 @@ static int NCR5380_poll_politely(struct 
 		if((r & bit) == val)
 			return 0;
 		if(!in_interrupt())
-			yield();
+			cond_resched();
 		else
 			cpu_relax();
 	}
_
