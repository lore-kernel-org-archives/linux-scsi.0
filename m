From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix an aha1740 merge error
Date: Fri, 27 Jun 2003 19:50:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030627175036.GA20040@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:34014 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264537AbTF0Rga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 13:36:30 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

it should use scsi_host_alloc/scsi_host_put now.


diff -Nru a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
--- a/drivers/scsi/aha1740.c	Thu Jun 26 21:56:47 2003
+++ b/drivers/scsi/aha1740.c	Thu Jun 26 21:56:47 2003
@@ -606,7 +606,7 @@
 	       dev->name, slotbase, irq_level);
 	printk(KERN_INFO "aha174x: Extended translation %sabled.\n",
 	       translation ? "en" : "dis");
-	shpnt = scsi_register(&aha1740_template,
+	shpnt = scsi_host_alloc(&aha1740_template,
 			      sizeof(struct aha1740_hostdata));
 	if(shpnt == NULL)
 		goto err_release;
@@ -658,7 +658,7 @@
 			  sizeof (host->ecb), DMA_BIDIRECTIONAL);
 	release_region (shpnt->io_port, SLOTSIZE);
 
-	scsi_unregister (shpnt);
+	scsi_host_put (shpnt);
 	
 	return 0;
 }
