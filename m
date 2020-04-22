Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA196C5518A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1F620656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:42:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="E39VhEhu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731757AbgDVKmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:42:35 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22891 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731755AbgDVKmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552152; x=1619088152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wIn54DAzeuSnCiK9eWszO2wXPcN+stuUNMbgtoVYqOY=;
  b=E39VhEhuwDU4hHnRqZlAwOzpzMIsGJupjVmBf4XXl/xG7URJn1P5Bt9Y
   pUOxT0IUlSSv9WUH2IpaKG0Wp6bOp+fQ3vxrwhAIDvozNrd6V/CHBOkFv
   JaeWO9lNP+wUHVfd7jHqaZAJU0ZWHN+qa8bdYHxL5y3wdK5lGQ/3kIlRe
   MgMAmNodoGzRWVios2xvNsRsYRxlHxZPfs3ZvBjh52MKJDD+smYQbSh68
   c1CBGinZczN41BeVUsvbTKYx/e+o7g3em3Zl5HVqv6QfjIVG2NRkfqcpR
   jzpLHTXC1MFmsFAYyRFmhPUGTO0WY//UkWfBfoAy4x/MKDLyjt68R67iL
   w==;
IronPort-SDR: r8We6UTGmXDmWORGHP7zJZhXMG2jEXWDRiI+fOiI1TkttgObmlGKmOuGGhhIxtBzQ8O7TLy+je
 L31mE4mUkYB+5l9Y1qjlOOSPBb80TAWHC9gLly07p8HaMQ7gemDYiZGj+s+upoSohggItoHAtd
 CTYDi2Ok9n3qKNqDVHHX0wZRyPAGgSgD/jzN1v2ofnRAWz2oaiv6PaKfCC7syBMAxO46cTrMBL
 iVvLQ1R2Z2F/K2P+qMqangz2AK888UA+kdouGVAjy3DRETKSUxe5xm5A8Ddrc/1+01S0BIAoEQ
 T9g=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230026"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:28 +0800
IronPort-SDR: dqktuAvUjR2BSIU8TUFwxBYBnVTM7N6Z+bVzRECC3u6rJ5ZQecumVCh69yRyZfNCXOEtUaQYT5
 kFZW4IdOlqu0vzMRaHzjVmAPdYXrV9dzo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:17 -0700
IronPort-SDR: mbURds7REDBDB4hDxdbpm6PZDQXJtI7db2CySb07Ypw4xDGBwQye+5xwhP27E7KXcbIouhfZ3l
 Uu3vc7vLxO8w==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:26 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 6/7] scsi_debug: add zone_size_mb module parameter
Date:   Wed, 22 Apr 2020 19:42:20 +0900
Message-Id: <20200422104221.378203-7-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the zone_size_mb module parameters to control the zone size of a
ZBC device. If the zone size specified is not a divisor of the device
capacity, the last zone of the device will be created as a smaller
"runt" zone. This parameter is ignored for device types other than
0x14 (zbc=2 case).

Note: for testing purposes, zone sizes that are not a power of 2 are
accepted but will result in the drive being rejected by the sd driver.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 058e6d19b21d..9279ac9bb98d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -823,7 +823,7 @@ static int dif_errors;
 
 /* ZBC global data */
 static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
-static const int zbc_zone_size_mb;
+static int sdeb_zbc_zone_size_mb;
 static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
 static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
 
@@ -4763,12 +4763,12 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 	unsigned int i;
 
 	/*
-	 * Set the zone size: if zbc_zone_size_mb is not set, figure out a
-	 * zone size allowing for at least 4 zones on the device. Otherwise,
+	 * Set the zone size: if sdeb_zbc_zone_size_mb is not set, figure out
+	 * a zone size allowing for at least 4 zones on the device. Otherwise,
 	 * use the specified zone size checking that at least 2 zones can be
 	 * created for the device.
 	 */
-	if (!zbc_zone_size_mb) {
+	if (!sdeb_zbc_zone_size_mb) {
 		devip->zsize = (DEF_ZBC_ZONE_SIZE_MB * SZ_1M)
 			>> ilog2(sdebug_sector_size);
 		while (capacity < devip->zsize << 2 && devip->zsize >= 2)
@@ -4778,7 +4778,7 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 			return -EINVAL;
 		}
 	} else {
-		devip->zsize = (zbc_zone_size_mb * SZ_1M)
+		devip->zsize = (sdeb_zbc_zone_size_mb * SZ_1M)
 			>> ilog2(sdebug_sector_size);
 		if (devip->zsize >= capacity) {
 			pr_err("Zone size too large for device capacity\n");
@@ -5551,6 +5551,7 @@ module_param_named(write_same_length, sdebug_write_same_length, int,
 module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO);
 module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
+module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5615,6 +5616,7 @@ MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xff
 MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host-' prefix");
 MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit (def=auto)");
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
+MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.25.3

