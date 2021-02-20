Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15FDC433E6
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2D564ED2
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBTVkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:40:13 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50438 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhBTVkJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857208; x=1645393208;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t+dWcFkfTOpQy5hRzCq1aDeZCc0SYWDCIdkoPXD+ysM=;
  b=Q1Cqlbsx/8/WbUuE7xcFc0dpKZVKxl/OuMu+g3DTZHxyboXkMjPywZ3h
   snlKY0JjcvWQan1HloXhQKM4vESR/cmRZh9DuYSXHLB4Udqe8QHVvVCEP
   Jwu+utGLytbXznNhTUE2XhALNYfGZECYXw7sLO+CeGVR0xjixMkkKwDpd
   clnl66AEoZVyZSVO3YVW4kcjbXrLO/RZ5PTSehr6y6Ibht8Yivocqcr2+
   yBfoc9McVvZaRs0JFFhCjxDku3G+itUN4THAdE8dGQOJyRjrFewNriIL5
   cF3njsrTqWVcClY4ZKwRF3G48pfxofJdLG+IfN62+DDNw97laHBMrJrqr
   Q==;
IronPort-SDR: FtN6aIVTdq6+AvNMZa/VMHHHUqTC+lWYsVB4iI2+WesZoEgJUbvwfh3MzKUg9X++FXUVe0okQU
 AgnKjCEZCDADm4tR5jPawo0Mlt8eogShLamo8wkajAwZ8+juQ1mkqlzvXnS2fF7/Q8kWMLhs2p
 xb/2nD3GuSt9shgMfLoog06RimsUOSjfdn91PfKjc1ot/TvZ8H6Skdid2io9l9Mhab3vb1Zvvi
 xzpcEidQty/Di4MmDO5Kr6jp0ODxiviriH7UmnF7PvyzO2b0s5pXefnI/igN9VaxZ4lD+BKWym
 tNg=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="160409685"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:39:14 +0800
IronPort-SDR: 6yM9cQimorA1jRWlOdTWYkMtB53mPPy0PIUuXwmL+6vkc+0qtNpp7daNYfoQRxqXPLqBZq3+p5
 AheKxjD7xlt+i5hSlkGVKnWbos/Vg8xMSuqosXy+DUB3zGETGVd4O6ehcxLuYBQinCztILeyOs
 Ep2+LhmeMq1Pp4D3FRXAzbeQgAli7XAF5AOp1PwPcnS2R8tdBvzOQRqry/ZboYs/61gXjs4p9O
 ZZETI4DDSWztNBJFE+u+C3J2c60m1FlwEZJWJSMql9/1vJGUUKhrG0HgaCw2Q4wQ+5fbO214Fq
 2yod442DfNA87P0+z3huggOQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:22:37 -0800
IronPort-SDR: Zzzzy8+0Zr9WPSq8dKwVu6gKeT6mFckmWMdH2UKE0ertHIehnNyG92d8PkJK9ROgLEUC5xVgmJ
 lxea6ZVsGP2TgAYexH6+KRHC+Z6sz1CVydVWqJ1jN+l/zl8Gz70oqOXSVc55MD7cTv9fVJ0e6D
 dkHXhtrhc10e7t6pWbIiPf94vG/QkKbOYTTb6qhFSqErovjzfEWlWmTKv4ZGyFptE2t2MOxW9k
 SdnJrru+CuYLWRH24KbPD5jU/W/DqW6kIOxyV/nI4dXAa2elnoG0EJP5tI0LT14uULv3Nigg8N
 QLM=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:39:15 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 13/24] target/configfs: remove the memset with declare-init
Date:   Sat, 20 Feb 2021 13:39:13 -0800
Message-Id: <20210220213913.6919-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/target/target_core_configfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f04352285155..56ea47f5cda9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1494,7 +1494,7 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 {
 	struct t10_wwn *t10_wwn = to_t10_wwn(item);
 	struct se_device *dev = t10_wwn->t10_dev;
-	unsigned char buf[INQUIRY_VPD_SERIAL_LEN];
+	unsigned char buf[INQUIRY_VPD_SERIAL_LEN] = { };
 
 	/*
 	 * If Linux/SCSI subsystem_api_t plugin got a VPD Unit Serial
@@ -1536,7 +1536,6 @@ static ssize_t target_wwn_vpd_unit_serial_store(struct config_item *item,
 	 * Also, strip any newline added from the userspace
 	 * echo $UUID > $TARGET/$HBA/$STORAGE_OBJECT/wwn/vpd_unit_serial
 	 */
-	memset(buf, 0, INQUIRY_VPD_SERIAL_LEN);
 	snprintf(buf, INQUIRY_VPD_SERIAL_LEN, "%s", page);
 	snprintf(dev->t10_wwn.unit_serial, INQUIRY_VPD_SERIAL_LEN,
 			"%s", strstrip(buf));
-- 
2.22.1

