From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] Add transport class and domain validation to ncr53c8xx
Date: 05 Oct 2004 11:00:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096992032.2173.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44718 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270181AbUJEQAk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 12:00:40 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i95G0Wm27040
	for <linux-scsi@vger.kernel.org>; Tue, 5 Oct 2004 12:00:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This basically drags the driver up to date.  The patch applies agains
scsi-target-2.6.

James

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/05 10:50:10-05:00 jejb@pashleys.(none) 
#   ncr53c8xx: Convert to using transport classes
#   
#   Convert the driver to export period offset and width.  Pick up
#   domain validation on targets for free
#   
#   Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
# 
# drivers/scsi/zalon.c
#   2004/10/05 10:49:58-05:00 jejb@pashleys.(none) +6 -1
#   ncr53c8xx: Convert to using transport classes
# 
# drivers/scsi/ncr53c8xx.h
#   2004/10/05 10:49:58-05:00 jejb@pashleys.(none) +2 -0
#   ncr53c8xx: Convert to using transport classes
# 
# drivers/scsi/ncr53c8xx.c
#   2004/10/05 10:49:58-05:00 jejb@pashleys.(none) +124 -31
#   ncr53c8xx: Convert to using transport classes
# 
# drivers/scsi/NCR_Q720.c
#   2004/10/05 10:49:58-05:00 jejb@pashleys.(none) +7 -1
#   ncr53c8xx: Convert to using transport classes
# 
# drivers/scsi/Kconfig
#   2004/10/05 10:49:58-05:00 jejb@pashleys.(none) +2 -0
#   ncr53c8xx: Convert to using transport classes
# 
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2004-10-05 10:51:04 -05:00
+++ b/drivers/scsi/Kconfig	2004-10-05 10:51:04 -05:00
@@ -1028,6 +1028,7 @@
 config SCSI_ZALON
 	tristate "Zalon SCSI support"
 	depends on GSC && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  The Zalon is a GSC/HSC bus interface chip that sits between the
 	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
@@ -1038,6 +1039,7 @@
 config SCSI_NCR_Q720
 	tristate "NCR Quad 720 MCA SCSI support"
 	depends on MCA && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is a driver for the MicroChannel Quad 720 card produced by
 	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
diff -Nru a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
--- a/drivers/scsi/NCR_Q720.c	2004-10-05 10:51:04 -05:00
+++ b/drivers/scsi/NCR_Q720.c	2004-10-05 10:51:04 -05:00
@@ -358,13 +358,19 @@
 static int __init
 NCR_Q720_init(void)
 {
-	return mca_register_driver(&NCR_Q720_driver);
+	int ret = ncr53c8xx_init();
+	if (!ret)
+		ret = mca_register_driver(&NCR_Q720_driver);
+	if (ret)
+		ncr53c8xx_exit();
+	return ret;
 }
 
 static void __exit
 NCR_Q720_exit(void)
 {
 	mca_unregister_driver(&NCR_Q720_driver);
+	ncr53c8xx_exit();
 }
 
 module_init(NCR_Q720_init);
diff -Nru a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c	2004-10-05 10:51:04 -05:00
+++ b/drivers/scsi/ncr53c8xx.c	2004-10-05 10:51:04 -05:00
@@ -123,6 +123,8 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "ncr53c8xx.h"
 
@@ -412,6 +414,8 @@
 **==========================================================
 */
 
+static struct scsi_transport_template *ncr53c8xx_transport_template = NULL;
+
 struct tcb;
 struct lcb;
 struct ccb;
@@ -532,7 +536,7 @@
 	u_char	usrwide;
 	u_char	usrtags;
 	u_char	usrflag;
