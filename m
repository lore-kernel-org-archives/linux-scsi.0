From: Andries.Brouwer@cwi.nl
Subject: Re: /proc/scsi/map
Date: Sun, 16 Jun 2002 10:24:28 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200206160824.g5G8OSR28521.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

>> Yes, but I'll wait for 2.5.22 so that it is clear against
>> what tree to diff.

> perhaps you could send your 2.5.21 patch to me

OK. A moment ago I constructed a patch against some random tree
and removed most unrelated stuff. See below.

Andries

diff -u -r linux-2.5.21y/linux/drivers/scsi/hosts.h linux-2.5.21az/linux/drivers/scsi/hosts.h
--- linux-2.5.21y/linux/drivers/scsi/hosts.h	Sun Jun  9 07:28:47 2002
+++ linux-2.5.21az/linux/drivers/scsi/hosts.h	Sat Jun 15 16:41:58 2002
@@ -516,6 +516,7 @@
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. 
                                            Selects command for blkdevs */
+    int (*find_kdev)(Scsi_Device *, char*, kdev_t*);  /* find back dev. */
 };
 
 void  scsi_initialize_queue(Scsi_Device * SDpnt, struct Scsi_Host * SHpnt);
diff -u -r linux-2.5.21y/linux/drivers/scsi/osst.c linux-2.5.21az/linux/drivers/scsi/osst.c
--- linux-2.5.21y/linux/drivers/scsi/osst.c	Sun Jun 16 10:05:40 2002
+++ linux-2.5.21az/linux/drivers/scsi/osst.c	Sun Jun 16 10:13:43 2002
@@ -154,6 +154,7 @@
 static int osst_attach(Scsi_Device *);
 static int osst_detect(Scsi_Device *);
 static void osst_detach(Scsi_Device *);
+static int osst_find_kdev(Scsi_Device *, char*, kdev_t*);
 
 struct Scsi_Device_Template osst_template =
 {
@@ -165,7 +166,8 @@
        detect:		osst_detect,
        init:		osst_init,
        attach:		osst_attach,
-       detach:		osst_detach
+       detach:		osst_detach,
+       find_kdev:	osst_find_kdev,
 };
 
 static int osst_int_ioctl(OS_Scsi_Tape *STp, Scsi_Request ** aSRpnt, unsigned int cmd_in,unsigned long arg);
@@ -5416,6 +5418,24 @@
 	return 0;
 }
 
