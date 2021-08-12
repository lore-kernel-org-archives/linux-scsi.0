Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD6EC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54BF6103A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbhHLHoP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:44:15 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:17400 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhHLHoP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628754229; x=1660290229;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hL4R7IKEJ3CQSgb0OvIaeVnzifOcM6XgIINgrCxaOhQ=;
  b=lWqTrGRUS5z5XSzCyzIEmPtd2YVRbIZ6uPVuadXD4FKMXHXWvF+QFtGF
   yps8ETDsv9LeVfTS0dRWfLPFXe1lfwE/X4htHtxWHVAy3To+Gh0BupuaW
   nrK8DmDGIWecykm5fOB5z8Lv9+KaJ/FEjc0iQy+e74oCDn3Qk/MQz4BYF
   c7ka3lWSVZNIrNdolWOZVCBaUZWq6KoPAyjwz4VNcm5nVNVdawqK6aepB
   26GSO67YeDjZ5L0o9okIcvPpJ7y0YD3Tf/Gm7hZfpnLShByDDu1oKd25y
   785HqyOIxMlf7weJn0rRVTEglUEiKIUs/6u1JTamOAjiKEGaj3uuO9qL1
   w==;
X-IronPort-AV: E=Sophos;i="5.84,315,1620662400"; 
   d="scan'208";a="177022985"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 15:43:48 +0800
IronPort-SDR: M4rxCVDcnvMC3Mmqa7yOiX2VHr9AfWd0NSN9qPia5RtQAPtiQogAVtt5d1n9Su+igcB75et9gT
 LDIwDBECHJvd9qitCZOLrJ9kl9vVim5hzwbs26MYO+HZ1CXsqwsd6im71HuwlzSvSOaWUJC7+w
 TUjQkDmnD3y4d6ax9gJ+39vay6wjnQfahgtYtaHNfc8hz6y1zk3VzXl7g2Q9AgFkrH9jbIzrTN
 ZFeIngXUSVmnVWpZ2DUUz5tYjYRZID4OJTj/DsE4D/rJJvjwTZz0h1uaCQIC/73K8PgzwUwwpn
 OM6afTIsftrbDhWfMkV/q6WM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 00:21:09 -0700
IronPort-SDR: i/T/xFH067iQPqXv4Y5lT5VZvnGI/ubPNKt404MXahtiGtLswDtvdgcXQjN2a1ewxOSRy7Ty9Q
 pcRxHWqfhWeij9ZQCpFAW9F8zvnTp99hOvirM1dmPqRcBpjldb5vZYE2EP0N2GAiLdCKWMq63E
 6UjHg1cnvuPplPbhNmBKKzEyPvu017Z20NR7K7bPE/sCp3dH3SNUinFqNYNO6KuN9I8YVpsv/5
 UZCuk1imhLqfhQEdDKWWfmCLQ+1CXF4quXXQPcUNlOUg6A5/ssCq5Ku71rksOpFif0ips73vvc
 OIA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Aug 2021 00:43:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: cleanup scsi_get_vpd_page()
Date:   Thu, 12 Aug 2021 16:43:46 +0900
Message-Id: <20210812074346.1048470-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Get rid of all the gotos in scsi_get_vpd_page() to improve the code
readability and make it more compact. Also update the outdated kernel
doc comment for that function.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..14f7bb5e16cc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -339,47 +339,46 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
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
+	bool found = false;
 	int i, result;
 
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
+	for (i = 4; i < min(result, buf_len); i++) {
+		if (buf[i] == page) {
+			found = true;
+			break;
+		}
+	}
 
-	if (i < result && i >= buf_len)
-		/* ran off the end of the buffer, give us benefit of doubt */
-		goto found;
-	/* The device claims it doesn't support the requested page */
-	goto fail;
+	/* If we ran off the end of the buffer, give us benefit of doubt */
+	found = found || (i < result && i >= buf_len);
+	if (!found)
+		/* The device claims it doesn't support the requested page */
+		return -EINVAL;
 
- found:
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

