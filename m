From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid updates for new proing APIs
Date: Fri, 21 Nov 2003 11:30:19 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121113019.A15853@infradead.org>
References: <20031118110110.A22400@infradead.org> <1069190962.26419.29.camel@markh1.pdx.osdl.net> <20031119124828.A11769@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:56588 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264355AbTKULa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 06:30:29 -0500
Content-Disposition: inline
In-Reply-To: <20031119124828.A11769@infradead.org>; from hch@infradead.org on Wed, Nov 19, 2003 at 12:48:28PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Nov 19, 2003 at 12:48:28PM +0000, Christoph Hellwig wrote:
> On Tue, Nov 18, 2003 at 01:29:22PM -0800, Mark Haverkamp wrote:
> > > +	pci_set_master(pdev);
> > > +	pci_set_dma_mask(pdev, 0xFFFFFFFFULL);
> > 
> > I've been told that the return value of this should be checked as it is
> > possible for it to fail.
> 
> Indeed.  This patches objective was to convert aacraid to the new-style
> probing, not to fix bugs, but I'll add the fix to the next revision of
> the patch anyway.

Ok here's a new patch.  Updates:

  - check pci_set_dma_mask return value
  - fix leak in the HBA remove path
  - fix leak in probe_one failure case
  - remove unused list of hosts
  - avoid scsi.h usage all over driver
  - mention the updates in the README file

--- 1.3/drivers/scsi/aacraid/README	Tue Sep 23 20:50:44 2003
+++ edited/drivers/scsi/aacraid/README	Wed Nov 19 18:44:06 2003
@@ -28,7 +28,8 @@
 People
 -------------------------
 Alan Cox <alan@redhat.com>
-Christoph Hellwig <hch@infradead.org>	(small cleanups/fixes)
+Christoph Hellwig <hch@infradead.org>	(updates for new-style PCI probing and SCSI host registration,
+					 small cleanups/fixes)
 Matt Domsch <matt_domsch@dell.com>	(revision ioctl, adapter messages)
 Deanna Bonds <deanna_bonds@adaptec.com> (non-DASD support, PAE fibs and 64 bit, added new adaptec controllers
 					 added new ioctls, changed scsi interface to use new error handler,
===== drivers/scsi/aacraid/aachba.c 1.20 vs edited =====
--- 1.20/drivers/scsi/aacraid/aachba.c	Fri May  2 21:30:49 2003
+++ edited/drivers/scsi/aacraid/aachba.c	Wed Nov 19 18:36:23 2003
@@ -4,6 +4,7 @@
  *
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
+ *
  * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
@@ -22,7 +23,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -31,11 +31,14 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
+#include <linux/blkdev.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
-#include <linux/blkdev.h>
-#include "scsi.h"
-#include "hosts.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 
 #include "aacraid.h"
 
@@ -194,9 +197,9 @@
  
 static struct fsa_scsi_hba *fsa_dev[MAXIMUM_NUM_ADAPTERS];	/*  SCSI Device Instance Pointers */
 static struct sense_data sense_data[MAXIMUM_NUM_CONTAINERS];
-static unsigned long aac_build_sg(Scsi_Cmnd* scsicmd, struct sgmap* sgmap);
-static unsigned long aac_build_sg64(Scsi_Cmnd* scsicmd, struct sgmap64* psg);
-static int aac_send_srb_fib(Scsi_Cmnd* scsicmd);
+static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* sgmap);
+static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg);
+static int aac_send_srb_fib(struct scsi_cmnd* scsicmd);
 #ifdef AAC_DETAILED_STATUS_INFO
 static char *aac_get_status_string(u32 status);
 #endif
@@ -444,7 +447,7 @@
 	}
 }
 
-static void aac_io_done(Scsi_Cmnd * scsicmd)
+static void aac_io_done(struct scsi_cmnd * scsicmd)
 {
 	unsigned long cpu_flags;
 	struct Scsi_Host *host = scsicmd->device->host;
@@ -453,7 +456,7 @@
 	spin_unlock_irqrestore(host->host_lock, cpu_flags);
 }
 
-static void __aac_io_done(Scsi_Cmnd * scsicmd)
+static void __aac_io_done(struct scsi_cmnd * scsicmd)
 {
 	scsicmd->scsi_done(scsicmd);
 }
