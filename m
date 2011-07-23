From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 13/13] iscsi-target: Add Makefile/Kconfig and update TCM top level
Date: Sat, 23 Jul 2011 08:45:47 +0000
Message-ID: <1311410747-29947-14-git-send-email-nab@linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34339 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab1GWJKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:10:13 -0400
In-Reply-To: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
to include the fabric module.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kconfig        |    1 +
 drivers/target/Makefile       |    2 +-
 drivers/target/iscsi/Kconfig  |    8 ++++++++
 drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
 4 files changed, 30 insertions(+), 1 deletions(-)
 create mode 100644 drivers/target/iscsi/Kconfig
 create mode 100644 drivers/target/iscsi/Makefile

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 5cb0f0e..b28794b 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -31,5 +31,6 @@ config TCM_PSCSI
 
 source "drivers/target/loopback/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
+source "drivers/target/iscsi/Kconfig"
 
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 21df808..1060c7b 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -24,5 +24,5 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
 
 # Fabric modules
 obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
-
 obj-$(CONFIG_TCM_FC)		+= tcm_fc/
+obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
new file mode 100644
index 0000000..564ff4e
--- /dev/null
+++ b/drivers/target/iscsi/Kconfig
@@ -0,0 +1,8 @@
+config ISCSI_TARGET
+	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
+	select CRYPTO
+	select CRYPTO_CRC32C
+	select CRYPTO_CRC32C_INTEL if X86
+	help
+	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
+	Target Mode Stack.
diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
new file mode 100644
index 0000000..5b9a2cf
--- /dev/null
+++ b/drivers/target/iscsi/Makefile
@@ -0,0 +1,20 @@
+iscsi_target_mod-y +=		iscsi_target_parameters.o \
+				iscsi_target_seq_pdu_list.o \
+				iscsi_target_tq.o \
+				iscsi_target_auth.o \
+				iscsi_target_datain_values.o \
+				iscsi_target_device.o \
+				iscsi_target_erl0.o \
+				iscsi_target_erl1.o \
+				iscsi_target_erl2.o \
+				iscsi_target_login.o \
+				iscsi_target_nego.o \
+				iscsi_target_nodeattrib.o \
+				iscsi_target_tmr.o \
+				iscsi_target_tpg.o \
+				iscsi_target_util.o \
+				iscsi_target.o \
+				iscsi_target_configfs.o \
+				iscsi_target_stat.o
+
+obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
-- 
1.7.6

