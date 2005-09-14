From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sym2: remove code to handle DMA_BIDIRECTION requests
Date: Wed, 14 Sep 2005 15:41:31 +0200
Message-ID: <20050914134131.GA9700@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58501 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965207AbVINNlf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 09:41:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

The upper layer doesn't send these down since 2.4.x (or 2.6 in
practice), so no need to handle it.  Inline sym_setup_data_pointers
into it's only caller so we can fail gracefully in the case we'd get
one neverless.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_fw.c	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.c	2005-09-14 15:40:56.000000000 +0200
@@ -70,9 +70,6 @@
 };
 static struct sym_fwb_ofs sym_fw1b_ofs = {
 	SYM_GEN_FW_B(struct SYM_FWB_SCR)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(struct SYM_FWB_SCR, data_io)
-#endif
 };
 static struct sym_fwz_ofs sym_fw1z_ofs = {
 	SYM_GEN_FW_Z(struct SYM_FWZ_SCR)
@@ -98,9 +95,6 @@
 };
 static struct sym_fwb_ofs sym_fw2b_ofs = {
 	SYM_GEN_FW_B(struct SYM_FWB_SCR)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(struct SYM_FWB_SCR, data_io)
-#endif
 	SYM_GEN_B(struct SYM_FWB_SCR, start64)
 	SYM_GEN_B(struct SYM_FWB_SCR, pm_handle)
 };
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_fw.h	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw.h	2005-09-14 15:40:31.000000000 +0200
@@ -92,9 +92,6 @@
 };
 struct sym_fwb_ofs {
 	SYM_GEN_FW_B(u_short)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(u_short, data_io)
-#endif
 	SYM_GEN_B(u_short, start64)
 	SYM_GEN_B(u_short, pm_handle)
 };
@@ -111,9 +108,6 @@
 };
 struct sym_fwb_ba {
 	SYM_GEN_FW_B(u32)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(u32, data_io)
-#endif
 	SYM_GEN_B(u32, start64);
 	SYM_GEN_B(u32, pm_handle);
 };
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw1.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_fw1.h	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw1.h	2005-09-14 15:40:42.000000000 +0200
@@ -197,12 +197,6 @@
 	u32 bad_status		[  7];
 	u32 wsr_ma_helper	[  4];
 
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	/* Unknown direction handling */
-	u32 data_io		[  2];
-	u32 data_io_com		[  8];
-	u32 data_io_out		[  7];
-#endif
 	/* Data area */
 	u32 zero		[  1];
 	u32 scratch		[  1];