@@ -538,11 +541,11 @@
 {
 	struct aac_dev *dev;
 	struct aac_read_reply *readreply;
-	Scsi_Cmnd *scsicmd;
+	struct scsi_cmnd *scsicmd;
 	u32 lba;
 	u32 cid;
 
-	scsicmd = (Scsi_Cmnd *) context;
+	scsicmd = (struct scsi_cmnd *) context;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	cid =TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
@@ -557,11 +560,11 @@
 		pci_unmap_sg(dev->pdev, 
 			(struct scatterlist *)scsicmd->buffer,
 			scsicmd->use_sg,
-			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
 		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
 				 scsicmd->request_bufflen,
-				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+				 scsicmd->sc_data_direction);
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
 	if (le32_to_cpu(readreply->status) == ST_OK)
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
@@ -584,11 +587,11 @@
 {
 	struct aac_dev *dev;
 	struct aac_write_reply *writereply;
-	Scsi_Cmnd *scsicmd;
+	struct scsi_cmnd *scsicmd;
 	u32 lba;
 	u32 cid;
 
-	scsicmd = (Scsi_Cmnd *) context;
+	scsicmd = (struct scsi_cmnd *) context;
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	cid = TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
 
@@ -601,11 +604,11 @@
 		pci_unmap_sg(dev->pdev, 
 			(struct scatterlist *)scsicmd->buffer,
 			scsicmd->use_sg,
-			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
 		pci_unmap_single(dev->pdev, (dma_addr_t)(ulong)scsicmd->SCp.ptr,
 				 scsicmd->request_bufflen,
-				 scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+				 scsicmd->sc_data_direction);
 
 	writereply = (struct aac_write_reply *) fib_data(fibptr);
 	if (le32_to_cpu(writereply->status) == ST_OK)
@@ -625,7 +628,7 @@
 	aac_io_done(scsicmd);
 }
 
-int aac_read(Scsi_Cmnd * scsicmd, int cid)
+int aac_read(struct scsi_cmnd * scsicmd, int cid)
 {
 	u32 lba;
 	u32 count;
@@ -736,7 +739,7 @@
 	return -1;
 }
 
-static int aac_write(Scsi_Cmnd * scsicmd, int cid)
+static int aac_write(struct scsi_cmnd * scsicmd, int cid)
 {
 	u32 lba;
 	u32 count;
@@ -853,7 +856,7 @@
  *	aacraid firmware.
  */
  
-int aac_scsi_cmd(Scsi_Cmnd * scsicmd)
+int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 {
 	u32 cid = 0;
 	struct fsa_scsi_hba *fsa_dev_ptr;
@@ -1215,9 +1218,9 @@
 {
 	struct aac_dev *dev;
 	struct aac_srb_reply *srbreply;
-	Scsi_Cmnd *scsicmd;
+	struct scsi_cmnd *scsicmd;
 
-	scsicmd = (Scsi_Cmnd *) context;
+	scsicmd = (struct scsi_cmnd *) context;
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
 	if (fibptr == NULL)
@@ -1233,10 +1236,10 @@
 		pci_unmap_sg(dev->pdev, 
 			(struct scatterlist *)scsicmd->buffer,
 			scsicmd->use_sg,
-			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+			scsicmd->sc_data_direction);
 	else if(scsicmd->request_bufflen)
 		pci_unmap_single(dev->pdev, (ulong)scsicmd->SCp.ptr, scsicmd->request_bufflen,
-			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+			scsicmd->sc_data_direction);
 
 	/*
 	 * First check the fib status
@@ -1396,7 +1399,7 @@
  * scsicmd passed in.
  */
 
-static int aac_send_srb_fib(Scsi_Cmnd* scsicmd)
+static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 {
 	struct fib* cmd_fibcontext;
 	struct aac_dev* dev;
@@ -1414,17 +1417,16 @@
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	switch(scsicmd->sc_data_direction){
-	case SCSI_DATA_WRITE:
+	case DMA_TO_DEVICE:
 		flag = SRB_DataOut;
 		break;
-	case SCSI_DATA_UNKNOWN:  
+	case DMA_BIDIRECTIONAL:
 		flag = SRB_DataIn | SRB_DataOut;
 		break;
-	case SCSI_DATA_READ:
+	case DMA_FROM_DEVICE:
 		flag = SRB_DataIn;
 		break;
-	case SCSI_DATA_NONE: 
-	default:
+	case DMA_NONE:
 		flag = SRB_NoDataXfer;
 		break;
 	}
@@ -1507,7 +1509,7 @@
 	return -1;
 }
 
-static unsigned long aac_build_sg(Scsi_Cmnd* scsicmd, struct sgmap* psg)
+static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* psg)
 {
 	struct aac_dev *dev;
 	unsigned long byte_count = 0;
@@ -1524,7 +1526,7 @@
 		sg = (struct scatterlist *) scsicmd->request_buffer;
 
 		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
-			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+			scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(sg_count);
 
 		byte_count = 0;
@@ -1551,7 +1553,7 @@
 		addr = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
 				scsicmd->request_bufflen,
-				scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+				scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(1);
 		psg->sg[0].addr = cpu_to_le32(addr);
 		psg->sg[0].count = cpu_to_le32(scsicmd->request_bufflen);  
@@ -1562,7 +1564,7 @@
 }
 
 
-static unsigned long aac_build_sg64(Scsi_Cmnd* scsicmd, struct sgmap64* psg)
+static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg)
 {
 	struct aac_dev *dev;
 	unsigned long byte_count = 0;
@@ -1581,7 +1583,7 @@
 		sg = (struct scatterlist *) scsicmd->request_buffer;
 
 		sg_count = pci_map_sg(dev->pdev, sg, scsicmd->use_sg,
-			scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+			scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(sg_count);
 
 		byte_count = 0;
@@ -1610,7 +1612,7 @@
 		addr = pci_map_single(dev->pdev,
 				scsicmd->request_buffer,
 				scsicmd->request_bufflen,
-				scsi_to_pci_dma_dir(scsicmd->sc_data_direction));
+				scsicmd->sc_data_direction);
 		psg->count = cpu_to_le32(1);
 		le_addr = cpu_to_le64(addr);
 		psg->sg[0].addr[1] = (u32)(le_addr>>32);
===== drivers/scsi/aacraid/aacraid.h 1.9 vs edited =====
--- 1.9/drivers/scsi/aacraid/aacraid.h	Wed Oct 22 11:52:43 2003
+++ edited/drivers/scsi/aacraid/aacraid.h	Wed Nov 19 19:17:01 2003
@@ -520,10 +520,6 @@
 
 struct aac_driver_ident
 {
-	u16	vendor;
-	u16	device;
-	u16	subsystem_vendor;
-	u16	subsystem_device;
 	int 	(*init)(struct aac_dev *dev, unsigned long num);
 	char *	name;
 	char *	vname;
@@ -1466,6 +1462,8 @@
 	return (u32)capacity;
 }
 
+struct scsi_cmnd;
+
 const char *aac_driverinfo(struct Scsi_Host *);
 struct fib *fib_alloc(struct aac_dev *dev);
 int fib_setup(struct aac_dev *dev);
@@ -1480,10 +1478,9 @@
 void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
 int fib_complete(struct fib * context);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib->data)
-int aac_detach(struct aac_dev *dev);
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
 int aac_get_containers(struct aac_dev *dev);
-int aac_scsi_cmd(Scsi_Cmnd *scsi_cmnd_ptr);
+int aac_scsi_cmd(struct scsi_cmnd *cmd);
 int aac_dev_ioctl(struct aac_dev *dev, int cmd, void *arg);
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void *arg);
 int aac_rx_init(struct aac_dev *dev, unsigned long devNumber);
@@ -1495,3 +1492,4 @@
 int fib_adapter_complete(struct fib * fibptr, unsigned short size);
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
 int aac_get_adapter_info(struct aac_dev* dev);
+int aac_send_shutdown(struct aac_dev *dev);
===== drivers/scsi/aacraid/commctrl.c 1.3 vs edited =====
--- 1.3/drivers/scsi/aacraid/commctrl.c	Fri May  2 21:30:31 2003
+++ edited/drivers/scsi/aacraid/commctrl.c	Wed Nov 19 18:38:25 2003
@@ -28,7 +28,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -37,11 +36,10 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
+#include <linux/dma-mapping.h>
 #include <linux/blkdev.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
-#include "scsi.h"
-#include "hosts.h"
 
 #include "aacraid.h"
 
@@ -439,16 +437,16 @@
 	
 	switch(srbcmd->flags){
 	case SRB_DataOut:
-		data_dir = SCSI_DATA_WRITE;
+		data_dir = DMA_TO_DEVICE;
 		break;
 	case (SRB_DataIn | SRB_DataOut):
-		data_dir = SCSI_DATA_UNKNOWN;  
+		data_dir = DMA_BIDIRECTIONAL;
 		break;
 	case SRB_DataIn:
-		data_dir = SCSI_DATA_READ;
+		data_dir = DMA_FROM_DEVICE;
 		break;
 	default:
-		data_dir = SCSI_DATA_NONE;
+		data_dir = DMA_NONE;
 	}
 	if( dev->pae_support ==1 ) {
 		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
@@ -484,7 +482,7 @@
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, psg->sg[i].count, scsi_to_pci_dma_dir(data_dir));
+			addr = pci_map_single(dev->pdev, p, psg->sg[i].count, data_dir);
 
 			le_addr = cpu_to_le64(addr);
 			psg->sg[i].addr[1] = (u32)(le_addr>>32);
@@ -526,7 +524,7 @@
 					goto cleanup;
 				}
 			}
