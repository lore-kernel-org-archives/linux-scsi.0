Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD95C35DF7
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B0C324670
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 06:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgBYGYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 01:24:14 -0500
Received: from smtp.infotech.no ([82.134.31.41]:36129 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbgBYGYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Feb 2020 01:24:13 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 27BBD20425C;
        Tue, 25 Feb 2020 07:24:12 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Oy0QfJ2b+-rT; Tue, 25 Feb 2020 07:24:08 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id DD3DC204258;
        Tue, 25 Feb 2020 07:24:05 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com, Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v4 08/14] scsi_debug: add zone commands
Date:   Tue, 25 Feb 2020 01:23:45 -0500
Message-Id: <20200225062351.21267-9-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225062351.21267-1-dgilbert@interlog.com>
References: <20200225062351.21267-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add support for the 5 ZBC commands and enough functionality to emulate
a host-managed device with one conventional and a set of sequential
write required zones up to the disk capacity.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 832 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 791 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5a720d2a14c4..0e2e0d35af7e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -91,6 +91,11 @@ static const char *sdebug_version_date = "20190125";
 #define MICROCODE_CHANGED_ASCQ 0x1	/* with TARGET_CHANGED_ASC */
 #define MICROCODE_CHANGED_WO_RESET_ASCQ 0x16
 #define WRITE_ERROR_ASC 0xc
+#define UNALIGNED_WRITE_ASCQ 0x4
+#define WRITE_BOUNDARY_ASCQ 0x5
+#define READ_INVDATA_ASCQ 0x6
+#define READ_BOUNDARY_ASCQ 0x7
+#define INSUFF_ZONE_ASCQ 0xe
 
 /* Additional Sense Code Qualifier (ASCQ) */
 #define ACK_NAK_TO 0x3
@@ -144,6 +149,10 @@ static const char *sdebug_version_date = "20190125";
 #define DEF_UUID_CTL 0
 #define JDELAY_OVERRIDDEN -9999
 
+/* Default parameters for ZBC drives */
+#define DEF_ZBC_ZONE_SIZE_MB	128
+#define DEF_ZBC_MAX_OPEN_ZONES	8
+
 #define SDEBUG_LUN_0_VAL 0
 
 /* bit mask values for sdebug_opts */
@@ -245,6 +254,23 @@ static const char *sdebug_version_date = "20190125";
 
 #define SDEBUG_MAX_CMD_LEN 32
 
