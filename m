Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ED9C55189
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9251F2073A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="G5JlsMs8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgDVKnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:43:02 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22889 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731745AbgDVKmZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552145; x=1619088145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LEF/m13ccMqIwtISy7YBzyHbSqENGiR8gM7pDoh2Hdo=;
  b=G5JlsMs84F/VyVLtW/2Ij4TgAHivlYInGI/8boN7EXi4cI6B9U+G2e1K
   03FD36gkYh8XONN1CvXqD5cu4SR3Bz4SPPSAqbgLFUO1DTSBe6bfjqimU
   CZiQAJqFzeyIzSuomvxwTccgrh3Bv+Ujh/0ovMcGH0Kg0P48kT7i1cCWN
   8Da788eEwX6VEMCnpcbQ9GCMKXBHKmTXBDiownmkdOTqPY619gSJnRboS
   e3fHAUDbMSf2G0pPLYI6pFg3HOx5y8WM1yRvs28VGHYy6AZbtRKZ/dF/k
   TLYb+cd+1zmEzoFCjlnxIGT2EJQySU2lluDZpqOVa5GHE+I0uQNoctK9+
   Q==;
IronPort-SDR: 9C79PB+fPhbotNukyHFA3xK10PIPF6Hqul7K1fnaA7EtoKmClveWdLJ22F1AAPM2GKxvvT6/rR
 HkilSsUQ9SimpMy/tXd72ZR+n7QPfet/c20MdTORZH0gzjmpE0NVY47UCuZf1wz3VbW5pxtihm
 gc74v219FIp0cSn1TTN671QO6h5hOwzwFOyApnQbbLiWQwr8lo8GSdIeLcv74GiYjG1cjPxZ0a
 b8bX7KpMbzKmCsqYbAr2mVErZyQjeJ3H7lDW5fBFYU7dm8QIDV0A8aHiMb00FuXN9vKUiMUB5r
 y8w=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230020"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:24 +0800
IronPort-SDR: hqbnODYHlbkyWPuCCjXMQ9ON6pdZVrVdWPL7yreQE284dMjqKyfTWKn8KF4IkEjVOMSjKFNFhg
 pRFiVfr7r6pn6NuC6CH2NFh+uuiYu5Iyo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:14 -0700
IronPort-SDR: lqe9QPAOZy/r3vTF5D/0k7S0EoDcG55k+BKHQaI1qEgtmI9HtrlCNBt9h1nP1TXlbETUxnd6/9
 6acC8EOrF+/g==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:23 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 2/7] scsi_debug: add zbc zone commands
Date:   Wed, 22 Apr 2020 19:42:16 +0900
Message-Id: <20200422104221.378203-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

Add support for the 5 ZBC commands and enough functionality to emulate
a host-managed device with one conventional zone and a set of sequential
write required zones up to the disk capacity.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 819 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 804 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4aa4d9e58978..10214017d478 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -94,6 +94,11 @@ static const char *sdebug_version_date = "20200421";
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
@@ -147,6 +152,10 @@ static const char *sdebug_version_date = "20200421";
 #define DEF_UUID_CTL 0
 #define JDELAY_OVERRIDDEN -9999
 
+/* Default parameters for ZBC drives */
+#define DEF_ZBC_ZONE_SIZE_MB	128
+#define DEF_ZBC_MAX_OPEN_ZONES	8
+
 #define SDEBUG_LUN_0_VAL 0
 
 /* bit mask values for sdebug_opts */
@@ -250,6 +259,24 @@ static const char *sdebug_version_date = "20200421";
 
 #define SDEB_XA_NOT_IN_USE XA_MARK_1
 
