From: Willem Riede <wrlk@riede.org>
Subject: [PATCH] OSST tape driver fix for 2.5.51
Date: Wed, 11 Dec 2002 20:05:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021212010524.GP3664@linnie.riede.org>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.11.6/8.11.6) with ESMTP id gBC15OC22613
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2002 20:05:24 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The patch to osst.c below is needed to fix an oops and at the same time
brings in some bug fixes discovered in the 2.4 version.

Thanks, Willem Riede.

--- /home/wriede/kernel/linux-2.5.51/drivers/scsi/osst.c	Mon Dec  9 21:45:57 2002
+++ osst.c	Wed Dec 11 19:37:12 2002
@@ -24,7 +24,7 @@
 */
 
 static const char * cvsid = "$Id: osst.c,v 1.65 2001/11/11 20:38:56 riede Exp $";
-const char * osst_version = "0.99.0p3";
+const char * osst_version = "0.99.0p5";
 
 /* The "failure to reconnect" firmware bug */
 #define OSST_FW_NEED_POLL_MIN 10601 /*(107A)*/
@@ -60,7 +60,6 @@
    in the drivers are more widely classified, this may be changed to KERN_DEBUG. */
 #define OSST_DEB_MSG  KERN_NOTICE
 
-
 #include "scsi.h"
 #include "hosts.h"
 #include <scsi/scsi_ioctl.h>
@@ -85,7 +84,7 @@
 MODULE_PARM_DESC(max_dev, "Maximum number of OnStream Tape Drives to attach (4)");
 
 MODULE_PARM(write_threshold_kbs, "i");
-MODULE_PARM_DESC(write_threshold_kbs, "Asynchronous write threshold (KB; 30)");
+MODULE_PARM_DESC(write_threshold_kbs, "Asynchronous write threshold (KB; 32)");
 
 MODULE_PARM(max_sg_segs, "i");
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (9)");
@@ -170,8 +169,8 @@
 	.attach =       osst_attach,
 	.detach =       osst_detach,
 	.scsi_driverfs_driver = {
-		.name	= "osst",
-	},
+		.name =  "osst",
+	}
 };
 
 static int osst_int_ioctl(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, unsigned int cmd_in,unsigned long arg);
@@ -221,7 +220,7 @@
 		if (scode) printk(OSST_DEB_MSG "%s:D: Sense: %02x, ASC: %02x, ASCQ: %02x\n",
 			       	name, scode, sense[12], sense[13]);
 		if (driver_byte(result) & DRIVER_SENSE)
-			print_req_sense("osst", SRpnt);
+			print_req_sense("osst ", SRpnt);
 	}
 //	else
 #endif
@@ -543,8 +542,6 @@
 				 STp->first_frame_position);
 		goto err_out;
 	}
-//	STp->frame_in_buffer = 1;
-
         if (frame_seq_number != -1 && ntohl(aux->frame_seq_num) != frame_seq_number) {
 		if (!quiet)
 #if DEBUG
@@ -749,7 +746,7 @@
 	Scsi_Request  * SRpnt;
 
 	int             result = 0;
-	int		delay  = OSST_WAIT_LONG_WRITE_COMPLETE;
+	int		delay  = OSST_WAIT_WRITE_COMPLETE;
 #if DEBUG
 	char *name = tape_name(STp);
 
@@ -763,17 +760,14 @@
 	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_WRITE_RETRIES, TRUE);
 	*aSRpnt = SRpnt;
 	if (!SRpnt) return (-EBUSY);
-//printk(OSST_DEB_MSG "%s:X: Write filemark returned %x:%02x:%02x:%02x\n",dev,STp->buffer->syscall_result,SRpnt->sr_sense_buffer[2] & 0x0f,SRpnt->sr_sense_buffer[12],SRpnt->sr_sense_buffer[13]);
 	if (STp->buffer->syscall_result) {
 		if ((SRpnt->sr_sense_buffer[2] & 0x0f) == 2 && SRpnt->sr_sense_buffer[12] == 4) {
 			if (SRpnt->sr_sense_buffer[13] == 8) {
-//printk(OSST_DEB_MSG "%s:X: Long initial delay\n", dev);
 				delay = OSST_WAIT_LONG_WRITE_COMPLETE;
 			}
 		} else
 			result = osst_write_error_recovery(STp, aSRpnt, 0);
 	}
-//printk(OSST_DEB_MSG "%s:X: Entering wait ready (%d)\n",dev,delay);
 	result |= osst_wait_ready(STp, aSRpnt, 5 * 60, delay);
 	STp->ps[STp->partition].rw = OS_WRITING_COMPLETE;
 