+enum sdebug_z_cond {	/* enumeration names taken from table 12, zbc2r04 */
+	ZBC_NOT_WRITE_POINTER = 0x0, /* not in table 12; conventional zone */
+	ZC1_EMPTY = 0x1,
+	ZC2_IMPLICIT_OPEN,
+	ZC3_EXPLICIT_OPEN,
+	ZC4_CLOSED,
+	ZC5_FULL = 0xe,	/* values per Zone Condition field in Report Zones */
+	ZC6_READ_ONLY = 0xd,
+	ZC7_OFFLINE = 0xf,
+};
+
+struct sdeb_zone_state {	/* ZBC: per zone state */
+	enum sdebug_z_cond z_cond;
+	unsigned int z_size;
+	sector_t z_start;
+	sector_t z_wp;
+};
 
 struct sdebug_dev_info {
 	struct list_head dev_list;
@@ -258,6 +284,16 @@ struct sdebug_dev_info {
 	atomic_t stopped;
 	int sdg_devnum;
 	bool used;
+
+	/* For ZBC devices */
+	sector_t zsize;
+	sector_t zsize_shift;
+	unsigned int nr_zones;
+	unsigned int nr_imp_open;
+	unsigned int nr_exp_open;
+	unsigned int nr_closed;
+	unsigned int max_open;
+	struct sdeb_zone_state *zstate;
 };
 
 struct sdebug_host_info {
@@ -356,10 +392,11 @@ enum sdeb_opcode_index {
 	SDEB_I_SYNC_CACHE = 27,		/* 10, 16 */
 	SDEB_I_COMP_WRITE = 28,
 	SDEB_I_PRE_FETCH = 29,		/* 10, 16 */
-	SDEB_I_LAST_ELEM_P1 = 30,	/* keep this last (previous + 1) */
+	SDEB_I_ZONE_OUT = 30,		/* 0x94+SA; includes no data xfer */
+	SDEB_I_ZONE_IN = 31,		/* 0x95+SA; all have data-in */
+	SDEB_I_LAST_ELEM_P1 = 32,	/* keep this last (previous + 1) */
 };
 
-
 static const unsigned char opcode_ind_arr[256] = {
 /* 0x0; 0x0->0x1f: 6 byte cdbs */
 	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
@@ -388,7 +425,8 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
 	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0,
 	0, 0, 0, SDEB_I_VERIFY,
-	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
+	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME,
+	SDEB_I_ZONE_OUT, SDEB_I_ZONE_IN, 0, 0,
 	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
@@ -436,6 +474,11 @@ static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_pre_fetch(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_rep_zones(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_open_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_close_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 /*
  * The following are overflow arrays for cdbs that "hit" the same index in
@@ -523,16 +566,34 @@ static const struct opcode_info_t release_iarr[] = {
 
 static const struct opcode_info_t sync_cache_iarr[] = {
 	{0, 0x91, 0, F_SYNC_DELAY | F_M_ACCESS, resp_sync_cache, NULL,
-	    {16,  0x6, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	    {16, 0x6, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* SYNC_CACHE (16) */
 };
 
 static const struct opcode_info_t pre_fetch_iarr[] = {
 	{0, 0x90, 0, F_SYNC_DELAY | F_M_ACCESS, resp_pre_fetch, NULL,
-	    {16,  0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	    {16, 0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
 	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} },	/* PRE-FETCH (16) */
 };
 
+static const struct opcode_info_t zone_out_iarr[] = {	/* ZONE OUT(16) */
+	{0, 0x94, 0x1, F_SA_LOW, resp_close_zone, NULL,
+	    {16, 0x1, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0, 0, 0xff, 0xff, 0x1, 0xc7} },	/* CLOSE ZONE */
+	{0, 0x94, 0x2, F_SA_LOW, resp_finish_zone, NULL,
+	    {16, 0x2, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0, 0, 0xff, 0xff, 0x1, 0xc7} },	/* FINISH ZONE */
+	{0, 0x94, 0x4, F_SA_LOW, resp_rwp_zone, NULL,
+	    {16, 0x4, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0, 0, 0xff, 0xff, 0x1, 0xc7} },  /* RESET WRITE POINTER */
+};
+
+static const struct opcode_info_t zone_in_iarr[] = {	/* ZONE IN(16) */
+	{0, 0x95, 0x6, F_SA_LOW | F_D_IN, NULL, NULL,
+	    {16, 0x6, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} }, /* REPORT REALMS */
+};
+
 
 /* This array is accessed via SDEB_I_* values. Make sure all are mapped,
  * plus the terminating elements for logic that scans this table such as
@@ -635,6 +696,15 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
 
 /* 30 */
+	{ARRAY_SIZE(zone_out_iarr), 0x94, 0x3, F_SA_LOW,
+	    resp_open_zone, zone_out_iarr, /* ZONE_OUT(16), OPEN ZONE) */
+		{16,  0x3 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		 0xff, 0xff, 0x0, 0x0, 0xff, 0xff, 0x1, 0xc7} },
+	{ARRAY_SIZE(zone_in_iarr), 0x95, 0x0, F_SA_LOW | F_D_IN,
+	    resp_rep_zones, zone_in_iarr, /* ZONE_IN(16), REPORT ZONES) */
+		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
+/* sentinel */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
@@ -720,6 +790,11 @@ static int dix_writes;
 static int dix_reads;
 static int dif_errors;
 
+/* ZBC global data */
+static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
+static const int zbc_zone_size_mb;
+static const int zbc_max_open_zones = DEF_ZBC_MAX_OPEN_ZONES;
+
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
 
@@ -1417,20 +1492,22 @@ static int inquiry_vpd_b2(unsigned char *arr)
 }
 
 /* Zoned block device characteristics VPD page (ZBC mandatory) */
-static int inquiry_vpd_b6(unsigned char *arr)
+static int inquiry_vpd_b6(struct sdebug_dev_info *devip, unsigned char *arr)
 {
 	memset(arr, 0, 0x3c);
 	arr[0] = 0x1; /* set URSWRZ (unrestricted read in seq. wr req zone) */
 	/*
 	 * Set Optimal number of open sequential write preferred zones and
 	 * Optimal number of non-sequentially written sequential write
-	 * preferred zones and Maximum number of open sequential write
-	 * required zones fields to 'not reported' (0xffffffff). Leave other
-	 * fields set to zero.
+	 * preferred zones fields to 'not reported' (0xffffffff). Leave other
+	 * fields set to zero, apart from Max. number of open swrz_s field.
 	 */
 	put_unaligned_be32(0xffffffff, &arr[4]);
 	put_unaligned_be32(0xffffffff, &arr[8]);
-	put_unaligned_be32(0xffffffff, &arr[12]);
+	if (devip->max_open)
+		put_unaligned_be32(devip->max_open, &arr[12]);
+	else
+		put_unaligned_be32(0xffffffff, &arr[12]);
 	return 0x3c;
 }
 
@@ -1550,7 +1627,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[3] = inquiry_vpd_b2(&arr[4]);
 		} else if (is_zbc && cmd[2] == 0xb6) { /* ZB dev. charact. */
 			arr[1] = cmd[2];        /*sanity */
-			arr[3] = inquiry_vpd_b6(&arr[4]);
+			arr[3] = inquiry_vpd_b6(devip, &arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 			kfree(arr);
@@ -2521,9 +2598,110 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
+/* acc_num is modulo 2 as that is how it is used */
+static int scp2acc_num(struct scsi_cmnd *scp)
+{
+	if (sdebug_doublestore) {
+		struct scsi_device *sdp = scp->device;
+		struct sdebug_dev_info *devip =
+				(struct sdebug_dev_info *)sdp->hostdata;
+
+		return devip->sdg_devnum % 2;
+	}
+	return 0;
+}
+
+static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
+{
+	return devip->nr_zones != 0;
+}
+
+static struct sdeb_zone_state *zbc_zone(unsigned long long lba,
+					struct sdebug_dev_info *devip)
+{
+	return &devip->zstate[lba >> devip->zsize_shift];
+}
+
+static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
+{
+	return zsp->z_cond == ZBC_NOT_WRITE_POINTER;
+}
+
+static void zbc_close_zone(struct sdebug_dev_info *devip,
+			   struct sdeb_zone_state *zsp)
+{
+	enum sdebug_z_cond zc;
+
+	if (zbc_zone_is_conv(zsp))
+		return;
+
+	zc = zsp->z_cond;
+	if (!(zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN))
+		return;
+
+	if (zc == ZC2_IMPLICIT_OPEN)
+		devip->nr_imp_open--;
+	else
+		devip->nr_exp_open--;
+
+	if (zsp->z_wp == zsp->z_start) {
+		zsp->z_cond = ZC1_EMPTY;
+	} else {
+		zsp->z_cond = ZC4_CLOSED;
+		devip->nr_closed++;
+	}
+}
+
+static void zbc_close_imp_open_zone(struct sdebug_dev_info *devip)
+{
+	struct sdeb_zone_state *zsp = &devip->zstate[0];
+	unsigned int i;
+
+	for (i = 0; i < devip->nr_zones; i++, zsp++) {
+		if (zsp->z_cond == ZC2_IMPLICIT_OPEN) {
+			zbc_close_zone(devip, zsp);
+			return;
+		}
+	}
+}
+
+static void zbc_open_zone(struct sdebug_dev_info *devip,
+			  struct sdeb_zone_state *zsp, bool explicit)
+{
+	enum sdebug_z_cond zc;
+
+	if (zbc_zone_is_conv(zsp))
+		return;
+
+	zc = zsp->z_cond;
+	if ((explicit && zc == ZC3_EXPLICIT_OPEN) ||
+	    (!explicit && zc == ZC2_IMPLICIT_OPEN))
+		return;
+
+	/* Close an implicit open zone if necessary */
+	if (explicit && zsp->z_cond == ZC2_IMPLICIT_OPEN)
+		zbc_close_zone(devip, zsp);
+	else if (devip->max_open &&
+		 devip->nr_imp_open + devip->nr_exp_open >= devip->max_open)
+		zbc_close_imp_open_zone(devip);
+
+	if (zsp->z_cond == ZC4_CLOSED)
+		devip->nr_closed--;
+	if (explicit) {
+		zsp->z_cond = ZC3_EXPLICIT_OPEN;
+		devip->nr_exp_open++;
+	} else {
+		zsp->z_cond = ZC2_IMPLICIT_OPEN;
+		devip->nr_imp_open++;
+	}
+}
+
 static inline int check_device_access_params(struct scsi_cmnd *scp,
 	unsigned long long lba, unsigned int num, bool write)
 {
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
+
 	if (lba + num > sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
@@ -2538,17 +2716,58 @@ static inline int check_device_access_params(struct scsi_cmnd *scp,
 		mk_sense_buffer(scp, DATA_PROTECT, WRITE_PROTECTED, 0x2);
 		return check_condition_result;
 	}
-	return 0;
-}
 
-static int scp2acc_num(struct scsi_cmnd *scp)
-{
-	if (sdebug_doublestore) {
-		struct scsi_device *sdp = scp->device;
-		struct sdebug_dev_info *devip =
-				(struct sdebug_dev_info *)sdp->hostdata;
+	if (sdebug_dev_is_zoned(devip)) {
+		struct sdeb_zone_state *zsp = zbc_zone(lba, devip);
+		struct sdeb_zone_state *zsp_end =
+			zbc_zone(lba + num - 1, devip);
 
-		return devip->sdg_devnum;
+		if (write) {
+			/* No restrictions for writes within conv zones */
+			if (zbc_zone_is_conv(zsp)) {
+				if (zbc_zone_is_conv(zsp_end))
+					return 0;
+			}
+			/* Writes cannot cross sequential zone boundaries */
+			if (zsp_end != zsp) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+						LBA_OUT_OF_RANGE,
+						WRITE_BOUNDARY_ASCQ);
+				return check_condition_result;
+			}
+			/* Cannot write full zones */
+			if (zsp->z_cond == ZC5_FULL) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+						INVALID_FIELD_IN_CDB, 0);
+				return check_condition_result;
+			}
+			/* Writes must be aligned to the zone WP */
+			if (lba != zsp->z_wp) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST,
+						LBA_OUT_OF_RANGE,
+						UNALIGNED_WRITE_ASCQ);
+				return check_condition_result;
+			}
+			/* Handle implicit open of closed and empty zones */
+			if (zsp->z_cond == ZC1_EMPTY ||
+			    zsp->z_cond == ZC4_CLOSED) {
+				if (devip->max_open &&
+				    devip->nr_exp_open >= devip->max_open) {
+					mk_sense_buffer(scp, DATA_PROTECT,
+							INSUFF_RES_ASC,
+							INSUFF_ZONE_ASCQ);
+					return check_condition_result;
+				}
+				zbc_open_zone(devip, zsp, false);
+			}
+		} else if (zsp_end != zsp &&
+			   zbc_zone_is_conv(zsp) &&
+			   !zbc_zone_is_conv(zsp_end)) {
+			/* Reads cannot cross zone types boundaries */
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE, READ_INVDATA_ASCQ);
+			return check_condition_result;
+		}
 	}
 	return 0;
 }
@@ -2574,7 +2793,7 @@ static int do_device_access(struct scsi_cmnd *scmd, u32 sg_skip, u64 lba,
 		return 0;
 	if (scmd->sc_data_direction != dir)
 		return -1;
-	fsp = fake_store_a[scp2acc_num(scmd) % 2];
+	fsp = fake_store_a[scp2acc_num(scmd)];
 
 	block = do_div(lba, sdebug_store_sectors);
 	if (block + num > sdebug_store_sectors)
@@ -2625,7 +2844,7 @@ static bool comp_write_worker(u64 lba, u32 num, const u8 *arr, int acc_num,
 	if (block + num > store_blks)
 		rest = block + num - store_blks;
 
-	fsp = fake_store_a[acc_num % 2];
+	fsp = fake_store_a[acc_num];
 
 	res = !memcmp(fsp + (block * lb_size), arr, (num - rest) * lb_size);
 	if (!res)
@@ -2847,21 +3066,21 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 
-	read_lock(ramdisk_lck_a[acc_num % 2]);
+	read_lock(ramdisk_lck_a[acc_num]);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_read(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			read_unlock(ramdisk_lck_a[acc_num % 2]);
+			read_unlock(ramdisk_lck_a[acc_num]);
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
 	}
 
 	ret = do_device_access(scp, 0, lba, num, false);
-	read_unlock(ramdisk_lck_a[acc_num % 2]);
+	read_unlock(ramdisk_lck_a[acc_num]);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
 
@@ -3036,7 +3255,7 @@ static void map_region(sector_t lba, unsigned int len)
 static void unmap_region(sector_t lba, unsigned int len, int acc_num)
 {
 	sector_t end = lba + len;
-	u8 *fsp = fake_store_a[acc_num % 2];
+	u8 *fsp = fake_store_a[acc_num];
 
 	while (lba < end) {
 		unsigned long index = lba_to_map_index(lba);
@@ -3125,14 +3344,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = check_device_access_params(scp, lba, num, true);
 	if (ret)
 		return ret;
-	write_lock(ramdisk_lck_a[acc_num % 2]);
+	write_lock(ramdisk_lck_a[acc_num]);
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
 		int prot_ret = prot_verify_write(scp, lba, num, ei_lba);
 
 		if (prot_ret) {
-			write_unlock(ramdisk_lck_a[acc_num % 2]);
+			write_unlock(ramdisk_lck_a[acc_num]);
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, prot_ret);
 			return illegal_condition_result;
 		}
@@ -3141,7 +3360,17 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(lba, num);
-	write_unlock(ramdisk_lck_a[acc_num % 2]);
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip)) {
+		struct sdeb_zone_state *zsp = zbc_zone(lba, devip);
+
+		if (!zbc_zone_is_conv(zsp)) {
+			zsp->z_wp += num;
+			if (zsp->z_wp >= zsp->z_start + zsp->z_size)
+				zsp->z_cond = ZC5_FULL;
+		}
+	}
+	write_unlock(ramdisk_lck_a[acc_num]);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
 	else if (unlikely(sdebug_verbose &&
@@ -3250,7 +3479,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		goto err_out;
 	}
 
-	write_lock(ramdisk_lck_a[acc_num % 2]);
+	write_lock(ramdisk_lck_a[acc_num]);
 	sg_off = lbdof_blen;
 	/* Spec says Buffer xfer Length field in number of LBs in dout */
 	cum_lb = 0;
@@ -3294,6 +3523,16 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		}
 
 		ret = do_device_access(scp, sg_off, lba, num, true);
+		/* If ZBC zone then bump its write pointer */
+		if (sdebug_dev_is_zoned(devip)) {
+			struct sdeb_zone_state *zsp = zbc_zone(lba, devip);
+
+			if (!zbc_zone_is_conv(zsp)) {
+				zsp->z_wp += num;
+				if (zsp->z_wp >= zsp->z_start + zsp->z_size)
+					zsp->z_cond = ZC5_FULL;
+			}
+		}
 		if (unlikely(scsi_debug_lbp()))
 			map_region(lba, num);
 		if (unlikely(-1 == ret)) {
@@ -3333,7 +3572,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 	}
 	ret = 0;
 err_out_unlock:
-	write_unlock(ramdisk_lck_a[acc_num % 2]);
+	write_unlock(ramdisk_lck_a[acc_num]);
 err_out:
 	kfree(lrdp);
 	return ret;
@@ -3342,6 +3581,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
 	unsigned long long i;
 	u64 block, lbaa;
 	u32 lb_size = sdebug_sector_size;
@@ -3354,7 +3595,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (ret)
 		return ret;
 
-	write_lock(ramdisk_lck_a[acc_num % 2]);
+	write_lock(ramdisk_lck_a[acc_num]);
 
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(lba, num, acc_num);
@@ -3363,7 +3604,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	lbaa = lba;
 	block = do_div(lbaa, sdebug_store_sectors);
 	/* if ndob then zero 1 logical block, else fetch 1 logical block */
-	fsp = fake_store_a[acc_num % 2];
+	fsp = fake_store_a[acc_num];
 	fs1p = fsp + (block * lb_size);
 	if (ndob) {
 		memset(fs1p, 0, lb_size);
@@ -3372,7 +3613,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 		ret = fetch_to_dev_buffer(scp, fs1p, lb_size);
 
 	if (-1 == ret) {
-		write_unlock(ramdisk_lck_a[acc_num % 2]);
+		write_unlock(ramdisk_lck_a[acc_num]);
 		return DID_ERROR << 16;
 	} else if (sdebug_verbose && !ndob && (ret < lb_size))
 		sdev_printk(KERN_INFO, scp->device,
@@ -3387,8 +3628,18 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	}
 	if (scsi_debug_lbp())
 		map_region(lba, num);
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip)) {
+		struct sdeb_zone_state *zsp = zbc_zone(lba, devip);
+
+		if (!zbc_zone_is_conv(zsp)) {
+			zsp->z_wp += num;
+			if (zsp->z_wp >= zsp->z_start + zsp->z_size)
+				zsp->z_cond = ZC5_FULL;
+		}
+	}
 out:
-	write_unlock(ramdisk_lck_a[acc_num % 2]);
+	write_unlock(ramdisk_lck_a[acc_num]);
 
 	return 0;
 }