+/* enumeration names taken from table 26, zbcr05 */
+enum sdebug_z_cond {
+	ZBC_NOT_WRITE_POINTER	= 0x0,
+	ZC1_EMPTY		= 0x1,
+	ZC2_IMPLICIT_OPEN	= 0x2,
+	ZC3_EXPLICIT_OPEN	= 0x3,
+	ZC4_CLOSED		= 0x4,
+	ZC6_READ_ONLY		= 0xd,
+	ZC5_FULL		= 0xe,
+	ZC7_OFFLINE		= 0xf,
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
@@ -262,6 +289,16 @@ struct sdebug_dev_info {
 	atomic_t num_in_q;
 	atomic_t stopped;
 	bool used;
+
+	/* For ZBC devices */
+	unsigned int zsize;
+	unsigned int zsize_shift;
+	unsigned int nr_zones;
+	unsigned int nr_imp_open;
+	unsigned int nr_exp_open;
+	unsigned int nr_closed;
+	unsigned int max_open;
+	struct sdeb_zone_state *zstate;
 };
 
 struct sdebug_host_info {
@@ -369,7 +406,9 @@ enum sdeb_opcode_index {
 	SDEB_I_SYNC_CACHE = 27,		/* 10, 16 */
 	SDEB_I_COMP_WRITE = 28,
 	SDEB_I_PRE_FETCH = 29,		/* 10, 16 */
-	SDEB_I_LAST_ELEM_P1 = 30,	/* keep this last (previous + 1) */
+	SDEB_I_ZONE_OUT = 30,		/* 0x94+SA; includes no data xfer */
+	SDEB_I_ZONE_IN = 31,		/* 0x95+SA; all have data-in */
+	SDEB_I_LAST_ELEM_P1 = 32,	/* keep this last (previous + 1) */
 };
 
 
@@ -401,7 +440,8 @@ static const unsigned char opcode_ind_arr[256] = {
 	0, 0, 0, 0, 0, SDEB_I_ATA_PT, 0, 0,
 	SDEB_I_READ, SDEB_I_COMP_WRITE, SDEB_I_WRITE, 0,
 	0, 0, 0, SDEB_I_VERIFY,
-	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME, 0, 0, 0, 0,
+	SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, SDEB_I_WRITE_SAME,
+	SDEB_I_ZONE_OUT, SDEB_I_ZONE_IN, 0, 0,
 	0, 0, 0, 0, 0, 0, SDEB_I_SERV_ACT_IN_16, SDEB_I_SERV_ACT_OUT_16,
 /* 0xa0; 0xa0->0xbf: 12 byte cdbs */
 	SDEB_I_REPORT_LUNS, SDEB_I_ATA_PT, 0, SDEB_I_MAINT_IN,
@@ -449,6 +489,11 @@ static int resp_comp_write(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_write_buffer(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_sync_cache(struct scsi_cmnd *, struct sdebug_dev_info *);
 static int resp_pre_fetch(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_report_zones(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_open_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_close_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
+static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
 
 static int sdebug_do_add_host(bool mk_new_store);
 static int sdebug_add_host_helper(int per_host_idx);
@@ -553,6 +598,24 @@ static const struct opcode_info_t pre_fetch_iarr[] = {
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
+	     0xff, 0xff, 0xff, 0xff, 0x3f, 0xc7} }, /* REPORT ZONES */
+};
+
 
 /* This array is accessed via SDEB_I_* values. Make sure all are mapped,
  * plus the terminating elements for logic that scans this table such as
@@ -655,6 +718,15 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
 	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
 
 /* 30 */
+	{ARRAY_SIZE(zone_out_iarr), 0x94, 0x3, F_SA_LOW,
+	    resp_open_zone, zone_out_iarr, /* ZONE_OUT(16), OPEN ZONE) */
+		{16,  0x3 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		 0xff, 0xff, 0x0, 0x0, 0xff, 0xff, 0x1, 0xc7} },
+	{ARRAY_SIZE(zone_in_iarr), 0x95, 0x0, F_SA_LOW | F_D_IN,
+	    resp_report_zones, zone_in_iarr, /* ZONE_IN(16), REPORT ZONES) */
+		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
+/* sentinel */
 	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
 	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
 };
@@ -742,6 +814,11 @@ static int dix_writes;
 static int dix_reads;
 static int dif_errors;
 
+/* ZBC global data */
+static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
+static const int zbc_zone_size_mb;
+static const int zbc_max_open_zones = DEF_ZBC_MAX_OPEN_ZONES;
+
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
 
@@ -1446,20 +1523,22 @@ static int inquiry_vpd_b2(unsigned char *arr)
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
 
@@ -1579,7 +1658,7 @@ static int resp_inquiry(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			arr[3] = inquiry_vpd_b2(&arr[4]);
 		} else if (is_zbc && cmd[2] == 0xb6) { /* ZB dev. charact. */
 			arr[1] = cmd[2];        /*sanity */
-			arr[3] = inquiry_vpd_b6(&arr[4]);
+			arr[3] = inquiry_vpd_b6(devip, &arr[4]);
 		} else {
 			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
 			kfree(arr);
@@ -2550,9 +2629,185 @@ static int resp_log_sense(struct scsi_cmnd *scp,
 		    min_t(int, len, SDEBUG_MAX_INQ_ARR_SZ));
 }
 
-static inline int check_device_access_params(struct scsi_cmnd *scp,
-	unsigned long long lba, unsigned int num, bool write)
+static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
+{
+	return devip->nr_zones != 0;
+}
+
+static struct sdeb_zone_state *zbc_zone(struct sdebug_dev_info *devip,
+					unsigned long long lba)
+{
+	unsigned int zno;
+
+	if (devip->zsize_shift)
+		zno = lba >> devip->zsize_shift;
+	else
+		zno = lba / devip->zsize;
+	return &devip->zstate[zno];
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
+static void zbc_inc_wp(struct sdebug_dev_info *devip,
+		       unsigned long long lba, unsigned int num)
+{
+	struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
+
+	if (zbc_zone_is_conv(zsp))
+		return;
+
+	zsp->z_wp += num;
+	if (zsp->z_wp >= zsp->z_start + zsp->z_size)
+		zsp->z_cond = ZC5_FULL;
+}
+
+static int check_zbc_access_params(struct scsi_cmnd *scp,
+			unsigned long long lba, unsigned int num, bool write)
+{
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
+	struct sdeb_zone_state *zsp = zbc_zone(devip, lba);
+	struct sdeb_zone_state *zsp_end = zbc_zone(devip, lba + num - 1);
+
+	if (!write) {
+		/* Reads cannot cross zone types boundaries */
+		if (zsp_end != zsp &&
+		    zbc_zone_is_conv(zsp) &&
+		    !zbc_zone_is_conv(zsp_end)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE,
+					READ_INVDATA_ASCQ);
+			return check_condition_result;
+		}
+		return 0;
+	}
+
+	/* No restrictions for writes within conventional zones */
+	if (zbc_zone_is_conv(zsp)) {
+		if (!zbc_zone_is_conv(zsp_end)) {
+			mk_sense_buffer(scp, ILLEGAL_REQUEST,
+					LBA_OUT_OF_RANGE,
+					WRITE_BOUNDARY_ASCQ);
+			return check_condition_result;
+		}
+		return 0;
+	}
+
+	/* Writes cannot cross sequential zone boundaries */
+	if (zsp_end != zsp) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
+				LBA_OUT_OF_RANGE,
+				WRITE_BOUNDARY_ASCQ);
+		return check_condition_result;
+	}
+	/* Cannot write full zones */
+	if (zsp->z_cond == ZC5_FULL) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
+				INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
+	/* Writes must be aligned to the zone WP */
+	if (lba != zsp->z_wp) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST,
+				LBA_OUT_OF_RANGE,
+				UNALIGNED_WRITE_ASCQ);
+		return check_condition_result;
+	}
+
+	/* Handle implicit open of closed and empty zones */
+	if (zsp->z_cond == ZC1_EMPTY || zsp->z_cond == ZC4_CLOSED) {
+		if (devip->max_open &&
+		    devip->nr_exp_open >= devip->max_open) {
+			mk_sense_buffer(scp, DATA_PROTECT,
+					INSUFF_RES_ASC,
+					INSUFF_ZONE_ASCQ);
+			return check_condition_result;
+		}
+		zbc_open_zone(devip, zsp, false);
+	}
+
+	return 0;
+}
+
+static inline int check_device_access_params
+			(struct scsi_cmnd *scp, unsigned long long lba,
+			 unsigned int num, bool write)
 {
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
+
 	if (lba + num > sdebug_capacity) {
 		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
 		return check_condition_result;
@@ -2567,6 +2822,9 @@ static inline int check_device_access_params(struct scsi_cmnd *scp,
 		mk_sense_buffer(scp, DATA_PROTECT, WRITE_PROTECTED, 0x2);
 		return check_condition_result;
 	}
+	if (sdebug_dev_is_zoned(devip))
+		return check_zbc_access_params(scp, lba, num, write);
+
 	return 0;
 }
 
@@ -3153,10 +3411,13 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 			sdev_printk(KERN_ERR, scp->device, "Unprotected WR "
 				    "to DIF device\n");
 	}
+
+	write_lock(macc_lckp);
 	ret = check_device_access_params(scp, lba, num, true);
-	if (ret)
+	if (ret) {
+		write_unlock(macc_lckp);
 		return ret;
-	write_lock(macc_lckp);
+	}
 
 	/* DIX + T10 DIF */
 	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
@@ -3172,6 +3433,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	ret = do_device_access(sip, scp, 0, lba, num, true);
 	if (unlikely(scsi_debug_lbp()))
 		map_region(sip, lba, num);
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip))
+		zbc_inc_wp(devip, lba, num);
 	write_unlock(macc_lckp);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
