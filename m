From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/11] [SYM2] Remove code to handle DMA_BIDIRECTION requests
Date: Tue, 29 Nov 2005 23:08:33 -0500 (EST)
Message-ID: <20051130040833.095E37626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:55998 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1750843AbVK3EIh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:37 -0500
Received: from mail2.magma.ca (mail2.magma.ca [206.191.0.214])
	by mx2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48ZT4014246
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:36 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48YV6002565
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:35 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The upper layer doesn't send these down since 2.4.x (or 2.6 in
practice), so no need to handle it.  Inline sym_setup_data_pointers
into its only caller so we can fail gracefully in the case we'd get
one neverless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_fw.c   |    6 ---
 drivers/scsi/sym53c8xx_2/sym_fw.h   |    6 ---
 drivers/scsi/sym53c8xx_2/sym_fw1.h  |   48 --------------------
 drivers/scsi/sym53c8xx_2/sym_fw2.h  |   52 ----------------------
 drivers/scsi/sym53c8xx_2/sym_glue.c |   39 +++++++++++++++-
 drivers/scsi/sym53c8xx_2/sym_glue.h |    1 
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    8 ++-
 drivers/scsi/sym53c8xx_2/sym_hipd.h |   84 -----------------------------------
 8 files changed, 40 insertions(+), 204 deletions(-)

applies-to: e1b800876a9da29e28cbdce5d11db7884d50542c
15a1cca64aced042ec913e4cf00c7cbad661820b
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index a7528a8..9916a2a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -62,9 +62,6 @@ static struct sym_fwa_ofs sym_fw1a_ofs =
 };
 static struct sym_fwb_ofs sym_fw1b_ofs = {
 	SYM_GEN_FW_B(struct SYM_FWB_SCR)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(struct SYM_FWB_SCR, data_io)
-#endif
 };
 static struct sym_fwz_ofs sym_fw1z_ofs = {
 	SYM_GEN_FW_Z(struct SYM_FWZ_SCR)
@@ -86,9 +83,6 @@ static struct sym_fwa_ofs sym_fw2a_ofs =
 };
 static struct sym_fwb_ofs sym_fw2b_ofs = {
 	SYM_GEN_FW_B(struct SYM_FWB_SCR)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(struct SYM_FWB_SCR, data_io)
-#endif
 	SYM_GEN_B(struct SYM_FWB_SCR, start64)
 	SYM_GEN_B(struct SYM_FWB_SCR, pm_handle)
 };
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.h b/drivers/scsi/sym53c8xx_2/sym_fw.h
index 43f6810..66ec35b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.h
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.h
@@ -92,9 +92,6 @@ struct sym_fwa_ofs {
 };
 struct sym_fwb_ofs {
 	SYM_GEN_FW_B(u_short)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(u_short, data_io)
-#endif
 	SYM_GEN_B(u_short, start64)
 	SYM_GEN_B(u_short, pm_handle)
 };
