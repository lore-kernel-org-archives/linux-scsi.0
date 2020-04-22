Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C003FC55189
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B7B20656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TztKYEko"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgDVKm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:42:59 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22892 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731206AbgDVKmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552152; x=1619088152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tDGih+lTeTDkRYh8gGWOlL5S5EIaPC0eMEk6IvRVuaI=;
  b=TztKYEkomgRqiTe2nZFT888uvbRykOg/aG2BvidqCvglL28/AUF1Ivlf
   JJBN0TZi+lPP+1ae0w8oSDhK6JPq7ZoEDpEEOkgKRc5RA63h3A26d4j1h
   2uqLb3dJvpkieoljwGU/vWb6R0+jHS2fs8voediH93yczumKz5NHfBktM
   UtEoXZZsI2MbnrwCHMUE4SuQzUYw5Gmm0n5T9QdiqT3B84wJ0Gt/oZE2V
   YgyMY5icAUfIGg3jRx0ZO6W9OEa26ura0cqND0Zy0Wbi3CuhDR9JGhrDj
   iN+Q1HaXQNAu7zWCPagV6qgf4rCKPd7Xvrm61nkao6DDTPnrsNhRK1Paf
   Q==;
IronPort-SDR: jNR00oRgeTUxbqgVOap8RqSIufmHCm5yUwrwpXZqFjeM/faigxKbV6U3CgRYKaphyJ3M5tQSx0
 sOOjQX7hnODvzbBJsAFhixvVxCWG8WHCqyK3Y4abtcjpFtnadkCQnh9iqvx62jlkS1j2Ysa04r
 mTRE3a38zeaunz32W6NgAd4+MSkn2jcNz/tKRol2tLC7yV43jJOk7Y8++F3lrnMO424P9KQDpy
 nHahiHzpOXW+EPP1rLvM17fEuTpWgLQieyzodIZRiyIsbhaU4eTfaYYq35PgajJxlZYu72mq1V
 AuQ=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230027"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:28 +0800
IronPort-SDR: Faa4/ySe/7Tu77bCkkgM26Qq+mmS06piom3pzatEob1nHTYkSu3VaG1VAIZesmwgqs0WVml2GA
 A5k1ZgKna70azdb+rIP3XGfoTzQw5H0NM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:18 -0700
IronPort-SDR: FmqCFuzAqmYibRjVuBubBXA/sXC4SGDOs56zScUwkIua685AXvXsEbHMiJwfBXOF+/Xik8zkxy
 0/k8r9uM4RSQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:27 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 7/7] scsi_debug: implement zbc host-aware emulation
Date:   Wed, 22 Apr 2020 19:42:21 +0900
Message-Id: <20200422104221.378203-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implement ZBC host-aware device model emulation. The main changes from
the host-managed emulation are the device type (TYPE_DISK is used),
relaxation of access checks for read and write operations and different
handling of a sequential write preferred zone write pointer as mandated
by the ZBC r05 specifications.

To facilitate the implementation and avoid a lot of "if" statement, the
zmodel field is added to the device information and the z_type field to
the zone state data structure.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 148 ++++++++++++++++++++++++++------------
 1 file changed, 103 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9279ac9bb98d..46cd4e64bb9c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -262,6 +262,13 @@ static const char *sdebug_version_date = "20200421";
 
 #define SDEB_XA_NOT_IN_USE XA_MARK_1
 
