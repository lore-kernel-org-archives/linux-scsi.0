From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix sym2 negotiation
Date: 21 Aug 2004 14:37:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093113450.1732.334.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:38590 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267658AbUHUSjJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 14:39:09 -0400
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The problems with domain validation were just the tip of the iceberg in
the sym2 driver.  Most of its problems seem to come from an overly
complex set of negotiating rules, which I've swept away with this patch.

I also removed the ability to set parameters in the on-board bios and
have the driver respect them. (this hasn't worked for a while in 2.6
because after the driver sets them, Domain Validation resets them
again).

Finally, there was a really nasty bug where the driver negotiates
improperly when turning off DT clocking.  If you simply turn it off, the
driver originally fell back to using the old WDTR/SDTR method of
negotiation.  However, since it thought the bus was already wide, it
only emitted a SDTR, which causes the device to reset from wide to
narrow.  Hence the driver thinks the device is wide and the device
thinks it is narrow => boom.

I redid the negotiation to predicate PPR messages on whether the device
claims support for them or not.

Finally, all this is dependent on the new inquiry getting macros of a
previous patch.

James

 sym_glue.c  |  119 ++++++----------------------------------------------------
 sym_glue.h  |    8 +++
 sym_hipd.c  |  122 ++++++++++++++++++++++++++++++++----------------------------
 sym_hipd.h  |   40 -------------------
 sym_misc.c  |  118 ----------------------------------------------------------
 sym_nvram.c |   16 -------
 6 files changed, 88 insertions(+), 335 deletions(-)

===== drivers/scsi/sym53c8xx_2/sym_hipd.c 1.20 vs edited =====
--- 1.20/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-08-21 09:27:03 -07:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_hipd.c	2004-08-21 11:17:09 -07:00
@@ -1038,28 +1038,11 @@
 	for (i = 0 ; i < SYM_CONF_MAX_TARGET ; i++) {
 		tcb_p tp = &np->target[i];
 
-		tp->tinfo.user.scsi_version = tp->tinfo.curr.scsi_version= 2;
-		tp->tinfo.user.spi_version  = tp->tinfo.curr.spi_version = 2;
-		tp->tinfo.user.period = np->minsync;
-		tp->tinfo.user.offset = np->maxoffs;
-		tp->tinfo.user.width  = np->maxwide ? BUS_16_BIT : BUS_8_BIT;
 		tp->usrflags |= (SYM_DISC_ENABLED | SYM_TAGS_ENABLED);
 		tp->usrtags = SYM_SETUP_MAX_TAG;
 
 		sym_nvram_setup_target (np, i, nvram);
 
-		/*
-		 * Some single-ended devices may crash on receiving a
-		 * PPR negotiation attempt.  Only try PPR if we're in
-		 * LVD mode.
-		 */
-		if (np->features & FE_ULTRA3) {
-			tp->tinfo.user.options |= PPR_OPT_DT;
-			tp->tinfo.user.period = np->minsync_dt;
-			tp->tinfo.user.offset = np->maxoffs_dt;
-			tp->tinfo.user.spi_version = 3;
-		}
-
 		if (!tp->usrtags)
 			tp->usrflags &= ~SYM_TAGS_ENABLED;
 	}
@@ -1493,6 +1476,55 @@
 }
 #endif
 
