From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [3/5] - remove old debugging stuff
Date: Tue, 9 Mar 2004 15:24:42 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309042442.GC12274@twibble.org>
References: <20040309042300.GA12274@twibble.org> <20040309042400.GB12274@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:53188 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S261503AbUCIEY5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2004 23:24:57 -0500
Content-Disposition: inline
In-Reply-To: <20040309042400.GB12274@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Remove the special versions of kmalloc and kfree and remove the trace
related stuff from the code. None of this is really needed and it is
not really a nice implementation. This also removes all non 7-bit
clean characters to help with David Eger's work to remove and/or
convert them all to UTF8.

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2004-03-07 09:43:14.600896285 +1100
+++ b/drivers/scsi/dc395x.c	2004-03-07 09:43:21.075897679 +1100
@@ -87,16 +87,13 @@
 #define DBG_SGPARANOIA	0x0020
 #define DBG_FIFO	0x0040
 #define DBG_PIO		0x0080
-#define DBG_MALLOC	0x0200		/* report on memory allocations */
-#define DBG_TRACE	0x0400
-#define DBG_TRACEALL	0x0800
=20
=20
 /*
  * Set set of things to output debugging for.
  * Undefine to remove all debugging
  */
-/*#define DEBUG_MASK (DBG_0|DBG_1|DBG_DCB|DBG_PARSE|DBG_SGPARANOIA|DBG=
_FIFO|DBG_PIO|DBG_TRACE|DBG_TRACEALL)*/
+/*#define DEBUG_MASK (DBG_0|DBG_1|DBG_DCB|DBG_PARSE|DBG_SGPARANOIA|DBG=
_FIFO|DBG_PIO)*/
 /*#define  DEBUG_MASK	DBG_0*/
=20
=20
@@ -137,61 +134,6 @@
 #endif
=20
=20
-/*
- * Memory allocation debugging
- * Just reports when memory is allocated and/or released.
- */
-#if debug_enabled(DBG_MALLOC)
-inline void *dc395x_kmalloc(size_t sz, int fl)
-{
-	void *ptr =3D kmalloc(sz, fl);
-	dprintkl(KERN_DEBUG, "Alloc %i bytes @ %p w/ fl %08x\n", sz, ptr, fl)=
;
-	return ptr;
-}
-inline void dc395x_kfree(const void *adr)
-{
-	dprintkl(KERN_DEBUG, "Free mem @ %p\n", adr);
-	kfree(adr);
-}
-#else
-#define dc395x_kmalloc(sz, fl)	kmalloc(sz, fl)
-#define dc395x_kfree(adr) kfree(adr)
-#endif
-
-
-/*
- * Debug/trace stuff
- */
-#if debug_enabled(DBG_TRACEALL)
-# define TRACEOUTALL(x...) printk ( x)
-#else
-# define TRACEOUTALL(x...) do {} while (0)
-#endif
-
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-# define DEBUGTRACEBUFSZ 512
-static char tracebuf[64];
-# define TRACEPRINTF(x...) \
-	do { \
-		int ln =3D sprintf(tracebuf, x); \
-		if (srb->debugpos + ln >=3D DEBUGTRACEBUFSZ) { \
-			srb->debugtrace[srb->debugpos] =3D 0; \
-			srb->debugpos =3D DEBUGTRACEBUFSZ/5; \
-			srb->debugtrace[srb->debugpos++] =3D '>'; \
-		} \
-		sprintf(srb->debugtrace + srb->debugpos, "%s", tracebuf); \
-		srb->debugpos +=3D ln - 1; \
-	} while (0)
-# define TRACEOUT(x...) printk (x)
-#else
-# define TRACEPRINTF(x...) do {} while (0)
-# define TRACEOUT(x...) do {} while (0)
-#endif
-
-
-/*--------------------------------------------------------------------=
-------
- ---------------------------------------------------------------------=
------*/
-
 #ifndef PCI_VENDOR_ID_TEKRAM
 #define PCI_VENDOR_ID_TEKRAM                    0x1DE1	/* Vendor ID   =
 */
 #endif
@@ -315,11 +257,6 @@
 	u8 flag;
=20
 	u8 scsi_phase;
-
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-	u16 debugpos;
-	char *debugtrace;
-#endif
 };
=20
 struct DeviceCtlBlk {
@@ -899,7 +836,6 @@
 		struct ScsiReqBlk *srb)
 {
 	dprintkdbg(DBG_0, "srb_waiting_to_going_move: srb %p\n", srb);
-	TRACEPRINTF("WtG *");
 	list_move(&srb->list, &dcb->srb_going_list);
 }
