Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B344C4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660F560F90
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhJ0CYy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:24:54 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63768 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237849AbhJ0CYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 22:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635301346; x=1666837346;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=DL3n+nHjUtGuck2tdXEwiK4+SWPEa6n9a33MrqEju14=;
  b=Y7UL3MSsQOEDlugVCZWX7tdxgXk3iePRa/f6zD04g4FK/gIbutZIZTK6
   fba8FiTzEYNtmTNH9qdWPHaOASs9V8T1ZhLa8OPDbx83bzk8lxWeWRBCe
   gy74E3BnDHcJknz/JwNbleSYYr0x8qhAVDAfSbyEF87m/NO7CmmNMv0SH
   UjM1tH+/he69LuzUpfuvKLddn6ampEKUIpCyWaFSOR9VNiOnr2MVYOuJJ
   saejOH8OBZcEkoSO2Cvif7dOGthHwP/YcJZaf1WlwjQDISxJHk//mNrxj
   ykE9milGn8OvERYbc10C4z7Fiwt8qhg1xnZrgiJp26wkXN4euSyrH5FwV
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="183924737"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 10:22:26 +0800
IronPort-SDR: Qi5iSgegemqmbqx0U9mia6IWSaNUroa88eDol32cMup/VswG2ueR6qBgbx8WCef6Ucks3SvMHK
 hbstkcD2y7apPhPPt/t6n2a8ObBCN38cVL8HJ1xEmxUavWO1Zrmo+Nw4S8PT665RnWfIzQBt70
 OaapbhNFABR0Hc0LOMd4YmDuwOkKpeAsnq1PLZXb6PN7jIQpiLXjgXfpSg7ZclCC7n30SaCkQZ
 szeMFLWuMgc7cNJo0b7FGXq+luGu/i6zcPqFfuXk82A8spEvyVRJygsq+bMiMtKXzDi4tXe1lK
 VeKuu20ZhwbED+3x5fntWDIY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 18:57:56 -0700
IronPort-SDR: qRgc9T+AP3Pvn8INECWL+mkmCPb2KbWW0a5GXK6WHpjYcOM0IporUVhlVv+ivkVsrfWzY2Yg7Q
 9NnVDrbI3xOFduljFozpv59OecNJS6U7ZmHoNUR9V5ri7PdklfI0QRIqddyrOjxuajCXbvIxjY
 RcYb30bJSiTxrbAvDy2v9sXmXN8e1+y5z9yxB3/dhy9fyWKUfrrf8kReYVtOpZpV1GVQRKbacG
 QmkiME50cTmyly7dQuf5YyhaDn9rpHsnH2t2R3MaP/qqIzzSoZJv+mAhVOTQKFI/LLf+cFaJ9B
 +eo=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 Oct 2021 19:22:27 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v9 2/5] scsi: sd: add concurrent positioning ranges support
Date:   Wed, 27 Oct 2021 11:22:20 +0900
Message-Id: <20211027022223.183838-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027022223.183838-1-damien.lemoal@wdc.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the sd_read_cpr() function to the sd scsi disk driver to discover
if a device has multiple concurrent positioning ranges (i.e. multiple
actuators on an HDD). The existence of VPD page B9h indicates if a
device has multiple concurrent positioning ranges. The page content
describes each range supported by the device.

sd_read_cpr() is called from sd_revalidate_disk() and uses the block
layer functions disk_alloc_independent_access_ranges() and
disk_set_independent_access_ranges() to represent the set of actuators
of the device as independent access ranges.

The format of the Concurrent Positioning Ranges VPD page B9h is defined
in section 6.6.6 of SBC-5.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/scsi/sd.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d8f6add416c0..55c0d951a446 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3088,6 +3088,86 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->security = 1;
 }
 
+static inline sector_t sd64_to_sectors(struct scsi_disk *sdkp, u8 *buf)
+{
+	return logical_to_sectors(sdkp->device, get_unaligned_be64(buf));
+}
+
+/**
+ * sd_read_cpr - Query concurrent positioning ranges
+ * @sdkp:	disk to query
+ */
+static void sd_read_cpr(struct scsi_disk *sdkp)
+{
+	struct blk_independent_access_ranges *iars = NULL;
+	unsigned char *buffer = NULL;
+	unsigned int nr_cpr = 0;
+	int i, vpd_len, buf_len = SD_BUF_SIZE;
+	u8 *desc;
+
+	/*
+	 * We need to have the capacity set first for the block layer to be
+	 * able to check the ranges.
+	 */
+	if (sdkp->first_scan)
+		return;
+
+	if (!sdkp->capacity)
+		goto out;
+
+	/*
+	 * Concurrent Positioning Ranges VPD: there can be at most 256 ranges,
+	 * leading to a maximum page size of 64 + 256*32 bytes.
+	 */
+	buf_len = 64 + 256*32;
+	buffer = kmalloc(buf_len, GFP_KERNEL);
+	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb9, buffer, buf_len))
+		goto out;
+
+	/* We must have at least a 64B header and one 32B range descriptor */
+	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
+	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Invalid Concurrent Positioning Ranges VPD page\n");
+		goto out;
+	}
+
+	nr_cpr = (vpd_len - 64) / 32;
+	if (nr_cpr == 1) {
+		nr_cpr = 0;
+		goto out;
+	}
+
+	iars = disk_alloc_independent_access_ranges(sdkp->disk, nr_cpr);
+	if (!iars) {
+		nr_cpr = 0;
+		goto out;
+	}
+
+	desc = &buffer[64];
+	for (i = 0; i < nr_cpr; i++, desc += 32) {
+		if (desc[0] != i) {
+			sd_printk(KERN_ERR, sdkp,
+				"Invalid Concurrent Positioning Range number\n");
+			nr_cpr = 0;
+			break;
+		}
+
+		iars->ia_range[i].sector = sd64_to_sectors(sdkp, desc + 8);
+		iars->ia_range[i].nr_sectors = sd64_to_sectors(sdkp, desc + 16);
+	}
+
+out:
+	disk_set_independent_access_ranges(sdkp->disk, iars);
+	if (nr_cpr && sdkp->nr_actuators != nr_cpr) {
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%u concurrent positioning ranges\n", nr_cpr);
+		sdkp->nr_actuators = nr_cpr;
+	}
+
+	kfree(buffer);
+}
+
 /*
  * Determine the device's preferred I/O size for reads and writes
  * unless the reported value is unreasonably small, large, not a
@@ -3203,6 +3283,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
+		sd_read_cpr(sdkp);
 	}
 
 	/*
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index b59136c4125b..2e5932bde43d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -106,6 +106,7 @@ struct scsi_disk {
 	u8		protection_type;/* Data Integrity Field */
 	u8		provisioning_mode;
 	u8		zeroing_mode;
+	u8		nr_actuators;		/* Number of actuators */
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.31.1

