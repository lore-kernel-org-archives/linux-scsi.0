From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 1/3] scsi_debug: scsi_cmnd->cmnd check and casts unnecessary
Date: Tue, 05 Aug 2014 12:20:02 +0200
Message-ID: <53E0AFD2.3050202@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020505070505010902010505"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32791 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590AbaHEKUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 06:20:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Dan Carpenter <dan.carpenter@oracle.com>

This is a multi-part message in MIME format.
--------------020505070505010902010505
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

This patch removes a NULL check for the scsi_cmnd::cmnd pointer
since many other instances in this driver and elsewhere assume
it is valid. Also redundant casts to 'unsigned char *' are removed
as the pointer has that type.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>



--------------020505070505010902010505
Content-Type: text/x-patch;
 name="0001-scsi_cmnd-cmnd-check-and-casts-unnecessary.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-scsi_cmnd-cmnd-check-and-casts-unnecessary.patch"

---
 drivers/scsi/scsi_debug.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d19c0e3..07d224a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -929,7 +929,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, int target,
 {
 	unsigned char pq_pdt;
 	unsigned char * arr;
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 	int alloc_len, n, ret;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
@@ -1075,7 +1075,7 @@ static int resp_requests(struct scsi_cmnd * scp,
 			 struct sdebug_dev_info * devip)
 {
 	unsigned char * sbuff;
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SCSI_SENSE_BUFFERSIZE];
 	int want_dsense;
 	int len = 18;
@@ -1115,7 +1115,7 @@ static int resp_requests(struct scsi_cmnd * scp,
 static int resp_start_stop(struct scsi_cmnd * scp,
 			   struct sdebug_dev_info * devip)
 {
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 	int power_cond, errsts, start;
 
 	errsts = check_readiness(scp, UAS_ONLY, devip);
@@ -1177,7 +1177,7 @@ static int resp_readcap(struct scsi_cmnd * scp,
 static int resp_readcap16(struct scsi_cmnd * scp,
 			  struct sdebug_dev_info * devip)
 {
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 	unsigned char arr[SDEBUG_READCAP16_ARR_SZ];
 	unsigned long long capac;
 	int errsts, k, alloc_len;
@@ -1222,7 +1222,7 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 static int resp_report_tgtpgs(struct scsi_cmnd * scp,
 			      struct sdebug_dev_info * devip)
 {
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 	unsigned char * arr;
 	int host_no = devip->sdbg_host->shost->host_no;
 	int n, ret, alen, rlen;
@@ -1468,7 +1468,7 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 	int k, alloc_len, msense_6, offset, len, errsts, target_dev_id;
 	unsigned char * ap;
 	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 
 	errsts = check_readiness(scp, UAS_ONLY, devip);
 	if (errsts)
@@ -1630,7 +1630,7 @@ static int resp_mode_select(struct scsi_cmnd * scp, int mselect6,
 	int pf, sp, ps, md_len, bd_len, off, spf, pg_len;
 	int param_len, res, errsts, mpage;
 	unsigned char arr[SDEBUG_MAX_MSELECT_SZ];
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 
 	errsts = check_readiness(scp, UAS_ONLY, devip);
 	if (errsts)
@@ -1739,7 +1739,7 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 {
 	int ppc, sp, pcontrol, pcode, subpcode, alloc_len, errsts, len, n;
 	unsigned char arr[SDEBUG_MAX_LSENSE_SZ];
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 
 	errsts = check_readiness(scp, UAS_ONLY, devip);
 	if (errsts)
@@ -2414,7 +2414,7 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 	unsigned int alloc_len;
 	int lun_cnt, i, upper, num, n;
 	u64 wlun, lun;
-	unsigned char *cmd = (unsigned char *)scp->cmnd;
+	unsigned char *cmd = scp->cmnd;
 	int select_report = (int)cmd[2];
 	struct scsi_lun *one_lun;
 	unsigned char arr[SDEBUG_RLUN_ARR_SZ];
@@ -4085,7 +4085,7 @@ static void sdebug_remove_adapter(void)
 static int
 scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
 {
-	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
+	unsigned char *cmd = SCpnt->cmnd;
 	int len, k;
 	unsigned int num;
 	unsigned long long lba;
@@ -4103,7 +4103,7 @@ scsi_debug_queuecommand(struct scsi_cmnd *SCpnt)
 
 	scsi_set_resid(SCpnt, 0);
 	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) &&
-	    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts) && cmd) {
+	    !(SCSI_DEBUG_OPT_NO_CDB_NOISE & scsi_debug_opts)) {
 		char b[120];
 		int n;
 
-- 
1.9.1



--------------020505070505010902010505--