+static void sym_check_goals(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_trans *st = &np->target[sdev->id].tinfo.goal;
+
+	/* here we enforce all the fiddly SPI rules */
+
+	if (!scsi_device_wide(sdev))
+		st->width = 0;
+
+	if (!scsi_device_sync(sdev)) {
+		st->options = 0;
+		st->period = 0;
+		st->offset = 0;
+		return;
+	}
+		
+	if (scsi_device_dt(sdev)) {
+		if (scsi_device_dt_only(sdev))
+			st->options |= PPR_OPT_DT;
+
+		if (st->offset == 0)
+			st->options &= ~PPR_OPT_DT;
+	} else {
+		st->options &= ~PPR_OPT_DT;
+	}
+
+	if (!(np->features & FE_ULTRA3))
+		st->options &= ~PPR_OPT_DT;
+
+	if (st->options & PPR_OPT_DT) {
+		/* all DT transfers must be wide */
+		st->width = 1;
+		if (st->offset > np->maxoffs_dt)
+			st->offset = np->maxoffs_dt;
+		if (st->period < np->minsync_dt)
+			st->period = np->minsync_dt;
+		if (st->period > np->maxsync_dt)
+			st->period = np->maxsync_dt;
+	} else {
+		if (st->offset > np->maxoffs)
+			st->offset = np->maxoffs;
+		if (st->period < np->minsync)
+			st->period = np->minsync;
+		if (st->period > np->maxsync)
+			st->period = np->maxsync;
+	}
+}		
+
 /*
  *  Prepare the next negotiation message if needed.
  *
@@ -1504,6 +1536,10 @@
 {
 	tcb_p tp = &np->target[cp->target];
 	int msglen = 0;
+	struct scsi_device *sdev = tp->sdev;
+
+	if (likely(sdev))
+		sym_check_goals(sdev);
 
 	/*
 	 *  Early C1010 chips need a work-around for DT 
@@ -1514,19 +1550,21 @@
 	/*
 	 *  negotiate using PPR ?
 	 */
-	if (tp->tinfo.goal.options & PPR_OPT_MASK)
+	if (scsi_device_dt(sdev)) {
 		nego = NS_PPR;
-	/*
-	 *  negotiate wide transfers ?
-	 */
-	else if (tp->tinfo.curr.width != tp->tinfo.goal.width)
-		nego = NS_WIDE;
-	/*
-	 *  negotiate synchronous transfers?
-	 */
-	else if (tp->tinfo.curr.period != tp->tinfo.goal.period ||
-		 tp->tinfo.curr.offset != tp->tinfo.goal.offset)
-		nego = NS_SYNC;
+	} else {
+		/*
+		 *  negotiate wide transfers ?
+		 */
+		if (tp->tinfo.curr.width != tp->tinfo.goal.width)
+			nego = NS_WIDE;
+		/*
+		 *  negotiate synchronous transfers?
+		 */
+		else if (tp->tinfo.curr.period != tp->tinfo.goal.period ||
+			 tp->tinfo.curr.offset != tp->tinfo.goal.offset)
+			nego = NS_SYNC;
+	}
 
 	switch (nego) {
 	case NS_SYNC:
@@ -3995,7 +4033,6 @@
 static int  
 sym_sync_nego_check(hcb_p np, int req, int target)
 {
-	tcb_p tp = &np->target[target];
 	u_char	chg, ofs, per, fak, div;
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
@@ -4015,19 +4052,11 @@
 	if (ofs) {
 		if (ofs > np->maxoffs)
 			{chg = 1; ofs = np->maxoffs;}
-		if (req) {
-			if (ofs > tp->tinfo.user.offset)
-				{chg = 1; ofs = tp->tinfo.user.offset;}
-		}
 	}
 
 	if (ofs) {
 		if (per < np->minsync)
 			{chg = 1; per = np->minsync;}
-		if (req) {
-			if (per < tp->tinfo.user.period)
-				{chg = 1; per = tp->tinfo.user.period;}
-		}
 	}
 
 	/*
@@ -4147,10 +4176,6 @@
 	}
 	if (!wide || !(np->features & FE_ULTRA3))
 		dt &= ~PPR_OPT_DT;
-	if (req) {
-		if (wide > tp->tinfo.user.width)
-			{chg = 1; wide = tp->tinfo.user.width;}
-	}
 
 	if (!(np->features & FE_U3EN))	/* Broken U3EN bit not supported */
 		dt &= ~PPR_OPT_DT;
@@ -4164,10 +4189,6 @@
 		}
 		else if (ofs > np->maxoffs)
 			{chg = 1; ofs = np->maxoffs;}
-		if (req) {
-			if (ofs > tp->tinfo.user.offset)
-				{chg = 1; ofs = tp->tinfo.user.offset;}
-		}
 	}
 
 	if (ofs) {
@@ -4177,10 +4198,6 @@
 		}
 		else if (per < np->minsync)
 			{chg = 1; per = np->minsync;}
