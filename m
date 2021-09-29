Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD98C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6CB1613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243612AbhI2JT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 05:19:28 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50575 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhI2JT2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 05:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632907066; x=1664443066;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=uJGQoQdXGTSCKFbGiZf4CBCF2bhaWe2wnJrV/LpxBdI=;
  b=PFAn6hdyTkRGqll6HZaOxu+WcPcvXtTUHQ/Ry1Gz4L6tTnMxnDtKRqd4
   uiON4O2GRR8uYa42VFuvD/5YZf9JZ3qdBcMJU0jPap5A7Q+rnCg0byxOF
   Cd2af01yk0Y4RxO5vu2ANLlRxyK7Kge3/7JyrNIGlubU/geWvLB6zEKpM
   IJ4nkCu2xz5B16RSb+DmPljAHIeav3NQYnQGaImgQysYE8AkY1f2p5B/w
   XPT/zhd/m0qtXLypkKm1/rTRZ0HOtIssqtZ2DWH19UmsM1cmk3XUmT83K
   wbpJRs84GAuwca+QuRL3X4X+TJ4op/LoweVr7Zies6HBxeZRE8YFXYZRB
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,331,1624291200"; 
   d="scan'208";a="181291269"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2021 17:17:46 +0800
IronPort-SDR: MLn5qCSGH8XskBkm6z2VNZKX46KMAFXMu0R/RWPvJCjlEMEYFrGGXOvpa2POmQTwJ3XAe/civ4
 ErbBwrMpSCm76EOkVMQOu7YYlht+WnuE/8psXxDfeymBi62SSO60Os6TWY4zZEkrhb/7jtlgkL
 EsT5XVsec7sB8cracGwAVPEpberRA9qpU5PyoJMnsQ1tQv41HvPViwYKa3reeXZ7cQJk/HGaLL
 3fd/ZbzGJuaAVD7e3VtlNkhRVtKAhZbxUAjQfJFbUDBjrBFr4FualcRTaOX93Jqbs2OK2EBJyi
 nnZC0RxJ7GwlEgCzo5i/uhT/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:52:18 -0700
IronPort-SDR: eP4DlZGG8zPQtVP7Yt+FVBrQ/6TYkeABregcw5eePXQiqwkzan4UjGljWPplkf/8TSq2DG9dYM
 50XhFiz/7JAbq4tf4bjj+7ZYW3Vd8Y0Oe60K1/5qUmNPHTIhYTMW2W9p29LVQY2urCtJPu8661
 c4+c55S6710B9deasOdCSe9vCgyz7MIqqAL2JpbYYFDgWXVV9zIgqqgP9r0VFVf6lHogE4IJmI
 IowM+TMGheVVafsd7JG0QrSl8nJJd8JsdvrNMZ72BhTnhtP871syZtvl5NwxtJHLZ5zTTL/+hv
 zdk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Sep 2021 02:17:47 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/2] scsi: simplify scsi_get_vpd_page()
Date:   Wed, 29 Sep 2021 18:17:43 +0900
Message-Id: <20210929091744.706003-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929091744.706003-1-damien.lemoal@wdc.com>
References: <20210929091744.706003-1-damien.lemoal@wdc.com>
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

