From: akpm@osdl.org
Subject: [patch 22/45] ioremap balanced with iounmap for drivers/scsi/fdomain.c
Date: Fri, 20 Oct 2006 14:48:22 -0700
Message-ID: <200610202148.k9KLmMO7004133@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:44934 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992782AbWJTVsi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/fdomain.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/fdomain.c~ioremap-balanced-with-iounmap-drivers-scsi-fdomainc drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c~ioremap-balanced-with-iounmap-drivers-scsi-fdomainc
+++ a/drivers/scsi/fdomain.c
@@ -779,7 +779,11 @@ found:
    else      printk( " FAILURE\n" );
 #endif
 
-   if (!flag) return 0;		/* iobase not found */
+   if (!flag) {
+	  if (bios_mem)
+		 iounmap(bios_mem);
+	  return 0;		/* iobase not found */
+   }
 
    *irq    = fdomain_get_irq( base );
    *iobase = base;
_
