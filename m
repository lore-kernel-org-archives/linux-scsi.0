From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] move all procfs code to scsi_proc.c
Date: Sat, 16 Nov 2002 21:54:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021116215453.A25518@lst.de>
References: <20021116200249.A23459@lst.de> <20021116120148.A6799@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021116120148.A6799@eng2.beaverton.ibm.com>; from patmans@us.ibm.com on Sat, Nov 16, 2002 at 12:01:48PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Nov 16, 2002 at 12:01:48PM -0800, Patrick Mansfield wrote:
> Where are the calls to scsi_init_procfs and scsi_exit_procfs?

Left between the previous and the final version of that patch.  Here's
the right diff:


--- 1.31/drivers/scsi/Makefile	Fri Jun 21 06:09:54 2002
+++ edited/drivers/scsi/Makefile	Sat Nov 16 20:19:18 2002
@@ -18,7 +18,7 @@
 CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
 CFLAGS_seagate.o =   -DARBITRATE -DPARITY -DSEAGATE_USE_ASM
 
-export-objs	:= scsi_syms.o 53c700.o
+export-objs	:= scsi_syms.o scsi_proc.o 53c700.o
 
 subdir-$(CONFIG_PCMCIA)		+= pcmcia
 
@@ -123,8 +123,11 @@
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 
 scsi_mod-objs	:= scsi.o hosts.o scsi_ioctl.o constants.o scsicam.o \
-			scsi_proc.o scsi_error.o scsi_lib.o scsi_scan.o \
-			scsi_syms.o
+		   scsi_error.o scsi_lib.o scsi_scan.o scsi_syms.o
+
+ifdef CONFIG_PROC_FS
+scsi_mod-objs	+= scsi_proc.o
+endif
 			
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
===== drivers/scsi/hosts.c 1.27 vs edited =====
--- 1.27/drivers/scsi/hosts.c	Thu Nov 14 13:19:04 2002
+++ edited/drivers/scsi/hosts.c	Sat Nov 16 20:23:06 2002
@@ -352,11 +359,7 @@
 	shost->hostt->present--;
 
 	/* Cleanup proc and driverfs */
-#ifdef CONFIG_PROC_FS
 	scsi_proc_host_rm(shost);
-	if (!shost->hostt->present)
-		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
-#endif
 	device_unregister(&shost->host_driverfs_dev);
 
 	kfree(shost);
@@ -470,12 +473,7 @@
 found:
 	spin_unlock(&scsi_host_list_lock);
 
-#ifdef CONFIG_PROC_FS
-	/* Add the new driver to /proc/scsi if not already there */
-	if (!shost_tp->proc_dir)
-		scsi_proc_host_mkdir(shost_tp);
 	scsi_proc_host_add(shost);
-#endif
 
 	strncpy(shost->host_driverfs_dev.name, shost_tp->proc_name,
 		DEVICE_NAME_SIZE-1);
===== drivers/scsi/hosts.h 1.36 vs edited =====
--- 1.36/drivers/scsi/hosts.h	Thu Nov 14 13:07:27 2002
+++ edited/drivers/scsi/hosts.h	Sat Nov 16 20:19:19 2002
@@ -509,10 +509,6 @@
 	unsigned short host_registered;
 } Scsi_Host_Name;
 	
-extern void scsi_proc_host_mkdir(Scsi_Host_Template *);
-extern void scsi_proc_host_add(struct Scsi_Host *);
-extern void scsi_proc_host_rm(struct Scsi_Host *);
-
 extern void scsi_register_blocked_host(struct Scsi_Host *);
 extern void scsi_deregister_blocked_host(struct Scsi_Host *);
 
===== drivers/scsi/scsi.c 1.61 vs edited =====
--- 1.61/drivers/scsi/scsi.c	Thu Nov 14 13:19:04 2002
+++ edited/drivers/scsi/scsi.c	Sat Nov 16 20:20:56 2002
@@ -74,13 +74,6 @@
 #include <linux/kmod.h>
 #endif
 
-struct proc_dir_entry *proc_scsi;
-
-#ifdef CONFIG_PROC_FS
-static int scsi_proc_info(char *buffer, char **start, off_t offset, int length);
-static void scsi_dump_status(int level);
-#endif
-
 #define SG_MEMPOOL_NR		5
 #define SG_MEMPOOL_SIZE		32
 
@@ -166,7 +159,7 @@
 static const char * const spaces = "                "; /* 16 of them */
 
 static unsigned scsi_default_dev_flags;
-static LIST_HEAD(scsi_dev_info_list);
+LIST_HEAD(scsi_dev_info_list);
 
 /* 
  * Function prototypes.
@@ -1762,7 +1755,7 @@
  *
  * Returns: 0 if OK, -error on failure.
  **/
-static int scsi_dev_info_list_add_str (char *dev_list)
+int scsi_dev_info_list_add_str (char *dev_list)
 {
 	char *vendor, *model, *strflags, *next;
 	char *next_check;
@@ -1908,367 +1901,6 @@
 	return scsi_default_dev_flags;
 }
 
