From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [RFC] Make the SCSI mempool allocations variable
Date: 09 Mar 2004 14:02:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078858977.1756.40.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:9125 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262089AbUCITDG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 14:03:06 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>, mpm@waste.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Based on Jeremy's request to increase max_phys_segments, this is the way
to do it (SCSI_MAX_PHYS_SEGMENTS) is the value that gets set as the
queue's max_phys_segments.

I have to say that when I tried raising it to 256 and hammering a 10GB
ext2 filesystem, I still didn't generate any >128 segment requests, so
I'm dubious that raising it has any benefit at all, but feel free to try
it and publish the figures.

I did wonder if lowering it might help improve the memory footprint for
some embedded systems, so I set it up to be lowered as far as 32.

James

===== drivers/scsi/scsi_lib.c 1.120 vs edited =====
--- 1.120/drivers/scsi/scsi_lib.c	Mon Feb 23 08:21:36 2004
+++ edited/drivers/scsi/scsi_lib.c	Tue Mar  9 12:04:55 2004
@@ -24,7 +24,7 @@
 #include "scsi_logging.h"
 

-#define SG_MEMPOOL_NR		5
+#define SG_MEMPOOL_NR		(sizeof(scsi_sg_pools)/sizeof(struct scsi_host_sg_pool))
 #define SG_MEMPOOL_SIZE		32
 
 struct scsi_host_sg_pool {
@@ -34,9 +34,27 @@
 	mempool_t	*pool;
 };
 
+#if (SCSI_MAX_PHYS_SEGMENTS < 32)
+#error SCSI_MAX_PHYS_SEGMENTS is too small
+#endif
+
 #define SP(x) { x, "sgpool-" #x } 
-struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR] = { 
-	SP(8), SP(16), SP(32), SP(64), SP(MAX_PHYS_SEGMENTS)
+struct scsi_host_sg_pool scsi_sg_pools[] = { 
+	SP(8),
+	SP(16),
+	SP(32),
+#if (SCSI_MAX_PHYS_SEGMENTS > 32)
+	SP(64),
+#if (SCSI_MAX_PHYS_SEGMENTS > 64)
+	SP(128),
+#if (SCSI_MAX_PHYS_SEGMENTS > 128)
+	SP(256),
+#if (SCSI_MAX_PHYS_SEGMENTS > 256)
+#error SCSI_MAX_PHYS_SEGMENTS is too large
+#endif
+#endif
+#endif
+#endif
 }; 	
 #undef SP
 
@@ -558,12 +576,21 @@
 	case 17 ... 32:
 		cmd->sglist_len = 2;
 		break;
+#if (SCSI_MAX_PHYS_SEGMENTS > 32)
 	case 33 ... 64:
 		cmd->sglist_len = 3;
 		break;
-	case 65 ... MAX_PHYS_SEGMENTS:
+#if (SCSI_MAX_PHYS_SEGMENTS > 64)
+	case 65 ... 128:
 		cmd->sglist_len = 4;
 		break;
+#if (SCSI_MAX_PHYS_SEGMENTS  > 128)
+	case 129 ... 256:
+		cmd->sglist_len = 5;
+		break;
+#endif
+#endif
+#endif
 	default:
 		return NULL;
 	}
@@ -1285,7 +1312,7 @@
 	blk_queue_prep_rq(q, scsi_prep_fn);
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
+	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
===== include/scsi/scsi.h 1.17 vs edited =====
--- 1.17/include/scsi/scsi.h	Wed Feb 11 01:49:41 2004
+++ edited/include/scsi/scsi.h	Tue Mar  9 12:44:40 2004
@@ -10,6 +10,12 @@
 
 #include <linux/types.h>
 
+/*
+ *	The maximum sg list length SCSI can cope with
+ *	(currently must be a power of 2 between 32 and 256)
+ */
+#define SCSI_MAX_PHYS_SEGMENTS	MAX_PHYS_SEGMENTS
+
 
 /*
  *	SCSI command lengths

