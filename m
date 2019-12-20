Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD6BC43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 07:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4055720716
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 07:58:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iSVESJ9A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLTH62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:58:28 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:17693 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLTH61 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 02:58:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1576828706; x=1608364706;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=w6qdMFq6hk3CvIqCMFquodJHaCAxb9EoKcudmEE+Xvw=;
  b=iSVESJ9AgKqOISJQmQjbIClkI/WUaE0MB1bqo2CnLGEuiUjXZwwkM9Hd
   dOh/K2F5BNXQSGAdEDnrsbcXygRk9Y7VJznNOXdnFRqwgjPYxwkMeIFd8
   Yf/Fi0XPp4O8V1m93bEz4h9X4wbI9gI/2Iw8dD1hHg1aWlGkTUGQ3cdUl
   UvDGiwQOUdta25fqycPwENEzWqN/YsFKUNylb0/f7Ml1FKqrDTj+qUXov
   xGEQLjSucoYKhADUQKbLVKlAr/Is373fozskVTxysFgtlgX5LgehUNreH
   IeBP7z9Z7DedaET8Sn3dkpRKNhcbu1gsCj1zDhdlcB21OZuYk90Q8QfhN
   A==;
IronPort-SDR: aGN3fRhGwGRQzGiGuQ3oCMqK2z/KPucQfD0CSe6z+ZJkc5e7kVedS1zE+82rJyvAGtwr5roiaM
 Jk0e1yEc84K+ZluzZJFs1jyAUe3HUwvfKD1xVE5jWTm9mnUg6a8nK9TVVyGPaIHsUqOLXuc/k1
 T+28iUDM0LV3MR5B5F2HRgpHK/R6RJsPXRCQhd1y9+lzRo5P7PcSKiCWf2Mxm6YZZf77MG6Kf0
 iKp/r/bZRv4LTO+lQ/kpjGloe6V8cUl73BCENgdGwvGVkSkOOmk0gnCVcoCdGLGxqMNIDYHkGw
 mLs=
X-IronPort-AV: E=Sophos;i="5.69,335,1571673600"; 
   d="scan'208";a="233424643"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2019 15:58:26 +0800
IronPort-SDR: hFnG4nW2Byrq0Hvc83H+skbZHGahJTZu1rHCu5K6g2WpeihtDQ9iDHA4yVJACRqy/BcUa/iZQT
 +M7hcoMkXYlCj72pKaVBndoD1iUz6ekXHgZGhu0Q9iFW9IQHnHue3XAQr9J7z4SdvivPAo2C9L
 fne1srhp6G9iP8kixFI9UlWz//RfUoAhdj8BnH4bxPNgiLgN7k6PT4fIQSgJ4cPs/UDO7YMFIc
 +QZmmyWEGiIclIKCbmICZ0B6WC/kmcOVfsb4okypf8UTGUUseLbfvdE/gMvk6CXP1iw1ypxwDU
 hk5NEZkEGIeDM8wnA/Um/Bg1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 23:52:46 -0800
IronPort-SDR: 9Ggj4jnzl0k9ECJ8ubBtP4xJ+guOC4A72ZKEIZso6F8n6qWNAwW2NpObcBtFI5yT93HYaSxeKI
 f75U+95h+zQE02vGl94GmHnY+fd4ySFBQsnkj9YJypcD5HaVGwPjGouLUnHZD4wqRkr7KWOcSG
 6eLrrnWhhx5jwi5QuEvM5pFqMhjt6pNeJD21WAM3E8AjTr1NuqqXqz4YA+B1H1qOyIaNxGpPc9
 8RBs9AypPdpytsD62rxQlc3c39InfMPoShVrvtme+M1HW7T8+Y39nch7jEK3DAfq0bvPFeIN2f
 ZWc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 19 Dec 2019 23:58:26 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] scsi: sd_zbc: Rename sd_zbc_check_zones()
Date:   Fri, 20 Dec 2019 16:58:23 +0900
Message-Id: <20191220075823.400072-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220075823.400072-1-damien.lemoal@wdc.com>
References: <20191220075823.400072-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the block layer implement zone checks on revalidate,
sd_zbc_check_zones() is reduced getting the zone size and verifying the
device capacity for device with RC_BASIS=0. Be clear about this by
renaming sd_zbc_check_zones() to sd_zbc_check_capacity() and updating
the function description and comments.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd_zbc.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index aca6367ced06..e4282bce5834 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -325,19 +325,21 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 }
 
 /**
- * sd_zbc_check_zones - Check the device capacity and zone size
+ * sd_zbc_check_capacity - Check the device capacity
  * @sdkp: Target disk
+ * @buf: command buffer
+ * @zblock: zone size in number of blocks
  *
- * Check that the device capacity as reported by READ CAPACITY matches the
- * max_lba value (plus one)of the report zones command reply.
+ * Get the device zone size and check that the device capacity as reported
+ * by READ CAPACITY matches the max_lba value (plus one) of the report zones
+ * command reply for devices with RC_BASIS == 0.
  *
- * Returns the zone size in number of blocks upon success or an error code
- * upon failure.
+ * Returns 0 upon success or an error code upon failure.
  */
-static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
-			      u32 *zblocks)
+static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
+				 u32 *zblocks)
 {
-	u64 zone_blocks = 0;
+	u64 zone_blocks;
 	sector_t max_lba;
 	unsigned char *rec;
 	int ret;
@@ -360,7 +362,7 @@ static int sd_zbc_check_zones(struct scsi_disk *sdkp, unsigned char *buf,
 		}
 	}
 
-	/* Parse REPORT ZONES header */
+	/* Get the size of the first reported zone */
 	rec = buf + 64;
 	zone_blocks = get_unaligned_be64(&rec[8]);
 	if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
@@ -394,11 +396,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	if (ret)
 		goto err;
 
-	/*
-	 * Check zone size: only devices with a constant zone size (except
-	 * an eventual last runt zone) that is a power of 2 are supported.
-	 */
-	ret = sd_zbc_check_zones(sdkp, buf, &zone_blocks);
+	/* Check the device capacity reported by report zones */
+	ret = sd_zbc_check_capacity(sdkp, buf, &zone_blocks);
 	if (ret != 0)
 		goto err;
 
-- 
2.23.0