@@ -3326,6 +3590,9 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 		}
 
 		ret = do_device_access(sip, scp, sg_off, lba, num, true);
+		/* If ZBC zone then bump its write pointer */
+		if (sdebug_dev_is_zoned(devip))
+			zbc_inc_wp(devip, lba, num);
 		if (unlikely(scsi_debug_lbp()))
 			map_region(sip, lba, num);
 		if (unlikely(-1 == ret)) {
@@ -3374,6 +3641,8 @@ static int resp_write_scat(struct scsi_cmnd *scp,
 static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 			   u32 ei_lba, bool unmap, bool ndob)
 {
+	struct scsi_device *sdp = scp->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
 	unsigned long long i;
 	u64 block, lbaa;
 	u32 lb_size = sdebug_sector_size;
@@ -3384,11 +3653,13 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	u8 *fs1p;
 	u8 *fsp;
 
+	write_lock(macc_lckp);
+
 	ret = check_device_access_params(scp, lba, num, true);
-	if (ret)
+	if (ret) {
+		write_unlock(macc_lckp);
 		return ret;
-
-	write_lock(macc_lckp);
+	}
 
 	if (unmap && scsi_debug_lbp()) {
 		unmap_region(sip, lba, num);
@@ -3421,6 +3692,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	}
 	if (scsi_debug_lbp())
 		map_region(sip, lba, num);
+	/* If ZBC zone then bump its write pointer */
+	if (sdebug_dev_is_zoned(devip))
+		zbc_inc_wp(devip, lba, num);
 out:
 	write_unlock(macc_lckp);
 
@@ -3948,6 +4222,426 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return ret;
 }
 
+#define RZONES_DESC_HD 64
+
+/* Report zones depending on start LBA nad reporting options */
+static int resp_report_zones(struct scsi_cmnd *scp,
+			     struct sdebug_dev_info *devip)
+{
+	unsigned int i, max_zones, rep_max_zones, nrz = 0;
+	int ret = 0;
+	u32 alloc_len, rep_opts, rep_len;
+	bool partial;
+	u64 lba, zs_lba;
+	u8 *arr = NULL, *desc;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_zone_state *zsp;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
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
+	if (zs_lba >= sdebug_capacity) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE, 0);
+		return check_condition_result;
+	}
+
+	max_zones = devip->nr_zones - zs_lba / devip->zsize;
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
+	read_lock(macc_lckp);
+
+	desc = arr + 64;
+	for (i = 0; i < max_zones; i++) {
+		lba = zs_lba + devip->zsize * i;
+		if (lba > sdebug_capacity)
+			break;
+		zsp = zbc_zone(devip, lba);
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
+
+	/* Report header */
+	put_unaligned_be32(nrz * RZONES_DESC_HD, arr + 0);
+	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
+
+	rep_len = (unsigned long)desc - (unsigned long)arr;
+	ret = fill_from_dev_buffer(scp, arr, min_t(int, alloc_len, rep_len));
+
+fini:
+	read_unlock(macc_lckp);
+	kfree(arr);
+	return ret;
+}
+
+/* Logic transplanted from tcmu-runner, file_zbc.c */
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
+	int res = 0;
+	u64 z_id;
+	enum sdebug_z_cond zc;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_zone_state *zsp;
+	bool all = cmd[14] & 0x01;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(macc_lckp);
+
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
+	zsp = zbc_zone(devip, z_id);
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
+	write_unlock(macc_lckp);
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
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	struct sdeb_zone_state *zsp;
+	bool all = cmd[14] & 0x01;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(macc_lckp);
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
+	zsp = zbc_zone(devip, z_id);
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
+	write_unlock(macc_lckp);
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
+	struct sdeb_zone_state *zsp;
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	bool all = cmd[14] & 0x01;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(macc_lckp);
+
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
+	zsp = zbc_zone(devip, z_id);
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
+	write_unlock(macc_lckp);
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
+	struct sdeb_zone_state *zsp;
+	int res = 0;
+	u64 z_id;
+	u8 *cmd = scp->cmnd;
+	bool all = cmd[14] & 0x01;
+	struct sdeb_store_info *sip = devip2sip(devip);
+	rwlock_t *macc_lckp = sip ? &sip->macc_lck : &sdeb_fake_rw_lck;
+
+	if (!sdebug_dev_is_zoned(devip)) {
+		mk_sense_invalid_opcode(scp);
+		return check_condition_result;
+	}
+
+	write_lock(macc_lckp);
+
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
+	zsp = zbc_zone(devip, z_id);
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
+	write_unlock(macc_lckp);
+	return res;
+}
+
 static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
 {
 	u32 tag = blk_mq_unique_tag(cmnd->request);
@@ -4053,6 +4747,76 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
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
+	 * Set the zone size: if zbc_zone_size_mb is not set, figure out a
+	 * zone size allowing for at least 4 zones on the device. Otherwise,
+	 * use the specified zone size checking that at least 2 zones can be
+	 * created for the device.
+	 */
+	if (!zbc_zone_size_mb) {
+		devip->zsize = (DEF_ZBC_ZONE_SIZE_MB * SZ_1M)
+			>> ilog2(sdebug_sector_size);
+		while (capacity < devip->zsize << 2 && devip->zsize >= 2)
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
+	if (is_power_of_2(devip->zsize))
+		devip->zsize_shift = ilog2(devip->zsize);
+	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
+
+	/* zbc_max_open_zones can be 0, meaning "not reported" (no limit) */
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
@@ -4072,6 +4836,13 @@ static struct sdebug_dev_info *sdebug_device_create(
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
@@ -5059,7 +5830,13 @@ static ssize_t ptype_store(struct device_driver *ddp, const char *buf,
 {
 	int n;
 
+	/* Cannot change from or to TYPE_ZBC with sysfs */
+	if (sdebug_ptype == TYPE_ZBC)
+		return -EINVAL;
+
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		if (n == TYPE_ZBC)
+			return -EINVAL;
 		sdebug_ptype = n;
 		return count;
 	}
@@ -5318,6 +6095,10 @@ static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 	int n;
 	bool changed;
 
+	/* Ignore capacity change for ZBC drives for now */
+	if (sdeb_zbc_in_use)
+		return -ENOTSUPP;
+
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		changed = (sdebug_virtual_gb != n);
 		sdebug_virtual_gb = n;
@@ -5708,6 +6489,12 @@ static int __init scsi_debug_init(void)
 	for (k = 0; k < submit_queues; ++k)
 		spin_lock_init(&sdebug_q_arr[k].qc_lock);
 
+	/*
+	 * check for host managed zoned block device specified with ptype=0x14.
+	 */
+	if (sdebug_ptype == TYPE_ZBC)
+		sdeb_zbc_in_use = true;
+
 	if (sdebug_dev_size_mb < 1)
 		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
@@ -5999,6 +6786,7 @@ static int sdebug_add_host_helper(int per_host_idx)
 	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
 				 dev_list) {
 		list_del(&sdbg_devinfo->dev_list);
+		kfree(sdbg_devinfo->zstate);
 		kfree(sdbg_devinfo);
 	}
 	kfree(sdbg_host);
@@ -6410,6 +7198,7 @@ static int sdebug_driver_remove(struct device *dev)
 	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
 				 dev_list) {
 		list_del(&sdbg_devinfo->dev_list);
+		kfree(sdbg_devinfo->zstate);
 		kfree(sdbg_devinfo);
 	}
 
-- 
2.25.3

