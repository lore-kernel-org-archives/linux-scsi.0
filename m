From: akpm@linux-foundation.org
Subject: [patch 21/28] drivers/scsi/ch.c: don't use vprintk as macro
Date: Tue, 27 Apr 2010 14:23:04 -0700
Message-ID: <201004272123.o3RLN4f4020841@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091Ab0D0V1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:27:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>

It's an exported symbol of kernel/printk.c

Rename vprintk and dprintk macros to more common VPRINTK and DPRINTK
Add do { } while(0) around macros
Add level to VPRINTK so KERN_CONT can be used a couple of times.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c |   87 ++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 43 deletions(-)

diff -puN drivers/scsi/ch.c~drivers-scsi-chc-dont-use-vprintk-as-macro drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~drivers-scsi-chc-dont-use-vprintk-as-macro
+++ a/drivers/scsi/ch.c
@@ -84,10 +84,16 @@ static const char * vendor_labels[CH_TYP
 };
 // module_param_string_array(vendor_labels, NULL, 0444);
 
-#define dprintk(fmt, arg...)    if (debug) \
-        printk(KERN_DEBUG "%s: " fmt, ch->name , ## arg)
-#define vprintk(fmt, arg...)    if (verbose) \
-        printk(KERN_INFO "%s: " fmt, ch->name , ## arg)
+#define DPRINTK(fmt, arg...)						\
+do {									\
+	if (debug)							\
+		printk(KERN_DEBUG "%s: " fmt, ch->name, ##arg);		\
+} while (0)
+#define VPRINTK(level, fmt, arg...)					\
+do {									\
+	if (verbose)							\
+		printk(level "%s: " fmt, ch->name, ##arg);		\
+} while (0)
 
 /* ------------------------------------------------------------------- */
 
@@ -186,7 +192,7 @@ ch_do_scsi(scsi_changer *ch, unsigned ch
  retry:
 	errno = 0;
 	if (debug) {
-		dprintk("command: ");
+		DPRINTK("command: ");
 		__scsi_print_command(cmd);
 	}
 
@@ -194,7 +200,7 @@ ch_do_scsi(scsi_changer *ch, unsigned ch
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
-	dprintk("result: 0x%x\n",result);
+	DPRINTK("result: 0x%x\n",result);
 	if (driver_byte(result) & DRIVER_SENSE) {
 		if (debug)
 			scsi_print_sense_hdr(ch->name, &sshdr);
@@ -250,7 +256,7 @@ ch_read_element_status(scsi_changer *ch,
 	cmd[9] = 255;
 	if (0 == (result = ch_do_scsi(ch, cmd, buffer, 256, DMA_FROM_DEVICE))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
-			dprintk("asked for element 0x%02x, got 0x%02x\n",
+			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
 			kfree(buffer);
 			return -EIO;
@@ -259,10 +265,10 @@ ch_read_element_status(scsi_changer *ch,
 	} else {
 		if (ch->voltags) {
 			ch->voltags = 0;
-			vprintk("device has no volume tag support\n");
+			VPRINTK(KERN_INFO, "device has no volume tag support\n");
 			goto retry;
 		}
-		dprintk("READ ELEMENT STATUS for element 0x%x failed\n",elem);
+		DPRINTK("READ ELEMENT STATUS for element 0x%x failed\n",elem);
 	}
 	kfree(buffer);
 	return result;
@@ -274,12 +280,12 @@ ch_init_elem(scsi_changer *ch)
 	int err;
 	u_char cmd[6];
 
-	vprintk("INITIALIZE ELEMENT STATUS, may take some time ...\n");
+	VPRINTK(KERN_INFO, "INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = ch->device->lun << 5;
 	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
-	vprintk("... finished\n");
+	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
 }
 
@@ -322,20 +328,20 @@ ch_readconfig(scsi_changer *ch)
 			(buffer[buffer[3]+18] << 8) | buffer[buffer[3]+19];
 		ch->counts[CHET_DT] =
 			(buffer[buffer[3]+20] << 8) | buffer[buffer[3]+21];
-		vprintk("type #1 (mt): 0x%x+%d [medium transport]\n",
+		VPRINTK(KERN_INFO, "type #1 (mt): 0x%x+%d [medium transport]\n",
 			ch->firsts[CHET_MT],
 			ch->counts[CHET_MT]);
-		vprintk("type #2 (st): 0x%x+%d [storage]\n",
+		VPRINTK(KERN_INFO, "type #2 (st): 0x%x+%d [storage]\n",
 			ch->firsts[CHET_ST],
 			ch->counts[CHET_ST]);
-		vprintk("type #3 (ie): 0x%x+%d [import/export]\n",
+		VPRINTK(KERN_INFO, "type #3 (ie): 0x%x+%d [import/export]\n",
 			ch->firsts[CHET_IE],
 			ch->counts[CHET_IE]);
-		vprintk("type #4 (dt): 0x%x+%d [data transfer]\n",
+		VPRINTK(KERN_INFO, "type #4 (dt): 0x%x+%d [data transfer]\n",
 			ch->firsts[CHET_DT],
 			ch->counts[CHET_DT]);
 	} else {
-		vprintk("reading element address assigment page failed!\n");
+		VPRINTK(KERN_INFO, "reading element address assigment page failed!\n");
 	}
 
 	/* vendor specific element types */
@@ -346,7 +352,7 @@ ch_readconfig(scsi_changer *ch)
 			continue;
 		ch->firsts[CHET_V1+i] = vendor_firsts[i];
 		ch->counts[CHET_V1+i] = vendor_counts[i];
-		vprintk("type #%d (v%d): 0x%x+%d [%s, vendor specific]\n",
+		VPRINTK(KERN_INFO, "type #%d (v%d): 0x%x+%d [%s, vendor specific]\n",
 			i+5,i+1,vendor_firsts[i],vendor_counts[i],
 			vendor_labels[i]);
 	}
@@ -366,21 +372,19 @@ ch_readconfig(scsi_changer *ch)
 		if (elem < CH_DT_MAX  &&  -1 != dt_id[elem]) {
 			id  = dt_id[elem];
 			lun = dt_lun[elem];
-			vprintk("dt 0x%x: [insmod option] ",
+			VPRINTK(KERN_INFO, "dt 0x%x: [insmod option] ",
 				elem+ch->firsts[CHET_DT]);
 		} else if (0 != ch_read_element_status
 			   (ch,elem+ch->firsts[CHET_DT],data)) {
-			vprintk("dt 0x%x: READ ELEMENT STATUS failed\n",
+			VPRINTK(KERN_INFO, "dt 0x%x: READ ELEMENT STATUS failed\n",
 				elem+ch->firsts[CHET_DT]);
 		} else {
-			vprintk("dt 0x%x: ",elem+ch->firsts[CHET_DT]);
+			VPRINTK(KERN_INFO, "dt 0x%x: ",elem+ch->firsts[CHET_DT]);
 			if (data[6] & 0x80) {
-				if (verbose)
-					printk("not this SCSI bus\n");
+				VPRINTK(KERN_CONT, "not this SCSI bus\n");
 				ch->dt[elem] = NULL;
 			} else if (0 == (data[6] & 0x30)) {
-				if (verbose)
-					printk("ID/LUN unknown\n");
+				VPRINTK(KERN_CONT, "ID/LUN unknown\n");
 				ch->dt[elem] = NULL;
 			} else {
 				id  = ch->device->id;
@@ -390,22 +394,19 @@ ch_readconfig(scsi_changer *ch)
 			}
 		}
 		if (-1 != id) {
-			if (verbose)
-				printk("ID %i, LUN %i, ",id,lun);
+			VPRINTK(KERN_CONT, "ID %i, LUN %i, ",id,lun);
 			ch->dt[elem] =
 				scsi_device_lookup(ch->device->host,
 						   ch->device->channel,
 						   id,lun);
 			if (!ch->dt[elem]) {
 				/* should not happen */
-				if (verbose)
-					printk("Huh? device not found!\n");
+				VPRINTK(KERN_CONT, "Huh? device not found!\n");
 			} else {
-				if (verbose)
-					printk("name: %8.8s %16.16s %4.4s\n",
-					       ch->dt[elem]->vendor,
-					       ch->dt[elem]->model,
-					       ch->dt[elem]->rev);
+				VPRINTK(KERN_CONT, "name: %8.8s %16.16s %4.4s\n",
+					ch->dt[elem]->vendor,
+					ch->dt[elem]->model,
+					ch->dt[elem]->rev);
 			}
 		}
 	}
@@ -422,7 +423,7 @@ ch_position(scsi_changer *ch, u_int tran
 {
 	u_char  cmd[10];
 
-	dprintk("position: 0x%x\n",elem);
+	DPRINTK("position: 0x%x\n",elem);
 	if (0 == trans)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
@@ -441,7 +442,7 @@ ch_move(scsi_changer *ch, u_int trans, u
 {
 	u_char  cmd[12];
 
-	dprintk("move: 0x%x => 0x%x\n",src,dest);
+	DPRINTK("move: 0x%x => 0x%x\n",src,dest);
 	if (0 == trans)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
@@ -463,7 +464,7 @@ ch_exchange(scsi_changer *ch, u_int tran
 {
 	u_char  cmd[12];
 
-	dprintk("exchange: 0x%x => 0x%x => 0x%x\n",
+	DPRINTK("exchange: 0x%x => 0x%x => 0x%x\n",
 		src,dest1,dest2);
 	if (0 == trans)
 		trans = ch->firsts[CHET_MT];
@@ -511,7 +512,7 @@ ch_set_voltag(scsi_changer *ch, u_int el
 	if (!buffer)
 		return -ENOMEM;
 
-	dprintk("%s %s voltag: 0x%x => \"%s\"\n",
+	DPRINTK("%s %s voltag: 0x%x => \"%s\"\n",
 		clear     ? "clear"     : "set",
 		alternate ? "alternate" : "primary",
 		elem, tag);
@@ -550,7 +551,7 @@ static int ch_gstatus(scsi_changer *ch, 
 		}
 		put_user(data[2], dest+i);
 		if (data[2] & CESTATUS_EXCEPT)
-			vprintk("element 0x%x: asc=0x%x, ascq=0x%x\n",
+			VPRINTK(KERN_INFO, "element 0x%x: asc=0x%x, ascq=0x%x\n",
 				ch->firsts[type]+i,
 				(int)data[4],(int)data[5]);
 		retval = ch_read_element_status
@@ -660,7 +661,7 @@ static long ch_ioctl(struct file *file,
 			return -EFAULT;
 
 		if (0 != ch_checkrange(ch, pos.cp_type, pos.cp_unit)) {
-			dprintk("CHIOPOSITION: invalid parameter\n");
+			DPRINTK("CHIOPOSITION: invalid parameter\n");
 			return -EBADSLT;
 		}
 		mutex_lock(&ch->lock);
@@ -680,7 +681,7 @@ static long ch_ioctl(struct file *file,
 
 		if (0 != ch_checkrange(ch, mv.cm_fromtype, mv.cm_fromunit) ||
 		    0 != ch_checkrange(ch, mv.cm_totype,   mv.cm_tounit  )) {
-			dprintk("CHIOMOVE: invalid parameter\n");
+			DPRINTK("CHIOMOVE: invalid parameter\n");
 			return -EBADSLT;
 		}
 
@@ -703,7 +704,7 @@ static long ch_ioctl(struct file *file,
 		if (0 != ch_checkrange(ch, mv.ce_srctype,  mv.ce_srcunit ) ||
 		    0 != ch_checkrange(ch, mv.ce_fdsttype, mv.ce_fdstunit) ||
 		    0 != ch_checkrange(ch, mv.ce_sdsttype, mv.ce_sdstunit)) {
-			dprintk("CHIOEXCHANGE: invalid parameter\n");
+			DPRINTK("CHIOEXCHANGE: invalid parameter\n");
 			return -EBADSLT;
 		}
 
@@ -796,7 +797,7 @@ static long ch_ioctl(struct file *file,
 			}
 		} else if (ch->voltags) {
 			ch->voltags = 0;
-			vprintk("device has no volume tag support\n");
+			VPRINTK(KERN_INFO, "device has no volume tag support\n");
 			goto voltag_retry;
 		}
 		kfree(buffer);
@@ -824,7 +825,7 @@ static long ch_ioctl(struct file *file,
 			return -EFAULT;
 
 		if (0 != ch_checkrange(ch, csv.csv_type, csv.csv_unit)) {
-			dprintk("CHIOSVOLTAG: invalid parameter\n");
+			DPRINTK("CHIOSVOLTAG: invalid parameter\n");
 			return -EBADSLT;
 		}
 		elem = ch->firsts[csv.csv_type] + csv.csv_unit;
_
