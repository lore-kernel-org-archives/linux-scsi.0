From: willy@parisc-linux.org (Matthew Wilcox)
Subject: [PATCH] [4/5] ncr53c8xx update
Date: Fri, 18 Mar 2005 20:56:37 -0700 (MST)
Message-ID: <20050319035637.16128496108@palinux.hppa>
Received: from palinux.external.hp.com ([192.25.206.14]:50835 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S262395AbVCSD4k
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 22:56:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

ncr53c8xx update

ncr-3.4.3g:

 - set the starget in slave_alloc instead of slave_configure to avoid
   problems with drives sending negotiation messages before we try to
   configure them.
 - Implement ->get_signalling.
 - Pass the scsi_cmnd to ncr_get_ccb() instead of the target & lun numbers
 - All ncr_show_msg() callers changed to use ncr_print_msg()
 - Combine ncr_show_msg() into ncr_print_msg()
 - Move ncr_print_msg() to near the top of the file and eliminate prototype
 - Change PRINT_ADDR() to take a fmt string
 - Make PRINT_ADDR use dev_info()
 - Eliminate PRINT_LUN -- all callers can use PRINT_ADDR or dev_info
 - Replace PRINT_TARGET() with a direct call to dev_info()
 - Whitespace cleanups
 - Get rid of superfluous ; after } of if/switch statements
 - Use IDENTIFY() instead of M_IDENTIFY | ...
 - Convert to use spi_display_xfer_agreement()

Signed-off-by: Matthew Wilcox <willy@parisc-linux.org>

diff -urpNX dontdiff linus-2.6/drivers/scsi/ncr53c8xx.c parisc-2.6/drivers/scsi/ncr53c8xx.c
--- linus-2.6/drivers/scsi/ncr53c8xx.c	2005-03-18 06:21:11.000000000 -0700
+++ parisc-2.6/drivers/scsi/ncr53c8xx.c	2005-03-18 20:36:10.870367554 -0700
@@ -86,7 +86,7 @@
 */
 
 /* Name and version of the driver */
-#define SCSI_NCR_DRIVER_NAME	"ncr53c8xx-3.4.3f"
+#define SCSI_NCR_DRIVER_NAME	"ncr53c8xx-3.4.3g"
 
 #define SCSI_NCR_DEBUG_FLAGS	(0)
 
@@ -1219,7 +1219,7 @@ static	struct lcb *	ncr_alloc_lcb	(struc
 static	struct lcb *	ncr_setup_lcb	(struct ncb *np, struct scsi_device *sdev);
 static	void	ncr_getclock	(struct ncb *np, int mult);
 static	void	ncr_selectclock	(struct ncb *np, u_char scntl3);
-static	struct ccb *ncr_get_ccb	(struct ncb *np, u_char tn, u_char ln);
+static	struct ccb *ncr_get_ccb	(struct ncb *np, struct scsi_cmnd *cmd);
 static	void	ncr_chip_reset	(struct ncb *np, int delay);
 static	void	ncr_init	(struct ncb *np, int reset, char * msg, u_long code);
 static	int	ncr_int_sbmc	(struct ncb *np);
@@ -1238,8 +1238,6 @@ static	void	ncr_getsync	(struct ncb *np,
 static	void	ncr_setsync	(struct ncb *np, struct ccb *cp, u_char scntl3, u_char sxfer);
 static	void	ncr_setup_tags	(struct ncb *np, struct scsi_device *sdev);
 static	void	ncr_setwide	(struct ncb *np, struct ccb *cp, u_char wide, u_char ack);
-static	int	ncr_show_msg	(u_char * msg);
-static  void    ncr_print_msg   (struct ccb *cp, char *label, u_char *msg);
 static	int	ncr_snooptest	(struct ncb *np);
 static	void	ncr_timeout	(struct ncb *np);
 static  void    ncr_wakeup      (struct ncb *np, u_long code);
@@ -2746,7 +2744,7 @@ void __init ncr_script_fill (struct scri
 	for (i=0; i<MAX_START; i++) {
 		*p++ =SCR_CALL;
 		*p++ =PADDR (idle);
-	};
+	}
 
 	BUG_ON((u_long)p != (u_long)&scrh->tryloop + sizeof (scrh->tryloop));
 
@@ -2771,7 +2769,7 @@ void __init ncr_script_fill (struct scri
 		*p++ =PADDR (dispatch);
 		*p++ =SCR_MOVE_TBL ^ SCR_DATA_IN;
 		*p++ =offsetof (struct dsb, data[i]);
-	};
+	}
 
 	BUG_ON((u_long)p != (u_long)&scrh->hdata_in + sizeof (scrh->hdata_in));
 
@@ -2781,7 +2779,7 @@ void __init ncr_script_fill (struct scri
 		*p++ =PADDR (dispatch);
 		*p++ =SCR_MOVE_TBL ^ SCR_DATA_IN;
 		*p++ =offsetof (struct dsb, data[i]);
-	};
+	}
 
 	BUG_ON((u_long)p != (u_long)&scr->data_in + sizeof (scr->data_in));
 
@@ -2791,7 +2789,7 @@ void __init ncr_script_fill (struct scri
 		*p++ =PADDR (dispatch);
 		*p++ =SCR_MOVE_TBL ^ SCR_DATA_OUT;
 		*p++ =offsetof (struct dsb, data[i]);
-	};
+	}
 
 	BUG_ON((u_long)p != (u_long)&scrh->hdata_out + sizeof (scrh->hdata_out));
 
@@ -2801,7 +2799,7 @@ void __init ncr_script_fill (struct scri
 		*p++ =PADDR (dispatch);
 		*p++ =SCR_MOVE_TBL ^ SCR_DATA_OUT;
 		*p++ =offsetof (struct dsb, data[i]);
-	};
+	}
 
 	BUG_ON((u_long) p != (u_long)&scr->data_out + sizeof (scr->data_out));
 }