@@ -3533,7 +3784,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	write_lock(ramdisk_lck_a[acc_num % 2]);
+	write_lock(ramdisk_lck_a[acc_num]);
 
 	ret = do_dout_fetch(scp, dnum, arr);
 	if (ret == -1) {
@@ -3551,7 +3802,7 @@ static int resp_comp_write(struct scsi_cmnd *scp,
 	if (scsi_debug_lbp())
 		map_region(lba, num);
 cleanup:
-	write_unlock(ramdisk_lck_a[acc_num % 2]);
+	write_unlock(ramdisk_lck_a[acc_num]);
 	kfree(arr);
 	return retval;
 }
@@ -3595,7 +3846,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	desc = (void *)&buf[8];
 
-	write_lock(ramdisk_lck_a[acc_num % 2]);
+	write_lock(ramdisk_lck_a[acc_num]);
 
 	for (i = 0 ; i < descriptors ; i++) {
 		unsigned long long lba = get_unaligned_be64(&desc[i].lba);
@@ -3611,7 +3862,7 @@ static int resp_unmap(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = 0;
 
 out:
-	write_unlock(ramdisk_lck_a[acc_num % 2]);
+	write_unlock(ramdisk_lck_a[acc_num]);
 	kfree(buf);
 
 	return ret;
@@ -3863,7 +4114,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		return check_condition_result;
 	}
 	/* Not changing store, so only need read access */
-	read_lock(ramdisk_lck_a[acc_num % 2]);
+	read_lock(ramdisk_lck_a[acc_num]);
 
 	ret = do_dout_fetch(scp, a_num, arr);
 	if (ret == -1) {
@@ -3885,11 +4136,426 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto cleanup;
 	}
 cleanup:
-	read_unlock(ramdisk_lck_a[acc_num % 2]);
+	read_unlock(ramdisk_lck_a[acc_num]);
 	kfree(arr);
 	return ret;
 }
 
+#define RZONES_DESC_HD 64
+
+/*
+ * Report two zones, the first: conventional; the second: sequential write
+ * required. The available storage is divided in two for these zones.
+ */
+static int resp_rep_zones(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	unsigned int i, max_zones, rep_max_zones, nrz = 0;
+	int ret = 0;
+	int acc_num = scp2acc_num(scp);
+	u32 alloc_len, rep_opts, rep_len;
+	bool partial;
+	u64 lba, zs_lba;
+	u8 *arr = NULL, *desc;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_zone_state *zsp;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+	zs_lba = get_unaligned_be64(cmd + 2);
+	alloc_len = get_unaligned_be32(cmd + 10);
+	rep_opts = cmd[14] & 0x3f;
+	partial = cmd[14] & 0x80;
+
+	lba = sdebug_capacity;
+	if (zs_lba >= lba) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		ret = check_condition_result;
+		goto fini;
+	}
+
+	max_zones = devip->nr_zones - (zs_lba >> devip->zsize_shift);
+	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
+			    max_zones);
+
+	arr = kcalloc(RZONES_DESC_HD, alloc_len, GFP_ATOMIC);
+	if (!arr) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INSUFF_RES_ASC,
+				INSUFF_RES_ASCQ);
+		return check_condition_result;
+	}
+
+	read_lock(ramdisk_lck_a[acc_num]);
+
+	desc = arr + 64;
+	for (i = 0; i < max_zones; i++) {
+		zsp = zbc_zone(zs_lba + ((sector_t)i << devip->zsize_shift),
+			       devip);
+		switch (rep_opts) {
+		case 0x00:
+			/* All zones */
+			break;
+		case 0x01:
+			/* Empty zones */
+			if (zsp->z_cond != ZC1_EMPTY)
+				continue;
+			break;
+		case 0x02:
+			/* Implicit open zones */
+			if (zsp->z_cond != ZC2_IMPLICIT_OPEN)
+				continue;
+			break;
+		case 0x03:
+			/* Explicit open zones */
+			if (zsp->z_cond != ZC3_EXPLICIT_OPEN)
+				continue;
+			break;
+		case 0x04:
+			/* Closed zones */
+			if (zsp->z_cond != ZC4_CLOSED)
+				continue;
+			break;
+		case 0x05:
+			/* Full zones */
+			if (zsp->z_cond != ZC5_FULL)
+				continue;
+			break;
+		case 0x06:
+		case 0x07:
+		case 0x10:
+		case 0x11:
+			/*
+			 * Read-only, offline, reset WP recommended and
+			 * non-seq-resource-used are not emulated: no zones
+			 * to report;
+			 */
+			continue;
+		case 0x3f:
+			/* Not write pointer (conventional) zones */
+			if (!zbc_zone_is_conv(zsp))
+				continue;
+			break;
+		default:
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					INVALID_FIELD_IN_CDB, 0);
+			ret = check_condition_result;
+			read_unlock(ramdisk_lck_a[acc_num]);
+			goto fini;
+		}
+
+		if (nrz < rep_max_zones) {
+			/* Fill zone descriptor */
+			if (zbc_zone_is_conv(zsp))
+				desc[0] = 0x1;
+			else
+				desc[0] = 0x2;
+			desc[1] = zsp->z_cond << 4;
+			put_unaligned_be64((u64)zsp->z_size, desc + 8);
+			put_unaligned_be64((u64)zsp->z_start, desc + 16);
+			put_unaligned_be64((u64)zsp->z_wp, desc + 24);
+			desc += 64;
+		}
+
+		if (partial && nrz >= rep_max_zones)
+			break;
+
+		nrz++;
+	}
+	read_unlock(ramdisk_lck_a[acc_num]);
+
+	/* Report header */
+	put_unaligned_be32(nrz * RZONES_DESC_HD, arr + 0);
+	put_unaligned_be64(lba - 1, arr + 8);
+
+	rep_len = (unsigned long)desc - (unsigned long)arr;
+	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
+
+fini:
+	kfree(arr);
+	return ret;
+}
+
+/* Logic transplanted from tcmu-runner, file_zbc.c __zbc_close_zone() */
+static void zbc_open_all(struct sdebug_dev_info *devip)
+{
+	struct sdeb_zone_state *zsp = &devip->zstate[0];
+	unsigned int i;
+
+	for (i = 0; i < devip->nr_zones; i++, zsp++) {
+		if (zsp->z_cond == ZC4_CLOSED)
+			zbc_open_zone(devip, &devip->zstate[i], true);
+	}
+}
+
+static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	int acc_num = scp2acc_num(scp);
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_zone_state *zsp;
+	enum sdebug_z_cond zc;
+	bool all = cmd[14] & 0x01;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(ramdisk_lck_a[acc_num]);
+	if (all) {
+		/* Check if all closed zones can be open */
+		if (devip->max_open &&
+		    devip->nr_exp_open + devip->nr_closed > devip->max_open) {
+			mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
+					INSUFF_ZONE_ASCQ);
+			res = check_condition_result;
+			goto fini;
+		}
+		/* Open all closed zones */
+		zbc_open_all(devip);
+		goto fini;
+	}
+
+	/* Open the specified zone */
+	z_id = get_unaligned_be64(cmd + 2);
+	if (z_id >= sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zsp = zbc_zone(z_id, devip);
+	if (z_id != zsp->z_start) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+	if (zbc_zone_is_conv(zsp)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zc = zsp->z_cond;
+	if (zc == ZC3_EXPLICIT_OPEN || zc == ZC5_FULL)
+		goto fini;
+
+	if (devip->max_open && devip->nr_exp_open >= devip->max_open) {
+		mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
+				INSUFF_ZONE_ASCQ);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	if (zc == ZC2_IMPLICIT_OPEN)
+		zbc_close_zone(devip, zsp);
+	zbc_open_zone(devip, zsp, true);
+fini:
+	write_unlock(ramdisk_lck_a[acc_num]);
+	return res;
+}
+
+static void zbc_close_all(struct sdebug_dev_info *devip)
+{
+	unsigned int i;
+
+	for (i = 0; i < devip->nr_zones; i++)
+		zbc_close_zone(devip, &devip->zstate[i]);
+}
+
+static int resp_close_zone(struct scsi_cmnd *scp,
+			   struct sdebug_dev_info *devip)
+{
+	int acc_num = scp2acc_num(scp);
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_zone_state *zsp;
+	bool all = cmd[14] & 0x01;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(ramdisk_lck_a[acc_num]);
+
+	if (all) {
+		zbc_close_all(devip);
+		goto fini;
+	}
+
+	/* Close specified zone */
+	z_id = get_unaligned_be64(cmd + 2);
+	if (z_id >= sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zsp = zbc_zone(z_id, devip);
+	if (z_id != zsp->z_start) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+	if (zbc_zone_is_conv(zsp)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zbc_close_zone(devip, zsp);
+fini:
+	write_unlock(ramdisk_lck_a[acc_num]);
+	return res;
+}
+
+static void zbc_finish_zone(struct sdebug_dev_info *devip,
+			    struct sdeb_zone_state *zsp, bool empty)
+{
+	enum sdebug_z_cond zc = zsp->z_cond;
+
+	if (zc == ZC4_CLOSED || zc == ZC2_IMPLICIT_OPEN ||
+	    zc == ZC3_EXPLICIT_OPEN || (empty && zc == ZC1_EMPTY)) {
+		if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
+			zbc_close_zone(devip, zsp);
+		if (zsp->z_cond == ZC4_CLOSED)
+			devip->nr_closed--;
+		zsp->z_wp = zsp->z_start + zsp->z_size;
+		zsp->z_cond = ZC5_FULL;
+	}
+}
+
+static void zbc_finish_all(struct sdebug_dev_info *devip)
+{
+	unsigned int i;
+
+	for (i = 0; i < devip->nr_zones; i++)
+		zbc_finish_zone(devip, &devip->zstate[i], false);
+}
+
+static int resp_finish_zone(struct scsi_cmnd *scp,
+			    struct sdebug_dev_info *devip)
+{
+	int acc_num = scp2acc_num(scp);
+	struct sdeb_zone_state *zsp;
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	bool all = cmd[14] & 0x01;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(ramdisk_lck_a[acc_num]);
+	if (all) {
+		zbc_finish_all(devip);
+		goto fini;
+	}
+
+	/* Finish the specified zone */
+	z_id = get_unaligned_be64(cmd + 2);
+	if (z_id >= sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zsp = zbc_zone(z_id, devip);
+	if (z_id != zsp->z_start) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+	if (zbc_zone_is_conv(zsp)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zbc_finish_zone(devip, zsp, true);
+fini:
+	write_unlock(ramdisk_lck_a[acc_num]);
+	return res;
+}
+
+static void zbc_rwp_zone(struct sdebug_dev_info *devip,
+			 struct sdeb_zone_state *zsp)
+{
+	enum sdebug_z_cond zc;
+
+	if (zbc_zone_is_conv(zsp))
+		return;
+
+	zc = zsp->z_cond;
+	if (zc == ZC2_IMPLICIT_OPEN || zc == ZC3_EXPLICIT_OPEN)
+		zbc_close_zone(devip, zsp);
+
+	if (zsp->z_cond == ZC4_CLOSED)
+		devip->nr_closed--;
+
+	zsp->z_wp = zsp->z_start;
+	zsp->z_cond = ZC1_EMPTY;
+}
+
+static void zbc_rwp_all(struct sdebug_dev_info *devip)
+{
+	unsigned int i;
+
+	for (i = 0; i < devip->nr_zones; i++)
+		zbc_rwp_zone(devip, &devip->zstate[i]);
+}
+
+static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
+{
+	int acc_num = scp2acc_num(scp);
+	struct sdeb_zone_state *zsp;
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	bool all = cmd[14] & 0x01;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(ramdisk_lck_a[acc_num]);
+	if (all) {
+		zbc_rwp_all(devip);
+		goto fini;
+	}
+
+	z_id = get_unaligned_be64(cmd + 2);
+	if (z_id >= sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zsp = zbc_zone(z_id, devip);
+	if (z_id != zsp->z_start) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+	if (zbc_zone_is_conv(zsp)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		res = check_condition_result;
+		goto fini;
+	}
+
+	zbc_rwp_zone(devip, zsp);
+fini:
+	write_unlock(ramdisk_lck_a[acc_num]);
+	return res;
+}
+
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u32 tag = blk_mq_unique_tag(cmnd->request);
@@ -3995,6 +4661,73 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
 static bool got_shared_uuid;
 static uuid_t shared_uuid;
 
+static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
+{
+	struct sdeb_zone_state *zsp;
+	sector_t capacity = get_sdebug_capacity();
+	sector_t zstart = 0;
+	unsigned int i;
+
+	/*
+	 * Set zone size: if zbc_zone_size_mb was not set, figure out a zone
+	 * size allowing for at least 4 zones on the device.
+	 */
+	if (!zbc_zone_size_mb) {
+		devip->zsize = (DEF_ZBC_ZONE_SIZE_MB * SZ_1M)
+			>> ilog2(sdebug_sector_size);
+		while (capacity < devip->zsize * 4 && devip->zsize >= 2)
+			devip->zsize >>= 1;
+		if (devip->zsize < 2) {
+			pr_err("Device capacity too small\n");
+			return -EINVAL;
+		}
+	} else {
+		devip->zsize = (zbc_zone_size_mb * SZ_1M)
+			>> ilog2(sdebug_sector_size);
+		if (devip->zsize >= capacity) {
+			pr_err("Zone size too large for device capacity\n");
+			return -EINVAL;
+		}
+	}
+
+	devip->zsize_shift = ilog2(devip->zsize);
+	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
+
+	/* zbc_max_open_zones can be 0, meaning "no limit" */
+	if (zbc_max_open_zones >= devip->nr_zones - 1)
+		devip->max_open = (devip->nr_zones - 1) / 2;
+	else
+		devip->max_open = zbc_max_open_zones;
+
+	devip->zstate = kcalloc(devip->nr_zones,
+				sizeof(struct sdeb_zone_state), GFP_KERNEL);
+	if (!devip->zstate)
+		return -ENOMEM;
+
+	for (i = 0; i < devip->nr_zones; i++) {
+		zsp = &devip->zstate[i];
+
+		zsp->z_start = zstart;
+
+		if (i == 0) {
+			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
+			zsp->z_wp = (sector_t)-1;
+		} else {
+			zsp->z_cond = ZC1_EMPTY;
+			zsp->z_wp = zsp->z_start;
+		}
+
+		if (zsp->z_start + devip->zsize < capacity)
+			zsp->z_size = devip->zsize;
+		else
+			zsp->z_size = capacity - zsp->z_start;
+
+		zstart += zsp->z_size;
+	}
+
+	return 0;
+}
+
 static struct sdebug_dev_info *sdebug_device_create(
 			struct sdebug_host_info *sdbg_host, gfp_t flags)
 {
@@ -4014,6 +4747,13 @@ static struct sdebug_dev_info *sdebug_device_create(
 			}
 		}
 		devip->sdbg_host = sdbg_host;
+		if (sdeb_zbc_in_use) {
+			if (sdebug_device_create_zones(devip)) {
+				kfree(devip);
+				return NULL;
+			}
+		}
+		devip->sdbg_host = sdbg_host;
 		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
 	}
 	return devip;
@@ -4972,6 +5712,7 @@ static ssize_t ptype_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		sdebug_ptype = n;
+		sdeb_zbc_in_use = (sdebug_ptype == TYPE_ZBC);
 		return count;
 	}
 	return -EINVAL;
@@ -5240,6 +5981,10 @@ static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 	int n;
 	bool changed;
 
+	/* Ignore capacity change for ZBC drives for now */
+	if (sdeb_zbc_in_use)
+		return -ENOTSUPP;
+
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		changed = (sdebug_virtual_gb != n);
 		sdebug_virtual_gb = n;
@@ -5709,6 +6454,9 @@ static int __init scsi_debug_init(void)
 		if (sdebug_num_parts)
 			map_region(0, 2);
 	}
+	/* check for host managed zoned block device [ptype=0x14] */
+	if (sdebug_ptype == TYPE_ZBC)
+		sdeb_zbc_in_use = true;
 
 	pseudo_primary = root_device_register("pseudo_0");
 	if (IS_ERR(pseudo_primary)) {
@@ -5832,6 +6580,7 @@ static int sdebug_add_adapter(void)
 	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
 				 dev_list) {
 		list_del(&sdbg_devinfo->dev_list);
+		kfree(sdbg_devinfo->zstate);
 		kfree(sdbg_devinfo);
 	}
 
@@ -6208,6 +6957,7 @@ static int sdebug_driver_remove(struct device *dev)
 	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
 				 dev_list) {
 		list_del(&sdbg_devinfo->dev_list);
+		kfree(sdbg_devinfo->zstate);
 		kfree(sdbg_devinfo);
 	}
 
-- 
2.25.1

