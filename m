From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATH V2] scsi_debug: rework resp_report_luns
Date: Thu, 26 Feb 2015 09:57:54 +0200
Message-ID: <1424937474-27765-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbbBZH6n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2015 02:58:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Douglas Gilbert <dgilbert@interlog.com>

1. Remove duplicated boundary checks which simplify
the fill-in loop
2. Use more of scsi generic API

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: keep alloc_len < 4 as required by SPC-4 and newer

 drivers/scsi/scsi_debug.c | 119 +++++++++++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 94c18e300135..079934c8698e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3320,63 +3320,96 @@ resp_get_lba_status(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
 }
 
-#define SDEBUG_RLUN_ARR_SZ 256
+#define SDEBUG_MAX_RLUNS 31
+#define SDEBUG_RLUN_ARR_SZ ((SDEBUG_MAX_RLUNS * 8) + 8)
 
-static int resp_report_luns(struct scsi_cmnd * scp,
-			    struct sdebug_dev_info * devip)
+static int resp_report_luns(struct scsi_cmnd *scp,
+			    struct sdebug_dev_info *devip)
 {
+	unsigned char *cmd = scp->cmnd;
 	unsigned int alloc_len;
-	int lun_cnt, i, upper, num, n, want_wlun, shortish;
+	unsigned char select_report;
+
 	u64 lun;
-	unsigned char *cmd = scp->cmnd;
-	int select_report = (int)cmd[2];
 	struct scsi_lun *one_lun;
-	unsigned char arr[SDEBUG_RLUN_ARR_SZ];
-	unsigned char * max_addr;
+	u8 arr[SDEBUG_RLUN_ARR_SZ];
+	unsigned int lun_cnt;          /* LUN count */
+	unsigned int wlun_cnt;         /* W_LUN count */
+	unsigned int rlun_cnt;         /* reported LUN count */
+	unsigned int rlen;             /* reported luns in bytes */
+	unsigned int n;
+	int i;
 
 	clear_luns_changed_on_target(devip);
-	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
-	shortish = (alloc_len < 4);
-	if (shortish || (select_report > 2)) {
-		mk_sense_invalid_fld(scp, SDEB_IN_CDB, shortish ? 6 : 2, -1);
+
+	select_report = cmd[2];
+	alloc_len = get_unaligned_be32(cmd + 6);
+
+	if (alloc_len < 4) {
+		pr_err("alloc len too small %d\n", alloc_len);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 6, -1);
 		return check_condition_result;
 	}
-	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
-	memset(arr, 0, SDEBUG_RLUN_ARR_SZ);
+
+	if (select_report > 0x02) {
+		pr_err("select report invalid %d\n", select_report);
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
+		return check_condition_result;
+	}
+
 	lun_cnt = scsi_debug_max_luns;
-	if (1 == select_report)
+	wlun_cnt = 0;
+
+	/* report only w_lun */
+	if (select_report == 0x01)
 		lun_cnt = 0;
-	else if (scsi_debug_no_lun_0 && (lun_cnt > 0))
+
+	if (scsi_debug_no_lun_0 && (lun_cnt > 0))
 		--lun_cnt;
-	want_wlun = (select_report > 0) ? 1 : 0;
-	num = lun_cnt + want_wlun;
-	arr[2] = ((sizeof(struct scsi_lun) * num) >> 8) & 0xff;
-	arr[3] = (sizeof(struct scsi_lun) * num) & 0xff;
-	n = min((int)((SDEBUG_RLUN_ARR_SZ - 8) /
-			    sizeof(struct scsi_lun)), num);
-	if (n < num) {
-		want_wlun = 0;
+
+	/* report w_lun */
+	if (select_report == 0x01 || select_report == 0x02)
+		wlun_cnt = 1;
+
+	rlun_cnt = lun_cnt + wlun_cnt;
+
+	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
+	n = min_t(int, SDEBUG_MAX_RLUNS, rlun_cnt);
+	if (n < rlun_cnt) {
+		wlun_cnt = 0;
 		lun_cnt = n;
 	}
-	one_lun = (struct scsi_lun *) &arr[8];
-	max_addr = arr + SDEBUG_RLUN_ARR_SZ;
-	for (i = 0, lun = (scsi_debug_no_lun_0 ? 1 : 0);
-             ((i < lun_cnt) && ((unsigned char *)(one_lun + i) < max_addr));
-	     i++, lun++) {
-		upper = (lun >> 8) & 0x3f;
-		if (upper)
-			one_lun[i].scsi_lun[0] =
-			    (upper | (SAM2_LUN_ADDRESS_METHOD << 6));
-		one_lun[i].scsi_lun[1] = lun & 0xff;
-	}
-	if (want_wlun) {
-		one_lun[i].scsi_lun[0] = (SCSI_W_LUN_REPORT_LUNS >> 8) & 0xff;
-		one_lun[i].scsi_lun[1] = SCSI_W_LUN_REPORT_LUNS & 0xff;
-		i++;
-	}
-	alloc_len = (unsigned char *)(one_lun + i) - arr;
-	return fill_from_dev_buffer(scp, arr,
-				    min((int)alloc_len, SDEBUG_RLUN_ARR_SZ));
+
+	pr_debug("select_report %d luns = %d wluns = %d no_lun0 %d\n",
+		 select_report, lun_cnt, wlun_cnt, scsi_debug_no_lun_0);
+
+	lun = 0LL;
+	/* luns start at offset 8 after the byte length */
+	one_lun = (struct scsi_lun *)&arr[8];
+
+	/* skip lun 0 */
+	if (scsi_debug_no_lun_0)
+		lun++;
+
+	/*
+	 * Address method (we use Peripherial = 00b)
+	 * 10b - Logical unit
+	 * 00b - Peripherial device - Use this one
+	 * 01b - Logical device
+	 * 11b - reserved
+	 */
+	for (i = 0; i < lun_cnt; i++)
+		int_to_scsilun(lun++, one_lun++);
+
+	/* report SCSI_W_LUN_REPORT_LUN */
+	if (wlun_cnt)
+		int_to_scsilun(SCSI_W_LUN_REPORT_LUNS, one_lun++);
+
+	rlen = rlun_cnt * sizeof(struct scsi_lun);
+
+	put_unaligned_be32(rlen, &arr[0]);
+
+	return fill_from_dev_buffer(scp, arr, rlen + 8);
 }
 
 static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
-- 
1.9.3