-#ifdef CONFIG_PROC_FS
-/* 
- * proc_scsi_dev_info_read: dump the scsi_dev_info_list via
- * /proc/scsi/device_info
- */
-static int proc_scsi_dev_info_read(char *buffer, char **start, off_t offset,
-				   int length)
-{
-	struct scsi_dev_info_list *devinfo;
-	int size, len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
-
-	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
-		size = sprintf(buffer + len, "'%.8s' '%.16s' 0x%x\n",
-			       devinfo->vendor, devinfo->model, devinfo->flags);
-		len += size;
-		pos = begin + len;
-		if (pos < offset) {
-			len = 0;
-			begin = pos;
-		}
-		if (pos > offset + length)
-			goto stop_output;
-	}
-
-stop_output:
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length)
-		len = length;	/* Ending slop */
-	return (len);
-}
-
-/* 
- * proc_scsi_dev_info_write: allow additions to the scsi_dev_info_list via
- * /proc.
- *
- * Use: echo "vendor:model:flag" > /proc/scsi/device_info
- *
- * To add a black/white list entry for vendor and model with an integer
- * value of flag to the scsi device info list.
- */
-static int proc_scsi_dev_info_write (struct file * file, const char * buf,
-                              unsigned long length, void *data)
-{
-	char *buffer;
-	int err = length;
-
-	if (!buf || length>PAGE_SIZE)
-		return -EINVAL;
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
-		return -ENOMEM;
-	if(copy_from_user(buffer, buf, length)) {
-		err =-EFAULT;
-		goto out;
-	}
-
-	if (length < PAGE_SIZE)
-		buffer[length] = '\0';
-	else if (buffer[PAGE_SIZE-1]) {
-		err = -EINVAL;
-		goto out;
-	}
-
-	scsi_dev_info_list_add_str(buffer);
-
-out:
-	free_page((unsigned long) buffer);
-	return err;
-}
-
-static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
-{
-	Scsi_Device *scd;
-	struct Scsi_Host *HBA_ptr;
-	int size, len = 0;
-	off_t begin = 0;
-	off_t pos = 0;
-
-	/*
-	 * First, see if there are any attached devices or not.
-	 */
-	for (HBA_ptr = scsi_host_get_next(NULL); HBA_ptr;
-	     HBA_ptr = scsi_host_get_next(HBA_ptr)) {
-		if (HBA_ptr->host_queue != NULL) {
-			break;
-		}
-	}
-	size = sprintf(buffer + len, "Attached devices: %s\n", (HBA_ptr) ? "" : "none");
-	len += size;
-	pos = begin + len;
-	for (HBA_ptr = scsi_host_get_next(NULL); HBA_ptr;
-	     HBA_ptr = scsi_host_get_next(HBA_ptr)) {
-#if 0
-		size += sprintf(buffer + len, "scsi%2d: %s\n", (int) HBA_ptr->host_no,
-				HBA_ptr->hostt->procname);
-		len += size;
-		pos = begin + len;
-#endif
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			proc_print_scsidevice(scd, buffer, &size, len);
-			len += size;
-			pos = begin + len;
-
-			if (pos < offset) {
-				len = 0;
-				begin = pos;
-			}
-			if (pos > offset + length)
-				goto stop_output;
-		}
-	}
-
-stop_output:
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);	/* Start slop */
-	if (len > length)
-		len = length;	/* Ending slop */
-	return (len);
-}
-
-static int proc_scsi_gen_write(struct file * file, const char * buf,
-                              unsigned long length, void *data)
-{
-	Scsi_Device *scd;
-	struct Scsi_Host *HBA_ptr;
-	char *p;
-	int host, channel, id, lun;
-	char * buffer;
-	int err;
-
-	if (!buf || length>PAGE_SIZE)
-		return -EINVAL;
-
-	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
-		return -ENOMEM;
-	if(copy_from_user(buffer, buf, length))
-	{
-		err =-EFAULT;
-		goto out;
-	}
-
-	err = -EINVAL;
-
-	if (length < PAGE_SIZE)
-		buffer[length] = '\0';
-	else if (buffer[PAGE_SIZE-1])
-		goto out;
-
-	if (length < 11 || strncmp("scsi", buffer, 4))
-		goto out;
-
-	/*
-	 * Usage: echo "scsi dump #N" > /proc/scsi/scsi
-	 * to dump status of all scsi commands.  The number is used to specify the level
-	 * of detail in the dump.
-	 */
-	if (!strncmp("dump", buffer + 5, 4)) {
-		unsigned int level;
-
-		p = buffer + 10;
-
-		if (*p == '\0')
-			goto out;
-
-		level = simple_strtoul(p, NULL, 0);
-		scsi_dump_status(level);
-	}
-	/*
-	 * Usage: echo "scsi log token #N" > /proc/scsi/scsi
-	 * where token is one of [error,scan,mlqueue,mlcomplete,llqueue,
-	 * llcomplete,hlqueue,hlcomplete]
-	 */
-#ifdef CONFIG_SCSI_LOGGING		/* { */
-
-	if (!strncmp("log", buffer + 5, 3)) {
-		char *token;
-		unsigned int level;
-
-		p = buffer + 9;
-		token = p;
-		while (*p != ' ' && *p != '\t' && *p != '\0') {
-			p++;
-		}
-
-		if (*p == '\0') {
-			if (strncmp(token, "all", 3) == 0) {
-				/*
-				 * Turn on absolutely everything.
-				 */
-				scsi_logging_level = ~0;
-			} else if (strncmp(token, "none", 4) == 0) {
-				/*
-				 * Turn off absolutely everything.
-				 */
-				scsi_logging_level = 0;
-			} else {
-				goto out;
-			}
-		} else {
-			*p++ = '\0';
-
-			level = simple_strtoul(p, NULL, 0);
-
-			/*
-			 * Now figure out what to do with it.
-			 */
-			if (strcmp(token, "error") == 0) {
-				SCSI_SET_ERROR_RECOVERY_LOGGING(level);
-			} else if (strcmp(token, "timeout") == 0) {
-				SCSI_SET_TIMEOUT_LOGGING(level);
-			} else if (strcmp(token, "scan") == 0) {
-				SCSI_SET_SCAN_BUS_LOGGING(level);
-			} else if (strcmp(token, "mlqueue") == 0) {
-				SCSI_SET_MLQUEUE_LOGGING(level);
-			} else if (strcmp(token, "mlcomplete") == 0) {
-				SCSI_SET_MLCOMPLETE_LOGGING(level);
-			} else if (strcmp(token, "llqueue") == 0) {
-				SCSI_SET_LLQUEUE_LOGGING(level);
-			} else if (strcmp(token, "llcomplete") == 0) {
-				SCSI_SET_LLCOMPLETE_LOGGING(level);
-			} else if (strcmp(token, "hlqueue") == 0) {
-				SCSI_SET_HLQUEUE_LOGGING(level);
-			} else if (strcmp(token, "hlcomplete") == 0) {
-				SCSI_SET_HLCOMPLETE_LOGGING(level);
-			} else if (strcmp(token, "ioctl") == 0) {
-				SCSI_SET_IOCTL_LOGGING(level);
-			} else {
-				goto out;
-			}
-		}
-
-		printk(KERN_INFO "scsi logging level set to 0x%8.8x\n", scsi_logging_level);
-	}
-#endif	/* CONFIG_SCSI_LOGGING */ /* } */
-
-	/*
-	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
-	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 * Consider this feature BETA.
-	 *     CAUTION: This is not for hotplugging your peripherals. As
-	 *     SCSI was not designed for this you could damage your
-	 *     hardware !
-	 * However perhaps it is legal to switch on an
-	 * already connected device. It is perhaps not
-	 * guaranteed this device doesn't corrupt an ongoing data transfer.
-	 */
-	if (!strncmp("add-single-device", buffer + 5, 17)) {
-		p = buffer + 23;
-
-		host = simple_strtoul(p, &p, 0);
-		channel = simple_strtoul(p + 1, &p, 0);
-		id = simple_strtoul(p + 1, &p, 0);
-		lun = simple_strtoul(p + 1, &p, 0);
-
-		printk(KERN_INFO "scsi singledevice %d %d %d %d\n", host, channel,
-		       id, lun);
-
-		for (HBA_ptr = scsi_host_get_next(NULL); HBA_ptr;
-		     HBA_ptr = scsi_host_get_next(HBA_ptr)) {
-			if (HBA_ptr->host_no == host) {
-				break;
-			}
-		}
-		err = -ENXIO;
-		if (!HBA_ptr)
-			goto out;
-
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			if ((scd->channel == channel
-			     && scd->id == id
-			     && scd->lun == lun)) {
-				break;
-			}
-		}
-
-		err = -ENOSYS;
-		if (scd)
-			goto out;	/* We do not yet support unplugging */
-
-		scan_scsis(HBA_ptr, 1, channel, id, lun);
-		err = length;
-		goto out;
-	}
-	/*
-	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
-	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 *
-	 * Consider this feature pre-BETA.
-	 *
-	 *     CAUTION: This is not for hotplugging your peripherals. As
-	 *     SCSI was not designed for this you could damage your
-	 *     hardware and thoroughly confuse the SCSI subsystem.
-	 *
-	 */
-	else if (!strncmp("remove-single-device", buffer + 5, 20)) {
-		p = buffer + 26;
-
-		host = simple_strtoul(p, &p, 0);
-		channel = simple_strtoul(p + 1, &p, 0);
-		id = simple_strtoul(p + 1, &p, 0);
-		lun = simple_strtoul(p + 1, &p, 0);
-
-
-		for (HBA_ptr = scsi_host_get_next(NULL); HBA_ptr;
-		     HBA_ptr = scsi_host_get_next(HBA_ptr)) {
-			if (HBA_ptr->host_no == host) {
-				break;
-			}
-		}
-		err = -ENODEV;
-		if (!HBA_ptr)
-			goto out;
-
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			if ((scd->channel == channel
-			     && scd->id == id
-			     && scd->lun == lun)) {
-				break;
-			}
-		}
-
-		if (scd == NULL)
-			goto out;	/* there is no such device attached */
-
-		err = -EBUSY;
-		if (scd->access_count)
-			goto out;
-
-		scsi_detach_device(scd);
-
-		if (scd->attached == 0) {
-			devfs_unregister (scd->de);
-
-			/* Now we can remove the device structure */
-			if (scd->next != NULL)
-				scd->next->prev = scd->prev;
-
-			if (scd->prev != NULL)
-				scd->prev->next = scd->next;
-
-			if (HBA_ptr->host_queue == scd) {
-				HBA_ptr->host_queue = scd->next;
-			}
-			blk_cleanup_queue(&scd->request_queue);
-			if (scd->inquiry)
-				kfree(scd->inquiry);
-			kfree((char *) scd);
-		} else {
-			goto out;
-		}
-		err = 0;
-	}
-out:
-	
-	free_page((unsigned long) buffer);
-	return err;
-}
-#endif
-
 int scsi_attach_device(struct scsi_device *sdev)
 {
 	struct Scsi_Device_Template *sdt;
@@ -2470,86 +2102,6 @@
 	return -1;
 }
 
