From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_scan.c complaints...
Date: Sat, 21 Dec 2002 18:42:25 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021221184225.A3075@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, Dec 20, 2002 at 08:29:23PM -0500, Doug Ledford wrote:
> And I was right.  One little q =3D NULL; is all that was missing.  An=
yway,=20
> here's a printout of what startup looks like with this patch in place=
=20
> under 2.5.52.  This should make you happy Justin ;-)

Okay, I looked at the patches that are in mainline and they look pretty
cool to me.  When looking over the code (in preparation of implementing
Justin's suggestion to get rid of the highmem_io flag) I found quite
a bit small stuff to make the code in that area a lot cleaner:

- new helper scsi_calculate_bounce_limit to calculate the bounce
  limit for a scsi host, remove a copy of that code ni st.c
- scsi_initialize_queue gets replace with scsi_alloc_queue, this
  one now takes only a struct Scsi_Host and returns the request queue,
  it's paired with a small scsi_free_queue helper.

Diffstat:

 hosts.h     |    3 -
 scsi.c      |   43 ----------------------
 scsi.h      |    1
 scsi_scan.c |  113 ++++++++++++++++++++++++++++++++++-----------------=
---------
 scsi_syms.c |    5 ++
 st.c        |   16 +-------
 6 files changed, 73 insertions(+), 108 deletions(-)


--- 1.46/drivers/scsi/hosts.h	Thu Nov 28 14:36:44 2002
+++ edited/drivers/scsi/hosts.h	Sat Dec 21 16:47:36 2002
@@ -554,9 +554,6 @@
     struct device_driver scsi_driverfs_driver;
 };
=20
-void  scsi_initialize_queue(Scsi_Device *, struct Scsi_Host *);
-
-
 /*
  * Highlevel driver registration/unregistration.
  */
--- 1.81/drivers/scsi/scsi.c	Fri Dec 20 20:59:59 2002
+++ edited/drivers/scsi/scsi.c	Sat Dec 21 16:34:24 2002
@@ -147,49 +147,6 @@
 extern void scsi_times_out(Scsi_Cmnd * SCpnt);
 void scsi_build_commandblocks(Scsi_Device * SDpnt);