-	struct scsi_device *sdev;
+	struct scsi_target *starget;
 };
 
 /*========================================================================
@@ -1212,7 +1216,7 @@
 static	void	ncr_init_ccb	(struct ncb *np, struct ccb *cp);
 static	void	ncr_init_tcb	(struct ncb *np, u_char tn);
 static	struct lcb *	ncr_alloc_lcb	(struct ncb *np, u_char tn, u_char ln);
-static	struct lcb *	ncr_setup_lcb	(struct ncb *np, u_char tn, u_char ln);
+static	struct lcb *	ncr_setup_lcb	(struct ncb *np, struct scsi_device *sdev);
 static	void	ncr_getclock	(struct ncb *np, int mult);
 static	void	ncr_selectclock	(struct ncb *np, u_char scntl3);
 static	struct ccb *ncr_get_ccb	(struct ncb *np, u_char tn, u_char ln);
@@ -1232,7 +1236,7 @@
 static	int	ncr_scatter	(struct ncb *np, struct ccb *cp, struct scsi_cmnd *cmd);
 static	void	ncr_getsync	(struct ncb *np, u_char sfac, u_char *fakp, u_char *scntl3p);
 static	void	ncr_setsync	(struct ncb *np, struct ccb *cp, u_char scntl3, u_char sxfer);
-static	void	ncr_setup_tags	(struct ncb *np, u_char tn, u_char ln);
+static	void	ncr_setup_tags	(struct ncb *np, struct scsi_device *sdev);
 static	void	ncr_setwide	(struct ncb *np, struct ccb *cp, u_char wide, u_char ack);
 static	int	ncr_show_msg	(u_char * msg);
 static  void    ncr_print_msg   (struct ccb *cp, char *label, u_char *msg);
@@ -3363,16 +3367,16 @@
 	struct tcb *tp = &np->target[cp->target];
 	int msglen = 0;
 	int nego = 0;
-	struct scsi_device *sdev = tp->sdev;
+	struct scsi_target *starget = tp->starget;
 
-	if (likely(sdev)) {
+	if (likely(starget)) {
 
 		/*
 		**	negotiate wide transfers ?
 		*/
 
 		if (!tp->widedone) {
-			if (sdev->wdtr) {
+			if (spi_support_wide(starget)) {
 				nego = NS_WIDE;
 			} else
 				tp->widedone=1;
@@ -3384,7 +3388,7 @@
 		*/
 
 		if (!nego && !tp->period) {
-			if (sdev->sdtr) {
+			if (spi_support_sync(starget)) {
 				nego = NS_SYNC;
 			} else {
 				tp->period  =0xffff;
@@ -4273,7 +4277,7 @@
 			if (lp->num_good >= 1000) {
 				lp->num_good = 0;
 				++lp->numtags;
-				ncr_setup_tags (np, cmd->device->id, cmd->device->lun);
+				ncr_setup_tags (np, cmd->device);
 			}
 		}
 	} else if ((cp->host_status == HS_COMPLETE)
@@ -4723,8 +4727,11 @@
 	if (minsync > np->maxsync)
 		minsync = 255;
 
+	if (tp->maxoffs > np->maxoffs)
+		tp->maxoffs = np->maxoffs;
+
 	tp->minsync = minsync;
-	tp->maxoffs = (minsync<255 ? np->maxoffs : 0);
+	tp->maxoffs = (minsync<255 ? tp->maxoffs : 0);
 
 	/*
 	**	period=0: has to negotiate sync transfer
@@ -4978,12 +4985,12 @@
 **==========================================================
 */
 
-static void ncr_setup_tags (struct ncb *np, u_char tn, u_char ln)
+static void ncr_setup_tags (struct ncb *np, struct scsi_device *sdev)
 {
+	unsigned char tn = sdev->id, ln = sdev->lun;
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 	u_char   reqtags, maxdepth;
-	struct scsi_device *sdev = tp->sdev;
 
 	/*
 	**	Just in case ...
@@ -5939,7 +5946,7 @@
 		if (disc_cnt < lp->numtags) {
 			lp->numtags	= disc_cnt > 2 ? disc_cnt : 2;
 			lp->num_good	= 0;
-			ncr_setup_tags (np, cmd->device->id, cmd->device->lun);
+			ncr_setup_tags (np, cmd->device);
 		}
 		/*
 		**	Requeue the command to the start queue.
@@ -6078,6 +6085,7 @@
 	u_long	dsa    = INL (nc_dsa);
 	u_char	target = INB (nc_sdid) & 0x0f;
 	struct tcb *tp     = &np->target[target];
+	struct scsi_target *starget = tp->starget;
 
 	if (DEBUG_FLAGS & DEBUG_TINY) printk ("I#%d", num);
 
@@ -6235,10 +6243,13 @@
 
 		case NS_SYNC:
 			ncr_setsync (np, cp, 0, 0xe0);
+			spi_period(starget) = 0;
+			spi_offset(starget) = 0;
 			break;
 
 		case NS_WIDE:
 			ncr_setwide (np, cp, 0, 0);
+			spi_width(starget) = 0;
 			break;
 
 		};
@@ -6273,8 +6284,8 @@
 		**	      it CAN transfer synch.
 		*/
 
-		if (ofs && tp->sdev)
-			tp->sdev->sdtr = 1;
+		if (ofs && tp->starget)
+			spi_support_sync(tp->starget) = 1;
 
 		/*
 		**	check values against driver limits.
@@ -6325,18 +6336,23 @@
 					**	Answer wasn't acceptable.
 					*/
 					ncr_setsync (np, cp, 0, 0xe0);
+					spi_period(starget) = 0;
+					spi_offset(starget) = 0;
 					OUTL_DSP (NCB_SCRIPT_PHYS (np, msg_bad));
 				} else {
 					/*
 					**	Answer is ok.
 					*/
 					ncr_setsync (np, cp, scntl3, (fak<<5)|ofs);
+					spi_period(starget) = per;
+					spi_offset(starget) = ofs;
 					OUTL_DSP (NCB_SCRIPT_PHYS (np, clrack));
 				};
 				return;
 
 			case NS_WIDE:
 				ncr_setwide (np, cp, 0, 0);
+				spi_width(starget) = 0;
 				break;
 			};
 		};
@@ -6347,6 +6363,8 @@
 		*/
 
 		ncr_setsync (np, cp, scntl3, (fak<<5)|ofs);
+		spi_period(starget) = per;
+		spi_offset(starget) = ofs;
 
 		np->msgout[0] = M_EXTENDED;
 		np->msgout[1] = 3;
@@ -6394,8 +6412,8 @@
 		**	      it CAN transfer wide.
 		*/
 
-		if (wide && tp->sdev)
-			tp->sdev->wdtr = 1;
+		if (wide && tp->starget)
+			spi_support_wide(tp->starget) = 1;
 
 		/*
 		**	check values against driver limits.
@@ -6422,18 +6440,22 @@
 					**	Answer wasn't acceptable.
 					*/
 					ncr_setwide (np, cp, 0, 1);
+					spi_width(starget) = 0;
 					OUTL_DSP (NCB_SCRIPT_PHYS (np, msg_bad));
 				} else {
 					/*
 					**	Answer is ok.
 					*/
 					ncr_setwide (np, cp, wide, 1);
+					spi_width(starget) = wide;
 					OUTL_DSP (NCB_SCRIPT_PHYS (np, clrack));
 				};
 				return;
 
 			case NS_SYNC:
 				ncr_setsync (np, cp, 0, 0xe0);
+				spi_period(starget) = 0;
+				spi_offset(starget) = 0;
 				break;
 			};
 		};