@@ -111,9 +108,6 @@ struct sym_fwa_ba {
 };
 struct sym_fwb_ba {
 	SYM_GEN_FW_B(u32)
-#ifdef SYM_OPT_HANDLE_DIR_UNKNOWN
-	SYM_GEN_B(u32, data_io)
-#endif
 	SYM_GEN_B(u32, start64);
 	SYM_GEN_B(u32, pm_handle);
 };
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw1.h b/drivers/scsi/sym53c8xx_2/sym_fw1.h
index cdd92d8..7b39f4a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw1.h
+++ b/drivers/scsi/sym53c8xx_2/sym_fw1.h
@@ -197,12 +197,6 @@ struct SYM_FWB_SCR {
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
@@ -1747,48 +1741,6 @@ static struct SYM_FWB_SCR SYM_FWB_SCR = 
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
diff --git a/drivers/scsi/sym53c8xx_2/sym_fw2.h b/drivers/scsi/sym53c8xx_2/sym_fw2.h
index 7ea7151..851f270 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw2.h
+++ b/drivers/scsi/sym53c8xx_2/sym_fw2.h
@@ -191,13 +191,6 @@ struct SYM_FWB_SCR {
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
@@ -1838,51 +1831,6 @@ static struct SYM_FWB_SCR SYM_FWB_SCR = 
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
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 60beee2..b39151f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -514,9 +514,10 @@ static inline int sym_setup_cdb(struct s
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
@@ -534,15 +535,47 @@ int sym_setup_data_and_start(struct sym_
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
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index c61c23f..cc92d0c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -68,7 +68,6 @@
  */
 #define	SYM_CONF_TIMER_INTERVAL		((HZ+1)/2)
 
-#define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index bec6448..b4f0d9a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -3654,7 +3654,7 @@ static int sym_evaluate_dp(struct sym_hc
 	 *  If result is dp_sg = SYM_CONF_MAX_SG, then we are at the 
 	 *  end of the data.
 	 */
-	tmp = scr_to_cpu(sym_goalp(cp));
+	tmp = scr_to_cpu(cp->goalp);
 	dp_sg = SYM_CONF_MAX_SG;
 	if (dp_scr != tmp)
 		dp_sg -= (tmp - 8 - (int)dp_scr) / (2*4);
@@ -3761,7 +3761,7 @@ static void sym_modify_dp(struct sym_hcb
 	 *  And our alchemy:) allows to easily calculate the data 
 	 *  script address we want to return for the next data phase.
 	 */
-	dp_ret = cpu_to_scr(sym_goalp(cp));
+	dp_ret = cpu_to_scr(cp->goalp);
 	dp_ret = dp_ret - 8 - (SYM_CONF_MAX_SG - dp_sg) * (2*4);
 
 	/*
@@ -3857,7 +3857,7 @@ int sym_compute_residual(struct sym_hcb 
 	 *  If all data has been transferred,
 	 *  there is no residual.
 	 */
-	if (cp->phys.head.lastp == sym_goalp(cp))
+	if (cp->phys.head.lastp == cp->goalp)
 		return resid;
 
 	/*
@@ -5470,7 +5470,7 @@ void sym_complete_ok (struct sym_hcb *np
 	 *  extended error did occur, there is no residual.
 	 */
 	resid = 0;
-	if (cp->phys.head.lastp != sym_goalp(cp))
+	if (cp->phys.head.lastp != cp->goalp)
 		resid = sym_compute_residual(np, cp);
 
 	/*
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 7560088..1718110 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -48,12 +48,6 @@
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
@@ -64,7 +58,6 @@
  *        (set for Linux)
  */
 #if 0
-#define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #endif
@@ -659,9 +652,6 @@ struct sym_ccbh {
 	 */
 	u32	savep;		/* Jump address to saved data pointer	*/
 	u32	lastp;		/* SCRIPTS address at end of data	*/
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	u32	wlastp;
-#endif
 
 	/*
 	 *  Status fields.
@@ -791,9 +781,6 @@ struct sym_ccb {
 	SYM_QUEHEAD link_ccbq;	/* Link to free/busy CCB queue	*/
 	u32	startp;		/* Initial data pointer		*/
 	u32	goalp;		/* Expected last data pointer	*/
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-	u32	wgoalp;
-#endif
 	int	ext_sg;		/* Extreme data pointer, used	*/
 	int	ext_ofs;	/*  to calculate the residual.	*/
 #ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
@@ -808,12 +795,6 @@ struct sym_ccb {
 
 #define CCB_BA(cp,lbl)	cpu_to_scr(cp->ccb_ba + offsetof(struct sym_ccb, lbl))
 
-#ifdef	SYM_OPT_HANDLE_DIR_UNKNOWN
-#define	sym_goalp(cp) ((cp->host_flags & HF_DATA_IN) ? cp->goalp : cp->wgoalp)
-#else
-#define	sym_goalp(cp) (cp->goalp)
-#endif
-
 typedef struct device *m_pool_ident_t;
 
 /*
@@ -1122,71 +1103,6 @@ bad:
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
 
---
0.99.9.GIT
