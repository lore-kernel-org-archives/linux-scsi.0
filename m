From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [RFC][PATCH] SCSI tape log message fixes
Date: Sat, 3 Apr 2004 13:44:45 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404031334490.1131@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:43973 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261680AbUDCKor (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Apr 2004 05:44:47 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hironobu Ishii <ishii.hironobu@jp.fujitsu.com>

This patch changes the st console/log messages:

- __GFP_NOWARN added to buffer allocation to suppress useless messages 
  when having to use smaller than default segments
- move log message from enlarge_buffer() to caller so that the tape name 
  can be printed and remove some debugging messages; now the st messages
  should include drive name where applicable (a problem reported by 
  Hironobu Ishii)
- setting options is logged only when debugging; the most important 
  options are now seen in sysfs
 
Kai

-------------------------------------8<----------------------------------
--- linux-2.6.5-rc3-bk3/drivers/scsi/st.c	2004-03-30 18:49:16.000000000 +0300
+++ linux-2.6.5-rc3-bk3-k1/drivers/scsi/st.c	2004-04-03 12:59:49.000000000 +0300
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20040318";
+static char *verstr = "20040403";
 
 #include <linux/module.h>
 
@@ -1031,7 +1031,8 @@
 
 	/* See that we have at least a one page buffer available */
 	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
-		printk(KERN_WARNING "%s: Can't allocate tape buffer.\n", name);
+		printk(KERN_WARNING "%s: Can't allocate one page tape buffer.\n",
+		       name);
 		retval = (-EOVERFLOW);
 		goto err_out;
 	}
@@ -1318,6 +1319,8 @@
 			bufsize = count;
 		if (bufsize > STbp->buffer_size &&
 		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
+			printk(KERN_WARNING "%s: Can't allocate %d byte tape buffer.\n",
+			       tape_name(STp), bufsize);
 			retval = (-EOVERFLOW);
 			goto out;
 		}
@@ -1960,26 +1963,29 @@
 

 
 
+DEB(
 /* Set the driver options */
 static void st_log_options(Scsi_Tape * STp, ST_mode * STm, char *name)
 {
-	printk(KERN_INFO
-	       "%s: Mode %d options: buffer writes: %d, async writes: %d, read ahead: %d\n",
-	       name, STp->current_mode, STm->do_buffer_writes, STm->do_async_writes,
-	       STm->do_read_ahead);
-	printk(KERN_INFO
-	       "%s:    can bsr: %d, two FMs: %d, fast mteom: %d, auto lock: %d,\n",
-	       name, STp->can_bsr, STp->two_fm, STp->fast_mteom, STp->do_auto_lock);
-	printk(KERN_INFO
-	       "%s:    defs for wr: %d, no block limits: %d, partitions: %d, s2 log: %d\n",
-	       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_partitions,
-	       STp->scsi2_logical);
-	printk(KERN_INFO
-	       "%s:    sysv: %d nowait: %d\n", name, STm->sysv, STp->immediate);
-        DEB(printk(KERN_INFO
-                   "%s:    debugging: %d\n",
-                   name, debugging);)
+	if (debugging) {
+		printk(KERN_INFO
+		       "%s: Mode %d options: buffer writes: %d, async writes: %d, read ahead: %d\n",
+		       name, STp->current_mode, STm->do_buffer_writes, STm->do_async_writes,
+		       STm->do_read_ahead);
+		printk(KERN_INFO
+		       "%s:    can bsr: %d, two FMs: %d, fast mteom: %d, auto lock: %d,\n",
+		       name, STp->can_bsr, STp->two_fm, STp->fast_mteom, STp->do_auto_lock);
+		printk(KERN_INFO
+		       "%s:    defs for wr: %d, no block limits: %d, partitions: %d, s2 log: %d\n",
+		       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_partitions,
+		       STp->scsi2_logical);
+		printk(KERN_INFO
+		       "%s:    sysv: %d nowait: %d\n", name, STm->sysv, STp->immediate);
+		printk(KERN_INFO "%s:    debugging: %d\n",
+		       name, debugging);
+	}
 }
+	)
 
 
 static int st_set_options(Scsi_Tape *STp, long options)
@@ -2017,8 +2023,8 @@
 		STp->scsi2_logical = (options & MT_ST_SCSI2LOGICAL) != 0;
 		STp->immediate = (options & MT_ST_NOWAIT) != 0;
 		STm->sysv = (options & MT_ST_SYSV) != 0;
