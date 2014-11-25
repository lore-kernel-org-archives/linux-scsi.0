From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 1/5] scsi_debug: pinpoint invalid field in sense data
Date: Mon, 24 Nov 2014 23:04:47 -0500
Message-ID: <5473FFDF.5070206@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080207040405090509030508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54358 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbaKYEFC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 23:05:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This is a multi-part message in MIME format.
--------------080207040405090509030508
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Use Sense Key Specific field in the sense data of an ILLEGAL REQUEST
to optionally pinpoint the location of the problem field. This may
be either in the cdb or the associated parameter list.
---
  drivers/scsi/scsi_debug.c | 138 +++++++++++++++++++++++++++++-----------------
  1 file changed, 88 insertions(+), 50 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------080207040405090509030508
Content-Type: text/x-patch;
 name="0001-pinpoint-invalid-field-in-sense-data.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-pinpoint-invalid-field-in-sense-data.patch"

>From e3cded06f31aa46a889664c1ea7df7b8b9b998e7 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:08:11 -0500
Subject: [PATCH 1/5] pinpoint invalid field in sense data

Use Sense Key Specific field in the sense data of an ILLEGAL REQUEST
to optionally pinpoint the location of the problem field. This may
be either in the cdb or the associated parameter list.
---
 drivers/scsi/scsi_debug.c | 138 +++++++++++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ce71b6d..a1bca60 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -63,31 +63,34 @@
 #include "sd.h"
 #include "scsi_logging.h"
 
-#define SCSI_DEBUG_VERSION "1.84"
-static const char *scsi_debug_version_date = "20140706";
+#define SCSI_DEBUG_VERSION "1.85"
+static const char *scsi_debug_version_date = "20141022";
 
 #define MY_NAME "scsi_debug"
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
 #define LOGICAL_UNIT_NOT_READY 0x4
-#define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
 #define UNRECOVERED_READ_ERR 0x11
 #define PARAMETER_LIST_LENGTH_ERR 0x1a
 #define INVALID_OPCODE 0x20
-#define ADDR_OUT_OF_RANGE 0x21
 #define INVALID_COMMAND_OPCODE 0x20
+#define LBA_OUT_OF_RANGE 0x21
 #define INVALID_FIELD_IN_CDB 0x24
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
 #define UA_RESET_ASC 0x29
 #define UA_CHANGED_ASC 0x2a
+#define INSUFF_RES_ASC 0x55
+#define INSUFF_RES_ASCQ 0x3
 #define POWER_ON_RESET_ASCQ 0x0
 #define BUS_RESET_ASCQ 0x2	/* scsi bus reset occurred */
 #define MODE_CHANGED_ASCQ 0x1	/* mode parameters changed */
+#define CAPACITY_CHANGED_ASCQ 0x9
 #define SAVING_PARAMS_UNSUP 0x39
 #define TRANSPORT_PROBLEM 0x4b
 #define THRESHOLD_EXCEEDED 0x5d
 #define LOW_POWER_COND_ON 0x5e
+#define MISCOMPARE_VERIFY_ASC 0x1d
 
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
@@ -394,6 +397,50 @@ static void sdebug_max_tgts_luns(void)
 	spin_unlock(&sdebug_host_list_lock);
 }
 
+enum sdeb_cmd_data {SDEB_IN_DATA = 0, SDEB_IN_CDB = 1};
+
+/* Set in_bit to -1 to indicate no bit position of invalid field */
+static void
+mk_sense_invalid_fld(struct scsi_cmnd *scp, enum sdeb_cmd_data c_d,
+		     int in_byte, int in_bit)
+{
+	unsigned char *sbuff;
+	u8 sks[4];
+	int sl, asc;
+
+	sbuff = scp->sense_buffer;
+	if (!sbuff) {
+		sdev_printk(KERN_ERR, scp->device,
+			    "%s: sense_buffer is NULL\n", __func__);
+		return;
+	}
+	asc = c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;
+	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);
+	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, ILLEGAL_REQUEST,
+				asc, 0);
+	memset(sks, 0, sizeof(sks));
+	sks[0] = 0x80;
+	if (c_d)
+		sks[0] |= 0x40;
+	if (in_bit >= 0) {
+		sks[0] |= 0x8;
+		sks[0] |= 0x7 & in_bit;
+	}
+	put_unaligned_be16(in_byte, sks + 1);
+	if (scsi_debug_dsense) {
+		sl = sbuff[7] + 8;
+		sbuff[7] = sl;
+		sbuff[sl] = 0x2;
+		sbuff[sl + 1] = 0x6;
+		memcpy(sbuff + sl + 4, sks, 3);
+	} else
+		memcpy(sbuff + 15, sks, 3);
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		sdev_printk(KERN_INFO, scp->device, "%s:  [sense_key,asc,ascq"
+			    "]: [0x5,0x%x,0x0] %c byte=%d, bit=%d\n",
+			    my_name, asc, c_d ? 'C' : 'D', in_byte, in_bit);
+}
+
 static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 {
 	unsigned char *sbuff;
@@ -414,6 +461,12 @@ static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
 			    my_name, key, asc, asq);
 }
 
