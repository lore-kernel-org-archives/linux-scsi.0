Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA441C433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95B820715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NA5hRhFM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgGFMdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37662 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038830; x=1625574830;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XL5DCWDWIQygV5i3Im5vcWH3rrQNLaW35XdZbeJI/5o=;
  b=NA5hRhFMa7yWoVK+VTOciA6YJ9ywoN9rU4D2wEKEn5FDzbYOawCncoX3
   5/0MEzGwhVK38tM6QUy6RwlDI2+NYtJxUdzw7EebIp6Rb+WKKuBLbVDDa
   +sYpxhUPuXssK4Nyr9CUuQRjncKy68PrEnToeyvUe8Hw8qEDA4sTSFghy
   0so4cOGuCd4a745D+ybxPZ+lVBDy9clcmyPQH/rk878wyE2r8XvwuCajd
   /4coqVRBopYostFT/qkeAJnXv6oJDwqPZcnom1z7T3lgoL74vEUJKCakG
   bC8FNmT40SMKBpv8hhD2kzvTtFxTwEHY4w4LN/4VTi5xEMFYQKo0XRQrF
   A==;
IronPort-SDR: w+7XKfO3QtbdoDY0S/hpp9HL+Cm6/iGU7ZfiKHZu9oVLEcYYAEGUIDn1JV9ELZwbEgBLiWw/wz
 HEgHSvhDBp9fxcYYg/KdXZ/7qUkXLwKxK8XqwUuFpT9BVPr6TmmlK50jkttO4BVYV/OtohGnps
 4o5CfEhfusFVJgKPY0zCXnhtbPgeOgfyeU13X/vvdfJ9X5aUBX6lDGGFvcu7QXYT3w4QbUrWPl
 LoLS0hGWzQk55vaARYlG63cktWRVwA9LNvRLTiaoaw7718rkcbiFHbyMLayFzETGvyA0CKggBg
 ZHY=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052059"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:50 +0800
IronPort-SDR: GztNl5FB/A9Gwz5Zz2r890WXDYT9cOWabTaQSeJ2iMzQybIvlqzT1xkbR4hnFJ2PrNli5hCyR3
 oNCb3oYptUvceW8CaUrDv9vjMgERJFDfI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:21:58 -0700
IronPort-SDR: CrCFkiZz2u0LCosFuCsSqkwFw0HQo78EDagJkppuBHfzGM+L2HXnEOrsH5zdeOWdAjvWYBIoFO
 edrAeicGfrWg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:49 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 03/10] scsi: megaraid: Remove set but unused variable
Date:   Mon,  6 Jul 2020 21:33:48 +0900
Message-Id: <20200706123348.451871-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The variable remainder is unused in mega_div64_32(). Remove it to avoid
a compiler warning. While at it, also fix the function documentation
comments.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 3b3d04d7671f..b6c08d620033 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -80,21 +80,20 @@ u32 mega_mod64(u64 dividend, u32 divisor)
 }
 
 /**
- * @param dividend    : Dividend
- * @param divisor    : Divisor
+ * mega_div64_32 - Do a 64-bit division
+ * @dividend:	Dividend
+ * @divisor:	Divisor
  *
  * @return quotient
  **/
 static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
-	u32 remainder;
-	u64 d;
+	u64 d = dividend;
 
 	if (!divisor)
 		printk(KERN_ERR "megasas : DIVISOR is zero in mod fn\n");
 
-	d = dividend;
-	remainder = do_div(d, divisor);
+	do_div(d, divisor);
 
 	return d;
 }
-- 
2.26.2

