From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 3/6] mpt fusion: locking down ScsiLookup
Date: Sat, 29 Sep 2007 10:16:53 -0600
Message-ID: <20070929161653.GA4366@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42013 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbXI2QQv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Sep 2007 12:16:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

ScsiLookup is an array of pending scmd pointers that the scsi lld maintains. This array is touched from queuecommand, eh threads, and interrupt context. This array should put under locks, hence this patch to synchronize its access.  I've added some nice little function wrappers for this, and moved the ScsiLookup array over to MPT_ADAPTER struct.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-09-17 10:41:08.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-09-17 16:34:14.000000000 -0600
@@ -704,6 +704,8 @@ typedef struct _MPT_ADAPTER
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
+	struct scsi_cmnd	**ScsiLookup;
+	spinlock_t		  scsi_lookup_lock;
 } MPT_ADAPTER;
 
 /*
@@ -817,7 +819,6 @@ typedef struct _MPT_SCSI_HOST {
 	MPT_ADAPTER		 *ioc;
 	int			  port;
 	u32			  pad0;
-	struct scsi_cmnd	**ScsiLookup;
 	MPT_LOCAL_REPLY		 *pLocal;		/* used for internal commands */
 	struct timer_list	  timer;
 		/* Pool of memory for holding SCpnts before doing
diff -uarpN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-09-17 11:57:11.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2007-09-17 16:35:48.000000000 -0600
@@ -1282,14 +1282,15 @@ mptfc_probe(struct pci_dev *pdev, const 
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
-	if (!hd->ScsiLookup) {
+	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	if (!ioc->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptfc_probe;
 	}
+	spin_lock_init(&ioc->scsi_lookup_lock);
 
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
-		 ioc->name, hd->ScsiLookup));
+		 ioc->name, ioc->ScsiLookup));
 
 	/* Clear the TM flags
 	 */
diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-09-17 15:14:35.000000000 -0600
+++ a/drivers/message/fusion/mptsas.c	2007-09-17 16:35:06.000000000 -0600
@@ -3221,15 +3221,16 @@ mptsas_probe(struct pci_dev *pdev, const
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
-	if (!hd->ScsiLookup) {
+	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	if (!ioc->ScsiLookup) {
 		error = -ENOMEM;
 		spin_unlock_irqrestore(&ioc->FreeQlock, flags);
 		goto out_mptsas_probe;
 	}
+	spin_lock_init(&ioc->scsi_lookup_lock);
 
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
-		 ioc->name, hd->ScsiLookup));
+		 ioc->name, ioc->ScsiLookup));
 
 	/* Clear the TM flags
 	 */
diff -uarpN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2007-09-17 11:43:44.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2007-09-17 17:01:40.000000000 -0600
@@ -80,6 +80,10 @@ MODULE_VERSION(my_VERSION);
 /*
  *  Other private/forward protos...
  */
+static struct scsi_cmnd * mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i);
+static struct scsi_cmnd * mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i);
+static void	mptscsih_set_scsi_lookup(MPT_ADAPTER *ioc, int i, struct scsi_cmnd *scmd);
+static int	SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *scmd);
 int		mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 static void	mptscsih_report_queue_full(struct scsi_cmnd *sc, SCSIIOReply_t *pScsiReply, SCSIIORequest_t *pScsiReq);
 int		mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
@@ -90,7 +94,6 @@ static void	mptscsih_freeChainBuffers(MP
 static void	mptscsih_copy_sense_data(struct scsi_cmnd *sc, MPT_SCSI_HOST *hd, MPT_FRAME_HDR *mf, SCSIIOReply_t *pScsiReply);
 static int	mptscsih_tm_pending_wait(MPT_SCSI_HOST * hd);
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
-static int	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, int ctx2abort, ulong timeout);
 
