From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Add spi_populate_*_msg functions
Date: Tue, 7 Feb 2006 07:54:46 -0700
Message-ID: <20060207145446.GA1601@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:36017 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S965105AbWBGOyr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 09:54:47 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Introduce new helpers:
 - spi_populate_width_msg()
 - spi_populate_sync_msg()
 - spi_populate_ppr_msg()

and use them in drivers which already enable the SPI transport.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

 drivers/scsi/53c700.c               |   18 ++----------
 drivers/scsi/aha152x.c              |    7 ----
 drivers/scsi/aic7xxx/aic79xx_core.c |   24 ++++------------
 drivers/scsi/aic7xxx/aic7xxx_core.c |   24 ++++------------
 drivers/scsi/ncr53c8xx.c            |   25 +++-------------
 drivers/scsi/scsi_transport_spi.c   |   33 ++++++++++++++++++++++
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   53 ++++++++----------------------------
 include/scsi/scsi_transport_spi.h   |    4 ++
 9 files changed, 74 insertions(+), 121 deletions(-)

Index: ./drivers/scsi/53c700.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/53c700.c,v
retrieving revision 1.21
diff -u -p -r1.21 53c700.c
--- ./drivers/scsi/53c700.c	17 Jan 2006 14:51:47 -0000	1.21
+++ ./drivers/scsi/53c700.c	17 Jan 2006 15:07:38 -0000
@@ -238,14 +238,6 @@ static char *NCR_700_SBCL_to_phase[] = {
 	"MSG IN",
 };
 
-static __u8 NCR_700_SDTR_msg[] = {
-	0x01,			/* Extended message */
-	0x03,			/* Extended message Length */
-	0x01,			/* SDTR Extended message */
-	NCR_700_MIN_PERIOD,
-	NCR_700_MAX_OFFSET
-};
-
 /* This translates the SDTR message offset and period to a value
  * which can be loaded into the SXFER_REG.
  *
@@ -266,7 +258,7 @@ NCR_700_offset_period_to_sxfer(struct NC
 		return 0;
 
 	if(period < hostdata->min_period) {
-		printk(KERN_WARNING "53c700: Period %dns is less than this chip's minimum, setting to %d\n", period*4, NCR_700_SDTR_msg[3]*4);
+		printk(KERN_WARNING "53c700: Period %dns is less than this chip's minimum, setting to %d\n", period*4, NCR_700_MIN_PERIOD*4);
 		period = hostdata->min_period;
 	}
 	XFERP = (period*4 * hostdata->sync_clock)/1000 - 4;
@@ -1435,11 +1427,9 @@ NCR_700_start_command(struct scsi_cmnd *
 
 	if(hostdata->fast &&
 	   NCR_700_is_flag_clear(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC)) {
-		memcpy(&hostdata->msgout[count], NCR_700_SDTR_msg,
-		       sizeof(NCR_700_SDTR_msg));
-		hostdata->msgout[count+3] = spi_period(SCp->device->sdev_target);
-		hostdata->msgout[count+4] = spi_offset(SCp->device->sdev_target);
-		count += sizeof(NCR_700_SDTR_msg);
+		count += spi_populate_sync_msg(&hostdata->msgout[count],
+				spi_period(SCp->device->sdev_target),
+				spi_offset(SCp->device->sdev_target));
 		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_SYNC_NEGOTIATION);
 	}
 
Index: ./drivers/scsi/aha152x.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aha152x.c,v
retrieving revision 1.18
diff -u -p -r1.18 aha152x.c
--- ./drivers/scsi/aha152x.c	17 Jan 2006 14:51:48 -0000	1.18
+++ ./drivers/scsi/aha152x.c	17 Jan 2006 15:07:39 -0000
@@ -1708,12 +1708,7 @@ static void seldo_run(struct Scsi_Host *
 		ADDMSGO(BUS_DEVICE_RESET);
 	} else if (SYNCNEG==0 && SYNCHRONOUS) {
     		CURRENT_SC->SCp.phase |= syncneg;
-		ADDMSGO(EXTENDED_MESSAGE);
-		ADDMSGO(3);
-		ADDMSGO(EXTENDED_SDTR);
-		ADDMSGO(50);		/* 200ns */
-		ADDMSGO(8);		/* 8 byte req/ack offset */
-
+		MSGOLEN += spi_populate_sync_msg(&MSGO(MSGOLEN), 50, 8);
 		SYNCNEG=1;		/* negotiation in progress */
 	}
 
