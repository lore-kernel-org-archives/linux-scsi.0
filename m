From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug 2.6.9-rc1
Date: Sun, 29 Aug 2004 23:06:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4131D4F3.3060005@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060200090901020509040903"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:58832 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S265222AbUH2NHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2004 09:07:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------060200090901020509040903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

To check descriptor format sense data handling we need a source.
Clean up some other problems and improve support for st.

Changes:
   - add 'dsense' option to generate descriptor sense data
     format (default still fixed format)
   - correct unit attention generation (only INQUIRY, REQUEST_SENSE
     and REPORT_LUNS ignore it)
   - better information sent to log in "noisy" mode (i.e. opts=1)
   - correct and expand standard INQUIRY response, include version
     descriptors
   - filter MODE_SENSE command so that subpage!=0 generates error
   - add REWIND (SSC) command support (NOP)

Doug Gilbert

--------------060200090901020509040903
Content-Type: text/x-patch;
 name="sdebug269rc1_174.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug269rc1_174.diff"

--- linux/drivers/scsi/scsi_debug.c	2004-08-14 21:12:43.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c269rc1_174	2004-08-29 22:36:05.000000000 +1000
@@ -55,8 +55,8 @@
 #include "scsi_logging.h"
 #include "scsi_debug.h"
 
-#define SCSI_DEBUG_VERSION "1.73"
-static const char * scsi_debug_version_date = "20040518";
+#define SCSI_DEBUG_VERSION "1.74"
+static const char * scsi_debug_version_date = "20040829";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -82,8 +82,9 @@
 #define DEF_EVERY_NTH   0
 #define DEF_NUM_PARTS   0
 #define DEF_OPTS   0
-#define DEF_SCSI_LEVEL   3
+#define DEF_SCSI_LEVEL   4    /* SPC-2 */
 #define DEF_PTYPE   0
+#define DEF_D_SENSE   0
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -114,6 +115,7 @@
 static int scsi_debug_opts = DEF_OPTS;
 static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
 static int scsi_debug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
+static int scsi_debug_dsense = DEF_D_SENSE;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -277,7 +279,7 @@
 int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
-	int block, upper_blk, num;
+	int block, upper_blk, num, k;
 	unsigned char *buff;
 	int errsts = 0;
 	int target = SCpnt->device->id;
@@ -305,7 +307,12 @@
 		bufflen = SDEBUG_SENSE_LEN;
 	}
 
-
+	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
+		printk(KERN_INFO "scsi_debug: cmd ");
+		for (k = 0, num = SCpnt->cmd_len; k < num; ++k)
+			printk("%02x ", (int)cmd[k]);
+		printk("\n");
+	}
         if(target == sdebug_driver_template.this_id) {
 		printk(KERN_INFO "scsi_debug: initiator's id used as "
 		       "target!\n");
@@ -331,14 +338,10 @@
         }
 
 	switch (*cmd) {
-	case INQUIRY:     /* mandatory */
+	case INQUIRY:     /* mandatory, ignore unit attention */
 		errsts = resp_inquiry(cmd, target, buff, bufflen, devip);
 		break;
-	case REQUEST_SENSE:	/* mandatory */
-		/* Since this driver indicates autosense by placing the
-		 * sense buffer in the scsi_cmnd structure in the response
-		 * (when SAM_STAT_CHECK_CONDITION is set), the mid level
-		 * shouldn't need to call REQUEST_SENSE */
+	case REQUEST_SENSE:	/* mandatory, ignore unit attention */
 		if (devip) {
 			sbuff = devip->sense_buff;
 			memcpy(buff, sbuff, (bufflen < SDEBUG_SENSE_LEN) ?
@@ -349,20 +352,24 @@
 			buff[0] = 0x70;
 		}
 		break;
+	case REZERO_UNIT:	/* actually this is REWIND for SSC */
 	case START_STOP:
 		errsts = check_reset(SCpnt, devip);
+		memset(buff, 0, bufflen);
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 		if ((errsts = check_reset(SCpnt, devip)))
 			break;
 		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-			printk("\tMedium removal %s\n",
-			       cmd[4] ? "inhibited" : "enabled");
+			printk(KERN_INFO "scsi_debug: Medium removal %s\n",
+			        cmd[4] ? "inhibited" : "enabled");
 		break;
 	case SEND_DIAGNOSTIC:     /* mandatory */
+		errsts = check_reset(SCpnt, devip);
 		memset(buff, 0, bufflen);
 		break;
 	case TEST_UNIT_READY:     /* mandatory */
+		errsts = check_reset(SCpnt, devip);
 		memset(buff, 0, bufflen);
 		break;
         case RESERVE:
@@ -429,7 +436,7 @@
 			errsts = check_condition_result;
 		}
 		break;
-	case REPORT_LUNS:
+	case REPORT_LUNS:	/* mandatory, ignore unit attention */
 		errsts = resp_report_luns(cmd, buff, bufflen, devip);
 		break;
 	case WRITE_16:
@@ -469,14 +476,20 @@
 		break;
 	case MODE_SENSE:
 	case MODE_SENSE_10:
+		if ((errsts = check_reset(SCpnt, devip)))
+			break;
 		errsts = resp_mode_sense(cmd, target, buff, bufflen, devip);
 		break;
 	case SYNCHRONIZE_CACHE:
+		errsts = check_reset(SCpnt, devip);
 		memset(buff, 0, bufflen);
 		break;
 	default:
+		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+			printk(KERN_INFO "scsi_debug: Opcode: 0x%x not "
+			       "supported\n", *cmd);
 		if ((errsts = check_reset(SCpnt, devip)))
-			break;
+			break;	/* Unit attention takes precedence */
 		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_OPCODE, 0, 18);
 		errsts = check_condition_result;
 		break;