-#ifdef CONFIG_PROC_FS
-/*
- * Function:    scsi_dump_status
- *
- * Purpose:     Brain dump of scsi system, used for problem solving.
- *
- * Arguments:   level - used to indicate level of detail.
- *
- * Notes:       The level isn't used at all yet, but we need to find some way
- *              of sensibly logging varying degrees of information.  A quick one-line
- *              display of each command, plus the status would be most useful.
- *
- *              This does depend upon CONFIG_SCSI_LOGGING - I do want some way of turning
- *              it all off if the user wants a lean and mean kernel.  It would probably
- *              also be useful to allow the user to specify one single host to be dumped.
- *              A second argument to the function would be useful for that purpose.
- *
- *              FIXME - some formatting of the output into tables would be very handy.
- */
-static void scsi_dump_status(int level)
-{
-#ifdef CONFIG_SCSI_LOGGING		/* { */
-	int i;
-	struct Scsi_Host *shpnt;
-	Scsi_Cmnd *SCpnt;
-	Scsi_Device *SDpnt;
-	printk(KERN_INFO "Dump of scsi host parameters:\n");
-	i = 0;
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) {
-		printk(KERN_INFO " %d %d %d : %d %d\n",
-		       shpnt->host_failed,
-		       shpnt->host_busy,
-		       atomic_read(&shpnt->host_active),
-		       shpnt->host_blocked,
-		       shpnt->host_self_blocked);
-	}
-
-	printk(KERN_INFO "\n\n");
-	printk(KERN_INFO "Dump of scsi command parameters:\n");
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) {
-		printk(KERN_INFO "h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to ito) cmd snse result\n");
-		for (SDpnt = shpnt->host_queue; SDpnt; SDpnt = SDpnt->next) {
-			for (SCpnt = SDpnt->device_queue; SCpnt; SCpnt = SCpnt->next) {
-				/*  (0) h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to ito) cmd snse result %d %x      */
-				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
-				       i++,
-
-				       SCpnt->host->host_no,
-				       SCpnt->channel,
-                                       SCpnt->target,
-                                       SCpnt->lun,
-
-                                       SCpnt->request->rq_disk ?
-                                       SCpnt->request->rq_disk->disk_name : "?",
-                                       (unsigned long long)SCpnt->request->sector,
-				       SCpnt->request->nr_sectors,
-				       (long)SCpnt->request->current_nr_sectors,
-				       SCpnt->request->rq_status,
-				       SCpnt->use_sg,
-
-				       SCpnt->retries,
-				       SCpnt->allowed,
-				       SCpnt->flags,
-
-				       SCpnt->timeout_per_command,
-				       SCpnt->timeout,
-				       SCpnt->internal_timeout,
-
-				       SCpnt->cmnd[0],
-				       SCpnt->sense_buffer[2],
-				       SCpnt->result);
-			}
-		}
-	}
-#endif	/* CONFIG_SCSI_LOGGING */ /* } */
-}
-#endif				/* CONFIG_PROC_FS */
-
 static char *scsi_dev_flags;
 MODULE_PARM(scsi_dev_flags, "s");
 MODULE_PARM_DESC(scsi_dev_flags,
@@ -2671,7 +2223,6 @@
 
 static int __init init_scsi(void)
 {
-	struct proc_dir_entry *generic;
 	int i;
 
 	printk(KERN_INFO "SCSI subsystem driver " REVISION "\n");
@@ -2692,44 +2243,12 @@
 			panic("SCSI: can't init sg mempool\n");
 	}
 
-	/*
-	 * This makes /proc/scsi and /proc/scsi/scsi visible.
-	 */
-#ifdef CONFIG_PROC_FS
-	proc_scsi = proc_mkdir("scsi", 0);
-	if (!proc_scsi) {
-		printk (KERN_ERR "cannot init /proc/scsi\n");
-		return -ENOMEM;
-	}
-	generic = create_proc_info_entry ("scsi/scsi", 0, 0, scsi_proc_info);
-	if (!generic) {
-		printk (KERN_ERR "cannot init /proc/scsi/scsi\n");
-		remove_proc_entry("scsi", 0);
-		return -ENOMEM;
-	}
-	generic->write_proc = proc_scsi_gen_write;
-
-	generic = create_proc_info_entry ("scsi/device_info", 0, 0,
-					  proc_scsi_dev_info_read);
-	if (!generic) {
-		printk (KERN_ERR "cannot init /proc/scsi/device_info\n");
-		remove_proc_entry("scsi/scsi", 0);
-		remove_proc_entry("scsi", 0);
-		return -ENOMEM;
-	}
-	generic->write_proc = proc_scsi_dev_info_write;
-#endif
-
-        scsi_devfs_handle = devfs_mk_dir (NULL, "scsi", NULL);
-
+	scsi_init_procfs();
+	scsi_devfs_handle = devfs_mk_dir(NULL, "scsi", NULL);
 	scsi_host_init();
 	scsi_dev_info_list_init(scsi_dev_flags);
-
 	bus_register(&scsi_driverfs_bus_type);
-
-	/* Where we handle work queued by scsi_done */
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
-
 	return 0;
 }
 
