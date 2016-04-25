From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 08/12] scsi_debug: rework resp_report_luns
Date: Mon, 25 Apr 2016 12:16:35 -0400
Message-ID: <1461600999-28893-9-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37001 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016AbcDYQRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:17:13 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

Based on "[PATH V2] scsi_debug: rework resp_report_luns" patch
sent by Tomas Winkler on Thursday, 26 Feb 2015. His notes:
  1. Remove duplicated boundary checks which simplify the fill-in
     loop
  2. Use more of scsi generic API
Replace fixed length response array a with heap allocation
allowing up to 16383 LUNs per target.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 138 ++++++++++++++++++++++++++++++----------------
 1 file changed, 91 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cf44ab0..eac62b8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3205,63 +3205,99 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
 }
 
-#define SDEBUG_RLUN_ARR_SZ 256
-
-static int resp_report_luns(struct scsi_cmnd * scp,
-			    struct sdebug_dev_info * devip)
+/* Even though each pseudo target has a REPORT LUNS "well known logical unit"
+ * (W-LUN), the normal Linux scanning logic does not associate it with a
+ * device (e.g. /dev/sg7). The following magic will make that association:
+ *   "cd /sys/class/scsi_host/host<n> ; echo '- - 49409' > scan"
+ * where <n> is a host number. If there are multiple targets in a host then
+ * the above will associate a W-LUN to each target. To only get a W-LUN
+ * for target 2, then use "echo '- 2 49409' > scan" . */
+static int resp_report_luns(struct scsi_cmnd *scp,
+			    struct sdebug_dev_info *devip)
 {
+	unsigned char *cmd = scp->cmnd;
 	unsigned int alloc_len;
-	int lun_cnt, i, upper, num, n, want_wlun, shortish;
+	unsigned char select_report;
 	u64 lun;
-	unsigned char *cmd = scp->cmnd;
-	int select_report = (int)cmd[2];
-	struct scsi_lun *one_lun;
-	unsigned char arr[SDEBUG_RLUN_ARR_SZ];
-	unsigned char * max_addr;
+	struct scsi_lun *lun_p;
+	u8 *arr;
+	unsigned int lun_cnt;	/* normal LUN count (max: 16383) */
+	unsigned int wlun_cnt;	/* report luns W-LUN count */
+	unsigned int tlun_cnt;	/* total LUN count */
+	unsigned int rlen;	/* response length (in bytes) less header */
+	int i, res;
 
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
 	lun_cnt = sdebug_max_luns;
-	if (1 == select_report)
+	wlun_cnt = 0;
+
+	/* report only w_lun */
+	if (select_report == 0x01)
 		lun_cnt = 0;
-	else if (sdebug_no_lun_0 && (lun_cnt > 0))
+
+	if (sdebug_no_lun_0 && (lun_cnt > 0))
 		--lun_cnt;
-	want_wlun = (select_report > 0) ? 1 : 0;
-	num = lun_cnt + want_wlun;
-	arr[2] = ((sizeof(struct scsi_lun) * num) >> 8) & 0xff;
-	arr[3] = (sizeof(struct scsi_lun) * num) & 0xff;
-	n = min((int)((SDEBUG_RLUN_ARR_SZ - 8) /
-			    sizeof(struct scsi_lun)), num);
-	if (n < num) {
-		want_wlun = 0;
-		lun_cnt = n;
-	}
-	one_lun = (struct scsi_lun *) &arr[8];
-	max_addr = arr + SDEBUG_RLUN_ARR_SZ;
-	for (i = 0, lun = (sdebug_no_lun_0 ? 1 : 0);
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
+	/* report w_lun */
+	if (select_report == 0x01 || select_report == 0x02)
+		wlun_cnt = 1;
+
+	tlun_cnt = lun_cnt + wlun_cnt;
+	/* can produce response with up to 16k luns (lun 0 to lun 16383) */
+	arr = kzalloc((tlun_cnt * sizeof(lun_p->scsi_lun)) + 8, GFP_ATOMIC);
+	if (!arr) {
+		pr_warn("No space for report luns response\n");
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
+	pr_debug("select_report %d luns = %d wluns = %d no_lun0 %d\n",
+		 select_report, lun_cnt, wlun_cnt, sdebug_no_lun_0);
+
+	lun = 0LL;
+	/* luns start at offset 8 after the byte length */
+	lun_p = (struct scsi_lun *)&arr[8];
+
+	/* skip lun 0 */
+	if (sdebug_no_lun_0)
+		lun++;
+	/*
+	 * Address method (we use Peripherial = 00b)
+	 * 10b - Logical unit
+	 * 00b - Peripherial device - Use this one
+	 * 01b - Logical device
+	 * 11b - reserved
+	 */
+	for (i = 0; i < lun_cnt; i++)
+		int_to_scsilun(lun++, lun_p++);
+
+	/* report SCSI_W_LUN_REPORT_LUN */
+	if (wlun_cnt)
+		int_to_scsilun(SCSI_W_LUN_REPORT_LUNS, lun_p++);
+
+	rlen = tlun_cnt * sizeof(struct scsi_lun);
+
+	put_unaligned_be32(rlen, &arr[0]);
+
+	res = fill_from_dev_buffer(scp, arr, rlen + 8);
+	kfree(arr);
+	return res;
 }
 
 static int resp_xdwriteread(struct scsi_cmnd *scp, unsigned long long lba,
@@ -4299,6 +4335,10 @@ static ssize_t max_luns_store(struct device_driver *ddp, const char *buf,
 	bool changed;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		if (n > 16383) {
+			pr_warn("max_luns can be no more than 16383\n");
+			return -EINVAL;
+		}
 		changed = (sdebug_max_luns != n);
 		sdebug_max_luns = n;
 		sdebug_max_tgts_luns();
@@ -4643,6 +4683,10 @@ static int __init scsi_debug_init(void)
 		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
+	if (sdebug_max_luns > 16383) {
+		pr_warn("max_luns can be no more than 16383, use default\n");
+		sdebug_max_luns = DEF_MAX_LUNS;
+	}
 
 	if (sdebug_lowest_aligned > 0x3fff) {
 		pr_err("lowest_aligned too big: %u\n", sdebug_lowest_aligned);
-- 
2.7.4

