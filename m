Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C724C43331
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 10:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B1C20722
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 10:57:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aCer+8D3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgCYK52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 06:57:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCYK52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 06:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=zS+6qmfI2uhjCN3mq/MjMldCAfvPw1O3Uog8YjIUp/c=; b=aCer+8D33FJWT/fvt43yWfDGGd
        OdAut3frFd/7SG+rIkuT4Ih7Rrs2QfDMsBbmvEGPe3Ar4O0G+4/sGjtWKpzGZLl7VSdoR1rOfkPbz
        28QoX5Z0gUVSCg5L7+UFqZPWyiPS8spATJ0Fs8djQJBuff4xw2k7zjWURqPh3cbV1Atw1ilpgQ082
        E6q56yt/lRv6TQturqCn+PyBWI/njBQ5bigcIYIitBWAkvXBaCla7f83Afo1fByKXwLlydDKMvYGS
        5sN4RB5GHLlaEWL9ltKPgigeXibqZtpd1owOfoIcWLST0ZobtpDuT7wkyDuuuQx9RjbiVW12x7Jbn
        hVL1Vorg==;
Received: from 213-225-10-87.nat.highway.a1.net ([213.225.10.87] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jH3ip-00073g-Rh; Wed, 25 Mar 2020 10:57:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org
Cc:     dc395x@twibble.org, linux-scsi@vger.kernel.org
Subject: [PATCH] dc395x: remove dc395x_bios_param
Date:   Wed, 25 Mar 2020 11:55:05 +0100
Message-Id: <20200325105505.1028582-1-hch@lst.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

dc395x_bios_param was only different from the default when the
CONFIG_SCSI_DC395x_TRMS1040_TRADMAP symbol is true, but that symbol
doesn't exist in the Kconfig system and thus can't be set.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/dc395x.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13fbb2eab842..e95f5b3bef4d 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -61,7 +61,6 @@
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
-#include <scsi/scsicam.h>	/* needed for scsicam_bios_param */
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
@@ -1053,38 +1052,6 @@ static int dc395x_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct s
 
 static DEF_SCSI_QCMD(dc395x_queue_command)
 
-/*
- * Return the disk geometry for the given SCSI device.
- */
-static int dc395x_bios_param(struct scsi_device *sdev,
-		struct block_device *bdev, sector_t capacity, int *info)
-{
-#ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
-	int heads, sectors, cylinders;
-	struct AdapterCtlBlk *acb;
-	int size = capacity;
-
-	dprintkdbg(DBG_0, "dc395x_bios_param..............\n");
-	acb = (struct AdapterCtlBlk *)sdev->host->hostdata;
-	heads = 64;
-	sectors = 32;
-	cylinders = size / (heads * sectors);
-
-	if ((acb->gmode2 & NAC_GREATER_1G) && (cylinders > 1024)) {
-		heads = 255;
-		sectors = 63;
-		cylinders = size / (heads * sectors);
-	}
-	geom[0] = heads;
-	geom[1] = sectors;
-	geom[2] = cylinders;
-	return 0;
-#else
-	return scsicam_bios_param(bdev, capacity, info);
-#endif
-}
-
-
 static void dump_register_info(struct AdapterCtlBlk *acb,
 		struct DeviceCtlBlk *dcb, struct ScsiReqBlk *srb)
 {
@@ -4622,7 +4589,6 @@ static struct scsi_host_template dc395x_driver_template = {
 	.show_info              = dc395x_show_info,
 	.name                   = DC395X_BANNER " " DC395X_VERSION,
 	.queuecommand           = dc395x_queue_command,
-	.bios_param             = dc395x_bios_param,
 	.slave_alloc            = dc395x_slave_alloc,
 	.slave_destroy          = dc395x_slave_destroy,
 	.can_queue              = DC395x_MAX_CAN_QUEUE,
-- 
2.25.1

