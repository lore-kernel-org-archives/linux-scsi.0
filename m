From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/5] scsi_debug: remove the duplicated code in resp_read and resp_write
Date: Sun, 30 Mar 2008 00:59:56 +0900
Message-ID: <1206806398-22205-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35458 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbYC2QAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 12:00:54 -0400
In-Reply-To: <1206806398-22205-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

resp_read and resp_write performs READ_* and WRITE_* commands
respectively. This sweeps up the similar code in them.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |  116 +++++++++++++++++++-------------------------
 1 files changed, 50 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 70bcee6..c98559e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1468,25 +1468,53 @@ static int resp_log_sense(struct scsi_cmnd * scp,
 		    min(len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
-static int resp_read(struct scsi_cmnd * SCpnt, unsigned long long lba,
-		     unsigned int num, struct sdebug_dev_info * devip)
+static int check_device_access_params(struct sdebug_dev_info *devi,
+				      unsigned long long lba, unsigned int num)
 {
-	unsigned long iflags;
-	unsigned int block, from_bottom;
-	unsigned long long u;
-	int ret;
-
 	if (lba + num > sdebug_capacity) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE,
-				0);
+		mk_sense_buffer(devi, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE, 0);
 		return check_condition_result;
 	}
 	/* transfer length excessive (tie in to block limits VPD page) */
 	if (num > sdebug_store_sectors) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-				0);
+		mk_sense_buffer(devi, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
+	return 0;
+}
+
+static int do_device_access(struct scsi_cmnd *scmd,
+			    struct sdebug_dev_info *devi,
+			    unsigned long long lba, unsigned int num, int write)
+{
+	int ret;
+	unsigned int block, rest = 0;
+	int (*func)(struct scsi_cmnd *, unsigned char *, int);
+
+	func = write ? fetch_to_dev_buffer : fill_from_dev_buffer;
+
+	block = do_div(lba, sdebug_store_sectors);
+	if (block + num > sdebug_store_sectors)
+		rest = block + num - sdebug_store_sectors;
+
+	ret = func(scmd, fake_storep + (block * SECT_SIZE),
+		   (num - rest) * SECT_SIZE);
+	if (!ret && rest)
+		ret = func(scmd, fake_storep, rest * SECT_SIZE);
+
+	return ret;
+}
+
+static int resp_read(struct scsi_cmnd *SCpnt, unsigned long long lba,
+		     unsigned int num, struct sdebug_dev_info *devip)
+{
+	unsigned long iflags;
+	int ret;
+
+	ret = check_device_access_params(devip, lba, num);
+	if (ret)
+		return ret;
+
 	if ((SCSI_DEBUG_OPT_MEDIUM_ERR & scsi_debug_opts) &&
 	    (lba <= OPT_MEDIUM_ERR_ADDR) &&
 	    ((lba + num) > OPT_MEDIUM_ERR_ADDR)) {
@@ -1505,74 +1533,30 @@ static int resp_read(struct scsi_cmnd * SCpnt, unsigned long long lba,
 		return check_condition_result;
 	}
 	read_lock_irqsave(&atomic_rw, iflags);
-	if ((lba + num) <= sdebug_store_sectors)
-		ret = fill_from_dev_buffer(SCpnt,
-					   fake_storep + (lba * SECT_SIZE),
-			   		   num * SECT_SIZE);
-	else {
-		/* modulo when one arg is 64 bits needs do_div() */
-		u = lba;
-		block = do_div(u, sdebug_store_sectors);
-		from_bottom = 0;
-		if ((block + num) > sdebug_store_sectors)
-			from_bottom = (block + num) - sdebug_store_sectors;
-		ret = fill_from_dev_buffer(SCpnt,
-					   fake_storep + (block * SECT_SIZE),
-			   		   (num - from_bottom) * SECT_SIZE);
-		if ((0 == ret) && (from_bottom > 0))
-			ret = fill_from_dev_buffer(SCpnt, fake_storep,
-						   from_bottom * SECT_SIZE);
-	}
+	ret = do_device_access(SCpnt, devip, lba, num, 0);
 	read_unlock_irqrestore(&atomic_rw, iflags);
 	return ret;
 }
 
-static int resp_write(struct scsi_cmnd * SCpnt, unsigned long long lba,
-		      unsigned int num, struct sdebug_dev_info * devip)
+static int resp_write(struct scsi_cmnd *SCpnt, unsigned long long lba,
+		      unsigned int num, struct sdebug_dev_info *devip)
 {
 	unsigned long iflags;
-	unsigned int block, to_bottom;
-	unsigned long long u;
-	int res;
+	int ret;
 
-	if (lba + num > sdebug_capacity) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, ADDR_OUT_OF_RANGE,
-			       	0);
-		return check_condition_result;
-	}
-	/* transfer length excessive (tie in to block limits VPD page) */
-	if (num > sdebug_store_sectors) {
-		mk_sense_buffer(devip, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB,
-				0);
-		return check_condition_result;
-	}
+	ret = check_device_access_params(devip, lba, num);
+	if (ret)
+		return ret;
 
 	write_lock_irqsave(&atomic_rw, iflags);
-	if ((lba + num) <= sdebug_store_sectors)
-		res = fetch_to_dev_buffer(SCpnt,
-					  fake_storep + (lba * SECT_SIZE),
-			   		  num * SECT_SIZE);
-	else {
-		/* modulo when one arg is 64 bits needs do_div() */
-		u = lba;
-		block = do_div(u, sdebug_store_sectors);
-		to_bottom = 0;
-		if ((block + num) > sdebug_store_sectors)
-			to_bottom = (block + num) - sdebug_store_sectors;
-		res = fetch_to_dev_buffer(SCpnt,
-					  fake_storep + (block * SECT_SIZE),
-			   		  (num - to_bottom) * SECT_SIZE);
-		if ((0 == res) && (to_bottom > 0))
-			res = fetch_to_dev_buffer(SCpnt, fake_storep,
-						  to_bottom * SECT_SIZE);
-	}
+	ret = do_device_access(SCpnt, devip, lba, num, 1);
 	write_unlock_irqrestore(&atomic_rw, iflags);
-	if (-1 == res)
+	if (-1 == ret)
 		return (DID_ERROR << 16);
-	else if ((res < (num * SECT_SIZE)) &&
+	else if ((ret < (num * SECT_SIZE)) &&
 		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
 		printk(KERN_INFO "scsi_debug: write: cdb indicated=%u, "
-		       " IO sent=%d bytes\n", num * SECT_SIZE, res);
+		       " IO sent=%d bytes\n", num * SECT_SIZE, ret);
 	return 0;
 }
 
-- 
1.5.3.7