-		if (req) {
-			if (per < tp->tinfo.user.period)
-				{chg = 1; per = tp->tinfo.user.period;}
-		}
 	}
 
 	/*
@@ -4282,7 +4299,6 @@
 static int  
 sym_wide_nego_check(hcb_p np, int req, int target)
 {
-	tcb_p tp = &np->target[target];
 	u_char	chg, wide;
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
@@ -4301,10 +4317,6 @@
 	if (wide > np->maxwide) {
 		chg = 1;
 		wide = np->maxwide;
-	}
-	if (req) {
-		if (wide > tp->tinfo.user.width)
-			{chg = 1; wide = tp->tinfo.user.width;}
 	}
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
===== drivers/scsi/sym53c8xx_2/sym_misc.c 1.4 vs edited =====
--- 1.4/drivers/scsi/sym53c8xx_2/sym_misc.c	2004-03-11 01:06:02 -08:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_misc.c	2004-08-21 09:31:51 -07:00
@@ -216,121 +216,3 @@
 #undef __tprev
 #undef __tcurr
 #endif	/* SYM_OPT_ANNOUNCE_TRANSFER_RATE */
-
-
-#ifdef	SYM_OPT_SNIFF_INQUIRY
-/*
- *  Update transfer settings according to user settings 
- *  and bits sniffed out from INQUIRY response.
- */
-void sym_update_trans_settings(hcb_p np, tcb_p tp)
-{
-	memcpy(&tp->tinfo.goal, &tp->tinfo.user, sizeof(tp->tinfo.goal));
-
-	if (tp->inq_version >= 4) {
-		switch(tp->inq_byte56 & INQ56_CLOCKING) {
-		case INQ56_ST_ONLY:
-			tp->tinfo.goal.options = 0;
-			break;
-		case INQ56_DT_ONLY:
-		case INQ56_ST_DT:
-		default:
-			break;
-		}
-	}
-
-	if (!((tp->inq_byte7 & tp->inq_byte7_valid) & INQ7_WIDE16)) {
-		tp->tinfo.goal.width   = 0;
-		tp->tinfo.goal.options = 0;
-	}
-
-	if (!((tp->inq_byte7 & tp->inq_byte7_valid) & INQ7_SYNC)) {
-		tp->tinfo.goal.offset  = 0;
-		tp->tinfo.goal.options = 0;
-	}
-
-	if (tp->tinfo.goal.options & PPR_OPT_DT) {
-		if (tp->tinfo.goal.offset > np->maxoffs_dt)
-			tp->tinfo.goal.offset = np->maxoffs_dt;
-	}
-	else {
-		if (tp->tinfo.goal.offset > np->maxoffs)
-			tp->tinfo.goal.offset = np->maxoffs;
-	}
-}
-
-/*
- *  Snoop target capabilities from INQUIRY response.
- *  We only believe device versions >= SCSI-2 that use 
- *  appropriate response data format (2). But it seems 
- *  that some CCS devices also support SYNC (?).
- */
-int 
-__sym_sniff_inquiry(hcb_p np, u_char tn, u_char ln,
-                    u_char *inq_data, int inq_len)
-{
-	tcb_p tp = &np->target[tn];
-	u_char inq_version;
-	u_char inq_byte7;
-	u_char inq_byte56;
-
-	if (!inq_data || inq_len < 2)
-		return -1;
-
-	/*
-	 *  Check device type and qualifier.
-	 */
-	if ((inq_data[0] & 0xe0) == 0x60)
-		return -1;
-
-	/*
-	 *  Get SPC version.
-	 */
-	if (inq_len <= 2)
-		return -1;
-	inq_version = inq_data[2] & 0x7;
-
-	/*
-	 *  Get SYNC/WIDE16 capabilities.
-	 */
-	inq_byte7 = tp->inq_byte7;
-	if (inq_version >= 2 && (inq_data[3] & 0xf) == 2) {
-		if (inq_len > 7)
-			inq_byte7 = inq_data[7];
-	}
-	else if (inq_version == 1 && (inq_data[3] & 0xf) == 1)
-		inq_byte7 = INQ7_SYNC;
-
-	/*
-	 *  Get Tagged Command Queuing capability.
-	 */
-	if (inq_byte7 & INQ7_CMDQ)
-		sym_set_bit(tp->cmdq_map, ln);
-	else
-		sym_clr_bit(tp->cmdq_map, ln);
-	inq_byte7 &= ~INQ7_CMDQ;
-
-	/*
-	 *  Get CLOCKING capability.
-	 */
-	inq_byte56 = tp->inq_byte56;
-	if (inq_version >= 4 && inq_len > 56)
-		inq_byte56 = inq_data[56];
-#if 0
-printf("XXXXXX [%d] inq_version=%x inq_byte7=%x inq_byte56=%x XXXXX\n",
-	inq_len, inq_version, inq_byte7, inq_byte56);
-#endif
-	/*
-	 *  Trigger a negotiation if needed.
-	 */
-	if (tp->inq_version != inq_version ||
-	    tp->inq_byte7   != inq_byte7   ||
-	    tp->inq_byte56  != inq_byte56) {
-		tp->inq_version = inq_version;
-		tp->inq_byte7   = inq_byte7;
-		tp->inq_byte56  = inq_byte56;
-		return 1;
-	}
-	return 0;
-}
-#endif	/* SYM_OPT_SNIFF_INQUIRY */
===== drivers/scsi/sym53c8xx_2/sym_hipd.h 1.7 vs edited =====
--- 1.7/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-08-14 07:08:22 -07:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_hipd.h	2004-08-21 11:14:46 -07:00
@@ -69,11 +69,6 @@
  *        When this option is set, the driver will use a queue per 
  *        device and handle QUEUE FULL status requeuing internally.
  *
