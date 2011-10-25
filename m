From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] scsi: lpfc: drop SCSI_LPFC_DEBUG_FS
Date: Tue, 25 Oct 2011 20:13:12 +0200
Message-ID: <1319566392.2409.71.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:50909 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1JYSOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2011 14:14:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Commit 88a2cfbb8bf3802ca5a90c7d1567a1e542e6ef0c ("[SCSI] lpfc 8.3.25:
Miscellaneous Bug fixes and code cleanup") turned SCSI_LPFC_DEBUG_FS
into an alias of DEBUG_FS (for all code enabled by SCSI_LPFC). So
SCSI_LPFC_DEBUG_FS can as well be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

 drivers/scsi/Kconfig             |    7 -------
 drivers/scsi/lpfc/lpfc.h         |    8 ++------
 drivers/scsi/lpfc/lpfc_debugfs.c |   16 ++++++++--------
 drivers/scsi/lpfc/lpfc_debugfs.h |    2 +-
 4 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3878b73..8aa80f1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1457,13 +1457,6 @@ config SCSI_LPFC
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
 
-config SCSI_LPFC_DEBUG_FS
-	bool "Emulex LightPulse Fibre Channel debugfs Support"
-	depends on SCSI_LPFC && DEBUG_FS
-	help
-	  This makes debugging information from the lpfc driver
-	  available via the debugfs filesystem.
-
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index c088a36..3e024ae 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -21,10 +21,6 @@
 
 #include <scsi/scsi_host.h>
 
-#if defined(CONFIG_DEBUG_FS) && !defined(CONFIG_SCSI_LPFC_DEBUG_FS)
-#define CONFIG_SCSI_LPFC_DEBUG_FS
-#endif
-
 struct lpfc_sli2_slim;
 
 #define LPFC_PCI_DEV_LP		0x1
@@ -420,7 +416,7 @@ struct lpfc_vport {
 
 	struct fc_vport *fc_vport;
 
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	struct dentry *debug_disc_trc;
 	struct dentry *debug_nodelist;
 	struct dentry *vport_debugfs_root;
@@ -840,7 +836,7 @@ struct lpfc_hba {
 	unsigned long last_rsrc_error_time;
 	unsigned long last_ramp_down_time;
 	unsigned long last_ramp_up_time;
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	struct dentry *hba_debugfs_root;
 	atomic_t debugfs_vport_count;
 	struct dentry *debug_hbqinfo;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a0424dd..89b8e80 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -50,7 +50,7 @@
 #include "lpfc_debugfs.h"
 #include "lpfc_bsg.h"
 
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 /*
  * debugfs interface
  *
@@ -624,7 +624,7 @@ inline void
 lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	struct lpfc_debugfs_trc *dtp;
 	int index;
 
@@ -665,7 +665,7 @@ inline void
 lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	struct lpfc_debugfs_trc *dtp;
 	int index;
 
@@ -686,7 +686,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	return;
 }
 
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 /**
  * lpfc_debugfs_disc_trc_open - Open the discovery trace log
  * @inode: The inode pointer that contains a vport pointer.
@@ -3489,7 +3489,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 				enum sta_type sta_tp,
 				struct lpfc_dmabuf *dmabuf, uint32_t ext_buf)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	uint32_t *mbx_mbox_cmd, *mbx_dump_map, *mbx_dump_cnt, *mbx_word_cnt;
 	char line_buf[LPFC_MBX_ACC_LBUF_SZ];
 	int len = 0;
@@ -3585,7 +3585,7 @@ lpfc_idiag_mbxacc_dump_bsg_mbox(struct lpfc_hba *phba, enum nemb_type nemb_tp,
 void
 lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	uint32_t *mbx_dump_map, *mbx_dump_cnt, *mbx_word_cnt, *mbx_mbox_cmd;
 	char line_buf[LPFC_MBX_ACC_LBUF_SZ];
 	int len = 0;
@@ -3684,7 +3684,7 @@ lpfc_idiag_mbxacc_dump_issue_mbox(struct lpfc_hba *phba, MAILBOX_t *pmbox)
 inline void
 lpfc_debugfs_initialize(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	struct lpfc_hba   *phba = vport->phba;
 	char name[64];
 	uint32_t num, i;
@@ -4047,7 +4047,7 @@ debug_failed:
 inline void
 lpfc_debugfs_terminate(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 	struct lpfc_hba   *phba = vport->phba;
 
 	if (vport->disc_trc) {
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index f83bd94..a9e092b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -21,7 +21,7 @@
 #ifndef _H_LPFC_DEBUG_FS
 #define _H_LPFC_DEBUG_FS
 
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+#ifdef CONFIG_DEBUG_FS
 
 /* size of output line, for discovery_trace and slow_ring_trace */
 #define LPFC_DEBUG_TRC_ENTRY_SIZE 100
-- 
1.7.4.4