@@ -1747,48 +1741,6 @@
 	SCR_JUMP,
 		PADDR_A (dispatch),
 
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-}/*-------------------------< DATA_IO >--------------------------*/,{
-	/*
-	 *  We jump here if the data direction was unknown at the 
-	 *  time we had to queue the command to the scripts processor.
-	 *  Pointers had been set as follow in this situation:
-	 *    savep   -->   DATA_IO
-	 *    lastp   -->   start pointer when DATA_IN
-	 *    wlastp  -->   start pointer when DATA_OUT
-	 *  This script sets savep and lastp according to the 
-	 *  direction chosen by the target.
-	 */
-	SCR_JUMP ^ IFTRUE (WHEN (SCR_DATA_OUT)),
-		PADDR_B (data_io_out),
-}/*-------------------------< DATA_IO_COM >----------------------*/,{
-	/*
-	 *  Direction is DATA IN.
-	 */
-	SCR_COPY  (4),
-		HADDR_1 (ccb_head.lastp),
-		HADDR_1 (ccb_head.savep),
-	/*
-	 *  Jump to the SCRIPTS according to actual direction.
-	 */
-	SCR_COPY  (4),
-		HADDR_1 (ccb_head.savep),
-		RADDR_1 (temp),
-	SCR_RETURN,
-		0,
-}/*-------------------------< DATA_IO_OUT >----------------------*/,{
-	/*
-	 *  Direction is DATA OUT.
-	 */
-	SCR_REG_REG (HF_REG, SCR_AND, (~HF_DATA_IN)),
-		0,
-	SCR_COPY  (4),
-		HADDR_1 (ccb_head.wlastp),
-		HADDR_1 (ccb_head.lastp),
-	SCR_JUMP,
-		PADDR_B(data_io_com),
-#endif /* SYM_OPT_HANDLE_DIR_UNKNOWN */
-
 }/*-------------------------< ZERO >-----------------------------*/,{
 	SCR_DATA_ZERO,
 }/*-------------------------< SCRATCH >--------------------------*/,{
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw2.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_fw2.h	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_fw2.h	2005-09-14 15:40:53.000000000 +0200
@@ -191,13 +191,6 @@
 	u32 pm_wsr_handle	[ 38];
 	u32 wsr_ma_helper	[  4];
 
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	/* Unknown direction handling */
-	u32 data_io		[  2];
-	u32 data_io_in		[  2];
-	u32 data_io_com		[  6];
-	u32 data_io_out		[  8];
-#endif
 	/* Data area */
 	u32 zero		[  1];
 	u32 scratch		[  1];
@@ -1838,51 +1831,6 @@
 	SCR_JUMP,
 		PADDR_A (dispatch),
 
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-}/*-------------------------< DATA_IO >--------------------------*/,{
-	/*
-	 *  We jump here if the data direction was unknown at the 
-	 *  time we had to queue the command to the scripts processor.
-	 *  Pointers had been set as follow in this situation:
-	 *    savep   -->   DATA_IO
-	 *    lastp   -->   start pointer when DATA_IN
-	 *    wlastp  -->   start pointer when DATA_OUT
-	 *  This script sets savep and lastp according to the 
-	 *  direction chosen by the target.
-	 */
-	SCR_JUMP ^ IFTRUE (WHEN (SCR_DATA_OUT)),
-		PADDR_B (data_io_out),
-}/*-------------------------< DATA_IO_IN >-----------------------*/,{
-	/*
-	 *  Direction is DATA IN.
-	 */
-	SCR_LOAD_REL  (scratcha, 4),
-		offsetof (struct sym_ccb, phys.head.lastp),
-}/*-------------------------< DATA_IO_COM >----------------------*/,{
-	SCR_STORE_REL (scratcha, 4),
-		offsetof (struct sym_ccb, phys.head.savep),
-
-	/*
-	 *  Jump to the SCRIPTS according to actual direction.
-	 */
-	SCR_LOAD_REL  (temp, 4),
-		offsetof (struct sym_ccb, phys.head.savep),
-	SCR_RETURN,
-		0,
-}/*-------------------------< DATA_IO_OUT >----------------------*/,{
-	/*
-	 *  Direction is DATA OUT.
-	 */
-	SCR_REG_REG (HF_REG, SCR_AND, (~HF_DATA_IN)),
-		0,
-	SCR_LOAD_REL  (scratcha, 4),
-		offsetof (struct sym_ccb, phys.head.wlastp),
-	SCR_STORE_REL (scratcha, 4),
-		offsetof (struct sym_ccb, phys.head.lastp),
-	SCR_JUMP,
-		PADDR_B(data_io_com),
-#endif /* SYM_OPT_HANDLE_DIR_UNKNOWN */
-
 }/*-------------------------< ZERO >-----------------------------*/,{
 	SCR_DATA_ZERO,
 }/*-------------------------< SCRATCH >--------------------------*/,{
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.h	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.h	2005-09-14 15:42:57.000000000 +0200
@@ -68,7 +68,6 @@
  */
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
-#define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-09-14 15:42:04.000000000 +0200
@@ -3650,7 +3650,7 @@
 	 *  If result is dp_sg = SYM_CONF_MAX_SG, then we are at the 
 	 *  end of the data.
 	 */
-	tmp = scr_to_cpu(sym_goalp(cp));
+	tmp = scr_to_cpu(cp->goalp);
 	dp_sg = SYM_CONF_MAX_SG;
 	if (dp_scr != tmp)
 		dp_sg -= (tmp - 8 - (int)dp_scr) / (2*4);
@@ -3757,7 +3757,7 @@
 	 *  And our alchemy:) allows to easily calculate the data 
 	 *  script address we want to return for the next data phase.
 	 */
