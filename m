From: Joe Perches <joe@perches.com>
Subject: [PATCH] drivers/scsi/ch.c: Don't use vprintk as macro
Date: Sun, 28 Feb 2010 13:30:35 -0800
Message-ID: <1267392635.12641.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Davidlohr Bueso <dave@gnu.org>, Scott James Remnant <scott@canonical.com>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

It's an exported symbol of kernel/printk.c

Rename vprintk and dprintk macros to more common VPRINTK and DPRINTK
Add do { } while(0) around macros
Add level to VPRINTK so KERN_CONT can be used a couple of times.

Signed-off-by: Joe Perches <joe@perches.com>
 drivers/scsi/ch.c |   87 +++++++++++++++++++++++++++--------------------------
 1 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fe11c1d..5bd396f 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -83,10 +83,16 @@ static const char * vendor_labels[CH_TYPES-4] = {
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
 
@@ -185,7 +191,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
  retry:
 	errno = 0;
 	if (debug) {
-		dprintk("command: ");
+		DPRINTK("command: ");
 		__scsi_print_command(cmd);
 	}
 
@@ -193,7 +199,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 				  buflength, &sshdr, timeout * HZ,
 				  MAX_RETRIES, NULL);
 
-	dprintk("result: 0x%x\n",result);
+	DPRINTK("result: 0x%x\n",result);
 	if (driver_byte(result) & DRIVER_SENSE) {
 		if (debug)
 			scsi_print_sense_hdr(ch->name, &sshdr);
@@ -249,7 +255,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	cmd[9] = 255;
 	if (0 == (result = ch_do_scsi(ch, cmd, buffer, 256, DMA_FROM_DEVICE))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
-			dprintk("asked for element 0x%02x, got 0x%02x\n",
+			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
 			kfree(buffer);
 			return -EIO;
@@ -258,10 +264,10 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
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
@@ -273,12 +279,12 @@ ch_init_elem(scsi_changer *ch)
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
 
@@ -321,20 +327,20 @@ ch_readconfig(scsi_changer *ch)
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
@@ -345,7 +351,7 @@ ch_readconfig(scsi_changer *ch)
 			continue;
 		ch->firsts[CHET_V1+i] = vendor_firsts[i];
 		ch->counts[CHET_V1+i] = vendor_counts[i];
-		vprintk("type #%d (v%d): 0x%x+%d [%s, vendor specific]\n",
+		VPRINTK(KERN_INFO, "type #%d (v%d): 0x%x+%d [%s, vendor specific]\n",
 			i+5,i+1,vendor_firsts[i],vendor_counts[i],
 			vendor_labels[i]);
 	}
@@ -365,21 +371,19 @@ ch_readconfig(scsi_changer *ch)
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
@@ -389,22 +393,19 @@ ch_readconfig(scsi_changer *ch)
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
@@ -421,7 +422,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 {
 	u_char  cmd[10];
 
-	dprintk("position: 0x%x\n",elem);
+	DPRINTK("position: 0x%x\n",elem);
 	if (0 == trans)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
@@ -440,7 +441,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 {
 	u_char  cmd[12];
 
-	dprintk("move: 0x%x => 0x%x\n",src,dest);
+	DPRINTK("move: 0x%x => 0x%x\n",src,dest);
 	if (0 == trans)
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
@@ -462,7 +463,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 {
 	u_char  cmd[12];
 
-	dprintk("exchange: 0x%x => 0x%x => 0x%x\n",
+	DPRINTK("exchange: 0x%x => 0x%x => 0x%x\n",
 		src,dest1,dest2);
 	if (0 == trans)
 		trans = ch->firsts[CHET_MT];
@@ -510,7 +511,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	if (!buffer)
 		return -ENOMEM;
 
-	dprintk("%s %s voltag: 0x%x => \"%s\"\n",
+	DPRINTK("%s %s voltag: 0x%x => \"%s\"\n",
 		clear     ? "clear"     : "set",
 		alternate ? "alternate" : "primary",
 		elem, tag);
@@ -549,7 +550,7 @@ static int ch_gstatus(scsi_changer *ch, int type, unsigned char __user *dest)
 		}
 		put_user(data[2], dest+i);
 		if (data[2] & CESTATUS_EXCEPT)
-			vprintk("element 0x%x: asc=0x%x, ascq=0x%x\n",
+			VPRINTK(KERN_INFO, "element 0x%x: asc=0x%x, ascq=0x%x\n",
 				ch->firsts[type]+i,
 				(int)data[4],(int)data[5]);
 		retval = ch_read_element_status
@@ -659,7 +660,7 @@ static long ch_ioctl(struct file *file,
 			return -EFAULT;
 
 		if (0 != ch_checkrange(ch, pos.cp_type, pos.cp_unit)) {
-			dprintk("CHIOPOSITION: invalid parameter\n");
+			DPRINTK("CHIOPOSITION: invalid parameter\n");
 			return -EBADSLT;
 		}
 		mutex_lock(&ch->lock);
@@ -679,7 +680,7 @@ static long ch_ioctl(struct file *file,
 
 		if (0 != ch_checkrange(ch, mv.cm_fromtype, mv.cm_fromunit) ||
 		    0 != ch_checkrange(ch, mv.cm_totype,   mv.cm_tounit  )) {
-			dprintk("CHIOMOVE: invalid parameter\n");
+			DPRINTK("CHIOMOVE: invalid parameter\n");
 			return -EBADSLT;
 		}
 
@@ -702,7 +703,7 @@ static long ch_ioctl(struct file *file,
 		if (0 != ch_checkrange(ch, mv.ce_srctype,  mv.ce_srcunit ) ||
 		    0 != ch_checkrange(ch, mv.ce_fdsttype, mv.ce_fdstunit) ||
 		    0 != ch_checkrange(ch, mv.ce_sdsttype, mv.ce_sdstunit)) {
-			dprintk("CHIOEXCHANGE: invalid parameter\n");
+			DPRINTK("CHIOEXCHANGE: invalid parameter\n");
 			return -EBADSLT;
 		}
 
@@ -795,7 +796,7 @@ static long ch_ioctl(struct file *file,
 			}
 		} else if (ch->voltags) {
 			ch->voltags = 0;
-			vprintk("device has no volume tag support\n");
+			VPRINTK(KERN_INFO, "device has no volume tag support\n");
 			goto voltag_retry;
 		}
 		kfree(buffer);
@@ -823,7 +824,7 @@ static long ch_ioctl(struct file *file,
 			return -EFAULT;
 
 		if (0 != ch_checkrange(ch, csv.csv_type, csv.csv_unit)) {
-			dprintk("CHIOSVOLTAG: invalid parameter\n");
+			DPRINTK("CHIOSVOLTAG: invalid parameter\n");
 			return -EBADSLT;
 		}
 		elem = ch->firsts[csv.csv_type] + csv.csv_unit;
