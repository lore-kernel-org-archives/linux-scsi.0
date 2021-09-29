Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277BDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1123E613A9
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243667AbhI2JT3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 05:19:29 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50575 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhI2JT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 05:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632907066; x=1664443066;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=qP/na06NorDfR9chdWLBRuVYPwFDbNT4xexr+vGaWUw=;
  b=iLY3Cl0IvbNbOSyKibctLd12LOuBbGImqIys+sjtRF52GU96slIU0a2J
   mYzvQqu0nmmlAolY3fe9wX74ca5ISEHmzKKz1hOGIAbtu9/yFVgmLssON
   pTaH+hyQJB73AEPreMylJKED/32PpTv1OezoWs+RJ9IbA/epeJK0G46qS
   oUaj73bfo7VUZ7ZWWbamaCiUImZszeZYenNHlztMAUqNB5vNys5cxsfBd
   Rb3dUHtndFO+TYCNi07Rpq8Lzfobysbqap6dI+cXXEe4SPVop0dSc0oFH
   bPO0fW4tGPK16cmVgdLIY4q24zaDr9WKPrSELtg94jbVNPzFDCblkj4gD
   g==;
X-IronPort-AV: E=Sophos;i="5.85,331,1624291200"; 
   d="scan'208";a="181291272"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2021 17:17:46 +0800
IronPort-SDR: QF2w09T2xIlqgXRwLJjGGkhAr3tO2WYqkFObgfg9aO8qys24WwH2tacAY5rQPOfw/pf9e1baCV
 slaVs6Z4eqU2HpVBy85XXmasfGPZoAlHIweAxbCFDGVMLS9v40wvjsTQ92d3y6pv7iKbQIHoDA
 PMs7UKi5qjH6ykW+WiX6tOiNMwUyrlFMihCdW3mNwuLZJ/qAkEuB86tJU7z5iOMmKKRDBzONFW
 xs/0uP5R7Uj11qtcf5UcLhygtxEpUTXEDnhDYUtMDmJEEMd60+nWzyUhP/o6ThOLyP4YQaMPld
 Gtn6mzx4KFeJVtBwu9UbYHD0
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:52:19 -0700
IronPort-SDR: rXye01TfaWEJ1Hk1eRXQ+ixHSsDaWyAKrGPH61mj0YbWnY/TZmNSwXIP1Iz9KoW1haHyCtZOjV
 hjXBsr+ghWOXWke+zHGs6hbJ03gPWCfuxBr2BUOnRnmLGhipswBGUU6H1Vvg6UFzZGluvuT6aY
 zOzEd7n+/xr67leaZuj4Z/l/UsRZBfrFJ6uthTURqZGpqXD6cXD2YAZ7PLEEPMTL6P46eJzLVH
 HQbc5EIt7YzkVsqtW//sg5mluVpe6BA8kFRgu6bi8lB7+4M/XcnjAjpWo4F9xcJWrHXzb4rd4/
 LXo=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Sep 2021 02:17:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] scsi: fix scsi_mode_select() interface
Date:   Wed, 29 Sep 2021 18:17:44 +0900
Message-Id: <20210929091744.706003-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929091744.706003-1-damien.lemoal@wdc.com>
References: <20210929091744.706003-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The modepage argument is unused. Remove it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c    | 8 +++-----
 drivers/scsi/sd.c          | 2 +-
 include/scsi/scsi_device.h | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dcf105287a76..f1fe5803d7ec 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2001,7 +2001,6 @@ void scsi_exit_queue(void)
  *	@sdev:	SCSI device to be queried
  *	@pf:	Page format bit (1 == standard, 0 == vendor specific)
  *	@sp:	Save page bit (0 == don't save, 1 == save)
- *	@modepage: mode page being requested
  *	@buffer: request buffer (may not be smaller than eight bytes)
  *	@len:	length of request buffer.
  *	@timeout: command timeout
@@ -2014,10 +2013,9 @@ void scsi_exit_queue(void)
  *	status on error
  *
  */
-int
-scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
-		 unsigned char *buffer, int len, int timeout, int retries,
-		 struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
+int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
+		     unsigned char *buffer, int len, int timeout, int retries,
+		     struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
 {
 	unsigned char cmd[10];
 	unsigned char *real_buffer;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 71fa70b42c2b..89b5eea0ea0c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -209,7 +209,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	 */
 	data.device_specific = 0;
 
-	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
+	if (scsi_mode_select(sdp, 1, sp, buffer_data, len, SD_TIMEOUT,
 			     sdkp->max_retries, &data, &sshdr)) {
 		if (scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09a17f6e93a7..1a9d2fe6aa02 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -415,9 +415,8 @@ extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 			   int retries, struct scsi_mode_data *data,
 			   struct scsi_sense_hdr *);
 extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
-			    int modepage, unsigned char *buffer, int len,
-			    int timeout, int retries,
-			    struct scsi_mode_data *data,
+			    unsigned char *buffer, int len, int timeout,
+			    int retries, struct scsi_mode_data *data,
 			    struct scsi_sense_hdr *);
 extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
-- 
2.31.1

