From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_merge.c
Date: Thu, 24 Oct 2002 02:53:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021024025317.B20656@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

In 2.5.44 it contains only two functions, that both have exactly
one caller in other files and both are entirely unrelated to
request merging..

--- 1.28/drivers/scsi/Makefile	Sun Oct 13 17:12:43 2002
+++ edited/drivers/scsi/Makefile	Wed Oct 23 17:09:17 2002
@@ -122,8 +122,8 @@
 obj-$(CONFIG_CHR_DEV_SG)	+=3D sg.o
=20
 scsi_mod-objs	:=3D scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o \
-			scsi_proc.o scsi_error.o scsi_lib.o scsi_merge.o \
-			scsi_scan.o scsi_syms.o
+			scsi_proc.o scsi_error.o scsi_lib.o scsi_scan.o \
+			scsi_syms.o
 		=09
 sd_mod-objs	:=3D sd.o
 sr_mod-objs	:=3D sr.o sr_ioctl.o sr_vendor.o
--- 1.29/drivers/scsi/scsi.h	Thu Oct 17 17:16:34 2002
+++ edited/drivers/scsi/scsi.h	Wed Oct 23 17:12:40 2002
@@ -446,20 +446,6 @@
 void scsi_free_sgtable(struct scatterlist *sgl, int index);
=20
 /*
- * Prototypes for functions in scsi_dma.c
- */
-void scsi_resize_dma_pool(void);
-int scsi_init_minimal_dma_pool(void);
-void *scsi_malloc(unsigned int);
-int scsi_free(void *, unsigned int);
-
-/*
- * Prototypes for functions in scsi_merge.c
- */
-extern void scsi_initialize_merge_fn(Scsi_Device *SDpnt);
-extern int scsi_init_io(Scsi_Cmnd *SCpnt);
-
-/*
  * Prototypes for functions in scsi_lib.c
  */
 extern int scsi_maybe_unblock_host(Scsi_Device * SDpnt);
--- 1.35/drivers/scsi/scsi_lib.c	Fri Oct 18 15:19:51 2002
+++ edited/drivers/scsi/scsi_lib.c	Wed Oct 23 17:07:52 2002
@@ -730,6 +730,92 @@
 }