- *    SYM_OPT_SNIFF_INQUIRY
- *        When this option is set, the driver sniff out successful 
- *        INQUIRY response and performs negotiations accordingly.
- *        (set for Linux)
- *
  *    SYM_OPT_LIMIT_COMMAND_REORDERING
  *        When this option is set, the driver tries to limit tagged 
  *        command reordering to some reasonnable value.
@@ -82,7 +77,6 @@
 #if 0
 #define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
-#define SYM_OPT_SNIFF_INQUIRY
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #endif
 
@@ -364,7 +358,6 @@
 struct sym_tinfo {
 	struct sym_trans curr;
 	struct sym_trans goal;
-	struct sym_trans user;
 #ifdef	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 	struct sym_trans prev;
 #endif
@@ -465,18 +458,7 @@
 	 */
 	u_char	usrflags;
 	u_short	usrtags;
-
-#ifdef	SYM_OPT_SNIFF_INQUIRY
-	/*
-	 *  Some minimal information from INQUIRY response.
-	 */
-	u32	cmdq_map[(SYM_CONF_MAX_LUN+31)/32];
-	u_char	inq_version;
-	u_char	inq_byte7;
-	u_char	inq_byte56;
-	u_char	inq_byte7_valid;
-#endif
-
+	struct scsi_device *sdev;
 };
 
 /*
@@ -1162,26 +1144,6 @@
 #ifdef	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 void sym_announce_transfer_rate(hcb_p np, int target);
 #endif
-
-/*
- *  Optionnaly, the driver may sniff inquiry data.
- */
-#ifdef	SYM_OPT_SNIFF_INQUIRY
-#define	INQ7_CMDQ	(0x02)
-#define	INQ7_SYNC	(0x10)
-#define	INQ7_WIDE16	(0x20)
-
-#define INQ56_CLOCKING	(3<<2)
-#define INQ56_ST_ONLY	(0<<2)
-#define INQ56_DT_ONLY	(1<<2)
-#define INQ56_ST_DT	(3<<2)
-
-void sym_update_trans_settings(hcb_p np, tcb_p tp);
-int  
-__sym_sniff_inquiry(hcb_p np, u_char tn, u_char ln,
-                    u_char *inq_data, int inq_len);
-#endif
-
 
 /*
  *  Build a scatter/gather entry.
===== drivers/scsi/sym53c8xx_2/sym_nvram.c 1.5 vs edited =====
--- 1.5/drivers/scsi/sym53c8xx_2/sym_nvram.c	2004-07-26 14:24:36 -07:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_nvram.c	2004-08-21 09:31:52 -07:00
@@ -53,11 +53,6 @@
 #include "sym_glue.h"
 #include "sym_nvram.h"
 
-/*
- *  Some poor and bogus sync table that refers to Tekram NVRAM layout.
- */
-static u_char Tekram_sync[16] =
-	{25,31,37,43, 50,62,75,125, 12,15,18,21, 6,7,9,10};
 #ifdef	SYM_CONF_DEBUG_NVRAM
 static u_char Tekram_boot_delay[7] = {3, 5, 10, 20, 30, 60, 120};
 #endif