@@ -6444,6 +6466,7 @@
 		*/
 
 		ncr_setwide (np, cp, wide, 1);
+		spi_width(starget) = wide;
 
 		np->msgout[0] = M_EXTENDED;
 		np->msgout[1] = 2;
@@ -6573,13 +6596,6 @@
 			ncr_alloc_ccb(np, tn, ln);
 
 		/*
-		**	Tune tag mode if asked by user.
-		*/
-		if (lp->queuedepth != lp->numtags) {
-			ncr_setup_tags(np, tn, ln);
-		}
-			
-		/*
 		**	Look for free CCB
 		*/
 		qp = ncr_list_pop(&lp->free_ccbq);
@@ -6796,7 +6812,6 @@
 	np->ccb->link_ccb = cp;
 
 	list_add(&cp->link_ccbq, &lp->free_ccbq);
-	ncr_setup_tags (np, tn, ln);
 }
 
 /*==========================================================
@@ -6994,11 +7009,12 @@
 **	will play with CHANGE DEFINITION commands. :-)
 **------------------------------------------------------------------------
 */
-static struct lcb *ncr_setup_lcb (struct ncb *np, u_char tn, u_char ln)
+static struct lcb *ncr_setup_lcb (struct ncb *np, struct scsi_device *sdev)
 {
+	unsigned char tn = sdev->id, ln = sdev->lun;
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
-	struct scsi_device *sdev = tp->sdev;
+	struct scsi_target *starget = tp->starget;
 
 	/*
 	**	If no lcb, try to allocate it.
@@ -7009,7 +7025,7 @@
 	/*
 	**	Prepare negotiation
 	*/
-	if (sdev->wdtr || sdev->sdtr)
+	if (spi_support_wide(starget) || spi_support_sync(starget))
 		ncr_negotiate(np, tp);
 
 	/*
@@ -7031,7 +7047,7 @@
 			lp->cb_tags[i] = i;
 		lp->maxnxs = MAX_TAGS;
 		lp->tags_stime = ktime_get(3*HZ);
-		ncr_setup_tags (np, tn, ln);
+		ncr_setup_tags (np, sdev);
 	}
 

@@ -7416,9 +7432,9 @@
 	struct lcb *lp = tp->lp[device->lun];
 	int numtags, depth_to_use;
 
-	tp->sdev = device;
+	tp->starget = device->sdev_target;
 
-	ncr_setup_lcb(np, device->id, device->lun);
+	ncr_setup_lcb(np, device);
 
 	/*
 	**	Select queue depth from driver setup.
@@ -7455,13 +7471,16 @@
 		lp->numtags = lp->maxtags = numtags;
 		lp->scdev_depth = depth_to_use;
 	}
-	ncr_setup_tags (np, device->id, device->lun);
+	ncr_setup_tags (np, device);
 
 #ifdef DEBUG_NCR53C8XX
 	printk("ncr53c8xx_select_queue_depth: host=%d, id=%d, lun=%d, depth=%d\n",
 	       np->unit, device->id, device->lun, depth_to_use);
 #endif
 
+	if (spi_support_sync(device->sdev_target) &&
+	    !spi_initial_dv(device->sdev_target))
+		spi_dv_device(device);
 	return 0;
 }
 
@@ -7856,6 +7875,10 @@
 	instance->dma_channel	= 0;
 	instance->cmd_per_lun	= MAX_TAGS;
 	instance->can_queue	= (MAX_START-4);
+	/* This can happen if you forget to call ncr53c8xx_init from
+	 * your module_init */
+	BUG_ON(!ncr53c8xx_transport_template);
+	instance->transportt	= ncr53c8xx_transport_template;
 	scsi_set_device(instance, device->dev);
 
 	/* Patch script to physical addresses */
@@ -7983,4 +8006,74 @@
 	if (host_data && host_data->ncb)
 		ncr_detach(host_data->ncb);
 	return 1;
+}
+
+static void ncr53c8xx_set_period(struct scsi_target *starget, int period)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ncb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct tcb *tp = &np->target[starget->id];
+
+	if (period > np->maxsync)
+		period = np->maxsync;
+	else if (period < np->minsync)
+		period = np->minsync;
+
+	tp->usrsync = period;
+
+	ncr_negotiate(np, tp);
+}
+
+static void ncr53c8xx_set_offset(struct scsi_target *starget, int offset)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ncb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct tcb *tp = &np->target[starget->id];
+
+	if (offset > np->maxoffs)
+		offset = np->maxoffs;
+	else if (offset < 0)
+		offset = 0;
+
+	tp->maxoffs = offset;
+
+	ncr_negotiate(np, tp);
+}
+
+static void ncr53c8xx_set_width(struct scsi_target *starget, int width)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct ncb *np = ((struct host_data *)shost->hostdata)->ncb;
+	struct tcb *tp = &np->target[starget->id];
+
+	if (width > np->maxwide)
+		width = np->maxwide;
+	else if (width < 0)
+		width = 0;
+
+	tp->usrwide = width;
+
+	ncr_negotiate(np, tp);
+}
+
+static struct spi_function_template ncr53c8xx_transport_functions =  {
+	.set_period	= ncr53c8xx_set_period,
+	.show_period	= 1,
+	.set_offset	= ncr53c8xx_set_offset,
+	.show_offset	= 1,
+	.set_width	= ncr53c8xx_set_width,
+	.show_width	= 1,
+};
+
+int __init ncr53c8xx_init(void)
+{
+	ncr53c8xx_transport_template = spi_attach_transport(&ncr53c8xx_transport_functions);
+	if (!ncr53c8xx_transport_template)
+		return -ENODEV;
+	return 0;
+}
+
+void ncr53c8xx_exit(void)
+{
+	spi_release_transport(ncr53c8xx_transport_template);
 }
