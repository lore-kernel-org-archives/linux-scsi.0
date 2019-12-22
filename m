Return-Path: <SRS0=BSUp=2M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79720C2D0D4
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46808206D3
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfLVEAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Dec 2019 23:00:02 -0500
Received: from smtp.infotech.no ([82.134.31.41]:39904 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbfLVEAC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Dec 2019 23:00:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D218C204195;
        Sun, 22 Dec 2019 04:59:59 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cNbpgjyveH4q; Sun, 22 Dec 2019 04:59:57 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 96067204191;
        Sun, 22 Dec 2019 04:59:55 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC 4/6] scsi_debug: weaken rwlock around ramdisk access
Date:   Sat, 21 Dec 2019 22:59:46 -0500
Message-Id: <20191222035948.30447-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191222035948.30447-1-dgilbert@interlog.com>
References: <20191222035948.30447-1-dgilbert@interlog.com>
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
index 5d9dc9bdd1a7..a3cb0bc29f81 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2703,7 +2703,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 num;
 	u32 ei_lba;
 	int acc_num = scp2acc_num(scp);
-	unsigned long iflags;
 	u64 lba;
 	int ret;
 	bool check_prot;
@@ -2788,22 +2787,21 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
 
@@ -3010,7 +3008,6 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 ei_lba;
 	int acc_num = scp2acc_num(scp);
 	int ret;
-	unsigned long iflags;
 	u64 lba;
 	u8 *cmd = scp->cmnd;
 
@@ -3068,15 +3065,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -3085,7 +3081,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(lba, num);
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3133,7 +3129,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u32 ei_lba;
 	int acc_num = scp2acc_num(scp);
 	u64 lba;
-	unsigned long iflags;
 	int ret, res;
 	bool is_16;
 	static const u32 lrd_size = 32; /* + parameter list header size */
@@ -3195,7 +3190,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3278,7 +3273,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3287,7 +3282,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
-	unsigned long iflags;
 	unsigned long long i;
 	u64 block, lbaa;
 	u32 lb_size = sdebug_sector_size;
@@ -3300,7 +3294,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (ret)
 		return ret;
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(lba, num, acc_num);
@@ -3318,7 +3312,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+		write_unlock(ramdisk_lck_a[acc_num % 2]);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3334,7 +3328,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 out:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 
 	return 0;
 }
@@ -3452,7 +3446,6 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
 	u8 num;
-	unsigned long iflags;
 	int ret;
 	int retval = 0;
 	int acc_num = scp2acc_num(scp);
@@ -3482,7 +3475,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	/*
 	 * Trick do_device_access() to fetch both compare and write buffers
@@ -3508,7 +3501,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 cleanup:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 	kfree(arr);
 	return retval;
 }
@@ -3526,8 +3519,6 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned int i, payload_len, descriptors;
 	int ret;
 	int acc_num = scp2acc_num(scp);
-	unsigned long iflags;
-
 
 	if (!scsi_debug_lbp())
 		return 0;	/* fib and say its done */
@@ -3554,7 +3545,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	write_lock(ramdisk_lck_a[acc_num % 2]);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -3570,7 +3561,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	write_unlock(ramdisk_lck_a[acc_num % 2]);
 	kfree(buf);
 
 	return ret;
@@ -3753,7 +3744,6 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int acc_num = scp2acc_num(scp);
 	u32 vnum, a_num, off;
 	const u32 lb_size = sdebug_sector_size;
-	unsigned long iflags;
 	u64 lba;
 	u8 *arr;
 	u8 **fspp;
@@ -3795,7 +3785,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	read_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+	read_lock(ramdisk_lck_a[acc_num % 2]);
 
 	/* trick do_device_access() to fetch data-out into arr. */
 	fspp = &fake_store_a[acc_num % 2];
@@ -3822,7 +3812,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	read_unlock(ramdisk_lck_a[acc_num % 2]);
 	kfree(arr);
 	return ret;
 }
@@ -4471,9 +4461,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 
 	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
 	if (cmnd->result & SDEG_RES_IMMED_MASK) {
-		/*
-		 * This is the F_DELAY_OVERR case. No delay.
-		 */
 		cmnd->result &= ~SDEG_RES_IMMED_MASK;
 		delta_jiff = ndelay = 0;
 	}
@@ -4998,16 +4985,14 @@ static ssize_t doublestore_store(struct device_driver *ddp, const char *buf,
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
@@ -5017,10 +5002,10 @@ static ssize_t doublestore_store(struct device_driver *ddp, const char *buf,
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
@@ -5953,7 +5938,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
 
 fini:
-	if (F_DELAY_OVERR & flags)
+	if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
 		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
 	else if ((flags & F_LONG_DELAY) && (sdebug_jdelay > 0 ||
 					    sdebug_ndelay > 10000)) {
-- 
2.24.1

