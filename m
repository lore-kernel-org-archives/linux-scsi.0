From: akpm@osdl.org
Subject: [patch 16/45] ioremap balanced with iounmap for drivers/scsi/sun3_scsi.c
Date: Fri, 20 Oct 2006 14:48:17 -0700
Message-ID: <200610202148.k9KLmHpk004112@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:47750 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992778AbWJTVsk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:40 -0400
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

 drivers/scsi/sun3_scsi.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sun3_scsi.c~ioremap-balanced-with-iounmap-drivers-scsi-sun3_scsic drivers/scsi/sun3_scsi.c
--- a/drivers/scsi/sun3_scsi.c~ioremap-balanced-with-iounmap-drivers-scsi-sun3_scsic
+++ a/drivers/scsi/sun3_scsi.c
@@ -240,11 +240,13 @@ int sun3scsi_detect(struct scsi_host_tem
 	if((udc_regs = dvma_malloc(sizeof(struct sun3_udc_regs)))
 	   == NULL) {
 	     printk("SUN3 Scsi couldn't allocate DVMA memory!\n");
+		 iounmap((void*)ioaddr);
 	     return 0;
 	}
 #ifdef OLDDMA
 	if((dmabuf = dvma_malloc_align(SUN3_DVMA_BUFSIZE, 0x10000)) == NULL) {
 	     printk("SUN3 Scsi couldn't allocate DVMA memory!\n");
+		 iounmap((void*)ioaddr);
 	     return 0;
 	}
 #endif
@@ -254,8 +256,10 @@ int sun3scsi_detect(struct scsi_host_tem
 #endif
 
 	instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if(instance == NULL)
+	if(instance == NULL) {
+		iounmap((void*)ioaddr);
 		return 0;
+	}
 		
 	default_instance = instance;
 
@@ -277,6 +281,7 @@ int sun3scsi_detect(struct scsi_host_tem
 #else
 		printk("scsi%d: IRQ%d not free, bailing out\n",
 		       instance->host_no, instance->irq);
+		iounmap((void*)ioaddr);
 		return 0;
 #endif
 	}
_
