From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix the aacraid merge a bit more
Date: Thu, 8 May 2003 21:03:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508210341.A28294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:37647 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261968AbTEHSvH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2003 14:51:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.13/drivers/scsi/aacraid/aachba.c	Wed May  7 18:16:33 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Thu May  8 18:24:16 2003
@@ -33,7 +33,6 @@
 #include <linux/completion.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
-#define MAJOR_NR SCSI_DISK0_MAJOR	/* For DEVICE_NR() */
 #include <linux/blk.h>
 #include "scsi.h"
 #include "hosts.h"
@@ -967,9 +966,7 @@
 		memset(inq_data_ptr, 0, sizeof (struct inquiry_data));
 
 		inq_data_ptr->inqd_ver = 2;	/* claim compliance to SCSI-2 */
- 		if(!strstr(UTS_RELEASE,"BOOT")){  // If this is not a RH driver disk kernel
-			inq_data_ptr->inqd_dtq = 0x80;	/* set RMB bit to one indicating that the medium is removable */
-		}
+		inq_data_ptr->inqd_dtq = 0x80;	/* set RMB bit to one indicating that the medium is removable */
 		inq_data_ptr->inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
 		inq_data_ptr->inqd_len = 31;
 		/*Format for "pad2" is  RelAdr | WBus32 | WBus16 |  Sync  | Linked |Reserved| CmdQue | SftRe */
--- 1.6/drivers/scsi/aacraid/aacraid.h	Wed May  7 22:18:41 2003
+++ edited/drivers/scsi/aacraid/aacraid.h	Thu May  8 18:24:16 2003
@@ -1,7 +1,6 @@
 //#define dprintk(x) printk x
 #define dprintk(x)
 
-#include "compat.h"
 /*------------------------------------------------------------------------------
  *              D E F I N E S
  *----------------------------------------------------------------------------*/
@@ -1461,12 +1460,8 @@
  */
 static inline u32 cap_to_cyls(sector_t capacity, u32 divisor)
 {
-#ifdef CONFIG_LBD
-	do_div(capacity, divisor);
-#else
-	capacity /= divisor;
-#endif
-	return (u32) capacity;
+	sector_div(capacity, divisor);
+	return (u32)capacity;
 }
 
 const char *aac_driverinfo(struct Scsi_Host *);
--- 1.1/drivers/scsi/aacraid/compat.h	Wed May  7 22:08:36 2003
+++ edited/drivers/scsi/aacraid/compat.h	Thu May  8 18:24:16 2003
@@ -1,114 +0,0 @@
-/*
- *	Adaptec AAC series RAID controller driver
- *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.  If not, write to
- * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-/*
- * This file is for backwards compatibility with older kernel versions
- */
-#include <linux/version.h>
-#if LINUX_VERSION_CODE  < KERNEL_VERSION(2,4,11)   
-#include <linux/blk.h>
-static inline unsigned int block_size(kdev_t dev)
-{
-	int retval = BLOCK_SIZE;
-	int major = MAJOR(dev);
-
-	if (blksize_size[major]) {
-		int minor = MINOR(dev);
-		if (blksize_size[major][minor])
-			retval = blksize_size[major][minor];
-	}
-	return retval;
-}
-#endif
-
-#if LINUX_VERSION_CODE  <= KERNEL_VERSION(2,4,7)   
-
-#ifndef COMPLETION_INITIALIZER
-
-#include <linux/wait.h>
-
-struct completion {
-	unsigned int done;
-	wait_queue_head_t wait;
-};
-#define COMPLETION_INITIALIZER(work) \
-	{ 0, __WAIT_QUEUE_HEAD_INITIALIZER((work).wait) }
-
-#define DECLARE_COMPLETION(work) \
-	struct completion work = COMPLETION_INITIALIZER(work)
-#define INIT_COMPLETION(x)	((x).done = 0)
-
-static inline void init_completion(struct completion *x)
-{
-	x->done = 0;
-	init_waitqueue_head(&x->wait);
-}
-#endif
-
-#ifndef complete_and_exit
-static inline void complete_and_exit(struct completion *comp, long code)
-{
-	/*
-	if (comp)
-		complete(comp);
-	
-	do_exit(code);
-	*/
-}
-#endif
-
-#endif
-
-#if LINUX_VERSION_CODE  <= KERNEL_VERSION(2,4,2)   
-
-static inline void scsi_set_pci_device(struct Scsi_Host *SHpnt,
-                                       struct pci_dev *pdev)
-{
-//	SHpnt->pci_dev = pdev;
-}
-
-static inline void wait_for_completion(struct completion *x)
-{
-	spin_lock_irq(&x->wait.lock);
-	if (!x->done) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		wait.flags |= WQ_FLAG_EXCLUSIVE;
-		__add_wait_queue_tail(&x->wait, &wait);
-		do {
-			__set_current_state(TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&x->wait.lock);
-			schedule();
-			spin_lock_irq(&x->wait.lock);
-		} while (!x->done);
-		__remove_wait_queue(&x->wait, &wait);
-	}
-	x->done--;
-	spin_unlock_irq(&x->wait.lock);
-}
-
-static inline int pci_set_dma_mask(struct pci_dev *dev, dma_addr_t mask)
-{
-    dev->dma_mask = mask;
-
-    return 0;
-}
-
-#endif
-    
--- 1.17/drivers/scsi/aacraid/linit.c	Wed May  7 22:18:41 2003
+++ edited/drivers/scsi/aacraid/linit.c	Thu May  8 18:24:16 2003
@@ -62,9 +62,7 @@
 
 MODULE_AUTHOR("Red Hat Inc and Adaptec");
 MODULE_DESCRIPTION("Supports Dell PERC2, 2/Si, 3/Si, 3/Di, Adaptec Advanced Raid Products, and HP NetRAID-4M devices. http://domsch.com/linux/ or http://linux.adaptec.com");
-#if LINUX_VERSION_CODE  > KERNEL_VERSION(2,4,7)   
 MODULE_LICENSE("GPL");
-#endif
 MODULE_PARM(nondasd, "i");
 MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
 MODULE_PARM(paemode, "i");
