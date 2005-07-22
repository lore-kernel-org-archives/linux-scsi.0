From: Andy Stevens <stevens@electricalscience.com>
Subject: [PATCH] drivers/scsi/st.c: add command and sense history
Date: Fri, 22 Jul 2005 15:52:01 -0400
Message-ID: <42E14E61.2080701@electricalscience.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010805010800000806080500"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cleo.electricalscience.com ([69.93.202.130]:8910 "EHLO
	cleo.electricalscience.com") by vger.kernel.org with ESMTP
	id S261363AbVGVTwG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 15:52:06 -0400
Received: from [192.168.101.236] ([66.167.20.189])
	(authenticated bits=0)
	by cleo.electricalscience.com (8.12.11/8.12.11) with ESMTP id j6MJq5O2019334
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2005 15:52:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010805010800000806080500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello SCSI tapers,

Attached is a patch to add some functionality the st driver so that you 
can monitor the most recent SCSI command and sense buffer.  This info is 
made available via sysfs attributes.  I want to add these attributes in 
order to do better error processing in some custom tape software which I 
am writing.  This patch has been tested on Linux kernel 2.6.12.

The new functionality is as follows:

1) the most recent "relevant" SCSI command and sense are stored in hex 
format in:

   /sys/class/scsi_tape/stN/last_cmnd
   /sys/class/scsi_tape/stN/last_sense

When I say "relevant" SCSI command, I mean: occasionally the most recent 
SCSI command is not the one of interest, e.g. when encountering an ILI, 
the driver will automatically backspace to the beginning of the block. 
However, the last_cmnd and last_sense will show the results of the read 
error, not the backspace.

2) The raw sense data is also decoded into English language for primary 
sense key, extended sense, and ILI/FM/EOM flags in these sysfs files:

   /sys/class/scsi_tape/stN/primary_sense
   /sys/class/scsi_tape/stN/extended_sense
   /sys/class/scsi_tape/stN/sense_flags

Details of implementation:

1) added data fields "last_cmnd" and "last_sense" to struct st_cmdstatus 
for storage of most recent command and sense data.  Removed unused 
"last_cmnd" and "last_sense" fields from struct scsi_tape.

2) added routine st_record_last_command() to save command and sense data

3) added calls to st_record_last_command() in appropriate locations in 
the code.

4) added arg to st_int_ioctl() to indicate whether or not to record the 
SCSI command (necessary so that we can record the "relevant" command)

5) added routines for sysfs attribute files

This is my first time submitting a patch to the list, please go easy on me!!

Regards,

--Andy Stevens
Electrical Science, Inc.
NY, USA


--------------010805010800000806080500
Content-Type: text/plain;
 name="st.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="st.c.patch"

--- st.c.orig	2005-06-17 15:48:29.000000000 -0400
+++ st.c	2005-07-22 15:20:06.000000000 -0400
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20050312";
+static char *verstr = "20050706";
 
 #include <linux/module.h>
 
@@ -215,7 +215,7 @@
 static int find_partition(struct scsi_tape *);
 static int switch_partition(struct scsi_tape *);
 
-static int st_int_ioctl(struct scsi_tape *, unsigned int, unsigned long);
+static int st_int_ioctl(struct scsi_tape *, unsigned int, unsigned long, int);
 
 

 #include "osst_detect.h"
@@ -264,6 +264,29 @@
 	return tape->disk->disk_name;
 }
 