diff -Nru a/drivers/scsi/ncr53c8xx.h b/drivers/scsi/ncr53c8xx.h
--- a/drivers/scsi/ncr53c8xx.h	2004-10-05 10:51:04 -05:00
+++ b/drivers/scsi/ncr53c8xx.h	2004-10-05 10:51:04 -05:00
@@ -95,5 +95,7 @@
 extern struct Scsi_Host *ncr_attach(struct scsi_host_template *tpnt, int unit, struct ncr_device *device);
 extern int ncr53c8xx_release(struct Scsi_Host *host);
 irqreturn_t ncr53c8xx_intr(int irq, void *dev_id, struct pt_regs * regs);
+extern int ncr53c8xx_init(void);
+extern void ncr53c8xx_exit(void);
 
 #endif /* NCR53C8XX_H */
diff -Nru a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
--- a/drivers/scsi/zalon.c	2004-10-05 10:51:04 -05:00
+++ b/drivers/scsi/zalon.c	2004-10-05 10:51:04 -05:00
@@ -190,7 +190,12 @@
 
 static int __init zalon7xx_init(void)
 {
-	return register_parisc_driver(&zalon_driver);
+	int ret = ncr53c8xx_init();
+	if (!ret)
+		ret = register_parisc_driver(&zalon_driver);
+	if (ret)
+		ncr53c8xx_exit();
+	return ret;
 }
 
 static void __exit zalon7xx_exit(void)

