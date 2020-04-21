Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 491D8C54FD0
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234CC2068F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 15:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgDUPOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:14:47 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41945 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbgDUPOp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 11:14:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DC911204247;
        Tue, 21 Apr 2020 17:14:39 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GpomclYjSnhv; Tue, 21 Apr 2020 17:14:34 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id CCDD720423B;
        Tue, 21 Apr 2020 17:14:32 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com
Subject: [PATCH v5 2/8] scsi_debug: add per_host_store option
Date:   Tue, 21 Apr 2020 11:14:18 -0400
Message-Id: <20200421151424.32668-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200421151424.32668-1-dgilbert@interlog.com>
References: <20200421151424.32668-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_debug driver has always been restricted to using one ramdisk
image (or none) for its storage. This means that thousands of
scsi_debug devices can be created without exhausting the host machine's
RAM. The downside is that all scsi_debug devices share the same ramdisk
image. This option changes the way a following write to the add_host
parameter (or an add_host in the module/driver invocation) operates.
For each new host that is created while per_host_store is true, a new
store (of dev-size_mb MiB) is created and associated with all the LUs
that belong to that new host. The user (who will need root permissions)
needs to take care not to exhaust all the machine's available RAM.

One reason for doing this is to check that (partial) disk to disk
copies based on scsi_debug devices have actually copied accurately. To
test this the add_host=<n> parameter where <n> is 2 or greater can be
used when the scsi_debug module is loaded. Let us assume that
/dev/sdb and /dev/sg1 are the same scsi_debug device, while /dev/sdc
and /dev/sg2 are the same scsi_debug device. With per_host_store=1
add_host=2 they will have different ramdisk images. Then the following
pseudocode could be executed to check if the sgh_dd copy worked:
    dd if=/dev/urandom of=/dev/sdb
    sgh_dd if=/dev/sg1 of=/dev/sg2 [plus option(s) to test]
    cmp /dev/sdb /dev/sdc

If the cmp fails then the copy has failed (or some other mechanism
wrote to /dev/sdb or /dev/sdc in the interim).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 710 ++++++++++++++++++++++++++------------
 1 file changed, 496 insertions(+), 214 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d54ef83c78d8..af2eaf6dd64f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -40,6 +40,7 @@
 #include <linux/t10-pi.h>
 #include <linux/msdos_partition.h>
 #include <linux/random.h>
+#include <linux/xarray.h>
 
 #include <net/checksum.h>
 
@@ -109,6 +110,7 @@ static const char *sdebug_version_date = "20190125";
 #define DEF_DEV_SIZE_MB   8
 #define DEF_DIF 0
 #define DEF_DIX 0
+#define DEF_PER_HOST_STORE false
 #define DEF_D_SENSE   0
 #define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
@@ -245,6 +247,8 @@ static const char *sdebug_version_date = "20190125";
 
 #define SDEBUG_MAX_CMD_LEN 32
 
+#define SDEB_XA_NOT_IN_USE XA_MARK_1
+
 
 struct sdebug_dev_info {
 	struct list_head dev_list;
@@ -261,11 +265,20 @@ struct sdebug_dev_info {
 
 struct sdebug_host_info {
 	struct list_head host_list;
+	int si_idx;	/* sdeb_store_info (per host) xarray index */
 	struct Scsi_Host *shost;
 	struct device dev;
 	struct list_head dev_info_list;
 };
 
+/* There is an xarray of pointers to this struct's objects, one per host */
+struct sdeb_store_info {
+	rwlock_t macc_lck;	/* for atomic media access on this store */
+	u8 *storep;		/* user data storage (ram) */
+	struct t10_pi_tuple *dif_storep; /* protection info */
+	void *map_storep;	/* provisioning map */
+};
+
 #define to_sdebug_host(d)	\
 	container_of(d, struct sdebug_host_info, dev)
 
@@ -432,6 +445,13 @@ static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
 
+static int sdebug_do_add_host(bool mk_new_store);
+static int sdebug_add_host_helper(int per_host_idx);
+static void sdebug_do_remove_host(bool the_end);
+static int sdebug_add_store(void);
+static void sdebug_erase_store(int idx, struct sdeb_store_info *sip);
+static void sdebug_erase_all_stores(bool apart_from_first);
+
 /*
  * The following are overflow arrays for cdbs that "hit" the same index in
  * the opcode_info_arr array. The most time sensitive (or commonly used) cdb
@@ -617,7 +637,8 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEMENT + 1] = {
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
 
-static int sdebug_add_host = DEF_NUM_HOST;
+static int sdebug_num_hosts;
+static int sdebug_add_host = DEF_NUM_HOST;  /* in sysfs this is relative */
 static int sdebug_ato = DEF_ATO;
 static int sdebug_cdb_len = DEF_CDB_LEN;
 static int sdebug_jdelay = DEF_JDELAY;	/* if > 0 then unit is jiffies */
@@ -659,6 +680,7 @@ static unsigned int sdebug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int sdebug_write_same_length = DEF_WRITESAME_LENGTH;
 static int sdebug_uuid_ctl = DEF_UUID_CTL;
 static bool sdebug_random = DEF_RANDOM;
+static bool sdebug_per_host_store = DEF_PER_HOST_STORE;
 static bool sdebug_removable = DEF_REMOVABLE;
 static bool sdebug_clustering;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
@@ -682,9 +704,11 @@ static int sdebug_sectors_per;		/* sectors per cylinder */
 static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
-static unsigned char *fake_storep;	/* ramdisk storage */
-static struct t10_pi_tuple *dif_storep;	/* protection info */
-static void *map_storep;		/* provisioning map */
+static struct xarray per_store_arr;
+static struct xarray *per_store_ap = &per_store_arr;
+static int sdeb_first_idx = -1;		/* invalid index ==> none created */
+static int sdeb_most_recent_idx = -1;
+static DEFINE_RWLOCK(sdeb_fake_rw_lck);	/* need a RW lock when fake_rw=1 */
 
 static unsigned long map_size;
 static int num_aborts;
@@ -700,6 +724,9 @@ static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
 
 static DEFINE_RWLOCK(atomic_rw);
+static DEFINE_RWLOCK(atomic_rw2);
+
+static rwlock_t *ramdisk_lck_a[2];
 
 static char sdebug_proc_name[] = MY_NAME;
 static const char *my_name = MY_NAME;
@@ -731,18 +758,25 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
 
-static void *lba2fake_store(unsigned long long lba)
+static void *lba2fake_store(struct sdeb_store_info *sip,
+			    unsigned long long lba)
 {
-	lba = do_div(lba, sdebug_store_sectors);
+	struct sdeb_store_info *lsip = sip;
 
-	return fake_storep + lba * sdebug_sector_size;
+	lba = do_div(lba, sdebug_store_sectors);
+	if (!sip || !sip->storep) {
+		WARN_ON_ONCE(true);
+		lsip = xa_load(per_store_ap, 0);  /* should never be NULL */
+	}
+	return lsip->storep + lba * sdebug_sector_size;
 }
 
-static struct t10_pi_tuple *dif_store(sector_t sector)
+static struct t10_pi_tuple *dif_store(struct sdeb_store_info *sip,
+				      sector_t sector)
 {
 	sector = sector_div(sector, sdebug_store_sectors);
 
-	return dif_storep + sector;
+	return sip->dif_storep + sector;
 }
 
 static void sdebug_max_tgts_luns(void)
@@ -1044,7 +1078,7 @@ static int p_fill_from_dev_buffer(struct scsi_cmnd *scp, const void *arr,
 		 __func__, off_dst, scsi_bufflen(scp), act_len,
 		 scsi_get_resid(scp));
 	n = scsi_bufflen(scp) - (off_dst + act_len);
-	scsi_set_resid(scp, min(scsi_get_resid(scp), n));
+	scsi_set_resid(scp, min_t(int, scsi_get_resid(scp), n));
 	return 0;
 }
 
@@ -1536,7 +1570,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	}
 	put_unaligned_be16(0x2100, arr + n);	/* SPL-4 no version claimed */
 	ret = fill_from_dev_buffer(scp, arr,
-			    min(alloc_len, SDEBUG_LONG_INQ_SZ));
+			    min_t(int, alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -1691,7 +1725,7 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 	}
 
 	return fill_from_dev_buffer(scp, arr,
-				    min(alloc_len, SDEBUG_READCAP16_ARR_SZ));
+			    min_t(int, alloc_len, SDEBUG_READCAP16_ARR_SZ));
 }
 
 #define SDEBUG_MAX_TGTPGS_ARR_SZ 1412