+static void st_clear_last_command(struct scsi_tape *STp)
+{
+	/* clear last command and last sense */
+	memset(STp->buffer->cmdstat.last_cmnd,0,MAX_COMMAND_SIZE);
+	memset(STp->buffer->cmdstat.last_sense,0,SCSI_SENSE_BUFFERSIZE);
+}	
+
+static void st_record_last_command(struct scsi_tape *STp, struct scsi_request *SRpnt)
+{
+	int i;
+
+	st_clear_last_command(STp);
+	
+	/* make copy of last SCSI command */
+	for(i=0; i<MAX_COMMAND_SIZE; i++){
+		STp->buffer->cmdstat.last_cmnd[i] = SRpnt->sr_cmnd[i];
+	}
+
+	/* make copy of last SCSI sense buffer */
+	for(i=0; i<SCSI_SENSE_BUFFERSIZE; i++){
+		STp->buffer->cmdstat.last_sense[i] = SRpnt->sr_sense_buffer[i];
+	}
+}	
 
 static void st_analyze_sense(struct scsi_request *SRpnt, struct st_cmdstatus *s)
 {
@@ -539,6 +562,7 @@
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
 	scsi_release_request(SRpnt);
 	SRpnt = NULL;
 
@@ -587,6 +611,8 @@
 		if (!SRpnt)
 			return (STp->buffer)->syscall_result;
 
+		st_record_last_command(STp,SRpnt);
+
 		STps = &(STp->ps[STp->partition]);
 		if ((STp->buffer)->syscall_result != 0) {
 			struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
@@ -666,7 +692,7 @@
 			}
 		}
 		if (!result && backspace > 0)
-			result = st_int_ioctl(STp, MTBSR, backspace);
+			result = st_int_ioctl(STp, MTBSR, backspace, 1);
 	} else if (STps->eof == ST_FM_HIT) {
 		if (STps->drv_file >= 0)
 			STps->drv_file++;
@@ -700,7 +726,7 @@
 	} else
 		arg |= STp->block_size;
 	if (set_it &&
-	    st_int_ioctl(STp, SET_DENS_AND_BLK, arg)) {
+	    st_int_ioctl(STp, SET_DENS_AND_BLK, arg, 1)) {
 		printk(KERN_WARNING
 		       "%s: Can't set default block size to %d bytes and density %x.\n",
 		       name, STm->default_blksize, STm->default_density);
@@ -786,6 +812,8 @@
 			break;
 		}
 
+		st_record_last_command(STp,SRpnt);
+
 		if (cmdstatp->have_sense) {
 
 			scode = cmdstatp->sense_hdr.sense_key;
@@ -919,6 +947,8 @@
 			goto err_out;
 		}
 
+		st_record_last_command(STp,SRpnt);
+
 		if (!SRpnt->sr_result && !STp->buffer->cmdstat.have_sense) {
 			STp->max_block = ((STp->buffer)->b_data[1] << 16) |
 			    ((STp->buffer)->b_data[2] << 8) | (STp->buffer)->b_data[3];
@@ -946,6 +976,8 @@
 		goto err_out;
 	}
 
+	st_record_last_command(STp,SRpnt);
+
 	if ((STp->buffer)->syscall_result != 0) {
                 DEBC(printk(ST_DEB_MSG "%s: No Mode Sense.\n", name));
 		STp->block_size = ST_DEFAULT_BLOCK;	/* Educated guess (?) */
@@ -1022,7 +1054,7 @@
 		    goto err_out;
 
 		if (STp->default_drvbuffer != 0xff) {
-			if (st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer))
+			if (st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer, 1))
 				printk(KERN_WARNING
                                        "%s: Can't set default drive buffering to %d.\n",
 				       name, STp->default_drvbuffer);
@@ -1173,6 +1205,8 @@
 			goto out;
 		}
 
+		st_record_last_command(STp,SRpnt);
+
 		if (STp->buffer->syscall_result == 0 ||
 		    (cmdstatp->have_sense && !cmdstatp->deferred &&
 		     (cmdstatp->flags & SENSE_EOM) &&
@@ -1226,7 +1260,7 @@
 
       out:
 	if (STp->rew_at_close) {
-		result2 = st_int_ioctl(STp, MTREW, 1);
+		result2 = st_int_ioctl(STp, MTREW, 1, 1);
 		if (result == 0)
 			result = result2;
 	}
@@ -1555,6 +1589,9 @@
 			retval = STbp->syscall_result;
 			goto out;
 		}
+
+		st_record_last_command(STp,SRpnt);
+
 		if (async_write) {
 			STbp->writing = transfer;
 			STp->dirty = !(STbp->writing ==
@@ -1723,6 +1760,8 @@
 	if (!SRpnt)
 		return STbp->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
+
 	STbp->read_pointer = 0;
 	STps->at_sm = 0;
 
@@ -1772,7 +1811,7 @@
 							printk(KERN_NOTICE "%s: Incorrect block size.\n", name);
 							if (STps->drv_block >= 0)
 								STps->drv_block += blks - transfer + 1;
-							st_int_ioctl(STp, MTBSR, 1);
+							st_int_ioctl(STp, MTBSR, 1, 0);
 							return (-EIO);
 						}
 						/* We have some data, deliver it */
@@ -1783,7 +1822,7 @@
                                                             name, count, STbp->buffer_bytes));
 						if (STps->drv_block >= 0)
 							STps->drv_block += 1;
