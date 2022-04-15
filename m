Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2D8C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351766AbiDOUU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351793AbiDOUUz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:55 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA1BDE926
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:15 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id bx5so8347841pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4nyx7As0HsTMbADSXHo0W7kCBcSJ8CoQIWC79JbOuFs=;
        b=pjuegMzyC1QABZJBcGO9SbGSb4rHAM4b7WPL9PA6hjc/IqP9eN4wtuMHfu9bgdPSII
         M2xNQiTwvKLze+OSXy8P34J1m47pqXAeWJNSqSweFts0TVWkDP8gb+9TpxJauAH7ATkb
         N11rKH1h7ZDHrFvjKZ4dZIxsJFoCaU9lVCHwtTbjjeVyoD0OgmbbHqERruv8u4kHfaKc
         L0Mu9k+uwsKK0mSUlMevTFfTTc0x8sNYMx9DaE4XypuatZQ2MS17k4ei039ye57PtUmh
         MuUNmVKB4vMmHo/nBwVtTeE1vEoH84B2lE6eYHOfezD8RLHvDN+0JewzXztzbp3AQvUo
         bZXQ==
X-Gm-Message-State: AOAM531Ll+xohJJGMCE5TpLHna5Emn40FjW/1jYdwygwyWeOQLQhPsHG
        +ZWCG42TwkWRgrUhQXD5K4w=
X-Google-Smtp-Source: ABdhPJyuCw7nk+vhJGbar3kvYECaAdJWlGf42TQQdHhiMEXeDeg3hhVvqtuvP4LLiDMb+HMtLLIe+w==
X-Received: by 2002:a17:90a:ba15:b0:1c6:7873:b192 with SMTP id s21-20020a17090aba1500b001c67873b192mr595614pjr.76.1650053894724;
        Fri, 15 Apr 2022 13:18:14 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 8/8] scsi_debug: Add gap zone support
Date:   Fri, 15 Apr 2022 13:17:52 -0700
Message-Id: <20220415201752.2793700-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415201752.2793700-1-bvanassche@acm.org>
References: <20220415201752.2793700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the 'zone_cap_mb' kernel module parameter. This parameter defines
the zone capacity. The zone capacity must be less than or equal to the
zone size.

Report that sequential write zones and gap zones are paired in the Zoned
Block Device Characteristics VPD page (page B6h).

This patch has been tested as follows:

modprobe scsi_debug delay=0 sector_size=512 dev_size_mb=128 zbc=host-managed zone_nr_conv=16 zone_size_mb=4 zone_cap_mb=3
modprobe brd rd_nr=1 rd_size=$((1<<20))
mkfs.f2fs -m /dev/ram0 -c /dev/${scsi_debug_dev}
mount /dev/ram0 /mnt
 # Run a fio job that uses /mnt

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: Switched to reporting a constant zone starting LBA granularity ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 127 +++++++++++++++++++++++++++++++-------
 1 file changed, 103 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 47cec83a4b7c..08bb735b5590 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -99,6 +99,7 @@ static const char *sdebug_version_date = "20210520";
 #define WRITE_BOUNDARY_ASCQ 0x5
 #define READ_INVDATA_ASCQ 0x6
 #define READ_BOUNDARY_ASCQ 0x7
+#define ATTEMPT_ACCESS_GAP 0x9
 #define INSUFF_ZONE_ASCQ 0xe
 
 /* Additional Sense Code Qualifier (ASCQ) */
@@ -255,6 +256,8 @@ enum sdebug_z_type {
 	ZBC_ZTYPE_CNV	= 0x1,
 	ZBC_ZTYPE_SWR	= 0x2,
 	ZBC_ZTYPE_SWP	= 0x3,
+	/* ZBC_ZTYPE_SOBR = 0x4, */
+	ZBC_ZTYPE_GAP	= 0x5,
 };
 
 /* enumeration names taken from table 26, zbcr05 */
@@ -292,10 +295,12 @@ struct sdebug_dev_info {
 
 	/* For ZBC devices */
 	enum blk_zoned_model zmodel;
+	unsigned int zcap;
 	unsigned int zsize;
 	unsigned int zsize_shift;
 	unsigned int nr_zones;
 	unsigned int nr_conv_zones;
+	unsigned int nr_seq_zones;
 	unsigned int nr_imp_open;
 	unsigned int nr_exp_open;
 	unsigned int nr_closed;
@@ -833,6 +838,7 @@ static int dif_errors;
 
 /* ZBC global data */
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
+static int sdeb_zbc_zone_cap_mb;
 static int sdeb_zbc_zone_size_mb;
 static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
 static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
@@ -1563,6 +1569,12 @@ static int inquiry_vpd_b6(struct sdebug_dev_info *devip, unsigned char *arr)
 		put_unaligned_be32(devip->max_open, &arr[12]);
 	else
 		put_unaligned_be32(0xffffffff, &arr[12]);
+	if (devip->zcap < devip->zsize) {
+		arr[19] = ZBC_CONSTANT_ZONE_STARTING_LBA_OFFSETS;
+		put_unaligned_be64(devip->zsize, &arr[20]);
+	} else {
+		arr[19] = 0;
+	}
 	return 0x3c;
 }
 
