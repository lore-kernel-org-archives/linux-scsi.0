Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1E7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 10:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C543761B27
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 10:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhKSKZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 05:25:08 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8421 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbhKSKZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 05:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637317327; x=1668853327;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YeeI3xnG9DNwbGK+nxEuis1KFWs7UygsQbxy2bzwMQE=;
  b=ZyH8r6eW7G8ycueS7dB8PccpR12RVolLDdtXqrAesxigZne1aNV3YQJU
   m1WIQb3OlMLPj8d3blfiPDKISvAP4AMjWkjf2/6ZRvlD2L3eusFEOwCoz
   T/FMLI7ZR+td0MUmgwUDO9UcwcRlKsLsIxOlhERtc3Qiv+hTE33aWnFJE
   UzCqo4plf8xBkfHL/F+25FoMwlkcIdf43hVL23l1YmQJ2A6dhtVh3KDKh
   Q9E/dl3+gRtMToK8ASWn/gNWBUKG9PC+qJS15i/12DEBMhkDeAOGmhd6v
   FdECE4o1BVXijK0HjyS846WQz3mzPQNzqlSd8eCmmCb85vN9lwMhP9TGe
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="187084469"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 18:22:06 +0800
IronPort-SDR: Q1gKPyJAZzObOGr/mf7AN+P1pFLAKQCN5ITItP+q6aUinjyM7ZCmE/mMrCLMXOxvGcO34jwk2F
 fDDewUIYJ9TupYGPB+Zk9fOuf4kO1S1KWuUPCHn5FN2ae5eO6diAUDAtzL5/EC/YHSME9NevLI
 OyzVU4W+vIjsLsMzXKNCzyg/nrWTEfrjyRxDNh4kMFOSdJxuztqd3mjOgKSjhQJc5fh+Nmg/mQ
 9qvGIylY8hLmoIUdSCLgaXkiWbXFH3136Cj/6lighrOamtVkTIxpgqXV3XX9g5t8gTg1wLQhbd
 TXELiK8tTHrntUQETuPd7r41
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 01:55:32 -0800
IronPort-SDR: LvCKL967XmWrDTqxUgudrndL4GpM4sov/ozrY3JcnpCN+QLbRoovfrPe0VniihJ30JYLTyHusE
 sDtm18HkpqNShvDM8Q8a4t398FfLfEgWp+Zk0SN/xl4UVetUBd3o8luWvSSamaAkwLs9tC3ZUx
 flj+FEkb0SWCAcj7R6x7/V02XhWcorbByIrGuQSZu+883mto250iLJMLf+yDWVuUsSD1z5jOti
 W9VqPuS7bKohh60KYKk5S5F6JgXzlA1J8d6gx0Uvq5YWRPPzYpg9v+FZHuuTHK8wMOLm520oPU
 27U=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Nov 2021 02:22:06 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: scsi_debug: Zero clear zones at reset write pointer
Date:   Fri, 19 Nov 2021 19:22:04 +0900
Message-Id: <20211119102204.259762-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When reset write pointer is requested to scsi_debug devices with zoned
model, positions of write pointers are reset, but the data in the target
zones are not cleared. Read to the zones returns data written before the
reset write pointer. This unexpected left data is confusing and does not
allow using scsi_debug for stale page cache test of the BLKRESETZONE
ioctl. Hence, zero clear the target zones at reset write pointer.

Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1d0278da9041..6d1f1a4a6724 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4653,6 +4653,7 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 			 struct sdeb_zone_state *zsp)
 {
 	enum sdebug_z_cond zc;
+	struct sdeb_store_info *sip = devip2sip(devip, false);
 
 	if (zbc_zone_is_conv(zsp))
 		return;
@@ -4667,6 +4668,9 @@ static void zbc_rwp_zone(struct sdebug_dev_info *devip,
 	zsp->z_non_seq_resource = false;
 	zsp->z_wp = zsp->z_start;
 	zsp->z_cond = ZC1_EMPTY;
+
+	memset(sip->storep + zsp->z_start * sdebug_sector_size, 0,
+	       devip->zsize * sdebug_sector_size);
 }
 
 static void zbc_rwp_all(struct sdebug_dev_info *devip)
-- 
2.33.1