@@ -100,8 +95,6 @@
 	struct sym_tcb *tp = &np->target[target];
 	Symbios_target *tn = &nvram->target[target];
 
-	tp->tinfo.user.period = tn->sync_period ? (tn->sync_period + 3) / 4 : 0;
-	tp->tinfo.user.width  = tn->bus_width == 0x10 ? BUS_16_BIT : BUS_8_BIT;
 	tp->usrtags =
 		(tn->flags & SYMBIOS_QUEUE_TAGS_ENABLED)? SYM_SETUP_MAX_TAG : 0;
 
@@ -121,15 +114,6 @@
 {
 	struct sym_tcb *tp = &np->target[target];
 	struct Tekram_target *tn = &nvram->target[target];
-	int i;
-
-	if (tn->flags & TEKRAM_SYNC_NEGO) {
-		i = tn->sync_index & 0xf;
-		tp->tinfo.user.period = Tekram_sync[i];
-	}
-
-	tp->tinfo.user.width = (tn->flags & TEKRAM_WIDE_NEGO) ?
-		BUS_16_BIT : BUS_8_BIT;
 
 	if (tn->flags & TEKRAM_TAGGED_COMMANDS) {
 		tp->usrtags = 2 << nvram->max_tags_index;
===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.46 vs edited =====
--- 1.46/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-21 09:27:03 -07:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-08-21 09:31:49 -07:00
@@ -143,13 +143,6 @@
 }
 
 /*
- *  Driver host data structure.
- */
-struct host_data {
-	struct sym_hcb *ncb;
-};
-
-/*
  *  Used by the eh thread to wait for command completion.
  *  It is allocated on the eh thread stack.
  */
@@ -220,47 +213,12 @@
 	return use_sg;
 }
 
-static void __sync_scsi_data_for_cpu(struct pci_dev *pdev, struct scsi_cmnd *cmd)
-{
-	int dma_dir = cmd->sc_data_direction;
-
-	switch(SYM_UCMD_PTR(cmd)->data_mapped) {
-	case 2:
-		pci_dma_sync_sg_for_cpu(pdev, cmd->buffer, cmd->use_sg, dma_dir);
-		break;
-	case 1:
-		pci_dma_sync_single_for_cpu(pdev, SYM_UCMD_PTR(cmd)->data_mapping,
-					    cmd->request_bufflen, dma_dir);
-		break;
-	}
-}
-
-static void __sync_scsi_data_for_device(struct pci_dev *pdev, struct scsi_cmnd *cmd)
-{
-	int dma_dir = cmd->sc_data_direction;
-
-	switch(SYM_UCMD_PTR(cmd)->data_mapped) {
-	case 2:
-		pci_dma_sync_sg_for_device(pdev, cmd->buffer, cmd->use_sg, dma_dir);
-		break;
-	case 1:
-		pci_dma_sync_single_for_device(pdev, SYM_UCMD_PTR(cmd)->data_mapping,
-					       cmd->request_bufflen, dma_dir);
-		break;
-	}
-}
-
 #define unmap_scsi_data(np, cmd)	\
 		__unmap_scsi_data(np->s.device, cmd)
 #define map_scsi_single_data(np, cmd)	\
 		__map_scsi_single_data(np->s.device, cmd)
 #define map_scsi_sg_data(np, cmd)	\
 		__map_scsi_sg_data(np->s.device, cmd)
-#define sync_scsi_data_for_cpu(np, cmd)		\
-		__sync_scsi_data_for_cpu(np->s.device, cmd)
-#define sync_scsi_data_for_device(np, cmd)		\
-		__sync_scsi_data_for_device(np->s.device, cmd)
-
 /*
  *  Complete a pending CAM CCB.
  */
@@ -417,27 +375,6 @@
 

 /*
- *  Called on successfull INQUIRY response.
- */
-void sym_sniff_inquiry(struct sym_hcb *np, struct scsi_cmnd *cmd, int resid)
-{
-	int retv;
-
-	if (!cmd || cmd->use_sg)
-		return;
-
-	sync_scsi_data_for_cpu(np, cmd);
-	retv = __sym_sniff_inquiry(np, cmd->device->id, cmd->device->lun,
-				   (u_char *) cmd->request_buffer,
-				   cmd->request_bufflen - resid);
-	sync_scsi_data_for_device(np, cmd);
-	if (retv < 0)
-		return;
-	else if (retv)
-		sym_update_trans_settings(np, &np->target[cmd->device->id]);
-}
-
-/*
  *  Build the scatter/gather array for an I/O.
  */
 
