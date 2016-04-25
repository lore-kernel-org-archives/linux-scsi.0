From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 01/12] scsi_debug: cleanup naming and bit crunching
Date: Mon, 25 Apr 2016 12:16:28 -0400
Message-ID: <1461600999-28893-2-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36973 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbcDYQQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:16:57 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

Shorten file scope static and constant names. Use more
get/put_unaligned calls to hide bit banging. Introduce
sdebug_verbose boolean to replace frequent masking of
option bit flags. Add GPL and bump version.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 1162 ++++++++++++++++++++-------------------------
 1 file changed, 525 insertions(+), 637 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f3d69a98..bc586a4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6,23 +6,15 @@
  *  anything out of the ordinary is seen.
  * ^^^^^^^^^^^^^^^^^^^^^^^ Original ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  *
- *  This version is more generic, simulating a variable number of disk
- *  (or disk like devices) sharing a common amount of RAM. To be more
- *  realistic, the simulated devices have the transport attributes of
- *  SAS disks.
+ * Copyright (C) 2001 - 2016 Douglas Gilbert
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
  *
  *  For documentation see http://sg.danny.cz/sg/sdebug26.html
  *
- *   D. Gilbert (dpg) work for Magneto-Optical device test [20010421]
- *   dpg: work for devfs large number of disks [20010809]
- *        forked for lk 2.5 series [20011216, 20020101]
- *        use vmalloc() more inquiry+mode_sense [20020302]
- *        add timers for delayed responses [20020721]
- *   Patrick Mansfield <patmans@us.ibm.com> max_luns+scsi_level [20021031]
- *   Mike Anderson <andmike@us.ibm.com> sysfs work [20021118]
- *   dpg: change style of boot options to "scsi_debug.num_tgts=2" and
- *        module options to "modprobe scsi_debug num_tgts=2" [20021221]
  */
 
 
@@ -66,8 +58,9 @@
 #include "sd.h"
 #include "scsi_logging.h"
 
-#define SCSI_DEBUG_VERSION "1.85"
-static const char *scsi_debug_version_date = "20141022";
+/* make sure inq_product_rev string corresponds to this version */
+#define SCSI_DEBUG_VERSION "1.86"
+static const char *sdebug_version_date = "20160422";
 
 #define MY_NAME "scsi_debug"
 
@@ -145,38 +138,44 @@ static const char *scsi_debug_version_date = "20141022";
 #define DEF_STRICT 0
 #define DELAY_OVERRIDDEN -9999
 
-/* bit mask values for scsi_debug_opts */
-#define SCSI_DEBUG_OPT_NOISE   1
-#define SCSI_DEBUG_OPT_MEDIUM_ERR   2
-#define SCSI_DEBUG_OPT_TIMEOUT   4
-#define SCSI_DEBUG_OPT_RECOVERED_ERR   8
-#define SCSI_DEBUG_OPT_TRANSPORT_ERR   16
-#define SCSI_DEBUG_OPT_DIF_ERR   32
-#define SCSI_DEBUG_OPT_DIX_ERR   64
-#define SCSI_DEBUG_OPT_MAC_TIMEOUT  128
-#define SCSI_DEBUG_OPT_SHORT_TRANSFER	0x100
-#define SCSI_DEBUG_OPT_Q_NOISE	0x200
-#define SCSI_DEBUG_OPT_ALL_TSF	0x400
-#define SCSI_DEBUG_OPT_RARE_TSF	0x800
-#define SCSI_DEBUG_OPT_N_WCE	0x1000
-#define SCSI_DEBUG_OPT_RESET_NOISE 0x2000
-#define SCSI_DEBUG_OPT_NO_CDB_NOISE 0x4000
-#define SCSI_DEBUG_OPT_ALL_NOISE (0x1 | 0x200 | 0x2000)
+/* bit mask values for sdebug_opts */
+#define SDEBUG_OPT_NOISE		1
+#define SDEBUG_OPT_MEDIUM_ERR		2
+#define SDEBUG_OPT_TIMEOUT		4
+#define SDEBUG_OPT_RECOVERED_ERR	8
+#define SDEBUG_OPT_TRANSPORT_ERR	16
+#define SDEBUG_OPT_DIF_ERR		32
+#define SDEBUG_OPT_DIX_ERR		64
+#define SDEBUG_OPT_MAC_TIMEOUT		128
+#define SDEBUG_OPT_SHORT_TRANSFER	0x100
+#define SDEBUG_OPT_Q_NOISE		0x200
+#define SDEBUG_OPT_ALL_TSF		0x400
+#define SDEBUG_OPT_RARE_TSF		0x800
+#define SDEBUG_OPT_N_WCE		0x1000
+#define SDEBUG_OPT_RESET_NOISE		0x2000
+#define SDEBUG_OPT_NO_CDB_NOISE		0x4000
+#define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
+			      SDEBUG_OPT_RESET_NOISE)
+#define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
+				  SDEBUG_OPT_TRANSPORT_ERR | \
+				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
+				  SDEBUG_OPT_SHORT_TRANSFER)
 /* When "every_nth" > 0 then modulo "every_nth" commands:
- *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
+ *   - a no response is simulated if SDEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
- *     commands if SCSI_DEBUG_OPT_RECOVERED_ERR is set.
+ *     commands if SDEBUG_OPT_RECOVERED_ERR is set.
  *   - a TRANSPORT_ERROR is simulated on successful read and write
- *     commands if SCSI_DEBUG_OPT_TRANSPORT_ERR is set.
+ *     commands if SDEBUG_OPT_TRANSPORT_ERR is set.
  *
  * When "every_nth" < 0 then after "- every_nth" commands:
- *   - a no response is simulated if SCSI_DEBUG_OPT_TIMEOUT is set
+ *   - a no response is simulated if SDEBUG_OPT_TIMEOUT is set
  *   - a RECOVERED_ERROR is simulated on successful read and write
- *     commands if SCSI_DEBUG_OPT_RECOVERED_ERR is set.
+ *     commands if SDEBUG_OPT_RECOVERED_ERR is set.
  *   - a TRANSPORT_ERROR is simulated on successful read and write
- *     commands if SCSI_DEBUG_OPT_TRANSPORT_ERR is set.
- * This will continue until some other action occurs (e.g. the user
- * writing a new value (other than -1 or 1) to every_nth via sysfs).
+ *     commands if _DEBUG_OPT_TRANSPORT_ERR is set.
+ * This will continue on every subsequent command until some other action
+ * occurs (e.g. the user * writing a new value (other than -1 or 1) to
+ * every_nth via sysfs).
  */
 
 /* As indicated in SAM-5 and SPC-4 Unit Attentions (UAs)are returned in
@@ -196,7 +195,7 @@ static const char *scsi_debug_version_date = "20141022";
 #define UAS_ONLY 1	/* check for UAs only */
 #define UAS_TUR 0	/* if no UAs then check if media access possible */
 
-/* when 1==SCSI_DEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
+/* when 1==SDEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
  * sector on read commands: */
 #define OPT_MEDIUM_ERR_ADDR   0x1234 /* that's sector 4660 in decimal */
 #define OPT_MEDIUM_ERR_NUM    10     /* number of consecutive medium errs */
@@ -517,47 +516,48 @@ struct sdebug_scmd_extra_t {
 	bool inj_short;
 };
 
-static int scsi_debug_add_host = DEF_NUM_HOST;
-static int scsi_debug_ato = DEF_ATO;
-static int scsi_debug_delay = DEF_DELAY;
-static int scsi_debug_dev_size_mb = DEF_DEV_SIZE_MB;
-static int scsi_debug_dif = DEF_DIF;
-static int scsi_debug_dix = DEF_DIX;
-static int scsi_debug_dsense = DEF_D_SENSE;
-static int scsi_debug_every_nth = DEF_EVERY_NTH;
-static int scsi_debug_fake_rw = DEF_FAKE_RW;
-static unsigned int scsi_debug_guard = DEF_GUARD;
-static int scsi_debug_lowest_aligned = DEF_LOWEST_ALIGNED;
-static int scsi_debug_max_luns = DEF_MAX_LUNS;
-static int scsi_debug_max_queue = SCSI_DEBUG_CANQUEUE;
+static int sdebug_add_host = DEF_NUM_HOST;
+static int sdebug_ato = DEF_ATO;
+static int sdebug_delay = DEF_DELAY;
+static int sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
+static int sdebug_dif = DEF_DIF;
+static int sdebug_dix = DEF_DIX;
+static int sdebug_dsense = DEF_D_SENSE;
+static int sdebug_every_nth = DEF_EVERY_NTH;
+static int sdebug_fake_rw = DEF_FAKE_RW;
+static unsigned int sdebug_guard = DEF_GUARD;
+static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
+static int sdebug_max_luns = DEF_MAX_LUNS;
+static int sdebug_max_queue = SCSI_DEBUG_CANQUEUE;
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
-static int scsi_debug_ndelay = DEF_NDELAY;
-static int scsi_debug_no_lun_0 = DEF_NO_LUN_0;
-static int scsi_debug_no_uld = 0;
-static int scsi_debug_num_parts = DEF_NUM_PARTS;
-static int scsi_debug_num_tgts = DEF_NUM_TGTS; /* targets per host */
-static int scsi_debug_opt_blks = DEF_OPT_BLKS;
-static int scsi_debug_opts = DEF_OPTS;
-static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
-static int scsi_debug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
-static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
-static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
-static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
-static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
-static unsigned int scsi_debug_lbpu = DEF_LBPU;
-static unsigned int scsi_debug_lbpws = DEF_LBPWS;
-static unsigned int scsi_debug_lbpws10 = DEF_LBPWS10;
-static unsigned int scsi_debug_lbprz = DEF_LBPRZ;
-static unsigned int scsi_debug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
-static unsigned int scsi_debug_unmap_granularity = DEF_UNMAP_GRANULARITY;
-static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
-static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
-static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
-static bool scsi_debug_removable = DEF_REMOVABLE;
-static bool scsi_debug_clustering;
-static bool scsi_debug_host_lock = DEF_HOST_LOCK;
-static bool scsi_debug_strict = DEF_STRICT;
+static int sdebug_ndelay = DEF_NDELAY;
+static int sdebug_no_lun_0 = DEF_NO_LUN_0;
+static int sdebug_no_uld;
+static int sdebug_num_parts = DEF_NUM_PARTS;
+static int sdebug_num_tgts = DEF_NUM_TGTS; /* targets per host */
+static int sdebug_opt_blks = DEF_OPT_BLKS;
+static int sdebug_opts = DEF_OPTS;
+static int sdebug_physblk_exp = DEF_PHYSBLK_EXP;
+static int sdebug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
+static int sdebug_scsi_level = DEF_SCSI_LEVEL;
+static int sdebug_sector_size = DEF_SECTOR_SIZE;
+static int sdebug_virtual_gb = DEF_VIRTUAL_GB;
+static int sdebug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
+static unsigned int sdebug_lbpu = DEF_LBPU;
+static unsigned int sdebug_lbpws = DEF_LBPWS;
+static unsigned int sdebug_lbpws10 = DEF_LBPWS10;
+static unsigned int sdebug_lbprz = DEF_LBPRZ;
+static unsigned int sdebug_unmap_alignment = DEF_UNMAP_ALIGNMENT;
+static unsigned int sdebug_unmap_granularity = DEF_UNMAP_GRANULARITY;
+static unsigned int sdebug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
+static unsigned int sdebug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
+static unsigned int sdebug_write_same_length = DEF_WRITESAME_LENGTH;
+static bool sdebug_removable = DEF_REMOVABLE;
+static bool sdebug_clustering;
+static bool sdebug_host_lock = DEF_HOST_LOCK;
+static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
+static bool sdebug_verbose;
 
 static atomic_t sdebug_cmnd_count;
 static atomic_t sdebug_completions;
@@ -580,8 +580,8 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 
 static unsigned int scsi_debug_lbp(void)
 {
-	return ((0 == scsi_debug_fake_rw) &&
-		(scsi_debug_lbpu | scsi_debug_lbpws | scsi_debug_lbpws10));
+	return ((0 == sdebug_fake_rw) &&
+		(sdebug_lbpu | sdebug_lbpws | sdebug_lbpws10));
 }
 
 struct sdebug_dev_info {
@@ -674,7 +674,7 @@ static void *fake_store(unsigned long long lba)
 {
 	lba = do_div(lba, sdebug_store_sectors);
 
-	return fake_storep + lba * scsi_debug_sector_size;
+	return fake_storep + lba * sdebug_sector_size;
 }
 
 static struct sd_dif_tuple *dif_store(sector_t sector)
@@ -696,11 +696,11 @@ static void sdebug_max_tgts_luns(void)
 	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
 		hpnt = sdbg_host->shost;
 		if ((hpnt->this_id >= 0) &&
-		    (scsi_debug_num_tgts > hpnt->this_id))
-			hpnt->max_id = scsi_debug_num_tgts + 1;
+		    (sdebug_num_tgts > hpnt->this_id))
+			hpnt->max_id = sdebug_num_tgts + 1;
 		else
-			hpnt->max_id = scsi_debug_num_tgts;
-		/* scsi_debug_max_luns; */
+			hpnt->max_id = sdebug_num_tgts;
+		/* sdebug_max_luns; */
 		hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
 	}
 	spin_unlock(&sdebug_host_list_lock);
@@ -725,8 +725,7 @@ mk_sense_invalid_fld(struct scsi_cmnd *scp, enum sdeb_cmd_data c_d,
 	}
 	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
 	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
-	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, ILLEGAL_REQUEST,
-				asc, 0);
+	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);
 	memset(sks, 0, sizeof(sks));
 	sks[0] = 0x80;
 	if (c_d)
@@ -736,7 +735,7 @@ mk_sense_invalid_fld(struct scsi_cmnd *scp, enum sdeb_cmd_data c_d,
 		sks[0] |= 0x7 & in_bit;
 	}
 	put_unaligned_be16(in_byte, sks + 1);