-			addr = pci_map_single(dev->pdev, p, psg->sg[i].count, scsi_to_pci_dma_dir(data_dir));
+			addr = pci_map_single(dev->pdev, p, psg->sg[i].count, data_dir);
 
 			psg->sg[i].addr = cpu_to_le32(addr);
 			psg->sg[i].count = cpu_to_le32(psg->sg[i].count);  
===== drivers/scsi/aacraid/comminit.c 1.7 vs edited =====
--- 1.7/drivers/scsi/aacraid/comminit.c	Wed Oct 22 11:54:35 2003
+++ edited/drivers/scsi/aacraid/comminit.c	Wed Nov 19 19:16:38 2003
@@ -29,7 +29,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -41,15 +40,11 @@
 #include <linux/completion.h>
 #include <linux/mm.h>
 #include <asm/semaphore.h>
-#include "scsi.h"
-#include "hosts.h"
 
 #include "aacraid.h"
 
 struct aac_common aac_config;
 
-static struct aac_dev *devices;
-
 static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long commsize, unsigned long commalign)
 {
 	unsigned char *base;
@@ -163,7 +158,7 @@
  *	This routine will send a VM_CloseAll (shutdown) request to the adapter.
  */
 
-static int aac_send_shutdown(struct aac_dev * dev)
+int aac_send_shutdown(struct aac_dev * dev)
 {
 	struct fib * fibctx;
 	struct aac_close *cmd;
@@ -191,35 +186,6 @@
 }
 
 /**
- *	aac_detach	-	detach adapter
- *	@detach: adapter to disconnect
- *
- *	Disconnect and shutdown an AAC based adapter, freeing resources
- *	as we go.
- */
-
-int aac_detach(struct aac_dev *detach)
-{
-	struct aac_dev **dev = &devices;
-	
-	while(*dev)
-	{
-		if(*dev == detach)
-		{
-			*dev = detach->next;
-			aac_send_shutdown(detach);
-			fib_map_free(detach);
-			pci_free_consistent(detach->pdev, detach->comm_size, detach->comm_addr, detach->comm_phys);
-			kfree(detach->queues);
-			return 1;
-		}
-		dev=&((*dev)->next);
-	}
-	BUG();
-	return 0;
-}
-
-/**
  *	aac_comm_init	-	Initialise FSA data structures
  *	@dev:	Adapter to initialise
  *
@@ -344,11 +310,7 @@
 		
 	INIT_LIST_HEAD(&dev->fib_list);
 	init_completion(&dev->aif_completion);
-	/*
-	 *	Add this adapter in to our dev List.
-	 */
-	dev->next = devices;
-	devices = dev;
+
 	return dev;
 }
 
===== drivers/scsi/aacraid/commsup.c 1.6 vs edited =====
--- 1.6/drivers/scsi/aacraid/commsup.c	Fri May  2 21:31:18 2003
+++ edited/drivers/scsi/aacraid/commsup.c	Wed Nov 19 18:32:45 2003
@@ -3,7 +3,6 @@
  *	(c) Copyright 2001 Red Hat Inc.	<alan@redhat.com>
  *
  * based on the old aacraid driver that is..
-
  * Adaptec aacraid device driver for Linux.
  *
  * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
@@ -28,10 +27,8 @@
  * Abstract: Contain all routines that are required for FSA host/adapter
  *    commuication.
  *
- *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -40,10 +37,8 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
-#include <asm/semaphore.h>
 #include <linux/blkdev.h>
-#include "scsi.h"
-#include "hosts.h"
+#include <asm/semaphore.h>
 
 #include "aacraid.h"
 
===== drivers/scsi/aacraid/dpcsup.c 1.4 vs edited =====
--- 1.4/drivers/scsi/aacraid/dpcsup.c	Fri May  2 21:31:00 2003
+++ edited/drivers/scsi/aacraid/dpcsup.c	Wed Nov 19 18:32:58 2003
@@ -29,7 +29,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -40,8 +39,6 @@
 #include <linux/completion.h>
 #include <linux/blkdev.h>
 #include <asm/semaphore.h>
-#include "scsi.h"
-#include "hosts.h"
 
 #include "aacraid.h"
 
===== drivers/scsi/aacraid/linit.c 1.22 vs edited =====
--- 1.22/drivers/scsi/aacraid/linit.c	Tue Aug 26 18:25:41 2003
+++ edited/drivers/scsi/aacraid/linit.c	Wed Nov 19 19:16:13 2003
@@ -25,354 +25,158 @@
  *   linit.c
  *
  * Abstract: Linux Driver entry module for Adaptec RAID Array Controller
- *				
- *	Provides the following driver entry points:
- *		aac_detect()
- *		aac_release()
- *		aac_queuecommand()
- *		aac_resetcommand()
- *		aac_biosparm()
- *	
  */
 
-#define AAC_DRIVER_VERSION		"1.1.2"
+#define AAC_DRIVER_VERSION		"1.1.2-lk1"
 #define AAC_DRIVER_BUILD_DATE		__DATE__
+#define AAC_DRIVERNAME			"aacraid"
 
-#include <linux/module.h>
-#include <linux/config.h>
-#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/completion.h>
 #include <linux/init.h>
-#include <linux/types.h>
-#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/pci.h>
-#include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <linux/completion.h>
-#include <linux/interrupt.h>
+#include <linux/spinlock.h>
 #include <asm/semaphore.h>
-#include <linux/blkdev.h>
-#include "scsi.h"
-#include "hosts.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 
 #include "aacraid.h"
 
 
-#define AAC_DRIVERNAME	"aacraid"
-
 MODULE_AUTHOR("Red Hat Inc and Adaptec");
-MODULE_DESCRIPTION("Supports Dell PERC2, 2/Si, 3/Si, 3/Di, Adaptec Advanced Raid Products, and HP NetRAID-4M devices. http://domsch.com/linux/ or http://linux.adaptec.com");
+MODULE_DESCRIPTION("Dell PERC2, 2/Si, 3/Si, 3/Di, "
+		   "Adaptec Advanced Raid Products, "
+		   "and HP NetRAID-4M SCSI driver");
 MODULE_LICENSE("GPL");