=20
@@ -1119,10 +1055,6 @@
 				srb->total_xfer_length, cmd->request_buffer,
 			        cmd->use_sg, srb->segment_x[0].address);
 	}
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-	srb->debugpos =3D 0;
-	srb->debugtrace =3D 0;
-#endif
 }
=20
=20
@@ -1284,7 +1216,6 @@
 		    ("              State %04x Status %02x Phase %02x (%sconn.)\n",
 		     srb->state, srb->status, srb->scsi_phase,
 		     (acb->active_dcb) ? "" : "not");
-		TRACEOUT("        %s\n", srb->debugtrace);
 	}
 	dprintkl(KERN_INFO, "dump: SCSI block\n");
 	printk
@@ -1338,12 +1269,6 @@
 		       "Clr FIFO (%i bytes) on phase %02x in %s\n",
 			fifocnt & 0x3f, lines, txt);
 #endif
-#if debug_enabled(DBG_TRACE)  =20
-	if (acb->active_dcb && acb->active_dcb->active_srb) {
-		struct ScsiReqBlk *srb =3D acb->active_dcb->active_srb;
-		TRACEPRINTF("#*");
-	}
-#endif
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRFIFO);
 }
=20
@@ -1497,7 +1422,6 @@
 	*ptr++ =3D dcb->sync_offset;	/* Transfer period (max. REQ/ACK dist) *=
/
 	srb->msg_count +=3D 5;
 	srb->state |=3D SRB_DO_SYNC_NEGO;
-	TRACEPRINTF("S *");
 }
=20
=20
@@ -1521,7 +1445,6 @@
 	*ptr++ =3D wide;
 	srb->msg_count +=3D 4;
 	srb->state |=3D SRB_DO_WIDE_NEGO;
-	TRACEPRINTF("W *");
 }
=20
=20
@@ -1558,7 +1481,6 @@
 	}
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 	srb =3D acb->active_dcb->active_srb;
-	TRACEPRINTF("N/TO *");
 	disconnect(acb);
 	DC395x_UNLOCK_IO(acb->scsi_host, flags);
 }
@@ -1578,7 +1500,6 @@
 	s_stat =3D DC395x_read8(acb, TRM_S1040_SCSI_SIGNAL);
 	s_stat2 =3D 0;
 	s_stat2 =3D DC395x_read16(acb, TRM_S1040_SCSI_STATUS);
-	TRACEPRINTF("Start %02x *", s_stat);
 #if 1
 	if (s_stat & 0x20 /* s_stat2 & 0x02000 */ ) {
 		dprintkdbg(DBG_KG,
@@ -1595,7 +1516,6 @@
 		 * Instead let this fail and have the timer make sure the command is=
=20
 		 * tried again after a short time
 		 */
-		TRACEPRINTF("^*");
 		/*selto_timer (acb); */
 		/*monitor_next_irq =3D 1; */
 		return 1;
@@ -1607,17 +1527,12 @@
 		dprintkl(KERN_DEBUG, "While another one (%li) is active!!\n",
 		       (acb->active_dcb->active_srb ? acb->active_dcb->
 			active_srb->cmd->pid : 0));
-		TRACEOUT(" %s\n", srb->debugtrace);
-		if (acb->active_dcb->active_srb)
-			TRACEOUT(" %s\n",
-				 acb->active_dcb->active_srb->debugtrace);
 		return 1;
 	}
 	if (DC395x_read16(acb, TRM_S1040_SCSI_STATUS) & SCSIINTERRUPT) {
 		dprintkdbg(DBG_KG,
 		       "StartSCSI failed (busy) for pid %li(%02i-%i)\n",
 		       srb->cmd->pid, dcb->target_id, dcb->target_lun);
-		TRACEPRINTF("=B0*");
 		return 1;
 	}
 	/* Allow starting of SCSI commands half a second before we allow the =
mid-level
@@ -1704,8 +1619,6 @@
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, tag_number);
 		dcb->tag_mask |=3D tag_mask;
 		srb->tag_number =3D tag_number;
-		TRACEPRINTF("Tag %i *", tag_number);
-
 		scsicommand =3D SCMD_SEL_ATN3;
 		srb->state =3D SRB_START_;
 	}
@@ -1761,7 +1674,6 @@
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL,
 			       DO_DATALATCH | DO_HWRESELECT);
 		/* SCSI command */
-		TRACEPRINTF("%02x *", scsicommand);
 		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, scsicommand);
 	}
 	return return_code;
