Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F51C433EF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jan 2022 01:29:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbiAIB3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Jan 2022 20:29:08 -0500
Received: from smtp.infotech.no ([82.134.31.41]:37828 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233631AbiAIB3G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Jan 2022 20:29:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 522B12041C0;
        Sun,  9 Jan 2022 02:29:05 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tJSwJW9ZS81u; Sun,  9 Jan 2022 02:29:05 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 01B0D20413E;
        Sun,  9 Jan 2022 02:29:03 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v2 6/9] scsi_debug: add no_rwlock parameter
Date:   Sat,  8 Jan 2022 20:28:50 -0500
Message-Id: <20220109012853.301953-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220109012853.301953-1-dgilbert@interlog.com>
References: <20220109012853.301953-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By default, this driver places a read lock around all user data
fetches and a write lock around all user data modifying operations
(e.g. WRITE commands). These locks have "per store" granularity.
Other drivers that have a similar function (e.g. null_blk) do not
take this data integrity step and run significantly faster in
some tests.

In the common case of a (simulated) device to device copy (e.g.
what dd and its variants do) there should be no need for locks
around data accesses. So add the driver and sysfs parameter
no_rwlock which is boolean and when set does what its name
suggests. The default is false for backward comaptibility.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 152 +++++++++++++++++++++++++-------------
 1 file changed, 102 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 85dd110c2b65..de9059d06cd5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -787,6 +787,7 @@ static bool sdebug_clustering;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
 static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
+static bool sdebug_no_rwlock;
 static bool sdebug_verbose;
 static bool have_dif_prot;
 static bool write_since_sync;
@@ -3130,6 +3131,50 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 	return ret;
 }
 
+static inline void
+sdeb_read_lock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock)
+		return;
+	if (sip)
+		read_lock(&sip->macc_lck);
+	else
+		read_lock(&sdeb_fake_rw_lck);
+}
+
+static inline void
+sdeb_read_unlock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock)
+		return;
+	if (sip)
+		read_unlock(&sip->macc_lck);
+	else
+		read_unlock(&sdeb_fake_rw_lck);
+}
+
+static inline void
+sdeb_write_lock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock)
+		return;
+	if (sip)
+		write_lock(&sip->macc_lck);
+	else
+		write_lock(&sdeb_fake_rw_lck);
+}
+
+static inline void
+sdeb_write_unlock(struct sdeb_store_info *sip)
+{
+	if (sdebug_no_rwlock)
+		return;
+	if (sip)
+		write_unlock(&sip->macc_lck);
+	else
+		write_unlock(&sdeb_fake_rw_lck);
+}
+
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	bool check_prot;
@@ -3138,7 +3183,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int ret;
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	u8 *cmd = scp->cmnd;
 
 	switch (cmd[0]) {
@@ -3217,29 +3261,29 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	read_lock(macc_lckp);
+	sdeb_read_lock(sip);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		switch (prot_verify_read(scp, lba, num, ei_lba)) {
 		case 1: /* Guard tag error */
 			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
-				read_unlock(macc_lckp);
+				sdeb_read_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 				return check_condition_result;
 			} else if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
-				read_unlock(macc_lckp);
+				sdeb_read_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
 				return illegal_condition_result;
 			}
 			break;
 		case 3: /* Reference tag error */
 			if (cmd[1] >> 5 != 3) { /* RDPROTECT != 3 */
-				read_unlock(macc_lckp);
+				sdeb_read_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
 				return check_condition_result;
 			} else if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
-				read_unlock(macc_lckp);
+				sdeb_read_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
 				return illegal_condition_result;
 			}
@@ -3248,7 +3292,7 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 
 	ret = do_device_access(sip, scp, 0, lba, num, false);
-	read_unlock(macc_lckp);
+	sdeb_read_unlock(sip);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -3436,7 +3480,6 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	int ret;
 	u64 lba;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 *cmd = scp->cmnd;
 
 	switch (cmd[0]) {
@@ -3491,10 +3534,10 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				    "to DIF device\n");
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret) {
-		write_unlock(macc_lckp);
+		sdeb_write_unlock(sip);
 		return ret;
 	}
 
@@ -3503,22 +3546,22 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		switch (prot_verify_write(scp, lba, num, ei_lba)) {
 		case 1: /* Guard tag error */
 			if (scp->prot_flags & SCSI_PROT_GUARD_CHECK) {
-				write_unlock(macc_lckp);
+				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
 				return illegal_condition_result;
 			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
-				write_unlock(macc_lckp);
+				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 				return check_condition_result;
 			}
 			break;
 		case 3: /* Reference tag error */
 			if (scp->prot_flags & SCSI_PROT_REF_CHECK) {
-				write_unlock(macc_lckp);
+				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 3);
 				return illegal_condition_result;
 			} else if (scp->cmnd[1] >> 5 != 3) { /* WRPROTECT != 3 */
-				write_unlock(macc_lckp);
+				sdeb_write_unlock(sip);
 				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 3);
 				return check_condition_result;
 			}
@@ -3532,7 +3575,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	/* If ZBC zone then bump its write pointer */
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3572,7 +3615,6 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u8 *lrdp = NULL;
 	u8 *up;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
 	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
@@ -3640,7 +3682,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3722,7 +3764,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3739,15 +3781,14 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	int ret;
 	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
 						scp->device->hostdata, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 *fs1p;
 	u8 *fsp;
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret) {
-		write_unlock(macc_lckp);
+		sdeb_write_unlock(sip);
 		return ret;
 	}
 
@@ -3767,7 +3808,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock(&sip->macc_lck);
+		sdeb_write_unlock(sip);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3786,7 +3827,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (sdebug_dev_is_zoned(devip))
 		zbc_inc_wp(devip, lba, num);
 out:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 
 	return 0;
 }