=20
 /*
+ * Function:    scsi_init_io()
+ *
+ * Purpose:     SCSI I/O initialize function.
+ *
+ * Arguments:   SCpnt   - Command descriptor we wish to initialize
+ *
+ * Returns:     1 on success.
+ */
+static int scsi_init_io(Scsi_Cmnd *SCpnt)
+{
+	struct request     *req =3D SCpnt->request;
+	struct scatterlist *sgpnt;
+	int count, gfp_mask;
+
+	/*
+	 * non-sg block request. FIXME: check bouncing for isa hosts!
+	 */
+	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
+		/*
+		 * FIXME: isa bouncing
+		 */
+		if (SCpnt->host->unchecked_isa_dma)
+			goto fail;
+
+		SCpnt->request_bufflen =3D req->data_len;
+		SCpnt->request_buffer =3D req->data;
+		req->buffer =3D req->data;
+		SCpnt->use_sg =3D 0;
+		return 1;
+	}
+
+	/*
+	 * we used to not use scatter-gather for single segment request,
+	 * but now we do (it makes highmem I/O easier to support without
+	 * kmapping pages)
+	 */
+	SCpnt->use_sg =3D req->nr_phys_segments;
+
+	gfp_mask =3D GFP_NOIO;
+	if (in_interrupt()) {
+		gfp_mask &=3D ~__GFP_WAIT;
+		gfp_mask |=3D __GFP_HIGH;
+	}
+
+	/*
+	 * if sg table allocation fails, requeue request later.
+	 */
+	sgpnt =3D scsi_alloc_sgtable(SCpnt, gfp_mask);
+	if (unlikely(!sgpnt))
+		goto out;
+
+	SCpnt->request_buffer =3D (char *) sgpnt;
+	SCpnt->request_bufflen =3D req->nr_sectors << 9;
+	req->buffer =3D NULL;
+
+	/*=20
+	 * Next, walk the list, and fill in the addresses and sizes of
+	 * each segment.
+	 */
+	count =3D blk_rq_map_sg(req->q, req, SCpnt->request_buffer);
+
+	/*
+	 * mapped well, send it off
+	 */
+	if (unlikely(count > SCpnt->use_sg))
+		goto incorrect;
+	SCpnt->use_sg =3D count;
+	return 1;
+
+incorrect:
+	printk(KERN_ERR "Incorrect number of segments after building list\n")=
;
+	printk(KERN_ERR "counted %d, received %d\n", count, SCpnt->use_sg);
+	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
+			req->current_nr_sectors);
+
+	/*
+	 * kill it. there should be no leftover blocks in this request
+	 */
+fail:
+	SCpnt =3D scsi_end_request(SCpnt, 0, req->nr_sectors);
+	BUG_ON(SCpnt);
+out:
+	return 0;
+}
+
+/*
  * Function:    scsi_request_fn()
  *
  * Purpose:     Generic version of request function for SCSI hosts.
--- 1.24/drivers/scsi/scsi_merge.c	Fri Oct 18 15:19:51 2002
+++ edited/drivers/scsi/scsi_merge.c	Wed Oct 23 17:08:07 2002
@@ -1,168 +0,0 @@
-/*
- *  scsi_merge.c Copyright (C) 1999 Eric Youngdale
- *
- *  SCSI queueing library.
- *      Initial versions: Eric Youngdale (eric@andante.org).
- *                        Based upon conversations with large numbers
- *                        of people at Linux Expo.
- *	Support for dynamic DMA mapping: Jakub Jelinek (jakub@redhat.com).
- *	Support for highmem I/O: Jens Axboe <axboe@suse.de>
- */
-
-/*
- * This file contains queue management functions that are used by SCSI=
=2E
- * We need to ensure that commands do not grow so large that they cann=
ot
- * be handled all at once by a host adapter.
- */
-
-#include <linux/config.h>
-#include <linux/module.h>
-
-#include <linux/sched.h>
-#include <linux/timer.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/ioport.h>
-#include <linux/kernel.h>
-#include <linux/stat.h>
-#include <linux/blk.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/smp_lock.h>
-
-
-#define __KERNEL_SYSCALLS__
-
-#include <linux/unistd.h>
-
-#include <asm/system.h>
-#include <asm/irq.h>
-#include <asm/dma.h>
-#include <asm/io.h>
-
-#include "scsi.h"
-#include "hosts.h"
-#include <scsi/scsi_ioctl.h>
-
-/*
- * Function:    scsi_init_io()
- *
- * Purpose:     SCSI I/O initialize function.
- *
- * Arguments:   SCpnt   - Command descriptor we wish to initialize
- *
- * Returns:     1 on success.
- *
- * Lock status:=20
- */
-int scsi_init_io(Scsi_Cmnd *SCpnt)
-{
-	struct request     *req =3D SCpnt->request;
-	struct scatterlist *sgpnt;
-	int count, gfp_mask;
-
-	/*
-	 * non-sg block request. FIXME: check bouncing for isa hosts!
-	 */
-	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
-		/*
-		 * FIXME: isa bouncing
-		 */
-		if (SCpnt->host->unchecked_isa_dma)
-			goto fail;
-
-		SCpnt->request_bufflen =3D req->data_len;
-		SCpnt->request_buffer =3D req->data;
-		req->buffer =3D req->data;
-		SCpnt->use_sg =3D 0;
-		return 1;
-	}
-
-	/*
-	 * we used to not use scatter-gather for single segment request,
-	 * but now we do (it makes highmem I/O easier to support without
-	 * kmapping pages)
-	 */
-	SCpnt->use_sg =3D req->nr_phys_segments;
-
-	gfp_mask =3D GFP_NOIO;
-	if (in_interrupt()) {
-		gfp_mask &=3D ~__GFP_WAIT;
-		gfp_mask |=3D __GFP_HIGH;
-	}
-
-	/*
-	 * if sg table allocation fails, requeue request later.
-	 */
-	sgpnt =3D scsi_alloc_sgtable(SCpnt, gfp_mask);
-	if (!sgpnt)
-		return 0;
-
-	SCpnt->request_buffer =3D (char *) sgpnt;
-	SCpnt->request_bufflen =3D req->nr_sectors << 9;
-	req->buffer =3D NULL;
-
-	/*=20
-	 * Next, walk the list, and fill in the addresses and sizes of
-	 * each segment.
-	 */
-	count =3D blk_rq_map_sg(req->q, req, SCpnt->request_buffer);
-
-	/*
-	 * mapped well, send it off
-	 */
-	if (count <=3D SCpnt->use_sg) {
-		SCpnt->use_sg =3D count;
-		return 1;
-	}
-
-	printk("Incorrect number of segments after building list\n");
-	printk("counted %d, received %d\n", count, SCpnt->use_sg);
-	printk("req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors, req->curre=
nt_nr_sectors);
-
-	/*
-	 * kill it. there should be no leftover blocks in this request
-	 */
-fail:
-	SCpnt =3D scsi_end_request(SCpnt, 0, req->nr_sectors);
-	BUG_ON(SCpnt);
-	return 0;
-}
-
-/*
- * Function:    scsi_initialize_merge_fn()
- *
- * Purpose:     Initialize merge function for a host
- *
- * Arguments:   SHpnt   - Host descriptor.
- *
- * Returns:     Nothing.
- *
- * Lock status:=20
- *
- * Notes:
- */
-void scsi_initialize_merge_fn(Scsi_Device * SDpnt)
-{
-	struct Scsi_Host *SHpnt =3D SDpnt->host;
-	request_queue_t *q =3D &SDpnt->request_queue;
-	u64 bounce_limit;
-
-	/*
-	 * The generic merging functions work just fine for us.
-	 * Enable highmem I/O, if appropriate.
-	 */
-	bounce_limit =3D BLK_BOUNCE_HIGH;
-	if (SHpnt->highmem_io) {
-		if (!PCI_DMA_BUS_IS_PHYS)
-			/* Platforms with virtual-DMA translation
- 			 * hardware have no practical limit.
-			 */
-			bounce_limit =3D BLK_BOUNCE_ANY;
-		else if (SHpnt->pci_dev)
-			bounce_limit =3D SHpnt->pci_dev->dma_mask;
-	} else if (SHpnt->unchecked_isa_dma)
-		bounce_limit =3D BLK_BOUNCE_ISA;
-
-	blk_queue_bounce_limit(q, bounce_limit);
-}
--- 1.30/drivers/scsi/scsi_scan.c	Tue Oct 22 13:06:06 2002
+++ edited/drivers/scsi/scsi_scan.c	Wed Oct 23 17:04:01 2002
@@ -483,6 +483,35 @@
 }
=20
 /**
+ * scsi_initialize_merge_fn() -=C6=A3initialize merge function for a h=
ost
+ * @sd:		host descriptor
+ */
+static void scsi_initialize_merge_fn(struct scsi_device *sd)
+{
+	request_queue_t *q =3D &sd->request_queue;
+	struct Scsi_Host *sh =3D sd->host;
+	u64 bounce_limit;
+
+	if (sh->highmem_io) {
+		if (sh->pci_dev && PCI_DMA_BUS_IS_PHYS) {
+			bounce_limit =3D sh->pci_dev->dma_mask;
+		} else {
+			/*
+			 * Platforms with virtual-DMA translation
+ 			 * hardware have no practical limit.
+			 */
+			bounce_limit =3D BLK_BOUNCE_ANY;
+		}
+	} else if (sh->unchecked_isa_dma) {
+		bounce_limit =3D BLK_BOUNCE_ISA;
+	} else {
+		bounce_limit =3D BLK_BOUNCE_HIGH;
+	}
+
+	blk_queue_bounce_limit(q, bounce_limit);
+}
+
+/**
  * scsi_alloc_sdev - allocate and setup a Scsi_Device
  *
  * Description:
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