@@ -2842,7 +2840,7 @@ ncr_script_copy_and_bind (struct ncb *np
 			printk (KERN_ERR "%s: ERROR0 IN SCRIPT at %d.\n",
 				ncr_name(np), (int) (src-start-1));
 			mdelay(1000);
-		};
+		}
 
 		if (DEBUG_FLAGS & DEBUG_SCRIPT)
 			printk (KERN_DEBUG "%p:  <%x>\n",
@@ -2911,7 +2909,7 @@ ncr_script_copy_and_bind (struct ncb *np
 		default:
 			relocs = 0;
 			break;
-		};
+		}
 
 		if (relocs) {
 			while (relocs--) {
@@ -2958,7 +2956,7 @@ ncr_script_copy_and_bind (struct ncb *np
 		} else
 			*dst++ = cpu_to_scr(*src++);
 
-	};
+	}
 }
 
 /*
@@ -2969,25 +2967,25 @@ struct host_data {
      struct ncb *ncb;
 };
 
-/*
-**	Print something which allows to retrieve the controller type, unit,
-**	target, lun concerned by a kernel message.
-*/
+#define PRINT_ADDR(cmd, arg...) dev_info(&cmd->device->sdev_gendev , ## arg)
 
-static void PRINT_TARGET(struct ncb *np, int target)
+static void ncr_print_msg(struct ccb *cp, char *label, u_char *msg)
 {
-	printk(KERN_INFO "%s-<%d,*>: ", ncr_name(np), target);
-}
+	int i;
+	PRINT_ADDR(cp->cmd, "%s: ", label);
 
-static void PRINT_LUN(struct ncb *np, int target, int lun)
-{
-	printk(KERN_INFO "%s-<%d,%d>: ", ncr_name(np), target, lun);
-}
+	printk ("%x",*msg);
+	if (*msg == M_EXTENDED) {
+		for (i = 1; i < 8; i++) {
+			if (i - 1 > msg[1])
+				break;
+			printk ("-%x",msg[i]);
+		}
+	} else if ((*msg & 0xf0) == 0x20) {
+		printk ("-%x",msg[1]);
+	}
 
-static void PRINT_ADDR(struct scsi_cmnd *cmd)
-{
-	struct host_data *host_data = (struct host_data *) cmd->device->host->hostdata;
-	PRINT_LUN(host_data->ncb, cmd->device->id, cmd->device->lun);
+	printk(".\n");
 }
 
 /*==========================================================
@@ -3369,34 +3367,23 @@ static int ncr_prepare_nego(struct ncb *
 	int nego = 0;
 	struct scsi_target *starget = tp->starget;
 
-	if (likely(starget)) {
-
-		/*
-		**	negotiate wide transfers ?
-		*/
-
-		if (!tp->widedone) {
-			if (spi_support_wide(starget)) {
-				nego = NS_WIDE;
-			} else
-				tp->widedone=1;
-
-		};
-
-		/*
-		**	negotiate synchronous transfers?
-		*/
+	/* negotiate wide transfers ?  */
+	if (!tp->widedone) {
+		if (spi_support_wide(starget)) {
+			nego = NS_WIDE;
+		} else
+			tp->widedone=1;
+	}
 
-		if (!nego && !tp->period) {
-			if (spi_support_sync(starget)) {
-				nego = NS_SYNC;
-			} else {
-				tp->period  =0xffff;
-				PRINT_TARGET(np, cp->target);
-				printk ("target did not report SYNC.\n");
-			};
-		};
-	};
+	/* negotiate synchronous transfers?  */
+	if (!nego && !tp->period) {
+		if (spi_support_sync(starget)) {
+			nego = NS_SYNC;
+		} else {
+			tp->period  =0xffff;
+			dev_info(&starget->dev, "target did not report SYNC.\n");
+		}
+	}
 
 	switch (nego) {
 	case NS_SYNC:
@@ -3412,7 +3399,7 @@ static int ncr_prepare_nego(struct ncb *
 		msgptr[msglen++] = M_X_WIDE_REQ;
 		msgptr[msglen++] = tp->usrwide;
 		break;
-	};
+	}
 
 	cp->nego_status = nego;
 
@@ -3421,8 +3408,8 @@ static int ncr_prepare_nego(struct ncb *
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
 			ncr_print_msg(cp, nego == NS_WIDE ?
 					  "wide msgout":"sync_msgout", msgptr);
-		};
-	};
+		}
+	}
 
 	return msglen;
 }
