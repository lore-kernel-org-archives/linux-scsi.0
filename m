From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] imm: no need for unchecked_isa_dma
Date: Fri, 19 May 2006 11:55:58 -0700
Message-ID: <20060519115558.7a76015a.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:11727 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932260AbWESSxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 14:53:32 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 11:53:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Relax the lowmem bounce buffer requirement for imm so that any
low memory page will do -- they don't need to be below the
ISA 16 MB limit, just need to be mapped in low memory.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/imm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.17-rc4.orig/drivers/scsi/imm.c
+++ linux-2.6.17-rc4/drivers/scsi/imm.c
@@ -1119,6 +1119,10 @@ static int device_check(imm_struct *dev)
 	return -ENODEV;
 }
 
+/*
+ * imm cannot deal with highmem, so this causes all IO pages for this host
+ * to reside in low memory (hence mapped)
+ */
 static int imm_adjust_queue(struct scsi_device *device)
 {
 	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
@@ -1141,10 +1145,6 @@ static struct scsi_host_template imm_tem
 	.use_clustering		= ENABLE_CLUSTERING,
 	.can_queue		= 1,
 	.slave_alloc		= imm_adjust_queue,
-	.unchecked_isa_dma	= 1, /* imm cannot deal with highmem, so
-				      * this is an easy trick to ensure
-				      * all io pages for this host reside
-				      * in low memory */
 };
 
 /***************************************************************************


---
