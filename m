Return-Path: <SRS0=BSUp=2M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A494DC2D0D5
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ADA220CC7
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfLVEAC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Dec 2019 23:00:02 -0500
Received: from smtp.infotech.no ([82.134.31.41]:39892 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbfLVEAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Dec 2019 23:00:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id BE055204190;
        Sun, 22 Dec 2019 04:59:57 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pep1kaFqrRPa; Sun, 22 Dec 2019 04:59:54 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 6F0BF204192;
        Sun, 22 Dec 2019 04:59:53 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC 2/6] scsi_debug: add doublestore option
Date:   Sat, 21 Dec 2019 22:59:44 -0500
Message-Id: <20191222035948.30447-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191222035948.30447-1-dgilbert@interlog.com>
References: <20191222035948.30447-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_debug driver has always been restricted to using one
(or none) ramdisk image for its storage. This means that thousands
of scsi_debug devices can be created without exhausting the host
machine's RAM. The downside is that all scsi_debug devices share
the same ramdisk image. This option doubles the amount of ramdisk
storage space with the first, third, fifth (etc) created
scsi_debug devices using the first ramdisk image while the second,
fourth, sixth (etc) created scsi_debug devices using the second
ramdisk image.

The reason for doing this is to check that (partial) disk to disk
copies based on scsi_debug devices have actually worked properly.
As an example: assume /dev/sdb and /dev/sg1 are the same
scsi_debug device, while /dev/sdc and /dev/sg2 are also the
same scsi_debug device. With doublestore=1 they will have
different ramdisk images. Then the following pseudocode could
be executed to check the if sgh_dd copy worked:
    dd if=/dev/urandom of=/dev/sdb
    sgh_dd if=/dev/sg1 of=/dev/sg2 [plus option(s) to test]
    cmp /dev/sdb /dev/sdc

If the cmp fails then the copy has failed (or some other
mechanism wrote to /dev/sdb or /dev/sdc in the interim).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 250 ++++++++++++++++++++++++++------------
 1 file changed, 174 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 18c07e9ace15..45934dae8617 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -108,6 +108,7 @@ static const char *sdebug_version_date = "20190125";
 #define DEF_DEV_SIZE_MB   8
 #define DEF_DIF 0
 #define DEF_DIX 0
+#define DEF_DOUBLESTORE false
 #define DEF_D_SENSE   0
 #define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
@@ -255,6 +256,7 @@ struct sdebug_dev_info {
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
 	atomic_t stopped;
+	int sdg_devnum;
 	bool used;
 };
 
@@ -633,6 +635,7 @@ static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
 static unsigned int sdebug_medium_error_start = OPT_MEDIUM_ERR_ADDR;
 static int sdebug_medium_error_count = OPT_MEDIUM_ERR_NUM;
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
+static atomic_t a_sdg_devnum;
 static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
 static int sdebug_no_lun_0 = DEF_NO_LUN_0;
 static int sdebug_no_uld;
@@ -658,6 +661,7 @@ static unsigned int sdebug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int sdebug_write_same_length = DEF_WRITESAME_LENGTH;
 static int sdebug_uuid_ctl = DEF_UUID_CTL;
 static bool sdebug_random = DEF_RANDOM;
+static bool sdebug_doublestore = DEF_DOUBLESTORE;
 static bool sdebug_removable = DEF_REMOVABLE;
 static bool sdebug_clustering;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
@@ -681,7 +685,7 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
-static unsigned char *fake_storep;	/* ramdisk storage */
+static u8 *fake_store_a[2];		/* ramdisk storage */
 static struct t10_pi_tuple *dif_storep;	/* protection info */
 static void *map_storep;		/* provisioning map */
 
@@ -699,6 +703,9 @@ static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
 
 static DEFINE_RWLOCK(atomic_rw);
+static DEFINE_RWLOCK(atomic_rw2);
+
+static rwlock_t *ramdisk_lck_a[2];
 
 static char sdebug_proc_name[] = MY_NAME;
 static const char *my_name = MY_NAME;
