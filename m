From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of obsolete APIs in nsp32
Date: Sat, 9 Oct 2004 15:50:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041009135034.GA20157@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:25747 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266879AbUJINuq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Oct 2004 09:50:46 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: gotom@debian.or.jp, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.29/drivers/scsi/nsp32.c	2004-07-16 00:37:26 +02:00
+++ edited/drivers/scsi/nsp32.c	2004-10-02 15:24:50 +02:00
@@ -43,10 +43,11 @@
 #include <asm/system.h>
 #include <asm/io.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
-#include <scsi/scsi.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
 # include <linux/blk.h>
@@ -209,37 +210,38 @@
 #else
 static int         nsp32_detect      (Scsi_Host_Template *);
 #endif
-static int         nsp32_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
+static int         nsp32_queuecommand(struct scsi_cmnd *,
+		void (*done)(struct scsi_cmnd *));
 static const char *nsp32_info        (struct Scsi_Host *);
 static int         nsp32_release     (struct Scsi_Host *);
 
 /* SCSI error handler */
-static int         nsp32_eh_abort     (Scsi_Cmnd *);
-static int         nsp32_eh_bus_reset (Scsi_Cmnd *);
-static int         nsp32_eh_host_reset(Scsi_Cmnd *);
+static int         nsp32_eh_abort     (struct scsi_cmnd *);
+static int         nsp32_eh_bus_reset (struct scsi_cmnd *);
+static int         nsp32_eh_host_reset(struct scsi_cmnd *);
 
 /* generate SCSI message */
-static void nsp32_build_identify(Scsi_Cmnd *);
-static void nsp32_build_nop     (Scsi_Cmnd *);
-static void nsp32_build_reject  (Scsi_Cmnd *);
-static void nsp32_build_sdtr    (Scsi_Cmnd *, unsigned char, unsigned char);
+static void nsp32_build_identify(struct scsi_cmnd *);
+static void nsp32_build_nop     (struct scsi_cmnd *);
+static void nsp32_build_reject  (struct scsi_cmnd *);
+static void nsp32_build_sdtr    (struct scsi_cmnd *, unsigned char, unsigned char);
 
 /* SCSI message handler */
-static int  nsp32_busfree_occur(Scsi_Cmnd *, unsigned short);
-static void nsp32_msgout_occur (Scsi_Cmnd *);
-static void nsp32_msgin_occur  (Scsi_Cmnd *, unsigned long, unsigned short);
-
-static int  nsp32_setup_sg_table    (Scsi_Cmnd *);
-static int  nsp32_selection_autopara(Scsi_Cmnd *);
-static int  nsp32_selection_autoscsi(Scsi_Cmnd *);
-static void nsp32_scsi_done         (Scsi_Cmnd *);
-static int  nsp32_arbitration       (Scsi_Cmnd *, unsigned int);
-static int  nsp32_reselection       (Scsi_Cmnd *, unsigned char);
-static void nsp32_adjust_busfree    (Scsi_Cmnd *, unsigned int);
-static void nsp32_restart_autoscsi  (Scsi_Cmnd *, unsigned short);
+static int  nsp32_busfree_occur(struct scsi_cmnd *, unsigned short);
+static void nsp32_msgout_occur (struct scsi_cmnd *);
+static void nsp32_msgin_occur  (struct scsi_cmnd *, unsigned long, unsigned short);
+
+static int  nsp32_setup_sg_table    (struct scsi_cmnd *);
+static int  nsp32_selection_autopara(struct scsi_cmnd *);
+static int  nsp32_selection_autoscsi(struct scsi_cmnd *);
+static void nsp32_scsi_done         (struct scsi_cmnd *);
+static int  nsp32_arbitration       (struct scsi_cmnd *, unsigned int);
+static int  nsp32_reselection       (struct scsi_cmnd *, unsigned char);
+static void nsp32_adjust_busfree    (struct scsi_cmnd *, unsigned int);
+static void nsp32_restart_autoscsi  (struct scsi_cmnd *, unsigned short);
 
 /* SCSI SDTR */
-static void nsp32_analyze_sdtr       (Scsi_Cmnd *);
+static void nsp32_analyze_sdtr       (struct scsi_cmnd *);
 static int  nsp32_search_period_entry(nsp32_hw_data *, nsp32_target *, unsigned char);
 static void nsp32_set_async          (nsp32_hw_data *, nsp32_target *);
 static void nsp32_set_max_sync       (nsp32_hw_data *, nsp32_target *, unsigned char *, unsigned char *);
@@ -279,7 +281,7 @@
 /*
  * max_sectors is currently limited up to 128.
  */
