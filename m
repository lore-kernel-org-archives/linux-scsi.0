Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C15C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B74220722
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZKl2SN6P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgGFMdx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:53 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038833; x=1625574833;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+L/27iWpKb2Q84j8Ql9wxiyhEN2izLsIXNk4XFny46c=;
  b=ZKl2SN6PKGGQUmmZN1BuuJgAvcYxnKYnEqR4hWvEj65qMKPhDFe+7txn
   4sGNsT9vuNFBOY+Vra4Y/5q5h35cRVy53Z52QvxspGfI3FZaFmC2cChF9
   U6TEStfjOvASp7OIqLdUO1A4kSvL4meHYttBTHhAQZR1xBvG4n0ss6Oqy
   UrM+Q4Xy0BBVr6f4AxIeDWRhsuvzxDVEsPhH0OpJYANbGCO6GpwLv5Avy
   +DQ0DJYOqGG9jyoLXMKBnd5CdZD5QFJ9ol2FLyHUtTlsfSxQyHC5TDBpc
   mVDyIcLHZf80tBDi7rov7nW+6EEsnmD47vfQnKW24X+n8x//uzL5CPw6O
   Q==;
IronPort-SDR: 0F7MrwA+ZGOhuaH+9zoPXcFvn56/VqOFx8o0vLmHlbXh/aqQGqsIKth5h/tYf9xgvsAwgb8a/a
 YU9GQ//tCtc7Ma18myigOp7ZrtmA8DPgm+RmCe6PA18KDWIpQyiK9bRk8ADAsNwWW4+dDWQQ/o
 MVk2Lt0lWoatm4lmw8o8iZ61dI4nugbCRbcER4Zvri9HBSN8waIRLbGpNmg8uhsXsSHz2zQcMb
 JsaAdZfnPcIj9RLWUYZdTU5HwqF7DiCaDKOHLK5vngEd0fZhKtcwyJ4j11qBo3J6B+63S/qsx0
 rpM=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052065"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:52 +0800
IronPort-SDR: u1HHsFpegJRMpxSCIUqEX9K9a74HBMnK0zZcKY3edtNSl/TE9Rl7GIf5ivo8XCzRUuKHQ1RpVV
 37XRC1uqEXrRC6rv4l7gLnzy3Eag4MJ6A=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:22:00 -0700
IronPort-SDR: hrAsDyacn8EBN+V7EbiJEVEpo4gLI1ZPN5WYqGvkcRCz7qwciWs0DM24eTV2Tf9e/QzcRg/8zS
 MHMPTrrigKqQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:52 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 05/10] scsi: megaraid: Fix set but unused variable
Date:   Mon,  6 Jul 2020 21:33:51 +0900
Message-Id: <20200706123351.451959-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In megadev_ioctl(), if MEGA_HAVE_STATS is not defined, the variables
num_ldrv and ustats are unused. Conditionally define them to avoid
compiler warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/megaraid.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 96ecf5929e68..acd7c6ed77b1 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2975,14 +2975,13 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	void		*data = NULL;	/* data to be transferred */
 	dma_addr_t	data_dma_hndl;	/* dma handle for data xfer area */
 	megacmd_t	mc;
-	megastat_t	__user *ustats;
-	int		num_ldrv;
+#if MEGA_HAVE_STATS
+	megastat_t	__user *ustats = NULL;
+	int		num_ldrv = 0;
+#endif
 	u32		uxferaddr = 0;
 	struct pci_dev	*pdev;
 
-	ustats = NULL; /* avoid compilation warnings */
-	num_ldrv = 0;
-
 	/*
 	 * Make sure only USCSICMD are issued through this interface.
 	 * MIMD application would still fire different command.
-- 
2.26.2