@@ -730,11 +737,11 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
 
-static void *lba2fake_store(unsigned long long lba)
+static void *lba2fake_store(unsigned long long lba, int acc_num)
 {
 	lba = do_div(lba, sdebug_store_sectors);
 
-	return fake_storep + lba * sdebug_sector_size;
+	return fake_store_a[acc_num % 2] + lba * sdebug_sector_size;
 }
 
 static struct t10_pi_tuple *dif_store(sector_t sector)
@@ -1043,7 +1050,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
 	n = scsi_bufflen(scp) - (off_dst + act_len);
-	scsi_set_resid(scp, min(scsi_get_resid(scp), n));
+	scsi_set_resid(scp, min_t(int, scsi_get_resid(scp), n));
 	return 0;
 }
 
@@ -1535,7 +1542,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
-			    min(alloc_len, SDEBUG_LONG_INQ_SZ));
+			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -1690,7 +1697,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 	}
 
 	return fill_from_dev_buffer(scp, arr,
-				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
+			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
 #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
@@ -1764,9 +1771,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	 * - The constructed command length
 	 * - The maximum array size
 	 */
-	rlen = min(alen,n);
+	rlen = min_t(int, alen,n);
 	ret = fill_from_dev_buffer(scp, arr,
-				   min(rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
+			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -2268,7 +2275,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
-	return fill_from_dev_buffer(scp, arr, min(alloc_len, offset));
+	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
@@ -2453,9 +2460,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 3, -1);
 		return check_condition_result;
 	}
-	len = min(get_unaligned_be16(arr + 2) + 4, alloc_len);
+	len = min_t(int, get_unaligned_be16(arr + 2) + 4, alloc_len);
 	return fill_from_dev_buffer(scp, arr,
-		    min(len, SDEBUG_MAX_INQ_ARR_SZ));
+		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
 static inline int check_device_access_params(struct scsi_cmnd *scp,
@@ -2478,6 +2485,18 @@ static inline int check_device_access_params(struct scsi_cmnd *scp,
 	return 0;
 }
 
+static int scp2acc_num(struct scsi_cmnd *scp)
+{
+	if (sdebug_doublestore) {
+		struct scsi_device *sdp = scp->device;
+		struct sdebug_dev_info *devip =
+				(struct sdebug_dev_info *)sdp->hostdata;
+
+		return devip->sdg_devnum;
+	}
+	return 0;
+}
+
 /* Returns number of bytes copied or -1 if error. */
 static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 			    u32 num, bool do_write)
@@ -2486,6 +2505,7 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 	u64 block, rest = 0;
 	struct scsi_data_buffer *sdb = &scmd->sdb;
 	enum dma_data_direction dir;
+	u8 *fsp;
 
 	if (do_write) {
 		dir = DMA_TO_DEVICE;
@@ -2498,20 +2518,21 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 		return 0;
 	if (scmd->sc_data_direction != dir)
 		return -1;
+	fsp = fake_store_a[scp2acc_num(scmd) % 2];
 
 	block = do_div(lba, sdebug_store_sectors);
 	if (block + num > sdebug_store_sectors)
 		rest = block + num - sdebug_store_sectors;
 
 	ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
-		   fake_storep + (block * sdebug_sector_size),
+		   fsp + (block * sdebug_sector_size),
 		   (num - rest) * sdebug_sector_size, sg_skip, do_write);
 	if (ret != (num - rest) * sdebug_sector_size)
 		return ret;
 
 	if (rest) {
 		ret += sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
-			    fake_storep, rest * sdebug_sector_size,
+			    fsp, rest * sdebug_sector_size,
 			    sg_skip + ((num - rest) * sdebug_sector_size),
 			    do_write);
 	}
@@ -2522,31 +2543,32 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 /* If lba2fake_store(lba,num) compares equal to arr(num), then copy top half of
  * arr into lba2fake_store(lba,num) and return true. If comparison fails then
  * return false. */