-	if (scsi_debug_dsense) {
+	if (sdebug_dsense) {
 		sl = sbuff[7] + 8;
 		sbuff[7] = sl;
 		sbuff[sl] = 0x2;
@@ -744,7 +743,7 @@ mk_sense_invalid_fld(struct scsi_cmnd *scp, enum sdeb_cmd_data c_d,
 		memcpy(sbuff + sl + 4, sks, 3);
 	} else
 		memcpy(sbuff + 15, sks, 3);
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+	if (sdebug_verbose)
 		sdev_printk(KERN_INFO, scp->device, "%s:  [sense_key,asc,ascq"
 			    "]: [0x5,0x%x,0x0] %c byte=%d, bit=%d\n",
 			    my_name, asc, c_d ? 'C' : 'D', in_byte, in_bit);
@@ -762,9 +761,9 @@ static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 	}
 	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
 
-	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, key, asc, asq);
+	scsi_build_sense_buffer(sdebug_dsense, sbuff, key, asc, asq);
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+	if (sdebug_verbose)
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s:  [sense_key,asc,ascq]: [0x%x,0x%x,0x%x]\n",
 			    my_name, key, asc, asq);
@@ -778,7 +777,7 @@ mk_sense_invalid_opcode(struct scsi_cmnd *scp)
 
 static int scsi_debug_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 {
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
+	if (sdebug_verbose) {
 		if (0x1261 == cmd)
 			sdev_printk(KERN_INFO, dev,
 				    "%s: BLKFLSBUF [0x1261]\n", __func__);
@@ -814,7 +813,6 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			   struct sdebug_dev_info * devip)
 {
 	int k;
-	bool debug = !!(SCSI_DEBUG_OPT_NOISE & scsi_debug_opts);
 
 	k = find_first_bit(devip->uas_bm, SDEBUG_NUM_UAS);
 	if (k != SDEBUG_NUM_UAS) {
@@ -824,38 +822,38 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 		case SDEBUG_UA_POR:
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 					UA_RESET_ASC, POWER_ON_RESET_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "power on reset";
 			break;
 		case SDEBUG_UA_BUS_RESET:
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 					UA_RESET_ASC, BUS_RESET_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "bus reset";
 			break;
 		case SDEBUG_UA_MODE_CHANGED:
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 					UA_CHANGED_ASC, MODE_CHANGED_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "mode parameters changed";
 			break;
 		case SDEBUG_UA_CAPACITY_CHANGED:
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 					UA_CHANGED_ASC, CAPACITY_CHANGED_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "capacity data changed";
 			break;
 		case SDEBUG_UA_MICROCODE_CHANGED:
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 				 TARGET_CHANGED_ASC, MICROCODE_CHANGED_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "microcode has been changed";
 			break;
 		case SDEBUG_UA_MICROCODE_CHANGED_WO_RESET:
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 					TARGET_CHANGED_ASC,
 					MICROCODE_CHANGED_WO_RESET_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "microcode has been changed without reset";
 			break;
 		case SDEBUG_UA_LUNS_CHANGED:
@@ -864,26 +862,25 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			 * ASC/ASCQ REPORTED LUNS DATA HAS CHANGED on every LUN
 			 * on the target, until a REPORT LUNS command is
 			 * received.  SPC-4 behavior is to report it only once.
-			 * NOTE:  scsi_debug_scsi_level does not use the same
+			 * NOTE:  sdebug_scsi_level does not use the same
 			 * values as struct scsi_device->scsi_level.
 			 */
-			if (scsi_debug_scsi_level >= 6)	/* SPC-4 and above */
+			if (sdebug_scsi_level >= 6)	/* SPC-4 and above */
 				clear_luns_changed_on_target(devip);
 			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
 					TARGET_CHANGED_ASC,
 					LUNS_CHANGED_ASCQ);
-			if (debug)
+			if (sdebug_verbose)
 				cp = "reported luns data has changed";
 			break;
 		default:
-			pr_warn("%s: unexpected unit attention code=%d\n",
-				__func__, k);
-			if (debug)
+			pr_warn("unexpected unit attention code=%d\n", k);
+			if (sdebug_verbose)
 				cp = "unknown";
 			break;
 		}
 		clear_bit(k, devip->uas_bm);
-		if (debug)
+		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, SCpnt->device,
 				   "%s reports: Unit attention: %s\n",
 				   my_name, cp);
@@ -892,7 +889,7 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 	if ((UAS_TUR == uas_only) && devip->stopped) {
 		mk_sense_buffer(SCpnt, NOT_READY, LOGICAL_UNIT_NOT_READY,
 				0x2);
-		if (debug)
+		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, SCpnt->device,
 				    "%s reports: Not ready: %s\n", my_name,
 				    "initializing command required");
@@ -911,7 +908,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 	if (!sdb->length)
 		return 0;
 	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_FROM_DEVICE))
-		return (DID_ERROR << 16);
+		return DID_ERROR << 16;
 
 	act_len = sg_copy_from_buffer(sdb->table.sgl, sdb->table.nents,
 				      arr, arr_len);
@@ -935,7 +932,10 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 
 static const char * inq_vendor_id = "Linux   ";
 static const char * inq_product_id = "scsi_debug      ";
-static const char *inq_product_rev = "0184";	/* version less '.' */
+static const char *inq_product_rev = "0186";	/* version less '.' */
+static const u64 naa5_comp_a = 0x5222222000000000ULL;
+static const u64 naa5_comp_b = 0x5333333000000000ULL;
+static const u64 naa5_comp_c = 0x5111111000000000ULL;
 
 /* Device identification VPD page. Returns number of bytes placed in arr */
 static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
@@ -963,14 +963,8 @@ static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
 		arr[num++] = 0x3;	/* PIV=0, lu, naa */
 		arr[num++] = 0x0;
 		arr[num++] = 0x8;
-		arr[num++] = 0x53;  /* naa-5 ieee company id=0x333333 (fake) */
-		arr[num++] = 0x33;
-		arr[num++] = 0x33;
-		arr[num++] = 0x30;
-		arr[num++] = (dev_id_num >> 24);
-		arr[num++] = (dev_id_num >> 16) & 0xff;
-		arr[num++] = (dev_id_num >> 8) & 0xff;
-		arr[num++] = dev_id_num & 0xff;
+		put_unaligned_be64(naa5_comp_b + dev_id_num, arr + num);
+		num += 8;
 		/* Target relative port number */
 		arr[num++] = 0x61;	/* proto=sas, binary */
 		arr[num++] = 0x94;	/* PIV=1, target port, rel port */
@@ -986,14 +980,8 @@ static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
 	arr[num++] = 0x93;	/* piv=1, target port, naa */
 	arr[num++] = 0x0;
 	arr[num++] = 0x8;
-	arr[num++] = 0x52;	/* naa-5, company id=0x222222 (fake) */
-	arr[num++] = 0x22;
-	arr[num++] = 0x22;
-	arr[num++] = 0x20;
-	arr[num++] = (port_a >> 24);
-	arr[num++] = (port_a >> 16) & 0xff;
-	arr[num++] = (port_a >> 8) & 0xff;
-	arr[num++] = port_a & 0xff;
+	put_unaligned_be64(naa5_comp_a + port_a, arr + num);
+	num += 8;
 	/* NAA-5, Target port group identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0x95;	/* piv=1, target port group id */
@@ -1001,21 +989,15 @@ static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
 	arr[num++] = 0x4;
 	arr[num++] = 0;
 	arr[num++] = 0;
-	arr[num++] = (port_group_id >> 8) & 0xff;
-	arr[num++] = port_group_id & 0xff;
+	put_unaligned_be16(port_group_id, arr + num);
+	num += 2;
 	/* NAA-5, Target device identifier */
 	arr[num++] = 0x61;	/* proto=sas, binary */
 	arr[num++] = 0xa3;	/* piv=1, target device, naa */
 	arr[num++] = 0x0;
 	arr[num++] = 0x8;
-	arr[num++] = 0x52;	/* naa-5, company id=0x222222 (fake) */
-	arr[num++] = 0x22;
-	arr[num++] = 0x22;
-	arr[num++] = 0x20;
-	arr[num++] = (target_dev_id >> 24);
-	arr[num++] = (target_dev_id >> 16) & 0xff;
-	arr[num++] = (target_dev_id >> 8) & 0xff;
-	arr[num++] = target_dev_id & 0xff;
+	put_unaligned_be64(naa5_comp_a + target_dev_id, arr + num);
+	num += 8;
 	/* SCSI name string: Target device identifier */
 	arr[num++] = 0x63;	/* proto=sas, UTF-8 */
 	arr[num++] = 0xa8;	/* piv=1, target device, SCSI name string */
@@ -1031,7 +1013,6 @@ static int inquiry_evpd_83(unsigned char * arr, int port_group_id,
 	return num;
 }
 
-
 static unsigned char vpd84_data[] = {
 /* from 4th byte */ 0x22,0x22,0x22,0x0,0xbb,0x0,
     0x22,0x22,0x22,0x0,0xbb,0x1,
@@ -1101,15 +1082,8 @@ static int inquiry_evpd_88(unsigned char * arr, int target_dev_id)
 	arr[num++] = 0x93;	/* PIV=1, target port, NAA */
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x8;	/* length */
-	arr[num++] = 0x52;	/* NAA-5, company_id=0x222222 (fake) */
-	arr[num++] = 0x22;
-	arr[num++] = 0x22;
-	arr[num++] = 0x20;
-	arr[num++] = (port_a >> 24);
-	arr[num++] = (port_a >> 16) & 0xff;
-	arr[num++] = (port_a >> 8) & 0xff;
-	arr[num++] = port_a & 0xff;
-
+	put_unaligned_be64(naa5_comp_a + port_a, arr + num);
+	num += 8;
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x0;
@@ -1123,14 +1097,8 @@ static int inquiry_evpd_88(unsigned char * arr, int target_dev_id)
 	arr[num++] = 0x93;	/* PIV=1, target port, NAA */
 	arr[num++] = 0x0;	/* reserved */
 	arr[num++] = 0x8;	/* length */
-	arr[num++] = 0x52;	/* NAA-5, company_id=0x222222 (fake) */
-	arr[num++] = 0x22;
-	arr[num++] = 0x22;
-	arr[num++] = 0x20;
-	arr[num++] = (port_b >> 24);
-	arr[num++] = (port_b >> 16) & 0xff;
-	arr[num++] = (port_b >> 8) & 0xff;
-	arr[num++] = port_b & 0xff;
+	put_unaligned_be64(naa5_comp_a + port_b, arr + num);
+	num += 8;
 
 	return num;
 }
@@ -1203,40 +1171,35 @@ static int inquiry_evpd_b0(unsigned char * arr)
 	memcpy(arr, vpdb0_data, sizeof(vpdb0_data));
 
 	/* Optimal transfer length granularity */
-	gran = 1 << scsi_debug_physblk_exp;
-	arr[2] = (gran >> 8) & 0xff;
-	arr[3] = gran & 0xff;
+	gran = 1 << sdebug_physblk_exp;
+	put_unaligned_be16(gran, arr + 2);
 
 	/* Maximum Transfer Length */
-	if (sdebug_store_sectors > 0x400) {
-		arr[4] = (sdebug_store_sectors >> 24) & 0xff;
-		arr[5] = (sdebug_store_sectors >> 16) & 0xff;
-		arr[6] = (sdebug_store_sectors >> 8) & 0xff;
-		arr[7] = sdebug_store_sectors & 0xff;
-	}
+	if (sdebug_store_sectors > 0x400)
+		put_unaligned_be32(sdebug_store_sectors, arr + 4);
 
 	/* Optimal Transfer Length */
-	put_unaligned_be32(scsi_debug_opt_blks, &arr[8]);
+	put_unaligned_be32(sdebug_opt_blks, &arr[8]);
 
