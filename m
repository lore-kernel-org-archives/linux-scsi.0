Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D99C41537
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED65F61050
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbhHFHnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24074 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238682AbhHFHnP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235780; x=1659771780;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/GKiBcGNCHf0CUSVfrIJTyG1d7bktg9vl+k7UAd6i/o=;
  b=b9p3MsgbUx4qa2jam2QdN+FGo3KrL5/DpH2bkbGwtkfvei2M3thoyXqf
   edd2bTPBPv/0/SKiybbUMVhgr311LTqwwgg1AIe13X74JLph+YqZ2APou
   l7kPCeyrqZdWAaiKSQU/6B2OyK9fRbX/bHnMDU5Nl3uvHRkW5BE9sJ75z
   PJlxCYRlpAGibkxtpVuJw0DALoAHJzClJs/Te4fygXEp7kV4YmzHPOTL7
   L400XV2lH6riqBJ1VWWwzQXkHKWUwBbn15fgXgk9CkORWmXsDAdu6uGCd
   bhg+WVSP17XRFT94NBq4RfBhpSvRA4NCFaFshore1JpV/dt4mO8aD/nYs
   g==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296849"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:43:00 +0800
IronPort-SDR: AVYJqk3FCXQsr1CDddDPVcBmq2RMnqBEAbiD2SnpU9GROkTKKg13kBNSpcyjEyernGHLaARlhW
 tGRbrk9HBz7zZ+02sYqsFNLtDXheahfntZFWRy9dcCx0m07BY4UubLEXhPF3Hpn/bPPNTOoRhp
 Z0v4fdjvckj0ME/WMOsg/UO7KRdVL7VzOt5rMdursLAJU6OXpUZb0NVS76toNb0aCWsObpS/YW
 wlATbxAgzrWw05jR1DOj2jPLOXn/sAmm4R43H+m7Bok6kFphJukB0Z4VmcVKXVZQK/v/XezPIu
 NfOOMjwgzEA3jsRjB/HyAyD1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:28 -0700
IronPort-SDR: y5vwB1t9n3hakKfYwHzE8HPyADy7ix4E9S9eVdpqtqKMI6G1Bcs1BSN8AVwSw2Ydl/3eBGX9BL
 aDf+4TIJiZIWoMK0Q7BIJ0c/8datMmNi//xQTq2exriqycue4z5tL11fBG/lJWGbq//Fo16F8b
 Vh67iPXYFj4cYVdXiOFJEg2hqINZ1OBg+rvrzhtOsuAOM23CJEUfUfXekTiOcQ3c3bzlJIVvJA
 B+SVpc/+zx0md5DIou3XAl/6F1rcvwVX/ng3h99sc/3H3r40YXL7VxPlXk3pPmH4BR5ekL+/L/
 y10=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:42:59 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 4/9] libata: cleanup ata_dev_configure()
Date:   Fri,  6 Aug 2021 16:42:47 +0900
Message-Id: <20210806074252.398482-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806074252.398482-1-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
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
index b13194432e5a..2b6054cdd8fc 100644
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
+		strscpy(info, "LBA48 ", infosz);
+
+		if (dev->n_sectors >= (1UL << 28) &&
+		    ata_id_has_flush_ext(id))
+			dev->flags |= ATA_DFLAG_FLUSH_EXT;
+	} else {
+		strscpy(info, "LBA ", infosz);
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