@@ -3899,7 +3940,6 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u8 *arr;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 	u64 lba;
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
@@ -3932,7 +3972,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	ret = do_dout_fetch(scp, dnum, arr);
 	if (ret == -1) {
@@ -3950,7 +3990,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
 cleanup:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	kfree(arr);
 	return retval;
 }
@@ -3966,7 +4006,6 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	unsigned char *buf;
 	struct unmap_block_desc *desc;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 	unsigned int i, payload_len, descriptors;
 	int ret;
 
@@ -3995,7 +4034,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -4011,7 +4050,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	kfree(buf);
 
 	return ret;
@@ -4103,7 +4142,6 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 	u32 nblks;
 	u8 *cmd = scp->cmnd;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 	u8 *fsp = sip->storep;
 
 	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
@@ -4125,12 +4163,12 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
 		rest = block + nblks - sdebug_store_sectors;
 
 	/* Try to bring the PRE-FETCH range into CPU's cache */
-	read_lock(macc_lckp);
+	sdeb_read_lock(sip);
 	prefetch_range(fsp + (sdebug_sector_size * block),
 		       (nblks - rest) * sdebug_sector_size);
 	if (rest)
 		prefetch_range(fsp, rest * sdebug_sector_size);
-	read_unlock(macc_lckp);
+	sdeb_read_unlock(sip);
 fini:
 	if (cmd[1] & 0x2)
 		res = SDEG_RES_IMMED_MASK;
@@ -4251,7 +4289,6 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *arr;
 	u8 *cmd = scp->cmnd;
 	struct sdeb_store_info *sip = devip2sip(devip, true);
-	rwlock_t *macc_lckp = &sip->macc_lck;
 
 	bytchk = (cmd[1] >> 1) & 0x3;
 	if (bytchk == 0) {
@@ -4290,7 +4327,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	read_lock(macc_lckp);
+	sdeb_read_lock(sip);
 
 	ret = do_dout_fetch(scp, a_num, arr);
 	if (ret == -1) {
@@ -4312,7 +4349,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	read_unlock(macc_lckp);
+	sdeb_read_unlock(sip);
 	kfree(arr);
 	return ret;
 }
@@ -4332,7 +4369,6 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	struct sdeb_zone_state *zsp;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
 		mk_sense_invalid_opcode(scp);
@@ -4361,7 +4397,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	read_lock(macc_lckp);
+	sdeb_read_lock(sip);
 
 	desc = arr + 64;
 	for (i = 0; i < max_zones; i++) {
@@ -4449,7 +4485,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	ret = fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));
 
 fini:
-	read_unlock(macc_lckp);
+	sdeb_read_unlock(sip);
 	kfree(arr);
 	return ret;
 }
@@ -4475,14 +4511,13 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_zone_state *zsp;
 	bool all = cmd[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	if (all) {
 		/* Check if all closed zones can be open */
@@ -4531,7 +4566,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zbc_open_zone(devip, zsp, true);
 fini:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	return res;
 }
 
@@ -4552,14 +4587,13 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 	struct sdeb_zone_state *zsp;
 	bool all = cmd[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	if (all) {
 		zbc_close_all(devip);
@@ -4588,7 +4622,7 @@ static int resp_close_zone(struct scsi_cmnd *scp,
 
 	zbc_close_zone(devip, zsp);
 fini:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	return res;
 }
 
@@ -4625,14 +4659,13 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	bool all = cmd[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	if (all) {
 		zbc_finish_all(devip);
@@ -4661,7 +4694,7 @@ static int resp_finish_zone(struct scsi_cmnd *scp,
 
 	zbc_finish_zone(devip, zsp, true);
 fini:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	return res;
 }
 
@@ -4706,14 +4739,13 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	u8 *cmd = scp->cmnd;
 	bool all = cmd[14] & 0x01;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
-	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 
 	if (!sdebug_dev_is_zoned(devip)) {
 		mk_sense_invalid_opcode(scp);
 		return check_condition_result;
 	}
 
-	write_lock(macc_lckp);
+	sdeb_write_lock(sip);
 
 	if (all) {
 		zbc_rwp_all(devip);
@@ -4741,7 +4773,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	zbc_rwp_zone(devip, zsp);
 fini:
-	write_unlock(macc_lckp);
+	sdeb_write_unlock(sip);
 	return res;
 }
 
@@ -5740,6 +5772,7 @@ module_param_named(medium_error_start, sdebug_medium_error_start, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
+module_param_named(no_rwlock, sdebug_no_rwlock, bool, S_IRUGO | S_IWUSR);
 module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
 module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
@@ -5812,6 +5845,7 @@ MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIU
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
+MODULE_PARM_DESC(no_rwlock, "don't protect user data reads+writes (def=0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
@@ -6374,6 +6408,23 @@ static ssize_t host_max_queue_show(struct device_driver *ddp, char *buf)
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_host_max_queue);
 }
 
+static ssize_t no_rwlock_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_no_rwlock);
+}
+
+static ssize_t no_rwlock_store(struct device_driver *ddp, const char *buf, size_t count)
+{
+	bool v;
+
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	sdebug_no_rwlock = v;
+	return count;
+}
+static DRIVER_ATTR_RW(no_rwlock);
+
 /*
  * Since this is used for .can_queue, and we get the hc_idx tag from the bitmap
  * in range [0, sdebug_host_max_queue), we can't change it.
@@ -6739,6 +6790,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_lun_format.attr,
 	&driver_attr_max_luns.attr,
 	&driver_attr_max_queue.attr,
+	&driver_attr_no_rwlock.attr,
 	&driver_attr_no_uld.attr,
 	&driver_attr_scsi_level.attr,
 	&driver_attr_virtual_gb.attr,
-- 
2.25.1

