From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fusion update to current APIs
Date: Mon, 31 May 2004 13:52:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531115229.GA16143@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:32172 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264246AbUEaLwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 07:52:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

 - kill scsi_to_pci_dma_dir usage, both pci and scsi use the same bits
 - kill mptscsih_io_direction and always trust the midlayer
 - kill usage of Scsi_Foo typedefs
 - use <scsi/*.h> headers


--- 1.22/drivers/message/fusion/mptctl.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptctl.c	2004-05-31 13:44:28 +02:00
@@ -84,13 +84,11 @@
 #include <linux/miscdevice.h>
 #include <linux/smp_lock.h>
 
+#include <scsi/scsi_host.h>
+
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-#include <linux/kdev_t.h>	/* needed for access to Scsi_Host struct */
-#include <linux/blkdev.h>
-#include "../../scsi/scsi.h"
-#include "../../scsi/hosts.h"
 
 #define COPYRIGHT	"Copyright (c) 1999-2004 LSI Logic Corporation"
 #define MODULEAUTHOR	"Steven J. Ralston, Noah Romer, Pamela Delaney"
===== drivers/message/fusion/mptscsih.c 1.41 vs edited =====
--- 1.41/drivers/message/fusion/mptscsih.c	2004-05-29 17:10:51 +02:00
+++ edited/drivers/message/fusion/mptscsih.c	2004-05-31 13:07:29 +02:00
@@ -76,8 +76,12 @@
 #include <linux/reboot.h>	/* notifier code */
 #include <linux/sched.h>
 #include <linux/workqueue.h>
-#include "../../scsi/scsi.h"
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 
 
 #include "mptbase.h"
@@ -154,16 +158,16 @@
  *  Other private/forward protos...
  */
 static int	mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
-static void	mptscsih_report_queue_full(Scsi_Cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq);
+static void	mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq);
 static int	mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 