+static void
+mk_sense_invalid_opcode(struct scsi_cmnd *scp)
+{
+	mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
+}
+
 static void get_data_transfer_info(unsigned char *cmd,
 				   unsigned long long *lba, unsigned int *num,
 				   u32 *ei_lba)
@@ -944,8 +997,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, int target,
 		pq_pdt = (scsi_debug_ptype & 0x1f);
 	arr[0] = pq_pdt;
 	if (0x2 & cmd[1]) {  /* CMDDT bit set */
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-			       	0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
 		kfree(arr);
 		return check_condition_result;
 	} else if (0x1 & cmd[1]) {  /* EVPD bit set */
@@ -1029,9 +1081,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, int target,
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_evpd_b2(&arr[4]);
 		} else {
-			/* Illegal request, invalid field in cdb */
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 			kfree(arr);
 			return check_condition_result;
 		}
@@ -1123,8 +1173,7 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 		return errsts;
 	power_cond = (cmd[4] & 0xf0) >> 4;
 	if (power_cond) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-			       	0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, 7);
 		return check_condition_result;
 	}
 	start = cmd[4] & 1;
@@ -1542,8 +1591,7 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 
 	if ((subpcode > 0x0) && (subpcode < 0xff) && (0x19 != pcode)) {
 		/* TODO: Control Extension page */
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-			       	0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
 	switch (pcode) {
@@ -1569,8 +1617,7 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 		break;
 	case 0x19:	/* if spc==1 then sas phy, control+discover */
 		if ((subpcode > 0x2) && (subpcode < 0xff)) {
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 			return check_condition_result;
 	        }
 		len = 0;
@@ -1602,15 +1649,13 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 			}
 			len += resp_iec_m_pg(ap + len, pcontrol, target);
 		} else {
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 			return check_condition_result;
                 }
 		offset += len;
 		break;
 	default:
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-			       	0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
 		return check_condition_result;
 	}
 	if (msense_6)
@@ -1640,8 +1685,7 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	sp = cmd[1] & 0x1;
 	param_len = mselect6 ? cmd[4] : ((cmd[7] << 8) + cmd[8]);
 	if ((0 == pf) || sp || (param_len > SDEBUG_MAX_MSELECT_SZ)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, mselect6 ? 4 : 7, -1);
 		return check_condition_result;
 	}
         res = fetch_to_dev_buffer(scp, arr, param_len);
@@ -1655,16 +1699,14 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	md_len = mselect6 ? (arr[0] + 1) : ((arr[0] << 8) + arr[1] + 2);
 	bd_len = mselect6 ? arr[3] : ((arr[6] << 8) + arr[7]);
 	if (md_len > 2) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_PARAM_LIST, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
 		return check_condition_result;
 	}
 	off = bd_len + (mselect6 ? 4 : 8);
 	mpage = arr[off] & 0x3f;
 	ps = !!(arr[off] & 0x80);
 	if (ps) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_PARAM_LIST, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_DATA, off, 7);
 		return check_condition_result;
 	}
 	spf = !!(arr[off] & 0x40);
@@ -1701,8 +1743,7 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	default:
 		break;
 	}
-	mk_sense_buffer(scp, ILLEGAL_REQUEST,
-			INVALID_FIELD_IN_PARAM_LIST, 0);
+	mk_sense_invalid_fld(scp, SDEB_IN_DATA, off, 5);
 	return check_condition_result;
 set_mode_changed_ua:
 	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