@@ -2737,17 +2256,10 @@
 {
 	int i;
 
-        devfs_unregister (scsi_devfs_handle);
+	devfs_unregister(scsi_devfs_handle);
+	scsi_exit_procfs();
 	scsi_dev_info_list_delete();
 
-
-#ifdef CONFIG_PROC_FS
-	/* No, we're not here anymore. Don't show the /proc/scsi files. */
-	remove_proc_entry ("scsi/device_info", 0);
-	remove_proc_entry ("scsi/scsi", 0);
-	remove_proc_entry ("scsi", 0);
-#endif
-	
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
 		mempool_destroy(sgp->pool);
===== drivers/scsi/scsi.h 1.40 vs edited =====
--- 1.40/drivers/scsi/scsi.h	Thu Nov 14 12:34:35 2002
+++ edited/drivers/scsi/scsi.h	Sat Nov 16 20:19:19 2002
@@ -391,6 +391,11 @@
 #include "scsi_obsolete.h"
 
 /*
+ * Forward-declaration of structs for prototypes.
+ */
+struct Scsi_Host;
+
+/*
  * Add some typedefs so that we can prototyope a bunch of the functions.
  */
 typedef struct scsi_device Scsi_Device;
@@ -496,8 +501,21 @@
 /*
  * Prototypes for functions in scsi_proc.c
  */
-extern void proc_print_scsidevice(Scsi_Device *, char *, int *, int);
+#ifdef CONFIG_PROC_FS
+extern int scsi_init_procfs(void);
+extern void scsi_exit_procfs(void);
+
+extern void scsi_proc_host_add(struct Scsi_Host *);
+extern void scsi_proc_host_rm(struct Scsi_Host *);
+
 extern struct proc_dir_entry *proc_scsi;
+#else
+static inline int scsi_init_procfs(void) { return 0; };
+static inline void scsi_exit_procfs(void) { };
+
+static inline void scsi_proc_host_add(struct Scsi_Host *);
+static inline void scsi_proc_host_rm(struct Scsi_Host *);
+#endif /* CONFIG_PROC_FS */
 
 /*
  * Prototypes for functions in constants.c
@@ -536,6 +554,8 @@
 	unsigned flags;
 	unsigned compatible; /* for use with scsi_static_device_list entries */
 };
+extern struct list_head scsi_dev_info_list;
+extern int scsi_dev_info_list_add_str(char *);
 
 /*
  *  The scsi_device struct contains what we know about each given scsi
===== drivers/scsi/scsi_proc.c 1.7 vs edited =====
--- 1.7/drivers/scsi/scsi_proc.c	Wed Oct 16 18:51:48 2002
+++ edited/drivers/scsi/scsi_proc.c	Sat Nov 16 20:19:19 2002
@@ -16,9 +16,8 @@
  * Michael A. Griffith <grif@acm.org>
  */
 
-#include <linux/config.h>	/* for CONFIG_PROC_FS */
+#include <linux/config.h>
 #include <linux/module.h>
-
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -26,245 +25,133 @@
 #include <linux/errno.h>
 #include <linux/stat.h>
 #include <linux/blk.h>
-
 #include <asm/uaccess.h>
 
 #include "scsi.h"
 #include "hosts.h"
 
-#ifndef TRUE
-#define TRUE  1
-#define FALSE 0
-#endif
+/* 4K page size, but our output routines, use some slack for overruns */
+#define PROC_BLOCK_SIZE (3*1024)
 
-#ifdef CONFIG_PROC_FS
+/* XXX: this shouldn't really be exposed to drivers. */
+struct proc_dir_entry *proc_scsi;
+EXPORT_SYMBOL(proc_scsi);
 
-/* generic_proc_info
- * Used if the driver currently has no own support for /proc/scsi
- */
-int generic_proc_info(char *buffer, char **start, off_t offset, int length, 
-		      const char *(*info) (struct Scsi_Host *),
-		      struct Scsi_Host *sh)
-{
-	int len, pos, begin;
-
-	begin = 0;
-	if (info && sh) {
-		pos = len = sprintf(buffer, "%s\n", info(sh));
-	} else {
-		pos = len = sprintf(buffer,
-			"The driver does not yet support the proc-fs\n");
-	}
+
+/* Used if the driver currently has no own support for /proc/scsi */
+static int generic_proc_info(char *buffer, char **start, off_t offset,
+			     int count, const char *(*info)(struct Scsi_Host *),
+			     struct Scsi_Host *shost)
+{
+	int len, pos, begin = 0;
+	static const char noprocfs[] =
+		"The driver does not yet support the proc-fs\n";
+
+	if (info && shost)
+		len = sprintf(buffer, "%s\n", info(shost));
+	else
+		len = sprintf(buffer, "%s\n", noprocfs);
+
+	pos = len;
 	if (pos < offset) {
 		len = 0;
 		begin = pos;
 	}
-	*start = buffer + (offset - begin);	/* Start of wanted data */
+
+	*start = buffer + (offset - begin);
 	len -= (offset - begin);
-	if (len > length)
-		len = length;
+	if (len > count)
+		len = count;
 
-	return (len);
+	return len;
 }
 
-/* dispatch_scsi_info is the central dispatcher 
- * It is the interface between the proc-fs and the SCSI subsystem code
- */
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
-	int length, int *eof, void *data)
+			  int length, int *eof, void *data)
 {
-	struct Scsi_Host *hpnt = data;
+	struct Scsi_Host *shost = data;
 	int n;
 
-	if (hpnt->hostt->proc_info == NULL)
+	if (shost->hostt->proc_info == NULL)
 		n = generic_proc_info(buffer, start, offset, length,
-				      hpnt->hostt->info, hpnt);
+				      shost->hostt->info, shost);
 	else