@@ -1938,7 +1850,6 @@
=20
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's im=
portant for atn stop */
 	srb->state &=3D ~SRB_MSGOUT;
-	TRACEPRINTF("MOP0 *");
 }
=20
=20
@@ -1949,7 +1860,6 @@
 	u8 *ptr;
=20
 	dprintkdbg(DBG_0, "msgout_phase1 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("MOP1*");
 	clear_fifo(acb, "MOP1");
 	if (!(srb->state & SRB_MSGOUT)) {
 		srb->state |=3D SRB_MSGOUT;
@@ -1961,17 +1871,11 @@
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, MSG_NOP);
 		DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's i=
mportant for atn stop */
 		DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
-		TRACEPRINTF("\\*");
-		TRACEOUT(" %s\n", srb->debugtrace);
 		return;
 	}
 	ptr =3D (u8 *)srb->msgout_buf;
-	TRACEPRINTF("(*");
-	for (i =3D 0; i < srb->msg_count; i++) {
-		TRACEPRINTF("%02x *", *ptr);
+	for (i =3D 0; i < srb->msg_count; i++)
 		DC395x_write8(acb, TRM_S1040_SCSI_FIFO, *ptr++);
-	}
-	TRACEPRINTF(")*");
 	srb->msg_count =3D 0;
 	if (/*(dcb->flag & ABORT_DEV_) && */
 	    (srb->msgout_buf[0] =3D=3D MSG_ABORT))
@@ -1980,7 +1884,6 @@
 	/*1.25 */
 	/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_DATALATCH); *//* it's im=
portant for atn stop */
 	/* SCSI command */
-	/*TRACEPRINTF (".*"); */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
 }
=20
@@ -1989,7 +1892,6 @@
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "command_phase0 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("COP0 *");
 	/*1.25 */
 	/*clear_fifo(acb, COP0); */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
@@ -2004,7 +1906,6 @@
 	u16 i;
=20
 	dprintkdbg(DBG_0, "command_phase1 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("COP1*");
 	clear_fifo(acb, "COP1");
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_CLRATN);
 	if (!(srb->flag & AUTO_REQSENSE)) {
@@ -2028,7 +1929,6 @@
 	/* it's important for atn stop */
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);
 	/* SCSI command */
-	TRACEPRINTF(".*");
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_FIFO_OUT);
 }
=20
@@ -2152,7 +2052,6 @@
 static void cleanup_after_transfer(struct AdapterCtlBlk *acb,
 		struct ScsiReqBlk *srb)
 {
-	TRACEPRINTF(" Cln*");
 	/*DC395x_write8 (TRM_S1040_DMA_STATUS, FORCEDMACOMP); */
 	if (DC395x_read16(acb, TRM_S1040_DMA_COMMAND) & 0x0001) {	/* read */
 		if (!(DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x40))
@@ -2184,7 +2083,6 @@
 	u32 d_left_counter =3D 0;
=20
 	dprintkdbg(DBG_0, "data_out_phase0 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("DOP0*");
=20
 	/*
 	 * KG: We need to drain the buffers before we draw any conclusions!
@@ -2260,7 +2158,6 @@
 		if (srb->total_xfer_length > DC395x_LASTPIO)
 			d_left_counter +=3D
 			    DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
-		TRACEPRINTF("%06x *", d_left_counter);
=20
 		/* Is this a good idea? */
 		/*clear_fifo(acb, "DOP1"); */
@@ -2337,7 +2234,6 @@
 		cleanup_after_transfer(acb, srb);
 	}
 #endif
-	TRACEPRINTF(".*");
 }
=20
=20
@@ -2346,11 +2242,9 @@
 {
 	dprintkdbg(DBG_0, "data_out_phase1 (#%li)\n", srb->cmd->pid);
 	/*1.25 */
-	TRACEPRINTF("DOP1*");
 	clear_fifo(acb, "DOP1");
 	/* do prepare befor transfer when data out phase */
 	data_io_transfer(acb, srb, XFERDATAOUT);
-	TRACEPRINTF(".*");
 }
=20
=20
@@ -2362,7 +2256,6 @@
 	u32 d_left_counter =3D 0;
=20
 	dprintkdbg(DBG_0, "data_in_phase0 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("DIP0*");
=20
 	/*
 	 * KG: DataIn is much more tricky than DataOut. When the device is fi=
nished
@@ -2570,7 +2463,6 @@
 	/*DC395x_write8 (TRM_S1040_DMA_CONTROL, CLRXFIFO | ABORTXFER); */
 	/*clear_fifo(acb, "DIP0"); */
 	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
-	TRACEPRINTF(".*");
 }
=20
=20
@@ -2582,10 +2474,8 @@
 	/*clear_fifo(acb, "DIP1"); */
 	/* Allow data in! */
 	/*DC395x_write16(TRM_S1040_SCSI_CONTROL, DO_DATALATCH); */
-	TRACEPRINTF("DIP1:*");
 	/* do prepare before transfer when data in phase */
 	data_io_transfer(acb, srb, XFERDATAIN);
-	TRACEPRINTF(".*");
 }
