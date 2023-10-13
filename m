Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FA8CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 08:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjJMIdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 04:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjJMIdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 04:33:39 -0400
Received: from m15.mail.163.com (m15.mail.163.com [45.254.50.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4A17DC;
        Fri, 13 Oct 2023 01:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=LaDzO
        7P/7Bxrgwx4S6QAlzMcetmHukoMgGfY234HCi0=; b=jP33fvREKFdmWo5NUpGKh
        5OffJgzMmeE4DxNokLA8KxfwgoFyRWRSM0M8o+3uRercJi0r54ABXI1fVfhBwzBN
        YPCW7NSkZDlAeoo4xCZzWKeVNbptrmJRjTw5juKjpsPbGoVWlLRQoBFkCU4CypoR
        sz+VE38nlgCKf47qDJFUyQ=
Received: from test-Z390-GAMING-X.bayhubtech.com (unknown [58.48.115.170])
        by zwqz-smtp-mta-g1-1 (Coremail) with SMTP id _____wD3f2vGACll9T+0AQ--.19521S2;
        Fri, 13 Oct 2023 16:33:11 +0800 (CST)
From:   liuchang_125125@163.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mark.tao@bayhubtech.com, shaper.liu@bayhubtech.com,
        thomas.hu@bayhubtech.com, chevron.li@bayhubtech.com,
        charl.liu@bayhubtech.com, Charl Liu <liuchang_125125@163.com>
Subject: [PATCH 2/9] scsi: bht: Add Bayhub module's Kconfig and Makefile for compiling Bayhub's SD/MMC Card interface driver
Date:   Fri, 13 Oct 2023 16:33:06 +0800
Message-Id: <20231013083306.10261-1-liuchang_125125@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wD3f2vGACll9T+0AQ--.19521S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFyUZF4xtF4fWryUAF15twb_yoW8tF47pF
        W8Ar13Ca18ta1Sg3s7uF12vFy3Kas2vFyjkay2q34UXFykCFyagF9FqFy5CrykXF4kXFWD
        CF9xWFykK3Z8JaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_9NVUUUUUU=
X-Originating-IP: [58.48.115.170]
X-CM-SenderInfo: polxux5dqjsiqsvrjki6rwjhhfrp/1tbiNwcIWVWBqsRVmAAAsW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Charl Liu <liuchang_125125@163.com>

1.Add Bayhub module's config "SCSI_BHT"
2.Add Bayhub module's Makefile

Signed-off-by: Charl Liu <liuchang_125125@163.com>
---
Change in V1:
Add Bayhub module's Kconfig and Makefile for compiling Bayhub's
SD/MMC Card interface driver.
---
 drivers/scsi/bht/Kconfig  | 10 ++++++++++
 drivers/scsi/bht/Makefile | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+)
 create mode 100644 drivers/scsi/bht/Kconfig
 create mode 100644 drivers/scsi/bht/Makefile

diff --git a/drivers/scsi/bht/Kconfig b/drivers/scsi/bht/Kconfig
new file mode 100644
index 000000000000..f6d224799885
--- /dev/null
+++ b/drivers/scsi/bht/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config SCSI_BHT
+	tristate "Bayhub's SD/MMC Card Interface Driver"
+	depends on PCI && SCSI
+	help
+	  This driver supports the Bayhub's SD/MMC host controllers.
+
+	  If you have the Bayhub's SD/MMC host controllers, say Y or M here.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/bht/Makefile b/drivers/scsi/bht/Makefile
new file mode 100644
index 000000000000..65fa352c51b2
--- /dev/null
+++ b/drivers/scsi/bht/Makefile
@@ -0,0 +1,18 @@
+# SPDX-License-Identifier: GPL-2.0-only
+INCLUDE = -I$(KERNEL_SOURCE)/include	\
+	-I$(KERNEL_SOURCE)/drivers/scsi	\
+	-I$(PWD)
+
+ccflags-y += -g $(INCLUDE)
+
+OBJ = linux_os/linux_base.o linux_os/linux_api.o linux_os/linux_scsi.o
+CARD_OBJ = card/cardcommon.o card/cardinterface.o card/mmc.o card/sd.o card/thermal.o card/uhs2.o card/card_ddr200_support.o card/output_tuning.o
+HOST_OBJ = host/host.o host/hostven.o host/cmdhandler.o host/irqhandler.o host/transhandler.o
+MAIN_OBJ = main/cfgmng.o main/thread.o main/autotimerfunc.o main/geniofunc.o main/pmfunc.o main/reqmng.o main/testcase.o
+TQ_OBJ = tagqueue/tagqueue.o  tagqueue/tqadma2.o tagqueue/tqadma3.o tagqueue/tqadma_sdma_like.o tagqueue/tqpolicy.o tagqueue/tqsdma.o tagqueue/tq_merge.o
+UTIL_OBJ = util/util.o util/debug.o
+
+obj-$(CONFIG_SCSI_BHT) := bht-sd.o
+bht-sd-objs := $(OBJ) $(CARD_OBJ) $(HOST_OBJ) $(MAIN_OBJ) $(TQ_OBJ) $(UTIL_OBJ)
+
+
-- 
2.34.1

