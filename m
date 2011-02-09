From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 11/31] target: do not include target_core_mib.h under include/target
Date: Wed,  9 Feb 2011 15:34:46 -0800
Message-ID: <1297294506-23579-12-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm23-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.224]:37697 "HELO
	nm23-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755755Ab1BIXf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:26 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

Headers under include/ should not include headers that require a specific
include path.  Fix this by moving the defintion of scsi_port_stats to
target_core_base.h, and including target_core_mib.h directly where needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    1 +
 drivers/target/target_core_hba.c       |    1 +
 drivers/target/target_core_mib.h       |    7 -------
 drivers/target/target_core_tpg.c       |    1 +
 drivers/target/target_core_transport.c |    1 +
 include/target/target_core_base.h      |    8 +++++++-
 6 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 656c4fa..96b87da 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -51,6 +51,7 @@
 #include "target_core_hba.h"
 #include "target_core_pr.h"
 #include "target_core_rd.h"
+#include "target_core_mib.h"
 
 static struct list_head g_tf_list;
 static struct mutex g_tf_lock;
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 4bbe820..29dc3fa 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -43,6 +43,7 @@
 #include <target/target_core_transport.h>
 
 #include "target_core_hba.h"
+#include "target_core_mib.h"
 
 static LIST_HEAD(subsystem_list);
 static DEFINE_MUTEX(subsystem_mutex);
diff --git a/drivers/target/target_core_mib.h b/drivers/target/target_core_mib.h
index 2772046..5172674 100644
--- a/drivers/target/target_core_mib.h
+++ b/drivers/target/target_core_mib.h
@@ -13,13 +13,6 @@ struct scsi_index_table {
 	u32 		scsi_mib_index[SCSI_INDEX_TYPE_MAX];
 } ____cacheline_aligned;
 
-/* SCSI Port stats */
-struct scsi_port_stats {
-	u64	cmd_pdus;
-	u64	tx_data_octets;
-	u64	rx_data_octets;
-} ____cacheline_aligned;
-
 extern int init_scsi_target_mib(void);
 extern void remove_scsi_target_mib(void);
 extern void init_scsi_index_table(void);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d15deaf..1f69be1 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -45,6 +45,7 @@
 #include <target/target_core_fabric_ops.h>
 
 #include "target_core_hba.h"
+#include "target_core_mib.h"
 
 /*	core_clear_initiator_node_from_tpg():
  *
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 28b6292..8cb628b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -58,6 +58,7 @@
 #include "target_core_pr.h"
 #include "target_core_scdb.h"
 #include "target_core_ua.h"
+#include "target_core_mib.h"
 
 /* #define DEBUG_CDB_HANDLER */
 #ifdef DEBUG_CDB_HANDLER
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 764177b..c071907 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -8,7 +8,6 @@
 #include <scsi/scsi_cmnd.h>
 #include <net/sock.h>
 #include <net/tcp.h>
-#include "target_core_mib.h"
 
 #define TARGET_CORE_MOD_VERSION		"v4.0.0-rc6"
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
@@ -175,6 +174,13 @@ struct se_obj {
 	atomic_t obj_access_count;
 } ____cacheline_aligned;
 
+/* SCSI Port stats */
+struct scsi_port_stats {
+	u64	cmd_pdus;
+	u64	tx_data_octets;
+	u64	rx_data_octets;
+} ____cacheline_aligned;
+
 /*
  * Used by TCM Core internally to signal if ALUA emulation is enabled or
  * disabled, or running in with TCM/pSCSI passthrough mode
-- 
1.7.4