@@ -3440,9 +3427,9 @@ static int ncr_prepare_nego(struct ncb *
 */
 static int ncr_queue_command (struct ncb *np, struct scsi_cmnd *cmd)
 {
-/*	struct scsi_device        *device    = cmd->device; */
-	struct tcb *tp                      = &np->target[cmd->device->id];
-	struct lcb *lp		      = tp->lp[cmd->device->lun];
+	struct scsi_device *sdev = cmd->device;
+	struct tcb *tp = &np->target[sdev->id];
+	struct lcb *lp = tp->lp[sdev->lun];
 	struct ccb *cp;
 
 	int	segments;
@@ -3457,9 +3444,9 @@ static int ncr_queue_command (struct ncb
 	**
 	**---------------------------------------------
 	*/
-	if ((cmd->device->id == np->myaddr	  ) ||
-		(cmd->device->id >= MAX_TARGET) ||
-		(cmd->device->lun    >= MAX_LUN   )) {
+	if ((sdev->id == np->myaddr	  ) ||
+		(sdev->id >= MAX_TARGET) ||
+		(sdev->lun    >= MAX_LUN   )) {
 		return(DID_BAD_TARGET);
 	}
 
@@ -3479,8 +3466,7 @@ static int ncr_queue_command (struct ncb
 	}
 
 	if (DEBUG_FLAGS & DEBUG_TINY) {
-		PRINT_ADDR(cmd);
-		printk ("CMD=%x ", cmd->cmnd[0]);
+		PRINT_ADDR(cmd, "CMD=%x ", cmd->cmnd[0]);
 	}
 
 	/*---------------------------------------------------
@@ -3499,7 +3485,7 @@ static int ncr_queue_command (struct ncb
 			np->settle_time = tlimit;
 	}
 
-	if (np->settle_time || !(cp=ncr_get_ccb (np, cmd->device->id, cmd->device->lun))) {
+	if (np->settle_time || !(cp=ncr_get_ccb (np, cmd))) {
 		insert_into_waiting_list(np, cmd);
 		return(DID_OK);
 	}
@@ -3512,7 +3498,7 @@ static int ncr_queue_command (struct ncb
 	**----------------------------------------------------
 	*/
 
-	idmsg = M_IDENTIFY | cmd->device->lun;
+	idmsg = M_IDENTIFY | sdev->lun;
 
 	if (cp ->tag != NO_TAG ||
 		(cp != np->ccb && np->disc && !(tp->usrflag & UF_NODISC)))
@@ -3533,8 +3519,8 @@ static int ncr_queue_command (struct ncb
 			if (lp->tags_smap) {
 				order = M_ORDERED_TAG;
 				if ((DEBUG_FLAGS & DEBUG_TAGS)||bootverbose>2){ 
-					PRINT_ADDR(cmd);
-					printk("ordered tag forced.\n");
+					PRINT_ADDR(cmd,
+						"ordered tag forced.\n");
 				}
 			}
 			lp->tags_stime = ktime_get(3*HZ);
@@ -3682,7 +3668,7 @@ static int ncr_queue_command (struct ncb
 	/*
 	**	select
 	*/
-	cp->phys.select.sel_id		= cmd->device->id;
+	cp->phys.select.sel_id		= sdev->id;
 	cp->phys.select.sel_scntl3	= tp->wval;
 	cp->phys.select.sel_sxfer	= tp->sval;
 	/*
@@ -3719,9 +3705,7 @@ static int ncr_queue_command (struct ncb
 	**----------------------------------------------------
 	*/
 
-	/*
-	**	activate this job.
-	*/
+	/* activate this job.  */
 	cp->magic		= CCB_MAGIC;
 
 	/*
@@ -3734,11 +3718,9 @@ static int ncr_queue_command (struct ncb
 	else
 		ncr_put_start_queue(np, cp);
 
-	/*
-	**	Command is successfully queued.
-	*/
+	/* Command is successfully queued.  */
 
-	return(DID_OK);
+	return DID_OK;
 }
 
 
@@ -4203,8 +4185,7 @@ void ncr_complete (struct ncb *np, struc
 	*/
 
 	if (cp->parity_status > 1) {
-		PRINT_ADDR(cmd);
-		printk ("%d parity error(s).\n",cp->parity_status);
+		PRINT_ADDR(cmd, "%d parity error(s).\n",cp->parity_status);
 	}
 
 	/*
@@ -4212,16 +4193,16 @@ void ncr_complete (struct ncb *np, struc
 	*/
 
 	if (cp->xerr_status != XE_OK) {
-		PRINT_ADDR(cmd);
 		switch (cp->xerr_status) {
 		case XE_EXTRA_DATA:
-			printk ("extraneous data discarded.\n");
+			PRINT_ADDR(cmd, "extraneous data discarded.\n");
 			break;
 		case XE_BAD_PHASE:
-			printk ("invalid scsi phase (4/5).\n");
+			PRINT_ADDR(cmd, "invalid scsi phase (4/5).\n");
 			break;
 		default:
-			printk ("extended error %d.\n", cp->xerr_status);
+			PRINT_ADDR(cmd, "extended error %d.\n",
+					cp->xerr_status);
 			break;
 		}
 		if (cp->host_status==HS_COMPLETE)
@@ -4233,9 +4214,9 @@ void ncr_complete (struct ncb *np, struc
 	*/
 	if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
 		if (cp->host_status!=HS_COMPLETE || cp->scsi_status!=S_GOOD) {
-			PRINT_ADDR(cmd);
-			printk ("ERROR: cmd=%x host_status=%x scsi_status=%x\n",
-				cmd->cmnd[0], cp->host_status, cp->scsi_status);
+			PRINT_ADDR(cmd, "ERROR: cmd=%x host_status=%x "
+					"scsi_status=%x\n", cmd->cmnd[0],
+					cp->host_status, cp->scsi_status);
 		}
 	}
 
@@ -4296,8 +4277,7 @@ void ncr_complete (struct ncb *np, struc
 		if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
 			u_char * p = (u_char*) & cmd->sense_buffer;
 			int i;
-			PRINT_ADDR(cmd);
-			printk ("sense data:");
+			PRINT_ADDR(cmd, "sense data:");
 			for (i=0; i<14; i++) printk (" %x", *p++);
 			printk (".\n");
 		}
@@ -4344,8 +4324,7 @@ void ncr_complete (struct ncb *np, struc
 		/*
 		**  Other protocol messes
 		*/
-		PRINT_ADDR(cmd);
-		printk ("COMMAND FAILED (%x %x) @%p.\n",
+		PRINT_ADDR(cmd, "COMMAND FAILED (%x %x) @%p.\n",
 			cp->host_status, cp->scsi_status, cp);
 
 		cmd->result = ScsiResult(DID_ERROR, cp->scsi_status);
@@ -4358,8 +4337,7 @@ void ncr_complete (struct ncb *np, struc
 	if (tp->usrflag & UF_TRACE) {
 		u_char * p;
 		int i;
-		PRINT_ADDR(cmd);
-		printk (" CMD:");
+		PRINT_ADDR(cmd, " CMD:");
 		p = (u_char*) &cmd->cmnd[0];
 		for (i=0; i<cmd->cmd_len; i++) printk (" %x", *p++);
 
@@ -4667,7 +4645,7 @@ void ncr_init (struct ncb *np, int reset
 			}
 			else
 				tp->usrsync = 255;
-		};
+		}
 
 		if (tp->usrwide > np->maxwide)
 			tp->usrwide = np->maxwide;
@@ -4849,7 +4827,7 @@ static void ncr_set_sync_wide_status (st
 #endif
 		cp->phys.select.sel_scntl3 = tp->wval;
 		cp->phys.select.sel_sxfer  = tp->sval;
-	};
+	}
 }
 
 /*==========================================================
@@ -4885,40 +4863,19 @@ static void ncr_setsync (struct ncb *np,
 	else
 		tp->period = 0xffff;
 
-	/*
-	**	 Stop there if sync parameters are unchanged
-	*/
-	if (tp->sval == sxfer && tp->wval == scntl3) return;
+	/* Stop there if sync parameters are unchanged */
+	if (tp->sval == sxfer && tp->wval == scntl3)
+		return;
 	tp->sval = sxfer;
 	tp->wval = scntl3;
 
-	/*
-	**	Bells and whistles   ;-)
-	*/
-	PRINT_TARGET(np, target);
 	if (sxfer & 0x01f) {
-		unsigned f10 = 100000 << (tp->widedone ? tp->widedone -1 : 0);
-		unsigned mb10 = (f10 + tp->period/2) / tp->period;
-		char *scsi;
-
-		/*
-		**  Disable extended Sreq/Sack filtering
-		*/
-		if (tp->period <= 2000) OUTOFFB (nc_stest2, EXT);
-
-		/*
-		**	Bells and whistles   ;-)
-		*/
-		if	(tp->period < 500)	scsi = "FAST-40";
-		else if	(tp->period < 1000)	scsi = "FAST-20";
-		else if	(tp->period < 2000)	scsi = "FAST-10";
-		else				scsi = "FAST-5";
-
-		printk ("%s %sSCSI %d.%d MB/s (%d ns, offset %d)\n", scsi,
-			tp->widedone > 1 ? "WIDE " : "",
-			mb10 / 10, mb10 % 10, tp->period / 10, sxfer & 0x1f);
-	} else
-		printk ("%sasynchronous.\n", tp->widedone > 1 ? "wide " : "");
+		/* Disable extended Sreq/Sack filtering */
+		if (tp->period <= 2000)
+			OUTOFFB(nc_stest2, EXT);
+	}
+ 
+	spi_display_xfer_agreement(tp->starget);
 
 	/*
 	**	set actual value and sync_status
@@ -4964,11 +4921,8 @@ static void ncr_setwide (struct ncb *np,
 	**	Bells and whistles   ;-)
 	*/
 	if (bootverbose >= 2) {
-		PRINT_TARGET(np, target);
-		if (scntl3 & EWS)
-			printk ("WIDE SCSI (16 bit) enabled.\n");
-		else
-			printk ("WIDE SCSI disabled.\n");
+		dev_info(&cmd->device->sdev_target->dev, "WIDE SCSI %sabled.\n",
+				(scntl3 & EWS) ? "en" : "dis");
 	}
 
 	/*
@@ -5023,7 +4977,7 @@ static void ncr_setup_tags (struct ncb *
 		reqtags = lp->numtags;
 	} else {
 		reqtags = 1;
-	};
+	}
 
 	/*
 	**	Update max number of tags
@@ -5063,12 +5017,13 @@ static void ncr_setup_tags (struct ncb *
 	**	Announce change to user.
 	*/
 	if (bootverbose) {
-		PRINT_LUN(np, tn, ln);
 		if (lp->usetags) {
-			printk("tagged command queue depth set to %d\n", reqtags);
-		}
-		else {
-			printk("tagged command queueing disabled\n");
+			dev_info(&sdev->sdev_gendev,
+				"tagged command queue depth set to %d\n",
+				reqtags);
+		} else {
+			dev_info(&sdev->sdev_gendev,
+					"tagged command queueing disabled\n");
 		}
 	}
 }
@@ -5274,7 +5229,7 @@ void ncr_exception (struct ncb *np)
 		istat = INB (nc_istat);
 		if (DEBUG_FLAGS & DEBUG_TINY) printk ("F ");
 		ncr_wakeup_done (np);
-	};
+	}
 
 	if (!(istat & (SIP|DIP)))
 		return;
@@ -5335,7 +5290,7 @@ void ncr_exception (struct ncb *np)
 		}
 		OUTONB_STD ();
 		return;
-	};
+	}
 
 	/*========================================================
 	**	Now, interrupts that need some fixing up.
@@ -5355,7 +5310,7 @@ void ncr_exception (struct ncb *np)
 	if (sist & RST) {
 		ncr_init (np, 1, bootverbose ? "scsi reset" : NULL, HS_RESET);
 		return;
-	};
+	}
 
 	if ((sist & STO) &&
 		!(dstat & (MDPE|BF|ABRT))) {
@@ -5366,7 +5321,7 @@ void ncr_exception (struct ncb *np)
 
 		ncr_int_sto (np);
 		return;
-	};
+	}
 
 	/*=========================================================
 	**	Now, interrupts we are not able to recover cleanly.
@@ -5387,7 +5342,7 @@ void ncr_exception (struct ncb *np)
 			((char*)&np->regdump)[i] = INB_OFF(i);
 		np->regdump.nc_dstat = dstat;
 		np->regdump.nc_sist  = sist;
-	};
+	}
 
 	ncr_log_hard_error(np, sist, dstat);
 
@@ -5399,20 +5354,20 @@ void ncr_exception (struct ncb *np)
 		(dstat & (MDPE|BF|ABRT|IID))) {
 		ncr_start_reset(np);
 		return;
-	};
+	}
 
 	if (sist & HTH) {
 		printk ("%s: handshake timeout\n", ncr_name(np));
 		ncr_start_reset(np);
 		return;
-	};
+	}
 
 	if (sist & UDC) {
 		printk ("%s: unexpected disconnect\n", ncr_name(np));
 		OUTB (HS_PRT, HS_UNEXPECTED);
 		OUTL_DSP (NCB_SCRIPT_PHYS (np, cleanup));
 		return;
-	};
+	}
 
 	/*=========================================================
 	**	We just miss the cause of the interrupt. :(
@@ -5456,7 +5411,7 @@ void ncr_int_sto (struct ncb *np)
 	if (cp) {
 		cp-> host_status = HS_SEL_TIMEOUT;
 		ncr_complete (np, cp);
-	};
+	}
 
 	/*
 	**	repair start queue and jump to start point.
@@ -5647,7 +5602,7 @@ static void ncr_int_ma (struct ncb *np)
 			ss2 = INB (nc_sstat2);
 			if (ss2 & OLF1) rest++;
 			if (ss2 & ORF1) rest++;
-		};
+		}
 
 		if (DEBUG_FLAGS & (DEBUG_TINY|DEBUG_PHASE))
 			printk ("P%x%x RL=%d D=%d SS0=%x ", cmd&7, sbcl&7,
@@ -5716,7 +5671,7 @@ static void ncr_int_ma (struct ncb *np)
 			cp, np->header.cp,
 			(unsigned)dsp,
 			(unsigned)nxtdsp, vdsp, cmd);
-	};
+	}
 
 	/*
 	**	cp=0 means that the DSA does not point to a valid control 
@@ -5744,7 +5699,7 @@ static void ncr_int_ma (struct ncb *np)
 	} else {
 		tblp = (u32 *) 0;
 		olen = scr_to_cpu(vdsp[0]) & 0xffffff;
-	};
+	}
 
 	if (DEBUG_FLAGS & DEBUG_PHASE) {
 		printk ("OCMD=%x\nTBLP=%p OLEN=%x OADR=%x\n",
@@ -5752,16 +5707,15 @@ static void ncr_int_ma (struct ncb *np)
 			tblp,
 			(unsigned) olen,
 			(unsigned) oadr);
-	};
+	}
 
 	/*
 	**	check cmd against assumed interrupted script command.
 	*/
 
 	if (cmd != (scr_to_cpu(vdsp[0]) >> 24)) {
-		PRINT_ADDR(cp->cmd);
-		printk ("internal error: cmd=%02x != %02x=(vdsp[0] >> 24)\n",
-			(unsigned)cmd, (unsigned)scr_to_cpu(vdsp[0]) >> 24);
+		PRINT_ADDR(cp->cmd, "internal error: cmd=%02x != %02x=(vdsp[0] "
+				">> 24)\n", cmd, scr_to_cpu(vdsp[0]) >> 24);
 
 		goto reset_all;
 	}