@@ -1118,12 +1055,7 @@
 
 	np = ((struct host_data *) host->hostdata)->ncb;
 	tp = &np->target[device->id];
-
-	/*
-	 *  Get user settings for transfer parameters.
-	 */
-	tp->inq_byte7_valid = (INQ7_SYNC|INQ7_WIDE16);
-	sym_update_trans_settings(np, tp);
+	tp->sdev = device;
 
 	/*
 	 *  Allocate the LCB if not yet.
@@ -2384,16 +2316,6 @@
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
-	if (offset == 0)
-		tp->tinfo.goal.options = 0;
-
-	if (tp->tinfo.curr.options & PPR_OPT_DT) {
-		if (offset > np->maxoffs_dt)
-			offset = np->maxoffs_dt;
-	} else {
-		if (offset > np->maxoffs)
-			offset = np->maxoffs;
-	}
 	tp->tinfo.goal.offset = offset;
 }
 
@@ -2411,23 +2333,11 @@
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
-	if (period <= 9 && np->minsync_dt) {
-		if (period < np->minsync_dt)
-			period = np->minsync_dt;
-		tp->tinfo.goal.options = PPR_OPT_DT;
-		tp->tinfo.goal.period = period;
-		if (!tp->tinfo.curr.offset ||
-					tp->tinfo.curr.offset > np->maxoffs_dt)
-			tp->tinfo.goal.offset = np->maxoffs_dt;
-	} else {
-		if (period < np->minsync)
-			period = np->minsync;
-		tp->tinfo.goal.options = 0;
-		tp->tinfo.goal.period = period;
-		if (!tp->tinfo.curr.offset ||
-					tp->tinfo.curr.offset > np->maxoffs)
-			tp->tinfo.goal.offset = np->maxoffs;
-	}
+	/* have to have DT for these transfers */
+	if (period <= np->minsync)
+		tp->tinfo.goal.options |= PPR_OPT_DT;
+
+	tp->tinfo.goal.period = period;
 }
 
 static void sym2_get_width(struct scsi_device *sdev)
@@ -2443,6 +2353,10 @@
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
+	/* It is illegal to have DT set on narrow transfers */
+	if (width == 0)
+		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+
 	tp->tinfo.goal.width = width;
 }
 
@@ -2459,17 +2373,10 @@
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
-	if (!dt) {
-		/* if clearing DT, then we may need to reduce the
-		 * period and the offset */
-		if (tp->tinfo.curr.period < np->minsync)
-			tp->tinfo.goal.period = np->minsync;
-		if (tp->tinfo.curr.offset > np->maxoffs)
-			tp->tinfo.goal.offset = np->maxoffs;
-		tp->tinfo.goal.options &= ~PPR_OPT_DT;
-	} else {
+	if (dt)
 		tp->tinfo.goal.options |= PPR_OPT_DT;
-	}
+	else
+		tp->tinfo.goal.options &= ~PPR_OPT_DT;
 }
 	
 
===== drivers/scsi/sym53c8xx_2/sym_glue.h 1.20 vs edited =====
--- 1.20/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-08-14 07:08:20 -07:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.h	2004-08-21 09:31:49 -07:00
@@ -89,7 +89,6 @@
 
 #define SYM_OPT_HANDLE_DIR_UNKNOWN
 #define SYM_OPT_HANDLE_DEVICE_QUEUEING
-#define SYM_OPT_SNIFF_INQUIRY
 #define SYM_OPT_LIMIT_COMMAND_REORDERING
 #define	SYM_OPT_ANNOUNCE_TRANSFER_RATE
 
@@ -436,6 +435,13 @@
 	struct sym_nvram *nvram;
 	u_short device_id;
 	u_char host_id;
+};
+
+/*
+ *  Driver host data structure.
+ */
+struct host_data {
+	struct sym_hcb *ncb;
 };
 
 /*

