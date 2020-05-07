Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1068C28CBC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 02:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1DC207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 02:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hDtTuDOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgEGCf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 22:35:29 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28803 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgEGCf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 22:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588818929; x=1620354929;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Toye69yWtnNAOxrzPITFJ1VnpC3GvNtj9B24VaFykHM=;
  b=hDtTuDOdhxiEQQPF+QAk6W6/p/5zLaFVubsAD+s3l/WFZPD03ShZRs6x
   jyOLSXD9J3iWvCz227QaZq3KtDe/XKKOGzFkd48XqGRp1u6uhh5p02gnX
   cB7Wuc3XRne9P6n/QIn28BNU5zukfMwT2b3Te6THeZfmB90R3/yMrnaiC
   Cn0hqNl6oFbaLy+ggmVRkN8pr+dqYTD65odUnXxUBxbnQlRLlx0T3GNA7
   gIYHepTL+lg2j+xiECK6HOKuyVLvHkvsZ3tLBsr2QR6wjcdwloTshIMcB
   JfyIr/JF85RZpQJqItIokyFxwM9SZk+r0mnVg15egfuPbFHWT5Kit+Xq1
   w==;
IronPort-SDR: knfqCebiCYiOHv9jzTiKPhnhjlEfJYS7zs3x3Dchgyd+Z7TxyyDeJ9Q4ajwO4Ll4cDOC/IjeiE
 SdvCTs9fJGEk/sC9KO5Gvuq++apb+Rwj3HBIMw0Q5vPCTKelY2+5mLbW1zJZwKSsaGdpkHCBSt
 H4NNcnll9VyJSNWKJk2M3higSyDXNF0Vd80mFSkHpgCeqTIMGBgIDCuzeShksrzoN4hcpwv7LC
 VQzlowD3ziSKwNU84MCPUjrAFDrtfmVdy+ZyqOcyMSkuLOjuPxs1quyGGI0eezTWHJXMH2oho2
 34o=
X-IronPort-AV: E=Sophos;i="5.73,361,1583164800"; 
   d="scan'208";a="138525879"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2020 10:35:28 +0800
IronPort-SDR: 2LEvZwqngOdT6xKdSm0NFdbnknuff+gur7gE5pmS4LGm9SddnnSbdr9xLMU5ZzwrLwt/cWjplX
 SjNqv3LcIuroCobBXqc0BEq7DHvwGCxi0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 19:25:20 -0700
IronPort-SDR: yvM4N7F/oF76r/tnz17ksjeluSLs/pwbwQLAwbODc/7Ycbx5U6MJKTK39p3gUm3naZb5fxtk1+
 PtePc9T+OWNw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 May 2020 19:35:26 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: Fix compilation error on 32bits arch
Date:   Thu,  7 May 2020 11:35:26 +0900
Message-Id: <20200507023526.221574-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allowing a non-power-of-2 zone size forces the use of direct division
operations of 64bits sector values to obtain a zone number or number of
zones. Doing so without using do_div() leads to compilation errors on
32bits architecture.

Devices with a zone size that is not a power of 2 do not exist today so
allowing their emulation is of limited interest, as the sd driver will
not support them anyway. So to fix this compilation error, instead of
using do_div() for sector values divisions, simply disallow zone size
values that are not a power of 2 value, allowing to use bitshift for
divisions in all cases.

Fixes: 98e0a689868c ("scsi: scsi_debug: Add zone_size_mb module parameter")
Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d3ea16f3c12e..105e563d87b4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2657,13 +2657,7 @@ static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
 static struct sdeb_zone_state *zbc_zone(struct sdebug_dev_info *devip,
 					unsigned long long lba)
 {
-	unsigned int zno;
-
-	if (devip->zsize_shift)
-		zno = lba >> devip->zsize_shift;
-	else
-		zno = lba / devip->zsize;
-	return &devip->zstate[zno];
+	return &devip->zstate[lba >> devip->zsize_shift];
 }
 
 static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
@@ -4306,7 +4300,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 		return check_condition_result;
 	}
 
-	max_zones = devip->nr_zones - zs_lba / devip->zsize;
+	max_zones = devip->nr_zones - (zs_lba >> devip->zsize_shift);
 	rep_max_zones = min((alloc_len - 64) >> ilog2(RZONES_DESC_HD),
 			    max_zones);
 
@@ -4826,6 +4820,10 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 			return -EINVAL;
 		}
 	} else {
+		if (!is_power_of_2(sdeb_zbc_zone_size_mb)) {
+			pr_err("Zone size is not a power of 2\n");
+			return -EINVAL;
+		}
 		devip->zsize = (sdeb_zbc_zone_size_mb * SZ_1M)
 			>> ilog2(sdebug_sector_size);
 		if (devip->zsize >= capacity) {
@@ -4834,8 +4832,7 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 		}
 	}
 
-	if (is_power_of_2(devip->zsize))
-		devip->zsize_shift = ilog2(devip->zsize);
+	devip->zsize_shift = ilog2(devip->zsize);
 	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
 
 	if (sdeb_zbc_nr_conv >= devip->nr_zones) {
-- 
2.25.4

