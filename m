Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C61D9C55186
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B1220656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eyTFJYSU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbgDVKnA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:43:00 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22889 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731754AbgDVKmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552151; x=1619088151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+cLDQ57gI+KrE69yCX0VN2j46gSUQU1CHuyPoqo3Odc=;
  b=eyTFJYSUbOD9cSKfjiyWR4daY/nlTGskAc++lZQEbJkII9zoBQijTiYc
   2GVgq3FvznCRw5jaloSMa7Tf6VQ4SaNSaiP4HqxNfnTcQHqanZSdeWwEE
   hmorDW+n+/mFCJ5DKgGyS0fzXYd/nnTFB72NsR02u+GL2diW280l6sYnb
   OVgaV8IXgEwDKGTWOKwpwGi0IXmJF0hQWFWO5BcmdxHBBbKrhK9H0K3QO
   cChuq14vN9vX7H/l0STV6eWYzPqPe9antfVAry47HDva7+2aHh6amhZ4R
   j41EjvSs8XWhfdJ0jcaPi6M/O18mEdzgd1NuMiL6lVv2hSK9Y5ili2A0I
   g==;
IronPort-SDR: 6QhbFIEMzq6fwwDLpTsSbOHQxsobIls2MFArQfkz4Th2CCvR6f68v89nwE7AmeuPDKg5L7tgHa
 0p/CZ3S/gFaKQKgCqZFmfVfWgmdXIPowTmTy/nF0v+1jwVl7de3WQnBe6ExstOh0hR+L91H7As
 WHbTG5lfhLYn8EnwfFGWJWuC4zDC9oxdwst/oDiXsy6E5uZtBKDMrJsq9r2nBSdr4Lr4F0CzRH
 lAsnQ4J6CEBdhu2PcEftYfcg0PUo/eDW+mEEPTN+sKXQH+YP2G8N2DZzwnaaudVN9GX1lstYFy
 2Vc=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230025"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:27 +0800
IronPort-SDR: rzjMGzGZVmA+58okJBS/EijpjezGXcyQEYKQdCqb2y6DfeiUgU+FqIlPZ52w0XuZWheDBZZ6qP
 OvOE2jMA85mNlFuScr/uBGoO1k7CztLck=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:16 -0700
IronPort-SDR: HeOiEX9kSnekyyKAp0CP6wGS4ehmVVtZ4v9y0jeNmwOKdQ3AX5G6rKQh5PNtU52K6NDNuwv8+Z
 YCU6gGqt6ZmQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:25 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 5/7] scsi_debug: add zone_nr_conv module parameter
Date:   Wed, 22 Apr 2020 19:42:19 +0900
Message-Id: <20200422104221.378203-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow controlling the number of conventional zones of a zbc device
with the new zone_nr_conv module parameter. The default value is 1
and the specified value must be less than the total number of zones
of the device. This parameter is ignored for device types other than
0x14 (zbc=2 case).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 36aeda10a117..058e6d19b21d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -157,6 +157,7 @@ static const char *sdebug_version_date = "20200421";
 /* Default parameters for ZBC drives */
 #define DEF_ZBC_ZONE_SIZE_MB	128
 #define DEF_ZBC_MAX_OPEN_ZONES	8
+#define DEF_ZBC_NR_CONV_ZONES	1
 
 #define SDEBUG_LUN_0_VAL 0
 
@@ -296,6 +297,7 @@ struct sdebug_dev_info {
 	unsigned int zsize;
 	unsigned int zsize_shift;
 	unsigned int nr_zones;
+	unsigned int nr_conv_zones;
 	unsigned int nr_imp_open;
 	unsigned int nr_exp_open;
 	unsigned int nr_closed;
@@ -823,6 +825,7 @@ static int dif_errors;
 static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
 static const int zbc_zone_size_mb;
 static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
+static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
 
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
@@ -4787,6 +4790,12 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 		devip->zsize_shift = ilog2(devip->zsize);
 	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
 
+	if (sdeb_zbc_nr_conv >= devip->nr_zones) {
+		pr_err("Number of conventional zones too large\n");
+		return -EINVAL;
+	}
+	devip->nr_conv_zones = sdeb_zbc_nr_conv;
+
 	/* zbc_max_open_zones can be 0, meaning "not reported" (no limit) */
 	if (sdeb_zbc_max_open >= devip->nr_zones - 1)
 		devip->max_open = (devip->nr_zones - 1) / 2;
@@ -4803,7 +4812,7 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 
 		zsp->z_start = zstart;
 
-		if (i == 0) {
+		if (i < devip->nr_conv_zones) {
 			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
 			zsp->z_wp = (sector_t)-1;
 		} else {
@@ -5541,6 +5550,7 @@ module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO);
 module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
+module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5604,6 +5614,7 @@ MODULE_PARM_DESC(wp, "Write Protect (def=0)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host-' prefix");
 MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit (def=auto)");
+MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.25.3