@@ -658,12 +661,11 @@ mptscsih_io_done(MPT_ADAPTER *ioc, MPT_F
 		printk (MYIOC_s_ERR_FMT
 		    "req_idx=%x req_idx_MR=%x mf=%p mr=%p sc=%p\n",
 		    ioc->name, req_idx, req_idx_MR, mf, mr,
-		    hd->ScsiLookup[req_idx_MR]);
+		    mptscsih_get_scsi_lookup(ioc, req_idx_MR));
 		return 0;
 	}
 
-	sc = hd->ScsiLookup[req_idx];
-	hd->ScsiLookup[req_idx] = NULL;
+	sc = mptscsih_getclear_scsi_lookup(ioc, req_idx);
 	if (sc == NULL) {
 		MPIHeader_t *hdr = (MPIHeader_t *)mf;
 
@@ -969,48 +971,32 @@ static void
 mptscsih_flush_running_cmds(MPT_SCSI_HOST *hd)
 {
 	MPT_ADAPTER *ioc = hd->ioc;
-	struct scsi_cmnd	*SCpnt;
-	MPT_FRAME_HDR	*mf;
+	struct scsi_cmnd *sc;
+	SCSIIORequest_t	*mf = NULL;
 	int		 ii;
-	int		 max = ioc->req_depth;
-
-	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": flush_ScsiLookup called\n", ioc->name));
-	for (ii= 0; ii < max; ii++) {
-		if ((SCpnt = hd->ScsiLookup[ii]) != NULL) {
-
-			/* Command found.
-			 */
-
-			/* Null ScsiLookup index
-			 */
-			hd->ScsiLookup[ii] = NULL;
+	int		 channel, id;
 
-			mf = MPT_INDEX_2_MFPTR(ioc, ii);
-			dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": flush: ScsiDone (mf=%p,sc=%p)\n",
-			    ioc->name, mf, SCpnt));
-
-			/* Free Chain buffers */
-			mptscsih_freeChainBuffers(ioc, ii);
-
-			/* Free Message frames */
-			mpt_free_msg_frame(ioc, mf);
-
-			if ((unsigned char *)mf != SCpnt->host_scribble)
-				continue;
-
-			/* Set status, free OS resources (SG DMA buffers)
-			 * Do OS callback
-			 */
-			scsi_dma_unmap(SCpnt);
-
-			SCpnt->result = DID_RESET << 16;
-			SCpnt->host_scribble = NULL;
-
-			SCpnt->scsi_done(SCpnt);	/* Issue the command callback */
-		}
+	for (ii= 0; ii < ioc->req_depth; ii++) {
+		sc = mptscsih_getclear_scsi_lookup(ioc, ii);
+		if (!sc)
+			continue;
+		mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(ioc, ii);
+		if (!mf)
+			continue;
+		channel = mf->Bus;
+		id = mf->TargetID;
+		mptscsih_freeChainBuffers(ioc, ii);
+		mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
+		if ((unsigned char *)mf != sc->host_scribble)
+			continue;
+		scsi_dma_unmap(sc);
+		sc->result = DID_RESET << 16;
+		sc->host_scribble = NULL;
+		sdev_printk(MYIOC_s_INFO_FMT, sc->device,
+		    "completing cmds: fw_channel %d, fw_id %d, sc=%p,"
+		    " mf = %p, idx=%x\n", ioc->name, channel, id, sc, mf, ii);
+		sc->scsi_done(sc);
 	}
-
-	return;
 }
 
 /*
@@ -1032,16 +1018,14 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 {
 	SCSIIORequest_t	*mf = NULL;
 	int		 ii;
-	int		 max = hd->ioc->req_depth;
 	struct scsi_cmnd *sc;
 	struct scsi_lun  lun;
 	MPT_ADAPTER *ioc = hd->ioc;
+	unsigned long	flags;
 
-	dsprintk(ioc, printk(MYIOC_s_DEBUG_FMT ": search_running channel %d id %d lun %d max %d\n",
-	    ioc->name, vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun, max));
-
-	for (ii=0; ii < max; ii++) {
-		if ((sc = hd->ScsiLookup[ii]) != NULL) {
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	for (ii = 0; ii < ioc->req_depth; ii++) {
+		if ((sc = ioc->ScsiLookup[ii]) != NULL) {
 
 			mf = (SCSIIORequest_t *)MPT_INDEX_2_MFPTR(ioc, ii);
 			if (mf == NULL)
@@ -1060,13 +1044,12 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			    memcmp(lun.scsi_lun, mf->LUN, 8))
 				continue;
 
-			/* Cleanup
-			 */
-			hd->ScsiLookup[ii] = NULL;
-			mptscsih_freeChainBuffers(ioc, ii);
-			mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
 			if ((unsigned char *)mf != sc->host_scribble)
 				continue;