-		DEB( debugging = (options & MT_ST_DEBUGGING) != 0; )
-		st_log_options(STp, STm, name);
+		DEB( debugging = (options & MT_ST_DEBUGGING) != 0;
+		     st_log_options(STp, STm, name); )
 	} else if (code == MT_ST_SETBOOLEANS || code == MT_ST_CLEARBOOLEANS) {
 		value = (code == MT_ST_SETBOOLEANS);
 		if ((options & MT_ST_BUFFER_WRITES) != 0)
@@ -2050,19 +2056,19 @@
 			STm->sysv = value;
                 DEB(
 		if ((options & MT_ST_DEBUGGING) != 0)
-			debugging = value; )
-		st_log_options(STp, STm, name);
+			debugging = value;
+			st_log_options(STp, STm, name); )
 	} else if (code == MT_ST_WRITE_THRESHOLD) {
 		/* Retained for compatibility */
 	} else if (code == MT_ST_DEF_BLKSIZE) {
 		value = (options & ~MT_ST_OPTIONS);
 		if (value == ~MT_ST_OPTIONS) {
 			STm->default_blksize = (-1);
-			printk(KERN_INFO "%s: Default block size disabled.\n", name);
+			DEBC( printk(KERN_INFO "%s: Default block size disabled.\n", name));
 		} else {
 			STm->default_blksize = value;
-			printk(KERN_INFO "%s: Default block size set to %d bytes.\n",
-			       name, STm->default_blksize);
+			DEBC( printk(KERN_INFO "%s: Default block size set to %d bytes.\n",
+			       name, STm->default_blksize));
 			if (STp->ready == ST_READY) {
 				STp->blksize_changed = FALSE;
 				set_mode_densblk(STp, STm);
@@ -2072,12 +2078,12 @@
 		value = (options & ~MT_ST_OPTIONS);
 		if ((value & MT_ST_SET_LONG_TIMEOUT) != 0) {
 			STp->long_timeout = (value & ~MT_ST_SET_LONG_TIMEOUT) * HZ;
-			printk(KERN_INFO "%s: Long timeout set to %d seconds.\n", name,
-			       (value & ~MT_ST_SET_LONG_TIMEOUT));
+			DEBC( printk(KERN_INFO "%s: Long timeout set to %d seconds.\n", name,
+			       (value & ~MT_ST_SET_LONG_TIMEOUT)));
 		} else {
 			STp->timeout = value * HZ;
-			printk(KERN_INFO "%s: Normal timeout set to %d seconds.\n",
-                               name, value);
+			DEBC( printk(KERN_INFO "%s: Normal timeout set to %d seconds.\n",
+				name, value) );
 		}
 	} else if (code == MT_ST_SET_CLN) {
 		value = (options & ~MT_ST_OPTIONS) & 0xff;
@@ -2096,12 +2102,12 @@
 		if (code == MT_ST_DEF_DENSITY) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
 				STm->default_density = (-1);
-				printk(KERN_INFO "%s: Density default disabled.\n",
-                                       name);
+				DEBC( printk(KERN_INFO "%s: Density default disabled.\n",
+                                       name));
 			} else {
 				STm->default_density = value & 0xff;
-				printk(KERN_INFO "%s: Density default set to %x\n",
-				       name, STm->default_density);
+				DEBC( printk(KERN_INFO "%s: Density default set to %x\n",
+				       name, STm->default_density));
 				if (STp->ready == ST_READY) {
 					STp->density_changed = FALSE;
 					set_mode_densblk(STp, STm);
@@ -2110,31 +2116,31 @@
 		} else if (code == MT_ST_DEF_DRVBUFFER) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
 				STp->default_drvbuffer = 0xff;
-				printk(KERN_INFO
-                                       "%s: Drive buffer default disabled.\n", name);
+				DEBC( printk(KERN_INFO
+                                       "%s: Drive buffer default disabled.\n", name));
 			} else {
 				STp->default_drvbuffer = value & 7;
-				printk(KERN_INFO
+				DEBC( printk(KERN_INFO
                                        "%s: Drive buffer default set to %x\n",
-				       name, STp->default_drvbuffer);
+				       name, STp->default_drvbuffer));
 				if (STp->ready == ST_READY)
 					st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer);
 			}
 		} else if (code == MT_ST_DEF_COMPRESSION) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
 				STm->default_compression = ST_DONT_TOUCH;
