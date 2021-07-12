Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893DCC07E9C
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F7866101D
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhGLF7c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhGLF7c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:59:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69132C0613DD;
        Sun, 11 Jul 2021 22:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tBTDy6ACdY4ZtA58BA4SAqnLRu5LIW5vRCkvwTfWkn8=; b=e4AazRjk2t1ytPSZRT9FbA/ww2
        nncQXZS/GQmvfEqZjkr+IIet+l+7HAA7XnG1cIJ0W9SGC4Blt+No42OGuQeEg7hnLd3CaLrdRpVEe
        pAYelUAZUN/vk5z7HZ5eHVpv5MoOrWVzdUi9LGS+RbalUgjUy4wKtosY7iQ5r1u1aj11H2p8k2+1u
        26t1GroYyYeQSBYRMSSRyq13F1MthBagoWqNShXHDLVQ6gboDaZLok+Ygkyp1OZKwIvaOJtLUIfY9
        f1o8Vdu9Hnro+8RCRnXk8ZFI/P9KzYqhC8GEAtAVfojP0PGza1VPkJikoXqJDHuUAhb98qzpiM3c+
        QufI61tQ==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2ovI-00GvUi-1v; Mon, 12 Jul 2021 05:56:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc:     Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 19/24] scsi: rename CONFIG_BLK_SCSI_REQUEST to CONFIG_SCSI_COMMON
Date:   Mon, 12 Jul 2021 07:48:11 +0200
Message-Id: <20210712054816.4147559-20-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712054816.4147559-1-hch@lst.de>
References: <20210712054816.4147559-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CONFIG_BLK_SCSI_REQUEST is rather misnamed now as it just enabled
building a small amount of code shared by the scsi initiator, target
and consumers of the scsi_request passthrough API.  Rename it and
also allow building it as a module.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/Kconfig          | 3 ---
 drivers/block/Kconfig  | 2 +-
 drivers/scsi/Kconfig   | 5 ++++-
 drivers/scsi/Makefile  | 2 +-
 drivers/target/Kconfig | 2 +-
 fs/nfsd/Kconfig        | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 88aa88241795..97c1d999b920 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -29,9 +29,6 @@ if BLOCK
 config BLK_RQ_ALLOC_TIME
 	bool
 
-config BLK_SCSI_REQUEST
-	bool
-
 config BLK_CGROUP_RWSTAT
 	bool
 
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 4652bcdb9efb..90ed1642304a 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -305,7 +305,7 @@ config CDROM_PKTCDVD
 	tristate "Packet writing on CD/DVD media (DEPRECATED)"
 	depends on !UML
 	select CDROM
-	select BLK_SCSI_REQUEST
+	select SCSI_COMMON
 	help
 	  Note: This driver is deprecated and will be removed from the
 	  kernel in the near future!
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 86ecab196dfd..6e3a04107bb6 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -14,12 +14,15 @@ config RAID_ATTRS
 	help
 	  Provides RAID
 
+config SCSI_COMMON
+	tristate
+
 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
 	select SCSI_DMA if HAS_DMA
 	select SG_POOL
-	select BLK_SCSI_REQUEST
+	select SCSI_COMMON
 	select BLK_DEV_BSG_COMMON if BLK_DEV_BSG
 	help
 	  If you want to use a SCSI hard disk, SCSI tape drive, SCSI CD-ROM or
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 240b831b5a11..f086eca2bcd7 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -20,7 +20,7 @@ CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
 obj-$(CONFIG_PCMCIA)		+= pcmcia/
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
-obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_common.o
+obj-$(CONFIG_SCSI_COMMON)	+= scsi_common.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index c163b14774d7..72171ea3dd53 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -5,7 +5,7 @@ menuconfig TARGET_CORE
 	depends on BLOCK
 	select CONFIGFS_FS
 	select CRC_T10DIF
-	select BLK_SCSI_REQUEST
+	select SCSI_COMMON
 	select SGL_ALLOC
 	default n
 	help
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index f229172652be..6e9ea4ee0f73 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -109,7 +109,7 @@ config NFSD_SCSILAYOUT
 	depends on NFSD_V4 && BLOCK
 	select NFSD_PNFS
 	select EXPORTFS_BLOCK_OPS
-	select BLK_SCSI_REQUEST
+	select SCSI_COMMON
 	help
 	  This option enables support for the exporting pNFS SCSI layouts
 	  in the kernel's NFS server. The pNFS SCSI layout enables NFS
-- 
2.30.2