@@ -1765,9 +1799,9 @@ static int resp_report_tgtpgs(struct scsi_cmnd *scp,
 	 * - The constructed command length
 	 * - The maximum array size
 	 */
-	rlen = min(alen,n);
+	rlen = min_t(int, alen, n);
 	ret = fill_from_dev_buffer(scp, arr,
-				   min(rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
+			   min_t(int, rlen, SDEBUG_MAX_TGTPGS_ARR_SZ));
 	kfree(arr);
 	return ret;
 }
@@ -2269,7 +2303,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 		arr[0] = offset - 1;
 	else
 		put_unaligned_be16((offset - 2), arr + 0);
-	return fill_from_dev_buffer(scp, arr, min(alloc_len, offset));
+	return fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, offset));
 }
 
 #define SDEBUG_MAX_MSELECT_SZ 512
@@ -2454,9 +2488,9 @@ static int resp_log_sense(struct scsi_cmnd *scp,
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
@@ -2479,14 +2513,21 @@ static inline int check_device_access_params(struct scsi_cmnd *scp,
 	return 0;
 }
 
+static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip)
+{
+	return sdebug_fake_rw ?
+			NULL : xa_load(per_store_ap, devip->sdbg_host->si_idx);
+}
+
 /* Returns number of bytes copied or -1 if error. */
-static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
-			    u32 num, bool do_write)
+static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
+			    u32 sg_skip, u64 lba, u32 num, bool do_write)
 {
 	int ret;
 	u64 block, rest = 0;
-	struct scsi_data_buffer *sdb = &scmd->sdb;
 	enum dma_data_direction dir;
+	struct scsi_data_buffer *sdb = &scp->sdb;
+	u8 *fsp;
 
 	if (do_write) {
 		dir = DMA_TO_DEVICE;
@@ -2495,24 +2536,25 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 		dir = DMA_FROM_DEVICE;
 	}
 
-	if (!sdb->length)
+	if (!sdb->length || !sip)
 		return 0;
-	if (scmd->sc_data_direction != dir)
+	if (scp->sc_data_direction != dir)
 		return -1;
+	fsp = sip->storep;
 
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
@@ -2520,34 +2562,47 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 	return ret;
 }
 
-/* If lba2fake_store(lba,num) compares equal to arr(num), then copy top half of
- * arr into lba2fake_store(lba,num) and return true. If comparison fails then
+/* Returns number of bytes copied or -1 if error. */
+static int do_dout_fetch(struct scsi_cmnd *scp, u32 num, u8 *doutp)
+{
+	struct scsi_data_buffer *sdb = &scp->sdb;
+
+	if (!sdb->length)
+		return 0;
+	if (scp->sc_data_direction != DMA_TO_DEVICE)
+		return -1;
+	return sg_copy_buffer(sdb->table.sgl, sdb->table.nents, doutp,
+			      num * sdebug_sector_size, 0, true);
+}
+
+/* If sip->storep+lba compares equal to arr(num), then copy top half of
+ * arr into sip->storep+lba and return true. If comparison fails then
  * return false. */
