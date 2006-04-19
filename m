From: akpm@osdl.org
Subject: [patch 01/17] git-scsi-misc-scsi_kmap_atomic_sg-warning-fix
Date: Tue, 18 Apr 2006 21:09:08 -0700
Message-ID: <200604190409.k3J49o0o008191@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19661 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750716AbWDSEJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 00:09:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org


From: Andrew Morton <akpm@osdl.org>

drivers/scsi/scsi_lib.c: In function `scsi_kmap_atomic_sg':
drivers/scsi/scsi_lib.c:2394: warning: unsigned int format, different type arg (arg 3)
drivers/scsi/scsi_lib.c:2394: warning: unsigned int format, different type arg (arg 4)



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~git-scsi-misc-scsi_kmap_atomic_sg-warning-fix drivers/scsi/scsi_lib.c
--- 25/drivers/scsi/scsi_lib.c~git-scsi-misc-scsi_kmap_atomic_sg-warning-fix	2006-04-17 05:26:50.000000000 -0600
+++ 25-akpm/drivers/scsi/scsi_lib.c	2006-04-17 05:28:25.000000000 -0600
@@ -2390,7 +2390,8 @@ void *scsi_kmap_atomic_sg(struct scatter
 	}
 
 	if (unlikely(i == sg_count)) {
-		printk(KERN_ERR "%s: Bytes in sg: %u, requested offset %u, elements %d\n",
+		printk(KERN_ERR "%s: Bytes in sg: %zu, requested offset %zu, "
+			"elements %d\n",
 		       __FUNCTION__, sg_len, *offset, sg_count);
 		WARN_ON(1);
 		return NULL;
_
