Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80635C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 01:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46A0B60FBF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 01:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237936AbhHMBIH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 21:08:07 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:6845 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbhHMBIG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 21:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628816860; x=1660352860;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G4GN7Odo66thHpxJuONrfYH9oGBSbL9IvXa1Rcamqu0=;
  b=N7H5Qwli3viD7gdiiAD3xE97U6LOlYUPuO9WQMMhNxQK6exsrbLoezPi
   GyHk7aCK/He7KcmVtNPcvKyAZjhNf/vZHYQZ6WfqsZ4rEKKPbtu2rkF7R
   Jd9wEDVdwxWu0uApmlXNtVDna579h/V3V8rKU9UvBVv1ZntUIJEirCGcL
   vPswufNw/01+6qvqrFoBkPFWnWbwBzFwEHQvm5BFVxTdeuHFv07/6P8Um
   Qs1LpPPPd+5ZYgLvZ+Z61wUv3FVhUe2yQoO+YXqT5l35trIlKT9pW13Af
   ruDp7v9oyHpJhX/Sd20cvkq0lx01Lwa814bevwsUSw81PRaciKMcdHgwv
   A==;
X-IronPort-AV: E=Sophos;i="5.84,317,1620662400"; 
   d="scan'208";a="288679416"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Aug 2021 09:07:40 +0800
IronPort-SDR: ofCayen6gehD2LI9vNzS69dmIsx9iYSX9kW3l/0P3x8pSJ3X8O1OfKnBPI+nQvRuO3vn3uMGlG
 H8piZsV+l9gPpiHId6U7tvRKnGOmmO7zURDumCEOYeyLuaiURO/skP8R3MqtHfrrDicukoouz5
 IZR6xrarKrAZVThAP1BlATZy9n3lKFT7j5wZY4DVPvNbUg+0rXcvnNFmGOfcrA4OCs+9hXjCg3
 Vpgu2XjmzUgGf2fQjQalGimewefvqFqBdy6oB/4RntbaCghwBnWmnRqDkvB1F+hOLWtuj3avwp
 JMyAiXaIDxZNOao4zIlupw1H
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 17:44:58 -0700
IronPort-SDR: QNmBIO/d+vEtbJXgrDxMG7H2es4gA1J0l9DeE6pFrQu1SIk/IJ/c4n5Jh4EIyPiwAJsqdIGxsg
 +fhkfhrCgGymhQU80OQ+sMmgtREkVZrk9DjlKDWtKUq0e9DuUe4QzRahCwerXsotpiO6BXC1c4
 BVGCHgpVuiAfE7kFdJOgly0aeh6p7PqChV6BxDRxtfxbpLzavh1KFcyUbj3q7sWH/vxrhdIc2q
 Qwwj3ggYoS/k0KgXEG07tplWVDl5pm9lG0oin9Le9dvvTj09Etg7cE/qUGeyttmF0FmIYFMh8g
 JaI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Aug 2021 18:07:40 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2] scsi: simplify scsi_get_vpd_page()
Date:   Fri, 13 Aug 2021 10:07:38 +0900
Message-Id: <20210813010738.1204219-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove unnecessary gotos in scsi_get_vpd_page() to improve the code
readability. Also use memchr() instead of an open coded search loop
and update the outdated kernel doc comment for this function.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from v1:
* Keep the "found" goto and use memchr() in place of the page search
  loop, as suggested by Bart.
* Update the patch commit title and message

 drivers/scsi/scsi.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d26025cf5de3..4946d8c4f298 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -339,47 +339,43 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
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
+	int result;
 
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
+	if (memchr(&buf[4], page, min(result, buf_len)))
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