+			ioc->ScsiLookup[ii] = NULL;
+			spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+			mptscsih_freeChainBuffers(ioc, ii);
+			mpt_free_msg_frame(ioc, (MPT_FRAME_HDR *)mf);
 			scsi_dma_unmap(sc);
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
@@ -1074,8 +1057,10 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 			   "fw_id %d, sc=%p, mf = %p, idx=%x\n", ioc->name, vdevice->vtarget->channel,
 			   vdevice->vtarget->id, sc, mf, ii);
 			sc->scsi_done(sc);
+			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 		}
 	}
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return;
 }
 
@@ -1143,10 +1128,10 @@ mptscsih_remove(struct pci_dev *pdev)
 
 	sz1=0;
 
-	if (hd->ScsiLookup != NULL) {
+	if (ioc->ScsiLookup != NULL) {
 		sz1 = ioc->req_depth * sizeof(void *);
-		kfree(hd->ScsiLookup);
-		hd->ScsiLookup = NULL;
+		kfree(ioc->ScsiLookup);
+		ioc->ScsiLookup = NULL;
 	}
 
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT
@@ -1463,7 +1448,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	}
 
 	SCpnt->host_scribble = (unsigned char *)mf;
-	hd->ScsiLookup[my_idx] = SCpnt;
+	mptscsih_set_scsi_lookup(ioc, my_idx, SCpnt);
 
 	mpt_put_msg_frame(ioc->DoneCtx, ioc, mf);
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "Issued SCSI cmd (%p) mf=%p idx=%d\n",
@@ -1472,7 +1457,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, v
 	return 0;
 
  fail:
-	hd->ScsiLookup[my_idx] = NULL;
 	mptscsih_freeChainBuffers(ioc, my_idx);
 	mpt_free_msg_frame(ioc, mf);
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1834,7 +1818,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	/* Find this command
 	 */
-	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(SCpnt)) < 0) {
+	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(ioc, SCpnt)) < 0) {
 		/* Cmd not found in ScsiLookup.
 		 * Do OS callback.
 		 */
@@ -1870,7 +1854,7 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	    vdevice->vtarget->channel, vdevice->vtarget->id, vdevice->lun,
 	    ctx2abort, mptscsih_get_tm_timeout(ioc));
 
-	if (SCPNT_TO_LOOKUP_IDX(SCpnt) == scpnt_idx &&
+	if (SCPNT_TO_LOOKUP_IDX(ioc, SCpnt) == scpnt_idx &&
 	    SCpnt->serial_number == sn)
 		retval = FAILED;
 
@@ -2551,21 +2535,101 @@ mptscsih_copy_sense_data(struct scsi_cmn
 	}
 }
 