@@ -5783,12 +5737,11 @@ static void ncr_int_ma (struct ncb *np)
 	*/
 
 	if (cmd & 0x06) {
-		PRINT_ADDR(cp->cmd);
-		printk ("phase change %x-%x %d@%08x resid=%d.\n",
+		PRINT_ADDR(cp->cmd, "phase change %x-%x %d@%08x resid=%d.\n",
 			cmd&7, sbcl&7, (unsigned)olen,
 			(unsigned)oadr, (unsigned)rest);
 		goto unexpected_phase;
-	};
+	}
 
 	/*
 	**	choose the correct patch area.
@@ -5812,8 +5765,7 @@ static void ncr_int_ma (struct ncb *np)
 	newcmd[3] = cpu_to_scr(nxtdsp);
 
 	if (DEBUG_FLAGS & DEBUG_PHASE) {
-		PRINT_ADDR(cp->cmd);
-		printk ("newcmd[%d] %x %x %x %x.\n",
+		PRINT_ADDR(cp->cmd, "newcmd[%d] %x %x %x %x.\n",
 			(int) (newcmd - cp->patch),
 			(unsigned)scr_to_cpu(newcmd[0]),
 			(unsigned)scr_to_cpu(newcmd[1]),
@@ -5939,9 +5891,8 @@ static void ncr_sir_to_redo(struct ncb *
 		if (!lp)
 			goto out;
 		if (bootverbose >= 1) {
-			PRINT_ADDR(cmd);
-			printk ("QUEUE FULL! %d busy, %d disconnected CCBs\n",
-				busy_cnt, disc_cnt);
+			PRINT_ADDR(cmd, "QUEUE FULL! %d busy, %d disconnected "
+					"CCBs\n", busy_cnt, disc_cnt);
 		}
 		if (disc_cnt < lp->numtags) {
 			lp->numtags	= disc_cnt > 2 ? disc_cnt : 2;
@@ -5978,7 +5929,7 @@ static void ncr_sir_to_redo(struct ncb *
 		**
 		**	identify message
 		*/