-				printk(KERN_INFO
-                                       "%s: Compression default disabled.\n", name);
+				DEBC( printk(KERN_INFO
+                                       "%s: Compression default disabled.\n", name));
 			} else {
 				if ((value & 0xff00) != 0) {
 					STp->c_algo = (value & 0xff00) >> 8;
-					printk(KERN_INFO "%s: Compression algorithm set to 0x%x.\n",
-					       name, STp->c_algo);
+					DEBC( printk(KERN_INFO "%s: Compression algorithm set to 0x%x.\n",
+					       name, STp->c_algo));
 				}
 				if ((value & 0xff) != 0xff) {
 					STm->default_compression = (value & 1 ? ST_YES : ST_NO);
-					printk(KERN_INFO "%s: Compression default set to %x\n",
-					       name, (value & 1));
+					DEBC( printk(KERN_INFO "%s: Compression default set to %x\n",
+					       name, (value & 1)));
 					if (STp->ready == ST_READY) {
 						STp->compression_changed = FALSE;
 						st_compression(STp, (STm->default_compression == ST_YES));
@@ -3465,7 +3471,7 @@
 	if (nbr <= 0)
 		return FALSE;
 
-	priority = GFP_KERNEL;
+	priority = GFP_KERNEL | __GFP_NOWARN;
 	if (need_dma)
 		priority |= GFP_DMA;
 	for (b_size = PAGE_SIZE, order=0;
@@ -3482,8 +3488,6 @@
 				order--;
 				continue;
 			}
-			printk(KERN_NOTICE "st: failed to enlarge buffer to %d bytes.\n",
-			       new_size);
 			DEB(STbuffer->buffer_size = got);
 			normalize_buffer(STbuffer);
 			return FALSE;
@@ -3495,9 +3499,6 @@
 		segs++;
 	}
 	STbuffer->b_data = page_address(STbuffer->frp[0].page);
-        DEBC(printk(ST_DEB_MSG
-                    "st: Succeeded to enlarge buffer at %p to %d bytes (segs %d->%d, %d).\n",
-                    STbuffer, got, STbuffer->orig_frp_segs, STbuffer->frp_segs, b_size));
 
 	return TRUE;
 }
@@ -3513,11 +3514,6 @@
 		__free_pages(STbuffer->frp[i].page, order);
 		STbuffer->buffer_size -= STbuffer->frp[i].length;
 	}
-        DEB(
-	if (debugging && STbuffer->orig_frp_segs < STbuffer->frp_segs)
-		printk(ST_DEB_MSG "st: Buffer at %p normalized to %d bytes (segs %d->%d).\n",
-		       STbuffer, STbuffer->buffer_size, STbuffer->frp_segs, STbuffer->orig_frp_segs);
-        ) /* end DEB */
 	STbuffer->frp_segs = STbuffer->orig_frp_segs;
 	STbuffer->frp_sg_current = 0;
 }
@@ -3547,11 +3543,9 @@
 		ubp += cnt;
 		offset = 0;
 	}
-	if (do_count) {		/* Should never happen */
-		printk(KERN_WARNING "st: append_to_buffer overflow (left %d).\n",
-		       do_count);
+	if (do_count) /* Should never happen */
 		return (-EIO);
-	}
+
 	return 0;
 }
 
@@ -3581,11 +3575,9 @@
 		ubp += cnt;
 		offset = 0;
 	}
-	if (do_count) {		/* Should never happen */
-		printk(KERN_WARNING "st: from_buffer overflow (left %d).\n",
-		       do_count);
+	if (do_count) /* Should never happen */
 		return (-EIO);
-	}
+
 	return 0;
 }
 
@@ -3606,10 +3598,6 @@
 			break;
 		offset -= st_bp->frp[src_seg].length;
 	}
-	if (src_seg == st_bp->frp_segs) {	/* Should never happen */
-		printk(KERN_WARNING "st: move_buffer offset overflow.\n");
-		return;
-	}
 
 	st_bp->buffer_bytes = st_bp->read_pointer = total;
 	for (dst_seg=dst_offset=0; total > 0; ) {
