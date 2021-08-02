Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E294C4320E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A96610CC
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 09:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhHBJDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:03:04 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:6561 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhHBJCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 05:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627894957; x=1659430957;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UsY3zNp+4Y74npaMKBNtjE5KDrgJ0zn2Z35nPaW5zAw=;
  b=Gy6xEpswTaRX/cFKp1hC7z1pOCCDTymYAaDrYfwVGaKoGEs5FZ4OVgpK
   p6dxD6yXslTPamOoMLQ7E0U3E0Wndj+rwyk4/pMJfQCGt9TcjpzsAfjVx
   srjU13QdkNNUhmfejjvy79pNvRMkxB4m+EgYopqdOPlptD1o8U1z3pl6q
   lgm06iJ0vYLrwpgAhhTkr3FHGDaMN7nZUZwzEkcIAiZ7PLhBkGmRjUnwr
   lQahc4bGPsC0uy96GzzrRMOFKvVuUGxIkPL1F208m/x5NWKeyrFcf/2tg
   UuYZMgdWoBBVzJTudkQtG4+puzG33D1JGJjyHuv6UtAnSo0XyRsEa58ML
   g==;
X-IronPort-AV: E=Sophos;i="5.84,288,1620662400"; 
   d="scan'208";a="180887618"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2021 17:02:35 +0800
IronPort-SDR: kta8M1woVs3bLcxqlGIRVr48DXQTmu1rk+dX5oRxMdJCoMPBaAPfnvw/MCiHX7tkCehVWeYeYa
 bBzrkOCJle2boHkv7Z+aoAuwjQKPWaH/r6JCdmj3GZ47elXRaGWuqPHnUAdxLoiw7rU12OdUT1
 +tSHZ7lkmPK211LUxewU7xO07amgFu1l/ocTwx0DhiHCqaIbiDcRSUjugTZmEvKgvLg8MyKwiW
 nJ6NSKs0G3fFsUHsVlRehu6MNFKdCn5vB28dWu5PBr+n2q76BqT0+q45zv0zDKBLQsrqrSaail
 b5yqENajdawuSjuB/YfNTryG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 01:40:11 -0700
IronPort-SDR: hDPe+nS0Z6HFpfRLqYn91XXcM27Q5PFchkFGfaY/sylQOz+vHRErky7KYwVB2iFBd6S42vTH+0
 vw0r/bzSv3dQSxHeEOIKZx8HAhwYxv8uCNi4wMjYt/tqpbL5ptLZtl3cSiComBHhQhD0LSrIjY
 PLjur0cBlAZGt+qOkjKg7ngkBsTDFt8Qibk+kTcdc+R/2USZKDiYsyqBY69P7K6wo3WbqKRHQo
 GBMiXDW6zfkowJLTTSVYXWT558wBXBS5rRerabXtJrZiJwSvKQR7nIguAPn1HLGSedgtMwqt33
 hFY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Aug 2021 02:02:36 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 2/7] libata: cleanup ata_dev_configure()
Date:   Mon,  2 Aug 2021 18:02:27 +0900
Message-Id: <20210802090232.1166195-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802090232.1166195-1-damien.lemoal@wdc.com>
References: <20210802090232.1166195-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the helper functions ata_dev_config_lba() and
ata_dev_config_chs() to configure the addressing capabilities of a
device. Each helper takes a string as argument for the addressing
information printed after these helpers execution completes.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 110 ++++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 51 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9b39a4e2e567..1849f858761b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2363,6 +2363,52 @@ static void ata_dev_config_trusted(struct ata_device *dev)
 		dev->flags |= ATA_DFLAG_TRUSTED;
 }
 
