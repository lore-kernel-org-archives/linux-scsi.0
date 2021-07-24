Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEF2C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3227960E93
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 07:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhGXGnF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 02:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbhGXGnE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2021 02:43:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BC2C061575;
        Sat, 24 Jul 2021 00:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fo3kNG7b55xaIkyx+YG36Cj/Alt4VuwOsi2pzRZrHB4=; b=TcpHPHFpCtgGeGNLnKgwqyckoc
        xevV14BKdxjrNtNbDbnNP4oYdnLSjkctg3KP6bXRPFImaRbI5Az8m5BQC2TxJGby4JnDDVDq9rykx
        F7bJTQwiOwaRrm0D/m1vPT+pjc/T0xiFOsMFtVNNYp8WsQ5chRRIbc2PJLwItTFo/PG6GkCOoQQnH
        ZSt2DGZXPPzsHeWF1M2mZiXxtdJqYZM8Y5/q4aKUJPLxB1hIR9Q+6am+CiloOIz4ltfbrrg6umdFI
        dm5BtJN+T8gZfgXoDaX/ETMktx8gZeEEfXqzOlbTlHjN51QWZy0QQv6+5rQSkfDMWWkIyBStqGFkv
        sIBr3gpQ==;
Received: from [2001:4bb8:184:87c5:85d0:a26b:ef67:d32c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m7C00-00C56G-Cr; Sat, 24 Jul 2021 07:23:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 08/24] cdrom: remove the call to scsi_cmd_blk_ioctl from cdrom_ioctl
Date:   Sat, 24 Jul 2021 09:20:17 +0200
Message-Id: <20210724072033.1284840-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210724072033.1284840-1-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only the sr driver can handle SCSI passthrough requests, so move the
call to scsi_cmd_blk_ioctl there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/Kconfig        | 1 -
 drivers/block/paride/Kconfig | 1 -
 drivers/cdrom/cdrom.c        | 7 -------
 drivers/scsi/sr.c            | 3 +++
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 63056cfd4b62..4652bcdb9efb 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -74,7 +74,6 @@ config N64CART
 
 config CDROM
 	tristate
-	select BLK_SCSI_REQUEST
 
 config GDROM
 	tristate "SEGA Dreamcast GD-ROM drive"
diff --git a/drivers/block/paride/Kconfig b/drivers/block/paride/Kconfig
index 7c6ae1036927..a295634597ba 100644
--- a/drivers/block/paride/Kconfig
+++ b/drivers/block/paride/Kconfig
@@ -27,7 +27,6 @@ config PARIDE_PCD
 	tristate "Parallel port ATAPI CD-ROMs"
 	depends on PARIDE
 	select CDROM
-	select BLK_SCSI_REQUEST # only for the generic cdrom code
 	help
 	  This option enables the high-level driver for ATAPI CD-ROM devices
 	  connected through a parallel port. If you chose to build PARIDE
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index feb827eefd1a..8882b311bafd 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3357,13 +3357,6 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	/*
-	 * Try the generic SCSI command ioctl's first.
-	 */
-	ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
-	if (ret != -ENOTTY)
-		return ret;
-
 	switch (cmd) {
 	case CDROMMULTISESSION:
 		return cdrom_ioctl_multisession(cdi, argp);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c5e163a659d2..7948416f40d5 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -579,6 +579,9 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case SCSI_IOCTL_GET_BUS_NUMBER:
 		break;
 	default:
+		ret = scsi_cmd_blk_ioctl(bdev, mode, cmd, argp);
+		if (ret != -ENOTTY)
+			goto put;
 		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 		if (ret != -ENOSYS)
 			goto put;
-- 
2.30.2

