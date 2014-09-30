From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: add a CONFIG_SCSI_MQ_DEFAULT option
Date: Tue, 30 Sep 2014 17:20:53 +0200
Message-ID: <1412090453-24484-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45027 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI3PS1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 11:18:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Add a Kconfig option to enable the blk-mq path for SCSI by default
to ease testing and deployment in setups that know they benefit
from blk-mq.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig | 11 +++++++++++
 drivers/scsi/scsi.c  |  4 ++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 18a3358..71b0877 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -45,6 +45,17 @@ config SCSI_NETLINK
 	default	n
 	select NET
 
+config SCSI_MQ_DEFAULT
+	bool "SCSI: use blk-mq I/O path by default"
+	depends on SCSI
+	---help---
+	  This option enables the new blk-mq based I/O path for SCSI
+	  devices by default.  With the option the scsi_mod.use_blk_mq
+	  module/boot option defaults to Y, without it to N, but it can
+	  still be overriden either way.
+
+	  If unsure say N.
+
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1423cb1..79c77b4 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1367,7 +1367,11 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
+#ifdef CONFIG_SCSI_MQ_DEFAULT
+bool scsi_use_blk_mq = true;
+#else
 bool scsi_use_blk_mq = false;
+#endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
 
 static int __init init_scsi(void)
-- 
1.9.1