-		cp->scsi_smsg2[0]	= M_IDENTIFY | cmd->device->lun;
+		cp->scsi_smsg2[0]	= IDENTIFY(0, cmd->device->lun);
 		cp->phys.smsg.addr	= cpu_to_scr(CCB_PHYS (cp, scsi_smsg2));
 		cp->phys.smsg.size	= cpu_to_scr(1);
 
@@ -6048,34 +5999,6 @@ out:
 **==========================================================
 */
 
-static int ncr_show_msg (u_char * msg)
-{
-	u_char i;
-	printk ("%x",*msg);
-	if (*msg==M_EXTENDED) {
-		for (i=1;i<8;i++) {
-			if (i-1>msg[1]) break;
-			printk ("-%x",msg[i]);
-		};
-		return (i+1);
-	} else if ((*msg & 0xf0) == 0x20) {
-		printk ("-%x",msg[1]);
-		return (2);
-	};
-	return (1);
-}
-
-static void ncr_print_msg ( struct ccb *cp, char *label, u_char *msg)
-{
-	if (cp)
-		PRINT_ADDR(cp->cmd);
-	if (label)
-		printk("%s: ", label);
-	
-	(void) ncr_show_msg (msg);
-	printk(".\n");
-}
-
 void ncr_int_sir (struct ncb *np)
 {
 	u_char scntl3;
@@ -6230,10 +6153,9 @@ void ncr_int_sir (struct ncb *np)
 		*/
 
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("negotiation failed sir=%x status=%x.\n",
-				num, cp->nego_status);
-		};
+			PRINT_ADDR(cp->cmd, "negotiation failed sir=%x "
+					"status=%x.\n", num, cp->nego_status);
+		}
 
 		/*
 		**	any error in negotiation:
@@ -6242,37 +6164,26 @@ void ncr_int_sir (struct ncb *np)
 		switch (cp->nego_status) {
 
 		case NS_SYNC:
-			ncr_setsync (np, cp, 0, 0xe0);
 			spi_period(starget) = 0;
 			spi_offset(starget) = 0;
+			ncr_setsync (np, cp, 0, 0xe0);
 			break;
 
 		case NS_WIDE:
-			ncr_setwide (np, cp, 0, 0);
 			spi_width(starget) = 0;
+			ncr_setwide (np, cp, 0, 0);
 			break;
 
-		};
+		}
 		np->msgin [0] = M_NOOP;
 		np->msgout[0] = M_NOOP;
 		cp->nego_status = 0;
 		break;
 
 	case SIR_NEGO_SYNC:
-		/*
-		**	Synchronous request message received.
-		*/
-
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("sync msgin: ");
-			(void) ncr_show_msg (np->msgin);
-			printk (".\n");
-		};
-
-		/*
-		**	get requested values.
-		*/
+			ncr_print_msg(cp, "sync msgin", np->msgin);
+		}
 
 		chg = 0;
 		per = np->msgin[3];
@@ -6284,8 +6195,8 @@ void ncr_int_sir (struct ncb *np)
 		**	      it CAN transfer synch.
 		*/
 