-	dp_ret = cpu_to_scr(sym_goalp(cp));
+	dp_ret = cpu_to_scr(cp->goalp);
 	dp_ret = dp_ret - 8 - (SYM_CONF_MAX_SG - dp_sg) * (2*4);
 
 	/*
@@ -3853,7 +3853,7 @@
 	 *  If all data has been transferred,
 	 *  there is no residual.
 	 */
-	if (cp->phys.head.lastp == sym_goalp(cp))
+	if (cp->phys.head.lastp == cp->goalp)
 		return resid;
 
 	/*
@@ -5527,7 +5527,7 @@
 	 *  extended error did occur, there is no residual.
 	 */
 	resid = 0;
-	if (cp->phys.head.lastp != sym_goalp(cp))
+	if (cp->phys.head.lastp != cp->goalp)
 		resid = sym_compute_residual(np, cp);
 
 	/*
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-09-14 15:45:27.000000000 +0200
@@ -46,12 +46,6 @@
  *  They may be defined in platform specific headers, if they 
  *  are useful.
  *
- *    SYM_OPT_HANDLE_DIR_UNKNOWN
- *        When this option is set, the SCRIPTS used by the driver 
- *        are able to handle SCSI transfers with direction not 
- *        supplied by user.
- *        (set for Linux-2.0.X)
- *
  *    SYM_OPT_HANDLE_DEVICE_QUEUEING
  *        When this option is set, the driver will use a queue per 
  *        device and handle QUEUE FULL status requeuing internally.
@@ -62,7 +56,6 @@
  *        (set for Linux)
  */
 #if 0
-#define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #endif
@@ -670,9 +663,6 @@
 	 */
 	u32	savep;		/* Jump address to saved data pointer	*/
 	u32	lastp;		/* SCRIPTS address at end of data	*/
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	u32	wlastp;
-#endif
 
 	/*
 	 *  Status fields.
@@ -802,9 +792,6 @@
 	SYM_QUEHEAD link_ccbq;	/* Link to free/busy CCB queue	*/
 	u32	startp;		/* Initial data pointer		*/
 	u32	goalp;		/* Expected last data pointer	*/
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	u32	wgoalp;
-#endif
 	int	ext_sg;		/* Extreme data pointer, used	*/
 	int	ext_ofs;	/*  to calculate the residual.	*/
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
@@ -819,12 +806,6 @@
 
 #define CCB_BA(cp,lbl)	cpu_to_scr(cp->ccb_ba + offsetof(struct sym_ccb, lbl))
 
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-#define	sym_goalp(cp) ((cp->host_flags & HF_DATA_IN) ? cp->goalp : cp->wgoalp)
-#else
-#define	sym_goalp(cp) (cp->goalp)
-#endif
-
 typedef struct device *m_pool_ident_t;
 
 /*
@@ -1134,71 +1115,6 @@
 #endif
 
 /*
- *  Set up data pointers used by SCRIPTS.
- *  Called from O/S specific code.
- */
-static inline void sym_setup_data_pointers(struct sym_hcb *np,
-		struct sym_ccb *cp, int dir)
-{
-	u32 lastp, goalp;
-
-	/*
-	 *  No segments means no data.
-	 */
-	if (!cp->segments)
-		dir = DMA_NONE;
-
-	/*
-	 *  Set the data pointer.
-	 */
-	switch(dir) {
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	case DMA_BIDIRECTIONAL:
-#endif
-	case DMA_TO_DEVICE:
-		goalp = SCRIPTA_BA(np, data_out2) + 8;
-		lastp = goalp - 8 - (cp->segments * (2*4));
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-		cp->wgoalp = cpu_to_scr(goalp);
-		if (dir != DMA_BIDIRECTIONAL)
-			break;
-		cp->phys.head.wlastp = cpu_to_scr(lastp);
-		/* fall through */
-#else
-		break;
-#endif
-	case DMA_FROM_DEVICE:
-		cp->host_flags |= HF_DATA_IN;
-		goalp = SCRIPTA_BA(np, data_in2) + 8;
-		lastp = goalp - 8 - (cp->segments * (2*4));
-		break;
-	case DMA_NONE:
-	default:
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-		cp->host_flags |= HF_DATA_IN;
-#endif
-		lastp = goalp = SCRIPTB_BA(np, no_data);
-		break;
-	}
-
-	/*
-	 *  Set all pointers values needed by SCRIPTS.
-	 */
-	cp->phys.head.lastp = cpu_to_scr(lastp);
-	cp->phys.head.savep = cpu_to_scr(lastp);
-	cp->startp	    = cp->phys.head.savep;
-	cp->goalp	    = cpu_to_scr(goalp);
-
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	/*
-	 *  If direction is unknown, start at data_io.
-	 */
-	if (dir == DMA_BIDIRECTIONAL)
-		cp->phys.head.savep = cpu_to_scr(SCRIPTB_BA(np, data_io));
-#endif
-}
-
-/*
  *  MEMORY ALLOCATOR.
  */
 
