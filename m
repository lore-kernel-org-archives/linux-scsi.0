From: akpm@osdl.org
Subject: [patch 17/26] drivers/scsi/NCR5380.c: Replacing yield() with a better alternative
Date: Wed, 08 Nov 2006 19:56:21 -0800
Message-ID: <200611090356.kA93uLZb003973@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63921 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424009AbWKID4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:56:31 -0500
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
 1 file changed, 1 insertion(+), 1 deletion(-)

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