-		if (ofs && tp->starget)
-			spi_support_sync(tp->starget) = 1;
+		if (ofs && starget)
+			spi_support_sync(starget) = 1;
 
 		/*
 		**	check values against driver limits.
@@ -6318,9 +6229,8 @@ void ncr_int_sir (struct ncb *np)
 		}
 
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("sync: per=%d scntl3=0x%x ofs=%d fak=%d chg=%d.\n",
-				per, scntl3, ofs, fak, chg);
+			PRINT_ADDR(cp->cmd, "sync: per=%d scntl3=0x%x ofs=%d "
+				"fak=%d chg=%d.\n", per, scntl3, ofs, fak, chg);
 		}
 
 		if (INB (HS_PRT) == HS_NEGOTIATE) {
@@ -6328,43 +6238,37 @@ void ncr_int_sir (struct ncb *np)
 			switch (cp->nego_status) {
 
 			case NS_SYNC:
-				/*
-				**      This was an answer message
-				*/
+				/* This was an answer message */
 				if (chg) {
-					/*
-					**	Answer wasn't acceptable.
-					*/
-					ncr_setsync (np, cp, 0, 0xe0);
+					/* Answer wasn't acceptable.  */
 					spi_period(starget) = 0;
 					spi_offset(starget) = 0;
-					OUTL_DSP (NCB_SCRIPT_PHYS (np, msg_bad));
+					ncr_setsync(np, cp, 0, 0xe0);
+					OUTL_DSP(NCB_SCRIPT_PHYS (np, msg_bad));
 				} else {
-					/*
-					**	Answer is ok.
-					*/
-					ncr_setsync (np, cp, scntl3, (fak<<5)|ofs);
+					/* Answer is ok.  */
 					spi_period(starget) = per;
 					spi_offset(starget) = ofs;
-					OUTL_DSP (NCB_SCRIPT_PHYS (np, clrack));
-				};
+					ncr_setsync(np, cp, scntl3, (fak<<5)|ofs);
+					OUTL_DSP(NCB_SCRIPT_PHYS (np, clrack));
+				}
 				return;
 
 			case NS_WIDE:
-				ncr_setwide (np, cp, 0, 0);
 				spi_width(starget) = 0;
+				ncr_setwide(np, cp, 0, 0);
 				break;
-			};
-		};
+			}
+		}
 
 		/*
 		**	It was a request. Set value and
 		**      prepare an answer message
 		*/
 
-		ncr_setsync (np, cp, scntl3, (fak<<5)|ofs);
 		spi_period(starget) = per;
 		spi_offset(starget) = ofs;
+		ncr_setsync(np, cp, scntl3, (fak<<5)|ofs);
 
 		np->msgout[0] = M_EXTENDED;
 		np->msgout[1] = 3;
@@ -6375,10 +6279,7 @@ void ncr_int_sir (struct ncb *np)
 		cp->nego_status = NS_SYNC;
 
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("sync msgout: ");
-			(void) ncr_show_msg (np->msgout);
-			printk (".\n");
+			ncr_print_msg(cp, "sync msgout", np->msgout);
 		}
 
 		if (!ofs) {
@@ -6394,11 +6295,8 @@ void ncr_int_sir (struct ncb *np)
 		**	Wide request message received.
 		*/
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("wide msgin: ");
-			(void) ncr_show_msg (np->msgin);
-			printk (".\n");
-		};
+			ncr_print_msg(cp, "wide msgin", np->msgin);
+		}
 
 		/*
 		**	get requested values.
@@ -6412,8 +6310,8 @@ void ncr_int_sir (struct ncb *np)
 		**	      it CAN transfer wide.
 		*/
 
-		if (wide && tp->starget)
-			spi_support_wide(tp->starget) = 1;
+		if (wide && starget)
+			spi_support_wide(starget) = 1;
 
 		/*
 		**	check values against driver limits.
@@ -6423,8 +6321,8 @@ void ncr_int_sir (struct ncb *np)
 			{chg = 1; wide = tp->usrwide;}
 
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("wide: wide=%d chg=%d.\n", wide, chg);
+			PRINT_ADDR(cp->cmd, "wide: wide=%d chg=%d.\n", wide,
+					chg);
 		}
 
 		if (INB (HS_PRT) == HS_NEGOTIATE) {
@@ -6436,37 +6334,33 @@ void ncr_int_sir (struct ncb *np)
 				**      This was an answer message
 				*/
 				if (chg) {
-					/*
-					**	Answer wasn't acceptable.
-					*/
-					ncr_setwide (np, cp, 0, 1);
+					/* Answer wasn't acceptable.  */
 					spi_width(starget) = 0;
+					ncr_setwide(np, cp, 0, 1);
 					OUTL_DSP (NCB_SCRIPT_PHYS (np, msg_bad));
 				} else {
-					/*
-					**	Answer is ok.
-					*/
-					ncr_setwide (np, cp, wide, 1);
+					/* Answer is ok.  */
 					spi_width(starget) = wide;
+					ncr_setwide(np, cp, wide, 1);
 					OUTL_DSP (NCB_SCRIPT_PHYS (np, clrack));
-				};
+				}
 				return;
 
 			case NS_SYNC:
-				ncr_setsync (np, cp, 0, 0xe0);
 				spi_period(starget) = 0;
 				spi_offset(starget) = 0;
+				ncr_setsync(np, cp, 0, 0xe0);
 				break;
-			};
-		};
+			}
+		}
 
 		/*
 		**	It was a request, set value and
 		**      prepare an answer message
 		*/
 
-		ncr_setwide (np, cp, wide, 1);
 		spi_width(starget) = wide;
+		ncr_setwide(np, cp, wide, 1);
 
 		np->msgout[0] = M_EXTENDED;
 		np->msgout[1] = 2;
@@ -6478,10 +6372,7 @@ void ncr_int_sir (struct ncb *np)
 		cp->nego_status = NS_WIDE;
 
 		if (DEBUG_FLAGS & DEBUG_NEGO) {
-			PRINT_ADDR(cp->cmd);
-			printk ("wide msgout: ");
-			(void) ncr_show_msg (np->msgin);
-			printk (".\n");
+			ncr_print_msg(cp, "wide msgout", np->msgin);
 		}
 		break;
 
@@ -6500,8 +6391,7 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd);
-		printk ("M_REJECT received (%x:%x).\n",
+		PRINT_ADDR(cp->cmd, "M_REJECT received (%x:%x).\n",
 			(unsigned)scr_to_cpu(np->lastmsg), np->msgout[0]);
 		break;
 
@@ -6513,10 +6403,7 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd);
-		printk ("M_REJECT sent for ");
-		(void) ncr_show_msg (np->msgin);
-		printk (".\n");
+		ncr_print_msg(cp, "M_REJECT sent for", np->msgin);
 		break;
 
 /*--------------------------------------------------------------------
@@ -6535,8 +6422,8 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd);
-		printk ("M_IGN_RESIDUE received, but not yet implemented.\n");
+		PRINT_ADDR(cp->cmd, "M_IGN_RESIDUE received, but not yet "
+				"implemented.\n");
 		break;
 #if 0
 	case SIR_MISSING_SAVE:
@@ -6548,15 +6435,14 @@ void ncr_int_sir (struct ncb *np)
 		**-----------------------------------------------
 		*/
 