-static bool comp_write_worker(u64 lba, u32 num, const u8 *arr)
+static bool comp_write_worker(struct sdeb_store_info *sip, u64 lba, u32 num,
+			      const u8 *arr)
 {
 	bool res;
 	u64 block, rest = 0;
 	u32 store_blks = sdebug_store_sectors;
 	u32 lb_size = sdebug_sector_size;
+	u8 *fsp = sip->storep;
 
 	block = do_div(lba, store_blks);
 	if (block + num > store_blks)
 		rest = block + num - store_blks;
 
-	res = !memcmp(fake_storep + (block * lb_size), arr,
-		      (num - rest) * lb_size);
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
 
@@ -2590,24 +2645,27 @@ static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
 	return 0;
 }
 
-static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
+static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
 			  unsigned int sectors, bool read)
 {
 	size_t resid;
 	void *paddr;
+	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata);
+	struct t10_pi_tuple *dif_storep = sip->dif_storep;
 	const void *dif_store_end = dif_storep + sdebug_store_sectors;
 	struct sg_mapping_iter miter;
 
 	/* Bytes of protection data to copy into sgl */
 	resid = sectors * sizeof(*dif_storep);
 
-	sg_miter_start(&miter, scsi_prot_sglist(SCpnt),
-			scsi_prot_sg_count(SCpnt), SG_MITER_ATOMIC |
-			(read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
+	sg_miter_start(&miter, scsi_prot_sglist(scp),
+		       scsi_prot_sg_count(scp), SG_MITER_ATOMIC |
+		       (read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
 
 	while (sg_miter_next(&miter) && resid > 0) {
-		size_t len = min(miter.length, resid);
-		void *start = dif_store(sector);
+		size_t len = min_t(size_t, miter.length, resid);
+		void *start = dif_store(sip, sector);
 		size_t rest = 0;
 
 		if (dif_store_end < start + len)
@@ -2633,30 +2691,33 @@ static void dif_copy_prot(struct scsi_cmnd *SCpnt, sector_t sector,
 	sg_miter_stop(&miter);
 }
 
-static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
+static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
 			    unsigned int sectors, u32 ei_lba)
 {
 	unsigned int i;
-	struct t10_pi_tuple *sdt;
 	sector_t sector;
+	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata);
+	struct t10_pi_tuple *sdt;
 
 	for (i = 0; i < sectors; i++, ei_lba++) {
 		int ret;
 
 		sector = start_sec + i;
-		sdt = dif_store(sector);
+		sdt = dif_store(sip, sector);
 
 		if (sdt->app_tag == cpu_to_be16(0xffff))
 			continue;
 
-		ret = dif_verify(sdt, lba2fake_store(sector), sector, ei_lba);
+		ret = dif_verify(sdt, lba2fake_store(sip, sector), sector,
+				 ei_lba);
 		if (ret) {
 			dif_errors++;
 			return ret;
 		}
 	}
 
-	dif_copy_prot(SCpnt, start_sec, sectors, true);
+	dif_copy_prot(scp, start_sec, sectors, true);
 	dix_reads++;
 
 	return 0;
@@ -2664,14 +2725,16 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
-	struct sdebug_queued_cmd *sqcp;
-	u64 lba;
+	bool check_prot;
 	u32 num;
 	u32 ei_lba;
-	unsigned long iflags;
 	int ret;
-	bool check_prot;
+	unsigned long iflags;
+	u64 lba;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	u8 *cmd = scp->cmnd;
+	struct sdebug_queued_cmd *sqcp;
 
 	switch (cmd[0]) {
 	case READ_16:
@@ -2753,21 +2816,21 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	read_lock_irqsave(&atomic_rw, iflags);
+	read_lock_irqsave(macc_lckp, iflags);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			read_unlock_irqrestore(&atomic_rw, iflags);
+			read_unlock_irqrestore(macc_lckp, iflags);
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	ret = do_device_access(scp, 0, lba, num, false);
-	read_unlock_irqrestore(&atomic_rw, iflags);
+	ret = do_device_access(sip, scp, 0, lba, num, false);
+	read_unlock_irqrestore(macc_lckp, iflags);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -2905,7 +2968,8 @@ static sector_t map_index_to_lba(unsigned long index)
 	return lba;
 }
 
-static unsigned int map_state(sector_t lba, unsigned int *num)
+static unsigned int map_state(struct sdeb_store_info *sip, sector_t lba,
+			      unsigned int *num)
 {
 	sector_t end;
 	unsigned int mapped;
@@ -2913,19 +2977,20 @@ static unsigned int map_state(sector_t lba, unsigned int *num)
 	unsigned long next;
 
 	index = lba_to_map_index(lba);
-	mapped = test_bit(index, map_storep);
+	mapped = test_bit(index, sip->map_storep);
 
 	if (mapped)
-		next = find_next_zero_bit(map_storep, map_size, index);
+		next = find_next_zero_bit(sip->map_storep, map_size, index);
 	else
-		next = find_next_bit(map_storep, map_size, index);
+		next = find_next_bit(sip->map_storep, map_size, index);
 
 	end = min_t(sector_t, sdebug_store_sectors,  map_index_to_lba(next));
 	*num = end - lba;
 	return mapped;
 }
 
-static void map_region(sector_t lba, unsigned int len)
+static void map_region(struct sdeb_store_info *sip, sector_t lba,
+		       unsigned int len)
 {
 	sector_t end = lba + len;
 
@@ -2933,15 +2998,17 @@ static void map_region(sector_t lba, unsigned int len)
 		unsigned long index = lba_to_map_index(lba);
 
 		if (index < map_size)
-			set_bit(index, map_storep);
+			set_bit(index, sip->map_storep);
 
 		lba = map_index_to_lba(index + 1);
 	}
 }
 
-static void unmap_region(sector_t lba, unsigned int len)
+static void unmap_region(struct sdeb_store_info *sip, sector_t lba,
+			 unsigned int len)
 {
 	sector_t end = lba + len;
+	u8 *fsp = sip->storep;
 
 	while (lba < end) {
 		unsigned long index = lba_to_map_index(lba);
@@ -2949,17 +3016,16 @@ static void unmap_region(sector_t lba, unsigned int len)
 		if (lba == map_index_to_lba(index) &&
 		    lba + sdebug_unmap_granularity <= end &&
 		    index < map_size) {
-			clear_bit(index, map_storep);
+			clear_bit(index, sip->map_storep);
 			if (sdebug_lbprz) {  /* for LBPRZ=2 return 0xff_s */
-				memset(fake_storep +
-				       lba * sdebug_sector_size,
+				memset(fsp + lba * sdebug_sector_size,
 				       (sdebug_lbprz & 1) ? 0 : 0xff,
 				       sdebug_sector_size *
 				       sdebug_unmap_granularity);
 			}
-			if (dif_storep) {
-				memset(dif_storep + lba, 0xff,
-				       sizeof(*dif_storep) *
+			if (sip->dif_storep) {
+				memset(sip->dif_storep + lba, 0xff,
+				       sizeof(*sip->dif_storep) *
 				       sdebug_unmap_granularity);
 			}
 		}
@@ -2969,13 +3035,15 @@ static void unmap_region(sector_t lba, unsigned int len)
 
 static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
-	u8 *cmd = scp->cmnd;
-	u64 lba;
+	bool check_prot;
 	u32 num;
 	u32 ei_lba;
-	unsigned long iflags;
 	int ret;
-	bool check_prot;
+	unsigned long iflags;
+	u64 lba;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+	u8 *cmd = scp->cmnd;
 
 	switch (cmd[0]) {
 	case WRITE_16:
@@ -3031,23 +3099,23 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(macc_lckp, iflags);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			write_unlock_irqrestore(&atomic_rw, iflags);
+			write_unlock_irqrestore(macc_lckp, iflags);
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
-	ret = do_device_access(scp, 0, lba, num, true);
+	ret = do_device_access(sip, scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
-		map_region(lba, num);
-	write_unlock_irqrestore(&atomic_rw, iflags);
+		map_region(sip, lba, num);
+	write_unlock_irqrestore(macc_lckp, iflags);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3088,6 +3156,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	u8 *cmd = scp->cmnd;
 	u8 *lrdp = NULL;
 	u8 *up;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	u8 wrprotect;
 	u16 lbdof, num_lrd, k;
 	u32 num, num_by, bt_len, lbdof_blen, sg_off, cum_lb;
@@ -3156,7 +3226,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(macc_lckp, iflags);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3199,9 +3269,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 			}
 		}
 
-		ret = do_device_access(scp, sg_off, lba, num, true);
+		ret = do_device_access(sip, scp, sg_off, lba, num, true);
 		if (unlikely(scsi_debug_lbp()))
-			map_region(lba, num);
+			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
 			ret = DID_ERROR << 16;
 			goto err_out_unlock;
@@ -3239,7 +3309,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(macc_lckp, iflags);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3248,27 +3318,32 @@ static int resp_write_scat(struct scsi_cmnd *scp,
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
+	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	u8 *fs1p;
+	u8 *fsp;
 
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(macc_lckp, iflags);
 
 	if (unmap && scsi_debug_lbp()) {
-		unmap_region(lba, num);
+		unmap_region(sip, lba, num);
 		goto out;
 	}
 	lbaa = lba;
 	block = do_div(lbaa, sdebug_store_sectors);
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
-	fs1p = fake_storep + (block * lb_size);
+	fsp = sip->storep;
+	fs1p = fsp + (block * lb_size);
 	if (ndob) {
 		memset(fs1p, 0, lb_size);
 		ret = 0;
@@ -3276,7 +3351,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock_irqrestore(&atomic_rw, iflags);
+		write_unlock_irqrestore(&sip->macc_lck, iflags);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3287,12 +3362,12 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	for (i = 1 ; i < num ; i++) {
 		lbaa = lba + i;
 		block = do_div(lbaa, sdebug_store_sectors);
-		memmove(fake_storep + (block * lb_size), fs1p, lb_size);
+		memmove(fsp + (block * lb_size), fs1p, lb_size);
 	}
 	if (scsi_debug_lbp())
-		map_region(lba, num);
+		map_region(sip, lba, num);
 out:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(macc_lckp, iflags);
 
 	return 0;
 }
@@ -3404,7 +3479,8 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 {
 	u8 *cmd = scp->cmnd;
 	u8 *arr;
-	u8 *fake_storep_hold;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	u64 lba;
 	u32 dnum;
 	u32 lb_size = sdebug_sector_size;
@@ -3438,14 +3514,9 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(macc_lckp, iflags);
 
-	/* trick do_device_access() to fetch both compare and write buffers
-	 * from data-in into arr. Safe (atomic) since write_lock held. */
-	fake_storep_hold = fake_storep;
-	fake_storep = arr;
-	ret = do_device_access(scp, 0, 0, dnum, true);
-	fake_storep = fake_storep_hold;
+	ret = do_dout_fetch(scp, dnum, arr);
 	if (ret == -1) {
 		retval = DID_ERROR << 16;
 		goto cleanup;
@@ -3453,15 +3524,15 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		sdev_printk(KERN_INFO, scp->device, "%s: compare_write: cdb "
 			    "indicated=%u, IO sent=%d bytes\n", my_name,
 			    dnum * lb_size, ret);
-	if (!comp_write_worker(lba, num, arr)) {
+	if (!comp_write_worker(sip, lba, num, arr)) {
 		mk_sense_buffer(scp, MISCOMPARE, MISCOMPARE_VERIFY_ASC, 0);
 		retval = check_condition_result;
 		goto cleanup;
 	}
 	if (scsi_debug_lbp())
-		map_region(lba, num);
+		map_region(sip, lba, num);
 cleanup:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(macc_lckp, iflags);
 	kfree(arr);
 	return retval;
 }
@@ -3476,6 +3547,8 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	unsigned char *buf;
 	struct unmap_block_desc *desc;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
 	unsigned int i, payload_len, descriptors;
 	int ret;
 	unsigned long iflags;
@@ -3506,7 +3579,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock_irqsave(&atomic_rw, iflags);
+	write_lock_irqsave(macc_lckp, iflags);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -3516,13 +3589,13 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		if (ret)
 			goto out;
 
-		unmap_region(lba, num);
+		unmap_region(sip, lba, num);
 	}
 
 	ret = 0;
 
 out:
-	write_unlock_irqrestore(&atomic_rw, iflags);
+	write_unlock_irqrestore(macc_lckp, iflags);
 	kfree(buf);
 
 	return ret;
@@ -3534,10 +3607,11 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 			       struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
+	struct sdeb_store_info *sip = devip2sip(devip);
 	u64 lba;
 	u32 alloc_len, mapped, num;
-	u8 arr[SDEBUG_GET_LBA_STATUS_LEN];
 	int ret;
+	u8 arr[SDEBUG_GET_LBA_STATUS_LEN];
 
 	lba = get_unaligned_be64(cmd + 2);
 	alloc_len = get_unaligned_be32(cmd + 10);
@@ -3550,7 +3624,7 @@ static int resp_get_lba_status(struct scsi_cmnd *scp,
 		return ret;
 
 	if (scsi_debug_lbp())
-		mapped = map_state(lba, &num);
+		mapped = map_state(sip, lba, &num);
 	else {
 		mapped = 1;
 		/* following just in case virtual_gb changed */
@@ -4147,8 +4221,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static void __init sdebug_build_parts(unsigned char *ramp,
-				      unsigned long store_size)
+static void sdebug_build_parts(unsigned char *ramp, unsigned long store_size)
 {
 	struct msdos_partition *pp;
 	int starts[SDEBUG_MAX_PARTS + 2];
@@ -4464,6 +4537,8 @@ module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
 module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
 module_param_named(opts, sdebug_opts, int, S_IRUGO | S_IWUSR);
+module_param_named(per_host_store, sdebug_per_host_store, bool,
+		   S_IRUGO | S_IWUSR);
 module_param_named(physblk_exp, sdebug_physblk_exp, int, S_IRUGO);
 module_param_named(opt_xferlen_exp, sdebug_opt_xferlen_exp, int, S_IRUGO);
 module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
@@ -4525,6 +4600,7 @@ MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
 MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
 MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err... (def=0)");
+MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get new store");
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
@@ -4593,6 +4669,7 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
 	int f, j, l;
 	struct sdebug_queue *sqp;
+	struct sdebug_host_info *sdhp;
 
 	seq_printf(m, "scsi_debug adapter driver, version %s [%s]\n",
 		   SDEBUG_VERSION, sdebug_version_date);
@@ -4628,6 +4705,34 @@ static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 				   "first,last bits", f, l);
 		}
 	}
+
+	seq_printf(m, "this host_no=%d\n", host->host_no);
+	if (!xa_empty(per_store_ap)) {
+		bool niu;
+		int idx;
+		unsigned long l_idx;
+		struct sdeb_store_info *sip;
+
+		seq_puts(m, "\nhost list:\n");
+		j = 0;
+		list_for_each_entry(sdhp, &sdebug_host_list, host_list) {
+			idx = sdhp->si_idx;
+			seq_printf(m, "  %d: host_no=%d, si_idx=%d\n", j,
+				   sdhp->shost->host_no, idx);
+			++j;
+		}
+		seq_printf(m, "\nper_store array [most_recent_idx=%d]:\n",
+			   sdeb_most_recent_idx);
+		j = 0;
+		xa_for_each(per_store_ap, l_idx, sip) {
+			niu = xa_get_mark(per_store_ap, l_idx,
+					  SDEB_XA_NOT_IN_USE);
+			idx = (int)l_idx;
+			seq_printf(m, "  %d: idx=%d%s\n", j, idx,
+				   (niu ? "  not_in_use" : ""));
+			++j;
+		}
+	}
 	return 0;
 }
 
@@ -4783,25 +4888,41 @@ static ssize_t fake_rw_show(struct device_driver *ddp, char *buf)
 static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 			     size_t count)
 {
-	int n;
+	int n, idx;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		bool want_store = (n == 0);
+		struct sdebug_host_info *sdhp;
+
 		n = (n > 0);
 		sdebug_fake_rw = (sdebug_fake_rw > 0);
-		if (sdebug_fake_rw != n) {
-			if ((0 == n) && (NULL == fake_storep)) {
-				unsigned long sz =
-					(unsigned long)sdebug_dev_size_mb *
-					1048576;
-
-				fake_storep = vzalloc(sz);
-				if (NULL == fake_storep) {
-					pr_err("out of memory, 9\n");
-					return -ENOMEM;
+		if (sdebug_fake_rw == n)
+			return count;	/* not transitioning so do nothing */
+
+		if (want_store) {	/* 1 --> 0 transition, set up store */
+			if (sdeb_first_idx < 0) {
+				idx = sdebug_add_store();
+				if (idx < 0)
+					return idx;
+			} else {
+				idx = sdeb_first_idx;
+				xa_clear_mark(per_store_ap, idx,
+					      SDEB_XA_NOT_IN_USE);
+			}
+			/* make all hosts use same store */
+			list_for_each_entry(sdhp, &sdebug_host_list,
+					    host_list) {
+				if (sdhp->si_idx != idx) {
+					xa_set_mark(per_store_ap, sdhp->si_idx,
+						    SDEB_XA_NOT_IN_USE);
+					sdhp->si_idx = idx;
 				}
 			}
-			sdebug_fake_rw = n;
+			sdeb_most_recent_idx = idx;
+		} else {	/* 0 --> 1 transition is trigger for shrink */
+			sdebug_erase_all_stores(true /* apart from first */);
 		}
+		sdebug_fake_rw = n;
 		return count;
 	}
 	return -EINVAL;
@@ -4849,6 +4970,26 @@ static ssize_t dev_size_mb_show(struct device_driver *ddp, char *buf)
 }
 static DRIVER_ATTR_RO(dev_size_mb);
 
+static ssize_t per_host_store_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_per_host_store);
+}
+
+static ssize_t per_host_store_store(struct device_driver *ddp, const char *buf,
+				    size_t count)
+{
+	int n;
+
+	if (count > 0 && kstrtoint(buf, 10, &n) == 0 && n >= 0) {
+		if (sdebug_per_host_store == (n > 0))
+			return count;	/* no state change */
+		sdebug_per_host_store = (n > 0);
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(per_host_store);
+
 static ssize_t num_parts_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_parts);
@@ -5001,26 +5142,42 @@ static DRIVER_ATTR_RW(virtual_gb);
 
 static ssize_t add_host_show(struct device_driver *ddp, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_add_host);
+	/* absolute number of hosts currently active is what is shown */
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_num_hosts);
 }
 
-static int sdebug_add_adapter(void);
-static void sdebug_remove_adapter(void);
-
 static ssize_t add_host_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
 {
+	bool found;
+	unsigned long idx;
+	struct sdeb_store_info *sip;
+	bool want_phs = (sdebug_fake_rw == 0) && sdebug_per_host_store;
 	int delta_hosts;
 
 	if (sscanf(buf, "%d", &delta_hosts) != 1)
 		return -EINVAL;
 	if (delta_hosts > 0) {
 		do {
-			sdebug_add_adapter();
+			found = false;
+			if (want_phs) {
+				xa_for_each_marked(per_store_ap, idx, sip,
+						   SDEB_XA_NOT_IN_USE) {
+					sdeb_most_recent_idx = (int)idx;
+					found = true;
+					break;
+				}
+				if (found)	/* re-use case */
+					sdebug_add_host_helper((int)idx);
+				else
+					sdebug_do_add_host(true);
+			} else {
+				sdebug_do_add_host(false);
+			}
 		} while (--delta_hosts);
 	} else if (delta_hosts < 0) {
 		do {
-			sdebug_remove_adapter();
+			sdebug_do_remove_host(false);
 		} while (++delta_hosts);
 	}
 	return count;
@@ -5104,14 +5261,19 @@ static DRIVER_ATTR_RO(ato);
 
 static ssize_t map_show(struct device_driver *ddp, char *buf)
 {
-	ssize_t count;
+	ssize_t count = 0;
 
 	if (!scsi_debug_lbp())
 		return scnprintf(buf, PAGE_SIZE, "0-%u\n",
 				 sdebug_store_sectors);
 
-	count = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
-			  (int)map_size, map_storep);
+	if (sdebug_fake_rw == 0 && !xa_empty(per_store_ap)) {
+		struct sdeb_store_info *sip = xa_load(per_store_ap, 0);
+
+		if (sip)
+			count = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+					  (int)map_size, sip->map_storep);
+	}
 	buf[count++] = '\n';
 	buf[count] = '\0';
 
@@ -5218,7 +5380,7 @@ static DRIVER_ATTR_RW(cdb_len);
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
    directory) is that auxiliary actions can be triggered when an attribute
-   is changed. For example see: sdebug_add_host_store() above.
+   is changed. For example see: add_host_store() above.
  */
 
 static struct attribute *sdebug_drv_attrs[] = {
@@ -5238,6 +5400,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_scsi_level.attr,
 	&driver_attr_virtual_gb.attr,
 	&driver_attr_add_host.attr,
+	&driver_attr_per_host_store.attr,
 	&driver_attr_vpd_use_hostno.attr,
 	&driver_attr_sector_size.attr,
 	&driver_attr_statistics.attr,
@@ -5262,11 +5425,13 @@ static struct device *pseudo_primary;
 
 static int __init scsi_debug_init(void)
 {
+	bool want_store = (sdebug_fake_rw == 0);
 	unsigned long sz;
-	int host_to_add;
-	int k;
-	int ret;
+	int k, ret, hosts_to_add;
+	int idx = -1;
 
+	ramdisk_lck_a[0] = &atomic_rw;
+	ramdisk_lck_a[1] = &atomic_rw2;
 	atomic_set(&retired_max_queue, 0);
 
 	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
@@ -5362,36 +5527,6 @@ static int __init scsi_debug_init(void)
 		sdebug_cylinders_per = (unsigned long)sdebug_capacity /
 			       (sdebug_sectors_per * sdebug_heads);
 	}
-
-	if (sdebug_fake_rw == 0) {
-		fake_storep = vzalloc(sz);
-		if (NULL == fake_storep) {
-			pr_err("out of memory, 1\n");
-			ret = -ENOMEM;
-			goto free_q_arr;
-		}
-		if (sdebug_num_parts > 0)
-			sdebug_build_parts(fake_storep, sz);
-	}
-
-	if (sdebug_dix) {
-		int dif_size;
-
-		dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
-		dif_storep = vmalloc(dif_size);
-
-		pr_err("dif_storep %u bytes @ %p\n", dif_size, dif_storep);
-
-		if (dif_storep == NULL) {
-			pr_err("out of mem. (DIX)\n");
-			ret = -ENOMEM;
-			goto free_vm;
-		}
-
-		memset(dif_storep, 0xff, dif_size);
-	}
-
-	/* Logical Block Provisioning */
 	if (scsi_debug_lbp()) {
 		sdebug_unmap_max_blocks =
 			clamp(sdebug_unmap_max_blocks, 0U, 0xffffffffU);
@@ -5407,26 +5542,16 @@ static int __init scsi_debug_init(void)
 		    sdebug_unmap_alignment) {
 			pr_err("ERR: unmap_granularity <= unmap_alignment\n");
 			ret = -EINVAL;
-			goto free_vm;
+			goto free_q_arr;
 		}
-
-		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
-		map_storep = vmalloc(array_size(sizeof(long),
-						BITS_TO_LONGS(map_size)));
-
-		pr_info("%lu provisioning blocks\n", map_size);
-
-		if (map_storep == NULL) {
-			pr_err("out of mem. (MAP)\n");
-			ret = -ENOMEM;
-			goto free_vm;
+	}
+	xa_init_flags(per_store_ap, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
+	if (want_store) {
+		idx = sdebug_add_store();
+		if (idx < 0) {
+			ret = idx;
+			goto free_q_arr;
 		}
-
-		bitmap_zero(map_storep, map_size);
-
-		/* Map first 1KB for partition table */
-		if (sdebug_num_parts)
-			map_region(0, 2);
 	}
 
 	pseudo_primary = root_device_register("pseudo_0");
@@ -5446,18 +5571,28 @@ static int __init scsi_debug_init(void)
 		goto bus_unreg;
 	}
 
-	host_to_add = sdebug_add_host;
+	hosts_to_add = sdebug_add_host;
 	sdebug_add_host = 0;
 
-	for (k = 0; k < host_to_add; k++) {
-		if (sdebug_add_adapter()) {
-			pr_err("sdebug_add_adapter failed k=%d\n", k);
-			break;
+	for (k = 0; k < hosts_to_add; k++) {
+		if (want_store && k == 0) {
+			ret = sdebug_add_host_helper(idx);
+			if (ret < 0) {
+				pr_err("add_host_helper k=%d, error=%d\n",
+				       k, -ret);
+				break;
+			}
+		} else {
+			ret = sdebug_do_add_host(want_store &&
+						 sdebug_per_host_store);
+			if (ret < 0) {
+				pr_err("add_host k=%d error=%d\n", k, -ret);
+				break;
+			}
 		}
 	}
-
 	if (sdebug_verbose)
-		pr_info("built %d host(s)\n", sdebug_add_host);
+		pr_info("built %d host(s)\n", sdebug_num_hosts);
 
 	return 0;
 
@@ -5466,9 +5601,7 @@ static int __init scsi_debug_init(void)
 dev_unreg:
 	root_device_unregister(pseudo_primary);
 free_vm:
-	vfree(map_storep);
-	vfree(dif_storep);
-	vfree(fake_storep);
+	sdebug_erase_store(idx, NULL);
 free_q_arr:
 	kfree(sdebug_q_arr);
 	return ret;
@@ -5476,20 +5609,18 @@ static int __init scsi_debug_init(void)
 
 static void __exit scsi_debug_exit(void)
 {
-	int k = sdebug_add_host;
+	int k = sdebug_num_hosts;
 
 	stop_all_queued();
 	for (; k; k--)
-		sdebug_remove_adapter();
+		sdebug_do_remove_host(true);
 	free_all_queued();
 	driver_unregister(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
 	root_device_unregister(pseudo_primary);
 
-	vfree(map_storep);
-	vfree(dif_storep);
-	vfree(fake_storep);
-	kfree(sdebug_q_arr);
+	sdebug_erase_all_stores(false);
+	xa_destroy(per_store_ap);
 }
 
 device_initcall(scsi_debug_init);
@@ -5503,29 +5634,146 @@ static void sdebug_release_adapter(struct device *dev)
 	kfree(sdbg_host);
 }
 
-static int sdebug_add_adapter(void)
+/* idx must be valid, if sip is NULL then it will be obtained using idx */
+static void sdebug_erase_store(int idx, struct sdeb_store_info *sip)
 {
-	int k, devs_per_host;
-	int error = 0;
+	if (idx < 0)
+		return;
+	if (!sip) {
+		if (xa_empty(per_store_ap))
+			return;
+		sip = xa_load(per_store_ap, idx);
+		if (!sip)
+			return;
+	}
+	vfree(sip->map_storep);
+	vfree(sip->dif_storep);
+	vfree(sip->storep);
+	xa_erase(per_store_ap, idx);
+	kfree(sip);
+}
+
+/* Assume apart_from_first==false only in shutdown case. */
+static void sdebug_erase_all_stores(bool apart_from_first)
+{
+	unsigned long idx;
+	struct sdeb_store_info *sip = NULL;
+
+	xa_for_each(per_store_ap, idx, sip) {
+		if (apart_from_first)
+			apart_from_first = false;
+		else
+			sdebug_erase_store(idx, sip);
+	}
+	if (apart_from_first)
+		sdeb_most_recent_idx = sdeb_first_idx;
+}
+
+/*
+ * Returns store xarray new element index (idx) if >=0 else negated errno.
+ * Limit the number of stores to 65536.
+ */
+static int sdebug_add_store(void)
+{
+	int res;
+	u32 n_idx;
+	unsigned long iflags;
+	unsigned long sz = (unsigned long)sdebug_dev_size_mb * 1048576;
+	struct sdeb_store_info *sip = NULL;
+	struct xa_limit xal = { .max = 1 << 16, .min = 0 };
+
+	sip = kzalloc(sizeof(*sip), GFP_KERNEL);
+	if (!sip)
+		return -ENOMEM;
+
+	xa_lock_irqsave(per_store_ap, iflags);
+	res = __xa_alloc(per_store_ap, &n_idx, sip, xal, GFP_ATOMIC);
+	if (unlikely(res < 0)) {
+		xa_unlock_irqrestore(per_store_ap, iflags);
+		kfree(sip);
+		pr_warn("%s: xa_alloc() errno=%d\n", __func__, -res);
+		return res;
+	}
+	sdeb_most_recent_idx = n_idx;
+	if (sdeb_first_idx < 0)
+		sdeb_first_idx = n_idx;
+	xa_unlock_irqrestore(per_store_ap, iflags);
+
+	res = -ENOMEM;
+	sip->storep = vzalloc(sz);
+	if (!sip->storep) {
+		pr_err("user data oom\n");
+		goto err;
+	}
+	if (sdebug_num_parts > 0)
+		sdebug_build_parts(sip->storep, sz);
+
+	/* DIF/DIX: what T10 calls Protection Information (PI) */
+	if (sdebug_dix) {
+		int dif_size;
+
+		dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
+		sip->dif_storep = vmalloc(dif_size);
+
+		pr_info("dif_storep %u bytes @ %pK\n", dif_size,
+			sip->dif_storep);
+
+		if (!sip->dif_storep) {
+			pr_err("DIX oom\n");
+			goto err;
+		}
+		memset(sip->dif_storep, 0xff, dif_size);
+	}
+	/* Logical Block Provisioning */
+	if (scsi_debug_lbp()) {
+		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
+		sip->map_storep = vmalloc(array_size(sizeof(long),
+						     BITS_TO_LONGS(map_size)));
+
+		pr_info("%lu provisioning blocks\n", map_size);
+
+		if (!sip->map_storep) {
+			pr_err("LBP map oom\n");
+			goto err;
+		}
+
+		bitmap_zero(sip->map_storep, map_size);
+
+		/* Map first 1KB for partition table */
+		if (sdebug_num_parts)
+			map_region(sip, 0, 2);
+	}
+
+	rwlock_init(&sip->macc_lck);
+	return (int)n_idx;
+err:
+	sdebug_erase_store((int)n_idx, sip);
+	pr_warn("%s: failed, errno=%d\n", __func__, -res);
+	return res;
+}
+
+static int sdebug_add_host_helper(int per_host_idx)
+{
+	int k, devs_per_host, idx;
+	int error = -ENOMEM;
 	struct sdebug_host_info *sdbg_host;
 	struct sdebug_dev_info *sdbg_devinfo, *tmp;
 
 	sdbg_host = kzalloc(sizeof(*sdbg_host), GFP_KERNEL);
-	if (sdbg_host == NULL) {
-		pr_err("out of memory at line %d\n", __LINE__);
+	if (!sdbg_host)
 		return -ENOMEM;
-	}
+	idx = (per_host_idx < 0) ? sdeb_first_idx : per_host_idx;
+	if (xa_get_mark(per_store_ap, idx, SDEB_XA_NOT_IN_USE))
+		xa_clear_mark(per_store_ap, idx, SDEB_XA_NOT_IN_USE);
+	sdbg_host->si_idx = idx;
 
 	INIT_LIST_HEAD(&sdbg_host->dev_info_list);
 
 	devs_per_host = sdebug_num_tgts * sdebug_max_luns;
 	for (k = 0; k < devs_per_host; k++) {
 		sdbg_devinfo = sdebug_device_create(sdbg_host, GFP_KERNEL);
-		if (!sdbg_devinfo) {
-			pr_err("out of memory at line %d\n", __LINE__);
-			error = -ENOMEM;
+		if (!sdbg_devinfo)
 			goto clean;
-		}
 	}
 
 	spin_lock(&sdebug_host_list_lock);
@@ -5535,15 +5783,14 @@ static int sdebug_add_adapter(void)
 	sdbg_host->dev.bus = &pseudo_lld_bus;
 	sdbg_host->dev.parent = pseudo_primary;
 	sdbg_host->dev.release = &sdebug_release_adapter;
-	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_add_host);
+	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
 
 	error = device_register(&sdbg_host->dev);
-
 	if (error)
 		goto clean;
 
-	++sdebug_add_host;
-	return error;
+	++sdebug_num_hosts;
+	return 0;
 
 clean:
 	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
@@ -5551,28 +5798,61 @@ static int sdebug_add_adapter(void)
 		list_del(&sdbg_devinfo->dev_list);
 		kfree(sdbg_devinfo);
 	}
-
 	kfree(sdbg_host);
+	pr_warn("%s: failed, errno=%d\n", __func__, -error);
 	return error;
 }
 
-static void sdebug_remove_adapter(void)
+static int sdebug_do_add_host(bool mk_new_store)
 {
+	int ph_idx = sdeb_most_recent_idx;
+
+	if (mk_new_store) {
+		ph_idx = sdebug_add_store();
+		if (ph_idx < 0)
+			return ph_idx;
+	}
+	return sdebug_add_host_helper(ph_idx);
+}
+
+static void sdebug_do_remove_host(bool the_end)
+{
+	int idx = -1;
 	struct sdebug_host_info *sdbg_host = NULL;
+	struct sdebug_host_info *sdbg_host2;
 
 	spin_lock(&sdebug_host_list_lock);
 	if (!list_empty(&sdebug_host_list)) {
 		sdbg_host = list_entry(sdebug_host_list.prev,
 				       struct sdebug_host_info, host_list);
-		list_del(&sdbg_host->host_list);
+		idx = sdbg_host->si_idx;
 	}
+	if (!the_end && idx >= 0) {
+		bool unique = true;
+
+		list_for_each_entry(sdbg_host2, &sdebug_host_list, host_list) {
+			if (sdbg_host2 == sdbg_host)
+				continue;
+			if (idx == sdbg_host2->si_idx) {
+				unique = false;
+				break;
+			}
+		}
+		if (unique) {
+			xa_set_mark(per_store_ap, idx, SDEB_XA_NOT_IN_USE);
+			if (idx == sdeb_most_recent_idx)
+				--sdeb_most_recent_idx;
+		}
+	}
+	if (sdbg_host)
+		list_del(&sdbg_host->host_list);
 	spin_unlock(&sdebug_host_list_lock);
 
 	if (!sdbg_host)
 		return;
 
 	device_unregister(&sdbg_host->dev);
-	--sdebug_add_host;
+	--sdebug_num_hosts;
 }
 
 static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
@@ -5631,6 +5911,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	const struct opcode_info_t *oip;
 	const struct opcode_info_t *r_oip;
 	struct sdebug_dev_info *devip;
+
 	u8 *cmd = scp->cmnd;
 	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
 	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
@@ -5902,8 +6183,9 @@ static int sdebug_driver_probe(struct device *dev)
 		pr_err("scsi_add_host failed\n");
 		error = -ENODEV;
 		scsi_host_put(hpnt);
-	} else
+	} else {
 		scsi_scan_host(hpnt);
+	}
 
 	return error;
 }
-- 
2.26.1