-	if (scsi_debug_lbpu) {
+	if (sdebug_lbpu) {
 		/* Maximum Unmap LBA Count */
-		put_unaligned_be32(scsi_debug_unmap_max_blocks, &arr[16]);
+		put_unaligned_be32(sdebug_unmap_max_blocks, &arr[16]);
 
 		/* Maximum Unmap Block Descriptor Count */
-		put_unaligned_be32(scsi_debug_unmap_max_desc, &arr[20]);
+		put_unaligned_be32(sdebug_unmap_max_desc, &arr[20]);
 	}
 
 	/* Unmap Granularity Alignment */
-	if (scsi_debug_unmap_alignment) {
-		put_unaligned_be32(scsi_debug_unmap_alignment, &arr[28]);
+	if (sdebug_unmap_alignment) {
+		put_unaligned_be32(sdebug_unmap_alignment, &arr[28]);
 		arr[28] |= 0x80; /* UGAVALID */
 	}
 
 	/* Optimal Unmap Granularity */
-	put_unaligned_be32(scsi_debug_unmap_granularity, &arr[24]);
+	put_unaligned_be32(sdebug_unmap_granularity, &arr[24]);
 
 	/* Maximum WRITE SAME Length */
-	put_unaligned_be64(scsi_debug_write_same_length, &arr[32]);
+	put_unaligned_be64(sdebug_write_same_length, &arr[32]);
 
 	return 0x3c; /* Mandatory page length for Logical Block Provisioning */
 
@@ -1261,16 +1224,16 @@ static int inquiry_evpd_b2(unsigned char *arr)
 	memset(arr, 0, 0x4);
 	arr[0] = 0;			/* threshold exponent */
 
-	if (scsi_debug_lbpu)
+	if (sdebug_lbpu)
 		arr[1] = 1 << 7;
 
-	if (scsi_debug_lbpws)
+	if (sdebug_lbpws)
 		arr[1] |= 1 << 6;
 
-	if (scsi_debug_lbpws10)
+	if (sdebug_lbpws10)
 		arr[1] |= 1 << 5;
 
-	if (scsi_debug_lbprz)
+	if (sdebug_lbprz)
 		arr[1] |= 1 << 2;
 
 	return 0x4;
@@ -1287,17 +1250,17 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int alloc_len, n, ret;
 	bool have_wlun;
 
-	alloc_len = (cmd[3] << 8) + cmd[4];
+	alloc_len = get_unaligned_be16(cmd + 3);
 	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
 	have_wlun = (scp->device->lun == SCSI_W_LUN_REPORT_LUNS);
 	if (have_wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
-	else if (scsi_debug_no_lun_0 && (0 == devip->lun))
+	else if (sdebug_no_lun_0 && (0 == devip->lun))
 		pq_pdt = 0x7f;	/* not present, no device type */
 	else
-		pq_pdt = (scsi_debug_ptype & 0x1f);
+		pq_pdt = (sdebug_ptype & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
@@ -1310,7 +1273,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		
 		port_group_id = (((host_no + 1) & 0x7f) << 8) +
 		    (devip->channel & 0x7f);
-		if (0 == scsi_debug_vpd_use_hostno)
+		if (0 == sdebug_vpd_use_hostno)
 			host_no = 0;
 		lu_id_num = have_wlun ? -1 : (((host_no + 1) * 2000) +
 			    (devip->target * 1000) + devip->lun);
@@ -1352,9 +1315,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		} else if (0x86 == cmd[2]) { /* extended inquiry */
 			arr[1] = cmd[2];	/*sanity */
 			arr[3] = 0x3c;	/* number of following entries */
-			if (scsi_debug_dif == SD_DIF_TYPE3_PROTECTION)
+			if (sdebug_dif == SD_DIF_TYPE3_PROTECTION)
 				arr[4] = 0x4;	/* SPT: GRD_CHK:1 */
-			else if (scsi_debug_dif)
+			else if (sdebug_dif)
 				arr[4] = 0x5;   /* SPT: GRD_CHK:1, REF_CHK:1 */
 			else
 				arr[4] = 0x0;   /* no protection stuff */
@@ -1372,8 +1335,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		} else if (0x89 == cmd[2]) { /* ATA information */
 			arr[1] = cmd[2];        /*sanity */
 			n = inquiry_evpd_89(&arr[4]);
-			arr[2] = (n >> 8);
-			arr[3] = (n & 0xff);
+			put_unaligned_be16(n, arr + 2);
 		} else if (0xb0 == cmd[2]) { /* Block limits (SBC) */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_evpd_b0(&arr[4]);
@@ -1388,19 +1350,19 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			kfree(arr);
 			return check_condition_result;
 		}
-		len = min(((arr[2] << 8) + arr[3]) + 4, alloc_len);
+		len = min(get_unaligned_be16(arr + 2) + 4, alloc_len);
 		ret = fill_from_dev_buffer(scp, arr,
 			    min(len, SDEBUG_MAX_INQ_ARR_SZ));
 		kfree(arr);
 		return ret;
 	}
 	/* drops through here for a standard inquiry */
-	arr[1] = scsi_debug_removable ? 0x80 : 0;	/* Removable disk */
-	arr[2] = scsi_debug_scsi_level;
+	arr[1] = sdebug_removable ? 0x80 : 0;	/* Removable disk */
+	arr[2] = sdebug_scsi_level;
 	arr[3] = 2;    /* response_data_format==2 */
 	arr[4] = SDEBUG_LONG_INQ_SZ - 5;
-	arr[5] = scsi_debug_dif ? 1 : 0; /* PROTECT bit */
-	if (0 == scsi_debug_vpd_use_hostno)
+	arr[5] = sdebug_dif ? 1 : 0; /* PROTECT bit */
+	if (0 == sdebug_vpd_use_hostno)
 		arr[5] = 0x10; /* claim: implicit TGPS */
 	arr[6] = 0x10; /* claim: MultiP */
 	/* arr[6] |= 0x40; ... claim: EncServ (enclosure services) */
@@ -1412,9 +1374,9 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	arr[58] = 0x0; arr[59] = 0xa2;  /* SAM-5 rev 4 */
 	arr[60] = 0x4; arr[61] = 0x68;  /* SPC-4 rev 37 */
 	n = 62;
-	if (scsi_debug_ptype == 0) {
+	if (sdebug_ptype == 0) {
 		arr[n++] = 0x4; arr[n++] = 0xc5; /* SBC-4 rev 36 */
-	} else if (scsi_debug_ptype == 1) {
+	} else if (sdebug_ptype == 1) {
 		arr[n++] = 0x5; arr[n++] = 0x25; /* SSC-4 rev 3 */
 	}
 	arr[n++] = 0x20; arr[n++] = 0xe6;  /* SPL-3 rev 7 */
@@ -1452,7 +1414,7 @@ static int resp_requests(struct scsi_cmnd * scp,
 		}
 	} else {
 		memcpy(arr, sbuff, SCSI_SENSE_BUFFERSIZE);
-		if (arr[0] >= 0x70 && dsense == scsi_debug_dsense)
+		if (arr[0] >= 0x70 && dsense == sdebug_dsense)
 			;	/* have sense and formats match */
 		else if (arr[0] <= 0x70) {
 			if (dsense) {
@@ -1504,9 +1466,11 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 
 static sector_t get_sdebug_capacity(void)
 {
-	if (scsi_debug_virtual_gb > 0)
-		return (sector_t)scsi_debug_virtual_gb *
-			(1073741824 / scsi_debug_sector_size);
+	static const unsigned int gibibyte = 1073741824;
+
+	if (sdebug_virtual_gb > 0)
+		return (sector_t)sdebug_virtual_gb *
+			(gibibyte / sdebug_sector_size);
 	else
 		return sdebug_store_sectors;
 }
@@ -1523,18 +1487,10 @@ static int resp_readcap(struct scsi_cmnd * scp,
 	memset(arr, 0, SDEBUG_READCAP_ARR_SZ);
 	if (sdebug_capacity < 0xffffffff) {
 		capac = (unsigned int)sdebug_capacity - 1;
-		arr[0] = (capac >> 24);
-		arr[1] = (capac >> 16) & 0xff;
-		arr[2] = (capac >> 8) & 0xff;
-		arr[3] = capac & 0xff;
-	} else {
-		arr[0] = 0xff;
-		arr[1] = 0xff;
-		arr[2] = 0xff;
-		arr[3] = 0xff;
-	}
-	arr[6] = (scsi_debug_sector_size >> 8) & 0xff;
-	arr[7] = scsi_debug_sector_size & 0xff;
+		put_unaligned_be32(capac, arr + 0);
+	} else
+		put_unaligned_be32(0xffffffff, arr + 0);
+	put_unaligned_be16(sdebug_sector_size, arr + 6);
 	return fill_from_dev_buffer(scp, arr, SDEBUG_READCAP_ARR_SZ);
 }
 
@@ -1544,34 +1500,27 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 {
 	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
-	unsigned long long capac;
-	int k, alloc_len;
+	int alloc_len;
 
-	alloc_len = ((cmd[10] << 24) + (cmd[11] << 16) + (cmd[12] << 8)
-		     + cmd[13]);
+	alloc_len = get_unaligned_be32(cmd + 10);
 	/* following just in case virtual_gb changed */
 	sdebug_capacity = get_sdebug_capacity();
 	memset(arr, 0, SDEBUG_READCAP16_ARR_SZ);
-	capac = sdebug_capacity - 1;
-	for (k = 0; k < 8; ++k, capac >>= 8)
-		arr[7 - k] = capac & 0xff;
-	arr[8] = (scsi_debug_sector_size >> 24) & 0xff;
-	arr[9] = (scsi_debug_sector_size >> 16) & 0xff;
-	arr[10] = (scsi_debug_sector_size >> 8) & 0xff;
-	arr[11] = scsi_debug_sector_size & 0xff;
-	arr[13] = scsi_debug_physblk_exp & 0xf;
-	arr[14] = (scsi_debug_lowest_aligned >> 8) & 0x3f;
+	put_unaligned_be64((u64)(sdebug_capacity - 1), arr + 0);
+	put_unaligned_be32(sdebug_sector_size, arr + 8);
+	arr[13] = sdebug_physblk_exp & 0xf;
+	arr[14] = (sdebug_lowest_aligned >> 8) & 0x3f;
 
 	if (scsi_debug_lbp()) {
 		arr[14] |= 0x80; /* LBPME */
-		if (scsi_debug_lbprz)
+		if (sdebug_lbprz)
 			arr[14] |= 0x40; /* LBPRZ */
 	}
 
-	arr[15] = scsi_debug_lowest_aligned & 0xff;
+	arr[15] = sdebug_lowest_aligned & 0xff;
 
-	if (scsi_debug_dif) {
-		arr[12] = (scsi_debug_dif - 1) << 1; /* P_TYPE */
+	if (sdebug_dif) {
+		arr[12] = (sdebug_dif - 1) << 1; /* P_TYPE */
 		arr[12] |= 1; /* PROT_EN */
 	}
 
@@ -1590,9 +1539,7 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 	int n, ret, alen, rlen;
 	int port_group_a, port_group_b, port_a, port_b;
 
-	alen = ((cmd[6] << 24) + (cmd[7] << 16) + (cmd[8] << 8)
-		+ cmd[9]);
-
+	alen = get_unaligned_be32(cmd + 6);
 	arr = kzalloc(SDEBUG_MAX_TGTPGS_ARR_SZ, GFP_ATOMIC);
 	if (! arr)
 		return DID_REQUEUE << 16;
@@ -1605,49 +1552,46 @@ static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 	port_a = 0x1; /* relative port A */
 	port_b = 0x2; /* relative port B */
 	port_group_a = (((host_no + 1) & 0x7f) << 8) +
-	    (devip->channel & 0x7f);
+			(devip->channel & 0x7f);
 	port_group_b = (((host_no + 1) & 0x7f) << 8) +
-	    (devip->channel & 0x7f) + 0x80;
+			(devip->channel & 0x7f) + 0x80;
 
 	/*
 	 * The asymmetric access state is cycled according to the host_id.
 	 */
 	n = 4;
-	if (0 == scsi_debug_vpd_use_hostno) {
-	    arr[n++] = host_no % 3; /* Asymm access state */
-	    arr[n++] = 0x0F; /* claim: all states are supported */
+	if (0 == sdebug_vpd_use_hostno) {
+		arr[n++] = host_no % 3; /* Asymm access state */
+		arr[n++] = 0x0F; /* claim: all states are supported */
 	} else {
-	    arr[n++] = 0x0; /* Active/Optimized path */
-	    arr[n++] = 0x01; /* claim: only support active/optimized paths */
+		arr[n++] = 0x0; /* Active/Optimized path */
+		arr[n++] = 0x01; /* only support active/optimized paths */
 	}
-	arr[n++] = (port_group_a >> 8) & 0xff;
-	arr[n++] = port_group_a & 0xff;
+	put_unaligned_be16(port_group_a, arr + n);
+	n += 2;
 	arr[n++] = 0;    /* Reserved */
 	arr[n++] = 0;    /* Status code */
 	arr[n++] = 0;    /* Vendor unique */
 	arr[n++] = 0x1;  /* One port per group */
 	arr[n++] = 0;    /* Reserved */
 	arr[n++] = 0;    /* Reserved */
-	arr[n++] = (port_a >> 8) & 0xff;
-	arr[n++] = port_a & 0xff;
+	put_unaligned_be16(port_a, arr + n);
+	n += 2;
 	arr[n++] = 3;    /* Port unavailable */
 	arr[n++] = 0x08; /* claim: only unavailalbe paths are supported */
-	arr[n++] = (port_group_b >> 8) & 0xff;
-	arr[n++] = port_group_b & 0xff;
+	put_unaligned_be16(port_group_b, arr + n);
+	n += 2;
 	arr[n++] = 0;    /* Reserved */
 	arr[n++] = 0;    /* Status code */
 	arr[n++] = 0;    /* Vendor unique */
 	arr[n++] = 0x1;  /* One port per group */
 	arr[n++] = 0;    /* Reserved */
 	arr[n++] = 0;    /* Reserved */
-	arr[n++] = (port_b >> 8) & 0xff;
-	arr[n++] = port_b & 0xff;
+	put_unaligned_be16(port_b, arr + n);
+	n += 2;
 
 	rlen = n - 4;
-	arr[0] = (rlen >> 24) & 0xff;
-	arr[1] = (rlen >> 16) & 0xff;
-	arr[2] = (rlen >> 8) & 0xff;
-	arr[3] = rlen & 0xff;
+	put_unaligned_be32(rlen, arr + 0);
 
 	/*
 	 * Return the smallest value of either
@@ -1871,11 +1815,9 @@ static int resp_format_pg(unsigned char * p, int pcontrol, int target)
 				     0, 0, 0, 0, 0x40, 0, 0, 0};
 
 	memcpy(p, format_pg, sizeof(format_pg));
-	p[10] = (sdebug_sectors_per >> 8) & 0xff;
-	p[11] = sdebug_sectors_per & 0xff;
-	p[12] = (scsi_debug_sector_size >> 8) & 0xff;
-	p[13] = scsi_debug_sector_size & 0xff;
-	if (scsi_debug_removable)
+	put_unaligned_be16(sdebug_sectors_per, p + 10);
+	put_unaligned_be16(sdebug_sector_size, p + 12);
+	if (sdebug_removable)
 		p[20] |= 0x20; /* should agree with INQUIRY */
 	if (1 == pcontrol)
 		memset(p + 2, 0, sizeof(format_pg) - 2);
@@ -1889,7 +1831,7 @@ static int resp_caching_pg(unsigned char * p, int pcontrol, int target)
 	unsigned char d_caching_pg[] = {0x8, 18, 0x14, 0, 0xff, 0xff, 0, 0,
 		0xff, 0xff, 0xff, 0xff, 0x80, 0x14, 0, 0,     0, 0, 0, 0};
 
-	if (SCSI_DEBUG_OPT_N_WCE & scsi_debug_opts)
+	if (SDEBUG_OPT_N_WCE & sdebug_opts)
 		caching_pg[2] &= ~0x4;	/* set WCE=0 (default WCE=1) */
 	memcpy(p, caching_pg, sizeof(caching_pg));
 	if (1 == pcontrol)
@@ -1906,12 +1848,12 @@ static int resp_ctrl_m_pg(unsigned char * p, int pcontrol, int target)
 	unsigned char d_ctrl_m_pg[] = {0xa, 10, 2, 0, 0, 0, 0, 0,
 				     0, 0, 0x2, 0x4b};
 
-	if (scsi_debug_dsense)
+	if (sdebug_dsense)
 		ctrl_m_pg[2] |= 0x4;
 	else
 		ctrl_m_pg[2] &= ~0x4;
 
-	if (scsi_debug_ato)
+	if (sdebug_ato)
 		ctrl_m_pg[5] |= 0x80; /* ATO=1 */
 
 	memcpy(p, ctrl_m_pg, sizeof(ctrl_m_pg));
@@ -1955,31 +1897,29 @@ static int resp_sas_pcd_m_spg(unsigned char * p, int pcontrol, int target,
 {	/* SAS phy control and discover mode page for mode_sense */
 	unsigned char sas_pcd_m_pg[] = {0x59, 0x1, 0, 0x64, 0, 0x6, 0, 2,
 		    0, 0, 0, 0, 0x10, 0x9, 0x8, 0x0,
-		    0x52, 0x22, 0x22, 0x20, 0x0, 0x0, 0x0, 0x0,
-		    0x51, 0x11, 0x11, 0x10, 0x0, 0x0, 0x0, 0x1,
+		    0, 0, 0, 0, 0, 0, 0, 0,	/* insert SAS addr */
+		    0, 0, 0, 0, 0, 0, 0, 0,	/* insert SAS addr */
 		    0x2, 0, 0, 0, 0, 0, 0, 0,
 		    0x88, 0x99, 0, 0, 0, 0, 0, 0,
 		    0, 0, 0, 0, 0, 0, 0, 0,
 		    0, 1, 0, 0, 0x10, 0x9, 0x8, 0x0,
-		    0x52, 0x22, 0x22, 0x20, 0x0, 0x0, 0x0, 0x0,
-		    0x51, 0x11, 0x11, 0x10, 0x0, 0x0, 0x0, 0x1,
+		    0, 0, 0, 0, 0, 0, 0, 0,	/* insert SAS addr */
+		    0, 0, 0, 0, 0, 0, 0, 0,	/* insert SAS addr */
 		    0x3, 0, 0, 0, 0, 0, 0, 0,
 		    0x88, 0x99, 0, 0, 0, 0, 0, 0,
 		    0, 0, 0, 0, 0, 0, 0, 0,
 		};
 	int port_a, port_b;
 
+	put_unaligned_be64(naa5_comp_a, sas_pcd_m_pg + 16);
+	put_unaligned_be64(naa5_comp_c + 1, sas_pcd_m_pg + 24);
+	put_unaligned_be64(naa5_comp_a, sas_pcd_m_pg + 64);
+	put_unaligned_be64(naa5_comp_c + 1, sas_pcd_m_pg + 72);
 	port_a = target_dev_id + 1;
 	port_b = port_a + 1;
 	memcpy(p, sas_pcd_m_pg, sizeof(sas_pcd_m_pg));
-	p[20] = (port_a >> 24);
-	p[21] = (port_a >> 16) & 0xff;
-	p[22] = (port_a >> 8) & 0xff;
-	p[23] = port_a & 0xff;
-	p[48 + 20] = (port_b >> 24);
-	p[48 + 21] = (port_b >> 16) & 0xff;
-	p[48 + 22] = (port_b >> 8) & 0xff;
-	p[48 + 23] = port_b & 0xff;
+	put_unaligned_be32(port_a, p + 20);
+	put_unaligned_be32(port_b, p + 48 + 20);
 	if (1 == pcontrol)
 		memset(p + 4, 0, sizeof(sas_pcd_m_pg) - 4);
 	return sizeof(sas_pcd_m_pg);
@@ -2005,7 +1945,7 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char dbd, llbaa;
 	int pcontrol, pcode, subpcode, bd_len;
 	unsigned char dev_spec;
-	int k, alloc_len, msense_6, offset, len, target_dev_id;
+	int alloc_len, msense_6, offset, len, target_dev_id;
 	int target = scp->device->id;
 	unsigned char * ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
@@ -2017,11 +1957,11 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	subpcode = cmd[3];
 	msense_6 = (MODE_SENSE == cmd[0]);
 	llbaa = msense_6 ? 0 : !!(cmd[1] & 0x10);
-	if ((0 == scsi_debug_ptype) && (0 == dbd))
+	if ((0 == sdebug_ptype) && (0 == dbd))
 		bd_len = llbaa ? 16 : 8;
 	else
 		bd_len = 0;
-	alloc_len = msense_6 ? cmd[4] : ((cmd[7] << 8) | cmd[8]);
+	alloc_len = msense_6 ? cmd[4] : get_unaligned_be16(cmd + 7);
 	memset(arr, 0, SDEBUG_MAX_MSENSE_SZ);
 	if (0x3 == pcontrol) {  /* Saving values not supported */
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, SAVING_PARAMS_UNSUP, 0);
@@ -2030,7 +1970,7 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	target_dev_id = ((devip->sdbg_host->shost->host_no + 1) * 2000) +
 			(devip->target * 1000) - 3;
 	/* set DPOFUA bit for disks */
-	if (0 == scsi_debug_ptype)
+	if (0 == sdebug_ptype)
 		dev_spec = (DEV_READONLY(target) ? 0x80 : 0x0) | 0x10;
 	else
 		dev_spec = 0x0;
@@ -2050,30 +1990,16 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		sdebug_capacity = get_sdebug_capacity();
 
 	if (8 == bd_len) {
-		if (sdebug_capacity > 0xfffffffe) {
-			ap[0] = 0xff;
-			ap[1] = 0xff;
-			ap[2] = 0xff;
-			ap[3] = 0xff;
-		} else {
-			ap[0] = (sdebug_capacity >> 24) & 0xff;
-			ap[1] = (sdebug_capacity >> 16) & 0xff;
-			ap[2] = (sdebug_capacity >> 8) & 0xff;
-			ap[3] = sdebug_capacity & 0xff;
-		}
-		ap[6] = (scsi_debug_sector_size >> 8) & 0xff;
-		ap[7] = scsi_debug_sector_size & 0xff;
+		if (sdebug_capacity > 0xfffffffe)
+			put_unaligned_be32(0xffffffff, ap + 0);
+		else
+			put_unaligned_be32(sdebug_capacity, ap + 0);
+		put_unaligned_be16(sdebug_sector_size, ap + 6);
 		offset += bd_len;
 		ap = arr + offset;
 	} else if (16 == bd_len) {
-		unsigned long long capac = sdebug_capacity;
-
-        	for (k = 0; k < 8; ++k, capac >>= 8)
-                	ap[7 - k] = capac & 0xff;
-		ap[12] = (scsi_debug_sector_size >> 24) & 0xff;
-		ap[13] = (scsi_debug_sector_size >> 16) & 0xff;
-		ap[14] = (scsi_debug_sector_size >> 8) & 0xff;
-		ap[15] = scsi_debug_sector_size & 0xff;
+		put_unaligned_be64((u64)sdebug_capacity, ap + 0);
+		put_unaligned_be32(sdebug_sector_size, ap + 12);
 		offset += bd_len;
 		ap = arr + offset;
 	}
@@ -2149,10 +2075,8 @@ resp_mode_sense(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	if (msense_6)
 		arr[0] = offset - 1;
-	else {
-		arr[0] = ((offset - 2) >> 8) & 0xff;
-		arr[1] = (offset - 2) & 0xff;
-	}
+	else
+		put_unaligned_be16((offset - 2), arr + 0);
 	return fill_from_dev_buffer(scp, arr, min(alloc_len, offset));
 }
 
@@ -2170,21 +2094,20 @@ resp_mode_select(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	memset(arr, 0, sizeof(arr));
 	pf = cmd[1] & 0x10;
 	sp = cmd[1] & 0x1;
-	param_len = mselect6 ? cmd[4] : ((cmd[7] << 8) + cmd[8]);
+	param_len = mselect6 ? cmd[4] : get_unaligned_be16(cmd + 7);
 	if ((0 == pf) || sp || (param_len > SDEBUG_MAX_MSELECT_SZ)) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, mselect6 ? 4 : 7, -1);
 		return check_condition_result;
 	}
         res = fetch_to_dev_buffer(scp, arr, param_len);
         if (-1 == res)
-                return (DID_ERROR << 16);
-        else if ((res < param_len) &&
-                 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+		return DID_ERROR << 16;
+	else if (sdebug_verbose && (res < param_len))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: cdb indicated=%d, IO sent=%d bytes\n",
 			    __func__, param_len, res);
-	md_len = mselect6 ? (arr[0] + 1) : ((arr[0] << 8) + arr[1] + 2);
-	bd_len = mselect6 ? arr[3] : ((arr[6] << 8) + arr[7]);
+	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
+	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
 	if (md_len > 2) {
 		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
@@ -2197,7 +2120,7 @@ resp_mode_select(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	spf = !!(arr[off] & 0x40);
-	pg_len = spf ? ((arr[off + 2] << 8) + arr[off + 3] + 4) :
+	pg_len = spf ? (get_unaligned_be16(arr + off + 2) + 4) :
 		       (arr[off + 1] + 2);
 	if ((pg_len + off) > param_len) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST,
@@ -2216,7 +2139,7 @@ resp_mode_select(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		if (ctrl_m_pg[1] == arr[off + 1]) {
 			memcpy(ctrl_m_pg + 2, arr + off + 2,
 			       sizeof(ctrl_m_pg) - 2);
-			scsi_debug_dsense = !!(ctrl_m_pg[2] & 0x4);
+			sdebug_dsense = !!(ctrl_m_pg[2] & 0x4);
 			goto set_mode_changed_ua;
 		}
 		break;
@@ -2279,7 +2202,7 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
 	subpcode = cmd[3] & 0xff;
-	alloc_len = (cmd[7] << 8) + cmd[8];
+	alloc_len = get_unaligned_be16(cmd + 7);
 	arr[0] = pcode;
 	if (0 == subpcode) {
 		switch (pcode) {
@@ -2336,7 +2259,7 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	len = min(((arr[2] << 8) + arr[3]) + 4, alloc_len);
+	len = min(get_unaligned_be16(arr + 2) + 4, alloc_len);
 	return fill_from_dev_buffer(scp, arr,
 		    min(len, SDEBUG_MAX_INQ_ARR_SZ));
 }
@@ -2384,15 +2307,15 @@ do_device_access(struct scsi_cmnd *scmd, u64 lba, u32 num, bool do_write)
 		rest = block + num - sdebug_store_sectors;
 
 	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
-		   fake_storep + (block * scsi_debug_sector_size),
-		   (num - rest) * scsi_debug_sector_size, 0, do_write);
-	if (ret != (num - rest) * scsi_debug_sector_size)
+		   fake_storep + (block * sdebug_sector_size),
+		   (num - rest) * sdebug_sector_size, 0, do_write);
+	if (ret != (num - rest) * sdebug_sector_size)
 		return ret;
 
 	if (rest) {
 		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
-			    fake_storep, rest * scsi_debug_sector_size,
-			    (num - rest) * scsi_debug_sector_size, do_write);
+			    fake_storep, rest * sdebug_sector_size,
+			    (num - rest) * sdebug_sector_size, do_write);
 	}
 
 	return ret;
@@ -2407,7 +2330,7 @@ comp_write_worker(u64 lba, u32 num, const u8 *arr)
 	bool res;
 	u64 block, rest = 0;
 	u32 store_blks = sdebug_store_sectors;
-	u32 lb_size = scsi_debug_sector_size;
+	u32 lb_size = sdebug_sector_size;
 
 	block = do_div(lba, store_blks);
 	if (block + num > store_blks)
@@ -2434,7 +2357,7 @@ static __be16 dif_compute_csum(const void *buf, int len)
 {
 	__be16 csum;
 
-	if (scsi_debug_guard)
+	if (sdebug_guard)
 		csum = (__force __be16)ip_compute_csum(buf, len);
 	else
 		csum = cpu_to_be16(crc_t10dif(buf, len));
@@ -2445,7 +2368,7 @@ static __be16 dif_compute_csum(const void *buf, int len)
 static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 		      sector_t sector, u32 ei_lba)
 {
-	__be16 csum = dif_compute_csum(data, scsi_debug_sector_size);
+	__be16 csum = dif_compute_csum(data, sdebug_sector_size);
 
 	if (sdt->guard_tag != csum) {
 		pr_err("GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
@@ -2454,13 +2377,13 @@ static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
 			be16_to_cpu(csum));
 		return 0x01;
 	}
-	if (scsi_debug_dif == SD_DIF_TYPE1_PROTECTION &&
+	if (sdebug_dif == SD_DIF_TYPE1_PROTECTION &&
 	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
 		pr_err("REF check failed on sector %lu\n",
 			(unsigned long)sector);
 		return 0x03;
 	}
-	if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+	if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
 	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
 		pr_err("REF check failed on sector %lu\n",
 			(unsigned long)sector);
@@ -2592,13 +2515,13 @@ resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		break;
 	}
 	if (check_prot) {
-		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
 		    (cmd[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
 			return check_condition_result;
 		}
-		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
-		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		if ((sdebug_dif == SD_DIF_TYPE1_PROTECTION ||
+		     sdebug_dif == SD_DIF_TYPE3_PROTECTION) &&
 		    (cmd[1] & 0xe0) == 0)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected RD "
 				    "to DIF device\n");
@@ -2622,7 +2545,7 @@ resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	if ((SCSI_DEBUG_OPT_MEDIUM_ERR & scsi_debug_opts) &&
+	if ((SDEBUG_OPT_MEDIUM_ERR & sdebug_opts) &&
 	    (lba <= (OPT_MEDIUM_ERR_ADDR + OPT_MEDIUM_ERR_NUM - 1)) &&
 	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
 		/* claim unrecoverable read error */
@@ -2641,7 +2564,7 @@ resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	read_lock_irqsave(&atomic_rw, iflags);
 
 	/* DIX + T10 DIF */
-	if (scsi_debug_dix && scsi_prot_sg_count(scp)) {
+	if (sdebug_dix && scsi_prot_sg_count(scp)) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
@@ -2750,13 +2673,13 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 			ret = dif_verify(sdt, daddr, sector, ei_lba);
 			if (ret) {
-				dump_sector(daddr, scsi_debug_sector_size);
+				dump_sector(daddr, sdebug_sector_size);
 				goto out;
 			}
 
 			sector++;
 			ei_lba++;
-			dpage_offset += scsi_debug_sector_size;
+			dpage_offset += sdebug_sector_size;
 		}
 		diter.consumed = dpage_offset;
 		sg_miter_stop(&diter);
@@ -2777,24 +2700,18 @@ out:
 
 static unsigned long lba_to_map_index(sector_t lba)
 {
-	if (scsi_debug_unmap_alignment) {
-		lba += scsi_debug_unmap_granularity -
-			scsi_debug_unmap_alignment;
-	}
-	sector_div(lba, scsi_debug_unmap_granularity);
-
+	if (sdebug_unmap_alignment)
+		lba += sdebug_unmap_granularity - sdebug_unmap_alignment;
+	sector_div(lba, sdebug_unmap_granularity);
 	return lba;
 }
 
 static sector_t map_index_to_lba(unsigned long index)
 {
-	sector_t lba = index * scsi_debug_unmap_granularity;
-
-	if (scsi_debug_unmap_alignment) {
-		lba -= scsi_debug_unmap_granularity -
-			scsi_debug_unmap_alignment;
-	}
+	sector_t lba = index * sdebug_unmap_granularity;
 
+	if (sdebug_unmap_alignment)
+		lba -= sdebug_unmap_granularity - sdebug_unmap_alignment;
 	return lba;
 }
 
@@ -2815,7 +2732,6 @@ static unsigned int map_state(sector_t lba, unsigned int *num)
 
 	end = min_t(sector_t, sdebug_store_sectors,  map_index_to_lba(next));
 	*num = end - lba;
-
 	return mapped;
 }
 
@@ -2841,19 +2757,19 @@ static void unmap_region(sector_t lba, unsigned int len)
 		unsigned long index = lba_to_map_index(lba);
 
 		if (lba == map_index_to_lba(index) &&
-		    lba + scsi_debug_unmap_granularity <= end &&
+		    lba + sdebug_unmap_granularity <= end &&
 		    index < map_size) {
 			clear_bit(index, map_storep);
-			if (scsi_debug_lbprz) {
+			if (sdebug_lbprz) {
 				memset(fake_storep +
-				       lba * scsi_debug_sector_size, 0,
-				       scsi_debug_sector_size *
-				       scsi_debug_unmap_granularity);
+				       lba * sdebug_sector_size, 0,
+				       sdebug_sector_size *
+				       sdebug_unmap_granularity);
 			}
 			if (dif_storep) {
 				memset(dif_storep + lba, 0xff,
 				       sizeof(*dif_storep) *
-				       scsi_debug_unmap_granularity);
+				       sdebug_unmap_granularity);
 			}
 		}
 		lba = map_index_to_lba(index + 1);
@@ -2911,13 +2827,13 @@ resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		break;
 	}
 	if (check_prot) {
-		if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+		if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
 		    (cmd[1] & 0xe0)) {
 			mk_sense_invalid_opcode(scp);
 			return check_condition_result;
 		}
-		if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
-		     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+		if ((sdebug_dif == SD_DIF_TYPE1_PROTECTION ||
+		     sdebug_dif == SD_DIF_TYPE3_PROTECTION) &&
 		    (cmd[1] & 0xe0) == 0)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 				    "to DIF device\n");
@@ -2938,7 +2854,7 @@ resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	write_lock_irqsave(&atomic_rw, iflags);
 
 	/* DIX + T10 DIF */
-	if (scsi_debug_dix && scsi_prot_sg_count(scp)) {
+	if (sdebug_dix && scsi_prot_sg_count(scp)) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
@@ -2953,12 +2869,11 @@ resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		map_region(lba, num);
 	write_unlock_irqrestore(&atomic_rw, iflags);
 	if (-1 == ret)
-		return (DID_ERROR << 16);
-	else if ((ret < (num * scsi_debug_sector_size)) &&
-		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+		return DID_ERROR << 16;
+	else if (sdebug_verbose && (ret < (num * sdebug_sector_size)))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
-			    my_name, num * scsi_debug_sector_size, ret);
+			    my_name, num * sdebug_sector_size, ret);
 
 	if (sdebug_any_injecting_opt) {
 		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
@@ -2986,6 +2901,7 @@ resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 ei_lba,
 	unsigned long iflags;
 	unsigned long long i;
 	int ret;
+	u64 lba_off;
 
 	ret = check_device_access_params(scp, lba, num);
 	if (ret)
@@ -2998,31 +2914,29 @@ resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num, u32 ei_lba,
 		goto out;
 	}
 
+	lba_off = lba * sdebug_sector_size;
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
 	if (ndob) {
-		memset(fake_storep + (lba * scsi_debug_sector_size), 0,
-		       scsi_debug_sector_size);
+		memset(fake_storep + lba_off, 0, sdebug_sector_size);
 		ret = 0;
 	} else
-		ret = fetch_to_dev_buffer(scp, fake_storep +
-					       (lba * scsi_debug_sector_size),
-					  scsi_debug_sector_size);
+		ret = fetch_to_dev_buffer(scp, fake_storep + lba_off,
+					  sdebug_sector_size);
 
 	if (-1 == ret) {
 		write_unlock_irqrestore(&atomic_rw, iflags);
-		return (DID_ERROR << 16);
-	} else if ((ret < (num * scsi_debug_sector_size)) &&
-		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+		return DID_ERROR << 16;
+	} else if (sdebug_verbose && (ret < (num * sdebug_sector_size)))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: %s: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, "write same",
-			    num * scsi_debug_sector_size, ret);
+			    num * sdebug_sector_size, ret);
 
 	/* Copy first sector to remaining blocks */
 	for (i = 1 ; i < num ; i++)
-		memcpy(fake_storep + ((lba + i) * scsi_debug_sector_size),
-		       fake_storep + (lba * scsi_debug_sector_size),
-		       scsi_debug_sector_size);
+		memcpy(fake_storep + ((lba + i) * sdebug_sector_size),
+		       fake_storep + lba_off,
+		       sdebug_sector_size);
 
 	if (scsi_debug_lbp())
 		map_region(lba, num);
@@ -3042,7 +2956,7 @@ resp_write_same_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	bool unmap = false;
 
 	if (cmd[1] & 0x8) {
-		if (scsi_debug_lbpws10 == 0) {
+		if (sdebug_lbpws10 == 0) {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 3);
 			return check_condition_result;
 		} else
@@ -3050,7 +2964,7 @@ resp_write_same_10(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	lba = get_unaligned_be32(cmd + 2);
 	num = get_unaligned_be16(cmd + 7);
-	if (num > scsi_debug_write_same_length) {
+	if (num > sdebug_write_same_length) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);
 		return check_condition_result;
 	}
@@ -3068,7 +2982,7 @@ resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	bool ndob = false;
 
 	if (cmd[1] & 0x8) {	/* UNMAP */
-		if (scsi_debug_lbpws == 0) {
+		if (sdebug_lbpws == 0) {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 3);
 			return check_condition_result;
 		} else
@@ -3078,7 +2992,7 @@ resp_write_same_16(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		ndob = true;
 	lba = get_unaligned_be64(cmd + 2);
 	num = get_unaligned_be32(cmd + 10);
-	if (num > scsi_debug_write_same_length) {
+	if (num > sdebug_write_same_length) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);
 		return check_condition_result;
 	}
@@ -3142,7 +3056,7 @@ resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *fake_storep_hold;
 	u64 lba;
 	u32 dnum;
-	u32 lb_size = scsi_debug_sector_size;
+	u32 lb_size = sdebug_sector_size;
 	u8 num;
 	unsigned long iflags;
 	int ret;
@@ -3152,13 +3066,13 @@ resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	num = cmd[13];		/* 1 to a maximum of 255 logical blocks */
 	if (0 == num)
 		return 0;	/* degenerate case, not an error */
-	if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
+	if (sdebug_dif == SD_DIF_TYPE2_PROTECTION &&
 	    (cmd[1] & 0xe0)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
-	if ((scsi_debug_dif == SD_DIF_TYPE1_PROTECTION ||
-	     scsi_debug_dif == SD_DIF_TYPE3_PROTECTION) &&
+	if ((sdebug_dif == SD_DIF_TYPE1_PROTECTION ||
+	     sdebug_dif == SD_DIF_TYPE3_PROTECTION) &&
 	    (cmd[1] & 0xe0) == 0)
 		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 			    "to DIF device\n");
@@ -3193,8 +3107,7 @@ resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (ret == -1) {
 		retval = DID_ERROR << 16;
 		goto cleanup;
-	} else if ((ret < (dnum * lb_size)) &&
-		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+	} else if (sdebug_verbose && (ret < (dnum * lb_size)))
 		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
@@ -3233,7 +3146,7 @@ resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	BUG_ON(scsi_bufflen(scp) != payload_len);
 
 	descriptors = (payload_len - 8) / 16;
-	if (descriptors > scsi_debug_unmap_max_desc) {
+	if (descriptors > sdebug_unmap_max_desc) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);
 		return check_condition_result;
 	}
@@ -3339,10 +3252,10 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 	}
 	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
 	memset(arr, 0, SDEBUG_RLUN_ARR_SZ);
-	lun_cnt = scsi_debug_max_luns;
+	lun_cnt = sdebug_max_luns;
 	if (1 == select_report)
 		lun_cnt = 0;
-	else if (scsi_debug_no_lun_0 && (lun_cnt > 0))
+	else if (sdebug_no_lun_0 && (lun_cnt > 0))
 		--lun_cnt;
 	want_wlun = (select_report > 0) ? 1 : 0;
 	num = lun_cnt + want_wlun;
@@ -3356,7 +3269,7 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 	}
 	one_lun = (struct scsi_lun *) &arr[8];
 	max_addr = arr + SDEBUG_RLUN_ARR_SZ;
-	for (i = 0, lun = (scsi_debug_no_lun_0 ? 1 : 0);
+	for (i = 0, lun = (sdebug_no_lun_0 ? 1 : 0);
              ((i < lun_cnt) && ((unsigned char *)(one_lun + i) < max_addr));
 	     i++, lun++) {
 		upper = (lun >> 8) & 0x3f;
@@ -3486,7 +3399,7 @@ static void sdebug_q_cmd_complete(unsigned long indx)
 			return;
 		}
 		k = find_last_bit(queued_in_use_bm, retval);
-		if ((k < scsi_debug_max_queue) || (k == retval))
+		if ((k < sdebug_max_queue) || (k == retval))
 			atomic_set(&retired_max_queue, 0);
 		else
 			atomic_set(&retired_max_queue, k + 1);
@@ -3546,7 +3459,7 @@ sdebug_q_cmd_hrt_complete(struct hrtimer *timer)
 			goto the_end;
 		}
 		k = find_last_bit(queued_in_use_bm, retval);
-		if ((k < scsi_debug_max_queue) || (k == retval))
+		if ((k < sdebug_max_queue) || (k == retval))
 			atomic_set(&retired_max_queue, 0);
 		else
 			atomic_set(&retired_max_queue, k + 1);
@@ -3614,7 +3527,7 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 
 static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+	if (sdebug_verbose)
 		pr_info("slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, sdp->request_queue);
@@ -3625,7 +3538,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 {
 	struct sdebug_dev_info *devip;
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+	if (sdebug_verbose)
 		pr_info("slave_configure <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
@@ -3635,7 +3548,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 		return 1;	/* no resources, will be marked offline */
 	sdp->hostdata = devip;
 	blk_queue_max_segment_size(sdp->request_queue, -1U);
-	if (scsi_debug_no_uld)
+	if (sdebug_no_uld)
 		sdp->no_uld_attach = 1;
 	return 0;
 }
@@ -3645,7 +3558,7 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 	struct sdebug_dev_info *devip =
 		(struct sdebug_dev_info *)sdp->hostdata;
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+	if (sdebug_verbose)
 		pr_info("slave_destroy <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 	if (devip) {
@@ -3664,7 +3577,7 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 	struct sdebug_dev_info *devip;
 
 	spin_lock_irqsave(&queued_arr_lock, iflags);
-	qmax = scsi_debug_max_queue;
+	qmax = sdebug_max_queue;
 	r_qmax = atomic_read(&retired_max_queue);
 	if (r_qmax > qmax)
 		qmax = r_qmax;
@@ -3679,15 +3592,15 @@ static int stop_queued_cmnd(struct scsi_cmnd *cmnd)
 				sqcp->a_cmnd = NULL;
 				spin_unlock_irqrestore(&queued_arr_lock,
 						       iflags);
-				if (scsi_debug_ndelay > 0) {
+				if (sdebug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
 							&sqcp->sd_hrtp->hrt);
-				} else if (scsi_debug_delay > 0) {
+				} else if (sdebug_delay > 0) {
 					if (sqcp->cmnd_timerp)
 						del_timer_sync(
 							sqcp->cmnd_timerp);
-				} else if (scsi_debug_delay < 0) {
+				} else if (sdebug_delay < 0) {
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
@@ -3720,15 +3633,15 @@ static void stop_all_queued(void)
 				sqcp->a_cmnd = NULL;
 				spin_unlock_irqrestore(&queued_arr_lock,
 						       iflags);
-				if (scsi_debug_ndelay > 0) {
+				if (sdebug_ndelay > 0) {
 					if (sqcp->sd_hrtp)
 						hrtimer_cancel(
 							&sqcp->sd_hrtp->hrt);
-				} else if (scsi_debug_delay > 0) {
+				} else if (sdebug_delay > 0) {
 					if (sqcp->cmnd_timerp)
 						del_timer_sync(
 							sqcp->cmnd_timerp);
-				} else if (scsi_debug_delay < 0) {
+				} else if (sdebug_delay < 0) {
 					if (sqcp->tletp)
 						tasklet_kill(sqcp->tletp);
 				}
@@ -3765,7 +3678,7 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 	++num_aborts;
 	if (SCpnt) {
 		if (SCpnt->device &&
-		    (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts))
+		    (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
 			sdev_printk(KERN_INFO, SCpnt->device, "%s\n",
 				    __func__);
 		stop_queued_cmnd(SCpnt);
@@ -3781,7 +3694,7 @@ static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
 	if (SCpnt && SCpnt->device) {
 		struct scsi_device *sdp = SCpnt->device;
 
-		if (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts)
+		if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
 			sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
 		devip = devInfoReg(sdp);
 		if (devip)
@@ -3804,7 +3717,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 	sdp = SCpnt->device;
 	if (!sdp)
 		goto lie;
-	if (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts)
+	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
 	hp = sdp->host;
 	if (!hp)
@@ -3819,7 +3732,7 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 				++k;
 			}
 	}
-	if (SCSI_DEBUG_OPT_RESET_NOISE & scsi_debug_opts)
+	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, sdp,
 			    "%s: %d device(s) found in target\n", __func__, k);
 lie:
@@ -3838,7 +3751,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
 	if (!(SCpnt && SCpnt->device))
 		goto lie;
 	sdp = SCpnt->device;
-	if (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts)
+	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
 	hp = sdp->host;
 	if (hp) {
@@ -3852,7 +3765,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
 			}
 		}
 	}
-	if (SCSI_DEBUG_OPT_RESET_NOISE & scsi_debug_opts)
+	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, sdp,
 			    "%s: %d device(s) found in host\n", __func__, k);
 lie:
@@ -3866,7 +3779,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
 	int k = 0;
 
 	++num_host_resets;
-	if ((SCpnt->device) && (SCSI_DEBUG_OPT_ALL_NOISE & scsi_debug_opts))
+	if ((SCpnt->device) && (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
 		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
         spin_lock(&sdebug_host_list_lock);
         list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
@@ -3878,7 +3791,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
         }
         spin_unlock(&sdebug_host_list_lock);
 	stop_all_queued();
-	if (SCSI_DEBUG_OPT_RESET_NOISE & scsi_debug_opts)
+	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
 		sdev_printk(KERN_INFO, SCpnt->device,
 			    "%s: %d device(s) found\n", __func__, k);
 	return SUCCESS;
@@ -3893,22 +3806,22 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 	int heads_by_sects, start_sec, end_sec;
 
 	/* assume partition table already zeroed */
-	if ((scsi_debug_num_parts < 1) || (store_size < 1048576))
+	if ((sdebug_num_parts < 1) || (store_size < 1048576))
 		return;
-	if (scsi_debug_num_parts > SDEBUG_MAX_PARTS) {
-		scsi_debug_num_parts = SDEBUG_MAX_PARTS;
+	if (sdebug_num_parts > SDEBUG_MAX_PARTS) {
+		sdebug_num_parts = SDEBUG_MAX_PARTS;
 		pr_warn("reducing partitions to %d\n", SDEBUG_MAX_PARTS);
 	}
 	num_sectors = (int)sdebug_store_sectors;
 	sectors_per_part = (num_sectors - sdebug_sectors_per)
-			   / scsi_debug_num_parts;
+			   / sdebug_num_parts;
 	heads_by_sects = sdebug_heads * sdebug_sectors_per;
         starts[0] = sdebug_sectors_per;
-	for (k = 1; k < scsi_debug_num_parts; ++k)
+	for (k = 1; k < sdebug_num_parts; ++k)
 		starts[k] = ((k * sectors_per_part) / heads_by_sects)
 			    * heads_by_sects;
-	starts[scsi_debug_num_parts] = num_sectors;
-	starts[scsi_debug_num_parts + 1] = 0;
+	starts[sdebug_num_parts] = num_sectors;
+	starts[sdebug_num_parts + 1] = 0;
 
 	ramp[510] = 0x55;	/* magic partition markings */
 	ramp[511] = 0xAA;
@@ -3955,7 +3868,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 
 	sdp = cmnd->device;
 
-	if ((scsi_result) && (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
+	if (sdebug_verbose && scsi_result)
 		sdev_printk(KERN_INFO, sdp, "%s: non-zero result=0x%x\n",
 			    __func__, scsi_result);
 	if (delta_jiff == 0)
@@ -3972,29 +3885,29 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			goto respond_in_thread;
 		} else
 			scsi_result = device_qfull_result;
-	} else if ((scsi_debug_every_nth != 0) &&
-		   (SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts) &&
+	} else if ((sdebug_every_nth != 0) &&
+		   (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
 		   (scsi_result == 0)) {
 		if ((num_in_q == (qdepth - 1)) &&
 		    (atomic_inc_return(&sdebug_a_tsf) >=
-		     abs(scsi_debug_every_nth))) {
+		     abs(sdebug_every_nth))) {
 			atomic_set(&sdebug_a_tsf, 0);
 			inject = 1;
 			scsi_result = device_qfull_result;
 		}
 	}
 
-	k = find_first_zero_bit(queued_in_use_bm, scsi_debug_max_queue);
-	if (k >= scsi_debug_max_queue) {
+	k = find_first_zero_bit(queued_in_use_bm, sdebug_max_queue);
+	if (k >= sdebug_max_queue) {
 		spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		if (scsi_result)
 			goto respond_in_thread;
-		else if (SCSI_DEBUG_OPT_ALL_TSF & scsi_debug_opts)
+		else if (SDEBUG_OPT_ALL_TSF & sdebug_opts)
 			scsi_result = device_qfull_result;
-		if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts)
+		if (SDEBUG_OPT_Q_NOISE & sdebug_opts)
 			sdev_printk(KERN_INFO, sdp,
 				    "%s: max_queue=%d exceeded, %s\n",
-				    __func__, scsi_debug_max_queue,
+				    __func__, sdebug_max_queue,
 				    (scsi_result ?  "status: TASK SET FULL" :
 						    "report: host busy"));
 		if (scsi_result)
@@ -4020,8 +3933,8 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		sqcp->cmnd_timerp->data = k;
 		sqcp->cmnd_timerp->expires = get_jiffies_64() + delta_jiff;
 		add_timer(sqcp->cmnd_timerp);
-	} else if (scsi_debug_ndelay > 0) {
-		ktime_t kt = ktime_set(0, scsi_debug_ndelay);
+	} else if (sdebug_ndelay > 0) {
+		ktime_t kt = ktime_set(0, sdebug_ndelay);
 		struct sdebug_hrtimer *sd_hp = sqcp->sd_hrtp;
 
 		if (NULL == sd_hp) {
@@ -4049,7 +3962,7 @@ schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		else
 			tasklet_schedule(sqcp->tletp);
 	}
-	if ((SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) &&
+	if ((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
 	    (scsi_result == device_qfull_result))
 		sdev_printk(KERN_INFO, sdp,
 			    "%s: num_in_q=%d +1, %s%s\n", __func__,
@@ -4069,46 +3982,46 @@ respond_in_thread:	/* call back to mid-layer using invocation thread */
    as it can when the corresponding attribute in the
    /sys/bus/pseudo/drivers/scsi_debug directory is changed.
  */
-module_param_named(add_host, scsi_debug_add_host, int, S_IRUGO | S_IWUSR);
-module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
-module_param_named(clustering, scsi_debug_clustering, bool, S_IRUGO | S_IWUSR);
-module_param_named(delay, scsi_debug_delay, int, S_IRUGO | S_IWUSR);
-module_param_named(dev_size_mb, scsi_debug_dev_size_mb, int, S_IRUGO);
-module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
-module_param_named(dix, scsi_debug_dix, int, S_IRUGO);
-module_param_named(dsense, scsi_debug_dsense, int, S_IRUGO | S_IWUSR);
-module_param_named(every_nth, scsi_debug_every_nth, int, S_IRUGO | S_IWUSR);
-module_param_named(fake_rw, scsi_debug_fake_rw, int, S_IRUGO | S_IWUSR);
-module_param_named(guard, scsi_debug_guard, uint, S_IRUGO);
-module_param_named(host_lock, scsi_debug_host_lock, bool, S_IRUGO | S_IWUSR);
-module_param_named(lbpu, scsi_debug_lbpu, int, S_IRUGO);
-module_param_named(lbpws, scsi_debug_lbpws, int, S_IRUGO);
-module_param_named(lbpws10, scsi_debug_lbpws10, int, S_IRUGO);
-module_param_named(lbprz, scsi_debug_lbprz, int, S_IRUGO);
-module_param_named(lowest_aligned, scsi_debug_lowest_aligned, int, S_IRUGO);
-module_param_named(max_luns, scsi_debug_max_luns, int, S_IRUGO | S_IWUSR);
-module_param_named(max_queue, scsi_debug_max_queue, int, S_IRUGO | S_IWUSR);
-module_param_named(ndelay, scsi_debug_ndelay, int, S_IRUGO | S_IWUSR);
-module_param_named(no_lun_0, scsi_debug_no_lun_0, int, S_IRUGO | S_IWUSR);
-module_param_named(no_uld, scsi_debug_no_uld, int, S_IRUGO);
-module_param_named(num_parts, scsi_debug_num_parts, int, S_IRUGO);
-module_param_named(num_tgts, scsi_debug_num_tgts, int, S_IRUGO | S_IWUSR);
-module_param_named(opt_blks, scsi_debug_opt_blks, int, S_IRUGO);
-module_param_named(opts, scsi_debug_opts, int, S_IRUGO | S_IWUSR);
-module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
-module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
-module_param_named(removable, scsi_debug_removable, bool, S_IRUGO | S_IWUSR);
-module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
-module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
-module_param_named(strict, scsi_debug_strict, bool, S_IRUGO | S_IWUSR);
-module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
-module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
-module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
-module_param_named(unmap_max_desc, scsi_debug_unmap_max_desc, int, S_IRUGO);
-module_param_named(virtual_gb, scsi_debug_virtual_gb, int, S_IRUGO | S_IWUSR);
-module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
+module_param_named(add_host, sdebug_add_host, int, S_IRUGO | S_IWUSR);
+module_param_named(ato, sdebug_ato, int, S_IRUGO);
+module_param_named(clustering, sdebug_clustering, bool, S_IRUGO | S_IWUSR);
+module_param_named(delay, sdebug_delay, int, S_IRUGO | S_IWUSR);
+module_param_named(dev_size_mb, sdebug_dev_size_mb, int, S_IRUGO);
+module_param_named(dif, sdebug_dif, int, S_IRUGO);
+module_param_named(dix, sdebug_dix, int, S_IRUGO);
+module_param_named(dsense, sdebug_dsense, int, S_IRUGO | S_IWUSR);
+module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
+module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
+module_param_named(guard, sdebug_guard, uint, S_IRUGO);
+module_param_named(host_lock, sdebug_host_lock, bool, S_IRUGO | S_IWUSR);
+module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
+module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
+module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
+module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
+module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
+module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
+module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
+module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
+module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
+module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
+module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
+module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
+module_param_named(opts, sdebug_opts, int, S_IRUGO | S_IWUSR);
+module_param_named(physblk_exp, sdebug_physblk_exp, int, S_IRUGO);
+module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
+module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
+module_param_named(scsi_level, sdebug_scsi_level, int, S_IRUGO);
+module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
+module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
+module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
+module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
+module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
+module_param_named(unmap_max_desc, sdebug_unmap_max_desc, int, S_IRUGO);
+module_param_named(virtual_gb, sdebug_virtual_gb, int, S_IRUGO | S_IWUSR);
+module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
-module_param_named(write_same_length, scsi_debug_write_same_length, int,
+module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
@@ -4162,8 +4075,7 @@ static const char * scsi_debug_info(struct Scsi_Host * shp)
 {
 	sprintf(sdebug_info, "scsi_debug, version %s [%s], "
 		"dev_size_mb=%d, opts=0x%x", SCSI_DEBUG_VERSION,
-		scsi_debug_version_date, scsi_debug_dev_size_mb,
-		scsi_debug_opts);
+		sdebug_version_date, sdebug_dev_size_mb, sdebug_opts);
 	return sdebug_info;
 }
 
@@ -4180,8 +4092,10 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer, int lengt
 	arr[minLen] = '\0';
 	if (1 != sscanf(arr, "%d", &opts))
 		return -EINVAL;
-	scsi_debug_opts = opts;
-	if (scsi_debug_every_nth != 0)
+	sdebug_opts = opts;
+	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
+	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
+	if (sdebug_every_nth != 0)
 		atomic_set(&sdebug_cmnd_count, 0);
 	return length;
 }
@@ -4194,9 +4108,9 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 	int f, l;
 	char b[32];
 
-	if (scsi_debug_every_nth > 0)
+	if (sdebug_every_nth > 0)
 		snprintf(b, sizeof(b), " (curr:%d)",
-			 ((SCSI_DEBUG_OPT_RARE_TSF & scsi_debug_opts) ?
+			 ((SDEBUG_OPT_RARE_TSF & sdebug_opts) ?
 				atomic_read(&sdebug_a_tsf) :
 				atomic_read(&sdebug_cmnd_count)));
 	else
@@ -4210,18 +4124,18 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 		"command aborts=%d; RESETs: device=%d, target=%d, bus=%d, "
 		"host=%d\ndix_reads=%d dix_writes=%d dif_errors=%d "
 		"usec_in_jiffy=%lu\n",
-		SCSI_DEBUG_VERSION, scsi_debug_version_date,
-		scsi_debug_num_tgts, scsi_debug_dev_size_mb, scsi_debug_opts,
-		scsi_debug_every_nth, b, scsi_debug_delay, scsi_debug_ndelay,
-		scsi_debug_max_luns, atomic_read(&sdebug_completions),
-		scsi_debug_sector_size, sdebug_cylinders_per, sdebug_heads,
+		SCSI_DEBUG_VERSION, sdebug_version_date,
+		sdebug_num_tgts, sdebug_dev_size_mb, sdebug_opts,
+		sdebug_every_nth, b, sdebug_delay, sdebug_ndelay,
+		sdebug_max_luns, atomic_read(&sdebug_completions),
+		sdebug_sector_size, sdebug_cylinders_per, sdebug_heads,
 		sdebug_sectors_per, num_aborts, num_dev_resets,
 		num_target_resets, num_bus_resets, num_host_resets,
 		dix_reads, dix_writes, dif_errors, TICK_NSEC / 1000);
 
-	f = find_first_bit(queued_in_use_bm, scsi_debug_max_queue);
-	if (f != scsi_debug_max_queue) {
-		l = find_last_bit(queued_in_use_bm, scsi_debug_max_queue);
+	f = find_first_bit(queued_in_use_bm, sdebug_max_queue);
+	if (f != sdebug_max_queue) {
+		l = find_last_bit(queued_in_use_bm, sdebug_max_queue);
 		seq_printf(m, "   %s BUSY: first,last bits set: %d,%d\n",
 			   "queued_in_use_bm", f, l);
 	}
@@ -4230,7 +4144,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 
 static ssize_t delay_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_delay);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_delay);
 }
 /* Returns -EBUSY if delay is being changed and commands are queued */
 static ssize_t delay_store(struct device_driver *ddp, const char *buf,
@@ -4240,18 +4154,17 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &delay))) {
 		res = count;
-		if (scsi_debug_delay != delay) {
+		if (sdebug_delay != delay) {
 			unsigned long iflags;
 			int k;
 
 			spin_lock_irqsave(&queued_arr_lock, iflags);
-			k = find_first_bit(queued_in_use_bm,
-					   scsi_debug_max_queue);
-			if (k != scsi_debug_max_queue)
+			k = find_first_bit(queued_in_use_bm, sdebug_max_queue);
+			if (k != sdebug_max_queue)
 				res = -EBUSY;	/* have queued commands */
 			else {
-				scsi_debug_delay = delay;
-				scsi_debug_ndelay = 0;
+				sdebug_delay = delay;
+				sdebug_ndelay = 0;
 			}
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		}
@@ -4263,10 +4176,10 @@ static DRIVER_ATTR_RW(delay);
 
 static ssize_t ndelay_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_ndelay);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_ndelay);
 }
 /* Returns -EBUSY if ndelay is being changed and commands are queued */
-/* If > 0 and accepted then scsi_debug_delay is set to DELAY_OVERRIDDEN */
+/* If > 0 and accepted then sdebug_delay is set to DELAY_OVERRIDDEN */
 static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
 {
@@ -4276,15 +4189,14 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 	if ((count > 0) && (1 == sscanf(buf, "%d", &ndelay)) &&
 	    (ndelay >= 0) && (ndelay < 1000000000)) {
 		res = count;
-		if (scsi_debug_ndelay != ndelay) {
+		if (sdebug_ndelay != ndelay) {
 			spin_lock_irqsave(&queued_arr_lock, iflags);
-			k = find_first_bit(queued_in_use_bm,
-					   scsi_debug_max_queue);
-			if (k != scsi_debug_max_queue)
+			k = find_first_bit(queued_in_use_bm, sdebug_max_queue);
+			if (k != sdebug_max_queue)
 				res = -EBUSY;	/* have queued commands */
 			else {
-				scsi_debug_ndelay = ndelay;
-				scsi_debug_delay = ndelay ? DELAY_OVERRIDDEN
+				sdebug_ndelay = ndelay;
+				sdebug_delay = ndelay ? DELAY_OVERRIDDEN
 							  : DEF_DELAY;
 			}
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
@@ -4297,7 +4209,7 @@ static DRIVER_ATTR_RW(ndelay);
 
 static ssize_t opts_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "0x%x\n", scsi_debug_opts);
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", sdebug_opts);
 }
 
 static ssize_t opts_store(struct device_driver *ddp, const char *buf,
@@ -4317,17 +4229,9 @@ static ssize_t opts_store(struct device_driver *ddp, const char *buf,
 	}
 	return -EINVAL;
 opts_done:
-	scsi_debug_opts = opts;
-	if (SCSI_DEBUG_OPT_RECOVERED_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_DIF_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_DIX_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & opts)
-		sdebug_any_injecting_opt = true;
+	sdebug_opts = opts;
+	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
+	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	atomic_set(&sdebug_cmnd_count, 0);
 	atomic_set(&sdebug_a_tsf, 0);
 	return count;
@@ -4336,7 +4240,7 @@ static DRIVER_ATTR_RW(opts);
 
 static ssize_t ptype_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_ptype);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_ptype);
 }
 static ssize_t ptype_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
@@ -4344,7 +4248,7 @@ static ssize_t ptype_store(struct device_driver *ddp, const char *buf,
         int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_ptype = n;
+		sdebug_ptype = n;
 		return count;
 	}
 	return -EINVAL;
@@ -4353,7 +4257,7 @@ static DRIVER_ATTR_RW(ptype);
 
 static ssize_t dsense_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dsense);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_dsense);
 }
 static ssize_t dsense_store(struct device_driver *ddp, const char *buf,
 			    size_t count)
@@ -4361,7 +4265,7 @@ static ssize_t dsense_store(struct device_driver *ddp, const char *buf,
         int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_dsense = n;
+		sdebug_dsense = n;
 		return count;
 	}
 	return -EINVAL;
@@ -4370,7 +4274,7 @@ static DRIVER_ATTR_RW(dsense);
 
 static ssize_t fake_rw_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_fake_rw);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_fake_rw);
 }
 static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 			     size_t count)
@@ -4379,11 +4283,11 @@ static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		n = (n > 0);
-		scsi_debug_fake_rw = (scsi_debug_fake_rw > 0);
-		if (scsi_debug_fake_rw != n) {
+		sdebug_fake_rw = (sdebug_fake_rw > 0);
+		if (sdebug_fake_rw != n) {
 			if ((0 == n) && (NULL == fake_storep)) {
 				unsigned long sz =
-					(unsigned long)scsi_debug_dev_size_mb *
+					(unsigned long)sdebug_dev_size_mb *
 					1048576;
 
 				fake_storep = vmalloc(sz);
@@ -4393,7 +4297,7 @@ static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 				}
 				memset(fake_storep, 0, sz);
 			}
-			scsi_debug_fake_rw = n;
+			sdebug_fake_rw = n;
 		}
 		return count;
 	}