-						if (st_int_ioctl(STp, MTBSR, 1))
+						if (st_int_ioctl(STp, MTBSR, 1, 0))
 							return (-EIO);
 					}
 				} else if (cmdstatp->flags & SENSE_FMK) {	/* FM overrides EOM */
@@ -2160,7 +2199,7 @@
                                        "%s: Drive buffer default set to %x\n",
 				       name, STp->default_drvbuffer));
 				if (STp->ready == ST_READY)
-					st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer);
+					st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer, 1);
 			}
 		} else if (code == MT_ST_DEF_COMPRESSION) {
 			if (value == MT_ST_CLEAR_DEFAULT) {
@@ -2229,6 +2268,7 @@
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
 	scsi_release_request(SRpnt);
 
 	return (STp->buffer)->syscall_result;
@@ -2260,6 +2300,7 @@
 	if (SRpnt == NULL)
 		return (STp->buffer)->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
 	scsi_release_request(SRpnt);
 
 	return (STp->buffer)->syscall_result;
@@ -2385,6 +2426,7 @@
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
 	retval = (STp->buffer)->syscall_result;
 	scsi_release_request(SRpnt);
 
@@ -2427,7 +2469,7 @@
 
 
 /* Internal ioctl function */
-static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned long arg)
+static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned long arg, int record_last)
 {
 	int timeout;
 	long ltmp;
@@ -2582,7 +2624,7 @@
 	case MTEOM:
 		if (!STp->fast_mteom) {
 			/* space to the end of tape */
-			ioctl_result = st_int_ioctl(STp, MTFSF, 0x7fffff);
+			ioctl_result = st_int_ioctl(STp, MTFSF, 0x7fffff, 1);
 			fileno = STps->drv_file;
 			if (STps->eof >= ST_EOD_1)
 				return 0;
@@ -2685,6 +2727,9 @@
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
+	if(record_last)
+		st_record_last_command(STp,SRpnt);
+
 	ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
@@ -2695,9 +2740,9 @@
 		STps->at_sm = at_sm;
 
 		if (cmd_in == MTBSFM)
-			ioctl_result = st_int_ioctl(STp, MTFSF, 1);
+			ioctl_result = st_int_ioctl(STp, MTFSF, 1, 1);
 		else if (cmd_in == MTFSFM)
-			ioctl_result = st_int_ioctl(STp, MTBSF, 1);
+			ioctl_result = st_int_ioctl(STp, MTBSF, 1, 1);
 
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
 			int old_block_size = STp->block_size;
@@ -2805,7 +2850,7 @@
 				STp->use_pf = !STp->use_pf | PF_TESTED;
 				scsi_release_request(SRpnt);
 				SRpnt = NULL;
-				return st_int_ioctl(STp, cmd_in, arg);
+				return st_int_ioctl(STp, cmd_in, arg, 1);
 			}
 		} else if (chg_eof)
 			STps->eof = ST_NOEOF;
