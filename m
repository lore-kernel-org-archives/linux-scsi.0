From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill blk_nohighio boot parameter
Date: Fri, 6 Jun 2003 10:03:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606080346.GE18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:16081 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264720AbTFFHuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 03:50:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

It was useful in 2.4 to debug the blockhighmem stuff but in 2.5
it's b0rked because doesn't have any implication except propagation
of the highmem_io flags from the scsi host template to the scsi
host structure.  It also only worked on i386.

ACKed by Jens.


diff -Nru a/arch/i386/kernel/setup.c b/arch/i386/kernel/setup.c
--- a/arch/i386/kernel/setup.c	Tue Jun  3 01:32:46 2003
+++ b/arch/i386/kernel/setup.c	Tue Jun  3 01:32:46 2003
@@ -96,7 +96,6 @@
 extern void generic_apic_probe(char *);
 extern int root_mountflags;
 extern char _text, _etext, _edata, _end;
-extern int blk_nohighio;
 
 unsigned long saved_videomode;
 
@@ -991,15 +990,6 @@
 #endif
 #endif
 }
-
-static int __init highio_setup(char *str)
-{
-	printk("i386: disabling HIGHMEM block I/O\n");
-	blk_nohighio = 1;
-	return 1;
-}
-__setup("nohighio", highio_setup);
- 
 
 #include "setup_arch_post.h"
 /*
diff -Nru a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
--- a/drivers/block/ll_rw_blk.c	Tue Jun  3 01:32:46 2003
+++ b/drivers/block/ll_rw_blk.c	Tue Jun  3 01:32:46 2003
@@ -49,8 +49,6 @@
 static int queue_nr_requests;
 
 unsigned long blk_max_low_pfn, blk_max_pfn;
-int blk_nohighio = 0;
-
 static wait_queue_head_t congestion_wqh[2];
 
 /*
@@ -2361,7 +2359,6 @@
 EXPORT_SYMBOL(blk_queue_segment_boundary);
 EXPORT_SYMBOL(blk_queue_dma_alignment);
 EXPORT_SYMBOL(blk_rq_map_sg);
-EXPORT_SYMBOL(blk_nohighio);
 EXPORT_SYMBOL(blk_dump_rq_flags);
 EXPORT_SYMBOL(submit_bio);
 EXPORT_SYMBOL(blk_queue_assign_lock);
diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Tue Jun  3 01:32:46 2003
+++ b/drivers/scsi/hosts.c	Tue Jun  3 01:32:46 2003
@@ -125,7 +125,6 @@
  **/
 struct Scsi_Host *scsi_host_alloc(Scsi_Host_Template *sht, int privsize)
 {
-	extern int blk_nohighio;
 	struct Scsi_Host *shost;
 	int gfp_mask = GFP_KERNEL, rval;
 	DECLARE_COMPLETION(complete);
@@ -186,8 +185,7 @@
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->use_blk_tcq = sht->use_blk_tcq;
-	if (!blk_nohighio)
-		shost->highmem_io = sht->highmem_io;
+	shost->highmem_io = sht->highmem_io;
 
 	if (!sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
