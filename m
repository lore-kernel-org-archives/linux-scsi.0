From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, RFC] sym2: remove unkown data direction handling
Date: Tue, 2 Nov 2004 12:18:35 +0100
Message-ID: <20041102111835.GA29191@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:19907 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261194AbUKBLSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 06:18:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

since 2.3 the LLDD gets the data direction passed down, so we don't
need to kludge around an unknown data direction anymore.  I've added
a BUG when we get an unkown data direction neverless, and it seems to
survive so far under low load.


--- 1.7/drivers/scsi/sym53c8xx_2/sym_fw.c	2004-09-13 11:10:31 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_fw.c	2004-10-26 14:35:24 +02:00
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
===== drivers/scsi/sym53c8xx_2/sym_fw.h 1.3 vs edited =====
--- 1.3/drivers/scsi/sym53c8xx_2/sym_fw.h	2004-09-13 11:10:31 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_fw.h	2004-10-26 14:35:01 +02:00
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
===== drivers/scsi/sym53c8xx_2/sym_fw1.h 1.6 vs edited =====
--- 1.6/drivers/scsi/sym53c8xx_2/sym_fw1.h	2004-09-13 11:10:31 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_fw1.h	2004-10-26 14:35:11 +02:00
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
@@ -1746,48 +1740,6 @@
 		offsetof (struct sym_ccb, phys.wresid),
 	SCR_JUMP,
 		PADDR_A (dispatch),
-
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
 
 }/*-------------------------< ZERO >-----------------------------*/,{
 	SCR_DATA_ZERO,
===== drivers/scsi/sym53c8xx_2/sym_fw2.h 1.6 vs edited =====
--- 1.6/drivers/scsi/sym53c8xx_2/sym_fw2.h	2004-09-13 11:10:32 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_fw2.h	2004-10-26 14:35:21 +02:00
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
@@ -1837,51 +1830,6 @@
 		offsetof (struct sym_ccb, phys.wresid),
 	SCR_JUMP,
 		PADDR_A (dispatch),
-
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
 
 }/*-------------------------< ZERO >-----------------------------*/,{
 	SCR_DATA_ZERO,
===== drivers/scsi/sym53c8xx_2/sym_glue.h 1.23 vs edited =====
--- 1.23/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-10-24 18:08:18 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-10-26 14:35:32 +02:00
@@ -74,7 +74,6 @@
  */
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
-#define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
===== drivers/scsi/sym53c8xx_2/sym_hipd.h 1.8 vs edited =====
--- 1.8/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-09-13 11:10:32 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-11-02 12:10:53 +01:00
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
@@ -663,9 +656,6 @@
 	 */
 	u32	savep;		/* Jump address to saved data pointer	*/
 	u32	lastp;		/* SCRIPTS address at end of data	*/
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	u32	wlastp;
-#endif
 
 	/*
 	 *  Status fields.
@@ -810,9 +800,6 @@
 		link_ccbq;	/* Link to free/busy CCB queue	*/
 	u32	startp;		/* Initial data pointer		*/
 	u32	goalp;		/* Expected last data pointer	*/
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	u32	wgoalp;
-#endif
 	int	ext_sg;		/* Extreme data pointer, used	*/
 	int	ext_ofs;	/*  to calculate the residual.	*/
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
@@ -828,11 +815,7 @@
 
 #define CCB_BA(cp,lbl)	(cp->ccb_ba + offsetof(struct sym_ccb, lbl))
 
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-#define	sym_goalp(cp) ((cp->host_flags & HF_DATA_IN) ? cp->goalp : cp->wgoalp)
-#else
 #define	sym_goalp(cp) (cp->goalp)
-#endif
 
 /*
  *  Host Control Block
@@ -1192,34 +1175,22 @@
 	/*
 	 *  Set the data pointer.
 	 */
-	switch(dir) {
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	case CAM_DIR_UNKNOWN:
-#endif
+	switch (dir) {
 	case CAM_DIR_OUT:
 		goalp = SCRIPTA_BA (np, data_out2) + 8;
 		lastp = goalp - 8 - (cp->segments * (2*4));
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-		cp->wgoalp = cpu_to_scr(goalp);
-		if (dir != CAM_DIR_UNKNOWN)
-			break;
-		cp->phys.head.wlastp = cpu_to_scr(lastp);
-		/* fall through */
-#else
 		break;
-#endif
 	case CAM_DIR_IN:
 		cp->host_flags |= HF_DATA_IN;
 		goalp = SCRIPTA_BA (np, data_in2) + 8;
 		lastp = goalp - 8 - (cp->segments * (2*4));
 		break;
 	case CAM_DIR_NONE:
-	default:
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-		cp->host_flags |= HF_DATA_IN;
-#endif
 		lastp = goalp = SCRIPTB_BA (np, no_data);
 		break;
+	case CAM_DIR_UNKNOWN:
+	default:
+		BUG();
 	}
 
 	/*
@@ -1229,14 +1200,6 @@
 	cp->phys.head.savep = cpu_to_scr(lastp);
 	cp->startp	    = cp->phys.head.savep;
 	cp->goalp	    = cpu_to_scr(goalp);
-
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	/*
-	 *  If direction is unknown, start at data_io.
-	 */
-	if (dir == CAM_DIR_UNKNOWN)
-		cp->phys.head.savep = cpu_to_scr(SCRIPTB_BA (np, data_io));
-#endif
 }
 
 /*