=20
-/*
- * Function:    scsi_initialize_queue()
- *
- * Purpose:     Sets up the block queue for a device.
- *
- * Arguments:   SDpnt   - device for which we need a handler function.
- *
- * Returns:     Nothing
- *
- * Lock status: No locking assumed or required.
- */
-void  scsi_initialize_queue(Scsi_Device * SDpnt, struct Scsi_Host * SH=
pnt)
-{
-	request_queue_t *q =3D SDpnt->request_queue;
-
-	/*
-	 * tell block layer about assigned host_lock for this host
-	 */
-	blk_init_queue(q, scsi_request_fn, SHpnt->host_lock);
-
-	/* Hardware imposed limit. */
-	blk_queue_max_hw_segments(q, SHpnt->sg_tablesize);
-
-	/*
-	 * scsi_alloc_sgtable max
-	 */
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
-
-	if(!SHpnt->max_sectors)
-		/* driver imposes no hard sector transfer limit.
-		 * start at machine infinity initially */
-		SHpnt->max_sectors =3D SCSI_DEFAULT_MAX_SECTORS;
-
-	/* FIXME: we should also adjust this limit later on
-	 * after we know what the device capabilities are */
-	blk_queue_max_sectors(q, SHpnt->max_sectors);
-
-	if (!SHpnt->use_clustering)
-		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
-
-        blk_queue_prep_rq(q, scsi_prep_fn);
-}
-
 #ifdef MODULE
 MODULE_PARM(scsi_logging_level, "i");
 MODULE_PARM_DESC(scsi_logging_level, "SCSI logging level; should be ze=
ro or nonzero");
--- 1.53/drivers/scsi/scsi.h	Fri Dec 20 20:59:59 2002
+++ edited/drivers/scsi/scsi.h	Sat Dec 21 16:54:22 2002
@@ -511,6 +511,7 @@
  */
 extern int scsi_add_single_device(uint, uint, uint, uint);
 extern int scsi_remove_single_device(uint, uint, uint, uint);
+extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
=20
 /*
  * Prototypes for functions in constants.c
--- 1.50/drivers/scsi/scsi_scan.c	Fri Dec 20 21:00:00 2002
+++ edited/drivers/scsi/scsi_scan.c	Sat Dec 21 17:44:03 2002
@@ -28,7 +28,6 @@
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/init.h>
-
 #include <linux/blk.h>
=20
 #include "scsi.h"
@@ -365,34 +364,60 @@
 		printk("\n");
 }
=20
-/**
- * scsi_initialize_merge_fn() -=C6=A3initialize merge function for a h=
ost
- * @sd:		host descriptor
- */
-static void scsi_initialize_merge_fn(struct scsi_device *sd)
+u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 {
-	request_queue_t *q =3D sd->request_queue;
-	struct Scsi_Host *sh =3D sd->host;
-	struct device *dev =3D scsi_get_device(sh);
-	u64 bounce_limit;
-
-	if (sh->highmem_io) {
-		if (dev && dev->dma_mask && PCI_DMA_BUS_IS_PHYS) {
-			bounce_limit =3D *dev->dma_mask;
-		} else {
-			/*
-			 * Platforms with virtual-DMA translation
- 			 * hardware have no practical limit.
-			 */
-			bounce_limit =3D BLK_BOUNCE_ANY;
-		}
-	} else if (sh->unchecked_isa_dma) {
-		bounce_limit =3D BLK_BOUNCE_ISA;
-	} else {
-		bounce_limit =3D BLK_BOUNCE_HIGH;
+	if (shost->highmem_io) {
+		struct device *host_dev =3D scsi_get_device(shost);
+
+		if (PCI_DMA_BUS_IS_PHYS && host_dev && host_dev->dma_mask)
+			return *host_dev->dma_mask;
+
+		/*
+		 * Platforms with virtual-DMA translation
+ 		 * hardware have no practical limit.
+		 */
+		return BLK_BOUNCE_ANY;
+	} else if (shost->unchecked_isa_dma)
+		return BLK_BOUNCE_ISA;
+
+	return BLK_BOUNCE_HIGH;
+}
+
+static request_queue_t *scsi_alloc_queue(struct Scsi_Host *shost)
+{
+	request_queue_t *q;
+
+	q =3D kmalloc(sizeof(*q), GFP_ATOMIC);
+	if (!q)
+		return NULL;
+	memset(q, 0, sizeof(*q));
+
+	if (!shost->max_sectors) {
+		/*
+		 * Driver imposes no hard sector transfer limit.
+		 * start at machine infinity initially.
+		 */
+		shost->max_sectors =3D SCSI_DEFAULT_MAX_SECTORS;
 	}
=20
-	blk_queue_bounce_limit(q, bounce_limit);
+	blk_init_queue(q, scsi_request_fn, shost->host_lock);
+	blk_queue_prep_rq(q, scsi_prep_fn);
+
+	blk_queue_max_hw_segments(q, shost->sg_tablesize);
+	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
+	blk_queue_max_sectors(q, shost->max_sectors);
+	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
+
+	if (!shost->use_clustering)
+		clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
+
+	return q;
+}
+
+static void scsi_free_queue(request_queue_t *q)
+{
+	blk_cleanup_queue(q);
+	kfree(q);
 }
=20
 /**
@@ -435,19 +460,15 @@
 		 */
 		sdev->borken =3D 1;
=20
-		if(!q || *q =3D=3D NULL) {
-			sdev->request_queue =3D kmalloc(sizeof(struct request_queue), GFP_A=
TOMIC);
-			if(sdev->request_queue =3D=3D NULL) {
+		if (!q || *q =3D=3D NULL) {
+			sdev->request_queue =3D scsi_alloc_queue(shost);
+			if (!sdev->request_queue)
 				goto out_bail;
-			}
-			memset(sdev->request_queue, 0,
-				       	sizeof(struct request_queue));
-			scsi_initialize_queue(sdev, shost);
-			scsi_initialize_merge_fn(sdev);
 		} else {
 			sdev->request_queue =3D *q;
 			*q =3D NULL;
 		}
+
 		sdev->request_queue->queuedata =3D sdev;
 		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 		scsi_build_commandblocks(sdev);
@@ -488,13 +509,12 @@
 	}
 out_bail:
 	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
-	if(q && sdev->request_queue) {
+	if (q && sdev->request_queue) {
 		*q =3D sdev->request_queue;
 		sdev->request_queue =3D NULL;
-	} else if(sdev->request_queue) {
-		blk_cleanup_queue(sdev->request_queue);
-		kfree(sdev->request_queue);
-	}
+	} else if (sdev->request_queue)
+		scsi_free_queue(sdev->request_queue);
+
 	scsi_release_commandblocks(sdev);
 	kfree(sdev);
 	return NULL;
@@ -513,14 +533,12 @@
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
=20
-	if(sdev->request_queue !=3D NULL) {
-		blk_cleanup_queue(sdev->request_queue);
-		kfree(sdev->request_queue);
-	}
+	if (sdev->request_queue)
+		scsi_free_queue(sdev->request_queue);
 	scsi_release_commandblocks(sdev);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-	if (sdev->inquiry !=3D NULL)
+	if (sdev->inquiry)
 		kfree(sdev->inquiry);
 	kfree(sdev);
 }
@@ -1946,10 +1964,9 @@
 			scsi_scan_target(shost, &q, channel, order_id);
 		}
 	}