-		PRINT_ADDR(cp->cmd);
-		printk ("M_DISCONNECT received, but datapointer not saved: "
-			"data=%x save=%x goal=%x.\n",
+		PRINT_ADDR(cp->cmd, "M_DISCONNECT received, but datapointer "
+				"not saved: data=%x save=%x goal=%x.\n",
 			(unsigned) INL (nc_temp),
 			(unsigned) scr_to_cpu(np->header.savep),
 			(unsigned) scr_to_cpu(np->header.goalp));
 		break;
 #endif
-	};
+	}
 
 out:
 	OUTONB_STD ();
@@ -6571,8 +6457,10 @@ out:
 **==========================================================
 */
 
-static	struct ccb *ncr_get_ccb (struct ncb *np, u_char tn, u_char ln)
+static struct ccb *ncr_get_ccb(struct ncb *np, struct scsi_cmnd *cmd)
 {
+	u_char tn = cmd->device->id;
+	u_char ln = cmd->device->lun;
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
 	u_char tag = NO_TAG;
@@ -6602,8 +6490,8 @@ static	struct ccb *ncr_get_ccb (struct n
 		if (qp) {
 			cp = list_entry(qp, struct ccb, link_ccbq);
 			if (cp->magic) {
-				PRINT_LUN(np, tn, ln);
-				printk ("ccb free list corrupted (@%p)\n", cp);
+				PRINT_ADDR(cmd, "ccb free list corrupted "
+						"(@%p)\n", cp);
 				cp = NULL;
 			} else {
 				list_add_tail(qp, &lp->wait_ccbq);
@@ -6637,7 +6525,7 @@ static	struct ccb *ncr_get_ccb (struct n
 		if (flags & SCSI_NOSLEEP) break;
 		if (tsleep ((caddr_t)cp, PRIBIO|PCATCH, "ncr", 0))
 			break;
-	};
+	}
 #endif
 
 	if (cp->magic)
@@ -6665,8 +6553,7 @@ static	struct ccb *ncr_get_ccb (struct n
 	cp->lun    = ln;
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
-		PRINT_LUN(np, tn, ln);
-		printk ("ccb @%p using tag %d.\n", cp, tag);
+		PRINT_ADDR(cmd, "ccb @%p using tag %d.\n", cp, tag);
 	}
 
 	return cp;
@@ -6687,8 +6574,7 @@ static void ncr_free_ccb (struct ncb *np
 	struct lcb *lp = tp->lp[cp->lun];
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
-		PRINT_LUN(np, cp->target, cp->lun);
-		printk ("ccb @%p freeing tag %d.\n", cp, cp->tag);
+		PRINT_ADDR(cp->cmd, "ccb @%p freeing tag %d.\n", cp, cp->tag);
 	}
 
 	/*
@@ -7014,17 +6900,13 @@ static struct lcb *ncr_setup_lcb (struct
 	unsigned char tn = sdev->id, ln = sdev->lun;
 	struct tcb *tp = &np->target[tn];
 	struct lcb *lp = tp->lp[ln];
-	struct scsi_target *starget = tp->starget;
+	struct scsi_target *starget = sdev->sdev_target;
 
-	/*
-	**	If no lcb, try to allocate it.
-	*/
+	/* If no lcb, try to allocate it.  */
 	if (!lp && !(lp = ncr_alloc_lcb(np, tn, ln)))
 		goto fail;
 
-	/*
-	**	Prepare negotiation
-	*/
+	/* Prepare negotiation */
 	if (spi_support_wide(starget) || spi_support_sync(starget))
 		ncr_negotiate(np, tp);
 
@@ -7170,7 +7052,7 @@ static int __init ncr_regtest (struct nc
 		printk ("CACHE TEST FAILED: reg dstat-sstat2 readback %x.\n",
 			(unsigned) data);
 		return (0x10);
-	};
+	}
 	return (0);
 }
 
@@ -7223,7 +7105,7 @@ static int __init ncr_snooptest (struct 
 	if (i>=NCR_SNOOP_TIMEOUT) {
 		printk ("CACHE TEST FAILED: timeout.\n");
 		return (0x20);
-	};
+	}
 	/*
 	**	Check termination position.
 	*/
@@ -7233,7 +7115,7 @@ static int __init ncr_snooptest (struct 
 			(u_long) NCB_SCRIPTH_PHYS (np, snooptest), (u_long) pc,
 			(u_long) NCB_SCRIPTH_PHYS (np, snoopend) +8);
 		return (0x40);
-	};
+	}
 	/*
 	**	Show results.
 	*/
@@ -7241,17 +7123,17 @@ static int __init ncr_snooptest (struct 
 		printk ("CACHE TEST FAILED: host wrote %d, ncr read %d.\n",
 			(int) host_wr, (int) ncr_rd);
 		err |= 1;
-	};
+	}
 	if (host_rd != ncr_wr) {
 		printk ("CACHE TEST FAILED: ncr wrote %d, host read %d.\n",
 			(int) ncr_wr, (int) host_rd);
 		err |= 2;
-	};
+	}
 	if (ncr_bk != ncr_wr) {
 		printk ("CACHE TEST FAILED: ncr wrote %d, read back %d.\n",
 			(int) ncr_wr, (int) ncr_bk);
 		err |= 4;
-	};
+	}
 	return (err);
 }
 