+/* Zone types (zbcr05 table 25) */
+enum sdebug_z_type {
+	ZBC_ZONE_TYPE_CNV	= 0x1,
+	ZBC_ZONE_TYPE_SWR	= 0x2,
+	ZBC_ZONE_TYPE_SWP	= 0x3,
+};
+
 /* enumeration names taken from table 26, zbcr05 */
 enum sdebug_z_cond {
 	ZBC_NOT_WRITE_POINTER	= 0x0,
@@ -275,7 +282,9 @@ enum sdebug_z_cond {
 };
 
 struct sdeb_zone_state {	/* ZBC: per zone state */
+	enum sdebug_z_type z_type;
 	enum sdebug_z_cond z_cond;
+	bool z_non_seq_resource;
 	unsigned int z_size;
 	sector_t z_start;
 	sector_t z_wp;
@@ -294,6 +303,7 @@ struct sdebug_dev_info {
 	bool used;
 
 	/* For ZBC devices */
+	enum blk_zoned_model zmodel;
 	unsigned int zsize;
 	unsigned int zsize_shift;
 	unsigned int nr_zones;
@@ -822,7 +832,7 @@ static int dix_reads;
 static int dif_errors;
 
 /* ZBC global data */
-static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
+static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
 static int sdeb_zbc_zone_size_mb;
 static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
 static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
@@ -1500,13 +1510,15 @@ static int inquiry_vpd_b0(unsigned char *arr)
 }
 
 /* Block device characteristics VPD page (SBC-3) */
-static int inquiry_vpd_b1(unsigned char *arr)
+static int inquiry_vpd_b1(struct sdebug_dev_info *devip, unsigned char *arr)
 {
 	memset(arr, 0, 0x3c);
 	arr[0] = 0;
 	arr[1] = 1;	/* non rotating medium (e.g. solid state) */
 	arr[2] = 0;
 	arr[3] = 5;	/* less than 1.8" */
+	if (devip->zmodel == BLK_ZONED_HA)
+		arr[4] = 1 << 4;	/* zoned field = 01b */
 
 	return 0x3c;
 }
@@ -1543,7 +1555,7 @@ static int inquiry_vpd_b6(struct sdebug_dev_info *devip, unsigned char *arr)
 	 */
 	put_unaligned_be32(0xffffffff, &arr[4]);
 	put_unaligned_be32(0xffffffff, &arr[8]);
-	if (devip->max_open)
+	if (sdeb_zbc_model == BLK_ZONED_HM && devip->max_open)
 		put_unaligned_be32(devip->max_open, &arr[12]);
 	else
 		put_unaligned_be32(0xffffffff, &arr[12]);
@@ -1566,7 +1578,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	if (! arr)
 		return DID_REQUEUE << 16;
 	is_disk = (sdebug_ptype == TYPE_DISK);
-	is_zbc = (sdebug_ptype == TYPE_ZBC);
+	is_zbc = (devip->zmodel != BLK_ZONED_NONE);
 	is_disk_zbc = (is_disk || is_zbc);
 	have_wlun = scsi_is_wlun(scp->device->lun);
 	if (have_wlun)
@@ -1611,7 +1623,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				arr[n++] = 0xb1;  /* Block characteristics */
 				if (is_disk)
 					arr[n++] = 0xb2;  /* LB Provisioning */
-				else if (is_zbc)
+				if (is_zbc)
 					arr[n++] = 0xb6;  /* ZB dev. char. */
 			}
 			arr[3] = n - 4;	  /* number of supported VPD pages */
@@ -1660,7 +1672,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[3] = inquiry_vpd_b0(&arr[4]);
 		} else if (is_disk_zbc && 0xb1 == cmd[2]) { /* Block char. */
 			arr[1] = cmd[2];        /*sanity */
-			arr[3] = inquiry_vpd_b1(&arr[4]);
+			arr[3] = inquiry_vpd_b1(devip, &arr[4]);
 		} else if (is_disk && 0xb2 == cmd[2]) { /* LB Prov. */
 			arr[1] = cmd[2];        /*sanity */
 			arr[3] = inquiry_vpd_b2(&arr[4]);
@@ -2305,7 +2317,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	msense_6 = (MODE_SENSE == cmd[0]);
 	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
 	is_disk = (sdebug_ptype == TYPE_DISK);
-	is_zbc = (sdebug_ptype == TYPE_ZBC);
+	is_zbc = (devip->zmodel != BLK_ZONED_NONE);
 	if ((is_disk || is_zbc) && !dbd)
 		bd_len = llbaa ? 16 : 8;
 	else
@@ -2656,7 +2668,7 @@ static struct sdeb_zone_state *zbc_zone(struct sdebug_dev_info *devip,
 
 static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
 {
-	return zsp->z_cond == ZBC_NOT_WRITE_POINTER;
+	return zsp->z_type == ZBC_ZONE_TYPE_CNV;
 }
 
 static void zbc_close_zone(struct sdebug_dev_info *devip,
@@ -2732,13 +2744,42 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 		       unsigned long long lba, unsigned int num)
 {
 	struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
+	unsigned long long n, end, zend = zsp->z_start + zsp->z_size;
 
 	if (zbc_zone_is_conv(zsp))
 		return;
 
-	zsp->z_wp += num;
-	if (zsp->z_wp >= zsp->z_start + zsp->z_size)
-		zsp->z_cond = ZC5_FULL;
+	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
+		zsp->z_wp += num;
+		if (zsp->z_wp >= zend)
+			zsp->z_cond = ZC5_FULL;
+		return;
+	}
+
+	while (num) {
+		if (lba != zsp->z_wp)
+			zsp->z_non_seq_resource = true;
+
+		end = lba + num;
+		if (end >= zend) {
+			n = zend - lba;
+			zsp->z_wp = zend;
+		} else if (end > zsp->z_wp) {
+			n = num;
+			zsp->z_wp = end;
+		} else {
+			n = num;
+		}
+		if (zsp->z_wp >= zend)
+			zsp->z_cond = ZC5_FULL;
+
+		num -= n;
+		lba += n;
+		if (num) {
+			zsp++;
+			zend = zsp->z_start + zsp->z_size;
+		}
+	}
 }
 
 static int check_zbc_access_params(struct scsi_cmnd *scp,
@@ -2750,7 +2791,9 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 	struct sdeb_zone_state *zsp_end = zbc_zone(devip, lba + num - 1);
 
 	if (!write) {
-		/* Reads cannot cross zone types boundaries */
+		if (devip->zmodel == BLK_ZONED_HA)
+			return 0;
+		/* For host-managed, reads cannot cross zone types boundaries */
 		if (zsp_end != zsp &&
 		    zbc_zone_is_conv(zsp) &&
 		    !zbc_zone_is_conv(zsp_end)) {
@@ -2773,25 +2816,27 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 		return 0;
 	}
 
-	/* Writes cannot cross sequential zone boundaries */
-	if (zsp_end != zsp) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				LBA_OUT_OF_RANGE,
-				WRITE_BOUNDARY_ASCQ);
-		return check_condition_result;
-	}
-	/* Cannot write full zones */
-	if (zsp->z_cond == ZC5_FULL) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				INVALID_FIELD_IN_CDB, 0);
-		return check_condition_result;
-	}
-	/* Writes must be aligned to the zone WP */
-	if (lba != zsp->z_wp) {
-		mk_sense_buffer(scp, ILLEGAL_REQUEST,
-				LBA_OUT_OF_RANGE,
-				UNALIGNED_WRITE_ASCQ);
-		return check_condition_result;
+	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
+		/* Writes cannot cross sequential zone boundaries */
+		if (zsp_end != zsp) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE,
+					WRITE_BOUNDARY_ASCQ);
+			return check_condition_result;
+		}
+		/* Cannot write full zones */
+		if (zsp->z_cond == ZC5_FULL) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					INVALID_FIELD_IN_CDB, 0);
+			return check_condition_result;
+		}
+		/* Writes must be aligned to the zone WP */
+		if (lba != zsp->z_wp) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE,
+					UNALIGNED_WRITE_ASCQ);
+			return check_condition_result;
+		}
 	}
 
 	/* Handle implicit open of closed and empty zones */