@@ -2849,6 +2894,8 @@
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
+
 	if ((STp->buffer)->syscall_result != 0 ||
 	    (STp->device->scsi_level >= SCSI_2 &&
 	     ((STp->buffer)->b_data[0] & 4) != 0)) {
@@ -2954,6 +3001,8 @@
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
+	st_record_last_command(STp,SRpnt);
+
 	STps->drv_block = STps->drv_file = (-1);
 	STps->eof = ST_NOEOF;
 	if ((STp->buffer)->syscall_result != 0) {
@@ -3237,7 +3286,7 @@
 			    (mtc.mt_op == MTREW || mtc.mt_op == MTOFFL ||
 			     mtc.mt_op == MTSEEK ||
 			     mtc.mt_op == MTBSF || mtc.mt_op == MTBSFM)) {
-				i = st_int_ioctl(STp, MTWEOF, 1);
+				i = st_int_ioctl(STp, MTWEOF, 1, 1);
 				if (i < 0) {
 					retval = i;
 					goto out;
@@ -3306,7 +3355,7 @@
 				retval = (-EINVAL);
 				goto out;
 			}
-			if ((i = st_int_ioctl(STp, MTREW, 0)) < 0 ||
+			if ((i = st_int_ioctl(STp, MTREW, 0, 1)) < 0 ||
 			    (i = partition_tape(STp, mtc.mt_count)) < 0) {
 				retval = i;
 				goto out;
@@ -3355,7 +3404,7 @@
 		if (mtc.mt_op == MTCOMPRESSION)
 			retval = st_compression(STp, (mtc.mt_count & 1));
 		else
-			retval = st_int_ioctl(STp, mtc.mt_op, mtc.mt_count);
+			retval = st_int_ioctl(STp, mtc.mt_op, mtc.mt_count, 1);
 		goto out;
 	}
 	if (!STm->defined) {
@@ -3981,6 +4030,11 @@
 			STm->cdevs[j] = cdev;
 
 		}
+		/* copy the per-drive data into each mode so that
+		   we can display it per-mode in sysfs */
+		STm->cmdstat = &tpnt->buffer->cmdstat;
+
+		/* create per-mode sysfs entries */
 		do_create_class_files(tpnt, dev_num, mode);
 	}
 
@@ -4215,6 +4269,94 @@
 
 
 /* The sysfs simple class interface */
+static ssize_t st_last_cmnd_show(struct class_device *class_dev, char *buf)
+{
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	int i;
+	char last_cmnd_as_string[2*MAX_COMMAND_SIZE+1];
+
+	/* convert unsigned char array into string */
+	for(i=0; i<MAX_COMMAND_SIZE; i++){
+		sprintf(last_cmnd_as_string+2*i,"%02x",STm->cmdstat->last_cmnd[i]);
+	}
+
+	return snprintf(buf, PAGE_SIZE, "0x%s\n", last_cmnd_as_string);
+}
+CLASS_DEVICE_ATTR(last_cmnd, S_IRUGO, st_last_cmnd_show, NULL);
+
+static ssize_t st_last_sense_show(struct class_device *class_dev, char *buf)
+{
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	int i;
+	char last_sense_as_string[2*SCSI_SENSE_BUFFERSIZE+1];
+
+	/* convert unsigned char array into string */
+	for(i=0; i<SCSI_SENSE_BUFFERSIZE; i++){
+		sprintf(last_sense_as_string+2*i,"%02x",STm->cmdstat->last_sense[i]);
+	}
+
+	return snprintf(buf, PAGE_SIZE, "0x%s\n", last_sense_as_string);
+}
+CLASS_DEVICE_ATTR(last_sense, S_IRUGO, st_last_sense_show, NULL);
+
+static ssize_t st_primary_sense_show(struct class_device *class_dev, char *buf)
+{
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	struct scsi_sense_hdr sshdr;
+
+	scsi_normalize_sense(STm->cmdstat->last_sense,SCSI_SENSE_BUFFERSIZE,&sshdr);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", (scsi_sense_key_string(sshdr.sense_key) == NULL)?"":scsi_sense_key_string(sshdr.sense_key));
+}
+CLASS_DEVICE_ATTR(primary_sense, S_IRUGO, st_primary_sense_show, NULL);
+
+static ssize_t st_extended_sense_show(struct class_device *class_dev, char *buf)
+{
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	struct scsi_sense_hdr sshdr;
+	const char *extd_sense_fmt;
+	int ret;
+
+	scsi_normalize_sense(STm->cmdstat->last_sense,SCSI_SENSE_BUFFERSIZE,&sshdr);
+	extd_sense_fmt = scsi_extd_sense_format(sshdr.asc, sshdr.ascq);
+
+	if (extd_sense_fmt) {
+		if (strstr(extd_sense_fmt, "%x")){
+			ret = snprintf(buf, PAGE_SIZE, extd_sense_fmt, sshdr.ascq);
+			/* carefully add trailing newline (there must
+			   be a better way to do this!!) */
+			if(ret < PAGE_SIZE){
+				strcat(buf,"\n");
+				ret++;
+			}
+			return ret;
+		}
+		else
+			return snprintf(buf, PAGE_SIZE, "%s\n", extd_sense_fmt);
+	} else {
+		if (sshdr.asc >= 0x80)
+			return snprintf(buf, PAGE_SIZE, "<<vendor>> ASC=0x%02x ASCQ=0x%02x\n", sshdr.asc,sshdr.ascq);
+		else if (sshdr.ascq >= 0x80)
+			return snprintf(buf, PAGE_SIZE, "ASC=0x%02x <<vendor>> ASCQ=0x%02x\n", sshdr.asc,sshdr.ascq);
+		else
+			return snprintf(buf, PAGE_SIZE, "ASC=0x%x ASCQ=0x%x\n", sshdr.asc,sshdr.ascq);
+	}
+
+
+}
+CLASS_DEVICE_ATTR(extended_sense, S_IRUGO, st_extended_sense_show, NULL);
+
+static ssize_t st_sense_flags_show(struct class_device *class_dev, char *buf)
+{
+	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
+	return snprintf(buf, PAGE_SIZE,"%s%s%s\n",
+		        (STm->cmdstat->last_sense[2] & SENSE_ILI)?"ILI ":"",
+			(STm->cmdstat->last_sense[2] & SENSE_FMK)?"FM ":"",
+			(STm->cmdstat->last_sense[2] & SENSE_EOM)?"EOM ":""
+		       );
+}
+CLASS_DEVICE_ATTR(sense_flags, S_IRUGO, st_sense_flags_show, NULL);
+
 static ssize_t st_defined_show(struct class_device *class_dev, char *buf)
 {
 	struct st_modedef *STm = (struct st_modedef *)class_get_devdata(class_dev);
@@ -4296,7 +4438,21 @@
 					 &class_device_attr_default_density);
 		class_device_create_file(st_class_member,
 					 &class_device_attr_default_compression);
+
 		if (mode == 0 && rew == 0) {
+
+			/* put all per-device params in stN */
+			class_device_create_file(st_class_member,
+						 &class_device_attr_last_cmnd);
+			class_device_create_file(st_class_member,
+						 &class_device_attr_last_sense);
+			class_device_create_file(st_class_member,
+						 &class_device_attr_primary_sense);
+			class_device_create_file(st_class_member,
+						 &class_device_attr_extended_sense);
+			class_device_create_file(st_class_member,
+						 &class_device_attr_sense_flags);
+
 			error = sysfs_create_link(&STp->device->sdev_gendev.kobj,
 						  &st_class_member->kobj,
 						  "tape");

--------------010805010800000806080500
Content-Type: text/plain;
 name="st.h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="st.h.patch"

--- st.h.orig	2005-06-17 15:48:29.000000000 -0400
+++ st.h	2005-07-22 15:15:37.000000000 -0400
@@ -15,6 +15,8 @@
 	u8 remainder_valid;
 	u8 fixed_format;
 	u8 deferred;
+	u8 last_sense[SCSI_SENSE_BUFFERSIZE];
+	u8 last_cmnd[MAX_COMMAND_SIZE];
 };
 
 /* The tape buffer descriptor. */
@@ -57,6 +59,7 @@
 	unsigned char default_compression;	/* 0 = don't touch, etc */
 	short default_density;	/* Forced density, -1 = no value */
 	int default_blksize;	/* Forced blocksize, -1 = no value */
+	struct st_cmdstatus *cmdstat;    /* last SCSI response flags */
 	struct cdev *cdevs[2];  /* Auto-rewind and non-rewind devices */
 };
 
@@ -152,8 +155,6 @@
 	int nbr_dio;
 	int nbr_pages;
 	int nbr_combinable;
-	unsigned char last_cmnd[6];
-	unsigned char last_sense[16];
 #endif
 	struct gendisk *disk;
 };

--------------010805010800000806080500--