@@ -7424,6 +7306,16 @@ static void __init ncr_getclock (struct 
 
 /*===================== LINUX ENTRY POINTS SECTION ==========================*/
 
+static int ncr53c8xx_slave_alloc(struct scsi_device *device)
+{
+	struct Scsi_Host *host = device->host;
+	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
+	struct tcb *tp = &np->target[device->id];
+	tp->starget = device->sdev_target;
+
+	return 0;
+}
+
 static int ncr53c8xx_slave_configure(struct scsi_device *device)
 {
 	struct Scsi_Host *host = device->host;
@@ -7432,8 +7324,6 @@ static int ncr53c8xx_slave_configure(str
 	struct lcb *lp = tp->lp[device->lun];
 	int numtags, depth_to_use;
 
-	tp->starget = device->sdev_target;
-
 	ncr_setup_lcb(np, device);
 
 	/*
@@ -7778,6 +7668,7 @@ struct Scsi_Host * __init ncr_attach(str
 
 	tpnt->queuecommand	= ncr53c8xx_queue_command;
 	tpnt->slave_configure	= ncr53c8xx_slave_configure;
+	tpnt->slave_alloc	= ncr53c8xx_slave_alloc;
 	tpnt->eh_bus_reset_handler = ncr53c8xx_bus_reset;
 	tpnt->can_queue		= SCSI_NCR_CAN_QUEUE;
 	tpnt->this_id		= 7;
@@ -7925,7 +7816,7 @@ struct Scsi_Host * __init ncr_attach(str
 	if (ncr_snooptest(np)) {
 		printk(KERN_ERR "CACHE INCORRECTLY CONFIGURED.\n");
 		goto attach_error;
-	};
+	}
 
 	/* Install the interrupt handler.  */
 	np->irq = device->slot.irq;
@@ -8057,6 +7948,25 @@ static void ncr53c8xx_set_width(struct s
 	ncr_negotiate(np, tp);
 }
 
+static void ncr53c8xx_get_signalling(struct Scsi_Host *shost)
+{
+	struct ncb *np = ((struct host_data *)shost->hostdata)->ncb;
+	enum spi_signal_type type;
+
+	switch (np->scsi_mode) {
+	case SMODE_SE:
+		type = SPI_SIGNAL_SE;
+		break;
+	case SMODE_HVD:
+		type = SPI_SIGNAL_HVD;
+		break;
+	default:
+		type = SPI_SIGNAL_UNKNOWN;
+		break;
+	}
+	spi_signalling(shost) = type;
+}
+
 static struct spi_function_template ncr53c8xx_transport_functions =  {
 	.set_period	= ncr53c8xx_set_period,
 	.show_period	= 1,
@@ -8064,6 +7974,7 @@ static struct spi_function_template ncr5
 	.show_offset	= 1,
 	.set_width	= ncr53c8xx_set_width,
 	.show_width	= 1,
+	.get_signalling	= ncr53c8xx_get_signalling,
 };
 
 int __init ncr53c8xx_init(void)
diff -urpNX dontdiff linus-2.6/drivers/scsi/sym53c8xx_defs.h parisc-2.6/drivers/scsi/sym53c8xx_defs.h
--- linus-2.6/drivers/scsi/sym53c8xx_defs.h	2005-03-18 06:21:12.000000000 -0700
+++ parisc-2.6/drivers/scsi/sym53c8xx_defs.h	2005-03-18 06:03:07.000000000 -0700
@@ -314,9 +314,9 @@
 #define	writew_b2l	__raw_writew
 #define	writel_b2l	__raw_writel
 #define	readw_raw	__raw_readw
-#define	readl_raw(a)	__raw_readl((unsigned long)(a))
+#define	readl_raw	__raw_readl
 #define	writew_raw	__raw_writew
-#define	writel_raw(v,a)	__raw_writel(v,(unsigned long)(a))
+#define	writel_raw	__raw_writel
 #else	/* Other big-endian */
 #define	readw_l2b	readw
 #define	readl_l2b	readl
@@ -1281,34 +1281,34 @@ struct scr_tblsel {
 **	Messages
 */
 
-#define	M_COMPLETE	(0x00)
-#define	M_EXTENDED	(0x01)
-#define	M_SAVE_DP	(0x02)
-#define	M_RESTORE_DP	(0x03)
-#define	M_DISCONNECT	(0x04)
-#define	M_ID_ERROR	(0x05)
-#define	M_ABORT		(0x06)
-#define	M_REJECT	(0x07)
-#define	M_NOOP		(0x08)
-#define	M_PARITY	(0x09)
-#define	M_LCOMPLETE	(0x0a)
-#define	M_FCOMPLETE	(0x0b)
-#define	M_RESET		(0x0c)
-#define	M_ABORT_TAG	(0x0d)
-#define	M_CLEAR_QUEUE	(0x0e)
-#define	M_INIT_REC	(0x0f)
-#define	M_REL_REC	(0x10)
+#define	M_COMPLETE	COMMAND_COMPLETE
+#define	M_EXTENDED	EXTENDED_MESSAGE
+#define	M_SAVE_DP	SAVE_POINTERS
+#define	M_RESTORE_DP	RESTORE_POINTERS
+#define	M_DISCONNECT	DISCONNECT
+#define	M_ID_ERROR	INITIATOR_ERROR
+#define	M_ABORT		ABORT_TASK_SET
+#define	M_REJECT	MESSAGE_REJECT
+#define	M_NOOP		NOP
+#define	M_PARITY	MSG_PARITY_ERROR
+#define	M_LCOMPLETE	LINKED_CMD_COMPLETE
+#define	M_FCOMPLETE	LINKED_FLG_CMD_COMPLETE
+#define	M_RESET		TARGET_RESET
+#define	M_ABORT_TAG	ABORT_TASK
+#define	M_CLEAR_QUEUE	CLEAR_TASK_SET
+#define	M_INIT_REC	INITIATE_RECOVERY
+#define	M_REL_REC	RELEASE_RECOVERY
 #define	M_TERMINATE	(0x11)
-#define	M_SIMPLE_TAG	(0x20)
-#define	M_HEAD_TAG	(0x21)
-#define	M_ORDERED_TAG	(0x22)
-#define	M_IGN_RESIDUE	(0x23)
+#define	M_SIMPLE_TAG	SIMPLE_QUEUE_TAG
+#define	M_HEAD_TAG	HEAD_OF_QUEUE_TAG
+#define	M_ORDERED_TAG	ORDERED_QUEUE_TAG
+#define	M_IGN_RESIDUE	IGNORE_WIDE_RESIDUE
 #define	M_IDENTIFY   	(0x80)
 
-#define	M_X_MODIFY_DP	(0x00)
-#define	M_X_SYNC_REQ	(0x01)
-#define	M_X_WIDE_REQ	(0x03)
-#define	M_X_PPR_REQ	(0x04)
+#define	M_X_MODIFY_DP	EXTENDED_MODIFY_DATA_POINTER
+#define	M_X_SYNC_REQ	EXTENDED_SDTR
+#define	M_X_WIDE_REQ	EXTENDED_WDTR
+#define	M_X_PPR_REQ	EXTENDED_PPR
 
 /*
 **	Status