=20
=20
@@ -2599,8 +2489,6 @@
 	       ((io_dir & DMACMD_DIR) ? 'r' : 'w'), srb->cmd->pid,
 	       srb->total_xfer_length, srb->sg_index,
 	       srb->sg_count);
-	TRACEPRINTF("%05x(%i/%i)*", srb->total_xfer_length,
-		    srb->sg_index, srb->sg_count);
 	if (srb =3D=3D acb->tmp_srb)
 		dprintkl(KERN_ERR, "Using tmp_srb in DataPhase!\n");
=20
@@ -2756,7 +2644,6 @@
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase0 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("STP0 *");
 	srb->target_status =3D DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 	srb->end_message =3D DC395x_read8(acb, TRM_S1040_SCSI_FIFO);	/* get m=
essage */
 	srb->state =3D SRB_COMPLETED;
@@ -2773,8 +2660,6 @@
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "status_phase1 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("STP1 *");
-
 	srb->state =3D SRB_STATUS;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's im=
portant for atn stop */
 	/* SCSI command */
@@ -2826,7 +2711,6 @@
 	dprintkl(KERN_INFO,
 	       "Reject message %02x from %02i-%i\n", srb->msgin_buf[0],
 	       srb->dcb->target_id, srb->dcb->target_lun);
-	TRACEPRINTF("\\*");
 }
=20
=20
@@ -2843,7 +2727,6 @@
 	   if (srb->dcb)
 	   srb->dcb->flag &=3D ~ABORT_DEV_;
 	 */
-	TRACEPRINTF("#*");
 }
=20
=20
@@ -2881,20 +2764,6 @@
 	if (!(srb->state & SRB_DISCONNECT))
 		goto mingx0;
=20
-	/* Tag found */
-	{
-		struct ScsiReqBlk *last_srb;
-		       =20
-		TRACEPRINTF("[%s]*", dcb->active_srb->debugtrace);
-		TRACEPRINTF("RTag*");
-		/* Just for debugging ... */
-	=09
-		last_srb =3D srb;
-		srb =3D dcb->active_srb;
-		TRACEPRINTF("Found.*");
-		srb =3D last_srb;
-	}
-
 	memcpy(srb->msgin_buf, dcb->active_srb->msgin_buf, acb->msg_len);
 	srb->state |=3D dcb->active_srb->state;
 	srb->state |=3D SRB_DATA_XFER;
@@ -2909,7 +2778,6 @@
 	srb->msgout_buf[0] =3D MSG_ABORT_TAG;
 	srb->msg_count =3D 1;
 	DC395x_ENABLE_MSGOUT;
-	TRACEPRINTF("?*");
 	dprintkl(KERN_DEBUG, "Unknown tag received: %i: abort !!\n", tag);
 	return srb;
 }
@@ -2931,7 +2799,6 @@
 	struct DeviceCtlBlk *dcb =3D srb->dcb;
=20
 	dprintkl(KERN_DEBUG, "Target %02i: No sync transfers\n", dcb->target_=
id);
-	TRACEPRINTF("!S *");
 	dcb->sync_mode &=3D ~(SYNC_NEGO_ENABLE);
 	dcb->sync_mode |=3D SYNC_NEGO_DONE;
 	/*dcb->sync_period &=3D 0; */
@@ -2998,7 +2865,6 @@
 	       ((fact % dcb->min_nego_period) * 10 +
 		dcb->min_nego_period / 2) / dcb->min_nego_period);