+static int osst_find_kdev(Scsi_Device *sdp, char* nm, kdev_t *dev)
+{
+	int i;
+	OS_Scsi_Tape *ostp;
+	
+	if (sdp && sdp->type == TYPE_TAPE && osst_supports(sdp)) {
+		for (ostp = os_scsi_tapes[i = 0]; i < osst_template.dev_max;
+		     ostp = os_scsi_tapes[++i]) {
+			if (ostp && ostp->device == sdp) {
+				sprintf (nm, "osst%i", i);
+				*dev = mk_kdev(OSST_MAJOR, i);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 static int osst_attach(Scsi_Device * SDp)
 {
 	OS_Scsi_Tape * tpnt;
diff -u -r linux-2.5.21y/linux/drivers/scsi/scsi.c linux-2.5.21az/linux/drivers/scsi/scsi.c
--- linux-2.5.21y/linux/drivers/scsi/scsi.c	Sun Jun 16 10:05:40 2002
+++ linux-2.5.21az/linux/drivers/scsi/scsi.c	Sat Jun 15 22:36:16 2002
@@ -78,6 +78,7 @@
 
 #ifdef CONFIG_PROC_FS
 static int scsi_proc_info(char *buffer, char **start, off_t offset, int length);
+static int scsi_proc_map (char *buffer, char **start, off_t offset, int length);
 static void scsi_dump_status(int level);
 #endif
 
@@ -1542,6 +1543,73 @@
 }
 
 #ifdef CONFIG_PROC_FS
+/* 
+ * Output the mapping of physical devices (contorller,channel.id,lun)
+ * to devices (sg and other highlevel drivers) to /proc/scsi/map.
+ * Caveat: No locking is done, so if your scsi config changes during
+ * reading this file, you may read garbled data.	KG, 2002-06-14
+ */
+static int scsi_proc_map(char *buffer, char **start, off_t offset, int length)
+{
+	Scsi_Device *scd;
+	struct Scsi_Host *HBA_ptr;
+	int size = 0, len = 0;
+	off_t begin = 0;
+	off_t pos = 0;
+#ifdef CONFIG_KMOD
+	int repeat = 0;
+#endif
+
+	struct Scsi_Device_Template *sg_t;
+	do {
+		sg_t = scsi_devicelist;
+		while (sg_t && !(sg_t->tag && !strcmp(sg_t->tag, "sg")))
+			sg_t = sg_t->next;
+#ifdef CONFIG_KMOD
+		if (!repeat && !sg_t)
+			request_module("sg");
+	} while (!repeat++);
+#else
+	} while (0);
+#endif	
+	/*
+	 * First, see if there are any attached devices or not.
+	 */
+	for (HBA_ptr = scsi_hostlist; HBA_ptr; HBA_ptr = HBA_ptr->next) {
+		if (HBA_ptr->host_queue != NULL) {
+			break;
+		}
+	}
+	if (!HBA_ptr)
+		goto stop_map_output;
+	
+	size = sprintf(buffer + len, "# C,B,T,U\tType\tonl\tsg_nm\tsg_dev\tnm\tdev(hex)\n");
+	len += size;
+	pos = begin + len;
+
+	for (HBA_ptr = scsi_hostlist; HBA_ptr; HBA_ptr = HBA_ptr->next) {
+		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
+			proc_print_scsimap(scd, buffer, &size, len, sg_t);
+			len += size;
+			pos = begin + len;
+
+			if (pos < offset) {
+				len = 0;
+				begin = pos;
+			}
+			if (pos > offset + length)
+				goto stop_map_output;
+		}
+	}
+
+ stop_map_output:
+	*start = buffer + (offset - begin);	/* Start of wanted data */
+	len -= (offset - begin);	/* Start slop */
+	if (len > length)
+		len = length;	/* Ending slop */
+	return (len);
+}
+
 static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
 {
 	Scsi_Device *scd;
@@ -1563,8 +1631,8 @@
 	pos = begin + len;
 	for (HBA_ptr = scsi_hostlist; HBA_ptr; HBA_ptr = HBA_ptr->next) {
 #if 0
-		size += sprintf(buffer + len, "scsi%2d: %s\n", (int) HBA_ptr->host_no,
-				HBA_ptr->hostt->procname);
+		size += sprintf(buffer + len, "scsi%2d: %s\n",
+			(int) HBA_ptr->host_no, HBA_ptr->hostt->procname);
 		len += size;
 		pos = begin + len;
 #endif
@@ -2502,6 +2570,7 @@
 static int __init init_scsi(void)
 {
 	struct proc_dir_entry *generic;
+	struct proc_dir_entry *map;
 	int i;
 
 	printk(KERN_INFO "SCSI subsystem driver " REVISION "\n");
@@ -2538,6 +2607,13 @@
 		return -ENOMEM;
 	}
 	generic->write_proc = proc_scsi_gen_write;
+	
+	map = create_proc_info_entry ("scsi/map", 0, 0, scsi_proc_map);
+	if (!map) {
+		printk (KERN_ERR "cannot init /proc/scsi/map\n");
+		remove_proc_entry("scsi", 0);
+		return -ENOMEM;
+	}
 #endif
 
         scsi_devfs_handle = devfs_mk_dir (NULL, "scsi", NULL);
@@ -2573,6 +2649,7 @@
 
 #ifdef CONFIG_PROC_FS
 	/* No, we're not here anymore. Don't show the /proc/scsi files. */
+	remove_proc_entry ("scsi/map", 0);
 	remove_proc_entry ("scsi/scsi", 0);
 	remove_proc_entry ("scsi", 0);
 #endif
diff -u -r linux-2.5.21y/linux/drivers/scsi/scsi.h linux-2.5.21az/linux/drivers/scsi/scsi.h
--- linux-2.5.21y/linux/drivers/scsi/scsi.h	Sun Jun 16 10:05:40 2002
+++ linux-2.5.21az/linux/drivers/scsi/scsi.h	Sat Jun 15 16:41:58 2002
@@ -523,6 +523,8 @@
  * Prototypes for functions in scsi_proc.c
  */
 extern void proc_print_scsidevice(Scsi_Device *, char *, int *, int);
+extern void proc_print_scsimap(Scsi_Device *, char *, int *, int, 
+			       struct Scsi_Device_Template *);
 extern struct proc_dir_entry *proc_scsi;
 
 /*
diff -u -r linux-2.5.21y/linux/drivers/scsi/scsi_proc.c linux-2.5.21az/linux/drivers/scsi/scsi_proc.c
--- linux-2.5.21y/linux/drivers/scsi/scsi_proc.c	Sun Jun  9 07:27:02 2002
+++ linux-2.5.21az/linux/drivers/scsi/scsi_proc.c	Sat Jun 15 22:49:21 2002
@@ -288,9 +288,10 @@
 
 	y += sprintf(buffer + len + y, "  Type:   %s ",
 		     scd->type < MAX_SCSI_DEVICE_CODE ?
-	       scsi_device_types[(int) scd->type] : "Unknown          ");
-	y += sprintf(buffer + len + y, "               ANSI"
-		     " SCSI revision: %02x", (scd->scsi_level - 1) ? scd->scsi_level - 1 : 1);
+		     scsi_device_types[(int) scd->type] : "Unknown          ");
+	y += sprintf(buffer + len + y,
+		     "               ANSI SCSI revision: %02x",
+		     (scd->scsi_level - 1) ? scd->scsi_level - 1 : 1);
 	if (scd->scsi_level == 2)
 		y += sprintf(buffer + len + y, " CCS\n");
 	else
@@ -300,29 +301,54 @@
 	return;
 }
 
+
+void proc_print_scsimap(Scsi_Device *scd, char *buffer, int *size, int len,
+			struct Scsi_Device_Template *sg_t)
+{
+	int y, err;
+	char nm[16];
+	kdev_t kdev; 
+	int att = scd->attached;
+	struct Scsi_Device_Template *sd_t = scsi_devicelist;
+
+	y = sprintf(buffer + len,
+	     "%i,%i,%02i,%02i\t0x%02x\t%i",
+		    scd->host->host_no, scd->channel, scd->id, scd->lun,
+		    scd->type, scd->online);
+	if (sg_t && sg_t->find_kdev && !(sg_t->find_kdev(scd, nm, &kdev))) {
+		y += sprintf(buffer + len + y,
+			     "\t%s\tc:%02x:%02x",
+			     nm, major(kdev), minor(kdev));
+		--att;
+	} else {
+		y += sprintf(buffer + len + y,
+			     "\tsg?\tc:NN:NN");
+	}
+	while (att && sd_t) {
+		if (sd_t->scsi_type != 0xff && sd_t->find_kdev) {
+			err = sd_t->find_kdev(scd, nm, &kdev);
+			if (!err) {
+				y += sprintf(buffer + len + y,
+					     "\t%s\t%c:%02x:%02x",
+					     nm, (sd_t->blk? 'b': 'c'),
+					     major(kdev), minor(kdev));
+				--att;
+			}
+		}
+		sd_t = sd_t->next;
+	}
+
+	y += sprintf(buffer + len + y, "\n");
+	*size = y;
+}
+
 #else				/* if !CONFIG_PROC_FS */
 
 void proc_print_scsidevice(Scsi_Device * scd, char *buffer, int *size, int len)
 {
 }
+void proc_print_scsimap(Scsi_Device *scd, char *buffer, int *size, int len)
+{
+}
 
 #endif				/* CONFIG_PROC_FS */
-
-/*
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
- */
diff -u -r linux-2.5.21y/linux/drivers/scsi/sd.c linux-2.5.21az/linux/drivers/scsi/sd.c
--- linux-2.5.21y/linux/drivers/scsi/sd.c	Sun Jun 16 10:05:40 2002
+++ linux-2.5.21az/linux/drivers/scsi/sd.c	Sat Jun 15 20:30:34 2002
@@ -102,6 +102,7 @@
 static int sd_detect(Scsi_Device *);
 static void sd_detach(Scsi_Device *);
 static int sd_init_command(Scsi_Cmnd *);
+static int sd_find_kdev(Scsi_Device*, char*, kdev_t*);
 
 static struct Scsi_Device_Template sd_template = {
 	module:THIS_MODULE,
@@ -121,6 +122,7 @@
 	attach:sd_attach,
 	detach:sd_detach,
 	init_command:sd_init_command,
+	find_kdev:sd_find_kdev,
 };
 
 static void sd_rw_intr(Scsi_Cmnd * SCpnt);
@@ -284,6 +286,24 @@
 	}
 }
 
+static int sd_find_kdev(Scsi_Device *sdp, char* nm, kdev_t *dev)
+{
+	Scsi_Disk *sdkp;
+	int dsk_nr;
+
+	if (sdp && (sdp->type == TYPE_DISK || sdp->type == TYPE_MOD)) {
+		for (dsk_nr = 0; dsk_nr < sd_template.dev_max; ++dsk_nr) {
+			sdkp = sd_dsk_arr[dsk_nr];
+			if (sdkp->device == sdp) {
+				sd_dskname(dsk_nr, nm);
+				*dev = MKDEV_SD(dsk_nr);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 /**
  *	sd_find_queue - yields queue associated with device
  *	@dev: kernel device descriptor (kdev_t)
@@ -1190,7 +1210,7 @@
 static int sd_registered;
 
 /**
- *	sd_init- called during driver initialization (after
+ *	sd_init - called during driver initialization (after
  *	sd_detect() is called for each scsi device present).
  *
  *	Returns 0 is successful (or already called); 1 if error
diff -u -r linux-2.5.21y/linux/drivers/scsi/sg.c linux-2.5.21az/linux/drivers/scsi/sg.c
--- linux-2.5.21y/linux/drivers/scsi/sg.c	Sun Jun  9 07:29:42 2002
+++ linux-2.5.21az/linux/drivers/scsi/sg.c	Sun Jun 16 10:18:05 2002
@@ -111,6 +111,7 @@
 static void sg_finish(void);
 static int sg_detect(Scsi_Device *);
 static void sg_detach(Scsi_Device *);
+static int sg_find_kdev(Scsi_Device *, char*, kdev_t*);
 
 static Scsi_Request * dummy_cmdp;	/* only used for sizeof */
 
@@ -120,6 +121,7 @@
 static struct Scsi_Device_Template sg_template =
 {
       module:THIS_MODULE,
+      name:"generic",
       tag:"sg",
       scsi_type:0xff,
       major:SCSI_GENERIC_MAJOR,
@@ -127,7 +129,8 @@
       init:sg_init,
       finish:sg_finish,
       attach:sg_attach,
-      detach:sg_detach
+      detach:sg_detach,
+      find_kdev:sg_find_kdev
 };
 
 
@@ -2632,6 +2635,37 @@
 }
 
 #ifdef CONFIG_PROC_FS
+static int sg_find_kdev(Scsi_Device* sdp, char *nm, kdev_t *dev)
+{
+    unsigned long iflags;
+    int err = 1; 
+
+    if (sdp && sg_dev_arr) {
+	int k;
+	read_lock_irqsave(&sg_dev_arr_lock, iflags);
+	for (k = 0; k < sg_template.dev_max; ++k) {
+	    if (sg_dev_arr[k] && sg_dev_arr[k]->device == sdp) {
+		sprintf (nm, "sg%i", k);
+	        *dev = sg_dev_arr[k]->i_rdev;
+		err = 0;
+		break;
+	    }
+	}
+	read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
+    }
+    return err;
+}
+#else
+/* Not needed without procfs support */
+static int sg_find_kdev(Scsi_Device* sdp, char *nm, kdev_t *dev)
+{
+    *nm = 0;
+    *kdev = NODEV;
+    return 1;
+}
+#endif
+
+#ifdef CONFIG_PROC_FS
 
 static struct proc_dir_entry * sg_proc_sgp = NULL;
 
diff -u -r linux-2.5.21y/linux/drivers/scsi/sr.c linux-2.5.21az/linux/drivers/scsi/sr.c
--- linux-2.5.21y/linux/drivers/scsi/sr.c	Sun Jun 16 10:05:40 2002
+++ linux-2.5.21az/linux/drivers/scsi/sr.c	Sat Jun 15 17:20:17 2002
@@ -69,6 +69,8 @@
 
 static int sr_init_command(Scsi_Cmnd *);
 
+static int sr_find_kdev(Scsi_Device*, char*, kdev_t*);
+
 static struct Scsi_Device_Template sr_template =
 {
 	module:THIS_MODULE,
@@ -82,7 +84,8 @@
 	finish:sr_finish,
 	attach:sr_attach,
 	detach:sr_detach,
-	init_command:sr_init_command
+	init_command:sr_init_command,
+	find_kdev:sr_find_kdev,
 };
 
 Scsi_CD *scsi_CDs;
@@ -469,6 +472,23 @@
 	return 0;
 }
 
+static int sr_find_kdev(Scsi_Device *sdp, char* nm, kdev_t *dev)
+{
+	Scsi_CD *srp;
+	int i;
+	
+	if (sdp && (sdp->type == TYPE_ROM || sdp->type == TYPE_WORM)) {
+		for (srp = scsi_CDs, i = 0; i < sr_template.dev_max;
+		     ++i, ++srp) {
+			if (srp->device == sdp) {
+				sprintf(nm, "sr%i", i);
+				*dev = mk_kdev(SCSI_CDROM_MAJOR,i);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
 
 void get_sectorsize(int i)
 {
diff -u -r linux-2.5.21y/linux/drivers/scsi/st.c linux-2.5.21az/linux/drivers/scsi/st.c
--- linux-2.5.21y/linux/drivers/scsi/st.c	Sun Jun 16 10:05:40 2002
+++ linux-2.5.21az/linux/drivers/scsi/st.c	Sun Jun 16 10:13:14 2002
@@ -156,6 +156,7 @@
 static int st_attach(Scsi_Device *);
 static int st_detect(Scsi_Device *);
 static void st_detach(Scsi_Device *);
+static int st_find_kdev(Scsi_Device*, char*, kdev_t*);
 
 static struct Scsi_Device_Template st_template = {
 	module:		THIS_MODULE,
@@ -165,7 +166,8 @@
 	major:		SCSI_TAPE_MAJOR, 
 	detect:		st_detect, 
 	attach:		st_attach, 
-	detach:		st_detach
+	detach:		st_detach,
+	find_kdev:	st_find_kdev
 };
 
 static int st_compression(Scsi_Tape *, int);
@@ -3910,6 +3912,24 @@
 	return;
 }
 
+static int st_find_kdev(Scsi_Device * sdp, char* nm, kdev_t *dev)
+{
+	int i;
+	Scsi_Tape *stp;
+
+	if (sdp && sdp->type == TYPE_TAPE && !st_incompatible(sdp)) {
+		for (stp = scsi_tapes[0], i = 0; i < st_template.dev_max;
+		     stp = scsi_tapes[++i]) {
+			if (stp && stp->device == sdp) {
+				sprintf(nm, "st%i", i);
+				*dev = mk_kdev(SCSI_TAPE_MAJOR, i);
+				return 0;
+			}
+		}
+	}
+	return 1;
+}
+
 static int __init init_st(void)
 {
 	validate_options();