@@ -4403,7 +4307,7 @@ static DRIVER_ATTR_RW(fake_rw);
 
 static ssize_t no_lun_0_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_no_lun_0);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_no_lun_0);
 }
 static ssize_t no_lun_0_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
@@ -4411,7 +4315,7 @@ static ssize_t no_lun_0_store(struct device_driver *ddp, const char *buf,
         int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_no_lun_0 = n;
+		sdebug_no_lun_0 = n;
 		return count;
 	}
 	return -EINVAL;
@@ -4420,7 +4324,7 @@ static DRIVER_ATTR_RW(no_lun_0);
 
 static ssize_t num_tgts_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_num_tgts);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_tgts);
 }
 static ssize_t num_tgts_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
@@ -4428,7 +4332,7 @@ static ssize_t num_tgts_store(struct device_driver *ddp, const char *buf,
         int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_num_tgts = n;
+		sdebug_num_tgts = n;
 		sdebug_max_tgts_luns();
 		return count;
 	}
@@ -4438,19 +4342,19 @@ static DRIVER_ATTR_RW(num_tgts);
 
 static ssize_t dev_size_mb_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dev_size_mb);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_dev_size_mb);
 }
 static DRIVER_ATTR_RO(dev_size_mb);
 
 static ssize_t num_parts_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_num_parts);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_parts);
 }
 static DRIVER_ATTR_RO(num_parts);
 
 static ssize_t every_nth_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_every_nth);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_every_nth);
 }
 static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
