From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid obsolete APIs in atp870u
Date: Mon, 21 Jun 2004 16:28:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621142843.GD32068@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:43216 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266253AbUFUO2q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 10:28:46 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 + minor cleanups


--- 1.31/drivers/scsi/atp870u.c	2004-05-12 17:46:20 +02:00
+++ edited/drivers/scsi/atp870u.c	2004-06-20 17:48:43 +02:00
@@ -1,6 +1,4 @@
-/* $Id: atp870u.c,v 1.0 1997/05/07 15:22:00 root Exp root $
- *  linux/kernel/atp870u.c
- *
+/*
  *  Copyright (C) 1997	Wu Ching Chen
  *  2.1.x update (C) 1998  Krzysztof G. Baranowski
  *  2.5.x update (C) 2002  Red Hat <alan@redhat.com>
@@ -29,20 +27,19 @@
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/blkdev.h>
-#include <linux/stat.h>
-
 #include <asm/system.h>
 #include <asm/io.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+
 #include "atp870u.h"
 
-/*
- *   static const char RCSid[] = "$Header: /usr/src/linux/kernel/blk_drv/scsi/RCS/atp870u.c,v 1.0 1997/05/07 15:22:00 root Exp root $";
- */
+static struct scsi_host_template atp870u_template;
+static void send_s870(struct Scsi_Host *host);
 
-static unsigned short int sync_idu;
 
 static irqreturn_t atp870u_intr_handle(int irq, void *dev_id,
 					struct pt_regs *regs)
@@ -51,7 +48,7 @@
 	unsigned short int tmpcip, id;
 	unsigned char i, j, target_id, lun;
 	unsigned char *prd;
-	Scsi_Cmnd *workrequ;
+	struct scsi_cmnd *workrequ;
 	unsigned int workportu, tmport;
 	unsigned long adrcntu, k;
 	int errstus;
@@ -348,10 +345,18 @@
 			 *      Complete the command
 			 */
 			 
-			if(workrequ->use_sg)
-				pci_unmap_sg(dev->pdev, (struct scatterlist *)workrequ->buffer, workrequ->use_sg, scsi_to_pci_dma_dir(workrequ->sc_data_direction));
-			else if(workrequ->request_bufflen && workrequ->sc_data_direction != SCSI_DATA_NONE)
-				pci_unmap_single(dev->pdev, workrequ->SCp.dma_handle, workrequ->request_bufflen, scsi_to_pci_dma_dir(workrequ->sc_data_direction));
+			if (workrequ->use_sg) {
+				pci_unmap_sg(dev->pdev,
+					(struct scatterlist *)workrequ->buffer,
+					workrequ->use_sg,
+					workrequ->sc_data_direction);
+			} else if (workrequ->request_bufflen &&
+					workrequ->sc_data_direction != DMA_NONE) {
+				pci_unmap_single(dev->pdev,
+					workrequ->SCp.dma_handle,
+					workrequ->request_bufflen,
+					workrequ->sc_data_direction);
+			}
 			spin_lock_irqsave(dev->host->host_lock, flags);
 			(*workrequ->scsi_done) (workrequ);
 
@@ -456,7 +461,8 @@
  *	Queue a command to the ATP queue. Called with the host lock held.
  */
  
