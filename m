From: Willem Riede <wrlk@riede.org>
Subject: [PATCH] Updated osst driver for 2.6.x
Date: Tue, 23 Dec 2003 12:43:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031223174320.GU1277@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc13.comcast.net ([204.127.198.39]:1707 "EHLO
	rwcrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S262033AbTLWRnX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Dec 2003 12:43:23 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Brings 2.6.x version of osst up to par with the 2.4.y version.
Tested against released 2.6.0 kernel.

Changes from what's in the kernel tree today:

- Fixes bug that files shorter than one 32K frame don't get written.
- Supports a proc file for each drive (/proc/scsi/osst/osstX) which provides
  ADRversion_major.minor linux_media_version first_data_ppos eod_frame_ppos filemrk_cnt
- Fix a memory alloc/free mismatch that could have made your kernel unstable after rmmod osst.
- Fix a number of tape (re)positioning bugs around filemarks that affected Amanda, Arkeia and
  Storix backup software.
- Rationalize module parameters.
- Fix time-out skipping to EOD
- Write FM+EOD+Header-update when file write terminated by ioctl
- Follow standard Unix behavior for read at EOD (return zero bytes read twice then error)
- Implement SETBLK ioctl (allowed before first write only)


---------- start patch -------------
--- drivers/scsi/osst.c.orig	2003-12-17 21:58:49.000000000 -0500
+++ drivers/scsi/osst.c	2003-12-23 09:31:52.086888871 -0500
@@ -16,15 +16,15 @@
   Copyright 1992 - 2002 Kai Makisara / Willem Riede
 	 email Kai.Makisara@metla.fi / osst@riede.org
 
-  $Header: /home/cvsroot/Driver/osst.c,v 1.68 2002/12/23 16:33:36 riede Exp $
+  $Header: /cvsroot/osst/Driver/osst.c,v 1.70 2003/12/23 14:22:12 wriede Exp $
 
   Microscopic alterations - Rik Ling, 2000/12/21
   Last st.c sync: Tue Oct 15 22:01:04 2002 by makisara
   Some small formal changes - aeb, 950809
 */
 
-static const char * cvsid = "$Id: osst.c,v 1.68 2002/12/23 16:33:36 riede Exp $";
-const char * osst_version = "0.99.0";
+static const char * cvsid = "$Id: osst.c,v 1.70 2003/12/23 14:22:12 wriede Exp $";
+const char * osst_version = "0.99.1";
 
 /* The "failure to reconnect" firmware bug */
 #define OSST_FW_NEED_POLL_MIN 10601 /*(107A)*/
@@ -36,6 +36,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/proc_fs.h>
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/string.h>
@@ -846,9 +847,6 @@
 	/* TODO: Error handling */
 	if (STp->poll)
 		retval = osst_wait_frame (STp, aSRpnt, STp->first_frame_position, 0, timeout);
-#if 0// DEBUG
-	printk ("osst_read: wait for frame returned %i\n", retval);
-#endif
 	
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = READ_6;
@@ -1279,14 +1277,14 @@
 	Scsi_Request  * SRpnt = * aSRpnt;
 	unsigned char * buffer, * p;
 	unsigned char	cmd[MAX_COMMAND_SIZE];
-	int             flag, new_frame, i;
-	int             nframes          = STp->cur_frames;
-	int             blks_per_frame   = ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
-	int             frame_seq_number = ntohl(STp->buffer->aux->frame_seq_num)
+	int		flag, new_frame, i;
+	int		nframes          = STp->cur_frames;
+	int		blks_per_frame   = ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
+	int		frame_seq_number = ntohl(STp->buffer->aux->frame_seq_num)
 						- (nframes + pending - 1);
-	int             logical_blk_num  = ntohl(STp->buffer->aux->logical_blk_num) 
+	int		logical_blk_num  = ntohl(STp->buffer->aux->logical_blk_num) 
 						- (nframes + pending - 1) * blks_per_frame;
-	char          * name             = tape_name(STp);
+	char	      * name             = tape_name(STp);
 	unsigned long	startwait        = jiffies;
 #if DEBUG
 	int		dbg              = debugging;
@@ -1472,7 +1470,7 @@
 {
 	unsigned char	cmd[MAX_COMMAND_SIZE];
 	Scsi_Request  * SRpnt;
-	char          * name      = tape_name(STp);
+	char	      * name      = tape_name(STp);
 	int		expected  = 0;
 	int		attempts  = 1000 / skip;
 	int		flag      = 1;
@@ -2189,6 +2187,7 @@
 	if (ppos == 5 || ppos == 0xbae || STp->buffer->syscall_result) {
 		if (osst_set_frame_position(STp, aSRpnt, ppos, 0))
 			printk(KERN_WARNING "%s:W: Couldn't position tape\n", name);
+		osst_wait_ready(STp, aSRpnt, 60 * 15, 0);
 		if (osst_initiate_read (STp, aSRpnt)) {
 			printk(KERN_WARNING "%s:W: Couldn't initiate read\n", name);
 			return 0;
@@ -2817,7 +2816,29 @@
 	return result;
 }
 
+static int osst_write_trailer(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, int leave_at_EOT)
+{
+	ST_partstat * STps = &(STp->ps[STp->partition]);
+	int result = 0;
+
+	if (STp->write_type != OS_WRITE_NEW_MARK) {
+		/* true unless the user wrote the filemark for us */
+		result = osst_flush_drive_buffer(STp, aSRpnt);
+		if (result < 0) goto out;
+		result = osst_write_filemark(STp, aSRpnt);
+		if (result < 0) goto out;
+
+		if (STps->drv_file >= 0)
+			STps->drv_file++ ;
+		STps->drv_block = 0;
+	}
+	result = osst_write_eod(STp, aSRpnt);
+	osst_write_header(STp, aSRpnt, leave_at_EOT);
 
+	STps->eof = ST_FM;
+out:
+	return result;
+}
 

 /* osst versions of st functions - augmented and stripped to suit OnStream only */
 
@@ -2935,7 +2956,7 @@
 					result = (-EIO);
 				}
 			}
-			STps->drv_block = (-1);
+			STps->drv_block = (-1);		/* FIXME - even if write recovery succeeds? */
 		}
 		else {
 			STp->first_frame_position++;
@@ -3628,7 +3649,7 @@
 	/* Change the eof state if no data from tape or buffer */
 	if (total == 0) {
 		if (STps->eof == ST_FM_HIT) {
-			STps->eof = (STp->first_frame_position >= STp->eod_frame_ppos)?ST_EOD:ST_FM;
+			STps->eof = (STp->first_frame_position >= STp->eod_frame_ppos)?ST_EOD_2:ST_FM;
 			STps->drv_block = 0;
 			if (STps->drv_file >= 0)
 				STps->drv_file++;
@@ -4037,8 +4058,8 @@
 		if (debugging)
 		   printk(OSST_DEB_MSG "%s:D: Spacing to end of recorded medium.\n", name);
 #endif
-		osst_set_frame_position(STp, &SRpnt, STp->eod_frame_ppos, 0);
-	if (osst_get_logical_frame(STp, &SRpnt, -1, 0) < 0) {
+		if ((osst_position_tape_and_confirm(STp, &SRpnt, STp->eod_frame_ppos) < 0) ||
+			    (osst_get_logical_frame(STp, &SRpnt, -1, 0)               < 0)) {
 		   ioctl_result = -EIO;
 		   goto os_bypass;
 		}
@@ -4076,6 +4097,23 @@
 		break;
 
 	 case MTSETBLK:           /* Set block length */
+		 if ((STps->drv_block == 0 )			  &&
+		     !STp->dirty				  &&
+		     ((STp->buffer)->buffer_bytes == 0)		  &&
+		     ((arg & MT_ST_BLKSIZE_MASK) >= 512 )	  && 
+		     ((arg & MT_ST_BLKSIZE_MASK) <= OS_DATA_SIZE) &&
+		     !(OS_DATA_SIZE % (arg & MT_ST_BLKSIZE_MASK))  ) {
+			 /*
+			  * Only allowed to change the block size if you opened the
+			  * device at the beginning of a file before writing anything.
+			  * Note, that when reading, changing block_size is futile,
+			  * as the size used when writing overrides it.
+			  */
+			 STp->block_size = (arg & MT_ST_BLKSIZE_MASK);
+			 printk(KERN_INFO "%s:I: Block size set to %d bytes.\n",
+					   name, STp->block_size);
+			 return 0;
+		 }
 	 case MTSETDENSITY:       /* Set tape density */
 	 case MTSETDRVBUFFER:     /* Set drive buffering */
 	 case SET_DENS_AND_BLK:   /* Set density and block size */
@@ -4083,11 +4121,11 @@
 		 if (STp->dirty || (STp->buffer)->buffer_bytes != 0)
 			 return (-EIO);       /* Not allowed if data in buffer */
 		 if ((cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) &&
-		   (arg & MT_ST_BLKSIZE_MASK) != 0 &&
-		   ((arg & MT_ST_BLKSIZE_MASK) < STp->min_block ||
-		    (arg & MT_ST_BLKSIZE_MASK) > STp->max_block ||
-		    (arg & MT_ST_BLKSIZE_MASK) > osst_buffer_size)) {
-			 printk(KERN_WARNING "%s:W: Illegal block size.\n", name);
+		     (arg & MT_ST_BLKSIZE_MASK) != 0                    &&
+		     (arg & MT_ST_BLKSIZE_MASK) != STp->block_size       ) {
+			 printk(KERN_WARNING "%s:W: Illegal to set block size to %d%s.\n",
+						name, (int)(arg & MT_ST_BLKSIZE_MASK),
+						(OS_DATA_SIZE % (arg & MT_ST_BLKSIZE_MASK))?"":" now");
 			 return (-EINVAL);
 		 }
 		 return 0;  /* FIXME silently ignore if block size didn't change */
@@ -4592,22 +4630,7 @@
 					       name, STp->nbr_waits, STp->nbr_finished);
 		}
 #endif
-		if (STp->write_type != OS_WRITE_NEW_MARK) {
-			/* true unless the user wrote the filemark for us */
-			result = osst_flush_drive_buffer(STp, &SRpnt);
-			if (result < 0) goto out;
-			result = osst_write_filemark(STp, &SRpnt);
-			if (result < 0) goto out;
-
-			if (STps->drv_file >= 0)
-				STps->drv_file++ ;
-			STps->drv_block = 0;
-		}
-		result = osst_write_eod(STp, &SRpnt);
-		osst_write_header(STp, &SRpnt, !(STp->rew_at_close));
-
-		STps->eof = ST_FM;
-
+		result = osst_write_trailer(STp, &SRpnt, !(STp->rew_at_close));
 #if DEBUG
 		if (debugging)
 			printk(OSST_DEB_MSG "%s:D: Buffer flushed, %d EOF(s) written\n",
@@ -4618,7 +4641,7 @@
 		STps = &(STp->ps[STp->partition]);
 		if (!STm->sysv || STps->rw != ST_READING) {
 			if (STp->can_bsr)
-		result = osst_flush_buffer(STp, &SRpnt, 0);	/* this is the default path */
+				result = osst_flush_buffer(STp, &SRpnt, 0); /* this is the default path */
 			else if (STps->eof == ST_FM_HIT) {
 				result = cross_eof(STp, &SRpnt, FALSE);
 					if (result) {
@@ -4633,7 +4656,7 @@
 		}
 		else if ((STps->eof == ST_NOEOF &&
 			  !(result = cross_eof(STp, &SRpnt, TRUE))) ||
-			  STps->eof == ST_FM_HIT) {
+			 STps->eof == ST_FM_HIT) {
 			if (STps->drv_file >= 0)
 				STps->drv_file++;
 			STps->drv_block = 0;
@@ -4736,6 +4759,7 @@
 #endif
 	if (cmd_type == _IOC_TYPE(MTIOCTOP) && cmd_nr == _IOC_NR(MTIOCTOP)) {
 		struct mtop mtc;
+		int    auto_weof = 0;
 
 		if (_IOC_SIZE(cmd_in) != sizeof(mtc)) {
 			retval = (-EINVAL);
@@ -4812,10 +4836,41 @@
 			STp->device->was_reset = 0;
 		}
 
-		if (mtc.mt_op != MTNOP && mtc.mt_op != MTWEOF && mtc.mt_op != MTWSM &&
-		    mtc.mt_op != MTSETDENSITY && mtc.mt_op != MTSETBLK &&
-		    mtc.mt_op != MTSETDRVBUFFER && mtc.mt_op != MTSETPART)
-			STps->rw = ST_IDLE;  /* Prevent automatic WEOF and fsf */
+		if (mtc.mt_op != MTCOMPRESSION  && mtc.mt_op != MTLOCK         &&
+		    mtc.mt_op != MTNOP          && mtc.mt_op != MTSETBLK       &&
+		    mtc.mt_op != MTSETDENSITY   && mtc.mt_op != MTSETDRVBUFFER && 
+		    mtc.mt_op != MTMKPART       && mtc.mt_op != MTSETPART      &&
+		    mtc.mt_op != MTWEOF         && mtc.mt_op != MTWSM           ) {
+
+			/*
+			 * The user tells us to move to another position on the tape.
+			 * If we were appending to the tape content, that would leave
+			 * the tape without proper end, in that case write EOD and
+			 * update the header to reflect its position.
+			 */
+#if DEBUG
+			printk(KERN_WARNING "%s:D: auto_weod %s at ffp=%d,efp=%d,fsn=%d,lbn=%d,fn=%d,bn=%d\n", name,
+					STps->rw >= ST_WRITING ? "write" : STps->rw == ST_READING ? "read" : "idle",
+					STp->first_frame_position, STp->eod_frame_ppos, STp->frame_seq_number,
+					STp->logical_blk_num, STps->drv_file, STps->drv_block );
+#endif
+			if (STps->rw >= ST_WRITING && STp->first_frame_position >= STp->eod_frame_ppos) {
+				auto_weof = ((STp->write_type != OS_WRITE_NEW_MARK) &&
+							!(mtc.mt_op == MTREW || mtc.mt_op == MTOFFL));
+				i = osst_write_trailer(STp, &SRpnt,
+							!(mtc.mt_op == MTREW || mtc.mt_op == MTOFFL));
+#if DEBUG
+				printk(KERN_WARNING "%s:D: post trailer xeof=%d,ffp=%d,efp=%d,fsn=%d,lbn=%d,fn=%d,bn=%d\n",
+						name, auto_weof, STp->first_frame_position, STp->eod_frame_ppos,
+						STp->frame_seq_number, STp->logical_blk_num, STps->drv_file, STps->drv_block );
+#endif
+				if (i < 0) {
+					retval = i;
+					goto out;
+				}
+			}
+			STps->rw = ST_IDLE;
+		}
 
 		if (mtc.mt_op == MTOFFL && STp->door_locked != ST_UNLOCKED)
 			do_door_lock(STp, 0);  /* Ignore result! */
@@ -4873,11 +4928,15 @@
 			retval = do_door_lock(STp, (mtc.mt_op == MTLOCK));
 			goto out;
 		}
-			
+
+		if (auto_weof)
+			cross_eof(STp, &SRpnt, FALSE);
+
 		if (mtc.mt_op == MTCOMPRESSION)
-			retval = -EINVAL /*osst_compression(STp, (mtc.mt_count & 1))*/;
+			retval = -EINVAL;       /* OnStream drives don't have compression hardware */
 		else
-
+			/* MTBSF MTBSFM MTBSR MTBSS MTEOM MTERASE MTFSF MTFSFB MTFSR MTFSS
+			 * MTLOAD MTOFFL MTRESET MTRETEN MTREW MTUNLOAD MTWEOF MTWSM */
 			retval = osst_int_ioctl(STp, &SRpnt, mtc.mt_op, mtc.mt_count);
 		goto out;
 	}
@@ -5360,6 +5419,63 @@
 	return 0;
 }
 
+#ifdef CONFIG_SCSI_PROC_FS
+/*
+ * /proc support for accessing ADR header information
+ */
+static struct proc_dir_entry * osst_proc_dir = NULL;
+static char   osst_proc_dirname[] = "scsi/osst";
+
+static int osst_proc_read(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	int l = 0;
+	OS_Scsi_Tape * STp = (OS_Scsi_Tape *) data;
+
+	if (!osst_proc_dir) return 0;
+
+	if (STp->header_ok && STp->linux_media)
+		l = sprintf(page, "%d.%d LIN%d %8d %8d %8d \n",
+				  STp->header_cache->major_rev,
+				  STp->header_cache->minor_rev,
+				  STp->linux_media_version,
+				  STp->first_data_ppos,
+				  STp->eod_frame_ppos,
+				  STp->filemark_cnt );
+	return l;
+}
+
+static void osst_proc_init(void)
+{
+	osst_proc_dir = create_proc_entry(osst_proc_dirname, S_IFDIR | S_IRUGO | S_IXUGO, NULL);
+	osst_proc_dir->owner = THIS_MODULE;
+}
+
+static void osst_proc_create(OS_Scsi_Tape * STp, char * name)
+{
+	struct proc_dir_entry * p_entry;
+
+	if (!osst_proc_dir) return;
+
+	p_entry = create_proc_read_entry(name, 0444, osst_proc_dir, osst_proc_read, (void *) STp);
+	p_entry->owner = THIS_MODULE;
+}
+
+static void osst_proc_destroy(char * name)
+{
+	if (!osst_proc_dir) return; 
+
+	remove_proc_entry(name, osst_proc_dir);
+}
+
+static void osst_proc_cleanup(void)
+{
+	if (!osst_proc_dir) return;
+
+	remove_proc_entry(osst_proc_dirname, NULL);
+	osst_proc_dir = NULL;
+}
+#endif
+
 /*
  * osst startup / cleanup code
  */
@@ -5514,6 +5630,9 @@
 	}
 	drive->number = devfs_register_tape(SDp->devfs_name);
 
+#ifdef CONFIG_SCSI_PROC_FS
+	osst_proc_create(tpnt, tape_name(tpnt));
+#endif
 	printk(KERN_INFO
 		"osst :I: Attached OnStream %.5s tape at scsi%d, channel %d, id %d, lun %d as %s\n",
 		SDp->model, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun, tape_name(tpnt));
@@ -5527,37 +5646,40 @@
 
 static int osst_remove(struct device *dev)
 {
-  Scsi_Device * SDp = to_scsi_device(dev);
-  OS_Scsi_Tape * tpnt;
-  int i, mode;
-
-  if ((SDp->type != TYPE_TAPE) || (osst_nr_dev <= 0))
-	  return 0;
-
-  write_lock(&os_scsi_tapes_lock);
-  for(i=0; i < osst_max_dev; i++) {
-	if((tpnt = os_scsi_tapes[i]) && (tpnt->device == SDp)) {
-		tpnt->device = NULL;
-		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-			devfs_remove("%s/ot%s", SDp->devfs_name, osst_formats[mode]);
-			devfs_remove("%s/ot%sn", SDp->devfs_name, osst_formats[mode]);
-		}
-		devfs_unregister_tape(tpnt->drive->number);
-		put_disk(tpnt->drive);
-		os_scsi_tapes[i] = NULL;
-		osst_nr_dev--;
-		write_unlock(&os_scsi_tapes_lock);
-		if (tpnt->header_cache != NULL) vfree(tpnt->header_cache);
-		if (tpnt->buffer) {
-			normalize_buffer(tpnt->buffer);
-			kfree(tpnt->buffer);
-		}
-		kfree(tpnt);
+	Scsi_Device  * SDp = to_scsi_device(dev);
+	OS_Scsi_Tape * tpnt;
+	int i, mode;
+
+	if ((SDp->type != TYPE_TAPE) || (osst_nr_dev <= 0))
 		return 0;
+
+	write_lock(&os_scsi_tapes_lock);
+	for(i=0; i < osst_max_dev; i++) {
+		if((tpnt = os_scsi_tapes[i]) && (tpnt->device == SDp)) {
+#ifdef CONFIG_SCSI_PROC_FS
+			osst_proc_destroy(tape_name(tpnt));
+#endif
+			tpnt->device = NULL;
+			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+				devfs_remove("%s/ot%s", SDp->devfs_name, osst_formats[mode]);
+				devfs_remove("%s/ot%sn", SDp->devfs_name, osst_formats[mode]);
+			}
+			devfs_unregister_tape(tpnt->drive->number);
+			put_disk(tpnt->drive);
+			os_scsi_tapes[i] = NULL;
+			osst_nr_dev--;
+			write_unlock(&os_scsi_tapes_lock);
+			if (tpnt->header_cache != NULL) vfree(tpnt->header_cache);
+			if (tpnt->buffer) {
+				normalize_buffer(tpnt->buffer);
+				kfree(tpnt->buffer);
+			}
+			kfree(tpnt);
+			return 0;
+		}
 	}
-  }
-  write_unlock(&os_scsi_tapes_lock);
-  return 0;
+	write_unlock(&os_scsi_tapes_lock);
+	return 0;
 }
 
 static int __init init_osst(void) 
@@ -5565,7 +5687,10 @@
 	printk(KERN_INFO "osst :I: Tape driver with OnStream support version %s\nosst :I: %s\n", osst_version, cvsid);
 
 	validate_options();
-	
+
+#ifdef CONFIG_SCSI_PROC_FS
+	osst_proc_init();
+#endif
 	if ((register_chrdev(OSST_MAJOR,"osst", &osst_fops) < 0) || scsi_register_driver(&osst_template.gendrv)) {
 		printk(KERN_ERR "osst :E: Unable to register major %d for OnStream tapes\n", OSST_MAJOR);
 		return 1;
@@ -5582,6 +5707,9 @@
 	scsi_unregister_driver(&osst_template.gendrv);
 	unregister_chrdev(OSST_MAJOR, "osst");
 
+#ifdef CONFIG_SCSI_PROC_FS
+	osst_proc_cleanup();
+#endif
 	if (os_scsi_tapes) {
 		for (i=0; i < osst_max_dev; ++i) {
 			if (!(STp = os_scsi_tapes[i])) continue;
--- drivers/scsi/osst.h.orig	2003-12-17 21:59:05.000000000 -0500
+++ drivers/scsi/osst.h	2003-12-14 14:34:38.000000000 -0500
@@ -1,12 +1,11 @@
 /*
- *	$Header: /home/cvsroot/Driver/osst.h,v 1.12 2001/10/11 00:30:15 riede Exp $
+ *	$Header: /cvsroot/osst/Driver/osst.h,v 1.14 2003/12/14 14:34:38 wriede Exp $
  */
 
 #include <asm/byteorder.h>
 #include <linux/config.h>
 #include <linux/completion.h>
 
-
 /*	FIXME - rename and use the following two types or delete them!
  *              and the types really should go to st.h anyway...
  *	INQUIRY packet command - Data Format (From Table 6-8 of QIC-157C)
--- drivers/scsi/osst_options.h.orig	2003-12-17 22:00:00.000000000 -0500
+++ drivers/scsi/osst_options.h	2003-12-23 09:31:57.708132856 -0500
@@ -8,7 +8,7 @@
    Changed (and renamed) for OnStream SCSI drives garloff@suse.de
    2000-06-21
 
-   $Header: /home/cvsroot/Driver/osst_options.h,v 1.5 2001/01/07 22:19:15 riede Exp $
+   $Header: /cvsroot/osst/Driver/osst_options.h,v 1.6 2003/12/23 14:22:12 wriede Exp $
 */
 
 #ifndef _OSST_OPTIONS_H
----------  end patch  ---------


Comments? Thanks, Willem Riede,
osst maintaner.