@@ -496,6 +509,9 @@
 static int check_reset(struct scsi_cmnd * SCpnt, struct sdebug_dev_info * devip)
 {
 	if (devip->reset) {
+		if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+			printk(KERN_INFO "scsi_debug: Reporting Unit "
+			       "attention: power on reset\n");
 		devip->reset = 0;
 		mk_sense_buffer(devip, UNIT_ATTENTION, POWERON_RESET, 0, 18);
 		return check_condition_result;
@@ -503,7 +519,7 @@
 	return 0;
 }
 
-#define SDEBUG_LONG_INQ_SZ 58
+#define SDEBUG_LONG_INQ_SZ 96
 #define SDEBUG_MAX_INQ_ARR_SZ 128
 
 static const char * vendor_id = "Linux   ";
@@ -593,11 +609,21 @@
 	/* drops through here for a standard inquiry */
 	arr[1] = DEV_REMOVEABLE(target) ? 0x80 : 0;	/* Removable disk */
 	arr[2] = scsi_debug_scsi_level;
+	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
+	arr[6] = 0x1; /* claim: ADDR16 */
 	arr[7] = 0x3a; /* claim: WBUS16, SYNC, LINKED + CMDQUE */
 	memcpy(&arr[8], vendor_id, 8);
 	memcpy(&arr[16], product_id, 16);
 	memcpy(&arr[32], product_rev, 4);
+	/* version descriptors (2 bytes each) follow */
+	arr[58] = 0x0; arr[59] = 0x40; /* SAM-2 */
+	arr[60] = 0x2; arr[61] = 0x60; /* SPC-2 */
+	if (scsi_debug_ptype == 0) {
+	    arr[62] = 0x1; arr[63] = 0x80; /* SBC */
+	} else if (scsi_debug_ptype == 1) {
+	    arr[62] = 0x2; arr[63] = 0x00; /* SSC */
+	}
 	memcpy(buff, arr, min_len);
 	return 0;
 }
@@ -660,6 +686,8 @@
 	unsigned char ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 				     0, 0, 0x2, 0x4b};
 
+	if (scsi_debug_dsense)
+		ctrl_m_pg[2] |= 0x4;
 	memcpy(p, ctrl_m_pg, sizeof(ctrl_m_pg));
 	if (1 == pcontrol)
 		memset(p + 2, 0, sizeof(ctrl_m_pg) - 2);
@@ -683,7 +711,7 @@
 			   struct sdebug_dev_info * devip)
 {
 	unsigned char dbd;
-	int pcontrol, pcode;
+	int pcontrol, pcode, subpcode;
 	unsigned char dev_spec;
 	int alloc_len, msense_6, offset, len;
 	unsigned char * ap;
@@ -695,11 +723,9 @@
 	dbd = cmd[1] & 0x8;
 	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
+	subpcode = cmd[3];
 	msense_6 = (MODE_SENSE == cmd[0]);
 	alloc_len = msense_6 ? cmd[4] : ((cmd[7] << 8) | cmd[8]);
-	/* printk(KERN_INFO "msense: dbd=%d pcontrol=%d pcode=%d "
-		"msense_6=%d alloc_len=%d\n", dbd, pcontrol, pcode, "
-		"msense_6, alloc_len); */
 	if (bufflen < alloc_len)
 		printk(KERN_INFO "scsi_debug: mode_sense: bufflen=%d "
 		       "< alloc_length=%d\n", bufflen, alloc_len);
@@ -720,6 +746,11 @@
 	}
 	ap = arr + offset;
 