@@ -1748,8 +1789,7 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 	ppc = cmd[1] & 0x2;
 	sp = cmd[1] & 0x1;
 	if (ppc || sp) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, ppc ? 1 : 0);
 		return check_condition_result;
 	}
 	pcontrol = (cmd[2] & 0xc0) >> 6;
@@ -1773,8 +1813,7 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 			arr[3] = resp_ie_l_pg(arr + 4);
 			break;
 		default:
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
 			return check_condition_result;
 		}
 	} else if (0xff == subpcode) {
@@ -1806,13 +1845,11 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 			arr[3] = n - 4;
 			break;
 		default:
-			mk_sense_buffer(scp, ILLEGAL_REQUEST,
-					INVALID_FIELD_IN_CDB, 0);
+			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
 			return check_condition_result;
 		}
 	} else {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_CDB, 0);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
 	len = min(((arr[2] << 8) + arr[3]) + 4, alloc_len);
@@ -1824,11 +1861,12 @@ static int check_device_access_params(struct scsi_cmnd *scp,
 				      unsigned long long lba, unsigned int num)
 {
 	if (lba + num > sdebug_capacity) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
 	/* transfer length excessive (tie in to block limits VPD page) */
 	if (num > sdebug_store_sectors) {
+		/* needs work to find which cdb byte 'num' comes from */
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
@@ -2412,8 +2450,8 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 			    struct sdebug_dev_info * devip)
 {
 	unsigned int alloc_len;
-	int lun_cnt, i, upper, num, n;
-	u64 wlun, lun;
+	int lun_cnt, i, upper, num, n, want_wlun, shortish;
+	u64 lun;
 	unsigned char *cmd = scp->cmnd;
 	int select_report = (int)cmd[2];
 	struct scsi_lun *one_lun;
@@ -2421,9 +2459,9 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 	unsigned char * max_addr;
 
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
-	if ((alloc_len < 4) || (select_report > 2)) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-			       	0);
+	shortish = (alloc_len < 4);
+	if (shortish || (select_report > 2)) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, shortish ? 6 : 2, -1);
 		return check_condition_result;
 	}
 	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
@@ -2433,14 +2471,14 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 		lun_cnt = 0;
 	else if (scsi_debug_no_lun_0 && (lun_cnt > 0))
 		--lun_cnt;
-	wlun = (select_report > 0) ? 1 : 0;
-	num = lun_cnt + wlun;
+	want_wlun = (select_report > 0) ? 1 : 0;
+	num = lun_cnt + want_wlun;
 	arr[2] = ((sizeof(struct scsi_lun) * num) >> 8) & 0xff;
 	arr[3] = (sizeof(struct scsi_lun) * num) & 0xff;
 	n = min((int)((SDEBUG_RLUN_ARR_SZ - 8) /
 			    sizeof(struct scsi_lun)), num);
 	if (n < num) {
-		wlun = 0;
+		want_wlun = 0;
 		lun_cnt = n;
 	}
 	one_lun = (struct scsi_lun *) &arr[8];
@@ -2454,7 +2492,7 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 			    (upper | (SAM2_LUN_ADDRESS_METHOD << 6));
 		one_lun[i].scsi_lun[1] = lun & 0xff;
 	}
-	if (wlun) {
+	if (want_wlun) {
 		one_lun[i].scsi_lun[0] = (SAM2_WLUN_REPORT_LUNS >> 8) & 0xff;
 		one_lun[i].scsi_lun[1] = SAM2_WLUN_REPORT_LUNS & 0xff;
 		i++;
@@ -2476,8 +2514,8 @@ static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
 	/* better not to use temporary buffer. */
 	buf = kmalloc(scsi_bufflen(scp), GFP_ATOMIC);
 	if (!buf) {
-		mk_sense_buffer(scp, NOT_READY,
-				LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
 		return check_condition_result;
 	}
 
@@ -4555,9 +4593,9 @@ static struct scsi_host_template sdebug_driver_template = {
 
 static int sdebug_driver_probe(struct device * dev)
 {
-        int error = 0;
-        struct sdebug_host_info *sdbg_host;
-        struct Scsi_Host *hpnt;
+	int error = 0;
+	struct sdebug_host_info *sdbg_host;
+	struct Scsi_Host *hpnt;
 	int host_prot;
 
 	sdbg_host = to_sdebug_host(dev);
-- 
1.9.1


--------------080207040405090509030508--
