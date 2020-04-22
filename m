Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC29C55186
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93E920656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fKaB29ED"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgDVKme (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:42:34 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22892 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731747AbgDVKm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552146; x=1619088146;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BApQX12KK7VHObqatMX8LszPi/l58RbP+elKeXLDErM=;
  b=fKaB29EDGuGQ0mHxZKbpaFD2tll1Fb3ZgwyvEm+lztw8/uzgle9pVwbk
   GSkGEhSNjK4gPxJzU+1tGd+sh+nG6HtrUOpFFkNUaLgUtFX+7FTDWQJSu
   jRl7uKzt+b7BjMOCcVH+qyeo7atgWOcKZQo1PTpfE6nu50qNR/QBhw/R9
   kut5ZbBTlqH0d6ykp8HdNzEdJOYUdtUvFMRtP6zfDhGqEzjHI9MgLuyVw
   hTrydU+PyTqHQQxy/Qm84KQ3DZI6ppPT0Ns/SxE/69ayvMYSWbGYxVo8W
   JgSCl49vxNKItsRh7fS17HnaqpbW3eOmfO77Th8DfLI7L88qoeU2SVMYe
   g==;
IronPort-SDR: xoEH6UJMDu0v7khClnXaFNJnLQ9F+39Dd5ZLAWBMB3CmXAekF5X4DrWEtpnFD87Y5PP7LF/GfI
 pkW7KUYVylHour8zI/jy2zzFol7FNAmrR+SIManerC9xhvkhELAaoDCoumgDyzIc18U0ay2Elz
 Lt+kfzSAfuGkVLtFioiSHAzX1Up4a0ATCF2OK77KEcxhyq3BVfvOUUtEhOL9w+foS2NXISPnXF
 7D+1uziMWhYB/r3eCvQH43idy4Jp0YgFFTC7GnqsnOIHx0fesaztEaoACpS72GAmkLMEc03VRR
 P9k=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230022"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:25 +0800
IronPort-SDR: pQYmhcsIbh9lLfYLbcGLyN7fqk9lff1yur3y9N0UbcyOqlZ0gF4QNxM0Qw8XhaNPvjI7HSxp+B
 aKEGPSmx/YfopkD6ah8btOvOLKVWj9sew=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:15 -0700
IronPort-SDR: BvvgEYTzfZ82P17X2kixzEbaeLfPXJUKTGc9qqY6sCozbJgeTX4SvekL8nxT/j+QqiMmqn9UkQ
 EkC1acebKIrg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:24 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 3/7] scsi_debug: add zbc module parameter
Date:   Wed, 22 Apr 2020 19:42:17 +0900
Message-Id: <20200422104221.378203-4-damien.lemoal@wdc.com>
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

Add the zbc module parameter to take either:
    0: none         (probably a conventional disk)
    1: host-aware
    2: host-managed

These values are chosen to match 'enum blk_zoned_model' found in
include/linux/blkdev.h . Instead of "none", "no" or "0" can be given.
Instead of "host-aware", "aware or "1" can be given. Instead of
"host-managed", "managed" or "2" can be given.

Note: the zbc parameter can only be given at driver/module load
time; it cannot be changed via sysfs thereafter.

At this time there is no ZBC "host-aware" implementation so that
string (or the value '1') results in a modprobe error.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 81 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 10214017d478..6ef01b97e1ae 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -113,7 +113,9 @@ static const char *sdebug_version_date = "20200421";
 #define DEF_ATO 1
 #define DEF_CDB_LEN 10
 #define DEF_JDELAY   1		/* if > 0 unit is a jiffy */
+#define DEF_DEV_SIZE_PRE_INIT   0
 #define DEF_DEV_SIZE_MB   8
+#define DEF_ZBC_DEV_SIZE_MB   128
 #define DEF_DIF 0
 #define DEF_DIX 0
 #define DEF_PER_HOST_STORE false
@@ -736,7 +738,7 @@ static int sdebug_add_host = DEF_NUM_HOST;  /* in sysfs this is relative */
 static int sdebug_ato = DEF_ATO;
 static int sdebug_cdb_len = DEF_CDB_LEN;
 static int sdebug_jdelay = DEF_JDELAY;	/* if > 0 then unit is jiffies */
