From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 12/12] iser-target: Add Makefile + Kconfig
Date: Fri, 22 Mar 2013 23:55:36 +0000
Message-ID: <1363996536-30644-13-git-send-email-nab@linux-iscsi.org>
References: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49678 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933590Ab3CWAGt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Mar 2013 20:06:49 -0400
In-Reply-To: <1363996536-30644-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/Makefile           |    1 +
 drivers/infiniband/ulp/isert/Kconfig  |    6 ++++++
 drivers/infiniband/ulp/isert/Makefile |    5 +++++
 4 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/ulp/isert/Kconfig
 create mode 100644 drivers/infiniband/ulp/isert/Makefile

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index a0f29c1..c85b56c 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -59,5 +59,6 @@ source "drivers/infiniband/ulp/srp/Kconfig"
 source "drivers/infiniband/ulp/srpt/Kconfig"
 
 source "drivers/infiniband/ulp/iser/Kconfig"
+source "drivers/infiniband/ulp/isert/Kconfig"
 
 endif # INFINIBAND
diff --git a/drivers/infiniband/Makefile b/drivers/infiniband/Makefile
index bf846a1..b126fef 100644
--- a/drivers/infiniband/Makefile
+++ b/drivers/infiniband/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_INFINIBAND_IPOIB)		+= ulp/ipoib/
 obj-$(CONFIG_INFINIBAND_SRP)		+= ulp/srp/
 obj-$(CONFIG_INFINIBAND_SRPT)		+= ulp/srpt/
 obj-$(CONFIG_INFINIBAND_ISER)		+= ulp/iser/
+obj-$(CONFIG_INFINIBAND_ISERT)		+= ulp/isert/
diff --git a/drivers/infiniband/ulp/isert/Kconfig b/drivers/infiniband/ulp/isert/Kconfig
new file mode 100644
index 0000000..c268a3b
--- /dev/null
+++ b/drivers/infiniband/ulp/isert/Kconfig
@@ -0,0 +1,6 @@
+config INFINIBAND_ISERT
+	tristate "InfiniBand iSCSI Extentions for RDMA (iSER) Target support"
+	depends on INFINIBAND && TARGET_CORE && ISCSI_TARGET
+	---help---
+
+	Support for iSCSI Extentions for RDMA (iSER) Target on Infiniband fabrics.
diff --git a/drivers/infiniband/ulp/isert/Makefile b/drivers/infiniband/ulp/isert/Makefile
new file mode 100644
index 0000000..2d0ac23
--- /dev/null
+++ b/drivers/infiniband/ulp/isert/Makefile
@@ -0,0 +1,5 @@
+ccflags-y		:= -Idrivers/target -Idrivers/target/iscsi
+obj-$(CONFIG_INFINIBAND_ISERT)	+= ib_isert.o
+
+ib_isert-y		:= isert_core.o \
+			   isert_verbs.o
-- 
1.7.2.5

