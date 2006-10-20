From: akpm@osdl.org
Subject: [patch 17/45] ioremap balanced with iounmap for drivers/scsi/sun3_vme.c
Date: Fri, 20 Oct 2006 14:48:18 -0700
Message-ID: <200610202148.k9KLmIKY004115@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61318 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992790AbWJTVsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com, davem@davemloft.net

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sun3_scsi_vme.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sun3_scsi_vme.c~ioremap-balanced-with-iounmap-drivers-scsi-sun3_scsi_vmec drivers/scsi/sun3_scsi_vme.c
--- a/drivers/scsi/sun3_scsi_vme.c~ioremap-balanced-with-iounmap-drivers-scsi-sun3_scsi_vmec
+++ a/drivers/scsi/sun3_scsi_vme.c
@@ -216,8 +216,10 @@ static int sun3scsi_detect(struct scsi_h
 #endif
 
 	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if(instance == NULL)
+	if(instance == NULL) {
+		iounmap((void *)ioaddr);
 		return 0;
+	}
 		
 	default_instance = instance;
 
@@ -239,6 +241,7 @@ static int sun3scsi_detect(struct scsi_h
 #else
 		printk("scsi%d: IRQ%d not free, bailing out\n",
 		       instance->host_no, instance->irq);
+		iounmap((void *)ioaddr);
 		return 0;
 #endif
 	}
_
