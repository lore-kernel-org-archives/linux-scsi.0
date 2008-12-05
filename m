From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 13/14] lpfc 8.3.0 :  Hook lpfc's debugfs into Kconfig
Date: Thu, 4 Dec 2008 22:40:07 -0500
Message-ID: <1228448407.19053.59.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:46010 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYLEOn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 09:43:59 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mB5Ehwww004318
	for <linux-scsi@vger.kernel.org>; Fri, 5 Dec 2008 06:43:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lpfc 8.3.0: Hook lpfc's debugfs into Kconfig


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 Kconfig             |    7 +++++++
 lpfc/lpfc.h         |    4 ++--
 lpfc/lpfc_debugfs.c |   12 ++++++------
 lpfc/lpfc_debugfs.h |    2 +-
 4 files changed, 16 insertions(+), 9 deletions(-)


diff -upNr a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	2008-10-18 10:32:51.000000000 -0400
+++ b/drivers/scsi/Kconfig	2008-12-04 21:10:40.000000000 -0500
@@ -1357,6 +1357,13 @@ config SCSI_LPFC
           This lpfc driver supports the Emulex LightPulse
           Family of Fibre Channel PCI host adapters.
 
+config SCSI_LPFC_DEBUG_FS
+	bool "Emulex LightPulse Fibre Channel debugfs Support"
+	depends on SCSI_LPFC && DEBUG_FS
+	help
+	  This makes debugging infomation from the lpfc driver
+	  available via the debugfs filesystem.
+
 config SCSI_SIM710
 	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
 	depends on (EISA || MCA) && SCSI
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-12-04 21:10:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-12-04 21:10:40.000000000 -0500
@@ -46,7 +46,7 @@
 #include "lpfc_compat.h"
 #include "lpfc_debugfs.h"
 
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
  * debugfs interface
  *
@@ -618,7 +618,7 @@ inline void
 lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_debugfs_trc *dtp;
 	int index;
 
@@ -659,7 +659,7 @@ inline void
 lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 	uint32_t data1, uint32_t data2, uint32_t data3)
 {
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_debugfs_trc *dtp;
 	int index;
 
@@ -680,7 +680,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_h
 	return;
 }
 
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
  * lpfc_debugfs_disc_trc_open - Open the discovery trace log.
  * @inode: The inode pointer that contains a vport pointer.
@@ -1222,7 +1222,7 @@ static atomic_t lpfc_debugfs_hba_count;
 inline void
 lpfc_debugfs_initialize(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba = vport->phba;
 	char name[64];
 	uint32_t num, i;
@@ -1447,7 +1447,7 @@ debug_failed:
 inline void
 lpfc_debugfs_terminate(struct lpfc_vport *vport)
 {
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba = vport->phba;
 
 	if (vport->disc_trc) {
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
--- a/drivers/scsi/lpfc/lpfc_debugfs.h	2008-09-23 15:12:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h	2008-12-04 21:10:40.000000000 -0500
@@ -21,7 +21,7 @@
 #ifndef _H_LPFC_DEBUG_FS
 #define _H_LPFC_DEBUG_FS
 
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 struct lpfc_debugfs_trc {
 	char *fmt;
 	uint32_t data1;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-12-04 21:10:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-12-04 21:10:40.000000000 -0500
@@ -376,7 +376,7 @@ struct lpfc_vport {
 
 	struct fc_vport *fc_vport;
 
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *debug_disc_trc;
 	struct dentry *debug_nodelist;
 	struct dentry *vport_debugfs_root;
@@ -621,7 +621,7 @@ struct lpfc_hba {
 	unsigned long last_rsrc_error_time;
 	unsigned long last_ramp_down_time;
 	unsigned long last_ramp_up_time;
-#ifdef CONFIG_LPFC_DEBUG_FS
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct dentry *hba_debugfs_root;
 	atomic_t debugfs_vport_count;
 	struct dentry *debug_hbqinfo;