-static bool comp_write_worker(u64 lba, u32 num, const u8 *arr)
+static bool comp_write_worker(u64 lba, u32 num, const u8 *arr, int acc_num)
 {
 	bool res;
 	u64 block, rest = 0;
 	u32 store_blks = sdebug_store_sectors;
 	u32 lb_size = sdebug_sector_size;
+	u8 *fsp;
 
 	block = do_div(lba, store_blks);
 	if (block + num > store_blks)
 		rest = block + num - store_blks;
 
-	res = !memcmp(fake_storep + (block * lb_size), arr,
-		      (num - rest) * lb_size);
+	fsp = fake_store_a[acc_num % 2];
+
+	res = !memcmp(fsp + (block * lb_size), arr, (num - rest) * lb_size);
 	if (!res)
 		return res;
 	if (rest)
-		res = memcmp(fake_storep, arr + ((num - rest) * lb_size),
+		res = memcmp(fsp, arr + ((num - rest) * lb_size),
 			     rest * lb_size);
 	if (!res)
 		return res;
 	arr += num * lb_size;
-	memcpy(fake_storep + (block * lb_size), arr, (num - rest) * lb_size);
+	memcpy(fsp + (block * lb_size), arr, (num - rest) * lb_size);
 	if (rest)
-		memcpy(fake_storep, arr + ((num - rest) * lb_size),
-		       rest * lb_size);
+		memcpy(fsp, arr + ((num - rest) * lb_size), rest * lb_size);
 	return res;
 }
 
@@ -2605,7 +2627,7 @@ static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
 			(read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
 
 	while (sg_miter_next(&miter) && resid > 0) {
-		size_t len = min(miter.length, resid);
+		size_t len = min_t(size_t, miter.length, resid);
 		void *start = dif_store(sector);
 		size_t rest = 0;
 
@@ -2632,12 +2654,12 @@ static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
 	sg_miter_stop(&miter);
 }
 
-static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
+static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 			    unsigned int sectors, u32 ei_lba)
 {
 	unsigned int i;
-	struct t10_pi_tuple *sdt;
 	sector_t sector;
+	struct t10_pi_tuple *sdt;
 
 	for (i = 0; i < sectors; i++, ei_lba++) {
 		int ret;
@@ -2648,14 +2670,15 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		if (sdt->app_tag == cpu_to_be16(0xffff))
 			continue;
 
-		ret = dif_verify(sdt, lba2fake_store(sector), sector, ei_lba);
+		ret = dif_verify(sdt, lba2fake_store(sector, scp2acc_num(scp)),
+				 sector, ei_lba);
 		if (ret) {
 			dif_errors++;
 			return ret;
 		}
 	}
 
-	dif_copy_prot(SCpnt, start_sec, sectors, true);
+	dif_copy_prot(scp, start_sec, sectors, true);
 	dix_reads++;
 
 	return 0;
@@ -2665,10 +2688,11 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
 	struct sdebug_queued_cmd *sqcp;
-	u64 lba;
 	u32 num;
 	u32 ei_lba;
+	int acc_num = scp2acc_num(scp);
 	unsigned long iflags;
+	u64 lba;
 	int ret;
 	bool check_prot;
 
@@ -2752,21 +2776,22 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	read_lock_irqsave(&atomic_rw, iflags);
+	read_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			read_unlock_irqrestore(&atomic_rw, iflags);
+			read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2],
+					       iflags);
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
 	ret = do_device_access(scp, 0, lba, num, false);
-	read_unlock_irqrestore(&atomic_rw, iflags);
+	read_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -2938,9 +2963,10 @@ static void map_region(sector_t lba, unsigned int len)
 	}
 }
 
