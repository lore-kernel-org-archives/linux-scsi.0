From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 14/14] iscsi-target: Add Makefile/Kconfig and update TCM top level
Date: Tue, 22 Mar 2011 20:06:45 -0700
Message-ID: <1300849605-12651-15-git-send-email-nab@linux-iscsi.org>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm17.bullet.mail.bf1.yahoo.com ([98.139.212.176]:42242 "HELO
	nm17.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752583Ab1CWDH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2011 23:07:56 -0400
In-Reply-To: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
to include the fabric module.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kconfig        |    2 ++
 drivers/target/Makefile       |    3 +++
 drivers/target/iscsi/Kconfig  |   17 +++++++++++++++++
 drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
 4 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/Kconfig
 create mode 100644 drivers/target/iscsi/Makefile

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 2fac3be..03a821c 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -29,4 +29,6 @@ config TCM_PSCSI
 	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
 	passthrough access to Linux/SCSI device
 
+source "drivers/target/iscsi/Kconfig"
+
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4f3cb78..ff9d62b 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -21,3 +21,6 @@ obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
 obj-$(CONFIG_TCM_IBLOCK)	+= target_core_iblock.o
 obj-$(CONFIG_TCM_FILEIO)	+= target_core_file.o
 obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
+
+# Fabric modules
+obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
new file mode 100644
index 0000000..cc34243
--- /dev/null
+++ b/drivers/target/iscsi/Kconfig
@@ -0,0 +1,17 @@
+config ISCSI_TARGET
+	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
+	select CRYPTO
+	select CRYPTO_CRC32C
+	select CRYPTO_CRC32C_INTEL if X86
+	help
+	Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
+	Target Mode Stack.
+
+if ISCSI_TARGET
+
+config ISCSI_TARGET_DEBUG
+	bool "LIO-Target iscsi_debug.h ring buffer messages"
+	help
+	Say Y here to enable the legacy DEBUG_ISCSI macros in iscsi_debug.h
+
+endif
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
1.7.4.1