-static Scsi_Host_Template nsp32_template = {
+static struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
 	.proc_info			= nsp32_proc_info,
@@ -388,7 +390,7 @@
 /*
  * IDENTIFY Message
  */
-static void nsp32_build_identify(Scsi_Cmnd *SCpnt)
+static void nsp32_build_identify(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	int pos             = data->msgout_len;
@@ -407,7 +409,7 @@
 /*
  * SDTR Message Routine
  */
-static void nsp32_build_sdtr(Scsi_Cmnd    *SCpnt,
+static void nsp32_build_sdtr(struct scsi_cmnd    *SCpnt,
 			     unsigned char period,
 			     unsigned char offset)
 {
@@ -426,7 +428,7 @@
 /*
  * No Operation Message
  */
-static void nsp32_build_nop(Scsi_Cmnd *SCpnt)
+static void nsp32_build_nop(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	int            pos  = data->msgout_len;
@@ -444,7 +446,7 @@
 /*
  * Reject Message
  */
-static void nsp32_build_reject(Scsi_Cmnd *SCpnt)
+static void nsp32_build_reject(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	int            pos  = data->msgout_len;
@@ -457,7 +459,7 @@
  * timer
  */
 #if 0
-static void nsp32_start_timer(Scsi_Cmnd *SCpnt, int time)
+static void nsp32_start_timer(struct scsi_cmnd *SCpnt, int time)
 {
 	unsigned int base = SCpnt->host->io_port;
 
@@ -475,7 +477,7 @@
 /*
  * set SCSI command and other parameter to asic, and start selection phase
  */
-static int nsp32_selection_autopara(Scsi_Cmnd *SCpnt)
+static int nsp32_selection_autopara(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int	base    = SCpnt->device->host->io_port;
@@ -606,7 +608,7 @@
 /*
  * Selection with AUTO SCSI (without AUTO PARAMETER)
  */
-static int nsp32_selection_autoscsi(Scsi_Cmnd *SCpnt)
+static int nsp32_selection_autoscsi(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int	base    = SCpnt->device->host->io_port;
@@ -781,7 +783,7 @@
  *	 arbitration delay time is defined minimal 2.4us in SCSI
  *	 specification, thus udelay works as coarse grained wait timer.
  */
-static int nsp32_arbitration(Scsi_Cmnd *SCpnt, unsigned int base)
+static int nsp32_arbitration(struct scsi_cmnd *SCpnt, unsigned int base)
 {
 	unsigned char arbit;
 	int	      status = TRUE;
@@ -830,7 +832,7 @@
  *	 reselection target id&lun must be already set.
  *	 SCSI-2 says IDENTIFY implies RESTORE_POINTER operation.
  */
-static int nsp32_reselection(Scsi_Cmnd *SCpnt, unsigned char newlun)
+static int nsp32_reselection(struct scsi_cmnd *SCpnt, unsigned char newlun)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   host_id = SCpnt->device->host->this_id;
@@ -884,7 +886,7 @@
  *
  * Note: NinjaSCSI-32Bi/UDE bus master can not transfer over 64KB at a time.
  */
-static int nsp32_setup_sg_table(Scsi_Cmnd *SCpnt)
+static int nsp32_setup_sg_table(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	struct scatterlist   *sgl;
@@ -904,7 +906,7 @@
 	if (SCpnt->use_sg) {
 		sgl = (struct scatterlist *)SCpnt->request_buffer;
 		num = pci_map_sg(data->Pci, sgl, SCpnt->use_sg,
-				 scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+				 SCpnt->sc_data_direction);
 		for (i = 0; i < num; i++) {
 			/*
 			 * Build nsp32_sglist, substitute sg dma addresses.
@@ -932,7 +934,7 @@
 	} else {
 		SCpnt->SCp.have_data_in	= pci_map_single(data->Pci,
 			SCpnt->request_buffer, SCpnt->request_bufflen,
-			scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+			SCpnt->sc_data_direction);
 
 		sgt[0].addr = cpu_to_le32(SCpnt->SCp.have_data_in);
 		sgt[0].len  = cpu_to_le32(SCpnt->request_bufflen | SGTEND); /* set end mark */
@@ -950,7 +952,7 @@
 	return TRUE;
 }
 
-static int nsp32_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	nsp32_target *target;
@@ -1205,7 +1207,7 @@
 {
 	nsp32_hw_data *data = dev_id;
 	unsigned int base = data->BaseAddress;
-	Scsi_Cmnd *SCpnt = data->CurrentSC;
+	struct scsi_cmnd *SCpnt = data->CurrentSC;
 	unsigned short auto_stat, irq_stat, trans_stat;
 	unsigned char busmon, busphase;
 	unsigned long flags;
@@ -1622,7 +1624,7 @@
  * Reset parameters and call scsi_done for data->cur_lunt.
  * Be careful setting SCpnt->result = DID_* before calling this function.
  */
-static void nsp32_scsi_done(Scsi_Cmnd *SCpnt)
+static void nsp32_scsi_done(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   base = SCpnt->device->host->io_port;
@@ -1637,13 +1639,12 @@
 	if (SCpnt->use_sg) {
 		pci_unmap_sg(data->Pci,
 			     (struct scatterlist *)SCpnt->buffer,
-			     SCpnt->use_sg,
-			     scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+			     SCpnt->use_sg, SCpnt->sc_data_direction);
 	} else {
 		pci_unmap_single(data->Pci,
 				 (u32)SCpnt->SCp.have_data_in,
 				 SCpnt->request_bufflen,
-				 scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+				 SCpnt->sc_data_direction);
 	}
 
  skip:
@@ -1678,7 +1679,7 @@
  *	MsgIn 04: Diconnect.
  * In other case, unexpected BUSFREE is detected.
  */
-static int nsp32_busfree_occur(Scsi_Cmnd *SCpnt, unsigned short execph)
+static int nsp32_busfree_occur(struct scsi_cmnd *SCpnt, unsigned short execph)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int base   = SCpnt->device->host->io_port;
@@ -1836,7 +1837,7 @@
  * Note: This driver adjust the SG table using SCSI ACK
  *       counter instead of BMCNT counter!
  */
-static void nsp32_adjust_busfree(Scsi_Cmnd *SCpnt, unsigned int s_sacklen)
+static void nsp32_adjust_busfree(struct scsi_cmnd *SCpnt, unsigned int s_sacklen)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	int                   old_entry = data->cur_entry;
@@ -1909,7 +1910,7 @@
  * message out phase. It, however, has more than 3 messages,
  * HBA creates the interrupt and we have to process by hand.
  */
-static void nsp32_msgout_occur(Scsi_Cmnd *SCpnt)
+static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int base   = SCpnt->device->host->io_port;
@@ -1985,7 +1986,7 @@
  * Note: Restarting AutoSCSI needs set:
  *		SYNC_REG, ACK_WIDTH, SGT_ADR, TRANSFER_CONTROL
  */
-static void nsp32_restart_autoscsi(Scsi_Cmnd *SCpnt, unsigned short command)
+static void nsp32_restart_autoscsi(struct scsi_cmnd *SCpnt, unsigned short command)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   base = data->BaseAddress;
@@ -2051,7 +2052,7 @@
 /*
  * cannot run automatically message in occur
  */
-static void nsp32_msgin_occur(Scsi_Cmnd     *SCpnt,
+static void nsp32_msgin_occur(struct scsi_cmnd     *SCpnt,
 			      unsigned long  irq_status,
 			      unsigned short execph)
 {
@@ -2348,7 +2349,7 @@
 /*
  * 
  */
-static void nsp32_analyze_sdtr(Scsi_Cmnd *SCpnt)
+static void nsp32_analyze_sdtr(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data   *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	nsp32_target     *target     = data->cur_target;
@@ -2956,7 +2957,7 @@
 /****************************************************************************
  * error handler
  */
-static int nsp32_eh_abort(Scsi_Cmnd *SCpnt)
+static int nsp32_eh_abort(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   base = SCpnt->device->host->io_port;
@@ -2984,7 +2985,7 @@
 	return SUCCESS;
 }
 
-static int nsp32_eh_bus_reset(Scsi_Cmnd *SCpnt)
+static int nsp32_eh_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   base = SCpnt->device->host->io_port;
@@ -3041,7 +3042,7 @@
 	data->CurrentSC = NULL;
 }
 
-static int nsp32_eh_host_reset(Scsi_Cmnd *SCpnt)
+static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
 {
 	struct Scsi_Host *host = SCpnt->device->host;
 	unsigned int      base = SCpnt->device->host->io_port;
--- 1.6/drivers/scsi/nsp32.h	2004-04-23 07:34:00 +02:00
+++ edited/drivers/scsi/nsp32.h	2004-10-02 15:24:32 +02:00
@@ -499,7 +499,7 @@
 #define MSGIN03			BIT(1)		/* Auto Msg In 03 Flag  */
 
 typedef struct _nsp32_lunt {
-	Scsi_Cmnd	*SCpnt;	    /* Current Handling Scsi_Cmnd */
+	struct scsi_cmnd	*SCpnt;	    /* Current Handling struct scsi_cmnd */
 	unsigned long	 save_datp;  /* Save Data Pointer - saved position from initial address */
 	int		 msgin03;	/* auto msg in 03 flag     */
 	unsigned int	 sg_num;	/* Total number of SG entries */
@@ -567,7 +567,7 @@
 #define NSP32_MMIO_OFFSET 0x0800
 	unsigned long MmioLength;
 
-	Scsi_Cmnd *CurrentSC;
+	struct scsi_cmnd *CurrentSC;
 
 	struct pci_dev             *Pci;
 	const struct pci_device_id *pci_devid;
