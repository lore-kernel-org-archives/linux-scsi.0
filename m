From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update 53c700 to avoid obsolete headers
Date: Fri, 4 Jun 2004 14:07:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040604120738.GB32155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:23710 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265760AbUFDMID (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 08:08:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.51/drivers/scsi/53c700.c	2004-05-12 17:46:19 +02:00
+++ edited/drivers/scsi/53c700.c	2004-06-04 13:43:46 +02:00
@@ -125,18 +125,21 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
+#include <linux/blkdev.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
 #include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/byteorder.h>
-#include <linux/blkdev.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
-
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_spi.h>
 
@@ -164,15 +167,15 @@
 #include "53c700_d.h"
 
 
-STATIC int NCR_700_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-STATIC int NCR_700_abort(Scsi_Cmnd * SCpnt);
-STATIC int NCR_700_bus_reset(Scsi_Cmnd * SCpnt);
-STATIC int NCR_700_dev_reset(Scsi_Cmnd * SCpnt);
-STATIC int NCR_700_host_reset(Scsi_Cmnd * SCpnt);
+STATIC int NCR_700_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
+STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
+STATIC int NCR_700_dev_reset(struct scsi_cmnd * SCpnt);
+STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
-STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
-STATIC void NCR_700_slave_destroy(Scsi_Device *SDpnt);
+STATIC int NCR_700_slave_configure(struct scsi_device *SDpnt);
+STATIC void NCR_700_slave_destroy(struct scsi_device *SDpnt);
 
 STATIC struct device_attribute *NCR_700_dev_attrs[];
 
@@ -279,7 +282,7 @@
 }
 
 static inline __u8
-NCR_700_get_SXFER(Scsi_Device *SDp)
+NCR_700_get_SXFER(struct scsi_device *SDp)
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
@@ -289,7 +292,7 @@
 }
 
 struct Scsi_Host *
-NCR_700_detect(Scsi_Host_Template *tpnt,
+NCR_700_detect(struct scsi_host_template *tpnt,
 	       struct NCR_700_Host_Parameters *hostdata)
 {
 	dma_addr_t pScript, pSlots;
@@ -561,7 +564,7 @@
    the ITL and (if tagged) the ITLQ lists in _queuecommand */
 STATIC void
 save_for_reselection(struct NCR_700_Host_Parameters *hostdata,
-		     Scsi_Cmnd *SCp, __u32 dsp)
+		     struct scsi_cmnd *SCp, __u32 dsp)
 {
 	/* Its just possible that this gets executed twice */
 	if(SCp != NULL) {
@@ -575,27 +578,25 @@
 }
 
 STATIC inline void
-NCR_700_unmap(struct NCR_700_Host_Parameters *hostdata, Scsi_Cmnd *SCp,
+NCR_700_unmap(struct NCR_700_Host_Parameters *hostdata, struct scsi_cmnd *SCp,
 	      struct NCR_700_command_slot *slot)
 {
-	if(SCp->sc_data_direction != SCSI_DATA_NONE &&
-	   SCp->sc_data_direction != SCSI_DATA_UNKNOWN) {
-		enum dma_data_direction direction = SCp->sc_data_direction;
+	if(SCp->sc_data_direction != DMA_NONE &&
+	   SCp->sc_data_direction != DMA_BIDIRECTIONAL) {
 		if(SCp->use_sg) {
 			dma_unmap_sg(hostdata->dev, SCp->buffer,
-				     SCp->use_sg, direction);
+				     SCp->use_sg, SCp->sc_data_direction);
 		} else {
-			dma_unmap_single(hostdata->dev,
-					 slot->dma_handle,
+			dma_unmap_single(hostdata->dev, slot->dma_handle,
 					 SCp->request_bufflen,
-					 direction);
+					 SCp->sc_data_direction);
 		}
 	}
 }
 
 STATIC inline void
 NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
-	       Scsi_Cmnd *SCp, int result)
+	       struct scsi_cmnd *SCp, int result)
 {
 	hostdata->state = NCR_700_HOST_FREE;
 	hostdata->cmd = NULL;
@@ -611,7 +612,7 @@
 #ifdef NCR_700_DEBUG
 			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
 			       SCp, SCp->cmnd[7], result);
-			print_sense("53c700", SCp);
+			scsi_print_sense("53c700", SCp);
 
 #endif
 			/* restore the old result if the request sense was
@@ -780,7 +781,7 @@
 STATIC __u32
 process_extended_message(struct Scsi_Host *host, 
 			 struct NCR_700_Host_Parameters *hostdata,
-			 Scsi_Cmnd *SCp, __u32 dsp, __u32 dsps)
+			 struct scsi_cmnd *SCp, __u32 dsp, __u32 dsps)
 {
 	__u32 resume_offset = dsp, temp = dsp + 8;
 	__u8 pun = 0xff, lun = 0xff;
@@ -849,7 +850,7 @@
 		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
 		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
-		print_msg(hostdata->msgin);
+		scsi_print_msg(hostdata->msgin);
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
@@ -865,7 +866,7 @@
 
 STATIC __u32
 process_message(struct Scsi_Host *host,	struct NCR_700_Host_Parameters *hostdata,
-		Scsi_Cmnd *SCp, __u32 dsp, __u32 dsps)
+		struct scsi_cmnd *SCp, __u32 dsp, __u32 dsps)
 {
 	/* work out where to return to */
 	__u32 temp = dsp + 8, resume_offset = dsp;
@@ -879,7 +880,7 @@
 #ifdef NCR_700_DEBUG
 	printk("scsi%d (%d:%d): message %s: ", host->host_no, pun, lun,
 	       NCR_700_phase[(dsps & 0xf00) >> 8]);
-	print_msg(hostdata->msgin);
+	scsi_print_msg(hostdata->msgin);
 	printk("\n");
 #endif
 
@@ -927,7 +928,7 @@
 		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 
-		print_msg(hostdata->msgin);
+		scsi_print_msg(hostdata->msgin);
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
@@ -946,7 +947,7 @@
 }
 
 STATIC __u32