@@ -4458,7 +4362,7 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
         int nth;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &nth))) {
-		scsi_debug_every_nth = nth;
+		sdebug_every_nth = nth;
 		atomic_set(&sdebug_cmnd_count, 0);
 		return count;
 	}
@@ -4468,7 +4372,7 @@ static DRIVER_ATTR_RW(every_nth);
 
 static ssize_t max_luns_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_max_luns);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_max_luns);
 }
 static ssize_t max_luns_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
@@ -4477,10 +4381,10 @@ static ssize_t max_luns_store(struct device_driver *ddp, const char *buf,
 	bool changed;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		changed = (scsi_debug_max_luns != n);
-		scsi_debug_max_luns = n;
+		changed = (sdebug_max_luns != n);
+		sdebug_max_luns = n;
 		sdebug_max_tgts_luns();
-		if (changed && (scsi_debug_scsi_level >= 5)) {	/* >= SPC-3 */
+		if (changed && (sdebug_scsi_level >= 5)) {	/* >= SPC-3 */
 			struct sdebug_host_info *sdhp;
 			struct sdebug_dev_info *dp;
 
@@ -4503,7 +4407,7 @@ static DRIVER_ATTR_RW(max_luns);
 
 static ssize_t max_queue_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_max_queue);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_max_queue);
 }
 /* N.B. max_queue can be changed while there are queued commands. In flight
  * commands beyond the new max_queue will be completed. */