-static int sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
+static int sdebug_dev_size_mb = DEF_DEV_SIZE_PRE_INIT;
 static int sdebug_dif = DEF_DIF;
 static int sdebug_dix = DEF_DIX;
 static int sdebug_dsense = DEF_D_SENSE;
@@ -785,6 +787,9 @@ static bool have_dif_prot;
 static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 static bool sdebug_wp;
+/* Following enum: 0: no zbc, def; 1: host aware; 2: host managed */
+static enum blk_zoned_model sdeb_zbc_model = BLK_ZONED_NONE;
+static char *sdeb_zbc_model_s;
 
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
@@ -5534,6 +5539,7 @@ module_param_named(vpd_use_hostno, sdebug_vpd_use_hostno, int,
 module_param_named(wp, sdebug_wp, bool, S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
+module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5595,6 +5601,7 @@ MODULE_PARM_DESC(virtual_gb, "virtual gigabyte (GiB) size (def=0 -> use dev_size
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(wp, "Write Protect (def=0)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
+MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host-' prefix");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
@@ -6359,6 +6366,45 @@ static ssize_t cdb_len_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(cdb_len);
 
+static const char * const zbc_model_strs_a[] = {
+	[BLK_ZONED_NONE] = "none",
+	[BLK_ZONED_HA]   = "host-aware",
+	[BLK_ZONED_HM]   = "host-managed",
+};
+
+static const char * const zbc_model_strs_b[] = {
+	[BLK_ZONED_NONE] = "no",
+	[BLK_ZONED_HA]   = "aware",
+	[BLK_ZONED_HM]   = "managed",
+};
+
+static const char * const zbc_model_strs_c[] = {
+	[BLK_ZONED_NONE] = "0",
+	[BLK_ZONED_HA]   = "1",
+	[BLK_ZONED_HM]   = "2",
+};
+
+static int sdeb_zbc_model_str(const char *cp)
+{
+	int res = sysfs_match_string(zbc_model_strs_a, cp);
+
+	if (res < 0) {
+		res = sysfs_match_string(zbc_model_strs_b, cp);
+		if (res < 0) {
+			res = sysfs_match_string(zbc_model_strs_c, cp);
+			if (sdeb_zbc_model < 0)
+				return -EINVAL;
+		}
+	}
+	return res;
+}
+
+static ssize_t zbc_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%s\n",
+			 zbc_model_strs_a[sdeb_zbc_model]);
+}
+static DRIVER_ATTR_RO(zbc);
 
 /* Note: The following array creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
@@ -6401,6 +6447,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_strict.attr,
 	&driver_attr_uuid_ctl.attr,
 	&driver_attr_cdb_len.attr,
+	&driver_attr_zbc.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
@@ -6490,11 +6537,39 @@ static int __init scsi_debug_init(void)
 		spin_lock_init(&sdebug_q_arr[k].qc_lock);
 
 	/*
-	 * check for host managed zoned block device specified with ptype=0x14.
+	 * check for host managed zoned block device specified with
+	 * ptype=0x14 or zbc=XXX.
 	 */
-	if (sdebug_ptype == TYPE_ZBC)
+	if (sdebug_ptype == TYPE_ZBC) {
+		sdeb_zbc_model = BLK_ZONED_HM;
+	} else if (sdeb_zbc_model_s && *sdeb_zbc_model_s) {
+		k = sdeb_zbc_model_str(sdeb_zbc_model_s);
+		if (k < 0) {
+			ret = k;
+			goto free_vm;
+		}
+		sdeb_zbc_model = k;
+		switch (sdeb_zbc_model) {
+		case BLK_ZONED_NONE:
+			sdebug_ptype = TYPE_DISK;
+			break;
+		case BLK_ZONED_HM:
+			sdebug_ptype = TYPE_ZBC;
+			break;
+		case BLK_ZONED_HA:
+		default:
+			pr_err("Invalid ZBC model\n");
+			return -EINVAL;
+		}
+	}
+	if (sdeb_zbc_model != BLK_ZONED_NONE) {
 		sdeb_zbc_in_use = true;
+		if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
+			sdebug_dev_size_mb = DEF_ZBC_DEV_SIZE_MB;
+	}
 
+	if (sdebug_dev_size_mb == DEF_DEV_SIZE_PRE_INIT)
+		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
 		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
-- 
2.25.3

