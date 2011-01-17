From: Fubo Chen <fubo.chen@gmail.com>
Subject: [PATCH] target_core_mib.h move
Date: Mon, 17 Jan 2011 21:00:02 +0100
Message-ID: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59100 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1AQUAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 15:00:04 -0500
Received: by iwn9 with SMTP id 9so5015032iwn.19
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jan 2011 12:00:03 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>

target_core_mib.h move from drivers/target to include/target.
Otherwise my driver not build.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>

diff --git a/drivers/target/target_core_mib.h b/drivers/target/target_core_mib.h
deleted file mode 100644
index 2772046..0000000
--- a/drivers/target/target_core_mib.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef TARGET_CORE_MIB_H
-#define TARGET_CORE_MIB_H
-
-typedef enum {
-	SCSI_INST_INDEX,
-	SCSI_DEVICE_INDEX,
-	SCSI_AUTH_INTR_INDEX,
-	SCSI_INDEX_TYPE_MAX
-} scsi_index_t;
-
-struct scsi_index_table {
-	spinlock_t	lock;
-	u32 		scsi_mib_index[SCSI_INDEX_TYPE_MAX];
-} ____cacheline_aligned;
-
-/* SCSI Port stats */
-struct scsi_port_stats {
-	u64	cmd_pdus;
-	u64	tx_data_octets;
-	u64	rx_data_octets;
-} ____cacheline_aligned;
-
-extern int init_scsi_target_mib(void);
-extern void remove_scsi_target_mib(void);
-extern void init_scsi_index_table(void);
-extern u32 scsi_get_new_index(scsi_index_t);
-
-#endif   /*** TARGET_CORE_MIB_H ***/
diff --git a/include/target/target_core_base.h
b/include/target/target_core_base.h
index 07fdfb6..2ede15f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -8,7 +8,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
-#include "target_core_mib.h"
+#include <target/target_core_mib.h>

 #define TARGET_CORE_MOD_VERSION		"v4.0.0-rc6"
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
diff --git a/include/target/target_core_mib.h b/include/target/target_core_mib.h
new file mode 100644
index 0000000..2772046
--- /dev/null
+++ b/include/target/target_core_mib.h
@@ -0,0 +1,28 @@
+#ifndef TARGET_CORE_MIB_H
+#define TARGET_CORE_MIB_H
+
+typedef enum {
+	SCSI_INST_INDEX,
+	SCSI_DEVICE_INDEX,
+	SCSI_AUTH_INTR_INDEX,
+	SCSI_INDEX_TYPE_MAX
+} scsi_index_t;
+
+struct scsi_index_table {
+	spinlock_t	lock;
+	u32 		scsi_mib_index[SCSI_INDEX_TYPE_MAX];
+} ____cacheline_aligned;
+
+/* SCSI Port stats */
+struct scsi_port_stats {
+	u64	cmd_pdus;
+	u64	tx_data_octets;
+	u64	rx_data_octets;
+} ____cacheline_aligned;
+
+extern int init_scsi_target_mib(void);
+extern void remove_scsi_target_mib(void);
+extern void init_scsi_index_table(void);
+extern u32 scsi_get_new_index(scsi_index_t);
+
+#endif   /*** TARGET_CORE_MIB_H ***/