@@ -4312,13 +4357,16 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		case 0x06:
 		case 0x07:
 		case 0x10:
-		case 0x11:
 			/*
-			 * Read-only, offline, reset WP recommended and
-			 * non-seq-resource-used are not emulated: no zones
-			 * to report;
+			 * Read-only, offline, reset WP recommended are
+			 * not emulated: no zones to report;
 			 */
 			continue;
+		case 0x11:
+			/* non-seq-resource set */
+			if (!zsp->z_non_seq_resource)
+				continue;
+			break;
 		case 0x3f:
 			/* Not write pointer (conventional) zones */
 			if (!zbc_zone_is_conv(zsp))
@@ -4333,11 +4381,10 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 
 		if (nrz < rep_max_zones) {
 			/* Fill zone descriptor */
-			if (zbc_zone_is_conv(zsp))
-				desc[0] = 0x1;
-			else
-				desc[0] = 0x2;
+			desc[0] = zsp->z_type;
 			desc[1] = zsp->z_cond << 4;
+			if (zsp->z_non_seq_resource)
+				desc[1] |= 1 << 1;
 			put_unaligned_be64((u64)zsp->z_size, desc + 8);
 			put_unaligned_be64((u64)zsp->z_start, desc + 16);
 			put_unaligned_be64((u64)zsp->z_wp, desc + 24);
@@ -4591,6 +4638,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 	if (zsp->z_cond == ZC4_CLOSED)
 		devip->nr_closed--;
 
+	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;
 	zsp->z_cond = ZC1_EMPTY;
 }
