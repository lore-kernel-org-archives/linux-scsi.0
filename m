Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A483CC35DF8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C8A32176D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgBYGYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:24:10 -0500
Received: from smtp.infotech.no ([82.134.31.41]:36112 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729070AbgBYGYI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 01:24:08 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 89E3A20426F;
        Tue, 25 Feb 2020 07:24:06 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TeoYP1SAVKjz; Tue, 25 Feb 2020 07:24:04 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id C78B52041E3;
        Tue, 25 Feb 2020 07:24:00 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v4 04/14] scsi_debug: weaken rwlock around ramdisk access
Date:   Tue, 25 Feb 2020 01:23:41 -0500
Message-Id: <20200225062351.21267-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225062351.21267-1-dgilbert@interlog.com>
References: <20200225062351.21267-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The design of this driver is to do any ramdisk access on the
same thread that invoked the queuecommand() call. That is
assumed to be user space context. The command
duration is implemented by setting the delay with a high
resolution timer. The hr timer's callback may well be in
interrupt context, but it doesn't touch the ramdisk. So try
removing the _irqsave()/_irqrestore() portion on the read-
write lock that protects ramdisk access.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 59 +++++++++++++++------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0cd27eca263a..c6b0a7d021cd 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2716,7 +2716,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 num;
 	u32 ei_lba;
 	int acc_num = scp2acc_num(scp);
-	unsigned long iflags;
 	u64 lba;
 	int ret;
 	bool check_prot;
@@ -2801,22 +2800,21 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	read_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	read_lock(ramdisk_lck_a[acc_num % 2]);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2],
-					       iflags);
+			read_unlock(ramdisk_lck_a[acc_num % 2]);
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
 	ret = do_device_access(scp, 0, lba, num, false);
-	read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	read_unlock(ramdisk_lck_a[acc_num % 2]);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -3023,7 +3021,6 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 ei_lba;
 	int acc_num = scp2acc_num(scp);
 	int ret;
-	unsigned long iflags;
 	u64 lba;
 	u8 *cmd = scp->cmnd;
 
@@ -3081,15 +3078,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2],
-						iflags);
+			write_unlock(ramdisk_lck_a[acc_num % 2]);
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
@@ -3098,7 +3094,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(lba, num);
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3146,7 +3142,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u32 ei_lba;
 	int acc_num = scp2acc_num(scp);
 	u64 lba;
-	unsigned long iflags;
 	int ret, res;
 	bool is_16;
 	static const u32 lrd_size = 32; /* + parameter list header size */
@@ -3208,7 +3203,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3291,7 +3286,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3300,7 +3295,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
-	unsigned long iflags;
 	unsigned long long i;
 	u64 block, lbaa;
 	u32 lb_size = sdebug_sector_size;
@@ -3313,7 +3307,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (ret)
 		return ret;
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(lba, num, acc_num);
@@ -3331,7 +3325,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+		write_unlock(ramdisk_lck_a[acc_num % 2]);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3347,7 +3341,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 out:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 
 	return 0;
 }
@@ -3463,7 +3457,6 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
 	u8 num;
-	unsigned long iflags;
 	int ret;
 	int retval = 0;
 	int acc_num = scp2acc_num(scp);
@@ -3493,7 +3486,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	ret = do_dout_fetch(scp, dnum, arr);
 	if (ret == -1) {
@@ -3511,7 +3504,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 cleanup:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 	kfree(arr);
 	return retval;
 }
@@ -3529,8 +3522,6 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned int i, payload_len, descriptors;
 	int ret;
 	int acc_num = scp2acc_num(scp);
-	unsigned long iflags;
-
 
 	if (!scsi_debug_lbp())
 		return 0;	/* fib and say its done */
@@ -3557,7 +3548,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -3573,7 +3564,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 	kfree(buf);
 
 	return ret;
@@ -3756,7 +3747,6 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int acc_num = scp2acc_num(scp);
 	u32 vnum, a_num, off;
 	const u32 lb_size = sdebug_sector_size;
-	unsigned long iflags;
 	u64 lba;
 	u8 *arr;
 	u8 *cmd = scp->cmnd;
@@ -3796,7 +3786,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	read_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	read_lock(ramdisk_lck_a[acc_num % 2]);
 
 	ret = do_dout_fetch(scp, a_num, arr);
 	if (ret == -1) {
@@ -3818,7 +3808,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	read_unlock(ramdisk_lck_a[acc_num % 2]);
 	kfree(arr);
 	return ret;
 }
@@ -4467,9 +4457,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 
 	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
 	if (cmnd->result & SDEG_RES_IMMED_MASK) {
-		/*
-		 * This is the F_DELAY_OVERR case. No delay.
-		 */
 		cmnd->result &= ~SDEG_RES_IMMED_MASK;
 		delta_jiff = ndelay = 0;
 	}
@@ -4996,16 +4983,14 @@ static ssize_t doublestore_store(struct device_driver *ddp, const char *buf,
 	int n;
 
 	if (count > 0 && kstrtoint(buf, 10, &n) == 0 && n >= 0) {
-		unsigned long iflags;
-
 		if (sdebug_doublestore == (n > 0))
 			return count;	/* no state change */
 		if (n <= 0) {
-			write_lock_irqsave(ramdisk_lck_a[1], iflags);
+			write_lock(ramdisk_lck_a[1]);
 			sdebug_doublestore = false;
 			vfree(fake_store_a[1]);
 			fake_store_a[1] = NULL;
-			write_unlock_irqrestore(ramdisk_lck_a[1], iflags);
+			write_unlock(ramdisk_lck_a[1]);
 		} else {
 			unsigned long sz = (unsigned long)sdebug_dev_size_mb *
 					   1048576;
@@ -5015,10 +5000,10 @@ static ssize_t doublestore_store(struct device_driver *ddp, const char *buf,
 				return -ENOMEM;
 			if (sdebug_num_parts > 0)
 				sdebug_build_parts(fsp, sz);
-			write_lock_irqsave(ramdisk_lck_a[1], iflags);
+			write_lock(ramdisk_lck_a[1]);
 			fake_store_a[1] = fsp;
 			sdebug_doublestore = true;
-			write_unlock_irqrestore(ramdisk_lck_a[1], iflags);
+			write_unlock(ramdisk_lck_a[1]);
 		}
 		return count;
 	}
@@ -5954,7 +5939,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
 
 fini:
-	if (F_DELAY_OVERR & flags)
+	if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
 		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
 	else if ((flags & F_LONG_DELAY) && (sdebug_jdelay > 0 ||
 					    sdebug_ndelay > 10000)) {
-- 
2.25.1

