Return-Path: <SRS0=BSUp=2M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3AAC2D0C8
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CB22208C3
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLVEAA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Dec 2019 23:00:00 -0500
Received: from smtp.infotech.no ([82.134.31.41]:39885 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbfLVD77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Dec 2019 22:59:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9F96F20419B;
        Sun, 22 Dec 2019 04:59:57 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id f8bcO2YuKpdu; Sun, 22 Dec 2019 04:59:55 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 91FFC204190;
        Sun, 22 Dec 2019 04:59:54 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC 3/6] scsi_debug: implement verify(10), add verify(16)
Date:   Sat, 21 Dec 2019 22:59:45 -0500
Message-Id: <20191222035948.30447-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191222035948.30447-1-dgilbert@interlog.com>
References: <20191222035948.30447-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With the addition of the doublestore option, the ability to check
whether the two different ramdisk images are the same or not
becomes useful. Prior to this patch VERIFY(10) always returned
true (i.e. the SCSI GOOD status) without checking. This option
adds support for BYTCHK equal to 1 and 3 . If the comparison
fails then a sense key of MISCOMPARE is returned as per the
T10 standards. Add support for the VERIFY(16).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 118 ++++++++++++++++++++++++++++++++++----
 1 file changed, 107 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 45934dae8617..5d9dc9bdd1a7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -342,7 +342,7 @@ enum sdeb_opcode_index {
 	SDEB_I_SERV_ACT_OUT_16 = 13,	/* add ...SERV_ACT_OUT_12 if needed */
 	SDEB_I_MAINT_IN = 14,
 	SDEB_I_MAINT_OUT = 15,
-	SDEB_I_VERIFY = 16,		/* 10 only */
+	SDEB_I_VERIFY = 16,		/* VERIFY(10), VERIFY(16) */
 	SDEB_I_VARIABLE_LEN = 17,	/* READ(32), WRITE(32), WR_SCAT(32) */
 	SDEB_I_RESERVE = 18,		/* 6, 10 */
 	SDEB_I_RELEASE = 19,		/* 6, 10 */
@@ -385,7 +385,8 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, SDEB_I_VARIABLE_LEN,
 /* 0x80; 0x80->0x9f: 16 byte cdbs */
 	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
-	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0, 0, 0, 0, 0,
+	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0,
+	0, 0, 0, SDEB_I_VERIFY,
 	0, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
@@ -427,6 +428,7 @@ static int resp_report_tgtpgs(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_unmap(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rsup_opcodes(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_rsup_tmfs(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_verify(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_10(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
@@ -471,6 +473,12 @@ static const struct opcode_info_t write_iarr[] = {
 		   0xbf, 0xc7, 0, 0, 0, 0} },
 };
 
+static const struct opcode_info_t verify_iarr[] = {
+	{0, 0x2f, 0, F_D_OUT_MAYBE | FF_MEDIA_IO, resp_verify,/* VERIFY(10) */
+	    NULL, {10,  0xf7, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xff, 0xff, 0xc7,
+		   0, 0, 0, 0, 0, 0} },
+};
+
 static const struct opcode_info_t sa_in_16_iarr[] = {
 	{0, 0x9e, 0x12, F_SA_LOW | F_D_IN, resp_get_lba_status, NULL,
 	    {16,  0x12, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
@@ -571,9 +579,10 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 /* 15 */
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* MAINT OUT */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
-	{0, 0x2f, 0, F_D_OUT_MAYBE | FF_MEDIA_IO, NULL, NULL, /* VERIFY(10) */
-	    {10,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xc7,
-	     0, 0, 0, 0, 0, 0} },
+	{ARRAY_SIZE(verify_iarr), 0x8f, 0,
+	    F_D_OUT_MAYBE | FF_MEDIA_IO, resp_verify,	/* VERIFY(16) */
+	    verify_iarr, {16,  0xf6, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },
 	{ARRAY_SIZE(vl_iarr), 0x7f, 0x9, F_SA_HIGH | F_D_IN | FF_MEDIA_IO,
 	    resp_read_dt0, vl_iarr,	/* VARIABLE LENGTH, READ(32) */
 	    {32,  0xc7, 0, 0, 0, 0, 0x3f, 0x18, 0x0, 0x9, 0xfe, 0, 0xff, 0xff,
@@ -2543,7 +2552,8 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 /* If lba2fake_store(lba,num) compares equal to arr(num), then copy top half of
  * arr into lba2fake_store(lba,num) and return true. If comparison fails then
  * return false. */
-static bool comp_write_worker(u64 lba, u32 num, const u8 *arr, int acc_num)
+static bool comp_write_worker(u64 lba, u32 num, const u8 *arr, int acc_num,
+			      bool compare_only)
 {
 	bool res;
 	u64 block, rest = 0;
@@ -2565,6 +2575,8 @@ static bool comp_write_worker(u64 lba, u32 num, const u8 *arr, int acc_num)
 			     rest * lb_size);
 	if (!res)
 		return res;
+	if (compare_only)
+		return true;
 	arr += num * lb_size;
 	memcpy(fsp + (block * lb_size), arr, (num - rest) * lb_size);
 	if (rest)
@@ -3472,9 +3484,11 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 
 	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 
-	/* trick do_device_access() to fetch both compare and write buffers
-	 * from data-in into arr. Safe (atomic) since write_lock held. */
-	fspp = &fake_store_a[scp2acc_num(scp) % 2];
+	/*
+	 * Trick do_device_access() to fetch both compare and write buffers
+	 * from data-out into arr. Safe (atomic) since write_lock held.
+	 */
+	fspp = &fake_store_a[acc_num % 2];
 	fsp_hold = *fspp;
 	*fspp = arr;
 	ret = do_device_access(scp, 0, 0, dnum, true);
@@ -3486,7 +3500,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
-	if (!comp_write_worker(lba, num, arr, scp2acc_num(scp))) {
+	if (!comp_write_worker(lba, num, arr, acc_num, false)) {
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
 		retval = check_condition_result;
 		goto cleanup;
@@ -3550,7 +3564,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		if (ret)
 			goto out;
 
-		unmap_region(lba, num, scp2acc_num(scp));
+		unmap_region(lba, num, acc_num);
 	}
 
 	ret = 0;
@@ -3731,6 +3745,88 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 	return res;
 }
 
+static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	bool is_bytchk3 = false;
+	u8 bytchk;
+	int ret, j;
+	int acc_num = scp2acc_num(scp);
+	u32 vnum, a_num, off;
+	const u32 lb_size = sdebug_sector_size;
+	unsigned long iflags;
+	u64 lba;
+	u8 *arr;
+	u8 **fspp;
+	u8 *fsp_hold;
+	u8 *cmd = scp->cmnd;
+
+	bytchk = (cmd[1] >> 1) & 0x3;
+	if (bytchk == 0) {
+		return 0;	/* always claim internal verify okay */
+	} else if (bytchk == 2) {
+		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 2);
+		return check_condition_result;
+	} else if (bytchk == 3) {
+		is_bytchk3 = true;	/* 1 block sent, compared repeatedly */
+	}
+	switch (cmd[0]) {
+	case VERIFY_16:
+		lba = get_unaligned_be64(cmd + 2);
+		vnum = get_unaligned_be32(cmd + 10);
+		break;
+	case VERIFY:		/* is VERIFY(10) */
+		lba = get_unaligned_be32(cmd + 2);
+		vnum = get_unaligned_be16(cmd + 7);
+		break;
+	default:
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+	a_num = is_bytchk3 ? 1 : vnum;
+	/* Treat following check like one for read (i.e. no write) access */
+	ret = check_device_access_params(scp, lba, a_num, false);
+	if (ret)
+		return ret;
+
+	arr = kcalloc(lb_size, vnum, GFP_ATOMIC);
+	if (!arr) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
+	/* Not changing store, so only need read access */
+	read_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
+
+	/* trick do_device_access() to fetch data-out into arr. */
+	fspp = &fake_store_a[acc_num % 2];
+	fsp_hold = *fspp;
+	*fspp = arr;
+	ret = do_device_access(scp, 0, 0, a_num, true);
+	*fspp = fsp_hold;
+	if (ret == -1) {
+		ret = DID_ERROR << 16;
+		goto cleanup;
+	} else if (sdebug_verbose && (ret < (a_num * lb_size))) {
+		sdev_printk(KERN_INFO, scp->device,
+			    "%s: %s: cdb indicated=%u, IO sent=%d bytes\n",
+			    my_name, __func__, a_num * lb_size, ret);
+	}
+	if (is_bytchk3) {
+		for (j = 1, off = lb_size; j < vnum; ++j, off += lb_size)
+			memcpy(arr + off, arr, lb_size);
+	}
+	ret = 0;
+	if (!comp_write_worker(lba, vnum, arr, acc_num, true)) {
+		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
+		ret = check_condition_result;
+		goto cleanup;
+	}
+cleanup:
+	read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
+	kfree(arr);
+	return ret;
+}
+
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u32 tag = blk_mq_unique_tag(cmnd->request);
-- 
2.24.1

