From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill use_blk_tcq template flag
Date: Sat, 20 Sep 2003 10:34:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920083459.GD20301@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:43757 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261746AbTITIfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 04:35:02 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

The flag isn't checked ever as drivers using the block layer tcq
code do so by themselves, without any interaction to the scsi midlayer.


diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Sat Sep 20 09:35:53 2003
+++ b/drivers/scsi/53c700.c	Sat Sep 20 09:35:53 2003
@@ -281,7 +281,6 @@
 	tpnt->use_clustering = DISABLE_CLUSTERING;
 	tpnt->slave_configure = NCR_700_slave_configure;
 	tpnt->slave_destroy = NCR_700_slave_destroy;
-	tpnt->use_blk_tcq = 1;
 	
 	if(tpnt->name == NULL)
 		tpnt->name = "53c700";
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Sat Sep 20 09:35:53 2003
+++ b/drivers/scsi/hosts.c	Sat Sep 20 09:35:53 2003
@@ -236,7 +236,6 @@
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
-	shost->use_blk_tcq = sht->use_blk_tcq;
 
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sat Sep 20 09:35:53 2003
+++ b/include/scsi/scsi_host.h	Sat Sep 20 09:35:53 2003
@@ -312,12 +312,6 @@
 	 */
 	unsigned emulated:1;
 
-	/* 
-	 * True if the driver wishes to use the generic block layer
-	 * tag queueing functions
-	 */
-	unsigned use_blk_tcq:1;
-
 	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