-		n = (hpnt->hostt->proc_info(buffer, start, offset,
-					   length, hpnt->host_no, 0));
-	*eof = (n<length);
+		n = (shost->hostt->proc_info(buffer, start, offset,
+					   length, shost->host_no, 0));
+
+	*eof = (n < length);
 	return n;
 }
 
-#define PROC_BLOCK_SIZE (3*1024)     /* 4K page size, but our output routines 
-				      * use some slack for overruns 
-				      */
-
-static int proc_scsi_write(struct file * file, const char * buf,
+static int proc_scsi_write(struct file *file, const char *buf,
                            unsigned long count, void *data)
 {
-	struct Scsi_Host *hpnt = data;
-	ssize_t ret = 0;
-	char * page;
+	struct Scsi_Host *shost = data;
+	ssize_t ret = -ENOMEM;
+	char *page;
 	char *start;
     
-	if (hpnt->hostt->proc_info == NULL)
-		ret = -ENOSYS;
-
+	if (!shost->hostt->proc_info)
+		return -ENOSYS;
 	if (count > PROC_BLOCK_SIZE)
 		return -EOVERFLOW;
 
-	if (!(page = (char *) __get_free_page(GFP_KERNEL)))
-		return -ENOMEM;
-	if(copy_from_user(page, buf, count))
-	{
-		free_page((ulong) page);
-		return -EFAULT;
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (page) {
+		ret = -EFAULT;
+		if (copy_from_user(page, buf, count))
+			goto out;
+		ret = shost->hostt->proc_info(page, &start, 0, count,
+					      shost->host_no, 1);
 	}
-
-	ret = hpnt->hostt->proc_info(page, &start, 0, count,
-				     hpnt->host_no, 1);
-
-	free_page((ulong) page);
-	return(ret);
-}
-
-void scsi_proc_host_mkdir(Scsi_Host_Template *shost_tp)
-{
-	shost_tp->proc_dir = proc_mkdir(shost_tp->proc_name, proc_scsi);
-        if (!shost_tp->proc_dir) {
-		printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
-		       __FUNCTION__, shost_tp->proc_name);
-                return;
-        }
-	shost_tp->proc_dir->owner = shost_tp->module;
+out:
+	free_page((unsigned long)page);
+	return ret;
 }
 
 void scsi_proc_host_add(struct Scsi_Host *shost)
 {
-	char name[10];
+	Scsi_Host_Template *sht = shost->hostt;
 	struct proc_dir_entry *p;
+	char name[10];
 
-	sprintf(name,"%d",shost->host_no);
-	p = create_proc_read_entry(name,
-			S_IFREG | S_IRUGO | S_IWUSR,
-			shost->hostt->proc_dir,
-			proc_scsi_read,
-			(void *)shost);
+	if (!sht->proc_dir) {
+		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
+        	if (!sht->proc_dir) {
+			printk(KERN_ERR "%s: proc_mkdir failed for %s\n",
+			       __FUNCTION__, sht->proc_name);
+			return;
+		}
+		sht->proc_dir->owner = sht->module;
+	}
+
+	sprintf(name,"%d", shost->host_no);
+	p = create_proc_read_entry(name, S_IFREG | S_IRUGO | S_IWUSR,
+			shost->hostt->proc_dir, proc_scsi_read, shost);
 	if (!p) {
 		printk(KERN_ERR "%s: Failed to register host %d in"
 		       "%s\n", __FUNCTION__, shost->host_no,
 		       shost->hostt->proc_name);
-	} else {
-		p->write_proc=proc_scsi_write;
-		p->owner = shost->hostt->module;
-	}
+		return;
+	} 
+
+	p->write_proc = proc_scsi_write;
+	p->owner = shost->hostt->module;
 
 }
 
 void scsi_proc_host_rm(struct Scsi_Host *shost)
 {
 	char name[10];
-	sprintf(name,"%d",shost->host_no);
-	remove_proc_entry(name, shost->hostt->proc_dir);
-}
 
-/*
- *  parseHandle *parseInit(char *buf, char *cmdList, int cmdNum); 
- *              gets a pointer to a null terminated data buffer
- *              and a list of commands with blanks as delimiter 
- *      in between. 
- *      The commands have to be alphanumerically sorted. 
- *      cmdNum has to contain the number of commands.
- *              On success, a pointer to a handle structure
- *              is returned, NULL on failure
- *
- *      int parseOpt(parseHandle *handle, char **param);
- *              processes the next parameter. On success, the
- *              index of the appropriate command in the cmdList
- *              is returned, starting with zero.
- *              param points to the null terminated parameter string.
- *              On failure, -1 is returned.
- *
- *      The databuffer buf may only contain pairs of commands
- *          options, separated by blanks:
- *              <Command> <Parameter> [<Command> <Parameter>]*
- */
-
-typedef struct {
-	char *buf,		/* command buffer  */
-	*cmdList,		/* command list    */
-	*bufPos,		/* actual position */
-	**cmdPos,		/* cmdList index   */
-	 cmdNum;		/* cmd number      */
-} parseHandle;
-
-inline int parseFree(parseHandle * handle)
-{				/* free memory     */
-	kfree(handle->cmdPos);
-	kfree(handle);
-
-	return -1;
-}
-
-parseHandle *parseInit(char *buf, char *cmdList, int cmdNum)
-{
-	char *ptr;		/* temp pointer    */
-	parseHandle *handle;	/* new handle      */
-
-	if (!buf || !cmdList)	/* bad input ?     */
-		return NULL;
-	handle = (parseHandle *) kmalloc(sizeof(parseHandle), GFP_KERNEL);
-	if (!handle)
-		return NULL;	/* out of memory   */
-	handle->cmdPos = (char **) kmalloc(sizeof(int) * cmdNum, GFP_KERNEL);
-	if (!handle->cmdPos) {
-		kfree(handle);
-		return NULL;	/* out of memory   */
-	}
-	handle->buf = handle->bufPos = buf;	/* init handle     */
-	handle->cmdList = cmdList;
-	handle->cmdNum = cmdNum;
-
-	handle->cmdPos[cmdNum = 0] = cmdList;
-	for (ptr = cmdList; *ptr; ptr++) {	/* scan command string */
-		if (*ptr == ' ') {	/* and insert zeroes   */
-			*ptr++ = 0;
-			handle->cmdPos[++cmdNum] = ptr++;
-		}
-	}
-	return handle;
-}
-
-int parseOpt(parseHandle * handle, char **param)
-{
-	int cmdIndex = 0, cmdLen = 0;
-	char *startPos;
-
-	if (!handle)		/* invalid handle  */
-		return (parseFree(handle));
-	/* skip spaces     */
-	for (; *(handle->bufPos) && *(handle->bufPos) == ' '; handle->bufPos++);
-	if (!*(handle->bufPos))
-		return (parseFree(handle));	/* end of data     */
-
-	startPos = handle->bufPos;	/* store cmd start */
-	for (; handle->cmdPos[cmdIndex][cmdLen] && *(handle->bufPos); handle->bufPos++) {	/* no string end?  */
-		for (;;) {
-			if (*(handle->bufPos) == handle->cmdPos[cmdIndex][cmdLen])
-				break;	/* char matches ?  */
-			else if (memcmp(startPos, (char *) (handle->cmdPos[++cmdIndex]), cmdLen))
-				return (parseFree(handle));	/* unknown command */
-
-			if (cmdIndex >= handle->cmdNum)
-				return (parseFree(handle));	/* unknown command */
-		}
-
-		cmdLen++;	/* next char       */
-	}
-
-	/* Get param. First skip all blanks, then insert zero after param  */
-
-	for (; *(handle->bufPos) && *(handle->bufPos) == ' '; handle->bufPos++);
-	*param = handle->bufPos;
-
-	for (; *(handle->bufPos) && *(handle->bufPos) != ' '; handle->bufPos++);
-	*(handle->bufPos++) = 0;
-
-	return (cmdIndex);
+	sprintf(name,"%d", shost->host_no);
+	remove_proc_entry(name, shost->hostt->proc_dir);
+	if (!shost->hostt->present)
+		remove_proc_entry(shost->hostt->proc_name, proc_scsi);
 }
 
