From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: fix compare and write errors
Date: Wed, 26 Nov 2014 12:45:13 -0500
Message-ID: <547611A9.2040208@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090105050106070509000004"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:40145 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaKZRpe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2014 12:45:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>

This is a multi-part message in MIME format.
--------------090105050106070509000004
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Wed, 26 Nov 2014 12:33:48 -0500
Subject: [PATCH] scsi_debug fix compare and write errors

Kernel build tools pointed out a memory leak so that has been
fixed and its error paths strengthened with a goto. Testing
showed compare and write was only working for lba=0; correcting
the length of the LBA field fixed that.
---
  drivers/scsi/scsi_debug.c | 31 ++++++++++++++++---------------
  1 file changed, 16 insertions(+), 15 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------090105050106070509000004
Content-Type: text/x-patch;
 name="0001-scsi_debug-fix-compare-and-write-errors.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-scsi_debug-fix-compare-and-write-errors.patch"

>From 699d7b799ebbc0e1b5bc905ccfd50dc77003a9e8 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Wed, 26 Nov 2014 12:33:48 -0500
Subject: [PATCH] scsi_debug fix compare and write errors

Kernel build tools pointed out a memory leak so that has been
fixed and its error paths strengthened with a goto. Testing
showed compare and write was only working for lba=0; correcting
the length of the LBA field fixed that.
---
 drivers/scsi/scsi_debug.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aa4b6b8..747c691 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3045,18 +3045,12 @@ resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 num;
 	unsigned long iflags;
 	int ret;
+	int retval = 0;
 
-	lba = get_unaligned_be32(cmd + 2);
+	lba = get_unaligned_be64(cmd + 2);
 	num = cmd[13];		/* 1 to a maximum of 255 logical blocks */
 	if (0 == num)
 		return 0;	/* degenerate case, not an error */
-	dnum = 2 * num;
-	arr = kzalloc(dnum * lb_size, GFP_ATOMIC);
-	if (NULL == arr) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
-				INSUFF_RES_ASCQ);
-		return check_condition_result;
-	}
 	if (scsi_debug_dif == SD_DIF_TYPE2_PROTECTION &&
 	    (cmd[1] & 0xe0)) {
 		mk_sense_invalid_opcode(scp);
@@ -3079,6 +3073,13 @@ resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
 		return check_condition_result;
 	}
+	dnum = 2 * num;
+	arr = kzalloc(dnum * lb_size, GFP_ATOMIC);
+	if (NULL == arr) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
 
 	write_lock_irqsave(&atomic_rw, iflags);
 
@@ -3089,24 +3090,24 @@ resp_comp_write(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(scp, 0, dnum, true);
 	fake_storep = fake_storep_hold;
 	if (ret == -1) {
-		write_unlock_irqrestore(&atomic_rw, iflags);
-		kfree(arr);
-		return DID_ERROR << 16;
+		retval = DID_ERROR << 16;
+		goto cleanup;
 	} else if ((ret < (dnum * lb_size)) &&
 		 (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts))
 		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
 	if (!comp_write_worker(lba, num, arr)) {
-		write_unlock_irqrestore(&atomic_rw, iflags);
-		kfree(arr);
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
-		return check_condition_result;
+		retval = check_condition_result;
+		goto cleanup;
 	}
 	if (scsi_debug_lbp())
 		map_region(lba, num);
+cleanup:
 	write_unlock_irqrestore(&atomic_rw, iflags);
-	return 0;
+	kfree(arr);
+	return retval;
 }
 
 struct unmap_block_desc {
-- 
1.9.1


--------------090105050106070509000004--
