From: Matthew Wilcox <willy@debian.org>
Subject: IU and QAS support for sym2
Date: Mon, 20 Sep 2004 15:32:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040920143255.GQ642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:21447 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266615AbUITOc4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 10:32:56 -0400
Received: from willy by www.linux.org.uk with local (Exim 4.33)
	id 1C9PDr-0002ah-TC
	for linux-scsi@vger.kernel.org; Mon, 20 Sep 2004 15:32:55 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The 53c1010 chip supports QAS and IU (with some additional restrictions
over those found in spi5).  This patch adds support for those features,
but the Seagate ST373453LC I have to test with claims to not support them.
Oh well.

Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.61
retrieving revision 1.62
diff -u -p -r1.61 -r1.62
--- drivers/scsi/sym53c8xx_2/sym_glue.c	17 Sep 2004 17:54:29 -0000	1.61
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	20 Sep 2004 02:32:26 -0000	1.62
@@ -1109,7 +1109,7 @@ static void sym_exec_user_command (struc
 				if (uc->data <= 9 && np->minsync_dt) {
 					if (uc->data < np->minsync_dt)
 						uc->data = np->minsync_dt;
-					tp->tinfo.goal.options = PPR_OPT_DT;
+					tp->tinfo.goal.options = PPR_OPT_MASK;
 					tp->tinfo.goal.width   = 1;
 					tp->tinfo.goal.period = uc->data;
 					tp->tinfo.goal.offset = np->maxoffs_dt;
@@ -2292,9 +2292,10 @@ static void sym2_set_width(struct scsi_d
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
-	/* It is illegal to have DT set on narrow transfers */
+	/* It is illegal to have DT set on narrow transfers.  If DT is
+	 * clear, we must also clear IU and QAS.  */
 	if (width == 0)
-		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+		tp->tinfo.goal.options &= ~PPR_OPT_MASK;
 
 	tp->tinfo.goal.width = width;
 }
@@ -2312,12 +2313,51 @@ static void sym2_set_dt(struct scsi_devi
 	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
 	struct sym_tcb *tp = &np->target[sdev->id];
 
+	/* We must clear QAS and IU if DT is clear */
 	if (dt)
 		tp->tinfo.goal.options |= PPR_OPT_DT;
 	else
-		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+		tp->tinfo.goal.options &= ~PPR_OPT_MASK;
 }
-	
+
+static void sym2_get_iu(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_iu(sdev) = (tp->tinfo.curr.options & PPR_OPT_IU) ? 1 : 0;
+}
+
+static void sym2_set_iu(struct scsi_device *sdev, int iu)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if (iu)
+		tp->tinfo.goal.options |= PPR_OPT_IU | PPR_OPT_DT;
+	else
+		tp->tinfo.goal.options &= ~PPR_OPT_IU;
+}
+
+static void sym2_get_qas(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_qas(sdev) = (tp->tinfo.curr.options & PPR_OPT_QAS) ? 1 : 0;
+}
+
+static void sym2_set_qas(struct scsi_device *sdev, int qas)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if (qas)
+		tp->tinfo.goal.options |= PPR_OPT_QAS | PPR_OPT_DT;
+	else
+		tp->tinfo.goal.options &= ~PPR_OPT_QAS;
+}
+
 
 static struct spi_function_template sym2_transport_functions = {
 	.set_offset	= sym2_set_offset,
@@ -2332,6 +2372,12 @@ static struct spi_function_template sym2
 	.get_dt		= sym2_get_dt,
 	.set_dt		= sym2_set_dt,
 	.show_dt	= 1,
+	.get_iu		= sym2_get_iu,
+	.set_iu		= sym2_set_iu,
+	.show_iu	= 1,
+	.get_qas	= sym2_get_qas,
+	.set_qas	= sym2_set_qas,
+	.show_qas	= 1,
 };
 
 static struct pci_device_id sym2_id_table[] __devinitdata = {
Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.32
retrieving revision 1.33
diff -u -p -r1.32 -r1.33
--- drivers/scsi/sym53c8xx_2/sym_hipd.c	13 Sep 2004 15:23:29 -0000	1.32
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	20 Sep 2004 02:32:26 -0000	1.33
@@ -1503,6 +1503,7 @@ static void sym_check_goals(struct scsi_
 		if (st->period > np->maxsync_dt)
 			st->period = np->maxsync_dt;
 	} else {
+		st->options &= ~PPR_OPT_MASK;
 		if (st->offset > np->maxoffs)
 			st->offset = np->maxoffs;
 		if (st->period < np->minsync)
@@ -1575,7 +1576,7 @@ static int sym_prepare_nego(hcb_p np, cc
 		msgptr[msglen++] = 0;
 		msgptr[msglen++] = tp->tinfo.goal.offset;
 		msgptr[msglen++] = tp->tinfo.goal.width;
-		msgptr[msglen++] = tp->tinfo.goal.options & PPR_OPT_DT;
+		msgptr[msglen++] = tp->tinfo.goal.options & PPR_OPT_MASK;
 		break;
 	};
 
@@ -2009,7 +2010,7 @@ void sym_start_up (hcb_p np, int reason)
 /*
  *  Switch trans mode for current job and it's target.
  */
-static void sym_settrans(hcb_p np, int target, u_char dt, u_char ofs,
+static void sym_settrans(hcb_p np, int target, u_char opts, u_char ofs,
 			 u_char per, u_char wide, u_char div, u_char fak)
 {
 	SYM_QUEHEAD *qp;
@@ -2060,7 +2061,7 @@ static void sym_settrans(hcb_p np, int t
 	 */
 	if (np->features & FE_C10) {
 		uval = uval & ~(U3EN|AIPCKEN);
-		if (dt)	{
+		if (opts)	{
 			assert(np->features & FE_U3EN);
 			uval |= U3EN;
 		}
@@ -2163,17 +2164,17 @@ sym_setsync(hcb_p np, int target,
  *  Let everything be aware of the changes.
  */
 static void 
-sym_setpprot(hcb_p np, int target, u_char dt, u_char ofs,
+sym_setpprot(hcb_p np, int target, u_char opts, u_char ofs,
              u_char per, u_char wide, u_char div, u_char fak)
 {
 	tcb_p tp = &np->target[target];
 
-	sym_settrans(np, target, dt, ofs, per, wide, div, fak);
+	sym_settrans(np, target, opts, ofs, per, wide, div, fak);
 
 	tp->tinfo.goal.width	= tp->tinfo.curr.width  = wide;
 	tp->tinfo.goal.period	= tp->tinfo.curr.period = per;
 	tp->tinfo.goal.offset	= tp->tinfo.curr.offset = ofs;
-	tp->tinfo.goal.options	= tp->tinfo.curr.options = dt;
+	tp->tinfo.goal.options	= tp->tinfo.curr.options = opts;
 
 	sym_xpt_async_nego_ppr(np, target);
 }
@@ -4139,20 +4140,17 @@ static int 
 sym_ppr_nego_check(hcb_p np, int req, int target)
 {
 	tcb_p tp = &np->target[target];
-	u_char	chg, ofs, per, fak, dt, div, wide;
+	unsigned char fak, div;
+	int dt, chg = 0;
+
+	unsigned char per = np->msgin[3];
+	unsigned char ofs = np->msgin[5];
+	unsigned char wide = np->msgin[6];
+	unsigned char opts = np->msgin[7] & PPR_OPT_MASK;
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
 		sym_print_nego_msg(np, target, "ppr msgin", np->msgin);
-	};
-
-	/*
-	 *  Get requested values.
-	 */
-	chg  = 0;
-	per  = np->msgin[3];
-	ofs  = np->msgin[5];
-	wide = np->msgin[6];
-	dt   = np->msgin[7] & PPR_OPT_DT;
+	}
 
 	/*
 	 *  Check values against our limits.
@@ -4162,29 +4160,30 @@ sym_ppr_nego_check(hcb_p np, int req, in
 		wide = np->maxwide;
 	}
 	if (!wide || !(np->features & FE_ULTRA3))
-		dt &= ~PPR_OPT_DT;
+		opts = 0;
 
 	if (!(np->features & FE_U3EN))	/* Broken U3EN bit not supported */
-		dt &= ~PPR_OPT_DT;
+		opts = 0;
+
+	if (opts != (np->msgin[7] & PPR_OPT_MASK))
+		chg = 1;
 
-	if (dt != (np->msgin[7] & PPR_OPT_MASK)) chg = 1;
+	dt = opts & PPR_OPT_DT;
 
 	if (ofs) {
-		if (dt) {
-			if (ofs > np->maxoffs_dt)
-				{chg = 1; ofs = np->maxoffs_dt;}
+		unsigned char maxoffs = dt ? np->maxoffs_dt : np->maxoffs;
+		if (ofs > maxoffs) {
+			chg = 1;
+			ofs = maxoffs;
 		}
-		else if (ofs > np->maxoffs)
-			{chg = 1; ofs = np->maxoffs;}
 	}
 
 	if (ofs) {
-		if (dt) {
-			if (per < np->minsync_dt)
-				{chg = 1; per = np->minsync_dt;}
+		unsigned char minsync = dt ? np->minsync_dt : np->minsync;
+		if (per < np->minsync_dt) {
+			chg = 1;
+			per = minsync;
 		}
-		else if (per < np->minsync)
-			{chg = 1; per = np->minsync;}
 	}
 
 	/*
@@ -4204,7 +4203,7 @@ sym_ppr_nego_check(hcb_p np, int req, in
 	/*
 	 *  Apply new values.
 	 */
-	sym_setpprot (np, target, dt, ofs, per, wide, div, fak);
+	sym_setpprot(np, target, opts, ofs, per, wide, div, fak);
 
 	/*
 	 *  It was an answer. We are done.
@@ -4222,7 +4221,7 @@ sym_ppr_nego_check(hcb_p np, int req, in
 	np->msgout[4] = 0;
 	np->msgout[5] = ofs;
 	np->msgout[6] = wide;
-	np->msgout[7] = dt;
+	np->msgout[7] = opts;
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
 		sym_print_nego_msg(np, target, "ppr msgout", np->msgout);
@@ -4238,7 +4237,7 @@ reject_it:
 	 *  If it is a device response that should result in  
 	 *  ST, we may want to try a legacy negotiation later.
 	 */
-	if (!req && !dt) {
+	if (!req && !opts) {
 		tp->tinfo.goal.options = 0;
 		tp->tinfo.goal.width   = wide;
 		tp->tinfo.goal.period  = per;
Index: drivers/scsi/sym53c8xx_2/sym_misc.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_misc.c,v
retrieving revision 1.7
retrieving revision 1.8
diff -u -p -r1.7 -r1.8
--- drivers/scsi/sym53c8xx_2/sym_misc.c	13 Sep 2004 15:23:29 -0000	1.7
+++ drivers/scsi/sym53c8xx_2/sym_misc.c	20 Sep 2004 02:32:26 -0000	1.8
@@ -190,10 +190,12 @@ void sym_announce_transfer_rate(hcb_p np
 			mb10 = (f10 + period/2) / period;
 		}
 		printf_info (
-		    "%s:%d: %s %sSCSI %d.%d MB/s %s (%d.%d ns, offset %d)\n",
+		    "%s:%d: %s %sSCSI %d.%d MB/s %s%s%s (%d.%d ns, offset %d)\n",
 		    sym_name(np), target, scsi, __tcurr.width? "WIDE " : "",
 		    mb10/10, mb10%10,
 		    (__tcurr.options & PPR_OPT_DT) ? "DT" : "ST",
+		    (__tcurr.options & PPR_OPT_IU) ? " IU" : "",
+		    (__tcurr.options & PPR_OPT_QAS) ? " QAS" : "",
 		    period/10, period%10, __tcurr.offset);
 	}
 	else

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