=20
-	TRACEPRINTF("S%i *", dcb->min_nego_period << 2);
 	if (!(srb->state & SRB_DO_SYNC_NEGO)) {
 		/* Reply with corrected SDTR Message */
 		dprintkl(KERN_DEBUG, " .. answer w/  %ins %i\n",
@@ -3030,7 +2896,6 @@
=20
 	dprintkdbg(DBG_KG, "WDTR got rejected from target %02i\n",
 	       dcb->target_id);
-	TRACEPRINTF("!W *");
 	dcb->sync_period &=3D ~WIDE_SYNC;
 	dcb->sync_mode &=3D ~(WIDE_NEGO_ENABLE);
 	dcb->sync_mode |=3D WIDE_NEGO_DONE;
@@ -3069,7 +2934,6 @@
 	else
 		dcb->sync_period &=3D ~WIDE_SYNC;
 	srb->state &=3D ~SRB_DO_WIDE_NEGO;
-	TRACEPRINTF("W%i *", (dcb->sync_period & WIDE_SYNC ? 1 : 0));
 	/*dcb->sync_mode &=3D ~(WIDE_NEGO_ENABLE+WIDE_NEGO_DONE); */
 	dprintkdbg(DBG_KG,
 	       "Wide transfers (%i bit) negotiated with target %02i\n",
@@ -3102,12 +2966,9 @@
 	struct DeviceCtlBlk *dcb =3D acb->active_dcb;
=20
 	dprintkdbg(DBG_0, "msgin_phase0 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("MIP0*");
=20
 	srb->msgin_buf[acb->msg_len++] =3D DC395x_read8(acb, TRM_S1040_SCSI_F=
IFO);
 	if (msgin_completed(srb->msgin_buf, acb->msg_len)) {
-		TRACEPRINTF("(%02x)*", srb->msgin_buf[0]);
-
 		/* Now eval the msg */
 		switch (srb->msgin_buf[0]) {
 		case DISCONNECT:
@@ -3117,7 +2978,6 @@
 		case SIMPLE_QUEUE_TAG:
 		case HEAD_OF_QUEUE_TAG:
 		case ORDERED_QUEUE_TAG:
-			TRACEPRINTF("(%02x)*", srb->msgin_buf[1]);
 			srb =3D
 			    msgin_qtag(acb, dcb,
 					      srb->msgin_buf[1]);
@@ -3141,7 +3001,6 @@
 			break;
=20
 		case EXTENDED_MESSAGE:
-			TRACEPRINTF("(%02x)*", srb->msgin_buf[2]);
 			/* SDTR */
 			if (srb->msgin_buf[1] =3D=3D 3
 			    && srb->msgin_buf[2] =3D=3D EXTENDED_SDTR) {
@@ -3168,10 +3027,9 @@
 			/* nothing has to be done */
 		case COMMAND_COMPLETE:
 			break;
-
 			/*
-			 * SAVE POINTER may be ignored as we have the struct ScsiReqBlk* as=
sociated with the
-			 * scsi command. Thanks, G=E9rard, for pointing it out.
+			 * SAVE POINTER may be ignored as we have the struct
+			 * ScsiReqBlk* associated with the scsi command.
 			 */
 		case SAVE_POINTERS:
 			dprintkdbg(DBG_0, "SAVE POINTER message received (pid %li: rem.%i) =
=2E.. ignore :-(\n",
@@ -3196,7 +3054,6 @@
 		default:
 			if (srb->msgin_buf[0] & IDENTIFY_BASE) {
 				dprintkl(KERN_DEBUG, "Identify Message received?\n");
-				/*TRACEOUT (" %s\n", srb->debugtrace); */
 				srb->msg_count =3D 1;
 				srb->msgout_buf[0] =3D dcb->identify_msg;
 				DC395x_ENABLE_MSGOUT;
@@ -3204,22 +3061,12 @@
 				/*break; */
 			}
 			msgin_reject(acb, srb);
-			TRACEOUT(" %s\n", srb->debugtrace);
 		}
-		TRACEPRINTF(".*");
=20
 		/* Clear counter and MsgIn state */
 		srb->state &=3D ~SRB_MSGIN;
 		acb->msg_len =3D 0;
 	}
-
-	/*1.25 */
-	if ((*pscsi_status & PHASEMASK) !=3D PH_MSG_IN)
-#if 0
-		clear_fifo(acb, "MIP0_");
-#else
-		TRACEPRINTF("N/Cln *");
-#endif
 	*pscsi_status =3D PH_BUS_FREE;
 	DC395x_write16(acb, TRM_S1040_SCSI_CONTROL, DO_DATALATCH);	/* it's im=
portant ... you know! */
 	DC395x_write8(acb, TRM_S1040_SCSI_COMMAND, SCMD_MSGACCEPT);
@@ -3230,7 +3077,6 @@
 		u16 *pscsi_status)
 {
 	dprintkdbg(DBG_0, "msgin_phase1 (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("MIP1 *");
 	clear_fifo(acb, "MIP1");
 	DC395x_write32(acb, TRM_S1040_SCSI_COUNTER, 1);
 	if (!(srb->state & SRB_MSGIN)) {
@@ -3246,14 +3092,12 @@
 static void nop0(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	/*TRACEPRINTF("NOP0 *"); */
 }
=20
=20
 static void nop1(struct AdapterCtlBlk *acb, struct ScsiReqBlk *srb,
 		u16 *pscsi_status)
 {
-	/*TRACEPRINTF("NOP1 *"); */
 }
=20
=20
@@ -3299,7 +3143,6 @@
 	srb =3D dcb->active_srb;
 	acb->active_dcb =3D NULL;
 	dprintkdbg(DBG_0, "disconnect (#%li)\n", srb->cmd->pid);
-	TRACEPRINTF("DISC *");
=20
 	srb->scsi_phase =3D PH_BUS_FREE;	/* initial phase */
 	clear_fifo(acb, "Disc");
@@ -3330,12 +3173,9 @@
 				dprintkl(KERN_DEBUG, "Unexpected Disconnection (pid %li)!\n",
 				       srb->cmd->pid);
 				srb->target_status =3D SCSI_STAT_SEL_TIMEOUT;
-				TRACEPRINTF("UnExpD *");
-				TRACEOUT("%s\n", srb->debugtrace);
 				goto disc1;
 			} else {
 				/* Normal selection timeout */
-				TRACEPRINTF("SlTO *");
 				dprintkdbg(DBG_KG,
 				       "Disc: SelTO (#%li) for dev %02i-%i\n",
 				       srb->cmd->pid, dcb->target_id,
@@ -3358,17 +3198,10 @@
 			 * SRB_DISCONNECT (This is what we expect!)
 			 */
 			/* dprintkl(KERN_DEBUG, "DoWaitingSRB (#%li)\n", srb->cmd->pid); */
-			TRACEPRINTF("+*");
 			if (bval & 0x40) {
 				dprintkdbg(DBG_0, "Debug: DISC: SCSI bus stat %02x: ACK set! Other=
 controllers?\n",
 					bval);
 				/* It could come from another initiator, therefore don't do much !=
 */
-				TRACEPRINTF("ACK(%02x) *", bval);
-				/*dump_register_info (acb, dcb, srb); */
-				/*TRACEOUT (" %s\n", srb->debugtrace); */
-				/*dcb->flag |=3D ABORT_DEV_; */
-				/*enable_msgout_abort (acb, srb); */
-				/*DC395x_write16 (TRM_S1040_SCSI_CONTROL, DO_CLRFIFO | DO_CLRATN |=
 DO_HWRESELECT); */
 			} else
 				waiting_process_next(acb);
 		} else if (srb->state & SRB_COMPLETED) {
@@ -3414,8 +3247,6 @@
 			       srb->cmd->pid, dcb->target_id,
 			       dcb->target_lun, rsel_tar_lun_id,
 			       DC395x_read16(acb, TRM_S1040_SCSI_STATUS));
-			TRACEPRINTF("ArbLResel!*");
-			/*TRACEOUT (" %s\n", srb->debugtrace); */
 			arblostflag =3D 1;
 			/*srb->state |=3D SRB_DISCONNECT; */
=20
@@ -3448,21 +3279,11 @@
 		       dcb->target_id, dcb->target_lun);
=20
 	if (dcb->sync_mode & EN_TAG_QUEUEING /*&& !arblostflag */) {
-		struct ScsiReqBlk *oldSRB =3D srb;
 		srb =3D acb->tmp_srb;
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-		srb->debugpos =3D 0;
-		srb->debugtrace[0] =3D 0;
-#endif
 		dcb->active_srb =3D srb;
-		if (oldSRB)
-			TRACEPRINTF("ArbLResel(%li):*", oldSRB->cmd->pid);
-		/*if (arblostflag) dprintkl(KERN_DEBUG, "Reselect: Wait for Tag ... =
\n"); */
 	} else {
 		/* There can be only one! */
 		srb =3D dcb->active_srb;
-		if (srb)
-			TRACEPRINTF("RSel *");
 		if (!srb || !(srb->state & SRB_DISCONNECT)) {
 			/*
 			 * abort command
@@ -3482,7 +3303,6 @@
 				srb->state =3D SRB_DATA_XFER;
=20
 		}
-		/*if (arblostflag) TRACEOUT (" %s\n", srb->debugtrace); */
 	}
 	srb->scsi_phase =3D PH_BUS_FREE;	/* initial phase */
=20
@@ -3606,8 +3426,6 @@
 	struct ScsiInqData *ptr;
 	int dir;
=20
-	TRACEPRINTF("DONE *");
-
 	dir =3D scsi_to_pci_dma_dir(cmd->sc_data_direction);
 	if (cmd->use_sg) {
 		struct scatterlist* sg =3D (struct scatterlist *)cmd->request_buffer=
;
@@ -3809,12 +3627,10 @@
 	if (debug_enabled(DBG_KG)) {
 		printk(" 0x%08x\n", cmd->result);
 	}
-	TRACEPRINTF("%08x(%li)*", cmd->result, jiffies);
 	pci_unmap_srb(acb, srb);
 	/*DC395x_UNLOCK_ACB_NI; */
 	cmd->scsi_done(cmd);
 	/*DC395x_LOCK_ACB_NI; */
-	TRACEOUTALL(KERN_INFO " %s\n", srb->debugtrace);
=20
 	waiting_process_next(acb);
 }
@@ -3839,16 +3655,8 @@
 			p =3D srb->cmd;
 			dir =3D scsi_to_pci_dma_dir(p->sc_data_direction);
 			result =3D MK_RES(0, did_flag, 0, 0);
-
-			/*result =3D MK_RES(0,DID_RESET,0,0); */
-			TRACEPRINTF("Reset(%li):%08x*", jiffies, result);
-			printk(" (G)");
-#if 1				/*ndef DC395x_DEBUGTRACE */
-			printk("%li(%02i-%i) ", p->pid,
+			printk("G:%li(%02i-%i) ", p->pid,
 			       p->device->id, p->device->lun);
-#endif
-			TRACEOUT("%s\n", srb->debugtrace);
-
 			srb_going_remove(dcb, srb);
 			free_tag(dcb, srb);
 			srb_free_insert(acb, srb);
@@ -3877,16 +3685,10 @@
 			p =3D srb->cmd;
=20
 			result =3D MK_RES(0, did_flag, 0, 0);
-			TRACEPRINTF("Reset(%li):%08x*", jiffies, result);
-			printk(" (W)");
-#if 1				/*ndef DC395x_DEBUGTRACE */
-			printk("%li(%i-%i)", p->pid, p->device->id,
+			printk("W:%li(%i-%i)", p->pid, p->device->id,
 			       p->device->lun);
-#endif
-			TRACEOUT("%s\n", srb->debugtrace);
 			srb_waiting_remove(dcb, srb);
 			srb_free_insert(acb, srb);
-
 			p->result =3D result;
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
@@ -3999,7 +3801,6 @@
 	dprintkdbg(DBG_KG,
 	       "request_sense for pid %li, target %02i-%i\n",
 	       cmd->pid, cmd->device->id, cmd->device->lun);
-	TRACEPRINTF("RqSn*");
 	srb->flag |=3D AUTO_REQSENSE;
 	srb->adapter_status =3D 0;
 	srb->target_status =3D 0;
@@ -4030,11 +3831,9 @@
 		dprintkl(KERN_DEBUG,
 		       "Request Sense failed for pid %li (%02i-%i)!\n",
 		       srb->cmd->pid, dcb->target_id, dcb->target_lun);
-		TRACEPRINTF("?*");
 		srb_going_to_waiting_move(dcb, srb);
 		waiting_set_timer(acb, HZ / 100);
 	}
-	TRACEPRINTF(".*");
 }
=20
=20
@@ -4058,7 +3857,7 @@
 	u8 period_index =3D eeprom->target[target].period & 0x07;
 	struct DeviceCtlBlk *dcb;
=20
-	dcb =3D dc395x_kmalloc(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
+	dcb =3D kmalloc(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
 	dprintkdbg(DBG_0, "device_alloc: device %p\n", dcb);
 	if (!dcb)
 		return NULL;
@@ -4193,7 +3992,7 @@
 		return;
 	}
 	adapter_remove_device(acb, dcb);
-	dc395x_kfree(dcb);
+	kfree(dcb);
 }
=20
=20
@@ -4570,60 +4369,6 @@
 }
=20
=20
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-/*
- * Memory for trace buffers
- */
-static void free_tracebufs(struct AdapterCtlBlk *acb)
-{
-	int i;
-	const unsigned bufs_per_page =3D PAGE_SIZE / DEBUGTRACEBUFSZ;
-
-	for (i =3D 0; i < srb_idx; i +=3D bufs_per_page)
-		if (acb->srb_array[i].debugtrace)
-			dc395x_kfree(acb->srb_array[i].debugtrace);
-}
-
-
-static int alloc_tracebufs(struct AdapterCtlBlk *acb)
-{
-	const unsigned mem_needed =3D
-	    (DC395x_MAX_SRB_CNT + 1) * DEBUGTRACEBUFSZ;
-	int pages =3D (mem_needed + (PAGE_SIZE - 1)) / PAGE_SIZE;
-	const unsigned bufs_per_page =3D PAGE_SIZE / DEBUGTRACEBUFSZ;
-	int srb_idx =3D 0;
-	unsigned i =3D 0;
-	unsigned char *ptr;
-
-	for (i =3D 0; i < DC395x_MAX_SRB_CNT; i++)
-		acb->srb_array[i].debugtrace =3D NULL;
-
-	while (pages--) {
-		ptr =3D dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!ptr) {
-			free_tracebufs(acb);
-			return 1;
-		}
-		/*dprintkl(KERN_DEBUG, "Alloc %li bytes at %p for tracebuf %i\n", */
-		/*      PAGE_SIZE, ptr, srb_idx); */
-		i =3D 0;
-		while (i < bufs_per_page && srb_idx < DC395x_MAX_SRB_CNT)
-			acb->srb_array[srb_idx++].debugtrace =3D
-			    ptr + (i++ * DEBUGTRACEBUFSZ);
-	}
-	if (i < bufs_per_page) {
-		acb->srb.debugtrace =3D ptr + (i * DEBUGTRACEBUFSZ);
-		acb->srb.debugtrace[0] =3D 0;
-	} else
-		dprintkl(KERN_DEBUG, "No space for tmsrb tracebuf reserved?!\n");
-	return 0;
-}
-#else
-static void free_tracebufs(struct AdapterCtlBlk *acb) {}
-static int alloc_tracebufs(struct AdapterCtlBlk *acb) { return 0; }
-#endif
-
-
 /* Free SG tables */
 static void adapter_sg_tables_free(struct AdapterCtlBlk *acb)
 {
@@ -4632,7 +4377,7 @@
=20
 	for (i =3D 0; i < DC395x_MAX_SRB_CNT; i +=3D srbs_per_page)
 		if (acb->srb_array[i].segment_x)
-			dc395x_kfree(acb->srb_array[i].segment_x);
+			kfree(acb->srb_array[i].segment_x);
 }
=20
=20
@@ -4654,7 +4399,7 @@
=20
 	dprintkdbg(DBG_1, "Allocate %i pages for SG tables\n", pages);
 	while (pages--) {
-		ptr =3D (struct SGentry *)dc395x_kmalloc(PAGE_SIZE, GFP_KERNEL);
+		ptr =3D (struct SGentry *)kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!ptr) {
 			adapter_sg_tables_free(acb);
 			return 1;
@@ -4918,10 +4663,6 @@
 		dprintkl(KERN_DEBUG, "Memory allocation for SG tables failed\n");
 		goto failed;
 	}
-	if (alloc_tracebufs(acb)) {
-		dprintkl(KERN_DEBUG, "Memory allocation for trace buffers failed\n")=
;
-		goto failed;
-	}
 	adapter_init_scsi_host(acb->scsi_host);
 	adapter_init_chip(acb);
 	set_basic_config(acb);
@@ -4939,7 +4680,6 @@
 	if (acb->io_port_base)
 		release_region(acb->io_port_base, acb->io_port_len);
 	adapter_sg_tables_free(acb);
-	free_tracebufs(acb);
=20
 	return 1;
 }
@@ -4996,7 +4736,6 @@
 		release_region(acb->io_port_base, acb->io_port_len);
=20
 	adapter_sg_tables_free(acb);
-	free_tracebufs(acb);
 }
=20
=20
@@ -5107,11 +4846,7 @@
 				dcb->target_id, dcb->target_lun,
 				list_size(&dcb->srb_going_list));
 		list_for_each_entry(srb, &dcb->srb_going_list, list)
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-			SPRINTF("\n  %s", srb->debugtrace);
-#else
 			SPRINTF(" %li", srb->cmd->pid);
-#endif
 		if (!list_empty(&dcb->srb_waiting_list) || !list_empty(&dcb->srb_goi=
ng_list))
 			SPRINTF("\n");
 	}


--=20
 Jamie Lenehan <lenehan@twibble.org>
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