-void proc_print_scsidevice(Scsi_Device * scd, char *buffer, int *size, int len)
+/* XXX: this shouldn't really be exposed to drivers. */
+void proc_print_scsidevice(Scsi_Device * sdev, char *buffer, int *size, int len)
 {
 
 	int x, y = *size;
@@ -272,35 +159,36 @@
 
 	y = sprintf(buffer + len,
 	     "Host: scsi%d Channel: %02d Id: %02d Lun: %02d\n  Vendor: ",
-		    scd->host->host_no, scd->channel, scd->id, scd->lun);
+		    sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 	for (x = 0; x < 8; x++) {
-		if (scd->vendor[x] >= 0x20)
-			y += sprintf(buffer + len + y, "%c", scd->vendor[x]);
+		if (sdev->vendor[x] >= 0x20)
+			y += sprintf(buffer + len + y, "%c", sdev->vendor[x]);
 		else
 			y += sprintf(buffer + len + y, " ");
 	}
 	y += sprintf(buffer + len + y, " Model: ");
 	for (x = 0; x < 16; x++) {
-		if (scd->model[x] >= 0x20)
-			y += sprintf(buffer + len + y, "%c", scd->model[x]);
+		if (sdev->model[x] >= 0x20)
+			y += sprintf(buffer + len + y, "%c", sdev->model[x]);
 		else
 			y += sprintf(buffer + len + y, " ");
 	}
 	y += sprintf(buffer + len + y, " Rev: ");
 	for (x = 0; x < 4; x++) {
-		if (scd->rev[x] >= 0x20)
-			y += sprintf(buffer + len + y, "%c", scd->rev[x]);
+		if (sdev->rev[x] >= 0x20)
+			y += sprintf(buffer + len + y, "%c", sdev->rev[x]);
 		else
 			y += sprintf(buffer + len + y, " ");
 	}
 	y += sprintf(buffer + len + y, "\n");
 
 	y += sprintf(buffer + len + y, "  Type:   %s ",
-		     scd->type < MAX_SCSI_DEVICE_CODE ?
-	       scsi_device_types[(int) scd->type] : "Unknown          ");
+		     sdev->type < MAX_SCSI_DEVICE_CODE ?
+	       scsi_device_types[(int) sdev->type] : "Unknown          ");
 	y += sprintf(buffer + len + y, "               ANSI"
-		     " SCSI revision: %02x", (scd->scsi_level - 1) ? scd->scsi_level - 1 : 1);
-	if (scd->scsi_level == 2)
+		     " SCSI revision: %02x", (sdev->scsi_level - 1) ?
+		     sdev->scsi_level - 1 : 1);
+	if (sdev->scsi_level == 2)
 		y += sprintf(buffer + len + y, " CCS\n");
 	else
 		y += sprintf(buffer + len + y, "\n");
@@ -308,30 +196,474 @@
 	*size = y;
 	return;
 }
+EXPORT_SYMBOL(proc_print_scsidevice);
 
-#else				/* if !CONFIG_PROC_FS */
+/* 
+ * proc_scsi_dev_info_read: dump the scsi_dev_info_list via
+ * /proc/scsi/device_info
+ */
+static int proc_scsi_dev_info_read(char *buffer, char **start, off_t offset,
+				   int length)
+{
+	struct scsi_dev_info_list *devinfo;
+	int size, len = 0;
+	off_t begin = 0;
+	off_t pos = 0;
+
+	list_for_each_entry(devinfo, &scsi_dev_info_list, dev_info_list) {
+		size = sprintf(buffer + len, "'%.8s' '%.16s' 0x%x\n",
+			       devinfo->vendor, devinfo->model, devinfo->flags);
+		len += size;
+		pos = begin + len;
+		if (pos < offset) {
+			len = 0;
+			begin = pos;
+		}
+		if (pos > offset + length)
+			goto stop_output;
+	}
 
-void proc_print_scsidevice(Scsi_Device * scd, char *buffer, int *size, int len)
+stop_output:
+	*start = buffer + (offset - begin);	/* Start of wanted data */
+	len -= (offset - begin);	/* Start slop */
+	if (len > length)
+		len = length;	/* Ending slop */
+	return (len);
+}
+
+/* 
+ * proc_scsi_dev_info_write: allow additions to the scsi_dev_info_list via
+ * /proc.
+ *
+ * Use: echo "vendor:model:flag" > /proc/scsi/device_info
+ *
+ * To add a black/white list entry for vendor and model with an integer
+ * value of flag to the scsi device info list.
+ */
+static int proc_scsi_dev_info_write (struct file * file, const char * buf,
+                              unsigned long length, void *data)
 {
+	char *buffer;
+	int err = length;
+
+	if (!buf || length>PAGE_SIZE)
+		return -EINVAL;
+	if (!(buffer = (char *) __get_free_page(GFP_KERNEL)))
+		return -ENOMEM;
+	if (copy_from_user(buffer, buf, length)) {
+		err =-EFAULT;
+		goto out;
+	}
+
+	if (length < PAGE_SIZE)
+		buffer[length] = '\0';
+	else if (buffer[PAGE_SIZE-1]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	scsi_dev_info_list_add_str(buffer);
+
+out:
+	free_page((unsigned long)buffer);
+	return err;
 }
 
-#endif				/* CONFIG_PROC_FS */
+static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
+{
+	struct Scsi_Host *shost;
+	Scsi_Device *sdev;
+	int size, len = 0;
+	off_t begin = 0;
+	off_t pos = 0;
+
+	/*
+	 * First, see if there are any attached devices or not.
+	 */
+	for (shost = scsi_host_get_next(NULL); shost;
+	     shost = scsi_host_get_next(shost)) {
+		if (shost->host_queue != NULL) {
+			break;
+		}
+	}
+	size = sprintf(buffer + len, "Attached devices: %s\n",
+			(shost) ? "" : "none");
+	len += size;
+	pos = begin + len;
+	for (shost = scsi_host_get_next(NULL); shost;
+	     shost = scsi_host_get_next(shost)) {
+		for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
+			proc_print_scsidevice(sdev, buffer, &size, len);
+			len += size;
+			pos = begin + len;
+
+			if (pos < offset) {
+				len = 0;
+				begin = pos;
+			}
+			if (pos > offset + length)
+				goto stop_output;
+		}
+	}
+
+stop_output:
+	*start = buffer + (offset - begin);	/* Start of wanted data */
+	len -= (offset - begin);	/* Start slop */
+	if (len > length)
+		len = length;	/* Ending slop */
+	return (len);
+}
 