+	if (0 != subpcode) { /* TODO: Control Extension page */
+		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
+			       	0, 18);
+		return check_condition_result;
+	}
 	switch (pcode) {
 	case 0x1:	/* Read-Write error recovery page, direct access */
 		len = resp_err_recov_pg(ap, pcontrol, target);
@@ -1023,13 +1054,23 @@
 
 	sbuff = devip->sense_buff;
 	memset(sbuff, 0, SDEBUG_SENSE_LEN);
-	if (inbandLen > SDEBUG_SENSE_LEN)
-		inbandLen = SDEBUG_SENSE_LEN;
-	sbuff[0] = 0x70;
-	sbuff[2] = key;
-	sbuff[7] = (inbandLen > 7) ? (inbandLen - 8) : 0;
-	sbuff[12] = asc;
-	sbuff[13] = asq;
+	if (scsi_debug_dsense) {
+		sbuff[0] = 0x72;  /* descriptor, current */
+		sbuff[1] = key;
+		sbuff[2] = asc;
+		sbuff[3] = asq;
+	} else {
+		if (inbandLen > SDEBUG_SENSE_LEN)
+			inbandLen = SDEBUG_SENSE_LEN;
+		sbuff[0] = 0x70;  /* fixed, current */
+		sbuff[2] = key;
+		sbuff[7] = (inbandLen > 7) ? (inbandLen - 8) : 0;
+		sbuff[12] = asc;
+		sbuff[13] = asq;
+	}
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug:    [sense_key,asc,ascq]: "
+		      "[0x%x,0x%x,0x%x]\n", key, asc, asq);
 }
 
 static int scsi_debug_abort(struct scsi_cmnd * SCpnt)
@@ -1230,17 +1271,11 @@
 			 struct sdebug_dev_info * devip,
 			 done_funct_t done, int scsi_result, int delta_jiff)
 {
-	int k, num;
-
 	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmnd) {
-		printk(KERN_INFO "scsi_debug: cmd ");
-		for (k = 0, num = cmnd->cmd_len; k < num; ++k)
-			printk("%02x ", (int)cmnd->cmnd[k]);
-		printk("\n");
 		if (scsi_result) {
 			struct scsi_device * sdp = cmnd->device;
 
-			printk(KERN_INFO "scsi_debug: ... <%u %u %u %u> "
+			printk(KERN_INFO "scsi_debug:    <%u %u %u %u> "
 			       "non-zero result=0x%x\n", sdp->host->host_no,
 			       sdp->channel, sdp->id, sdp->lun, scsi_result);
 		}
@@ -1296,6 +1331,7 @@
 module_param_named(add_host, scsi_debug_add_host, int, 0); /* perm=0644 */
 module_param_named(delay, scsi_debug_delay, int, 0); /* perm=0644 */
 module_param_named(dev_size_mb, scsi_debug_dev_size_mb, int, 0);
+module_param_named(dsense, scsi_debug_dsense, int, 0);
 module_param_named(every_nth, scsi_debug_every_nth, int, 0);
 module_param_named(max_luns, scsi_debug_max_luns, int, 0);
 module_param_named(num_parts, scsi_debug_num_parts, int, 0);
@@ -1312,13 +1348,14 @@
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs");
+MODULE_PARM_DESC(dsense, "use descriptor sense format(def: fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=100)");
 MODULE_PARM_DESC(max_luns, "number of SCSI LUNs per target to simulate");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of SCSI targets per host to simulate");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_error, 4->...");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
-MODULE_PARM_DESC(scsi_level, "SCSI level to simulate");
+MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=4[SPC-2])");
 
 
 static char sdebug_info[256];
@@ -1452,6 +1489,24 @@
 }
 DRIVER_ATTR(ptype, S_IRUGO | S_IWUSR, sdebug_ptype_show, sdebug_ptype_store);
 
+static ssize_t sdebug_dsense_show(struct device_driver * ddp, char * buf)
+{
+        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dsense);
+}
+static ssize_t sdebug_dsense_store(struct device_driver * ddp,
+				  const char * buf, size_t count)
+{
+        int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		scsi_debug_dsense = n;
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(dsense, S_IRUGO | S_IWUSR, sdebug_dsense_show,
+	    sdebug_dsense_store);
+
 static ssize_t sdebug_num_tgts_show(struct device_driver * ddp, char * buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_num_tgts);

--------------060200090901020509040903--