Index: scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-08-31 13:59:12.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-09-14 15:52:14.000000000 +0200
@@ -514,9 +514,10 @@
  */
 int sym_setup_data_and_start(struct sym_hcb *np, struct scsi_cmnd *cmd, struct sym_ccb *cp)
 {
-	int dir;
 	struct sym_tcb *tp = &np->target[cp->target];
 	struct sym_lcb *lp = sym_lp(tp, cp->lun);
+	u32 lastp, goalp;
+	int dir;
 
 	/*
 	 *  Build the CDB.
@@ -534,15 +535,47 @@
 			sym_set_cam_status(cmd, DID_ERROR);
 			goto out_abort;
 		}
+
+		/*
+		 *  No segments means no data.
+		 */
+		if (!cp->segments)
+			dir = DMA_NONE;
 	} else {
 		cp->data_len = 0;
 		cp->segments = 0;
 	}
 
 	/*
-	 *  Set data pointers.
+	 *  Set the data pointer.
+	 */
+	switch (dir) {
+	case DMA_BIDIRECTIONAL:
+		printk("%s: got DMA_BIDIRECTIONAL command", sym_name(np));
+		sym_set_cam_status(cmd, DID_ERROR);
+		goto out_abort;
+	case DMA_TO_DEVICE:
+		goalp = SCRIPTA_BA(np, data_out2) + 8;
+		lastp = goalp - 8 - (cp->segments * (2*4));
+		break;
+	case DMA_FROM_DEVICE:
+		cp->host_flags |= HF_DATA_IN;
+		goalp = SCRIPTA_BA(np, data_in2) + 8;
+		lastp = goalp - 8 - (cp->segments * (2*4));
+		break;
+	case DMA_NONE:
+	default:
+		lastp = goalp = SCRIPTB_BA(np, no_data);
+		break;
+	}
+
+	/*
+	 *  Set all pointers values needed by SCRIPTS.
 	 */
-	sym_setup_data_pointers(np, cp, dir);
+	cp->phys.head.lastp = cpu_to_scr(lastp);
+	cp->phys.head.savep = cpu_to_scr(lastp);
+	cp->startp	    = cp->phys.head.savep;
+	cp->goalp	    = cpu_to_scr(goalp);
 
 	/*
 	 *  When `#ifed 1', the code below makes the driver 