+static int ata_dev_config_lba(struct ata_device *dev,
+			      char *info, size_t infosz)
+{
+	const u16 *id = dev->id;
+	int info_ofst;
+
+	dev->flags |= ATA_DFLAG_LBA;
+
+	if (ata_id_has_lba48(id)) {
+		dev->flags |= ATA_DFLAG_LBA48;
+		strcpy(info, "LBA48 ");
+
+		if (dev->n_sectors >= (1UL << 28) &&
+		    ata_id_has_flush_ext(id))
+			dev->flags |= ATA_DFLAG_FLUSH_EXT;
+	} else {
+		strcpy(info, "LBA ");
+	}
+	info_ofst = strlen(info);
+
+	/* config NCQ */
+	return ata_dev_config_ncq(dev, info + info_ofst,
+				  infosz - info_ofst);
+}
+
+static void ata_dev_config_chs(struct ata_device *dev,
+			       char *info, size_t infosz)
+{
+	const u16 *id = dev->id;
+
+	/* Default translation */
+	dev->cylinders	= id[1];
+	dev->heads	= id[3];
+	dev->sectors	= id[6];
+
+	if (ata_id_current_chs_valid(id)) {
+		/* Current CHS translation is valid. */
+		dev->cylinders = id[54];
+		dev->heads     = id[55];
+		dev->sectors   = id[56];
+	}
+
+	snprintf(info, infosz, "CHS %u/%u/%u",
+		 dev->cylinders, dev->heads, dev->sectors);
+}
+
 static void ata_dev_config_devslp(struct ata_device *dev)
 {
 	u8 *sata_setting = dev->link->ap->sector_buf;
@@ -2418,6 +2464,7 @@ int ata_dev_configure(struct ata_device *dev)
 	char revbuf[7];		/* XYZ-99\0 */
 	char fwrevbuf[ATA_ID_FW_REV_LEN+1];
 	char modelbuf[ATA_ID_PROD_LEN+1];
+	char lba_info[40];
 	int rc;
 
 	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {
@@ -2539,61 +2586,22 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 
 		if (ata_id_has_lba(id)) {
-			const char *lba_desc;
-			char ncq_desc[24];
-
-			lba_desc = "LBA";
-			dev->flags |= ATA_DFLAG_LBA;
-			if (ata_id_has_lba48(id)) {
-				dev->flags |= ATA_DFLAG_LBA48;
-				lba_desc = "LBA48";
-
-				if (dev->n_sectors >= (1UL << 28) &&
-				    ata_id_has_flush_ext(id))
-					dev->flags |= ATA_DFLAG_FLUSH_EXT;
-			}
-
-			/* config NCQ */
-			rc = ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));
+			rc = ata_dev_config_lba(dev, lba_info, sizeof(lba_info));
 			if (rc)
 				return rc;
-
-			/* print device info to dmesg */
-			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_info(dev, "%s: %s, %s, max %s\n",
-					     revbuf, modelbuf, fwrevbuf,
-					     ata_mode_string(xfer_mask));
-				ata_dev_info(dev,
-					     "%llu sectors, multi %u: %s %s\n",
-					(unsigned long long)dev->n_sectors,
-					dev->multi_count, lba_desc, ncq_desc);
-			}
 		} else {
-			/* CHS */
-
-			/* Default translation */
-			dev->cylinders	= id[1];
-			dev->heads	= id[3];
-			dev->sectors	= id[6];
-
-			if (ata_id_current_chs_valid(id)) {
-				/* Current CHS translation is valid. */
-				dev->cylinders = id[54];
-				dev->heads     = id[55];
-				dev->sectors   = id[56];
-			}
+			ata_dev_config_chs(dev, lba_info, sizeof(lba_info));
+		}
 
-			/* print device info to dmesg */
-			if (ata_msg_drv(ap) && print_info) {
-				ata_dev_info(dev, "%s: %s, %s, max %s\n",
-					     revbuf,	modelbuf, fwrevbuf,
-					     ata_mode_string(xfer_mask));
-				ata_dev_info(dev,
-					     "%llu sectors, multi %u, CHS %u/%u/%u\n",
-					     (unsigned long long)dev->n_sectors,
-					     dev->multi_count, dev->cylinders,
-					     dev->heads, dev->sectors);
-			}
+		/* print device info to dmesg */
+		if (ata_msg_drv(ap) && print_info) {
+			ata_dev_info(dev, "%s: %s, %s, max %s\n",
+				     revbuf, modelbuf, fwrevbuf,
+				     ata_mode_string(xfer_mask));
+			ata_dev_info(dev,
+				     "%llu sectors, multi %u, %s\n",
+				     (unsigned long long)dev->n_sectors,
+				     dev->multi_count, lba_info);
 		}
 
 		ata_dev_config_devslp(dev);
-- 
2.31.1