-static int atp870u_queuecommand(Scsi_Cmnd * req_p, void (*done) (Scsi_Cmnd *))
+static int atp870u_queuecommand(struct scsi_cmnd *req_p,
+		void (*done) (struct scsi_cmnd *))
 {
 	unsigned short int m;
 	unsigned int tmport;
@@ -533,7 +539,7 @@
 static void send_s870(struct Scsi_Host *host)
 {
 	unsigned int tmport;
-	Scsi_Cmnd *workrequ;
+	struct scsi_cmnd *workrequ;
 	unsigned int i;
 	unsigned char j, target_id;
 	unsigned char *prd;
@@ -648,7 +654,8 @@
 	if (workrequ->use_sg) {
 		l = 0;
 		sgpnt = (struct scatterlist *) workrequ->request_buffer;
-		sg_count = pci_map_sg(dev->pdev, sgpnt, workrequ->use_sg, scsi_to_pci_dma_dir(workrequ->sc_data_direction));
+		sg_count = pci_map_sg(dev->pdev, sgpnt, workrequ->use_sg,
+				workrequ->sc_data_direction);
 		for (i = 0; i < workrequ->use_sg; i++) {
 			if (sgpnt[i].length == 0 || workrequ->use_sg > ATP870U_SCATTER) {
 				panic("Foooooooood fight!");
@@ -656,7 +663,10 @@
 			l += sgpnt[i].length;
 		}
 	} else if(workrequ->request_bufflen && workrequ->sc_data_direction != PCI_DMA_NONE) {
-		workrequ->SCp.dma_handle = pci_map_single(dev->pdev, workrequ->request_buffer, workrequ->request_bufflen, scsi_to_pci_dma_dir(workrequ->sc_data_direction));
+		workrequ->SCp.dma_handle = pci_map_single(dev->pdev,
+				workrequ->request_buffer,
+				workrequ->request_bufflen,
+				workrequ->sc_data_direction);
 		l = workrequ->request_bufflen;
 	}
 	else l = 0;
@@ -678,7 +688,7 @@
 	/*
 	 *      Check transfer direction
 	 */
-	if (workrequ->sc_data_direction == SCSI_DATA_WRITE) {
+	if (workrequ->sc_data_direction == DMA_TO_DEVICE) {
 		outb((unsigned char) (j | 0x20), tmport++);
 	} else {
 		outb(j, tmport++);
@@ -770,7 +780,7 @@
 	}
 	tmport = workportu + 0x1c;
 
-	if (workrequ->sc_data_direction == SCSI_DATA_WRITE) {
+	if (workrequ->sc_data_direction == DMA_TO_DEVICE) {
 		dev->id[target_id].dirctu = 0x20;
 		if (inb(tmport) == 0) {
 			tmport = workportu + 0x18;
@@ -1089,7 +1099,6 @@
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	struct atp_unit *dev = (struct atp_unit *)&host->hostdata;
 
-	sync_idu = 0;
 	tmport = wkport + 0x3a;
 	outb((unsigned char) (inb(tmport) | 0x10), tmport);
 
@@ -1583,7 +1592,6 @@
 	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
 	struct atp_unit *dev = (struct atp_unit *)&host->hostdata;
 
-	sync_idu = 0;
 	lvdmode = inb(wkport + 0x3f) & 0x40;
 
 	for (i = 0; i < 16; i++) {
@@ -2262,7 +2270,7 @@
 		dev->sp[k] = 0x04;
 	}
 	return 0;
-}			
+}
 
 /* return non-zero on detection */
 static int atp870u_probe(struct pci_dev *dev, const struct pci_device_id *ent)
@@ -2555,10 +2563,10 @@
    it is available to be used again.  Until this gets worked out, we will
    leave it commented out.  */
 
-int atp870u_abort(Scsi_Cmnd * SCpnt)
+static int atp870u_abort(struct scsi_cmnd * SCpnt)
 {
 	unsigned char j, k;
-	Scsi_Cmnd *workrequ;
+	struct scsi_cmnd *workrequ;
 	unsigned int tmport;
 	struct atp_unit *dev = (struct atp_unit *)&SCpnt->device->host->hostdata;
 
@@ -2594,7 +2602,7 @@
 	return SUCCESS;
 }
 
-const char *atp870u_info(struct Scsi_Host *notused)
+static const char *atp870u_info(struct Scsi_Host *notused)
 {
 	static char buffer[128];
 
@@ -2603,13 +2611,9 @@
 	return buffer;
 }
 
-int atp870u_set_info(char *buffer, int length, struct Scsi_Host *HBAptr)
-{
-	return -ENOSYS;		/* Currently this is a no-op */
-}
-
 #define BLS buffer + len + size
-int atp870u_proc_info(struct Scsi_Host *HBAptr, char *buffer, char **start, off_t offset, int length, int inout)
+static int atp870u_proc_info(struct Scsi_Host *HBAptr, char *buffer,
+		char **start, off_t offset, int length, int inout)
 {
 	static u8 buff[512];
 	int size = 0;
@@ -2617,9 +2621,8 @@
 	off_t begin = 0;
 	off_t pos = 0;
 
-	if (inout == TRUE) {	/* Has data been written to the file? */
-		return (atp870u_set_info(buffer, length, HBAptr));
-	}
+	if (inout)
+		return -ENOSYS;
 	if (offset == 0) {
 		memset(buff, 0, sizeof(buff));
 	}
@@ -2679,7 +2682,7 @@
 
 MODULE_LICENSE("GPL");
 
-static Scsi_Host_Template atp870u_template = {
+static struct scsi_host_template atp870u_template = {
 	.module			= THIS_MODULE,
 	.name			= "atp870u",
 	.proc_name		= "atp870u",
@@ -2718,8 +2721,7 @@
 
 static int __init atp870u_init(void)
 {
-	pci_register_driver(&atp870u_driver);
-	return 0;
+	return pci_module_init(&atp870u_driver);
 }
 
 static void __exit atp870u_exit(void)
--- 1.13/drivers/scsi/atp870u.h	2004-01-10 20:05:06 +01:00
+++ edited/drivers/scsi/atp870u.h	2004-06-20 17:42:00 +02:00
@@ -1,16 +1,6 @@
 #ifndef _ATP870U_H
 #define _ATP870U_H
 
-/* $Id: atp870u.h,v 1.0 1997/05/07 15:09:00 root Exp root $
-
- * Header file for the ACARD 870U/W driver for Linux
- *
- * $Log: atp870u.h,v $
- * Revision 1.0  1997/05/07  15:09:00  root
- * Initial revision
- *
- */
-
 #include <linux/types.h>
 
 /* I/O Port */
@@ -41,7 +31,7 @@
 	unsigned short deviceid;
 	unsigned char ata_cdbu[16];
 	unsigned char sp[16];
-	Scsi_Cmnd *querequ[qcnt];
+	struct scsi_cmnd *querequ[qcnt];
 	struct atp_id {
 		unsigned char dirctu;
 		unsigned char devspu;
@@ -52,20 +42,11 @@
 		unsigned char *prd_posu;
 		unsigned char *prd_tableu;
 		dma_addr_t prd_phys;
-		Scsi_Cmnd *curr_req;
+		struct scsi_cmnd *curr_req;
 	} id[16];
 	struct Scsi_Host *host;
 	struct pci_dev *pdev;
 	unsigned int unit;
 };
-
-static int atp870u_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-static int atp870u_abort(Scsi_Cmnd *);
-static int atp870u_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int *);
-static void send_s870(struct Scsi_Host *);
-
-extern const char *atp870u_info(struct Scsi_Host *);
-static Scsi_Host_Template atp870u_template;
 
 #endif
