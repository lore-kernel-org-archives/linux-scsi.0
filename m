Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2152AC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED1360EBC
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 03:23:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbhHTDYO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 23:24:14 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54070 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhHTDYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 23:24:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629429816; x=1660965816;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JS8xdQ0AKfIy7VN4Fx/OdR3t2GQOc6yIzhkAMcGqHgs=;
  b=EemRjKWwclMT2x9ij8UGrBPj3DfCVvlVZQPy0juWi6/4kQ3Ae34HyGlX
   3Bej3/f/oDDWiPYnMRzbmugBPmcoxWMXTjQyZpi6geDc+1OizkXn1wRp+
   xPhUG1atOEegpdMUCs1ijALYrc9SpvtG6hicRBELs7nZ1SID7cpJIxjlK
   13qYIsD0pdF/7xWiyfezssa97lB/pDGrfv/wLGu4CRZiitOWdQ23PG2Ks
   amsqhq4Vep72r96UR7wZNFkBaL/xHKa9XHy4qmzm8A16zy0j6dBx04TIQ
   RJM7pIS7De/Gqp8hREIssvwaykFL29e4PPs0JH9Ld/RvT2ymDvKVVFdTJ
   w==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="177015128"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 11:23:35 +0800
IronPort-SDR: f3DpfRn5vS0E0amew0j7p/aS90UlULxWjzH2uHvk3STI5cpkC6DP6/TwGwWi0tlk+lKqzNJuEI
 OK+UGy6ldoz+L4Dn/n6Vl2MLQBt3WOZoR9PzEVmgCeKP8SwI1A3/P8/ueVdGH8g3Uiz5nDLktk
 JMiAICKQXZ/cf19frJUCFnKmR2JLv+x2DNcaDDZUR/Q5V+pc/K59jbOq/RH2nfL3tuCIt3eqLO
 Rv3PToDhplocNb2ArFj1oM7YKMykkxVgeZI5UTrhgug1AtSa69vcSGkRvEFeuoDSaKppGwpWFX
 2N+P2Z5yNRw9cNVA8t/fYiDw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 19:58:55 -0700
IronPort-SDR: ttwEFSXsVOWKVLVGx62s0YT7yK8rm9xQZFpNYXEKKnbg27IH1OJMz+xDu+sUzlR2/in6lPX6Ba
 j+Xy2S8KVOCliaoYfAB1cRq8nBp45tgFfg5407QluhwR5+9JZ/P0yzEn51vXbZ8JkgBCW4ovX1
 2aOnB93YzTNvAxW9cVtQz47ZjfTPWxvb+EJfPSOaLO2JkH620TQoRscYLwCnaaUidA3hsC+RdF
 O6dgIRE4T9vC7byvTDEGR6fo4CUdEIrxJQNxMEP5nfsmjMQjBB4PExzQ2tqwzDXhPGjeHPeuvH
 DHc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Aug 2021 20:23:34 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Date:   Fri, 20 Aug 2021 12:21:54 +0900
Message-Id: <20210820032154.574953-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove unnecessary gotos in scsi_get_vpd_page() to improve the code
readability and use memchr() instead of an open coded search loop.
Also update the outdated kernel doc comment for this function.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
Changes from v1:
* Fix memchr() use to avoid accesses beyond the buffer and result size.

 drivers/scsi/scsi.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..6be68b3427a0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -339,47 +339,44 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
  *
  * SCSI devices may optionally supply Vital Product Data.  Each 'page'
  * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
- * If the device supports this VPD page, this routine returns a pointer
- * to a buffer containing the data from that page.  The caller is
- * responsible for calling kfree() on this pointer when it is no longer
- * needed.  If we cannot retrieve the VPD page this routine returns %NULL.
+ * If the device supports this VPD page, this routine fills @buf
+ * with the data from that page and return 0. If the VPD page is not
+ * supported or its content cannot be retrieved, -EINVAL is returned.
  */
 int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 		      int buf_len)
 {
-	int i, result;
+	int result, len;
 
 	if (sdev->skip_vpd_pages)
-		goto fail;
+		return -EINVAL;
 
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
 	if (result < 4)
-		goto fail;
+		return -EINVAL;
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
 		return 0;
 
-	for (i = 4; i < min(result, buf_len); i++)
-		if (buf[i] == page)
-			goto found;
+	len = min(result, buf_len);
+	if (len > 4 && memchr(&buf[4], page, len - 4))
+		goto found;
 
-	if (i < result && i >= buf_len)
-		/* ran off the end of the buffer, give us benefit of doubt */
+	/* If we ran off the end of the buffer, give us benefit of doubt */
+	if (result > buf_len)
 		goto found;
+
 	/* The device claims it doesn't support the requested page */
-	goto fail;
+	return -EINVAL;
 
  found:
 	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
 	if (result < 0)
-		goto fail;
+		return -EINVAL;
 
 	return 0;
-
- fail:
-	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
-- 
2.31.1