@@ -4517,7 +4421,7 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 	    (n <= SCSI_DEBUG_CANQUEUE)) {
 		spin_lock_irqsave(&queued_arr_lock, iflags);
 		k = find_last_bit(queued_in_use_bm, SCSI_DEBUG_CANQUEUE);
-		scsi_debug_max_queue = n;
+		sdebug_max_queue = n;
 		if (SCSI_DEBUG_CANQUEUE == k)
 			atomic_set(&retired_max_queue, 0);
 		else if (k >= n)
@@ -4533,19 +4437,19 @@ static DRIVER_ATTR_RW(max_queue);
 
 static ssize_t no_uld_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_no_uld);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_no_uld);
 }
 static DRIVER_ATTR_RO(no_uld);
 
 static ssize_t scsi_level_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_scsi_level);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_scsi_level);
 }
 static DRIVER_ATTR_RO(scsi_level);
 
 static ssize_t virtual_gb_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_virtual_gb);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_virtual_gb);
 }
 static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 				size_t count)
@@ -4554,8 +4458,8 @@ static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 	bool changed;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		changed = (scsi_debug_virtual_gb != n);
-		scsi_debug_virtual_gb = n;
+		changed = (sdebug_virtual_gb != n);
+		sdebug_virtual_gb = n;
 		sdebug_capacity = get_sdebug_capacity();
 		if (changed) {
 			struct sdebug_host_info *sdhp;
@@ -4580,7 +4484,7 @@ static DRIVER_ATTR_RW(virtual_gb);
 
 static ssize_t add_host_show(struct device_driver *ddp, char *buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_add_host);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_add_host);
 }
 
 static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
