From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] target: do not include target_core_mib.h under include/target
Date: Tue, 18 Jan 2011 21:24:34 +0100
Message-ID: <20110118202434.GA10884@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37248 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1ARUYj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 15:24:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Headers under include/ should not include headers that require a specific
include path.  Fix this by moving the defintion of scsi_port_stats to
target_core_base.h, and including target_core_mib.h directly where needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/target/target_core_configfs.c
===================================================================
--- linux-2.6.orig/drivers/target/target_core_configfs.c	2011-01-18 21:16:49.361253237 +0100
+++ linux-2.6/drivers/target/target_core_configfs.c	2011-01-18 21:17:03.393006207 +0100
@@ -51,6 +51,7 @@
 #include "target_core_hba.h"
 #include "target_core_pr.h"
 #include "target_core_rd.h"
+#include "target_core_mib.h"
 
 static struct list_head g_tf_list;
 static struct mutex g_tf_lock;
Index: linux-2.6/drivers/target/target_core_hba.c
===================================================================
--- linux-2.6.orig/drivers/target/target_core_hba.c	2011-01-18 21:17:15.067253727 +0100
+++ linux-2.6/drivers/target/target_core_hba.c	2011-01-18 21:17:26.881255543 +0100
@@ -43,6 +43,7 @@
 #include <target/target_core_transport.h>
 
 #include "target_core_hba.h"
+#include "target_core_mib.h"
 
 static LIST_HEAD(subsystem_list);
 static DEFINE_MUTEX(subsystem_mutex);
Index: linux-2.6/drivers/target/target_core_mib.h
===================================================================
--- linux-2.6.orig/drivers/target/target_core_mib.h	2011-01-18 21:15:59.708253238 +0100
+++ linux-2.6/drivers/target/target_core_mib.h	2011-01-18 21:16:13.016005995 +0100
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
Index: linux-2.6/drivers/target/target_core_tpg.c
===================================================================
--- linux-2.6.orig/drivers/target/target_core_tpg.c	2011-01-18 21:17:38.542004530 +0100
+++ linux-2.6/drivers/target/target_core_tpg.c	2011-01-18 21:17:49.480291791 +0100
@@ -45,6 +45,7 @@
 #include <target/target_core_fabric_ops.h>
 
 #include "target_core_hba.h"
+#include "target_core_mib.h"
 
 /*	core_clear_initiator_node_from_tpg():
  *
Index: linux-2.6/drivers/target/target_core_transport.c
===================================================================
--- linux-2.6.orig/drivers/target/target_core_transport.c	2011-01-18 21:18:00.593253587 +0100
+++ linux-2.6/drivers/target/target_core_transport.c	2011-01-18 21:18:08.858255404 +0100
@@ -58,6 +58,7 @@
 #include "target_core_pr.h"
 #include "target_core_scdb.h"
 #include "target_core_ua.h"
+#include "target_core_mib.h"
 
 /* #define DEBUG_CDB_HANDLER */
 #ifdef DEBUG_CDB_HANDLER
Index: linux-2.6/include/target/target_core_base.h
===================================================================
--- linux-2.6.orig/include/target/target_core_base.h	2011-01-18 21:14:57.945011025 +0100
+++ linux-2.6/include/target/target_core_base.h	2011-01-18 21:20:44.166015774 +0100
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