@@ -1708,12 +1702,7 @@
 						 name, last_mark_ppos);
 				return (-EIO);
 			}
-			if (mt_op == MTBSFM) {
-				STp->frame_seq_number++;
-				STp->frame_in_buffer  = 0;
-				STp->logical_blk_num += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
-			}
-			return 0;
+			goto found;
 		}
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Reverting to scan filemark backwards\n", name);
@@ -1741,10 +1730,13 @@
 			return (-EIO);
 		}
 	}
+found:
 	if (mt_op == MTBSFM) {
 		STp->frame_seq_number++;
-		STp->frame_in_buffer  = 0;
-		STp->logical_blk_num += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
+		STp->frame_in_buffer      = 0;
+		STp->buffer->buffer_bytes = 0;
+		STp->buffer->read_pointer = 0;
+		STp->logical_blk_num     += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
 	}
 	return 0;
 }
@@ -1797,8 +1789,10 @@
 	}
 	if (mt_op == MTFSF) {
 		STp->frame_seq_number++;
-		STp->frame_in_buffer  = 0;
-		STp->logical_blk_num += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
+		STp->frame_in_buffer      = 0;
+		STp->buffer->buffer_bytes = 0;
+		STp->buffer->read_pointer = 0;
+		STp->logical_blk_num     += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
 	}
 	return 0;
 }
@@ -1944,9 +1938,10 @@
 	}
 	if (mt_op == MTFSF) {
 		STp->frame_seq_number++;
-		STp->frame_in_buffer  = 0;
+		STp->frame_in_buffer      = 0;
+		STp->buffer->buffer_bytes = 0;
 		STp->buffer->read_pointer = 0;
-		STp->logical_blk_num += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
+		STp->logical_blk_num     += ntohs(STp->buffer->aux->dat.dat_list[0].blk_cnt);
 	}
 	return 0;
 }
