From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: default to scsi-mq
Date: Fri, 16 Jun 2017 10:27:55 +0200
Message-ID: <20170616082755.22832-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52677 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752924AbdFPI2A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 04:28:00 -0400
Received: from 80-109-164-210.cable.dynamic.surfer.at ([80.109.164.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dLmbn-0003jn-14
        for linux-scsi@vger.kernel.org; Fri, 16 Jun 2017 08:27:59 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq I/O
path now that we had plenty of testing, and have I/O schedulers for
blk-mq.  The module option to disable the blk-mq path is kept around
for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig | 11 -----------
 drivers/scsi/scsi.c  |  4 ----
 2 files changed, 15 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c52867dfe28..d384f4f86c26 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -47,17 +47,6 @@ config SCSI_NETLINK
 	default	n
 	depends on NET
 
-config SCSI_MQ_DEFAULT
-	bool "SCSI: use blk-mq I/O path by default"
-	depends on SCSI
-	---help---
-	  This option enables the new blk-mq based I/O path for SCSI
-	  devices by default.  With the option the scsi_mod.use_blk_mq
-	  module/boot option defaults to Y, without it to N, but it can
-	  still be overridden either way.
-
-	  If unsure say N.
-
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1bf274e3b2b6..3d38c6d463b8 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -800,11 +800,7 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
-#ifdef CONFIG_SCSI_MQ_DEFAULT
 bool scsi_use_blk_mq = true;
-#else
-bool scsi_use_blk_mq = false;
-#endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
 
 static int __init init_scsi(void)
-- 
2.11.0