-	if(q) {
-		blk_cleanup_queue(q);
-		kfree(q);
-	}
+
+	if (q)
+		scsi_free_queue(q);
 }
=20
 void scsi_forget_host(struct Scsi_Host *shost)
--- 1.23/drivers/scsi/scsi_syms.c	Thu Nov 28 09:09:53 2002
+++ edited/drivers/scsi/scsi_syms.c	Sat Dec 21 17:52:49 2002
@@ -98,6 +98,11 @@
 EXPORT_SYMBOL(scsi_device_types);
=20
 /*
+ * This is for st to find the bounce limit
+ */
+EXPORT_SYMBOL(scsi_calculate_bounce_limit);
+
+/*
  * Externalize timers so that HBAs can safely start/restart commands.
  */
 extern void scsi_add_timer(Scsi_Cmnd *, int, void ((*) (Scsi_Cmnd *)))=
;
--- 1.51/drivers/scsi/st.c	Mon Dec 16 10:55:37 2002
+++ edited/drivers/scsi/st.c	Sat Dec 21 16:53:05 2002
@@ -3764,21 +3764,9 @@
 	tpnt->nbr_partitions =3D 0;
 	tpnt->timeout =3D ST_TIMEOUT;
 	tpnt->long_timeout =3D ST_LONG_TIMEOUT;
-
 	tpnt->try_dio =3D try_direct_io && !SDp->host->unchecked_isa_dma;
-	bounce_limit =3D BLK_BOUNCE_HIGH; /* Borrowed from scsi_merge.c */
-	if (SDp->host->highmem_io) {
-		struct device *dev =3D scsi_get_device(SDp->host);
-		if (!PCI_DMA_BUS_IS_PHYS)
-			/* Platforms with virtual-DMA translation
-			 * hardware have no practical limit.
-			 */
-			bounce_limit =3D BLK_BOUNCE_ANY;
-		else if (dev && dev->dma_mask)
-			bounce_limit =3D *dev->dma_mask;
-	} else if (SDp->host->unchecked_isa_dma)
-		bounce_limit =3D BLK_BOUNCE_ISA;
-	bounce_limit >>=3D PAGE_SHIFT;
+
+	bounce_limit =3D scsi_calculate_bounce_limit(SDp->host) >> PAGE_SHIFT=
;
 	if (bounce_limit > ULONG_MAX)
 		bounce_limit =3D ULONG_MAX;
 	tpnt->max_pfn =3D bounce_limit;




-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
