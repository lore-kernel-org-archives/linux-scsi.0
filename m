Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6872EC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1876A61492
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 05:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhA1F6F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 00:58:05 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5797 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhA1F6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 00:58:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611813484; x=1643349484;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MObu/i/+owTQN+gcjWVkbFJdstC4hJrGOxnmmCXuCpA=;
  b=ppfgSPONrJ7QX12CwMn9WZnz4Q5CAJQhS1VTwWOaixYbWc7QsOiu9cyG
   8sSniOCiXRlsQhzRsSz4NFJ8WHEpTiLl+v2VLBA1nfx1GdALDcF3FHs4K
   IQ74a5eVxW0wMpF5wXCu//LMjjv9AbuBvML0Eck896Ye8fa+dnfWqIweL
   Cr33HsAKnAS3/MZazJS8FsmX3daDwa20ABAb2gOpf+qPlB89qyGz1eKwI
   jWJYOuYaY0/kOWLdnQPBUBNYJhNLS5GtbBDZqdXKziVFQ2XG3aeWOOYPw
   yVaYxXg+WDH2t5miBS56iqNlKaCCfFcB366nbqkMe5PiyzI1cQHJ4OncH
   A==;
IronPort-SDR: 0379xTzkf4+rNSlWZBQchiLNWk4oALsU5ThMNzReaHDBPz/z0j9QARgi/p+ywYKVTvCwm8PyS1
 CWCFM5mxM8vx+LQDWdaM3QzglBN3CpOe6gQqls0pcmlk1sqkSdcYInpozoJxTw8ruHwyuyRQb2
 y3QB3pv5Ftg4t7dy5WQG5AH/+G1tieucgctr1OpJpSiJDJ0vt5U7zyabfVdFDmk/Tc17ynpdWS
 cQRsy44Xq4mlv5Rtvkfey2rbz9pNqYhWckoz74DKw//FXE4eTVTLpWMvTNGDoV1ME1nWveTyNy
 s30=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158513162"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 13:56:59 +0800
IronPort-SDR: nee9cLZiDXqneMkO7U8NTBF3nV2sfp9VuHUcSVx8oQ4FSAbFvnyzwjZCMSWmlpj3X7hj4ChTom
 cbRhKTf4iDQ2LtPFhb58/36fBgjcFKipsId1ggo6o1CRjKkXK+npvd/7bNxzWAs9LtAcxVo5xL
 xdhnPeGb46s02FtgLd1wj+jDQMHEQTzW3gcSw7HCHYYC5pprixsvPkj0uodkfwbFUGJjcXDSRs
 3FULpQKvVbmqFHcV/WrxoNR/yAqhyolpiq4IPXzpVceHUWMPkfHMcubg/1G2mbPIMmDc9fyfoU
 NTwR2wv0vjAmQQidA++TyzqY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 21:39:18 -0800
IronPort-SDR: 7PmCqv8La26Y9zLazrAadj/ZViycYHWJ0jtn7C/bMgp0FdeX2+er6Xi4EWIZCRid9rRtjSwD8s
 4bS6/3B4ZsGRx32rkxvrYsOuxsmodJSs9feeFiPSRkGcEEfAxnX0rHI+CLiba2FlPKQ3pQsu2N
 NFP+MbvvgmtUIoMsDAZnUSnwmpavAYWBX+QSN3fYt2f8wF53CbNwJW3Cw6xiHpmi8j7c7O6xZG
 6dgrdsbGKXeEmy1pM1bz9Z31dkG4u6WQL68yTJfJPoNTkYRaZTvpMUZLVDw2M5j0rOSkje0oMP
 f9s=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 21:56:59 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: warn if unsupported ZBC device is probed
Date:   Thu, 28 Jan 2021 14:56:58 +0900
Message-Id: <20210128055658.530133-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In sd_probe(), print a warning if CONFIG_BLK_DEV_ZONED is disabled and a
TYPE_ZBC device is found. While at it, use IS_ENABLED() to test if
CONFIG_BLK_DEV_ZONED is enabled instead using of a #ifdef.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a3d2d4bc4a3d..6e41ecbf4399 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3379,10 +3379,12 @@ static int sd_probe(struct device *dev)
 	    sdp->type != TYPE_RBC)
 		goto out;
 
-#ifndef CONFIG_BLK_DEV_ZONED
-	if (sdp->type == TYPE_ZBC)
+	if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) && sdp->type == TYPE_ZBC) {
+		sdev_printk(KERN_WARNING, sdp,
+			    "Unsupported ZBC host-managed device.\n");
 		goto out;
-#endif
+	}
+
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
 					"sd_probe\n"));
 
-- 
2.29.2

