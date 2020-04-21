Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BD9C54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 238472068F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgDUPOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:14:45 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41960 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgDUPOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 11:14:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DAE09204172;
        Tue, 21 Apr 2020 17:14:41 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id m8gT-P-M8cDW; Tue, 21 Apr 2020 17:14:39 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 8ADAA20416A;
        Tue, 21 Apr 2020 17:14:35 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v5 4/8] scsi_debug: weaken rwlock around ramdisk access
Date:   Tue, 21 Apr 2020 11:14:20 -0400
Message-Id: <20200421151424.32668-5-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421151424.32668-1-dgilbert@interlog.com>
References: <20200421151424.32668-1-dgilbert@interlog.com>
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
 drivers/scsi/scsi_debug.c | 47 +++++++++++++++------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cc6375a3c2ad..268f96c3a6b5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2740,7 +2740,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 num;
 	u32 ei_lba;
 	int ret;
-	unsigned long iflags;
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
@@ -2827,21 +2826,21 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	read_lock_irqsave(macc_lckp, iflags);
+	read_lock(macc_lckp);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			read_unlock_irqrestore(macc_lckp, iflags);
+			read_unlock(macc_lckp);
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
 	ret = do_device_access(sip, scp, 0, lba, num, false);
-	read_unlock_irqrestore(macc_lckp, iflags);
+	read_unlock(macc_lckp);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -3050,7 +3049,6 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u32 num;
 	u32 ei_lba;
 	int ret;
-	unsigned long iflags;
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip);
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
@@ -3110,14 +3108,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
-	write_lock_irqsave(macc_lckp, iflags);
+	write_lock(macc_lckp);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			write_unlock_irqrestore(macc_lckp, iflags);
+			write_unlock(macc_lckp);
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
@@ -3126,7 +3124,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(sip, scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
-	write_unlock_irqrestore(macc_lckp, iflags);
+	write_unlock(macc_lckp);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3175,7 +3173,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
 	u64 lba;
-	unsigned long iflags;
 	int ret, res;
 	bool is_16;
 	static const u32 lrd_size = 32; /* + parameter list header size */
@@ -3237,7 +3234,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock_irqsave(macc_lckp, iflags);
+	write_lock(macc_lckp);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3320,7 +3317,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock_irqrestore(macc_lckp, iflags);
+	write_unlock(macc_lckp);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3329,7 +3326,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
-	unsigned long iflags;
 	unsigned long long i;
 	u64 block, lbaa;
 	u32 lb_size = sdebug_sector_size;
@@ -3344,7 +3340,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (ret)
 		return ret;
 
-	write_lock_irqsave(macc_lckp, iflags);
+	write_lock(macc_lckp);
 
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(sip, lba, num);
@@ -3362,7 +3358,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock_irqrestore(&sip->macc_lck, iflags);
+		write_unlock(&sip->macc_lck);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3378,7 +3374,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 out:
-	write_unlock_irqrestore(macc_lckp, iflags);
+	write_unlock(macc_lckp);
 
 	return 0;
 }
@@ -3496,7 +3492,6 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
 	u8 num;
-	unsigned long iflags;
 	int ret;
 	int retval = 0;
 
@@ -3525,7 +3520,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock_irqsave(macc_lckp, iflags);
+	write_lock(macc_lckp);
 
 	ret = do_dout_fetch(scp, dnum, arr);
 	if (ret == -1) {
@@ -3543,7 +3538,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup:
-	write_unlock_irqrestore(macc_lckp, iflags);
+	write_unlock(macc_lckp);
 	kfree(arr);
 	return retval;
 }
@@ -3562,8 +3557,6 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	unsigned int i, payload_len, descriptors;
 	int ret;
-	unsigned long iflags;
-
 
 	if (!scsi_debug_lbp())
 		return 0;	/* fib and say its done */
@@ -3590,7 +3583,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock_irqsave(macc_lckp, iflags);
+	write_lock(macc_lckp);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -3606,7 +3599,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	write_unlock_irqrestore(macc_lckp, iflags);
+	write_unlock(macc_lckp);
 	kfree(buf);
 
 	return ret;
@@ -3789,7 +3782,6 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int ret, j;
 	u32 vnum, a_num, off;
 	const u32 lb_size = sdebug_sector_size;
-	unsigned long iflags;
 	u64 lba;
 	u8 *arr;
 	u8 *cmd = scp->cmnd;
@@ -3831,7 +3823,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	read_lock_irqsave(macc_lckp, iflags);
+	read_lock(macc_lckp);
 
 	ret = do_dout_fetch(scp, a_num, arr);
 	if (ret == -1) {
@@ -3853,7 +3845,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	read_unlock_irqrestore(macc_lckp, iflags);
+	read_unlock(macc_lckp);
 	kfree(arr);
 	return ret;
 }
@@ -4501,9 +4493,6 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 
 	cmnd->result = pfp != NULL ? pfp(cmnd, devip) : 0;
 	if (cmnd->result & SDEG_RES_IMMED_MASK) {
-		/*
-		 * This is the F_DELAY_OVERR case. No delay.
-		 */
 		cmnd->result &= ~SDEG_RES_IMMED_MASK;
 		delta_jiff = ndelay = 0;
 	}
@@ -6128,7 +6117,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		pfp = r_pfp;    /* if leaf function ptr NULL, try the root's */
 
 fini:
-	if (F_DELAY_OVERR & flags)
+	if (F_DELAY_OVERR & flags)	/* cmds like INQUIRY respond asap */
 		return schedule_resp(scp, devip, errsts, pfp, 0, 0);
 	else if ((flags & F_LONG_DELAY) && (sdebug_jdelay > 0 ||
 					    sdebug_ndelay > 10000)) {
-- 
2.26.1