-process_script_interrupt(__u32 dsps, __u32 dsp, Scsi_Cmnd *SCp,
+process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 			 struct Scsi_Host *host,
 			 struct NCR_700_Host_Parameters *hostdata)
 {
@@ -975,7 +976,7 @@
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
 #ifdef NCR_DEBUG
-				print_command(SCp->cmnd);
+				scsi_print_command(SCp);
 				printk("  cmd %p has status %d, requesting sense\n",
 				       SCp, hostdata->status[0]);
 #endif
@@ -1004,7 +1005,7 @@
 				SCp->cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
 				SCp->cmnd[7] = hostdata->status[0];
 				SCp->use_sg = 0;
-				SCp->sc_data_direction = SCSI_DATA_READ;
+				SCp->sc_data_direction = DMA_FROM_DEVICE;
 				dma_sync_single_for_device(hostdata->dev, slot->pCmd,
 							   SCp->cmd_len, DMA_TO_DEVICE);
 				SCp->request_bufflen = sizeof(SCp->sense_buffer);
@@ -1053,7 +1054,7 @@
 		       NCR_700_phase[i],
 		       sbcl_to_string(NCR_700_readb(host, SBCL_REG)));
 		printk(KERN_ERR "         len = %d, cmd =", SCp->cmd_len);