-static void unmap_region(sector_t lba, unsigned int len)
+static void unmap_region(sector_t lba, unsigned int len, int acc_num)
 {
 	sector_t end = lba + len;
+	u8 *fsp = fake_store_a[acc_num % 2];
 
 	while (lba < end) {
 		unsigned long index = lba_to_map_index(lba);
@@ -2950,8 +2976,7 @@ static void unmap_region(sector_t lba, unsigned int len)
 		    index < map_size) {
 			clear_bit(index, map_storep);
 			if (sdebug_lbprz) {  /* for LBPRZ=2 return 0xff_s */
-				memset(fake_storep +
-				       lba * sdebug_sector_size,
+				memset(fsp + lba * sdebug_sector_size,
 				       (sdebug_lbprz & 1) ? 0 : 0xff,
 				       sdebug_sector_size *
 				       sdebug_unmap_granularity);
@@ -2968,13 +2993,14 @@ static void unmap_region(sector_t lba, unsigned int len)
 
 static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
-	u64 lba;
+	bool check_prot;
 	u32 num;
 	u32 ei_lba;
-	unsigned long iflags;
+	int acc_num = scp2acc_num(scp);
 	int ret;
-	bool check_prot;
+	unsigned long iflags;
+	u64 lba;
+	u8 *cmd = scp->cmnd;
 
 	switch (cmd[0]) {
 	case WRITE_16:
@@ -3030,14 +3056,15 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			write_unlock_irqrestore(&atomic_rw, iflags);
+			write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2],
+						iflags);
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
@@ -3046,7 +3073,7 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(lba, num);
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3092,6 +3119,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
 	u32 lb_size = sdebug_sector_size;
 	u32 ei_lba;
+	int acc_num = scp2acc_num(scp);
 	u64 lba;
 	unsigned long iflags;
 	int ret, res;
@@ -3155,7 +3183,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3238,7 +3266,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3247,27 +3275,30 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
-	int ret;
 	unsigned long iflags;
 	unsigned long long i;
-	u32 lb_size = sdebug_sector_size;
 	u64 block, lbaa;
+	u32 lb_size = sdebug_sector_size;
+	int ret;
+	int acc_num = scp2acc_num(scp);
 	u8 *fs1p;
+	u8 *fsp;
 
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 
 	if (unmap && scsi_debug_lbp()) {
-		unmap_region(lba, num);
+		unmap_region(lba, num, acc_num);
 		goto out;
 	}
 	lbaa = lba;
 	block = do_div(lbaa, sdebug_store_sectors);
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
-	fs1p = fake_storep + (block * lb_size);
+	fsp = fake_store_a[acc_num % 2];
+	fs1p = fsp + (block * lb_size);
 	if (ndob) {
 		memset(fs1p, 0, lb_size);
 		ret = 0;
@@ -3275,7 +3306,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock_irqrestore(&atomic_rw, iflags);
+		write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3286,12 +3317,12 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	for (i = 1 ; i < num ; i++) {
 		lbaa = lba + i;
 		block = do_div(lbaa, sdebug_store_sectors);
-		memmove(fake_storep + (block * lb_size), fs1p, lb_size);
+		memmove(fsp + (block * lb_size), fs1p, lb_size);
 	}
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 out:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 
 	return 0;
 }
@@ -3403,7 +3434,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 {
 	u8 *cmd = scp->cmnd;
 	u8 *arr;
-	u8 *fake_storep_hold;
+	u8 **fspp;
+	u8 *fsp_hold;
 	u64 lba;
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
@@ -3411,6 +3443,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	unsigned long iflags;
 	int ret;
 	int retval = 0;
+	int acc_num = scp2acc_num(scp);
 
 	lba = get_unaligned_be64(cmd + 2);
 	num = cmd[13];		/* 1 to a maximum of 255 logical blocks */
@@ -3437,14 +3470,15 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 
 	/* trick do_device_access() to fetch both compare and write buffers
 	 * from data-in into arr. Safe (atomic) since write_lock held. */
-	fake_storep_hold = fake_storep;
-	fake_storep = arr;
+	fspp = &fake_store_a[scp2acc_num(scp) % 2];
+	fsp_hold = *fspp;
+	*fspp = arr;
 	ret = do_device_access(scp, 0, 0, dnum, true);
-	fake_storep = fake_storep_hold;
+	*fspp = fsp_hold;
 	if (ret == -1) {
 		retval = DID_ERROR << 16;
 		goto cleanup;
@@ -3452,7 +3486,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
-	if (!comp_write_worker(lba, num, arr)) {
+	if (!comp_write_worker(lba, num, arr, scp2acc_num(scp))) {
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
 		retval = check_condition_result;
 		goto cleanup;
@@ -3460,7 +3494,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 cleanup:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 	kfree(arr);
 	return retval;
 }
@@ -3477,6 +3511,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct unmap_block_desc *desc;
 	unsigned int i, payload_len, descriptors;
 	int ret;
+	int acc_num = scp2acc_num(scp);
 	unsigned long iflags;
 
 
@@ -3505,7 +3540,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(ramdisk_lck_a[acc_num % 2], iflags);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -3515,13 +3550,13 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		if (ret)
 			goto out;
 
-		unmap_region(lba, num);
+		unmap_region(lba, num, scp2acc_num(scp));
 	}
 
 	ret = 0;
 
 out:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(ramdisk_lck_a[acc_num % 2], iflags);
 	kfree(buf);
 
 	return ret;
@@ -3891,6 +3926,7 @@ static int scsi_debug_slave_configure(struct scsi_device *sdp)
 	if (sdebug_no_uld)
 		sdp->no_uld_attach = 1;
 	config_cdb_len(sdp);
+	devip->sdg_devnum = atomic_inc_return(&a_sdg_devnum);
 	return 0;
 }
 
@@ -4146,8 +4182,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static void __init sdebug_build_parts(unsigned char *ramp,
-				      unsigned long store_size)
+static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 {
 	struct partition *pp;
 	int starts[SDEBUG_MAX_PARTS + 2];
@@ -4436,6 +4471,7 @@ module_param_named(delay, sdebug_jdelay, int, S_IRUGO | S_IWUSR);
 module_param_named(dev_size_mb, sdebug_dev_size_mb, int, S_IRUGO);
 module_param_named(dif, sdebug_dif, int, S_IRUGO);
 module_param_named(dix, sdebug_dix, int, S_IRUGO);
+module_param_named(doublestore, sdebug_doublestore, bool, S_IRUGO | S_IWUSR);
 module_param_named(dsense, sdebug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
@@ -4499,6 +4535,7 @@ MODULE_PARM_DESC(dev_size_mb, "size in MiB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
+MODULE_PARM_DESC(doublestore, "If set, 2 data buffers allocated, devices alternate between the two");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
@@ -4788,16 +4825,22 @@ static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 		n = (n > 0);
 		sdebug_fake_rw = (sdebug_fake_rw > 0);
 		if (sdebug_fake_rw != n) {
-			if ((0 == n) && (NULL == fake_storep)) {
-				unsigned long sz =
-					(unsigned long)sdebug_dev_size_mb *
-					1048576;
-
-				fake_storep = vzalloc(sz);
-				if (NULL == fake_storep) {
-					pr_err("out of memory, 9\n");
+			unsigned long sz = (unsigned long)sdebug_dev_size_mb *
+					   1048576;
+
+			if (n == 0 && !fake_store_a[0]) {
+				fake_store_a[0] = vzalloc(sz);
+				if (!fake_store_a[0])
 					return -ENOMEM;
-				}
+				if (sdebug_num_parts > 0)
+					sdebug_build_parts(fake_store_a[0], sz);
+			}
+			if (sdebug_doublestore && n == 0 && !fake_store_a[1]) {
+				fake_store_a[1] = vzalloc(sz);
+				if (!fake_store_a[1])
+					return -ENOMEM;
+				if (sdebug_num_parts > 0)
+					sdebug_build_parts(fake_store_a[1], sz);
 			}
 			sdebug_fake_rw = n;
 		}
@@ -4848,6 +4891,47 @@ static ssize_t dev_size_mb_show(struct device_driver *ddp, char *buf)
 }
 static DRIVER_ATTR_RO(dev_size_mb);
 
+static ssize_t doublestore_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_doublestore);
+}
+
+static ssize_t doublestore_store(struct device_driver *ddp, const char *buf,
+				 size_t count)
+{
+	int n;
+
+	if (count > 0 && kstrtoint(buf, 10, &n) == 0 && n >= 0) {
+		unsigned long iflags;
+
+		if (sdebug_doublestore == (n > 0))
+			return count;	/* no state change */
+		if (n <= 0) {
+			write_lock_irqsave(ramdisk_lck_a[1], iflags);
+			sdebug_doublestore = false;
+			vfree(fake_store_a[1]);
+			fake_store_a[1] = NULL;
+			write_unlock_irqrestore(ramdisk_lck_a[1], iflags);
+		} else {
+			unsigned long sz = (unsigned long)sdebug_dev_size_mb *
+					   1048576;
+			u8 *fsp = vzalloc(sz);
+
+			if (!fsp)
+				return -ENOMEM;
+			if (sdebug_num_parts > 0)
+				sdebug_build_parts(fsp, sz);
+			write_lock_irqsave(ramdisk_lck_a[1], iflags);
+			fake_store_a[1] = fsp;
+			sdebug_doublestore = true;
+			write_unlock_irqrestore(ramdisk_lck_a[1], iflags);
+		}
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(doublestore);
+
 static ssize_t num_parts_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_parts);
@@ -5225,6 +5309,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_opts.attr,
 	&driver_attr_ptype.attr,
 	&driver_attr_dsense.attr,
+	&driver_attr_doublestore.attr,
 	&driver_attr_fake_rw.attr,
 	&driver_attr_no_lun_0.attr,
 	&driver_attr_num_tgts.attr,
@@ -5266,7 +5351,10 @@ static int __init scsi_debug_init(void)
 	int k;
 	int ret;
 
+	ramdisk_lck_a[0] = &atomic_rw;
+	ramdisk_lck_a[1] = &atomic_rw2;
 	atomic_set(&retired_max_queue, 0);
+	atomic_set(&a_sdg_devnum, 0);
 
 	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
 		pr_warn("ndelay must be less than 1 second, ignored\n");
@@ -5363,14 +5451,22 @@ static int __init scsi_debug_init(void)
 	}
 
 	if (sdebug_fake_rw == 0) {
-		fake_storep = vzalloc(sz);
-		if (NULL == fake_storep) {
-			pr_err("out of memory, 1\n");
+		fake_store_a[0] = vzalloc(sz);
+		if (!fake_store_a[0]) {
 			ret = -ENOMEM;
 			goto free_q_arr;
 		}
 		if (sdebug_num_parts > 0)
-			sdebug_build_parts(fake_storep, sz);
+			sdebug_build_parts(fake_store_a[0], sz);
+		if (sdebug_doublestore) {
+			fake_store_a[1] = vzalloc(sz);
+			if (!fake_store_a[1]) {
+				ret = -ENOMEM;
+				goto free_q_arr;
+			}
+			if (sdebug_num_parts > 0)
+				sdebug_build_parts(fake_store_a[1], sz);
+		}
 	}
 
 	if (sdebug_dix) {
@@ -5467,7 +5563,8 @@ static int __init scsi_debug_init(void)
 free_vm:
 	vfree(map_storep);
 	vfree(dif_storep);
-	vfree(fake_storep);
+	vfree(fake_store_a[1]);
+	vfree(fake_store_a[0]);
 free_q_arr:
 	kfree(sdebug_q_arr);
 	return ret;
@@ -5487,7 +5584,8 @@ static void __exit scsi_debug_exit(void)
 
 	vfree(map_storep);
 	vfree(dif_storep);
-	vfree(fake_storep);
+	vfree(fake_store_a[1]);
+	vfree(fake_store_a[0]);
 	kfree(sdebug_q_arr);
 }
 
-- 
2.24.1