+#ifdef CONFIG_SCSI_LOGGING
 /*
- * Overrides for Emacs so that we get a uniform tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
+ * Function:    scsi_dump_status
+ *
+ * Purpose:     Brain dump of scsi system, used for problem solving.
+ *
+ * Arguments:   level - used to indicate level of detail.
+ *
+ * Notes:       The level isn't used at all yet, but we need to find some
+ *		way of sensibly logging varying degrees of information.
+ *		A quick one-line display of each command, plus the status
+ *		would be most useful.
+ *
+ *              This does depend upon CONFIG_SCSI_LOGGING - I do want some
+ *		way of turning it all off if the user wants a lean and mean
+ *		kernel.  It would probably also be useful to allow the user
+ *		to specify one single host to be dumped.  A second argument
+ *		to the function would be useful for that purpose.
+ *
+ *              FIXME - some formatting of the output into tables would be
+ *		        very handy.
  */
+static void scsi_dump_status(int level)
+{
+	int i;
+	struct Scsi_Host *shpnt;
+	Scsi_Cmnd *SCpnt;
+	Scsi_Device *SDpnt;
+	printk(KERN_INFO "Dump of scsi host parameters:\n");
+	i = 0;
+	for (shpnt = scsi_host_get_next(NULL); shpnt;
+	     shpnt = scsi_host_get_next(shpnt)) {
+		printk(KERN_INFO " %d %d %d : %d %d\n",
+		       shpnt->host_failed,
+		       shpnt->host_busy,
+		       atomic_read(&shpnt->host_active),
+		       shpnt->host_blocked,
+		       shpnt->host_self_blocked);
+	}
+
+	printk(KERN_INFO "\n\n");
+	printk(KERN_INFO "Dump of scsi command parameters:\n");
+	for (shpnt = scsi_host_get_next(NULL); shpnt;
+	     shpnt = scsi_host_get_next(shpnt)) {
+		printk(KERN_INFO "h:c:t:l (dev sect nsect cnumsec sg) "
+			"(ret all flg) (to/cmd to ito) cmd snse result\n");
+		for (SDpnt = shpnt->host_queue; SDpnt; SDpnt = SDpnt->next) {
+			for (SCpnt = SDpnt->device_queue; SCpnt; SCpnt = SCpnt->next) {
+				/*  (0) h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to ito) cmd snse result %d %x      */
+				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
+				       i++,
+
+				       SCpnt->host->host_no,
+				       SCpnt->channel,
+                                       SCpnt->target,
+                                       SCpnt->lun,
+
+                                       SCpnt->request->rq_disk ?
+                                       SCpnt->request->rq_disk->disk_name : "?",
+                                       (unsigned long long)SCpnt->request->sector,
+				       SCpnt->request->nr_sectors,
+				       (long)SCpnt->request->current_nr_sectors,
+				       SCpnt->request->rq_status,
+				       SCpnt->use_sg,
+
+				       SCpnt->retries,
+				       SCpnt->allowed,
+				       SCpnt->flags,
+
+				       SCpnt->timeout_per_command,
+				       SCpnt->timeout,
+				       SCpnt->internal_timeout,
+
+				       SCpnt->cmnd[0],
+				       SCpnt->sense_buffer[2],
+				       SCpnt->result);
+			}
+		}
+	}
+}
+#endif	/* CONFIG_SCSI_LOGGING */ 
+
+static int proc_scsi_gen_write(struct file * file, const char * buf,
+                              unsigned long length, void *data)
+{
+	Scsi_Device *sdev;
+	struct Scsi_Host *shost;
+	char *p;
+	int host, channel, id, lun;
+	char * buffer;
+	int err;
+
+	if (!buf || length>PAGE_SIZE)
+		return -EINVAL;
+
+	buffer = (char *)__get_free_page(GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	if (copy_from_user(buffer, buf, length)) {
+		err =-EFAULT;
+		goto out;
+	}
+
+	err = -EINVAL;
+
+	if (length < PAGE_SIZE)
+		buffer[length] = '\0';
+	else if (buffer[PAGE_SIZE-1])
+		goto out;
+
+	if (length < 11 || strncmp("scsi", buffer, 4))
+		goto out;
+
+#ifdef CONFIG_SCSI_LOGGING
+	/*
+	 * Usage: echo "scsi dump #N" > /proc/scsi/scsi
+	 * to dump status of all scsi commands.  The number is used to
+	 * specify the level of detail in the dump.
+	 */
+	if (!strncmp("dump", buffer + 5, 4)) {
+		unsigned int level;
+
+		p = buffer + 10;
+
+		if (*p == '\0')
+			goto out;
+
+		level = simple_strtoul(p, NULL, 0);
+		scsi_dump_status(level);
+	}
+	/*
+	 * Usage: echo "scsi log token #N" > /proc/scsi/scsi
+	 * where token is one of [error,scan,mlqueue,mlcomplete,llqueue,
+	 * llcomplete,hlqueue,hlcomplete]
+	 */
+	if (!strncmp("log", buffer + 5, 3)) {
+		char *token;
+		unsigned int level;
+
+		p = buffer + 9;
+		token = p;
+		while (*p != ' ' && *p != '\t' && *p != '\0') {
+			p++;
+		}
+
+		if (*p == '\0') {
+			if (strncmp(token, "all", 3) == 0) {
+				/*
+				 * Turn on absolutely everything.
+				 */
+				scsi_logging_level = ~0;
+			} else if (strncmp(token, "none", 4) == 0) {
+				/*
+				 * Turn off absolutely everything.
+				 */
+				scsi_logging_level = 0;
+			} else {
+				goto out;
+			}
+		} else {
+			*p++ = '\0';
+
+			level = simple_strtoul(p, NULL, 0);
+
+			/*
+			 * Now figure out what to do with it.
+			 */
+			if (strcmp(token, "error") == 0) {
+				SCSI_SET_ERROR_RECOVERY_LOGGING(level);
+			} else if (strcmp(token, "timeout") == 0) {
+				SCSI_SET_TIMEOUT_LOGGING(level);
+			} else if (strcmp(token, "scan") == 0) {
+				SCSI_SET_SCAN_BUS_LOGGING(level);
+			} else if (strcmp(token, "mlqueue") == 0) {
+				SCSI_SET_MLQUEUE_LOGGING(level);
+			} else if (strcmp(token, "mlcomplete") == 0) {
+				SCSI_SET_MLCOMPLETE_LOGGING(level);
+			} else if (strcmp(token, "llqueue") == 0) {
+				SCSI_SET_LLQUEUE_LOGGING(level);
+			} else if (strcmp(token, "llcomplete") == 0) {
+				SCSI_SET_LLCOMPLETE_LOGGING(level);
+			} else if (strcmp(token, "hlqueue") == 0) {
+				SCSI_SET_HLQUEUE_LOGGING(level);
+			} else if (strcmp(token, "hlcomplete") == 0) {
+				SCSI_SET_HLCOMPLETE_LOGGING(level);
+			} else if (strcmp(token, "ioctl") == 0) {
+				SCSI_SET_IOCTL_LOGGING(level);
+			} else {
+				goto out;
+			}
+		}
+
+		printk(KERN_INFO "scsi logging level set to 0x%8.8x\n", scsi_logging_level);
+	}
+#endif	/* CONFIG_SCSI_LOGGING */
+
+	/*
+	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
+	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
+	 * Consider this feature BETA.
+	 *     CAUTION: This is not for hotplugging your peripherals. As
+	 *     SCSI was not designed for this you could damage your
+	 *     hardware !
+	 * However perhaps it is legal to switch on an
+	 * already connected device. It is perhaps not
+	 * guaranteed this device doesn't corrupt an ongoing data transfer.
+	 */
+	if (!strncmp("add-single-device", buffer + 5, 17)) {
+		p = buffer + 23;
+
+		host = simple_strtoul(p, &p, 0);
+		channel = simple_strtoul(p + 1, &p, 0);
+		id = simple_strtoul(p + 1, &p, 0);
+		lun = simple_strtoul(p + 1, &p, 0);
+
+		printk(KERN_INFO "scsi singledevice %d %d %d %d\n", host, channel,
+		       id, lun);
+
+		for (shost = scsi_host_get_next(NULL); shost;
+		     shost = scsi_host_get_next(shost)) {
+			if (shost->host_no == host) {
+				break;
+			}
+		}
+		err = -ENXIO;
+		if (!shost)
+			goto out;
+
+		for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
+			if ((sdev->channel == channel
+			     && sdev->id == id
+			     && sdev->lun == lun)) {
+				break;
+			}
+		}
+
+		err = -ENOSYS;
+		if (sdev)
+			goto out;	/* We do not yet support unplugging */
+
+		scan_scsis(shost, 1, channel, id, lun);
+		err = length;
+		goto out;
+	}
+	/*
+	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
+	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
+	 *
+	 * Consider this feature pre-BETA.
+	 *
+	 *     CAUTION: This is not for hotplugging your peripherals. As
+	 *     SCSI was not designed for this you could damage your
+	 *     hardware and thoroughly confuse the SCSI subsystem.
+	 *
+	 */
+	else if (!strncmp("remove-single-device", buffer + 5, 20)) {
+		p = buffer + 26;
+
+		host = simple_strtoul(p, &p, 0);
+		channel = simple_strtoul(p + 1, &p, 0);
+		id = simple_strtoul(p + 1, &p, 0);
+		lun = simple_strtoul(p + 1, &p, 0);
+
+
+		for (shost = scsi_host_get_next(NULL); shost;
+		     shost = scsi_host_get_next(shost)) {
+			if (shost->host_no == host) {
+				break;
+			}
+		}
+		err = -ENODEV;
+		if (!shost)
+			goto out;
+
+		for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
+			if ((sdev->channel == channel
+			     && sdev->id == id
+			     && sdev->lun == lun)) {
+				break;
+			}
+		}
+
+		if (sdev == NULL)
+			goto out;	/* there is no such device attached */
+
+		err = -EBUSY;
+		if (sdev->access_count)
+			goto out;
+
+		scsi_detach_device(sdev);
+
+		if (sdev->attached == 0) {
+			devfs_unregister (sdev->de);
+
+			/* Now we can remove the device structure */
+			if (sdev->next != NULL)
+				sdev->next->prev = sdev->prev;
+
+			if (sdev->prev != NULL)
+				sdev->prev->next = sdev->next;
+
+			if (shost->host_queue == sdev) {
+				shost->host_queue = sdev->next;
+			}
+			blk_cleanup_queue(&sdev->request_queue);
+			if (sdev->inquiry)
+				kfree(sdev->inquiry);
+			kfree((char *) sdev);
+		} else {
+			goto out;
+		}
+		err = 0;
+	}
+out:
+	
+	free_page((unsigned long)buffer);
+	return err;
+}
+
+int __init scsi_init_procfs(void)
+{
+	struct proc_dir_entry *pde;
+
+	proc_scsi = proc_mkdir("scsi", 0);
+	if (!proc_scsi)
+		goto err1;
+
+	pde = create_proc_info_entry("scsi/scsi", 0, 0, scsi_proc_info);
+	if (!pde)
+		goto err2;
+	pde->write_proc = proc_scsi_gen_write;
+
+	pde = create_proc_info_entry("scsi/device_info", 0, 0,
+					  proc_scsi_dev_info_read);
+	if (!pde)
+		goto err3;
+	pde->write_proc = proc_scsi_dev_info_write;
+	return 0;
+
+err3:
+	remove_proc_entry("scsi/scsi", 0);
+err2:
+	remove_proc_entry("scsi", 0);
+err1:
+	return -ENOMEM;
+}
+
+void __exit scsi_exit_procfs(void)
+{
+	remove_proc_entry("scsi/device_info", 0);
+	remove_proc_entry("scsi/scsi", 0);
+	remove_proc_entry("scsi", 0);
+}
===== drivers/scsi/scsi_syms.c 1.18 vs edited =====
--- 1.18/drivers/scsi/scsi_syms.c	Wed Nov  6 16:12:50 2002
+++ edited/drivers/scsi/scsi_syms.c	Sat Nov 16 20:19:19 2002
@@ -74,9 +74,6 @@
 
 EXPORT_SYMBOL(scsi_sleep);
 
-EXPORT_SYMBOL(proc_print_scsidevice);
-EXPORT_SYMBOL(proc_scsi);
-
 EXPORT_SYMBOL(scsi_io_completion);
 EXPORT_SYMBOL(scsi_end_request);
 