-		print_command(SCp->cmnd);
+		scsi_print_command(SCp);
 
 		NCR_700_internal_bus_reset(host);
 	} else if((dsps & 0xfffff000) == A_FATAL) {
@@ -1080,7 +1081,7 @@
 		__u8 lun;
 		struct NCR_700_command_slot *slot;
 		__u8 reselection_id = hostdata->reselection_id;
-		Scsi_Device *SDp;
+		struct scsi_device *SDp;
 
 		lun = hostdata->msgin[0] & 0x1f;
 
@@ -1095,7 +1096,7 @@
 			BUG();
 		}
 		if(hostdata->msgin[1] == A_SIMPLE_TAG_MSG) {
-			Scsi_Cmnd *SCp = scsi_find_tag(SDp, hostdata->msgin[2]);
+			struct scsi_cmnd *SCp = scsi_find_tag(SDp, hostdata->msgin[2]);
 			if(unlikely(SCp == NULL)) {
 				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for tag %d\n", 
 				       host->host_no, reselection_id, lun, hostdata->msgin[2]);
@@ -1107,7 +1108,7 @@
 			       host->host_no, SDp->id, SDp->lun,
 			       hostdata->msgin[2], slot, slot->tag));
 		} else {
-			Scsi_Cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
+			struct scsi_cmnd *SCp = scsi_find_tag(SDp, SCSI_NO_TAG);
 			if(unlikely(SCp == NULL)) {
 				printk(KERN_ERR "scsi%d: (%d:%d) no saved request for untagged cmd\n", 
 				       host->host_no, reselection_id, lun);
@@ -1234,7 +1235,7 @@
 		       host->host_no, pun, lun, NCR_700_condition[i],
 		       NCR_700_phase[j], dsp - hostdata->pScript);
 		if(SCp != NULL) {
-			print_command(SCp->cmnd);
+			scsi_print_command(SCp);
 
 			if(SCp->use_sg) {
 				for(i = 0; i < SCp->use_sg + 1; i++) {
@@ -1270,7 +1271,7 @@
 	__u32 resume_offset = 0;
 	struct NCR_700_Host_Parameters *hostdata =
 		(struct NCR_700_Host_Parameters *)host->hostdata[0];
-	Scsi_Cmnd *SCp = hostdata->cmd;
+	struct scsi_cmnd *SCp = hostdata->cmd;
 	__u8 sbcl;
 
 	for(count = 0; count < 5; count++) {
@@ -1373,7 +1374,7 @@
 /* The queue lock with interrupts disabled must be held on entry to
  * this function */
 STATIC int
-NCR_700_start_command(Scsi_Cmnd *SCp)
+NCR_700_start_command(struct scsi_cmnd *SCp)
 {
 	struct NCR_700_command_slot *slot =
 		(struct NCR_700_command_slot *)SCp->host_scribble;
@@ -1481,7 +1482,7 @@
 		__u32 dsps;
 		__u8 sstat0 = 0, dstat = 0;
 		__u32 dsp;
-		Scsi_Cmnd *SCp = hostdata->cmd;
+		struct scsi_cmnd *SCp = hostdata->cmd;
 		enum NCR_700_Host_State state;
 
 		handled = 1;
@@ -1514,7 +1515,7 @@
 		}
 
 		if(sstat0 & SCSI_RESET_DETECTED) {
-			Scsi_Device *SDp;
+			struct scsi_device *SDp;
 			int i;
 
 			hostdata->state = NCR_700_HOST_BUSY;
@@ -1530,7 +1531,7 @@
 			
 			/* clear all the slots and their pending commands */
 			for(i = 0; i < NCR_700_COMMAND_SLOTS_PER_HOST; i++) {
-				Scsi_Cmnd *SCp;
+				struct scsi_cmnd *SCp;
 				struct NCR_700_command_slot *slot =
 					&hostdata->slots[i];
 
@@ -1590,7 +1591,7 @@
 				printk("scsi%d: (%d:%d) Expected phase mismatch in slot->SG[%d], transferred 0x%x\n",
 				       host->host_no, pun, lun,
 				       SGcount, data_transfer);
-				print_command(SCp->cmnd);
+				scsi_print_command(SCp);
 				if(residual) {
 					printk("scsi%d: (%d:%d) Expected phase mismatch in slot->SG[%d], transferred 0x%x, residual %d\n",
 				       host->host_no, pun, lun,
@@ -1731,7 +1732,7 @@
 }
 
 STATIC int
-NCR_700_queuecommand(Scsi_Cmnd *SCp, void (*done)(Scsi_Cmnd *))
+NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
@@ -1781,7 +1782,7 @@
 
 #ifdef NCR_700_DEBUG
 	printk("53c700: scsi%d, command ", SCp->device->host->host_no);
-	print_command(SCp->cmnd);
+	scsi_print_command(SCp);
 #endif
 	if(SCp->device->tagged_supported && !SCp->device->simple_tags
 	   && (hostdata->tag_negotiated &(1<<SCp->device->id)) == 0
@@ -1827,13 +1828,13 @@
 	/* sanity check: some of the commands generated by the mid-layer
 	 * have an eccentric idea of their sc_data_direction */
 	if(!SCp->use_sg && !SCp->request_bufflen 
-	   && SCp->sc_data_direction != SCSI_DATA_NONE) {
+	   && SCp->sc_data_direction != DMA_NONE) {
 #ifdef NCR_700_DEBUG
 		printk("53c700: Command");
-		print_command(SCp->cmnd);
+		scsi_print_command(SCp);
 		printk("Has wrong data direction %d\n", SCp->sc_data_direction);
 #endif
-		SCp->sc_data_direction = SCSI_DATA_NONE;
+		SCp->sc_data_direction = DMA_NONE;
 	}
 
 	switch (SCp->cmnd[0]) {
@@ -1844,20 +1845,20 @@
 	default:
 		/* OK, get it from the command */
 		switch(SCp->sc_data_direction) {
-		case SCSI_DATA_UNKNOWN:
+		case DMA_BIDIRECTIONAL:
 		default:
 			printk(KERN_ERR "53c700: Unknown command for data direction ");
-			print_command(SCp->cmnd);
+			scsi_print_command(SCp);
 			
 			move_ins = 0;
 			break;
-		case SCSI_DATA_NONE:
+		case DMA_NONE:
 			move_ins = 0;
 			break;
-		case SCSI_DATA_READ:
+		case DMA_FROM_DEVICE:
 			move_ins = SCRIPT_MOVE_DATA_IN;
 			break;
-		case SCSI_DATA_WRITE:
+		case DMA_TO_DEVICE:
 			move_ins = SCRIPT_MOVE_DATA_OUT;
 			break;
 		}
@@ -1914,13 +1915,13 @@
 }
 
 STATIC int
-NCR_700_abort(Scsi_Cmnd * SCp)
+NCR_700_abort(struct scsi_cmnd * SCp)
 {
 	struct NCR_700_command_slot *slot;
 
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants to abort command\n\t",
 	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-	print_command(SCp->cmnd);
+	scsi_print_command(SCp);
 
 	slot = (struct NCR_700_command_slot *)SCp->host_scribble;
 
@@ -1946,7 +1947,7 @@
 }
 
 STATIC int
-NCR_700_bus_reset(Scsi_Cmnd * SCp)
+NCR_700_bus_reset(struct scsi_cmnd * SCp)
 {
 	DECLARE_COMPLETION(complete);
 	struct NCR_700_Host_Parameters *hostdata = 
@@ -1954,7 +1955,7 @@
 
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants BUS reset, cmd %p\n\t",
 	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, SCp);
-	print_command(SCp->cmnd);
+	scsi_print_command(SCp);
 	/* In theory, eh_complete should always be null because the
 	 * eh is single threaded, but just in case we're handling a
 	 * reset via sg or something */
@@ -1976,21 +1977,21 @@
 }
 
 STATIC int
-NCR_700_dev_reset(Scsi_Cmnd * SCp)
+NCR_700_dev_reset(struct scsi_cmnd * SCp)
 {
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants device reset\n\t",
 	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-	print_command(SCp->cmnd);
+	scsi_print_command(SCp);
 	
 	return FAILED;
 }
 
 STATIC int
-NCR_700_host_reset(Scsi_Cmnd * SCp)
+NCR_700_host_reset(struct scsi_cmnd * SCp)
 {
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants HOST reset\n\t",
 	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-	print_command(SCp->cmnd);
+	scsi_print_command(SCp);
 
 	NCR_700_internal_bus_reset(SCp->device->host);
 	NCR_700_chip_reset(SCp->device->host);
@@ -2043,7 +2044,7 @@
 
 
 STATIC int
-NCR_700_slave_configure(Scsi_Device *SDp)
+NCR_700_slave_configure(struct scsi_device *SDp)
 {
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
@@ -2066,7 +2067,7 @@
 }
 
 STATIC void
-NCR_700_slave_destroy(Scsi_Device *SDp)
+NCR_700_slave_destroy(struct scsi_device *SDp)
 {
 	/* to do here: deallocate memory */
 }
===== drivers/scsi/53c700.h 1.16 vs edited =====
--- 1.16/drivers/scsi/53c700.h	2004-03-08 00:44:25 +01:00
+++ edited/drivers/scsi/53c700.h	2004-06-04 13:43:36 +02:00
@@ -9,9 +9,11 @@
 #define _53C700_H
 
 #include <linux/interrupt.h>
-
 #include <asm/io.h>
 
+#include <scsi/scsi_device.h>
+
+
 #if defined(CONFIG_53C700_MEM_MAPPED) && defined(CONFIG_53C700_IO_MAPPED)
 #define CONFIG_53C700_BOTH_MAPPED
 #endif
@@ -57,7 +59,8 @@
 struct NCR_700_Host_Parameters;
 
 /* These are the externally used routines */
-struct Scsi_Host *NCR_700_detect(Scsi_Host_Template *, struct NCR_700_Host_Parameters *);
+struct Scsi_Host *NCR_700_detect(struct scsi_host_template *,
+		struct NCR_700_Host_Parameters *);
 int NCR_700_release(struct Scsi_Host *host);
 irqreturn_t NCR_700_intr(int, void *, struct pt_regs *);
 
@@ -102,7 +105,7 @@
 #define NCR_700_DEV_PRINT_SYNC_NEGOTIATION (1<<19)
 
 static inline void
-NCR_700_set_depth(Scsi_Device *SDp, __u8 depth)
+NCR_700_set_depth(struct scsi_device *SDp, __u8 depth)
 {
 	long l = (long)SDp->hostdata;
 
@@ -111,27 +114,27 @@
 	SDp->hostdata = (void *)l;
 }
 static inline __u8
-NCR_700_get_depth(Scsi_Device *SDp)
+NCR_700_get_depth(struct scsi_device *SDp)
 {
 	return ((((unsigned long)SDp->hostdata) & 0xff00)>>8);
 }
 static inline int
-NCR_700_is_flag_set(Scsi_Device *SDp, __u32 flag)
+NCR_700_is_flag_set(struct scsi_device *SDp, __u32 flag)
 {
 	return (((unsigned long)SDp->hostdata) & flag) == flag;
 }
 static inline int
-NCR_700_is_flag_clear(Scsi_Device *SDp, __u32 flag)
+NCR_700_is_flag_clear(struct scsi_device *SDp, __u32 flag)
 {
 	return (((unsigned long)SDp->hostdata) & flag) == 0;
 }
 static inline void
-NCR_700_set_flag(Scsi_Device *SDp, __u32 flag)
+NCR_700_set_flag(struct scsi_device *SDp, __u32 flag)
 {
 	SDp->hostdata = (void *)((long)SDp->hostdata | (flag & 0xffff0000));
 }
 static inline void
-NCR_700_clear_flag(Scsi_Device *SDp, __u32 flag)
+NCR_700_clear_flag(struct scsi_device *SDp, __u32 flag)
 {
 	SDp->hostdata = (void *)((long)SDp->hostdata & ~(flag & 0xffff0000));
 }
@@ -147,7 +150,7 @@
 	__u8	state;
 	int	tag;
 	__u32	resume_offset;
-	Scsi_Cmnd	*cmnd;
+	struct scsi_cmnd *cmnd;
 	/* The pci_mapped address of the actual command in cmnd */
 	dma_addr_t	pCmd;
 	__u32		temp;
@@ -185,7 +188,7 @@
 	__u32	pScript;		/* physical mem addr of script */
 
 	enum NCR_700_Host_State state; /* protected by state lock */
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	/* Note: pScript contains the single consistent block of
 	 * memory.  All the msgin, msgout and status are allocated in
 	 * this memory too (at separate cache lines).  TOTAL_MEM_SIZE
--- 1.18/drivers/scsi/NCR_D700.c	2004-05-12 17:46:22 +02:00
+++ edited/drivers/scsi/NCR_D700.c	2004-06-04 13:45:28 +02:00
@@ -98,8 +98,6 @@
 #include <linux/module.h>
 #include <linux/mca.h>
 #include <asm/io.h>
-
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 
 #include "53c700.h"
@@ -156,7 +154,7 @@
 
 /* Host template.  The 53c700 routine NCR_700_detect will
  * fill in all of the missing routines */
-static Scsi_Host_Template NCR_D700_driver_template = {
+static struct scsi_host_template NCR_D700_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "NCR Dual 700 MCA",
 	.proc_name		= "NCR_D700",
--- 1.19/drivers/scsi/lasi700.c	2004-05-12 17:46:21 +02:00
+++ edited/drivers/scsi/lasi700.c	2004-06-04 12:53:02 +02:00
@@ -49,7 +49,6 @@
 #include <asm/parisc-device.h>
 #include <asm/delay.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 
 #include "lasi700.h"
@@ -65,7 +64,7 @@
 	{ 0 }
 };
 
-static Scsi_Host_Template lasi700_template = {
+static struct scsi_host_template lasi700_template = {
 	.name		= "LASI SCSI 53c700",
 	.proc_name	= "lasi700",
 	.this_id	= 7,
===== drivers/scsi/sim710.c 1.21 vs edited =====
--- 1.21/drivers/scsi/sim710.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/sim710.c	2004-06-04 12:53:02 +02:00
@@ -35,9 +35,8 @@
 #include <linux/mca.h>
 #include <linux/eisa.h>
 #include <linux/interrupt.h>
-
-#include "scsi.h"
 #include <scsi/scsi_host.h>
+
 #include "53c700.h"
 
 
@@ -86,7 +85,7 @@
 }
 __setup("sim710=", param_setup);
 
-static Scsi_Host_Template sim710_driver_template = {
+static struct scsi_host_template sim710_driver_template = {
 	.name			= "LSI (Symbios) 710 MCA/EISA",
 	.proc_name		= "sim710",
 	.this_id		= 7,