@@ -4605,7 +4509,7 @@ static DRIVER_ATTR_RW(add_host);
 
 static ssize_t vpd_use_hostno_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_vpd_use_hostno);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_vpd_use_hostno);
 }
 static ssize_t vpd_use_hostno_store(struct device_driver *ddp, const char *buf,
 				    size_t count)
@@ -4613,7 +4517,7 @@ static ssize_t vpd_use_hostno_store(struct device_driver *ddp, const char *buf,
 	int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_vpd_use_hostno = n;
+		sdebug_vpd_use_hostno = n;
 		return count;
 	}
 	return -EINVAL;
@@ -4622,31 +4526,31 @@ static DRIVER_ATTR_RW(vpd_use_hostno);
 
 static ssize_t sector_size_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_sector_size);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", sdebug_sector_size);
 }
 static DRIVER_ATTR_RO(sector_size);
 
 static ssize_t dix_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dix);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_dix);
 }
 static DRIVER_ATTR_RO(dix);
 
 static ssize_t dif_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dif);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_dif);
 }
 static DRIVER_ATTR_RO(dif);
 
 static ssize_t guard_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%u\n", scsi_debug_guard);
+	return scnprintf(buf, PAGE_SIZE, "%u\n", sdebug_guard);
 }
 static DRIVER_ATTR_RO(guard);
 
 static ssize_t ato_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_ato);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_ato);
 }
 static DRIVER_ATTR_RO(ato);
 
@@ -4669,7 +4573,7 @@ static DRIVER_ATTR_RO(map);
 
 static ssize_t removable_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_removable ? 1 : 0);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_removable ? 1 : 0);
 }
 static ssize_t removable_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
@@ -4677,7 +4581,7 @@ static ssize_t removable_store(struct device_driver *ddp, const char *buf,
 	int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_removable = (n > 0);
+		sdebug_removable = (n > 0);
 		return count;
 	}
 	return -EINVAL;
@@ -4686,7 +4590,7 @@ static DRIVER_ATTR_RW(removable);
 
 static ssize_t host_lock_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", !!scsi_debug_host_lock);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!sdebug_host_lock);
 }
 /* Returns -EBUSY if host_lock is being changed and commands are queued */
 static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
@@ -4698,17 +4602,17 @@ static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
 		bool new_host_lock = (n > 0);
 
 		res = count;
-		if (new_host_lock != scsi_debug_host_lock) {
+		if (new_host_lock != sdebug_host_lock) {
 			unsigned long iflags;
 			int k;
 
 			spin_lock_irqsave(&queued_arr_lock, iflags);
 			k = find_first_bit(queued_in_use_bm,
-					   scsi_debug_max_queue);
-			if (k != scsi_debug_max_queue)
+					   sdebug_max_queue);
+			if (k != sdebug_max_queue)
 				res = -EBUSY;	/* have queued commands */
 			else
-				scsi_debug_host_lock = new_host_lock;
+				sdebug_host_lock = new_host_lock;
 			spin_unlock_irqrestore(&queued_arr_lock, iflags);
 		}
 		return res;
@@ -4719,7 +4623,7 @@ static DRIVER_ATTR_RW(host_lock);
 
 static ssize_t strict_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", !!scsi_debug_strict);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", !!sdebug_strict);
 }
 static ssize_t strict_store(struct device_driver *ddp, const char *buf,
 			    size_t count)
@@ -4727,7 +4631,7 @@ static ssize_t strict_store(struct device_driver *ddp, const char *buf,
 	int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		scsi_debug_strict = (n > 0);
+		sdebug_strict = (n > 0);
 		return count;
 	}
 	return -EINVAL;
@@ -4787,24 +4691,24 @@ static int __init scsi_debug_init(void)
 	atomic_set(&sdebug_completions, 0);
 	atomic_set(&retired_max_queue, 0);
 
-	if (scsi_debug_ndelay >= 1000000000) {
+	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
 		pr_warn("ndelay must be less than 1 second, ignored\n");
-		scsi_debug_ndelay = 0;
-	} else if (scsi_debug_ndelay > 0)
-		scsi_debug_delay = DELAY_OVERRIDDEN;
+		sdebug_ndelay = 0;
+	} else if (sdebug_ndelay > 0)
+		sdebug_delay = DELAY_OVERRIDDEN;
 