@@ -2715,7 +2727,23 @@ static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
 static struct sdeb_zone_state *zbc_zone(struct sdebug_dev_info *devip,
 					unsigned long long lba)
 {
-	return &devip->zstate[lba >> devip->zsize_shift];
+	u32 zno = lba >> devip->zsize_shift;
+	struct sdeb_zone_state *zsp;
+
+	if (devip->zcap == devip->zsize || zno < devip->nr_conv_zones)
+		return &devip->zstate[zno];
+
+	/*
+	 * If the zone capacity is less than the zone size, adjust for gap
+	 * zones.
+	 */
+	zno = 2 * zno - devip->nr_conv_zones;
+	WARN_ONCE(zno >= devip->nr_zones, "%u > %u\n", zno, devip->nr_zones);
+	zsp = &devip->zstate[zno];
+	if (lba >= zsp->z_start + zsp->z_size)
+		zsp++;
+	WARN_ON_ONCE(lba >= zsp->z_start + zsp->z_size);
+	return zsp;
 }
 
 static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
@@ -2723,12 +2751,22 @@ static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
 	return zsp->z_type == ZBC_ZTYPE_CNV;
 }
 
+static inline bool zbc_zone_is_gap(struct sdeb_zone_state *zsp)
+{
+	return zsp->z_type == ZBC_ZTYPE_GAP;
+}
+
+static inline bool zbc_zone_is_seq(struct sdeb_zone_state *zsp)
+{
+	return !zbc_zone_is_conv(zsp) && !zbc_zone_is_gap(zsp);
+}
+
 static void zbc_close_zone(struct sdebug_dev_info *devip,
 			   struct sdeb_zone_state *zsp)
 {
 	enum sdebug_z_cond zc;
 
-	if (zbc_zone_is_conv(zsp))
+	if (!zbc_zone_is_seq(zsp))
 		return;
 
 	zc = zsp->z_cond;
@@ -2766,7 +2804,7 @@ static void zbc_open_zone(struct sdebug_dev_info *devip,
 {
 	enum sdebug_z_cond zc;
 
-	if (zbc_zone_is_conv(zsp))
+	if (!zbc_zone_is_seq(zsp))
 		return;
 
 	zc = zsp->z_cond;
@@ -2798,7 +2836,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 	struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
 	unsigned long long n, end, zend = zsp->z_start + zsp->z_size;
 
-	if (zbc_zone_is_conv(zsp))
+	if (!zbc_zone_is_seq(zsp))
 		return;
 
 	if (zsp->z_type == ZBC_ZTYPE_SWR) {
@@ -2846,9 +2884,7 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 		if (devip->zmodel == BLK_ZONED_HA)
 			return 0;
 		/* For host-managed, reads cannot cross zone types boundaries */
-		if (zsp_end != zsp &&
-		    zbc_zone_is_conv(zsp) &&
-		    !zbc_zone_is_conv(zsp_end)) {
+		if (zsp->z_type != zsp_end->z_type) {
 			mk_sense_buffer(scp, ILLEGAL_REQUEST,
 					LBA_OUT_OF_RANGE,
 					READ_INVDATA_ASCQ);
@@ -2857,6 +2893,13 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 		return 0;
 	}
 
+	/* Writing into a gap zone is not allowed */
+	if (zbc_zone_is_gap(zsp)) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE,
+				ATTEMPT_ACCESS_GAP);
+		return check_condition_result;
+	}
+
 	/* No restrictions for writes within conventional zones */
 	if (zbc_zone_is_conv(zsp)) {
 		if (!zbc_zone_is_conv(zsp_end)) {
@@ -4412,14 +4455,14 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 static int resp_report_zones(struct scsi_cmnd *scp,
 			     struct sdebug_dev_info *devip)
 {
-	unsigned int i, max_zones, rep_max_zones, nrz = 0;
+	unsigned int rep_max_zones, nrz = 0;
 	int ret = 0;
 	u32 alloc_len, rep_opts, rep_len;
 	bool partial;
 	u64 lba, zs_lba;
 	u8 *arr = NULL, *desc;
 	u8 *cmd = scp->cmnd;
-	struct sdeb_zone_state *zsp;
+	struct sdeb_zone_state *zsp = NULL;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (!sdebug_dev_is_zoned(devip)) {
@@ -4438,9 +4481,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	max_zones = devip->nr_zones - (zs_lba >> devip->zsize_shift);
-	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
-			    max_zones);
+	rep_max_zones = (alloc_len - 64) >> ilog2(RZONES_DESC_HD);
 
 	arr = kzalloc(alloc_len, GFP_ATOMIC);
 	if (!arr) {
@@ -4452,9 +4493,9 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	sdeb_read_lock(sip);
 
 	desc = arr + 64;
-	for (i = 0; i < max_zones; i++) {
-		lba = zs_lba + devip->zsize * i;
-		if (lba > sdebug_capacity)
+	for (lba = zs_lba; lba < sdebug_capacity;
+	     lba = zsp->z_start + zsp->z_size) {
+		if (WARN_ONCE(zbc_zone(devip, lba) == zsp, "lba = %llu\n", lba))
 			break;
 		zsp = zbc_zone(devip, lba);
 		switch (rep_opts) {
@@ -4499,9 +4540,14 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 			if (!zsp->z_non_seq_resource)
 				continue;
 			break;
+		case 0x3e:
+			/* All zones except gap zones. */
+			if (zbc_zone_is_gap(zsp))
+				continue;
+			break;
 		case 0x3f:
 			/* Not write pointer (conventional) zones */
-			if (!zbc_zone_is_conv(zsp))
+			if (zbc_zone_is_seq(zsp))
 				continue;
 			break;
 		default:
@@ -4530,8 +4576,13 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	}
 
 	/* Report header */
+	/* Zone list length. */
 	put_unaligned_be32(nrz * RZONES_DESC_HD, arr + 0);
+	/* Maximum LBA */
 	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
+	/* Zone starting LBA granularity. */
+	if (devip->zcap < devip->zsize)
+		put_unaligned_be64(devip->zsize, arr + 16);
 
 	rep_len = (unsigned long)desc - (unsigned long)arr;
 	ret = fill_from_dev_buffer(scp, arr, min_t(u32, alloc_len, rep_len));
@@ -4756,7 +4807,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 	enum sdebug_z_cond zc;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
 
-	if (zbc_zone_is_conv(zsp))
+	if (!zbc_zone_is_seq(zsp))
 		return;
 
 	zc = zsp->z_cond;
@@ -4946,6 +4997,7 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 {
 	struct sdeb_zone_state *zsp;
 	sector_t capacity = get_sdebug_capacity();
+	sector_t conv_capacity;
 	sector_t zstart = 0;
 	unsigned int i;
 
@@ -4980,11 +5032,30 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 	devip->zsize_shift = ilog2(devip->zsize);
 	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
 
-	if (sdeb_zbc_nr_conv >= devip->nr_zones) {
+	if (sdeb_zbc_zone_cap_mb == 0) {
+		devip->zcap = devip->zsize;
+	} else {
+		devip->zcap = (sdeb_zbc_zone_cap_mb * SZ_1M) >>
+			      ilog2(sdebug_sector_size);
+		if (devip->zcap > devip->zsize) {
+			pr_err("Zone capacity too large\n");
+			return -EINVAL;
+		}
+	}
+
+	conv_capacity = (sector_t)sdeb_zbc_nr_conv << devip->zsize_shift;
+	if (conv_capacity >= capacity) {
 		pr_err("Number of conventional zones too large\n");
 		return -EINVAL;
 	}
 	devip->nr_conv_zones = sdeb_zbc_nr_conv;
+	devip->nr_seq_zones = roundup(capacity - conv_capacity, devip->zsize) >>
+			      devip->zsize_shift;
+	devip->nr_zones = devip->nr_conv_zones + devip->nr_seq_zones;
+
+	/* Add gap zones if zone capacity is smaller than the zone size */
+	if (devip->zcap < devip->zsize)
+		devip->nr_zones += devip->nr_seq_zones;
 
 	if (devip->zmodel == BLK_ZONED_HM) {
 		/* zbc_max_open_zones can be 0, meaning "not reported" */
@@ -5008,20 +5079,26 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 			zsp->z_type = ZBC_ZTYPE_CNV;
 			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
 			zsp->z_wp = (sector_t)-1;
-		} else {
+			zsp->z_size =
+				min_t(u64, devip->zsize, capacity - zstart);
+		} else if ((zstart & (devip->zsize - 1)) == 0) {
 			if (devip->zmodel == BLK_ZONED_HM)
 				zsp->z_type = ZBC_ZTYPE_SWR;
 			else
 				zsp->z_type = ZBC_ZTYPE_SWP;
 			zsp->z_cond = ZC1_EMPTY;
 			zsp->z_wp = zsp->z_start;
+			zsp->z_size =
+				min_t(u64, devip->zcap, capacity - zstart);
+		} else {
+			zsp->z_type = ZBC_ZTYPE_GAP;
+			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
+			zsp->z_wp = (sector_t)-1;
+			zsp->z_size = min_t(u64, devip->zsize - devip->zcap,
+					    capacity - zstart);
 		}
 
-		if (zsp->z_start + devip->zsize < capacity)
-			zsp->z_size = devip->zsize;
-		else
-			zsp->z_size = capacity - zsp->z_start;
-
+		WARN_ON_ONCE((int)zsp->z_size <= 0);
 		zstart += zsp->z_size;
 	}
 
@@ -5856,6 +5933,7 @@ module_param_named(wp, sdebug_wp, bool, S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO);
+module_param_named(zone_cap_mb, sdeb_zbc_zone_cap_mb, int, S_IRUGO);
 module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
 module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
@@ -5927,6 +6005,7 @@ MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique de
 MODULE_PARM_DESC(wp, "Write Protect (def=0)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host-' prefix");
+MODULE_PARM_DESC(zone_cap_mb, "Zone capacity in MiB (def=zone size)");
 MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit (def=auto)");
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
 MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
