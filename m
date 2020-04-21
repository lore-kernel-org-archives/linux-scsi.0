Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E19C55183
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A5A2068F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDUPOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:14:46 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41966 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725987AbgDUPOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 11:14:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A3E4620416A;
        Tue, 21 Apr 2020 17:14:43 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JC7f74Ejmwp2; Tue, 21 Apr 2020 17:14:41 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 018A4204148;
        Tue, 21 Apr 2020 17:14:37 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v5 6/8] scsi_debug: implement pre-fetch commands
Date:   Tue, 21 Apr 2020 11:14:22 -0400
Message-Id: <20200421151424.32668-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421151424.32668-1-dgilbert@interlog.com>
References: <20200421151424.32668-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many disks implement the SCSI PRE-FETCH commands. One use case might
be a disk-to-disk compare, say between disks A and B. Then this
sequence of commands might be used: PRE-FETCH(from B, IMMED),
READ(from A), VERIFY (BYTCHK=1 on B with data returned from READ).
The PRE-FETCH (which returns quickly due to the IMMED) fetches the
data from the media into B's cache which should speed the trailing
VERIFY command. The next chunk of the compare might be done in
parallel, with A and B reversed.

The implementation tries to bring the specified range in main memory
into the cache(s) associated with this machine's CPU(s) using the
prefetch_range() function.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 75 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 64d65c34c676..f63eee5bae5d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -41,6 +41,7 @@
 #include <linux/msdos_partition.h>
 #include <linux/random.h>
 #include <linux/xarray.h>
+#include <linux/prefetch.h>
 
 #include <net/checksum.h>
 
@@ -367,7 +368,8 @@ enum sdeb_opcode_index {
 	SDEB_I_WRITE_SAME = 26,		/* 10, 16 */
 	SDEB_I_SYNC_CACHE = 27,		/* 10, 16 */
 	SDEB_I_COMP_WRITE = 28,
-	SDEB_I_LAST_ELEMENT = 29,	/* keep this last (previous + 1) */
+	SDEB_I_PRE_FETCH = 29,		/* 10, 16 */
+	SDEB_I_LAST_ELEM_P1 = 30,	/* keep this last (previous + 1) */
 };
 
 
@@ -383,7 +385,7 @@ static const unsigned char opcode_ind_arr[256] = {
 /* 0x20; 0x20->0x3f: 10 byte cdbs */
 	0, 0, 0, 0, 0, SDEB_I_READ_CAPACITY, 0, 0,
 	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, SDEB_I_VERIFY,
-	0, 0, 0, 0, 0, SDEB_I_SYNC_CACHE, 0, 0,
+	0, 0, 0, 0, SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, 0,
 	0, 0, 0, SDEB_I_WRITE_BUFFER, 0, 0, 0, 0,
 /* 0x40; 0x40->0x5f: 10 byte cdbs */
 	0, SDEB_I_WRITE_SAME, SDEB_I_UNMAP, 0, 0, 0, 0, 0,
@@ -399,7 +401,7 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
 	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0,
 	0, 0, 0, SDEB_I_VERIFY,
-	0, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
+	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
@@ -446,6 +448,7 @@ static int resp_write_same_16(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_pre_fetch(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 static int sdebug_do_add_host(bool mk_new_store);
 static int sdebug_add_host_helper(int per_host_idx);
@@ -544,11 +547,17 @@ static const struct opcode_info_t sync_cache_iarr[] = {
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* SYNC_CACHE (16) */
 };
 
+static const struct opcode_info_t pre_fetch_iarr[] = {
+	{0, 0x90, 0, F_SYNC_DELAY | F_M_ACCESS, resp_pre_fetch, NULL,
+	    {16,  0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* PRE-FETCH (16) */
+};
+
 
 /* This array is accessed via SDEB_I_* values. Make sure all are mapped,
  * plus the terminating elements for logic that scans this table such as
  * REPORT SUPPORTED OPERATION CODES. */
-static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
+static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 /* 0 */
 	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL,	/* unknown opcodes */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
@@ -640,8 +649,12 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	{0, 0x89, 0, F_D_OUT | FF_MEDIA_IO, resp_comp_write, NULL,
 	    {16,  0xf8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0, 0,
 	     0, 0xff, 0x3f, 0xc7} },		/* COMPARE AND WRITE */
+	{ARRAY_SIZE(pre_fetch_iarr), 0x34, 0, F_SYNC_DELAY | F_M_ACCESS,
+	    resp_pre_fetch, pre_fetch_iarr,
+	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
+	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
 
-/* 29 */
+/* 30 */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
@@ -756,6 +769,8 @@ static const int illegal_condition_result =
 static const int device_qfull_result =
 	(DID_OK << 16) | (COMMAND_COMPLETE << 8) | SAM_STAT_TASK_SET_FULL;
 
+static const int condition_met_result = SAM_STAT_CONDITION_MET;
+
 
 /* Only do the extra work involved in logical block provisioning if one or
  * more of the lbpu, lbpws or lbpws10 parameters are given and we are doing
@@ -3674,6 +3689,56 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
 	return res;
 }
 
+/*
+ * Assuming the LBA+num_blocks is not out-of-range, this function will return
+ * CONDITION MET if the specified blocks will/have fitted in the cache, and
+ * a GOOD status otherwise. Model a disk with a big cache and yield
+ * CONDITION MET. Actually tries to bring range in main memory into the
+ * cache associated with the CPU(s).
+ */
+static int resp_pre_fetch(struct scsi_cmnd *scp,
+			  struct sdebug_dev_info *devip)
+{
+	int res = 0;
+	u64 lba;
+	u64 block, rest = 0;
+	u32 nblks;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	u8 *fsp = sip ? sip->storep : NULL;
+
+	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
+		lba = get_unaligned_be32(cmd + 2);
+		nblks = get_unaligned_be16(cmd + 7);
+	} else {			/* PRE-FETCH(16) */
+		lba = get_unaligned_be64(cmd + 2);
+		nblks = get_unaligned_be32(cmd + 10);
+	}
+	if (lba + nblks > sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		return check_condition_result;
+	}
+	if (!fsp)
+		goto fini;
+	/* PRE-FETCH spec says nothing about LBP or PI so skip them */
+	block = do_div(lba, sdebug_store_sectors);
+	if (block + nblks > sdebug_store_sectors)
+		rest = block + nblks - sdebug_store_sectors;
+
+	/* Try to bring the PRE-FETCH range into CPU's cache */
+	read_lock(macc_lckp);
+	prefetch_range(fsp + (sdebug_sector_size * block),
+		       (nblks - rest) * sdebug_sector_size);
+	if (rest)
+		prefetch_range(fsp, rest * sdebug_sector_size);
+	read_unlock(macc_lckp);
+fini:
+	if (cmd[1] & 0x2)
+		res = SDEG_RES_IMMED_MASK;
+	return res | condition_met_result;
+}
+
 #define RL_BUCKET_ELEMS 8
 
 /* Even though each pseudo target has a REPORT LUNS "well known logical unit"
-- 
2.26.1