Index: ./drivers/scsi/ncr53c8xx.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/ncr53c8xx.c,v
retrieving revision 1.38
diff -u -p -r1.38 ncr53c8xx.c
--- ./drivers/scsi/ncr53c8xx.c	17 Jan 2006 14:51:48 -0000	1.38
+++ ./drivers/scsi/ncr53c8xx.c	17 Jan 2006 15:07:41 -0000
@@ -4105,17 +4105,11 @@ static int ncr_prepare_nego(struct ncb *
 
 	switch (nego) {
 	case NS_SYNC:
-		msgptr[msglen++] = EXTENDED_MESSAGE;
-		msgptr[msglen++] = 3;
-		msgptr[msglen++] = EXTENDED_SDTR;
-		msgptr[msglen++] = tp->maxoffs ? tp->minsync : 0;
-		msgptr[msglen++] = tp->maxoffs;
+		msglen += spi_populate_sync_msg(msgptr + msglen,
+				tp->maxoffs ? tp->minsync : 0, tp->maxoffs);
 		break;
 	case NS_WIDE:
-		msgptr[msglen++] = EXTENDED_MESSAGE;
-		msgptr[msglen++] = 2;
-		msgptr[msglen++] = EXTENDED_WDTR;
-		msgptr[msglen++] = tp->usrwide;
+		msglen += spi_populate_width_msg(msgptr + msglen, tp->usrwide);
 		break;
 	}
 
@@ -6989,12 +6983,7 @@ void ncr_int_sir (struct ncb *np)
 		spi_offset(starget) = ofs;
 		ncr_setsync(np, cp, scntl3, (fak<<5)|ofs);
 
-		np->msgout[0] = EXTENDED_MESSAGE;
-		np->msgout[1] = 3;
-		np->msgout[2] = EXTENDED_SDTR;
-		np->msgout[3] = per;
-		np->msgout[4] = ofs;
-
+		spi_populate_sync_msg(np->msgout, per, ofs);
 		cp->nego_status = NS_SYNC;
 
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
@@ -7080,11 +7069,7 @@ void ncr_int_sir (struct ncb *np)
 
 		spi_width(starget) = wide;
 		ncr_setwide(np, cp, wide, 1);
-
-		np->msgout[0] = EXTENDED_MESSAGE;
-		np->msgout[1] = 2;
-		np->msgout[2] = EXTENDED_WDTR;
-		np->msgout[3] = wide;
+		spi_populate_width_msg(np->msgout, wide);
 
 		np->msgin [0] = NOP;
 
Index: ./drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.24
diff -u -p -r1.24 scsi_transport_spi.c
--- ./drivers/scsi/scsi_transport_spi.c	17 Jan 2006 14:51:49 -0000	1.24
+++ ./drivers/scsi/scsi_transport_spi.c	7 Feb 2006 13:11:26 -0000
@@ -1054,6 +1053,39 @@ void spi_display_xfer_agreement(struct s
 }
 EXPORT_SYMBOL(spi_display_xfer_agreement);
 
+int spi_populate_width_msg(unsigned char *msg, int width)
+{
+	msg[0] = EXTENDED_MESSAGE;
+	msg[1] = 2;
+	msg[2] = EXTENDED_WDTR;
+	msg[3] = width;
+	return 4;
+}
+
+int spi_populate_sync_msg(unsigned char *msg, int period, int offset)
+{
+	msg[0] = EXTENDED_MESSAGE;
+	msg[1] = 3;
+	msg[2] = EXTENDED_SDTR;
+	msg[3] = period;
+	msg[4] = offset;
+	return 5;
+}
+
+int spi_populate_ppr_msg(unsigned char *msg, int period, int offset,
+		int width, int options)
+{
+	msg[0] = EXTENDED_MESSAGE;
+	msg[1] = 6;
+	msg[2] = EXTENDED_PPR;
+	msg[3] = period;
+	msg[4] = 0;
+	msg[5] = offset;
+	msg[6] = width;
+	msg[7] = options;
+	return 8;
+}
+
 #ifdef CONFIG_SCSI_CONSTANTS
 static const char * const one_byte_msgs[] = {
 /* 0x00 */ "Command Complete", NULL, "Save Pointers",
Index: ./drivers/scsi/aic7xxx/aic79xx_core.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aic7xxx/aic79xx_core.c,v
retrieving revision 1.7
diff -u -p -r1.7 aic79xx_core.c
--- ./drivers/scsi/aic7xxx/aic79xx_core.c	4 Feb 2006 04:51:59 -0000	1.7
+++ ./drivers/scsi/aic7xxx/aic79xx_core.c	6 Feb 2006 00:28:38 -0000
@@ -3762,11 +3762,8 @@ ahd_construct_sdtr(struct ahd_softc *ahd
 {
 	if (offset == 0)
 		period = AHD_ASYNC_XFER_PERIOD;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXTENDED;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXT_SDTR_LEN;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXT_SDTR;
-	ahd->msgout_buf[ahd->msgout_index++] = period;
-	ahd->msgout_buf[ahd->msgout_index++] = offset;
+	ahd->msgout_index += spi_populate_sync_msg(
+			ahd->msgout_buf + ahd->msgout_index, period, offset);
 	ahd->msgout_len += 5;
 	if (bootverbose) {
 		printf("(%s:%c:%d:%d): Sending SDTR period %x, offset %x\n",
@@ -3783,10 +3780,8 @@ static void
 ahd_construct_wdtr(struct ahd_softc *ahd, struct ahd_devinfo *devinfo,
 		   u_int bus_width)
 {
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXTENDED;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXT_WDTR_LEN;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXT_WDTR;
-	ahd->msgout_buf[ahd->msgout_index++] = bus_width;
+	ahd->msgout_index += spi_populate_width_msg(
+			ahd->msgout_buf + ahd->msgout_index, bus_width);
 	ahd->msgout_len += 4;
 	if (bootverbose) {
 		printf("(%s:%c:%d:%d): Sending WDTR %x\n",
@@ -3813,14 +3808,9 @@ ahd_construct_ppr(struct ahd_softc *ahd,
 		ppr_options |= MSG_EXT_PPR_PCOMP_EN;
 	if (offset == 0)
 		period = AHD_ASYNC_XFER_PERIOD;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXTENDED;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXT_PPR_LEN;
-	ahd->msgout_buf[ahd->msgout_index++] = MSG_EXT_PPR;
-	ahd->msgout_buf[ahd->msgout_index++] = period;
-	ahd->msgout_buf[ahd->msgout_index++] = 0;
-	ahd->msgout_buf[ahd->msgout_index++] = offset;
-	ahd->msgout_buf[ahd->msgout_index++] = bus_width;
-	ahd->msgout_buf[ahd->msgout_index++] = ppr_options;
+	ahd->msgout_index += spi_populate_ppr_msg(
+			ahd->msgout_buf + ahd->msgout_index, period, offset,
+			bus_width, ppr_options);
 	ahd->msgout_len += 8;
 	if (bootverbose) {
 		printf("(%s:%c:%d:%d): Sending PPR bus_width %x, period %x, "
Index: ./drivers/scsi/aic7xxx/aic7xxx_core.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c,v
retrieving revision 1.6
diff -u -p -r1.6 aic7xxx_core.c
--- ./drivers/scsi/aic7xxx/aic7xxx_core.c	14 Sep 2005 12:56:41 -0000	1.6
+++ ./drivers/scsi/aic7xxx/aic7xxx_core.c	17 Jan 2006 17:31:01 -0000
@@ -2461,11 +2461,8 @@ ahc_construct_sdtr(struct ahc_softc *ahc
 {
 	if (offset == 0)
 		period = AHC_ASYNC_XFER_PERIOD;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXTENDED;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXT_SDTR_LEN;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXT_SDTR;
-	ahc->msgout_buf[ahc->msgout_index++] = period;
-	ahc->msgout_buf[ahc->msgout_index++] = offset;
+	ahc->msgout_index += spi_populate_sync_msg(
+			ahc->msgout_buf + ahc->msgout_index, period, offset);
 	ahc->msgout_len += 5;
 	if (bootverbose) {
 		printf("(%s:%c:%d:%d): Sending SDTR period %x, offset %x\n",
@@ -2482,10 +2479,8 @@ static void
 ahc_construct_wdtr(struct ahc_softc *ahc, struct ahc_devinfo *devinfo,
 		   u_int bus_width)
 {
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXTENDED;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXT_WDTR_LEN;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXT_WDTR;
-	ahc->msgout_buf[ahc->msgout_index++] = bus_width;
+	ahc->msgout_index += spi_populate_width_msg(
+			ahc->msgout_buf + ahc->msgout_index, bus_width);
 	ahc->msgout_len += 4;
 	if (bootverbose) {
 		printf("(%s:%c:%d:%d): Sending WDTR %x\n",
@@ -2505,14 +2500,9 @@ ahc_construct_ppr(struct ahc_softc *ahc,
 {
 	if (offset == 0)
 		period = AHC_ASYNC_XFER_PERIOD;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXTENDED;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXT_PPR_LEN;
-	ahc->msgout_buf[ahc->msgout_index++] = MSG_EXT_PPR;
-	ahc->msgout_buf[ahc->msgout_index++] = period;
-	ahc->msgout_buf[ahc->msgout_index++] = 0;
-	ahc->msgout_buf[ahc->msgout_index++] = offset;
-	ahc->msgout_buf[ahc->msgout_index++] = bus_width;
-	ahc->msgout_buf[ahc->msgout_index++] = ppr_options;
+	ahc->msgout_index += spi_populate_ppr_msg(
+			ahc->msgout_buf + ahc->msgout_index, period, offset,
+			bus_width, ppr_options);
 	ahc->msgout_len += 8;
 	if (bootverbose) {
 		printf("(%s:%c:%d:%d): Sending PPR bus_width %x, period %x, "
Index: ./drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.78
diff -u -p -r1.78 sym_hipd.c
--- ./drivers/scsi/sym53c8xx_2/sym_hipd.c	17 Jan 2006 18:39:07 -0000	1.78
+++ ./drivers/scsi/sym53c8xx_2/sym_hipd.c	6 Feb 2006 00:28:40 -0000
@@ -40,7 +40,6 @@
 
 #include <linux/slab.h>
 #include <asm/param.h>		/* for timeouts in units of HZ */
-#include <scsi/scsi_dbg.h>
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -1435,29 +1434,18 @@ static int sym_prepare_nego(struct sym_h
 
 	switch (nego) {
 	case NS_SYNC:
-		msgptr[msglen++] = M_EXTENDED;
-		msgptr[msglen++] = 3;
-		msgptr[msglen++] = M_X_SYNC_REQ;
-		msgptr[msglen++] = goal->period;
-		msgptr[msglen++] = goal->offset;
+		msglen += spi_populate_sync_msg(msgptr + msglen, goal->period,
+				goal->offset);
 		break;
 	case NS_WIDE:
-		msgptr[msglen++] = M_EXTENDED;
-		msgptr[msglen++] = 2;
-		msgptr[msglen++] = M_X_WIDE_REQ;
-		msgptr[msglen++] = goal->width;
+		msglen += spi_populate_width_msg(msgptr + msglen, goal->width);
 		break;
 	case NS_PPR:
-		msgptr[msglen++] = M_EXTENDED;
-		msgptr[msglen++] = 6;
-		msgptr[msglen++] = M_X_PPR_REQ;
-		msgptr[msglen++] = goal->period;
-		msgptr[msglen++] = 0;
-		msgptr[msglen++] = goal->offset;
-		msgptr[msglen++] = goal->width;
-		msgptr[msglen++] = (goal->iu ? PPR_OPT_IU : 0) |
+		msglen += spi_populate_ppr_msg(msgptr + msglen, goal->period,
+				goal->offset, goal->width,
+				(goal->iu ? PPR_OPT_IU : 0) |
 					(goal->dt ? PPR_OPT_DT : 0) |
-					(goal->qas ? PPR_OPT_QAS : 0);
+					(goal->qas ? PPR_OPT_QAS : 0));
 		break;
 	}
 
@@ -3953,11 +3881,7 @@ sym_sync_nego_check(struct sym_hcb *np, 
 	/*
 	 *  It was a request. Prepare an answer message.
 	 */
-	np->msgout[0] = M_EXTENDED;
-	np->msgout[1] = 3;
-	np->msgout[2] = M_X_SYNC_REQ;
-	np->msgout[3] = per;
-	np->msgout[4] = ofs;
+	spi_populate_sync_msg(np->msgout, per, ofs);
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
 		sym_print_nego_msg(np, target, "sync msgout", np->msgout);
@@ -4083,14 +4007,7 @@ sym_ppr_nego_check(struct sym_hcb *np, i
 	/*
 	 *  It was a request. Prepare an answer message.
 	 */
-	np->msgout[0] = M_EXTENDED;
-	np->msgout[1] = 6;
-	np->msgout[2] = M_X_PPR_REQ;
-	np->msgout[3] = per;
-	np->msgout[4] = 0;
-	np->msgout[5] = ofs;
-	np->msgout[6] = wide;
-	np->msgout[7] = opts;
+	spi_populate_ppr_msg(np->msgout, per, ofs, wide, opts);
 
 	if (DEBUG_FLAGS & DEBUG_NEGO) {
 		sym_print_nego_msg(np, target, "ppr msgout", np->msgout);
@@ -4202,10 +4119,7 @@ sym_wide_nego_check(struct sym_hcb *np, 
 	/*
 	 *  It was a request. Prepare an answer message.
 	 */
-	np->msgout[0] = M_EXTENDED;
-	np->msgout[1] = 2;
-	np->msgout[2] = M_X_WIDE_REQ;
-	np->msgout[3] = wide;
+	spi_populate_width_msg(np->msgout, wide);
 
 	np->msgin [0] = M_NOOP;
 
@@ -4250,11 +4164,8 @@ static void sym_wide_nego(struct sym_hcb
 		 * a single SCSI command (Suggested by Justin Gibbs).
 		 */
 		if (tp->tgoal.offset) {
-			np->msgout[0] = M_EXTENDED;
-			np->msgout[1] = 3;
-			np->msgout[2] = M_X_SYNC_REQ;
-			np->msgout[3] = tp->tgoal.period;
-			np->msgout[4] = tp->tgoal.offset;
+			spi_populate_sync_msg(np->msgout, tp->tgoal.period,
+					tp->tgoal.offset);
 
 			if (DEBUG_FLAGS & DEBUG_NEGO) {
 				sym_print_nego_msg(np, cp->target,
Index: ./include/scsi/scsi_transport_spi.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_transport_spi.h,v
retrieving revision 1.10
diff -u -p -r1.10 scsi_transport_spi.h
--- ./include/scsi/scsi_transport_spi.h	4 Feb 2006 04:52:22 -0000	1.10
+++ ./include/scsi/scsi_transport_spi.h	6 Feb 2006 00:29:05 -0000
@@ -148,5 +148,9 @@ void spi_schedule_dv_device(struct scsi_
 void spi_dv_device(struct scsi_device *);
 void spi_display_xfer_agreement(struct scsi_target *);
 int spi_print_msg(const unsigned char *);
+int spi_populate_width_msg(unsigned char *msg, int width);
+int spi_populate_sync_msg(unsigned char *msg, int period, int offset);
+int spi_populate_ppr_msg(unsigned char *msg, int period, int offset, int width,
+		int options);
 
 #endif /* SCSI_TRANSPORT_SPI_H */