@@ -3215,8 +3210,8 @@
 
 	/* Write must be integral number of blocks */
 	if (STp->block_size != 0 && (count % STp->block_size) != 0) {
-		printk(KERN_ERR "%s:E: Write (%ld bytes) not multiple of tape block size (%d%c).\n",
-				       name, (unsigned long)count, STp->block_size<1024?
+		printk(KERN_ERR "%s:E: Write (%Zd bytes) not multiple of tape block size (%d%c).\n",
+				       name, count, STp->block_size<1024?
 				       STp->block_size:STp->block_size/1024, STp->block_size<1024?'b':'k');
 		retval = (-EINVAL);
 		goto out;
@@ -4140,8 +4135,14 @@
 
 		if (cmd_in == MTEOM)
 			STps->eof = ST_EOD;
-		else if ((cmd_in == MTFSFM || cmd_in == MTBSF) && STps->eof == ST_FM_HIT)
-			ioctl_result = osst_seek_logical_blk(STp, &SRpnt, STp->logical_blk_num - 1);
+		else if ((cmd_in == MTFSFM || cmd_in == MTBSF) && STps->eof == ST_FM_HIT) {
+			ioctl_result = osst_seek_logical_blk(STp, &SRpnt, STp->logical_blk_num-1);
+			STps->drv_block++;
+			STp->logical_blk_num++;
+			STp->frame_seq_number++;
+			STp->frame_in_buffer = 0;
+			STp->buffer->read_pointer = 0;
+		}
 		else if (cmd_in == MTFSF)
 			STps->eof = (STp->first_frame_position >= STp->eod_frame_ppos)?ST_EOD:ST_FM;
 		else if (chg_eof)
@@ -4233,8 +4234,7 @@
 #endif
 		return (-EBUSY);
 	}
-
-	if (!scsi_device_get(STp->device)) {
+	if (scsi_device_get(STp->device)) {
 		write_unlock(&os_scsi_tapes_lock);
 #if DEBUG
                 printk(OSST_DEB_MSG "%s:D: Failed scsi_device_get.\n", name);
@@ -4856,12 +4856,6 @@
 		}
 
 		if (mtc.mt_op == MTSETPART) {
-/*     if (!STp->can_partitions ||
-	   mtc.mt_count < 0 || mtc.mt_count >= ST_NBR_PARTITIONS)
-	 return (-EINVAL);
-		 if (mtc.mt_count >= STp->nbr_partitions &&
-	   (STp->nbr_partitions = nbr_partitions(inode)) < 0)
-	 return (-EIO);*/
 			if (mtc.mt_count >= STp->nbr_partitions)
 				retval = -EINVAL;
 			else {
@@ -4909,10 +4903,6 @@
 			goto out;
 		}
 			
-/*   if (STp->can_partitions && STp->ready == ST_READY &&
-	 (i = update_partition(inode)) < 0)
-		 {retval=i;goto out;}*/
-
 		if (mtc.mt_op == MTCOMPRESSION)
 			retval = -EINVAL /*osst_compression(STp, (mtc.mt_count & 1))*/;
 		else
@@ -4931,10 +4921,6 @@
 		goto out;
 	}
 
-/* if (STp->can_partitions &&
-		 (i = update_partition(inode)) < 0)
-	 {retval=i;goto out;}*/
-
 	if (cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET)) {
 		struct mtget mt_status;
 
@@ -5110,9 +5096,7 @@
 	for (segs=STbuffer->sg_segs=1, got=b_size;
 	     segs < max_segs && got < OS_FRAME_SIZE; ) {
 		STbuffer->sg[segs].page =
-			(OS_FRAME_SIZE - got <= PAGE_SIZE / 2) ?
-				kmalloc(OS_FRAME_SIZE - got, priority):
-				alloc_pages(priority, order);
+				alloc_pages(priority, (OS_FRAME_SIZE - got <= PAGE_SIZE) ? 0 : order);
 		STbuffer->sg[segs].offset = 0;
 		if (STbuffer->sg[segs].page == NULL) {
 			if (OS_FRAME_SIZE - got <= (max_segs - segs) * b_size / 2 && order) {
@@ -5320,10 +5304,8 @@
   if (max_sg_segs >= OSST_FIRST_SG)
 		osst_max_sg_segs = max_sg_segs;
 #if DEBUG
-  printk(OSST_DEB_MSG "osst :D: max tapes %d, write threshold %d, s/g segs %d.\n",
+  printk(OSST_DEB_MSG "osst :D: max tapes %d, write threshold %d, max s/g segs %d.\n",
 			   osst_max_dev, osst_write_threshold, osst_max_sg_segs);
-//printk(OSST_DEB_MSG "osst :D: sizeof(header) = %d (%s)\n",
-//		sizeof(os_header_t),sizeof(os_header_t)==OS_DATA_SIZE?"ok":"error");
 #endif
 }
 	
@@ -5446,7 +5428,7 @@
 	drive = alloc_disk(1);
 	if (!drive) {
 		printk(KERN_ERR "osst :E: Out of memory. Device not attached.\n");
-		return 1;
+		goto out_slave_detach;
 	}
 
 	/* if this is the first attach, build the infrastructure */
@@ -5458,7 +5440,7 @@
 		if (os_scsi_tapes == NULL) {
 			write_unlock(&os_scsi_tapes_lock);
 			printk(KERN_ERR "osst :E: Unable to allocate array for OnStream SCSI tapes.\n");
-			return 1;
+			goto out_put_disk;
 		}
 		for (i=0; i < osst_max_dev; ++i) os_scsi_tapes[i] = NULL;
 	}
@@ -5466,8 +5448,7 @@
 	if (osst_nr_dev >= osst_max_dev) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Too many tape devices (max. %d).\n", osst_max_dev);
-		put_disk(drive);
-		return 1;
+		goto out_put_disk;
 	}
 
 	/* find a free minor number */
@@ -5480,9 +5461,7 @@
 	if (tpnt == NULL) {
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Can't allocate device descriptor, device not attached.\n");
-		put_disk(drive);
-		scsi_slave_detach(SDp);
-		return 1;
+		goto out_put_disk;
 	}
 	memset(tpnt, 0, sizeof(OS_Scsi_Tape));
 
@@ -5495,9 +5474,7 @@
 		write_unlock(&os_scsi_tapes_lock);
 		printk(KERN_ERR "osst :E: Unable to allocate a tape buffer, device not attached.\n");
 		kfree(tpnt);
-		put_disk(drive);
-		scsi_slave_detach(SDp);
-		return 1;
+		goto out_put_disk;
 	}
 	os_scsi_tapes[dev_num] = tpnt;
 	tpnt->buffer = buffer;
@@ -5623,6 +5600,12 @@
 		SDp->model, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun, tape_name(tpnt));
 
 	return 0;
+
+out_put_disk:
+        put_disk(drive);
+out_slave_detach:
+        scsi_slave_detach(SDp);
+        return 1;
 };
 
 static void osst_detach(Scsi_Device * SDp)
