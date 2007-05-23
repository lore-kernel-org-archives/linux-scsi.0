From: akpm@linux-foundation.org
Subject: [patch 04/25] drivers/scsi/NCR5380.c: Replacing yield() with a better alternative
Date: Wed, 23 May 2007 14:41:37 -0700
Message-ID: <200705232141.l4NLfb85001165@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758186AbXEWVvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 17:51:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk

From: Amol Lad <amol@verismonetworks.com>

Replaced yield() with cond_resched()

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