-static int
-SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc)
+/**
+ * mptscsih_get_scsi_lookup
+ *
+ * retrieves scmd entry from ScsiLookup[] array list
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @i: index into the array
+ *
+ * Returns the scsi_cmd pointer
+ *
+ **/
+static struct scsi_cmnd *
+mptscsih_get_scsi_lookup(MPT_ADAPTER *ioc, int i)
 {
-	MPT_SCSI_HOST *hd;
-	int i;
+	unsigned long	flags;
+	struct scsi_cmnd *scmd;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	scmd = ioc->ScsiLookup[i];
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return scmd;
+}
+
+/**
+ * mptscsih_getclear_scsi_lookup
+ *
+ * retrieves and clears scmd entry from ScsiLookup[] array list
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @i: index into the array
+ *
+ * Returns the scsi_cmd pointer
+ *
+ **/
+static struct scsi_cmnd *
+mptscsih_getclear_scsi_lookup(MPT_ADAPTER *ioc, int i)
+{
+	unsigned long	flags;
+	struct scsi_cmnd *scmd;
+
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	scmd = ioc->ScsiLookup[i];
+	ioc->ScsiLookup[i] = NULL;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+
+	return scmd;
+}
+
+/**
+ * mptscsih_set_scsi_lookup
+ *
+ * writes a scmd entry into the ScsiLookup[] array list
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @i: index into the array
+ * @scmd: scsi_cmnd pointer
+ *
+ **/
+static void
+mptscsih_set_scsi_lookup(MPT_ADAPTER *ioc, int i, struct scsi_cmnd *scmd)
+{
+	unsigned long	flags;
 
-	hd = shost_priv(sc->device->host);
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	ioc->ScsiLookup[i] = scmd;
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+}
+
+/**
+ * SCPNT_TO_LOOKUP_IDX
+ *
+ * search's for a given scmd in the ScsiLookup[] array list
+ *
+ * @ioc: Pointer to MPT_ADAPTER structure
+ * @scmd: scsi_cmnd pointer
+ *
+ **/
+static int
+SCPNT_TO_LOOKUP_IDX(MPT_ADAPTER *ioc, struct scsi_cmnd *sc)
+{
+	unsigned long	flags;
+	int i, index=-1;
 
-	for (i = 0; i < hd->ioc->req_depth; i++) {
-		if (hd->ScsiLookup[i] == sc) {
-			return i;
+	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+	for (i = 0; i < ioc->req_depth; i++) {
+		if (ioc->ScsiLookup[i] == sc) {
+			index = i;
+			goto out;
 		}
 	}
 
-	return -1;
+ out:
+	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
+	return index;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -2574,7 +2638,6 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 {
 	MPT_SCSI_HOST	*hd;
 	unsigned long	 flags;
-	int 		ii;
 
 	dtmprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 	    ": IOC %s_reset routed to SCSI host driver!\n",
@@ -2630,11 +2693,6 @@ mptscsih_ioc_reset(MPT_ADAPTER *ioc, int
 		 * Init all control structures.
 		 */
 
-		/* ScsiLookup initialization
-		 */
-		for (ii=0; ii < ioc->req_depth; ii++)
-			hd->ScsiLookup[ii] = NULL;
-
 		/* 2. Chain Buffer initialization
 		 */
 
@@ -2772,7 +2830,7 @@ mptscsih_scandv_complete(MPT_ADAPTER *io
 
 	del_timer(&hd->timer);
 	req_idx = le16_to_cpu(mf->u.frame.hwhdr.msgctxu.fld.req_idx);
-	hd->ScsiLookup[req_idx] = NULL;
+	mptscsih_set_scsi_lookup(ioc, req_idx, NULL);
 	pReq = (SCSIIORequest_t *) mf;
 
 	if (mf != hd->cmdPtr) {
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-09-17 15:17:26.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-09-17 16:35:27.000000000 -0600
@@ -1446,14 +1446,15 @@ mptspi_probe(struct pci_dev *pdev, const
 	/* SCSI needs scsi_cmnd lookup table!
 	 * (with size equal to req_depth*PtrSz!)
 	 */
-	hd->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
-	if (!hd->ScsiLookup) {
+	ioc->ScsiLookup = kcalloc(ioc->req_depth, sizeof(void *), GFP_ATOMIC);
+	if (!ioc->ScsiLookup) {
 		error = -ENOMEM;
 		goto out_mptspi_probe;
 	}
+	spin_lock_init(&ioc->scsi_lookup_lock);
 
 	dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "ScsiLookup @ %p\n",
-		 ioc->name, hd->ScsiLookup));
+		 ioc->name, ioc->ScsiLookup));
 
 	/* Clear the TM flags
 	 */
