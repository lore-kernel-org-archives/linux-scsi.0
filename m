From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc : correct printk types on PPC compiles
Date: Tue, 16 Dec 2008 10:34:09 -0500
Message-ID: <1229441649.4621.0.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61766 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbYLPPpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 10:45:20 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mBGFjJvv024646
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 07:45:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    9 ++++++---
 lpfc_scsi.c |   11 ++++++-----
 2 files changed, 12 insertions(+), 8 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-12-16 09:36:40.000000000 -0500
@@ -123,7 +123,8 @@ lpfc_bg_guard_err_show(struct device *de
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n", phba->bg_guard_err_cnt);
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)phba->bg_guard_err_cnt);
 }
 
 static ssize_t
@@ -134,7 +135,8 @@ lpfc_bg_apptag_err_show(struct device *d
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n", phba->bg_apptag_err_cnt);
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)phba->bg_apptag_err_cnt);
 }
 
 static ssize_t
@@ -145,7 +147,8 @@ lpfc_bg_reftag_err_show(struct device *d
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 
-	return snprintf(buf, PAGE_SIZE, "%llu\n", phba->bg_reftag_err_cnt);
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+			(unsigned long long)phba->bg_reftag_err_cnt);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-12-16 09:36:40.000000000 -0500
@@ -1315,7 +1315,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba,
 
 	printk(KERN_ERR "BG ERROR in cmd 0x%x lba 0x%llx blk cnt 0x%lx "
 			"bgstat=0x%x bghm=0x%x\n",
-			cmd->cmnd[0], (u64)scsi_get_lba(cmd),
+			cmd->cmnd[0], (unsigned long long)scsi_get_lba(cmd),
 			cmd->request->nr_sectors, bgstat, bghm);
 
 	spin_lock(&_dump_buf_lock);
@@ -2376,13 +2376,13 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					"9035 BLKGRD: READ @ sector %llu, "
 					 "count %lu\n",
-					 (u64)scsi_get_lba(cmnd),
+					 (unsigned long long)scsi_get_lba(cmnd),
 					cmnd->request->nr_sectors);
 		else if (cmnd->cmnd[0] == WRITE_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					"9036 BLKGRD: WRITE @ sector %llu, "
 					"count %lu cmd=%p\n",
-					(u64)scsi_get_lba(cmnd),
+					(unsigned long long)scsi_get_lba(cmnd),
 					cmnd->request->nr_sectors,
 					cmnd);
 
@@ -2403,13 +2403,14 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		if (cmnd->cmnd[0] == READ_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9040 dbg: READ @ sector %llu, "
-					 "count %lu\n", (u64)scsi_get_lba(cmnd),
+					 "count %lu\n",
+					 (unsigned long long)scsi_get_lba(cmnd),
 					 cmnd->request->nr_sectors);
 		else if (cmnd->cmnd[0] == WRITE_10)
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 					 "9041 dbg: WRITE @ sector %llu, "
 					 "count %lu cmd=%p\n",
-					 (u64)scsi_get_lba(cmnd),
+					 (unsigned long long)scsi_get_lba(cmnd),
 					 cmnd->request->nr_sectors, cmnd);
 		else
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,