-	switch (scsi_debug_sector_size) {
+	switch (sdebug_sector_size) {
 	case  512:
 	case 1024:
 	case 2048:
 	case 4096:
 		break;
 	default:
-		pr_err("invalid sector_size %d\n", scsi_debug_sector_size);
+		pr_err("invalid sector_size %d\n", sdebug_sector_size);
 		return -EINVAL;
 	}
 
-	switch (scsi_debug_dif) {
+	switch (sdebug_dif) {
 
 	case SD_DIF_TYPE0_PROTECTION:
 	case SD_DIF_TYPE1_PROTECTION:
@@ -4817,39 +4721,38 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
-	if (scsi_debug_guard > 1) {
+	if (sdebug_guard > 1) {
 		pr_err("guard must be 0 or 1\n");
 		return -EINVAL;
 	}
 
-	if (scsi_debug_ato > 1) {
+	if (sdebug_ato > 1) {
 		pr_err("ato must be 0 or 1\n");
 		return -EINVAL;
 	}
 
-	if (scsi_debug_physblk_exp > 15) {
-		pr_err("invalid physblk_exp %u\n", scsi_debug_physblk_exp);
+	if (sdebug_physblk_exp > 15) {
+		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
 
-	if (scsi_debug_lowest_aligned > 0x3fff) {
-		pr_err("lowest_aligned too big: %u\n",
-			scsi_debug_lowest_aligned);
+	if (sdebug_lowest_aligned > 0x3fff) {
+		pr_err("lowest_aligned too big: %u\n", sdebug_lowest_aligned);
 		return -EINVAL;
 	}
 
-	if (scsi_debug_dev_size_mb < 1)
-		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
-	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;
-	sdebug_store_sectors = sz / scsi_debug_sector_size;
+	if (sdebug_dev_size_mb < 1)
+		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
+	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
+	sdebug_store_sectors = sz / sdebug_sector_size;
 	sdebug_capacity = get_sdebug_capacity();
 
 	/* play around with geometry, don't waste too much on track 0 */
 	sdebug_heads = 8;
 	sdebug_sectors_per = 32;
-	if (scsi_debug_dev_size_mb >= 256)
+	if (sdebug_dev_size_mb >= 256)
 		sdebug_heads = 64;
-	else if (scsi_debug_dev_size_mb >= 16)
+	else if (sdebug_dev_size_mb >= 16)
 		sdebug_heads = 32;
 	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
 			       (sdebug_sectors_per * sdebug_heads);
@@ -4861,18 +4764,18 @@ static int __init scsi_debug_init(void)
 			       (sdebug_sectors_per * sdebug_heads);
 	}
 
-	if (0 == scsi_debug_fake_rw) {
+	if (0 == sdebug_fake_rw) {
 		fake_storep = vmalloc(sz);
 		if (NULL == fake_storep) {
 			pr_err("out of memory, 1\n");
 			return -ENOMEM;
 		}
 		memset(fake_storep, 0, sz);
-		if (scsi_debug_num_parts > 0)
+		if (sdebug_num_parts > 0)
 			sdebug_build_parts(fake_storep, sz);
 	}
 
-	if (scsi_debug_dix) {
+	if (sdebug_dix) {
 		int dif_size;
 
 		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
@@ -4891,18 +4794,18 @@ static int __init scsi_debug_init(void)
 
 	/* Logical Block Provisioning */
 	if (scsi_debug_lbp()) {
-		scsi_debug_unmap_max_blocks =
-			clamp(scsi_debug_unmap_max_blocks, 0U, 0xffffffffU);
+		sdebug_unmap_max_blocks =
+			clamp(sdebug_unmap_max_blocks, 0U, 0xffffffffU);
 
-		scsi_debug_unmap_max_desc =
-			clamp(scsi_debug_unmap_max_desc, 0U, 256U);
+		sdebug_unmap_max_desc =
+			clamp(sdebug_unmap_max_desc, 0U, 256U);
 
-		scsi_debug_unmap_granularity =
-			clamp(scsi_debug_unmap_granularity, 1U, 0xffffffffU);
+		sdebug_unmap_granularity =
+			clamp(sdebug_unmap_granularity, 1U, 0xffffffffU);
 
-		if (scsi_debug_unmap_alignment &&
-		    scsi_debug_unmap_granularity <=
-		    scsi_debug_unmap_alignment) {
+		if (sdebug_unmap_alignment &&
+		    sdebug_unmap_granularity <=
+		    sdebug_unmap_alignment) {
 			pr_err("ERR: unmap_granularity <= unmap_alignment\n");
 			return -EINVAL;
 		}
@@ -4921,7 +4824,7 @@ static int __init scsi_debug_init(void)
 		bitmap_zero(map_storep, map_size);
 
 		/* Map first 1KB for partition table */
-		if (scsi_debug_num_parts)
+		if (sdebug_num_parts)
 			map_region(0, 2);
 	}
 
@@ -4942,8 +4845,8 @@ static int __init scsi_debug_init(void)
 		goto bus_unreg;
 	}
 
-	host_to_add = scsi_debug_add_host;
-        scsi_debug_add_host = 0;
+	host_to_add = sdebug_add_host;
+	sdebug_add_host = 0;
 
         for (k = 0; k < host_to_add; k++) {
                 if (sdebug_add_adapter()) {
@@ -4952,8 +4855,8 @@ static int __init scsi_debug_init(void)
                 }
         }
 
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		pr_info("built %d host(s)\n", scsi_debug_add_host);
+	if (sdebug_verbose)
+		pr_info("built %d host(s)\n", sdebug_add_host);
 
 	return 0;
 
@@ -4971,7 +4874,7 @@ free_vm:
 
 static void __exit scsi_debug_exit(void)
 {
-	int k = scsi_debug_add_host;
+	int k = sdebug_add_host;
 
 	stop_all_queued();
 	free_all_queued();
@@ -5011,7 +4914,7 @@ static int sdebug_add_adapter(void)
 
         INIT_LIST_HEAD(&sdbg_host->dev_info_list);
 
-	devs_per_host = scsi_debug_num_tgts * scsi_debug_max_luns;
+	devs_per_host = sdebug_num_tgts * sdebug_max_luns;
         for (k = 0; k < devs_per_host; k++) {
 		sdbg_devinfo = sdebug_device_create(sdbg_host, GFP_KERNEL);
 		if (!sdbg_devinfo) {
@@ -5028,14 +4931,14 @@ static int sdebug_add_adapter(void)
         sdbg_host->dev.bus = &pseudo_lld_bus;
         sdbg_host->dev.parent = pseudo_primary;
         sdbg_host->dev.release = &sdebug_release_adapter;
-        dev_set_name(&sdbg_host->dev, "adapter%d", scsi_debug_add_host);
+	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_add_host);
 
         error = device_register(&sdbg_host->dev);
 
         if (error)
 		goto clean;
 
-	++scsi_debug_add_host;
+	++sdebug_add_host;
         return error;
 
 clean:
@@ -5064,8 +4967,8 @@ static void sdebug_remove_adapter(void)
 	if (!sdbg_host)
 		return;
 
-        device_unregister(&sdbg_host->dev);
-        --scsi_debug_add_host;
+	device_unregister(&sdbg_host->dev);
+	--sdebug_add_host;
 }
 
 static int
@@ -5091,7 +4994,7 @@ sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 		qdepth = SCSI_DEBUG_CANQUEUE + 10;
 	scsi_change_queue_depth(sdev, qdepth);
 
-	if (SCSI_DEBUG_OPT_Q_NOISE & scsi_debug_opts) {
+	if (SDEBUG_OPT_Q_NOISE & sdebug_opts) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: qdepth=%d, num_in_q=%d\n",
 			    __func__, qdepth, num_in_q);
@@ -5106,28 +5009,25 @@ check_inject(struct scsi_cmnd *scp)
 
 	memset(ep, 0, sizeof(struct sdebug_scmd_extra_t));
 
-	if (atomic_inc_return(&sdebug_cmnd_count) >=
-	    abs(scsi_debug_every_nth)) {
+	if (atomic_inc_return(&sdebug_cmnd_count) >= abs(sdebug_every_nth)) {
 		atomic_set(&sdebug_cmnd_count, 0);
-		if (scsi_debug_every_nth < -1)
-			scsi_debug_every_nth = -1;
-		if (SCSI_DEBUG_OPT_TIMEOUT & scsi_debug_opts)
+		if (sdebug_every_nth < -1)
+			sdebug_every_nth = -1;
+		if (SDEBUG_OPT_TIMEOUT & sdebug_opts)
 			return 1; /* ignore command causing timeout */
-		else if (SCSI_DEBUG_OPT_MAC_TIMEOUT & scsi_debug_opts &&
+		else if (SDEBUG_OPT_MAC_TIMEOUT & sdebug_opts &&
 			 scsi_medium_access_command(scp))
 			return 1; /* time out reads and writes */
 		if (sdebug_any_injecting_opt) {
-			int opts = scsi_debug_opts;
-
-			if (SCSI_DEBUG_OPT_RECOVERED_ERR & opts)
+			if (SDEBUG_OPT_RECOVERED_ERR & sdebug_opts)
 				ep->inj_recovered = true;
-			else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & opts)
+			if (SDEBUG_OPT_TRANSPORT_ERR & sdebug_opts)
 				ep->inj_transport = true;
-			else if (SCSI_DEBUG_OPT_DIF_ERR & opts)
+			if (SDEBUG_OPT_DIF_ERR & sdebug_opts)
 				ep->inj_dif = true;
-			else if (SCSI_DEBUG_OPT_DIX_ERR & opts)
+			if (SDEBUG_OPT_DIX_ERR & sdebug_opts)
 				ep->inj_dix = true;
-			else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & opts)
+			if (SDEBUG_OPT_SHORT_TRANSFER & sdebug_opts)
 				ep->inj_short = true;
 		}
 	}
@@ -5146,15 +5046,13 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
 	int k, na;
 	int errsts = 0;
-	int errsts_no_connect = DID_NO_CONNECT << 16;
 	u32 flags;
 	u16 sa;
 	u8 opcode = cmd[0];
 	bool has_wlun_rl;
-	bool debug = !!(SCSI_DEBUG_OPT_NOISE & scsi_debug_opts);
 
 	scsi_set_resid(scp, 0);
-	if (debug && !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts)) {
+	if (sdebug_verbose && !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts)) {
 		char b[120];
 		int n, len, sb;
 
@@ -5170,8 +5068,8 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
 	}
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
-	if ((sdp->lun >= scsi_debug_max_luns) && !has_wlun_rl)
-		return schedule_resp(scp, NULL, errsts_no_connect, 0);
+	if ((sdp->lun >= sdebug_max_luns) && !has_wlun_rl)
+		return schedule_resp(scp, NULL, DID_NO_CONNECT << 16, 0);
 
 	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
 	oip = &opcode_info_arr[sdeb_i];		/* safe if table consistent */
@@ -5179,7 +5077,8 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 	if (!devip) {
 		devip = devInfoReg(sdp);
 		if (NULL == devip)
-			return schedule_resp(scp, NULL, errsts_no_connect, 0);
+			return schedule_resp(scp, NULL, DID_NO_CONNECT << 16,
+					     0);
 	}
 	na = oip->num_attached;
 	r_pfp = oip->pfp;
@@ -5216,13 +5115,13 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 		goto check_cond;
 	}
 	if (has_wlun_rl && !(F_RL_WLUN_OK & flags)) {
-		if (debug)
-			sdev_printk(KERN_INFO, sdp, "scsi_debug: Opcode: "
-				    "0x%x not supported for wlun\n", opcode);
+		if (sdebug_verbose)
+			sdev_printk(KERN_INFO, sdp, "%s: Opcode 0x%x not%s\n",
+				    my_name, opcode, " supported for wlun");
 		mk_sense_invalid_opcode(scp);
 		goto check_cond;
 	}
-	if (scsi_debug_strict) {	/* check cdb against mask */
+	if (sdebug_strict) {	/* check cdb against mask */
 		u8 rem;
 		int j;
 
@@ -5246,16 +5145,16 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 	}
 	if ((F_M_ACCESS & flags) && devip->stopped) {
 		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
-		if (debug)
+		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, sdp, "%s reports: Not ready: "
 				    "%s\n", my_name, "initializing command "
 				    "required");
 		errsts = check_condition_result;
 		goto fini;
 	}
-	if (scsi_debug_fake_rw && (F_FAKE_RW & flags))
+	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
-	if (scsi_debug_every_nth) {
+	if (sdebug_every_nth) {
 		if (check_inject(scp))
 			return 0;	/* ignore command: make trouble */
 	}
@@ -5266,7 +5165,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *scp)
 
 fini:
 	return schedule_resp(scp, devip, errsts,
-			     ((F_DELAY_OVERR & flags) ? 0 : scsi_debug_delay));
+			     ((F_DELAY_OVERR & flags) ? 0 : sdebug_delay));
 check_cond:
 	return schedule_resp(scp, devip, check_condition_result, 0);
 }
@@ -5274,7 +5173,7 @@ check_cond:
 static int
 sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
-	if (scsi_debug_host_lock) {
+	if (sdebug_host_lock) {
 		unsigned long iflags;
 		int rc;
 
@@ -5317,15 +5216,14 @@ static struct scsi_host_template sdebug_driver_template = {
 static int sdebug_driver_probe(struct device * dev)
 {
 	int error = 0;
-	int opts;
 	struct sdebug_host_info *sdbg_host;
 	struct Scsi_Host *hpnt;
 	int host_prot;
 
 	sdbg_host = to_sdebug_host(dev);
 
-	sdebug_driver_template.can_queue = scsi_debug_max_queue;
-	if (scsi_debug_clustering)
+	sdebug_driver_template.can_queue = sdebug_max_queue;
+	if (sdebug_clustering)
 		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
 	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
 	if (NULL == hpnt) {
@@ -5336,37 +5234,37 @@ static int sdebug_driver_probe(struct device * dev)
 
         sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
-	if ((hpnt->this_id >= 0) && (scsi_debug_num_tgts > hpnt->this_id))
-		hpnt->max_id = scsi_debug_num_tgts + 1;
+	if ((hpnt->this_id >= 0) && (sdebug_num_tgts > hpnt->this_id))
+		hpnt->max_id = sdebug_num_tgts + 1;
 	else
-		hpnt->max_id = scsi_debug_num_tgts;
-	/* = scsi_debug_max_luns; */
+		hpnt->max_id = sdebug_num_tgts;
+	/* = sdebug_max_luns; */
 	hpnt->max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
 
 	host_prot = 0;
 
-	switch (scsi_debug_dif) {
+	switch (sdebug_dif) {
 
 	case SD_DIF_TYPE1_PROTECTION:
 		host_prot = SHOST_DIF_TYPE1_PROTECTION;
-		if (scsi_debug_dix)
+		if (sdebug_dix)
 			host_prot |= SHOST_DIX_TYPE1_PROTECTION;
 		break;
 
 	case SD_DIF_TYPE2_PROTECTION:
 		host_prot = SHOST_DIF_TYPE2_PROTECTION;
-		if (scsi_debug_dix)
+		if (sdebug_dix)
 			host_prot |= SHOST_DIX_TYPE2_PROTECTION;
 		break;
 
 	case SD_DIF_TYPE3_PROTECTION:
 		host_prot = SHOST_DIF_TYPE3_PROTECTION;
-		if (scsi_debug_dix)
+		if (sdebug_dix)
 			host_prot |= SHOST_DIX_TYPE3_PROTECTION;
 		break;
 
 	default:
-		if (scsi_debug_dix)
+		if (sdebug_dix)
 			host_prot |= SHOST_DIX_TYPE0_PROTECTION;
 		break;
 	}
@@ -5382,23 +5280,13 @@ static int sdebug_driver_probe(struct device * dev)
 	       (host_prot & SHOST_DIX_TYPE2_PROTECTION) ? " DIX2" : "",
 	       (host_prot & SHOST_DIX_TYPE3_PROTECTION) ? " DIX3" : "");
 
-	if (scsi_debug_guard == 1)
+	if (sdebug_guard == 1)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_IP);
 	else
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
 
-	opts = scsi_debug_opts;
-	if (SCSI_DEBUG_OPT_RECOVERED_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_TRANSPORT_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_DIF_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_DIX_ERR & opts)
-		sdebug_any_injecting_opt = true;
-	else if (SCSI_DEBUG_OPT_SHORT_TRANSFER & opts)
-		sdebug_any_injecting_opt = true;
-
+	sdebug_verbose = !!(SDEBUG_OPT_NOISE & sdebug_opts);
+	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts);
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
 		pr_err("scsi_add_host failed\n");
-- 
2.7.4