-static int	mptscsih_AddSGE(MPT_SCSI_HOST *hd, Scsi_Cmnd *SCpnt,
+static int	mptscsih_AddSGE(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt,
 				 SCSIIORequest_t *pReq, int req_idx);
 static void	mptscsih_freeChainBuffers(MPT_SCSI_HOST *hd, int req_idx);
 static int	mptscsih_initChainBuffers (MPT_SCSI_HOST *hd, int init);
-static void	copy_sense_data(Scsi_Cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
+static void	copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
-static u32	SCPNT_TO_LOOKUP_IDX(Scsi_Cmnd *sc);
+static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 static MPT_FRAME_HDR *mptscsih_search_pendingQ(MPT_SCSI_HOST *hd, int scpnt_idx);
 static void	post_pendingQ_commands(MPT_SCSI_HOST *hd);
 
@@ -248,105 +252,12 @@
 	driver_setup = MPTSCSIH_DRIVER_SETUP;
 
 #ifdef MPTSCSIH_DBG_TIMEOUT
-static Scsi_Cmnd *foo_to[8];
+static struct scsi_cmnd *foo_to[8];
 #endif
 
 static struct scsi_host_template driver_template;
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/*
- *  Private inline routines...
- */
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/* 19991030 -sralston
- *  Return absolute SCSI data direction:
- *     1 = _DATA_OUT
- *     0 = _DIR_NONE
- *    -1 = _DATA_IN
- *
- * Changed: 3-20-2002 pdelaney to use the default data
- * direction and the defines set up in the
- * 2.4 kernel series
- *     1 = _DATA_OUT	changed to SCSI_DATA_WRITE (1)
- *     0 = _DIR_NONE	changed to SCSI_DATA_NONE (3)
- *    -1 = _DATA_IN	changed to SCSI_DATA_READ (2)
- * If the direction is unknown, fall through to original code.
- *
- * Mid-layer bug fix(): sg interface generates the wrong data
- * direction in some cases. Set the direction the hard way for
- * the most common commands.
- */
-static inline int
-mptscsih_io_direction(Scsi_Cmnd *cmd)
-{
-	switch (cmd->cmnd[0]) {
-	case WRITE_6:
-	case WRITE_10:
-	case WRITE_16:
-		return SCSI_DATA_WRITE;
-		break;
-	case READ_6:
-	case READ_10:
-	case READ_16:
-		return SCSI_DATA_READ;
-		break;
-	}
-
-	if (cmd->sc_data_direction != SCSI_DATA_UNKNOWN)
-		return cmd->sc_data_direction;
-
-	switch (cmd->cmnd[0]) {
-	/*  _DATA_OUT commands	*/
-	case WRITE_6:		case WRITE_10:		case WRITE_12:
-	case WRITE_16:
-	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
-	case WRITE_VERIFY:	case WRITE_VERIFY_12:
-	case COMPARE:		case COPY:		case COPY_VERIFY:
-	case SEARCH_EQUAL:	case SEARCH_HIGH:	case SEARCH_LOW:
-	case SEARCH_EQUAL_12:	case SEARCH_HIGH_12:	case SEARCH_LOW_12:
-	case MODE_SELECT:	case MODE_SELECT_10:	case LOG_SELECT:
-	case SEND_DIAGNOSTIC:	case CHANGE_DEFINITION: case UPDATE_BLOCK:
-	case SET_WINDOW:	case MEDIUM_SCAN:	case SEND_VOLUME_TAG:
-	case REASSIGN_BLOCKS:
-	case PERSISTENT_RESERVE_OUT:
-	case 0xea:
-	case 0xa3:
-		return SCSI_DATA_WRITE;
-
-	/*  No data transfer commands  */
-	case SEEK_6:		case SEEK_10:
-	case RESERVE:		case RELEASE:
-	case TEST_UNIT_READY:
-	case START_STOP:
-	case ALLOW_MEDIUM_REMOVAL:
-		return SCSI_DATA_NONE;
-
-	/*  Conditional data transfer commands	*/
-	case FORMAT_UNIT:
-		if (cmd->cmnd[1] & 0x10)	/* FmtData (data out phase)? */
-			return SCSI_DATA_WRITE;
-		else
-			return SCSI_DATA_NONE;
-
-	case VERIFY:
-		if (cmd->cmnd[1] & 0x02)	/* VERIFY:BYTCHK (data out phase)? */
-			return SCSI_DATA_WRITE;
-		else
-			return SCSI_DATA_NONE;
-
-	case RESERVE_10:
-		if (cmd->cmnd[1] & 0x03)	/* RESERVE:{LongID|Extent} (data out phase)? */
-			return SCSI_DATA_WRITE;
-		else
-			return SCSI_DATA_NONE;
-
-	/*  Must be data _IN!  */
-	default:
-		return SCSI_DATA_READ;
-	}
-} /* mptscsih_io_direction() */
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_add_sge - Place a simple SGE at address pAddr.
  *	@pAddr: virtual address for SGE
@@ -458,13 +369,13 @@
  *	mptscsih_AddSGE - Add a SGE (plus chain buffers) to the
  *	SCSIIORequest_t Message Frame.
  *	@hd: Pointer to MPT_SCSI_HOST structure
- *	@SCpnt: Pointer to Scsi_Cmnd structure
+ *	@SCpnt: Pointer to scsi_cmnd structure
  *	@pReq: Pointer to SCSIIORequest_t structure
  *
  *	Returns ...
  */
 static int
-mptscsih_AddSGE(MPT_SCSI_HOST *hd, Scsi_Cmnd *SCpnt,
+mptscsih_AddSGE(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt,
 		SCSIIORequest_t *pReq, int req_idx)
 {
 	char 	*psge;
@@ -498,7 +409,7 @@
 		sges_left = pci_map_sg(hd->ioc->pcidev,
 			       (struct scatterlist *) SCpnt->request_buffer,
 			       SCpnt->use_sg,
-			       scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+			       SCpnt->sc_data_direction);
 		if (sges_left == 0)
 			return FAILED;
 	} else if (SCpnt->request_bufflen) {
@@ -508,7 +419,7 @@
 		buf_dma_addr = pci_map_single(hd->ioc->pcidev,
 				      SCpnt->request_buffer,
 				      SCpnt->request_bufflen,
-				      scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+				      SCpnt->sc_data_direction);
 
 		/* We hide it here for later unmap. */
 		my_priv = (scPrivate *) &SCpnt->SCp;
@@ -708,7 +619,7 @@
 static int
 mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
-	Scsi_Cmnd	*sc;
+	struct scsi_cmnd	*sc;
 	MPT_SCSI_HOST	*hd;
 	SCSIIORequest_t	*pScsiReq;
 	SCSIIOReply_t	*pScsiReply;
@@ -946,14 +857,14 @@
 	/* Unmap the DMA buffers, if any. */
 	if (sc->use_sg) {
 		pci_unmap_sg(ioc->pcidev, (struct scatterlist *) sc->request_buffer,
-			    sc->use_sg, scsi_to_pci_dma_dir(sc->sc_data_direction));
+			    sc->use_sg, sc->sc_data_direction);
 	} else if (sc->request_bufflen) {
 		scPrivate	*my_priv;
 
 		my_priv = (scPrivate *) &sc->SCp;
 		pci_unmap_single(ioc->pcidev, (dma_addr_t)(ulong)my_priv->p1,
 			   sc->request_bufflen,
-			   scsi_to_pci_dma_dir(sc->sc_data_direction));
+			   sc->sc_data_direction);
 	}
 
 	hd->ScsiLookup[req_idx] = NULL;
@@ -974,7 +885,7 @@
 flush_doneQ(MPT_SCSI_HOST *hd)
 {
 	MPT_DONE_Q	*buffer;
-	Scsi_Cmnd	*SCpnt;
+	struct scsi_cmnd	*SCpnt;
 	unsigned long	 flags;
 
 	/* Flush the doneQ.
@@ -992,9 +903,9 @@
 		 */
 		Q_DEL_ITEM(buffer);
 
-		/* Set the Scsi_Cmnd pointer
+		/* Set the struct scsi_cmnd pointer
 		 */
-		SCpnt = (Scsi_Cmnd *) buffer->argp;
+		SCpnt = (struct scsi_cmnd *) buffer->argp;
 		buffer->argp = NULL;
 
 		/* Add to the freeQ
@@ -1015,7 +926,7 @@
  * Calling function will finish processing.
  */
 static void
-search_doneQ_for_cmd(MPT_SCSI_HOST *hd, Scsi_Cmnd *SCpnt)
+search_doneQ_for_cmd(MPT_SCSI_HOST *hd, struct scsi_cmnd *SCpnt)
 {
 	unsigned long	 flags;
 	MPT_DONE_Q	*buffer;
@@ -1024,12 +935,12 @@
 	if (!Q_IS_EMPTY(&hd->doneQ)) {
 		buffer = hd->doneQ.head;
 		do {
-			Scsi_Cmnd *sc = (Scsi_Cmnd *) buffer->argp;
+			struct scsi_cmnd *sc = (struct scsi_cmnd *) buffer->argp;
 			if (SCpnt == sc) {
 				Q_DEL_ITEM(buffer);
 				SCpnt->result = sc->result;
 
-				/* Set the Scsi_Cmnd pointer
+				/* Set the struct scsi_cmnd pointer
 				 */
 				buffer->argp = NULL;
 
@@ -1057,7 +968,7 @@
 static void
 mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 {
-	Scsi_Cmnd	*SCpnt;
+	struct scsi_cmnd	*SCpnt;
 	MPT_FRAME_HDR	*mf;
 	MPT_DONE_Q	*buffer;
 	int		 ii;
@@ -1093,7 +1004,7 @@
 					pci_unmap_sg(hd->ioc->pcidev,
 						(struct scatterlist *) SCpnt->request_buffer,
 						SCpnt->use_sg,
-						scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+						SCpnt->sc_data_direction);
 				} else if (SCpnt->request_bufflen) {
 					scPrivate	*my_priv;
 
@@ -1101,7 +1012,7 @@
 					pci_unmap_single(hd->ioc->pcidev,
 						(dma_addr_t)(ulong)my_priv->p1,
 						SCpnt->request_bufflen,
-						scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+						SCpnt->sc_data_direction);
 				}
 			}
 			SCpnt->result = DID_RESET << 16;
@@ -1123,7 +1034,7 @@
 				buffer = hd->freeQ.head;
 				Q_DEL_ITEM(buffer);
 
-				/* Set the Scsi_Cmnd pointer
+				/* Set the struct scsi_cmnd pointer
 				 */
 				buffer->argp = (void *)SCpnt;
 
@@ -1149,7 +1060,7 @@
  *	mptscsih_search_running_cmds - Delete any commands associated
  *		with the specified target and lun. Function called only
  *		when a lun is disable by mid-layer.
- *		Do NOT access the referenced Scsi_Cmnd structure or
+ *		Do NOT access the referenced scsi_cmnd structure or
  *		members. Will cause either a paging or NULL ptr error.
  *	@hd: Pointer to a SCSI HOST structure
  *	@target: target id
@@ -1307,7 +1218,7 @@
 /*
  *	mptscsih_report_queue_full - Report QUEUE_FULL status returned
  *	from a SCSI target device.
- *	@sc: Pointer to Scsi_Cmnd structure
+ *	@sc: Pointer to scsi_cmnd structure
  *	@pScsiReply: Pointer to SCSIIOReply_t
  *	@pScsiReq: Pointer to original SCSI request
  *
@@ -1316,7 +1227,7 @@
  *	printk() API call, not more than once every 10 seconds.
  */
 static void
-mptscsih_report_queue_full(Scsi_Cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq)
+mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq)
 {
 	long time = jiffies;
 
@@ -1492,7 +1403,7 @@
 		hd->is_multipath = 1;
 	}
 
-	/* SCSI needs Scsi_Cmnd lookup table!
+	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
 	sz = hd->ioc->req_depth * sizeof(void *);
@@ -1966,7 +1877,7 @@
  *	mptscsih_info - Return information about MPT adapter
  *	@SChost: Pointer to Scsi_Host structure
  *
- *	(linux Scsi_Host_Template.info routine)
+ *	(linux scsi_host_template.info routine)
  *
  *	Returns pointer to buffer where information was written.
  */
@@ -2176,7 +2087,7 @@
 /**
  *	mptscsih_proc_info - Return information about MPT adapter
  *
- *	(linux Scsi_Host_Template.info routine)
+ *	(linux scsi_host_template.info routine)
  *
  * 	buffer: if write, user data; if read, buffer for user
  * 	length: if write, return length;
@@ -2224,17 +2135,17 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_qcmd - Primary Fusion MPT SCSI initiator IO start routine.
- *	@SCpnt: Pointer to Scsi_Cmnd structure
+ *	@SCpnt: Pointer to scsi_cmnd structure
  *	@done: Pointer SCSI mid-layer IO completion function
  *
- *	(linux Scsi_Host_Template.queuecommand routine)
+ *	(linux scsi_host_template.queuecommand routine)
  *	This is the primary SCSI IO start routine.  Create a MPI SCSIIORequest
- *	from a linux Scsi_Cmnd request and send it to the IOC.
+ *	from a linux scsi_cmnd request and send it to the IOC.
  *
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
 int
-mptscsih_qcmd(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
@@ -2244,7 +2155,6 @@
 	unsigned long		 flags;
 	int	 target;
 	int	 lun;
-	int	 datadir;
 	u32	 datalen;
 	u32	 scsictl;
 	u32	 scsidir;
@@ -2295,21 +2205,15 @@
 
 	ADD_INDEX_LOG(my_idx);
 
-	/*
-	 *  The scsi layer should be handling this stuff
-	 *  (In 2.3.x it does -DaveM)
-	 */
-
 	/*  BUG FIX!  19991030 -sralston
 	 *    TUR's being issued with scsictl=0x02000000 (DATA_IN)!
 	 *    Seems we may receive a buffer (datalen>0) even when there
 	 *    will be no data transfer!  GRRRRR...
 	 */
-	datadir = mptscsih_io_direction(SCpnt);
-	if (datadir == SCSI_DATA_READ) {
+	if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
 		datalen = SCpnt->request_bufflen;
 		scsidir = MPI_SCSIIO_CONTROL_READ;	/* DATA IN  (host<--ioc<--dev) */
-	} else if (datadir == SCSI_DATA_WRITE) {
+	} else if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
 		datalen = SCpnt->request_bufflen;
 		scsidir = MPI_SCSIIO_CONTROL_WRITE;	/* DATA OUT (host-->ioc-->dev) */
 	} else {
@@ -2495,7 +2399,7 @@
 		buffer = hd->freeQ.head;
 		Q_DEL_ITEM(buffer);
 
-		/* Set the Scsi_Cmnd pointer
+		/* Set the scsi_cmnd pointer
 		 */
 		buffer->argp = (void *)SCpnt;
 
@@ -2789,15 +2693,15 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_abort - Abort linux Scsi_Cmnd routine, new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO to be aborted
+ *	mptscsih_abort - Abort linux scsi_cmnd routine, new_eh variant
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO to be aborted
  *
- *	(linux Scsi_Host_Template.eh_abort_handler routine)
+ *	(linux scsi_host_template.eh_abort_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_abort(Scsi_Cmnd * SCpnt)
+mptscsih_abort(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	MPT_FRAME_HDR	*mf;
@@ -2892,14 +2796,14 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO which reset is due to
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux Scsi_Host_Template.eh_dev_reset_handler routine)
+ *	(linux scsi_host_template.eh_dev_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_dev_reset(Scsi_Cmnd * SCpnt)
+mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
@@ -2947,14 +2851,14 @@
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_bus_reset - Perform a SCSI BUS_RESET!	new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO which reset is due to
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux Scsi_Host_Template.eh_bus_reset_handler routine)
+ *	(linux scsi_host_template.eh_bus_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_bus_reset(Scsi_Cmnd * SCpnt)
+mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
@@ -3002,14 +2906,14 @@
 /**
  *	mptscsih_host_reset - Perform a SCSI host adapter RESET!
  *	new_eh variant
- *	@SCpnt: Pointer to Scsi_Cmnd structure, IO which reset is due to
+ *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux Scsi_Host_Template.eh_host_reset_handler routine)
+ *	(linux scsi_host_template.eh_host_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_host_reset(Scsi_Cmnd *SCpnt)
+mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 {
 	MPT_SCSI_HOST *  hd;
 	int              status = SUCCESS;
@@ -3245,7 +3140,7 @@
  *	Init memory once per id (not LUN).
  */
 int
-mptscsih_slave_alloc(Scsi_Device *device)
+mptscsih_slave_alloc(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
 	MPT_SCSI_HOST		*hd;
@@ -3285,7 +3180,7 @@
  *	Called if no device present or device being unloaded
  */
 void
-mptscsih_slave_destroy(Scsi_Device *device)
+mptscsih_slave_destroy(struct scsi_device *device)
 {
 	struct Scsi_Host	*host = device->host;
 	MPT_SCSI_HOST		*hd;
@@ -3350,7 +3245,7 @@
  *	Return non-zero if fails.
  */
 int
-mptscsih_slave_configure(Scsi_Device *device)
+mptscsih_slave_configure(struct scsi_device *device)
 {
 	struct Scsi_Host	*sh = device->host;
 	VirtDevice		*pTarget;
@@ -3433,7 +3328,7 @@
  *
  */
 static void
-copy_sense_data(Scsi_Cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)
+copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply)
 {
 	VirtDevice	*target;
 	SCSIIORequest_t	*pReq;
@@ -3511,7 +3406,7 @@
 }
 
 static u32
-SCPNT_TO_LOOKUP_IDX(Scsi_Cmnd *sc)
+SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc)
 {
 	MPT_SCSI_HOST *hd;
 	int i;
@@ -3613,7 +3508,7 @@
 #if defined(MPT_DEBUG_DV) || defined(MPT_DEBUG_DV_TINY)
 		{
 			u16		 req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-			Scsi_Cmnd	*sc = hd->ScsiLookup[req_idx];
+			struct scsi_cmnd	*sc = hd->ScsiLookup[req_idx];
 			printk(MYIOC_s_INFO_FMT "Issued SCSI cmd (sc=%p) idx=%d (mf=%p)\n",
 					hd->ioc->name, sc, req_idx, mf);
 		}
