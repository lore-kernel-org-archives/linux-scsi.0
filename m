Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B770C3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 07:58:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 106ED20716
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 07:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q4cNHY4d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLTH60 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:58:26 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17693 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfLTH60 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 02:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576828706; x=1608364706;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=8/JVBVyrS4cWhpTQA6W/i29gYoZ2DA82O6megmp5lMM=;
  b=Q4cNHY4dEcrD5WV6nzEfF9NnSoblOobqo4tZ4Y5W9j86Y/4kU4vCYD7l
   miQuqUN5f3kqLDPkekIKefKu36zc09IG1z3PIRQgIEL0cn7qT/HwMRxuJ
   UfT1cIyBPNPE5MAXobTS7DTRFPligpLcMuaAfwIbFymkHkvfFGf1QutFb
   LjwRbVA1kMJCMfeVi17H4z0HapZVaVjnnn+a12s6E5Gfzf5Eo6BPFefDd
   Yv/Gq56QgJtML8Ok+Tp1MM8kJOK27Z9c0lUJPr3ms/+kalrgEcr24zryo
   0zPIvGijbrZZxS+l0R/OL+KFYax/uB1hjnwn1KpJceIphE3t8YR62GMYp
   g==;
IronPort-SDR: Vm6Eh6UlA+BEQBLQDWsQGBFQ3bSddRjBFXDOtNcu7Ax0Xtdln4/r0aVmXVGZ0sBEq9naSKfpDL
 hnledbqrS62GgbHKDBbJNjAtbtBZ3Ql4LiYsUsilskZXU4fiZOb/fZ+ookbLoyFAb8zZdB+NRX
 nL21vM1GXMGQpBf0h9Wp0imi0xGXptKDpMoGvPsJc8PfCdWJZZplPjhTA3Bt01wXI1xbg+MvGY
 GJUEXXZdxeuG4Y9bgUTYmxuzVRVNtmtP26vb5o6iXCPiMxo5N4PE9tLsgzfFfwrm9y4M32iHrK
 hRc=
X-IronPort-AV: E=Sophos;i="5.69,335,1571673600"; 
   d="scan'208";a="233424641"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2019 15:58:25 +0800
IronPort-SDR: ch4c8WtDvQCGoKAs7yvlKv1FX9w57YJFIO7Rpp3898sjpp08kUPwE+LIO6b7ucBSfZ231pr+h1
 TbMqyJiM3GUgGkyDbbm0c91WjI5RY1m0ATONMX9y9Likp42zusIovHDCK/8hHnvz21ZH4PtWbU
 lhyCwvxeErij8z0/uinB0zvzz2pTfO0uJOPkxbMN7VCX6A2W665Bm3c5r3agAT4f1ba0VdGq8u
 PoN9o6KBJWDOLMFi8vrvxXhrL3IvQdkQuIop1IzreoyFMnewGixLApvZgvRAt9e57RK1qJr3B5
 gppz3GADTDIVoHekpW8Pxda7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 23:52:45 -0800
IronPort-SDR: jrL405SHLvoiZdFX8akz9AlAYBhD3nff1GjWNk+6lJy90MxrGaDDgmyemhBH4ohQobftYsx/Cv
 oJ6ymuUFk52fIxOxPwhUQ/ER4xA3eOLrB2yNgEC8YN2lIBQo21+W/cbyfv7rIW0xqsLu20HgCv
 /Vt9saONlU34LDATMeFgAprjQ7Bh5CO/UzOb2TXzsclobGQMnMqgegj3BV+u75MiG73zzSzNgY
 wSVkZATDMWfQtrCMu3MqMaOHDJeoYWCZIAk/8OHv5RPsfp+tf07Q8ur63IleShD3Ips776OZXC
 CA4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Dec 2019 23:58:26 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] scsi: sd_zbc: Simplify sd_zbc_check_zones()
Date:   Fri, 20 Dec 2019 16:58:22 +0900
Message-Id: <20191220075823.400072-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220075823.400072-1-damien.lemoal@wdc.com>
References: <20191220075823.400072-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the block layer generic zone revalidation code in
blk_revalidate_disk_zones() checks for power of 2 zone size, there is
no need to do it in sd_zbc_check_zones(). Remove this check.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e0bd4cf17230..aca6367ced06 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -325,14 +325,11 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 }
 
 /**
- * sd_zbc_check_zones - Check the device capacity and zone sizes
+ * sd_zbc_check_zones - Check the device capacity and zone size
  * @sdkp: Target disk
  *
  * Check that the device capacity as reported by READ CAPACITY matches the
- * max_lba value (plus one)of the report zones command reply. Also check that
- * all zones of the device have an equal size, only allowing the last zone of
- * the disk to have a smaller size (runt zone). The zone size must also be a
- * power of two.
+ * max_lba value (plus one)of the report zones command reply.
  *
  * Returns the zone size in number of blocks upon success or an error code
  * upon failure.
@@ -366,14 +363,6 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	/* Parse REPORT ZONES header */
 	rec = buf + 64;
 	zone_blocks = get_unaligned_be64(&rec[8]);
-	if (!zone_blocks || !is_power_of_2(zone_blocks)) {
-		if (sdkp->first_scan)
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Devices with non power of 2 zone "
-				  "size are not supported\n");
-		return -ENODEV;
-	}
-
 	if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
 		if (sdkp->first_scan)
 			sd_printk(KERN_NOTICE, sdkp,
-- 
2.23.0