@@ -4796,11 +4844,13 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 	}
 	devip->nr_conv_zones = sdeb_zbc_nr_conv;
 
-	/* zbc_max_open_zones can be 0, meaning "not reported" (no limit) */
-	if (sdeb_zbc_max_open >= devip->nr_zones - 1)
-		devip->max_open = (devip->nr_zones - 1) / 2;
-	else
-		devip->max_open = sdeb_zbc_max_open;
+	if (devip->zmodel == BLK_ZONED_HM) {
+		/* zbc_max_open_zones can be 0, meaning "not reported" */
+		if (sdeb_zbc_max_open >= devip->nr_zones - 1)
+			devip->max_open = (devip->nr_zones - 1) / 2;
+		else
+			devip->max_open = sdeb_zbc_max_open;
+	}
 
 	devip->zstate = kcalloc(devip->nr_zones,
 				sizeof(struct sdeb_zone_state), GFP_KERNEL);
@@ -4813,9 +4863,14 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 		zsp->z_start = zstart;
 
 		if (i < devip->nr_conv_zones) {
+			zsp->z_type = ZBC_ZONE_TYPE_CNV;
 			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
 			zsp->z_wp = (sector_t)-1;
 		} else {
+			if (devip->zmodel == BLK_ZONED_HM)
+				zsp->z_type = ZBC_ZONE_TYPE_SWR;
+			else
+				zsp->z_type = ZBC_ZONE_TYPE_SWP;
 			zsp->z_cond = ZC1_EMPTY;
 			zsp->z_wp = zsp->z_start;
 		}
@@ -4851,10 +4906,13 @@ static struct sdebug_dev_info *sdebug_device_create(
 		}
 		devip->sdbg_host = sdbg_host;
 		if (sdeb_zbc_in_use) {
+			devip->zmodel = sdeb_zbc_model;
 			if (sdebug_device_create_zones(devip)) {
 				kfree(devip);
 				return NULL;
 			}
+		} else {
+			devip->zmodel = BLK_ZONED_NONE;
 		}
 		devip->sdbg_host = sdbg_host;
 		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
@@ -6566,12 +6624,12 @@ static int __init scsi_debug_init(void)
 		sdeb_zbc_model = k;
 		switch (sdeb_zbc_model) {
 		case BLK_ZONED_NONE:
+		case BLK_ZONED_HA:
 			sdebug_ptype = TYPE_DISK;
 			break;
 		case BLK_ZONED_HM:
 			sdebug_ptype = TYPE_ZBC;
 			break;
-		case BLK_ZONED_HA:
 		default:
 			pr_err("Invalid ZBC model\n");
 			return -EINVAL;
-- 
2.25.3

