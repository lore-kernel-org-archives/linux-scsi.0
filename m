From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2] scsi_debug: fix sleep in invalid context
Date: Tue, 31 May 2016 17:15:07 -0400
Message-ID: <1464729307-22182-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56000 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbcEaVPO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2016 17:15:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, bart.vanassche@sandisk.com, hch@infradead.org

In this post: http://www.spinics.net/lists/linux-scsi/msg97124.html
the author shows some kernel infrastructure complaining about a
sleep in an invalid context. Remove offending call to vmalloc().
Instead of using kzalloc() which reviewers didn't like, use a
bucket system (64 bytes on the stack) and potentially multiple
calls to sg_pcopy_from_buffer() to construct the 'data-in' buffer
for the SCSI REPORT LUNS command.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 93 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0f9ba41..6a219a0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -890,7 +890,7 @@ static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
-/* Returns 0 if ok else (DID_ERROR << 16). Sets scp->resid . */
+/* Build SCSI "data-in" buffer. Returns 0 if ok else (DID_ERROR << 16). */
 static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 				int arr_len)
 {
@@ -909,7 +909,35 @@ static int fill_from_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 	return 0;
 }
 
-/* Returns number of bytes fetched into 'arr' or -1 if error. */
+/* Partial build of SCSI "data-in" buffer. Returns 0 if ok else
+ * (DID_ERROR << 16). Can write to offset in data-in buffer. If multiple
+ * calls, not required to write in ascending offset order. Assumes resid
+ * set to scsi_bufflen() prior to any calls.
+ */
+static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
+				  int arr_len, unsigned int off_dst)
+{
+	int act_len, n;
+	struct scsi_data_buffer *sdb = scsi_in(scp);
+	off_t skip = off_dst;
+
+	if (sdb->length <= off_dst)
+		return 0;
+	if (!(scsi_bidi_cmnd(scp) || scp->sc_data_direction == DMA_FROM_DEVICE))
+		return DID_ERROR << 16;
+
+	act_len = sg_pcopy_from_buffer(sdb->table.sgl, sdb->table.nents,
+				       arr, arr_len, skip);
+	pr_debug("%s: off_dst=%u, scsi_bufflen=%u, act_len=%u, resid=%d\n",
+		 __func__, off_dst, scsi_bufflen(scp), act_len, sdb->resid);
+	n = (int)scsi_bufflen(scp) - ((int)off_dst + act_len);
+	sdb->resid = min(sdb->resid, n);
+	return 0;
+}
+
+/* Fetches from SCSI "data-out" buffer. Returns number of bytes fetched into
+ * 'arr' or -1 if error.
+ */
 static int fetch_to_dev_buffer(struct scsi_cmnd *scp, unsigned char *arr,
 			       int arr_len)
 {
@@ -3269,6 +3297,8 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 	return fill_from_dev_buffer(scp, arr, SDEBUG_GET_LBA_STATUS_LEN);
 }
 
+#define RL_BUCKET_ELEMS 8
+
 /* Even though each pseudo target has a REPORT LUNS "well known logical unit"
  * (W-LUN), the normal Linux scanning logic does not associate it with a
  * device (e.g. /dev/sg7). The following magic will make that association:
@@ -3285,12 +3315,14 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 	unsigned char select_report;
 	u64 lun;
 	struct scsi_lun *lun_p;
-	u8 *arr;
+	u8 arr[RL_BUCKET_ELEMS * sizeof(struct scsi_lun)];
 	unsigned int lun_cnt;	/* normal LUN count (max: 256) */
 	unsigned int wlun_cnt;	/* report luns W-LUN count */
 	unsigned int tlun_cnt;	/* total LUN count */
 	unsigned int rlen;	/* response length (in bytes) */
-	int i, res;
+	int k, j, n, res;
+	unsigned int off_rsp = 0;
+	const int sz_lun = sizeof(struct scsi_lun);
 
 	clear_luns_changed_on_target(devip);
 
@@ -3329,33 +3361,40 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 		--lun_cnt;
 
 	tlun_cnt = lun_cnt + wlun_cnt;
-
-	rlen = (tlun_cnt * sizeof(struct scsi_lun)) + 8;
-	arr = vmalloc(rlen);
-	if (!arr) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
-				INSUFF_RES_ASCQ);
-		return check_condition_result;
-	}
-	memset(arr, 0, rlen);
+	rlen = tlun_cnt * sz_lun;	/* excluding 8 byte header */
+	scsi_set_resid(scp, scsi_bufflen(scp));
 	pr_debug("select_report %d luns = %d wluns = %d no_lun0 %d\n",
 		 select_report, lun_cnt, wlun_cnt, sdebug_no_lun_0);
 
-	/* luns start at byte 8 in response following the header */
-	lun_p = (struct scsi_lun *)&arr[8];
-
-	/* LUNs use single level peripheral device addressing method */
+	/* loops rely on sizeof response header same as sizeof lun (both 8) */
 	lun = sdebug_no_lun_0 ? 1 : 0;
-	for (i = 0; i < lun_cnt; i++)
-		int_to_scsilun(lun++, lun_p++);
-
-	if (wlun_cnt)
-		int_to_scsilun(SCSI_W_LUN_REPORT_LUNS, lun_p++);
-
-	put_unaligned_be32(rlen - 8, &arr[0]);
-
-	res = fill_from_dev_buffer(scp, arr, rlen);
-	vfree(arr);
+	for (k = 0, j = 0, res = 0; true; ++k, j = 0) {
+		memset(arr, 0, sizeof(arr));
+		lun_p = (struct scsi_lun *)&arr[0];
+		if (k == 0) {
+			put_unaligned_be32(rlen, &arr[0]);
+			++lun_p;
+			j = 1;
+		}
+		for ( ; j < RL_BUCKET_ELEMS; ++j, ++lun_p) {
+			if ((k * RL_BUCKET_ELEMS) + j > lun_cnt)
+				break;
+			int_to_scsilun(lun++, lun_p);
+		}
+		if (j < RL_BUCKET_ELEMS)
+			break;
+		n = j * sz_lun;
+		res = p_fill_from_dev_buffer(scp, arr, n, off_rsp);
+		if (res)
+			return res;
+		off_rsp += n;
+	}
+	if (wlun_cnt) {
+		int_to_scsilun(SCSI_W_LUN_REPORT_LUNS, lun_p);
+		++j;
+	}
+	if (j > 0)
+		res = p_fill_from_dev_buffer(scp, arr, j * sz_lun, off_rsp);
 	return res;
 }
 
-- 
2.7.4

