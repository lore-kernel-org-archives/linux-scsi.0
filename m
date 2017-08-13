From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] Revert "scsi: default to scsi-mq"
Date: Sun, 13 Aug 2017 19:44:22 +0200
Message-ID: <20170813174422.16197-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49933 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdHMRo0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Aug 2017 13:44:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

Defaulting to scsi-mq in 4.13-rc has shown various regressions
on setups that we didn't previously consider.  Fixes for them are
in progress, but too invasive to make it in this cycle.  So for
now revert the commit that defaults to blk-mq for SCSI.  For 4.14
we'll plan to try again with these fixes.

This reverts commit 5c279bd9e40624f4ab6e688671026d6005b066fa.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig | 11 +++++++++++
 drivers/scsi/scsi.c  |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f4538d7a3016..d145e0d90227 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -47,6 +47,17 @@ config SCSI_NETLINK
 	default	n
 	depends on NET
 
+config SCSI_MQ_DEFAULT
+	bool "SCSI: use blk-mq I/O path by default"
+	depends on SCSI
+	---help---
+	  This option enables the new blk-mq based I/O path for SCSI
+	  devices by default.  With the option the scsi_mod.use_blk_mq
+	  module/boot option defaults to Y, without it to N, but it can
+	  still be overridden either way.
+
+	  If unsure say N.
+
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d38c6d463b8..1bf274e3b2b6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -800,7 +800,11 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
+#ifdef CONFIG_SCSI_MQ_DEFAULT
 bool scsi_use_blk_mq = true;
+#else
+bool scsi_use_blk_mq = false;
+#endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
 
 static int __init init_scsi(void)
-- 
2.11.0