-MODULE_PARM(nondasd, "i");
+
+
+int nondasd = -1;
+module_param(nondasd, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd devices. 0=off, 1=on");
-MODULE_PARM(paemode, "i");
-MODULE_PARM_DESC(paemode, "Control whether dma addressing is using PAE. 0=off, 1=on");
 
-int nondasd=-1;
-int paemode=-1;
+int paemode = -1;
+module_param(paemode, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(paemode, "Control whether dma addressing is using PAE. 0=off, 1=on");
 
 struct aac_dev *aac_devices[MAXIMUM_NUM_ADAPTERS];
-
-static unsigned aac_count = 0;
+static unsigned aac_count;
 static int aac_cfg_major = -1;
 
 /*
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
+ *
+ * Note: The last field is used to index into aac_drivers below.
  */
+static struct pci_device_id aac_pci_tbl[] = {
+	{ 0x1028, 0x0001, 0x1028, 0x0001, 0, 0, 0 }, /* PERC 2/Si */
+	{ 0x1028, 0x0002, 0x1028, 0x0002, 0, 0, 1 }, /* PERC 3/Di */
+	{ 0x1028, 0x0003, 0x1028, 0x0003, 0, 0, 2 }, /* PERC 3/Si */
+	{ 0x1028, 0x0004, 0x1028, 0x00d0, 0, 0, 3 }, /* PERC 3/Si */
+	{ 0x1028, 0x0002, 0x1028, 0x00d1, 0, 0, 4 }, /* PERC 3/Di */
+	{ 0x1028, 0x0002, 0x1028, 0x00d9, 0, 0, 5 }, /* PERC 3/Di */
+	{ 0x1028, 0x000a, 0x1028, 0x0106, 0, 0, 6 }, /* PERC 3/Di */
+	{ 0x1028, 0x000a, 0x1028, 0x011b, 0, 0, 7 }, /* PERC 3/Di */
+	{ 0x1028, 0x000a, 0x1028, 0x0121, 0, 0, 8 }, /* PERC 3/Di */
+	{ 0x9005, 0x0283, 0x9005, 0x0283, 0, 0, 9 }, /* catapult*/
+	{ 0x9005, 0x0284, 0x9005, 0x0284, 0, 0, 10 }, /* tomcat*/
+	{ 0x9005, 0x0285, 0x9005, 0x0286, 0, 0, 11 }, /* Adaptec 2120S (Crusader)*/
+	{ 0x9005, 0x0285, 0x9005, 0x0285, 0, 0, 12 }, /* Adaptec 2200S (Vulcan)*/
+	{ 0x9005, 0x0285, 0x9005, 0x0287, 0, 0, 13 }, /* Adaptec 2200S (Vulcan-2m)*/
+	{ 0x9005, 0x0285, 0x17aa, 0x0286, 0, 0, 14 }, /* Legend S220*/
+	{ 0x9005, 0x0285, 0x17aa, 0x0287, 0, 0, 15 }, /* Legend S230*/
+
+	{ 0x9005, 0x0285, 0x9005, 0x0288, 0, 0, 16 }, /* Adaptec 3230S (Harrier)*/
+	{ 0x9005, 0x0285, 0x9005, 0x0289, 0, 0, 17 }, /* Adaptec 3240S (Tornado)*/
+	{ 0x9005, 0x0285, 0x9005, 0x028a, 0, 0, 18 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
+	{ 0x9005, 0x0285, 0x9005, 0x028b, 0, 0, 19 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
+	{ 0x9005, 0x0285, 0x9005, 0x0290, 0, 0, 20 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
+	{ 0x9005, 0x0250, 0x1014, 0x0279, 0, 0, 21 }, /* (Marco)*/
+	{ 0x9005, 0x0250, 0x1014, 0x028c, 0, 0, 22 }, /* (Sebring)*/
+
+	{ 0x9005, 0x0285, 0x1028, 0x0287, 0, 0, 23 }, /* Perc 320/DC*/
+	{ 0x1011, 0x0046, 0x9005, 0x0365, 0, 0, 24 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x0364, 0, 0, 25 }, /* Adaptec 5400S (Mustang)*/
+	{ 0x1011, 0x0046, 0x9005, 0x1364, 0, 0, 26 }, /* Dell PERC2 "Quad Channel" */
+	{ 0x1011, 0x0046, 0x103c, 0x10c2, 0, 0, 27 }, /* HP NetRAID-4M */
+	{ 0,}
+};
+MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
+
 /*
  * dmb - For now we add the number of channels to this structure.  
  * In the future we should add a fib that reports the number of channels
  * for the card.  At that time we can remove the channels from here
  */
 static struct aac_driver_ident aac_drivers[] = {
-	{ 0x1028, 0x0001, 0x1028, 0x0001, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 2/Si */
-	{ 0x1028, 0x0002, 0x1028, 0x0002, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x0003, 0x1028, 0x0003, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
-	{ 0x1028, 0x0004, 0x1028, 0x00d0, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
-	{ 0x1028, 0x0002, 0x1028, 0x00d1, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x0002, 0x1028, 0x00d9, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x0106, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x011b, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x1028, 0x000a, 0x1028, 0x0121, aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
-	{ 0x9005, 0x0283, 0x9005, 0x0283, aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2 }, /* catapult*/
-	{ 0x9005, 0x0284, 0x9005, 0x0284, aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2 }, /* tomcat*/
-	{ 0x9005, 0x0285, 0x9005, 0x0286, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1 }, /* Adaptec 2120S (Crusader)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0285, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0287, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan-2m)*/
-	{ 0x9005, 0x0285, 0x17aa, 0x0286, aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1 }, /* Legend S220*/
-	{ 0x9005, 0x0285, 0x17aa, 0x0287, aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2 }, /* Legend S230*/
-
-	{ 0x9005, 0x0285, 0x9005, 0x0288, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0289, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028a, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
-	{ 0x9005, 0x0285, 0x9005, 0x028b, aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
-	{ 0x9005, 0x0285, 0x9005, 0x0290, aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
-	{ 0x9005, 0x0250, 0x1014, 0x0279, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Marco)*/
-	{ 0x9005, 0x0250, 0x1014, 0x028c, aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Sebring)*/
-
-	{ 0x9005, 0x0285, 0x1028, 0x0287, aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2 }, /* Perc 320/DC*/
-	{ 0x1011, 0x0046, 0x9005, 0x0365, aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x0364, aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
-	{ 0x1011, 0x0046, 0x9005, 0x1364, aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4 }, /* Dell PERC2 "Quad Channel" */
-	{ 0x1011, 0x0046, 0x103c, 0x10c2, aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }  /* HP NetRAID-4M */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 2/Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Si */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
+	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2 }, /* PERC 3/Di */
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2 }, /* catapult*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2 }, /* tomcat*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1 }, /* Adaptec 2120S (Crusader)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2 }, /* Adaptec 2200S (Vulcan-2m)*/
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1 }, /* Legend S220*/
+	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2 }, /* Legend S230*/
+
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3230S   ", 2 }, /* Adaptec 3230S (Harrier)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 3240S   ", 2 }, /* Adaptec 3240S (Tornado)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S PCI-X ZCR (Skyhawk)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "ASR-2020S PCI-X ", 2 }, /* ASR-2020S SO-DIMM PCI-X ZCR(Terminator)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "AAR-2410SA SATA ", 2 }, /* AAR-2410SA PCI SATA 4ch (Jaguar II)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Marco)*/
+	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec         ", 2 }, /* (Sebring)*/
+
+	{ aac_rx_init, "percraid", "DELL    ", "PERC 320/DC     ", 2 }, /* Perc 320/DC*/
+	{ aac_sa_init, "aacraid",  "ADAPTEC ", "Adaptec 5400S   ", 4 }, /* Adaptec 5400S (Mustang)*/
+	{ aac_sa_init, "aacraid",  "ADAPTEC ", "AAC-364         ", 4 }, /* Adaptec 5400S (Mustang)*/
+	{ aac_sa_init, "percraid", "DELL    ", "PERCRAID        ", 4 }, /* Dell PERC2 "Quad Channel" */
+	{ aac_sa_init, "hpnraid",  "HP      ", "NetRAID         ", 4 }  /* HP NetRAID-4M */
 };
 
-#define NUM_AACTYPES	(sizeof(aac_drivers) / sizeof(struct aac_driver_ident))
-static int num_aacdrivers = NUM_AACTYPES;
-
-static int aac_cfg_ioctl(struct inode * inode, struct file * file, unsigned int cmd, unsigned long arg);
-static int aac_cfg_open(struct inode * inode, struct file * file);
-static int aac_cfg_release(struct inode * inode,struct file * file);
-
-static struct file_operations aac_cfg_fops = {
-	.owner		= THIS_MODULE,
-	.ioctl		= aac_cfg_ioctl,
-	.open		= aac_cfg_open,
-	.release	= aac_cfg_release
-};
-
-static int aac_detect(Scsi_Host_Template *);
-static int aac_release(struct Scsi_Host *);
-static int aac_queuecommand(Scsi_Cmnd *, void (*CompletionRoutine)(Scsi_Cmnd *));
-static int aac_biosparm(struct scsi_device *, struct block_device *,
-			sector_t, int *);
-static int aac_ioctl(Scsi_Device *, int, void *);
-static int aac_eh_abort(Scsi_Cmnd * cmd);
-static int aac_eh_device_reset(Scsi_Cmnd* cmd);
-static int aac_eh_bus_reset(Scsi_Cmnd* cmd);
-static int aac_eh_reset(Scsi_Cmnd* cmd);
-
-static int aac_slave_configure(struct scsi_device *);
-
-/**
- *	aac_detect	-	Probe for aacraid cards
- *	@template: SCSI driver template
- *
- *	Probe for AAC Host Adapters initialize, register, and report the 
- *	configuration of each AAC Host Adapter found.
- *	Returns the number of adapters successfully initialized and 
- *	registered.
- *	Initializes all data necessary for this particular SCSI driver.
- *	Notes:
- *	The detect routine must not call any of the mid level functions 
- *	to queue commands because things are not guaranteed to be set 
- *	up yet. The detect routine can send commands to the host adapter 
- *	as long as the program control will not be passed to scsi.c in 
- *	the processing of the command. Note especially that 
- *	scsi_malloc/scsi_free must not be called.
- *
- */
- 
-static int aac_detect(Scsi_Host_Template *template)
-{
-	int index;
-	int container;
-	u16 vendor_id, device_id;
-	struct Scsi_Host *host_ptr;
-	struct pci_dev *dev = NULL;
-	struct aac_dev *aac;
-	struct fsa_scsi_hba *fsa_dev_ptr;
-	char *name = NULL;
-	
-	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n", AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
-
-	/* setting up the proc directory structure */
-	template->proc_name = "aacraid";
-
-	for( index = 0; index != num_aacdrivers; index++ ) {
-		device_id = aac_drivers[index].device;
-		vendor_id = aac_drivers[index].vendor;
-		name = aac_drivers[index].name;
-		dprintk((KERN_DEBUG "Checking %s %x/%x/%x/%x.\n", 
-			name, vendor_id, device_id,
-			aac_drivers[index].subsystem_vendor,
-			aac_drivers[index].subsystem_device));
-
-		dev = NULL;
-		while((dev = pci_find_device(vendor_id, device_id, dev))) {
-			if (pci_enable_device(dev))
-				continue;
-			pci_set_master(dev);
-			pci_set_dma_mask(dev, 0xFFFFFFFFULL);
-
-			if((dev->subsystem_vendor != aac_drivers[index].subsystem_vendor) || 
-			   (dev->subsystem_device != aac_drivers[index].subsystem_device))
-					continue;
-
-			dprintk((KERN_DEBUG "%s device detected.\n", name));
-			dprintk((KERN_DEBUG "%x/%x/%x/%x.\n", vendor_id, device_id, 
-				aac_drivers[index].subsystem_vendor, aac_drivers[index].subsystem_device));
-			/* Increment the host adapter count */
-			aac_count++;
-			/*
-			 * scsi_register() allocates memory for a Scsi_Hosts structure and
-			 * links it into the linked list of host adapters. This linked list
-			 * contains the data for all possible <supported> scsi hosts.
-			 * This is similar to the Scsi_Host_Template, except that we have
-			 * one entry for each actual physical host adapter on the system,
-			 * stored as a linked list. If there are two AAC boards, then we
-			 * will need to make two Scsi_Host entries, but there will be only
-			 * one Scsi_Host_Template entry. The second argument to scsi_register()
-			 * specifies the size of the extra memory we want to hold any device 
-			 * specific information.
-			 */
-			host_ptr = scsi_register( template, sizeof(struct aac_dev) );
-			/* 
-			 * These three parameters can be used to allow for wide SCSI 
-			 * and for host adapters that support multiple buses.
-			 */
-			host_ptr->irq = dev->irq;		/* Adapter IRQ number */
-			/* host_ptr->base = ( char * )(dev->resource[0].start & ~0xff); */
-			host_ptr->base = dev->resource[0].start;
-			scsi_set_device(host_ptr, &dev->dev);
-			dprintk((KERN_DEBUG "Device base address = 0x%lx [0x%lx].\n", host_ptr->base, dev->resource[0].start));
-			dprintk((KERN_DEBUG "Device irq = 0x%x.\n", dev->irq));
-			/*
-			 * The unique_id field is a unique identifier that must
-			 * be assigned so that we have some way of identifying
-			 * each host adapter properly and uniquely. For hosts 
-			 * that do not support more than one card in the
-			 * system, this does not need to be set. It is
-			 * initialized to zero in scsi_register(). This is the 
-			 * value returned as aac->id.
-			 */
-			host_ptr->unique_id = aac_count - 1;
-			aac = (struct aac_dev *)host_ptr->hostdata;
-			/* attach a pointer back to Scsi_Host */
-			aac->scsi_host_ptr = host_ptr;	
-			aac->pdev = dev;
-			aac->name = aac->scsi_host_ptr->hostt->name;
-			aac->id = aac->scsi_host_ptr->unique_id;
-			aac->cardtype =  index;
-
-			aac->fibs = (struct fib*) kmalloc(sizeof(struct fib)*AAC_NUM_FIB, GFP_KERNEL);
-			spin_lock_init(&aac->fib_lock);
-
-			/* Initialize the ordinal number of the device to -1 */
-			fsa_dev_ptr = &(aac->fsa_dev);
-			for( container = 0; container < MAXIMUM_NUM_CONTAINERS; container++ )
-				fsa_dev_ptr->devname[container][0] = '\0';
-
-			dprintk((KERN_DEBUG "Initializing Hardware...\n"));
-			if((*aac_drivers[index].init)(aac , host_ptr->unique_id) != 0)
-			{
-				/* device initialization failed */
-				printk(KERN_WARNING "aacraid: device initialization failed.\n");
-				scsi_unregister(host_ptr);
-				aac_count--;
-				continue;
-			} 
-			dprintk((KERN_DEBUG "%s:%d device initialization successful.\n", name, host_ptr->unique_id));
-			aac_get_adapter_info(aac);
-			if(aac->nondasd_support == 1){
-			/*
-			 * max channel will be the physical channels plus 1 virtual channel 
-			 * all containers are on the virtual channel 0
-			 * physical channels are address by their actual physical number+1
-			 */
-				host_ptr->max_channel = aac_drivers[index].channels+1;
-			} else {
-				host_ptr->max_channel = 1;
-			}
-			dprintk((KERN_DEBUG "Device has %d logical channels\n",host_ptr->max_channel));
-			aac_get_containers(aac);
-			aac_devices[aac_count-1] = aac;
-//			spin_unlock_irqrestore(&aac->fib_lock, flags);
-
-			/*
-			 * dmb - we may need to move the setting of these parms somewhere else once
-			 * we get a fib that can report the actual numbers
-			 */
-			host_ptr->max_id = AAC_MAX_TARGET;
-			host_ptr->max_lun = AAC_MAX_LUN;
-
-		}
-	}
-
-	if( aac_count ){
-		if((aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops))<0)
-			printk(KERN_WARNING "aacraid: unable to register \"aac\" device.\n");
-	}
-
-	return aac_count;
-}
-
-/**
- *	aac_release	-	release SCSI host resources
- *	@host_ptr: SCSI host to clean up
- *
- *	Release all resources previously acquired to support a specific Host 
- *	Adapter and unregister the AAC Host Adapter.
- *
- *	BUGS: Does not wait for the thread it kills to die.
- */
-
-static int aac_release(struct Scsi_Host *host_ptr)
-{
-	struct aac_dev *dev;
-	dprintk((KERN_DEBUG "aac_release.\n"));
-	dev = (struct aac_dev *)host_ptr->hostdata;
-	/*
-	 *	kill any threads we started
-	 */
-	kill_proc(dev->thread_pid, SIGKILL, 0);
-	wait_for_completion(&dev->aif_completion);
-	/*
-	 *	Call the comm layer to detach from this adapter
-	 */
-	aac_detach(dev);
-	/* Check free orderings... */
-	/* remove interrupt binding */
-	free_irq(host_ptr->irq, dev);
-	iounmap((void * )dev->regs.sa);
-	/* unregister adapter */
-	scsi_unregister(host_ptr);
-	/*
-	 *	FIXME: This assumes no hot plugging is going on...
-	 */
-	if( aac_cfg_major >= 0 )
-	{
-		unregister_chrdev(aac_cfg_major, "aac");
-		aac_cfg_major = -1;
-	}
-	return 0;
-}
-
 /**
  *	aac_queuecommand	-	queue a SCSI command
- *	@scsi_cmnd_ptr:	SCSI command to queue
- *	@CompletionRoutine: Function to call on command completion
+ *	@cmd:		SCSI command to queue
+ *	@done:		Function to call on command completion
  *
  *	Queues a command for execution by the associated Host Adapter.
+ *
+ *	TODO: unify with aac_scsi_cmd().
  */ 
 
-static int aac_queuecommand(Scsi_Cmnd *scsi_cmnd_ptr, void (*CompletionRoutine)(Scsi_Cmnd *))
+static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	int ret;
-
-	scsi_cmnd_ptr->scsi_done = CompletionRoutine;
-	/*
-	 *	aac_scsi_cmd() handles command processing, setting the 
-	 *	result code and calling completion routine. 
-	 */
-	if((ret = aac_scsi_cmd(scsi_cmnd_ptr)) != 0){
-		dprintk((KERN_DEBUG "aac_scsi_cmd failed.\n"));
-		return FAILED;
-	}
-	return ret;
+	cmd->scsi_done = done;
+	return (aac_scsi_cmd(cmd) ? FAILED : 0);
 } 
 
 /**
- *	aac_driverinfo		-	Returns the host adapter name
- *	@host_ptr:	Scsi host to report on
+ *	aac_info		-	Returns the host adapter name
+ *	@shost:		Scsi host to report on
  *
  *	Returns a static string describing the device in question
  */
 
-const char *aac_driverinfo(struct Scsi_Host *host_ptr)
+const char *aac_info(struct Scsi_Host *shost)
 {
-	struct aac_dev *dev = (struct aac_dev *)host_ptr->hostdata;
+	struct aac_dev *dev = (struct aac_dev *)shost->hostdata;
 	return aac_drivers[dev->cardtype].name;
 }
 
@@ -382,9 +186,10 @@
  *
  * 	Returns a pointer to the entry in the driver lookup table.
  */
+
 struct aac_driver_ident* aac_get_driver_ident(int devtype)
 {
-	return  &aac_drivers[devtype];
+	return &aac_drivers[devtype];
 }
 
 /**
@@ -420,66 +225,48 @@
 	/*
 	 *	Assuming extended translation is enabled - #REVISIT#
 	 */
-	if( capacity >= 2 * 1024 * 1024 ) /* 1 GB in 512 byte sectors */
-	{
-		if( capacity >= 4 * 1024 * 1024 ) /* 2 GB in 512 byte sectors */
-		{
+	if (capacity >= 2 * 1024 * 1024) { /* 1 GB in 512 byte sectors */
+		if(capacity >= 4 * 1024 * 1024) { /* 2 GB in 512 byte sectors */
 			param->heads = 255;
 			param->sectors = 63;
-		}
-		else
-		{
+		} else {
 			param->heads = 128;
 			param->sectors = 32;
 		}
-	}
-	else
-	{
+	} else {
 		param->heads = 64;
 		param->sectors = 32;
 	}
 
 	param->cylinders = cap_to_cyls(capacity, param->heads * param->sectors);
 
-	/*
-	 *	Read the first 1024 bytes from the disk device
-	 */
-
-	buf = scsi_bios_ptable(bdev);
-
 	/* 
-	 *	If the boot sector partition table is valid, search for a partition 
-	 *	table entry whose end_head matches one of the standard geometry 
+	 *	Read the first 1024 bytes from the disk device, if the boot
+	 *	sector partition table is valid, search for a partition table
+	 *	entry whose end_head matches one of the standard geometry 
 	 *	translations ( 64/32, 128/32, 255/63 ).
 	 */
-	 
-	if(*(unsigned short *)(buf + 0x40) == cpu_to_le16(0xaa55))
-	{
+	buf = scsi_bios_ptable(bdev);
+	if(*(unsigned short *)(buf + 0x40) == cpu_to_le16(0xaa55)) {
 		struct partition *first = (struct partition * )buf;
 		struct partition *entry = first;
 		int saved_cylinders = param->cylinders;
 		int num;
 		unsigned char end_head, end_sec;
 
-		for(num = 0; num < 4; num++)
-		{
+		for(num = 0; num < 4; num++) {
 			end_head = entry->end_head;
 			end_sec = entry->end_sector & 0x3f;
 
-			if(end_head == 63)
-			{
+			if(end_head == 63) {
 				param->heads = 64;
 				param->sectors = 32;
 				break;
-			}
-			else if(end_head == 127)
-			{
+			} else if(end_head == 127) {
 				param->heads = 128;
 				param->sectors = 32;
 				break;
-			}
-			else if(end_head == 254) 
-			{
+			} else if(end_head == 254) {
 				param->heads = 255;
 				param->sectors = 63;
 				break;
@@ -487,22 +274,17 @@
 			entry++;
 		}
 
-		if(num == 4)
-		{
+		if (num == 4) {
 			end_head = first->end_head;
 			end_sec = first->end_sector & 0x3f;
 		}
 
 		param->cylinders = cap_to_cyls(capacity, param->heads * param->sectors);
-
-		if(num < 4 && end_sec == param->sectors)
-		{
-			if(param->cylinders != saved_cylinders)
+		if (num < 4 && end_sec == param->sectors) {
+			if (param->cylinders != saved_cylinders)
 				dprintk((KERN_DEBUG "Adopting geometry: heads=%d, sectors=%d from partition table %d.\n",
 					param->heads, param->sectors, num));
-		}
-		else if(end_head > 0 || end_sec > 0)
-		{
+		} else if (end_head > 0 || end_sec > 0) {
 			dprintk((KERN_DEBUG "Strange geometry: heads=%d, sectors=%d in partition table %d.\n",
 				end_head + 1, end_sec, num));
 			dprintk((KERN_DEBUG "Using geometry: heads=%d, sectors=%d.\n",
@@ -515,42 +297,36 @@
 
 /**
  *	aac_queuedepth		-	compute queue depths
- *	@host:	SCSI host in question
- *	@dev:	SCSI device we are considering
+ *	@sdev:	SCSI device we are considering
  *
  *	Selects queue depths for each target device based on the host adapter's
  *	total capacity and the queue depth supported by the target device.
  *	A queue depth of one automatically disables tagged queueing.
  */
 
-static int aac_slave_configure(struct scsi_device * dev )
+static int aac_slave_configure(struct scsi_device *sdev)
 {
-	if(dev->tagged_supported)
-		scsi_adjust_queue_depth(dev, MSG_ORDERED_TAG, 128);
+	if (sdev->tagged_supported)
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, 128);
 	else
-		scsi_adjust_queue_depth(dev, 0, 1);
-
-	dprintk((KERN_DEBUG "(scsi%d:%d:%d:%d) Tagged Queue depth %2d, "
-				"%s\n", dev->host->host_no, dev->channel,
-				dev->id, dev->lun, dev->queue_depth,
-				dev->online ? "OnLine" : "OffLine"));
+		scsi_adjust_queue_depth(sdev, 0, 1);
 	return 0;
 }
 
-/*------------------------------------------------------------------------------
-	aac_ioctl()
-
-		Handle SCSI ioctls
- *----------------------------------------------------------------------------*/
-static int aac_ioctl(Scsi_Device * scsi_dev_ptr, int cmd, void * arg)
-/*----------------------------------------------------------------------------*/
-{
-	struct aac_dev *dev;
-	dprintk((KERN_DEBUG "aac_ioctl.\n"));
-	dev = (struct aac_dev *)scsi_dev_ptr->host->hostdata;
+static int aac_ioctl(struct scsi_device *sdev, int cmd, void * arg)
+{
+	struct aac_dev *dev = (struct aac_dev *)sdev->host->hostdata;
 	return aac_do_ioctl(dev, cmd, arg);
 }
 
+/*
+ * XXX: does aac really need no error handling??
+ */
+static int aac_eh_abort(struct scsi_cmnd *cmd)
+{
+	return FAILED;
+}
+
 /**
  *	aac_cfg_open		-	open a configuration file
  *	@inode: inode being opened
@@ -563,25 +339,13 @@
  *	so we can support hot plugging, and to ref count adapters.
  */
 
-static int aac_cfg_open(struct inode * inode, struct file * file )
+static int aac_cfg_open(struct inode *inode, struct file *file)
 {
-	unsigned minor_number = iminor(inode);
-	if(minor_number >= aac_count)
-		return -ENODEV;
-	return 0;
-}
+	unsigned minor = iminor(inode);
 
-/**
- *	aac_cfg_release		-	close down an AAC config device
- *	@inode: inode of configuration file
- *	@file: file handle of configuration file
- *	
- *	Called when the last close of the configuration file handle
- *	is performed.
- */
- 
-static int aac_cfg_release(struct inode * inode, struct file * file )
-{
+	if (minor >= aac_count)
+		return -ENODEV;
+	file->private_data = aac_devices[minor];
 	return 0;
 }
 
@@ -599,83 +363,205 @@
  *	Bugs: Needs to handle hot plugging
  */
  
-static int aac_cfg_ioctl(struct inode * inode,  struct file * file, unsigned int cmd, unsigned long arg )
+static int aac_cfg_ioctl(struct inode *inode,  struct file *file,
+		unsigned int cmd, unsigned long arg)
 {
-	struct aac_dev *dev = aac_devices[iminor(inode)];
-	return aac_do_ioctl(dev, cmd, (void *)arg);
+	return aac_do_ioctl(file->private_data, cmd, (void *)arg);
 }
 
-/*
- *	To use the low level SCSI driver support using the linux kernel loadable 
- *	module interface we should initialize the global variable driver_interface  
- *	(datatype Scsi_Host_Template) and then include the file scsi_module.c.
- */
- 
-static Scsi_Host_Template driver_template = {
+static struct file_operations aac_cfg_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= aac_cfg_ioctl,
+	.open		= aac_cfg_open,
+};
+
+static struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name           		= "AAC",
-	.detect         		= aac_detect,
-	.release        		= aac_release,
-	.info           		= aac_driverinfo,
+	.proc_name			= "aacraid",
+	.info           		= aac_info,
 	.ioctl          		= aac_ioctl,
 	.queuecommand   		= aac_queuecommand,
 	.bios_param     		= aac_biosparm,	
 	.slave_configure		= aac_slave_configure,
+	.eh_abort_handler		= aac_eh_abort,
 	.can_queue      		= AAC_NUM_IO_FIB,	
 	.this_id        		= 16,
 	.sg_tablesize   		= 16,
 	.max_sectors    		= 128,
 	.cmd_per_lun    		= AAC_NUM_IO_FIB, 
-	.eh_abort_handler		= aac_eh_abort,
-	.eh_device_reset_handler	= aac_eh_device_reset,
-	.eh_bus_reset_handler		= aac_eh_bus_reset,
-	.eh_host_reset_handler		= aac_eh_reset,
 	.use_clustering			= ENABLE_CLUSTERING,
 };
 
-/*===========================================================================
- * Error Handling routines
- *===========================================================================
- */
-
 
-/*
- *
- * We don't support abortting commands.
- */
-static int aac_eh_abort(Scsi_Cmnd * scsicmd)
+static int __devinit aac_probe_one(struct pci_dev *pdev,
+		const struct pci_device_id *id)
 {
-	printk("aacraid: abort failed\n");
-	return FAILED;
-}
+	unsigned index = id->driver_data;
+	struct Scsi_Host *shost;
+	struct fsa_scsi_hba *fsa_dev_ptr;
+	struct aac_dev *aac;
+	int container;
+	int error = -ENODEV;
 
-/*
- * We don't support device resets.
- */
-static int aac_eh_device_reset(Scsi_Cmnd* cmd)
-{
-	printk("aacraid: device reset failed\n");
-	return FAILED;
-}
+	if (pci_enable_device(pdev))
+		goto out;
 
+	if (pci_set_dma_mask(pdev, 0xFFFFFFFFULL))
+		goto out;
+	
+	pci_set_master(pdev);
 
-static int aac_eh_bus_reset(Scsi_Cmnd* cmd)
-{
-	printk("aacraid: bus reset failed\n");
-	return FAILED;
+	/* Increment the host adapter count */
+	aac_count++;
+
+	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
+	if (!shost)
+		goto out_disable_pdev;
+
+	shost->irq = pdev->irq;
+	shost->base = pci_resource_start(pdev, 0);
+	shost->unique_id = aac_count - 1;
+
+	aac = (struct aac_dev *)shost->hostdata;
+	aac->scsi_host_ptr = shost;	
+	aac->pdev = pdev;
+	aac->name = aac_driver_template.name;
+	aac->id = shost->unique_id;
+	aac->cardtype =  index;
+
+	aac->fibs = kmalloc(sizeof(struct fib) * AAC_NUM_FIB, GFP_KERNEL);
+	if (!aac->fibs)
+		goto out_free_host;
+	spin_lock_init(&aac->fib_lock);
+
+	/* Initialize the ordinal number of the device to -1 */
+	fsa_dev_ptr = &aac->fsa_dev;
+	for (container = 0; container < MAXIMUM_NUM_CONTAINERS; container++)
+		fsa_dev_ptr->devname[container][0] = '\0';
+
+	if ((*aac_drivers[index].init)(aac , shost->unique_id))
+		goto out_free_fibs;
+
+	aac_get_adapter_info(aac);
+
+	/*
+	 * max channel will be the physical channels plus 1 virtual channel
+	 * all containers are on the virtual channel 0
+	 * physical channels are address by their actual physical number+1
+	 */
+	if (aac->nondasd_support == 1)
+		shost->max_channel = aac_drivers[index].channels+1;
+	else
+		shost->max_channel = 1;
+
+	aac_get_containers(aac);
+	aac_devices[aac_count-1] = aac;
+
+	/*
+	 * dmb - we may need to move the setting of these parms somewhere else once
+	 * we get a fib that can report the actual numbers
+	 */
+	shost->max_id = AAC_MAX_TARGET;
+	shost->max_lun = AAC_MAX_LUN;
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_deinit;
+
+	pci_set_drvdata(pdev, shost);
+	scsi_scan_host(shost);
+
+	return 0;
+
+ out_deinit:
+	kill_proc(aac->thread_pid, SIGKILL, 0);
+	wait_for_completion(&aac->aif_completion);
+
+	aac_send_shutdown(aac);
+	fib_map_free(aac);
+	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
+	kfree(aac->queues);
+	free_irq(pdev->irq, aac);
+	iounmap((void * )aac->regs.sa);
+ out_free_fibs:
+	kfree(aac->fibs);
+ out_free_host:
+	scsi_host_put(shost);
+ out_disable_pdev:
+	pci_disable_device(pdev);
+	aac_count--;
+ out:
+	return error;
+}
+
+static void __devexit aac_remove_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
+
+	scsi_remove_host(shost);
+
+	kill_proc(aac->thread_pid, SIGKILL, 0);
+	wait_for_completion(&aac->aif_completion);
+
+	aac_send_shutdown(aac);
+	fib_map_free(aac);
+	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
+			aac->comm_phys);
+	kfree(aac->queues);
+
+	free_irq(pdev->irq, aac);
+	iounmap((void * )aac->regs.sa);
+	
+	kfree(aac->fibs);
+	
+	scsi_host_put(shost);
+	pci_disable_device(pdev);
+
+	/*
+	 * We don't decrement aac_count here because adapters can be unplugged
+	 * in a different order than they were detected.  If we're ever going
+	 * to overflow MAXIMUM_NUM_ADAPTERS we'll have to consider using a
+	 * bintmap of free aac_devices slots.
+	 */
+#if 0
+	aac_count--;
+#endif
 }
 
-static int aac_eh_reset(Scsi_Cmnd* cmd)
+static struct pci_driver aac_pci_driver = {
+	.name		= AAC_DRIVERNAME,
+	.id_table	= aac_pci_tbl,
+	.probe		= aac_probe_one,
+	.remove		= __devexit_p(aac_remove_one),
+};
+
+static int __init aac_init(void)
 {
-	printk("aacraid: hba reset failed\n");
-	return FAILED;
-}
+	int error;
+	
+	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n",
+			AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
 
+	error = pci_module_init(&aac_pci_driver);
+	if (error)
+		return error;
+
+	aac_cfg_major = register_chrdev( 0, "aac", &aac_cfg_fops);
+	if (aac_cfg_major < 0) {
+		printk(KERN_WARNING
+		       "aacraid: unable to register \"aac\" device.\n");
+	}
 
-/*===========================================================================
- * 
- *===========================================================================
- */
+	return 0;
+}
 
+static void __exit aac_exit(void)
+{
+	unregister_chrdev(aac_cfg_major, "aac");
+	pci_unregister_driver(&aac_pci_driver);
+}
 
-#include "scsi_module.c"
+module_init(aac_init);
+module_exit(aac_exit);
===== drivers/scsi/aacraid/rx.c 1.4 vs edited =====
--- 1.4/drivers/scsi/aacraid/rx.c	Fri May  2 21:31:27 2003
+++ edited/drivers/scsi/aacraid/rx.c	Wed Nov 19 18:38:55 2003
@@ -28,7 +28,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -41,8 +40,8 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <asm/semaphore.h>
-#include "scsi.h"
-#include "hosts.h"
+
+#include <scsi/scsi_host.h>
 
 #include "aacraid.h"
 
===== drivers/scsi/aacraid/sa.c 1.5 vs edited =====
--- 1.5/drivers/scsi/aacraid/sa.c	Fri May  2 21:31:09 2003
+++ edited/drivers/scsi/aacraid/sa.c	Wed Nov 19 18:39:11 2003
@@ -28,7 +28,6 @@
  *
  */
 
-#include <linux/config.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/types.h>
@@ -41,8 +40,8 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <asm/semaphore.h>
-#include "scsi.h"
-#include "hosts.h"
+
+#include <scsi/scsi_host.h>
 
 #include "aacraid.h"
 