@@ -5630,48 +5613,46 @@
   OS_Scsi_Tape * tpnt;
   int i, mode;
 
+  if ((SDp->type != TYPE_TAPE) || (osst_nr_dev <= 0))
+	  return;
+
   write_lock(&os_scsi_tapes_lock);
-  if (os_scsi_tapes != NULL) {
-	  for(i=0; i<osst_max_dev; i++) {
-		tpnt = os_scsi_tapes[i];
-		if(tpnt != NULL && tpnt->device == SDp) {
-			tpnt->device = NULL;
-			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-				devfs_unregister (tpnt->de_r[mode]);
-				tpnt->de_r[mode] = NULL;
-				devfs_unregister (tpnt->de_n[mode]);
-				tpnt->de_n[mode] = NULL;
-			}
-			devfs_unregister_tape(tpnt->drive->number);
-			put_disk(tpnt->drive);
-			os_scsi_tapes[i] = NULL;
-			scsi_slave_detach(SDp);
-			osst_nr_dev--;
-			write_unlock(&os_scsi_tapes_lock);
-			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-				device_remove_file(&tpnt->driverfs_dev_r[mode],
-						&dev_attr_type);
-				device_remove_file(&tpnt->driverfs_dev_r[mode],
-						&dev_attr_kdev);
-				device_unregister(&tpnt->driverfs_dev_r[mode]);
-				device_remove_file(&tpnt->driverfs_dev_n[mode],
-						&dev_attr_type);
-				device_remove_file(&tpnt->driverfs_dev_n[mode],
-						&dev_attr_kdev);
-				device_unregister(&tpnt->driverfs_dev_n[mode]);
-			}
-			if (tpnt->header_cache != NULL)
-				vfree(tpnt->header_cache);
-			if (tpnt->buffer) {
-				normalize_buffer(tpnt->buffer);
-				kfree(tpnt->buffer);
-			}
-			kfree(tpnt);
-			break;
+  for(i=0; i < osst_max_dev; i++) {
+	if((tpnt = os_scsi_tapes[i]) && (tpnt->device == SDp)) {
+		tpnt->device = NULL;
+		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+			devfs_unregister (tpnt->de_r[mode]);
+			tpnt->de_r[mode] = NULL;
+			devfs_unregister (tpnt->de_n[mode]);
+			tpnt->de_n[mode] = NULL;
+		}
+		devfs_unregister_tape(tpnt->drive->number);
+		put_disk(tpnt->drive);
+		os_scsi_tapes[i] = NULL;
+		scsi_slave_detach(SDp);
+		osst_nr_dev--;
+		write_unlock(&os_scsi_tapes_lock);
+		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+			device_remove_file(&tpnt->driverfs_dev_r[mode],
+					&dev_attr_type);
+			device_remove_file(&tpnt->driverfs_dev_r[mode],
+					&dev_attr_kdev);
+			device_unregister(&tpnt->driverfs_dev_r[mode]);
+			device_remove_file(&tpnt->driverfs_dev_n[mode],
+					&dev_attr_type);
+			device_remove_file(&tpnt->driverfs_dev_n[mode],
+					&dev_attr_kdev);
+			device_unregister(&tpnt->driverfs_dev_n[mode]);
+			}
+		if (tpnt->header_cache != NULL) vfree(tpnt->header_cache);
+		if (tpnt->buffer) {
+			normalize_buffer(tpnt->buffer);
+			kfree(tpnt->buffer);
 		}
-	  }
+		kfree(tpnt);
+		return;
+	}
   }
-
   write_unlock(&os_scsi_tapes_lock);
   return;
 }
@@ -5681,12 +5662,8 @@
 	printk(KERN_INFO "osst :I: Tape driver with OnStream support version %s\nosst :I: %s\n", osst_version, cvsid);
 
 	validate_options();
-#if DEBUG
-	 printk(OSST_DEB_MSG "osst :D: %d s/g segments, write threshold %d bytes.\n",
-			 max_sg_segs, osst_write_threshold);
-#endif
-	if ((register_chrdev(OSST_MAJOR, "osst", &osst_fops) < 0) ||
-			scsi_register_device(&osst_template)) {
+	
+	if ((register_chrdev(OSST_MAJOR,"osst", &osst_fops) < 0) || scsi_register_device(&osst_template)) {
 		printk(KERN_ERR "osst :E: Unable to register major %d for OnStream tapes\n", OSST_MAJOR);
 		return 1;
 	}
