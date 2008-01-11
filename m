From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/10] lpfc 8.2.4 : Enhance debugfs use
Date: Fri, 11 Jan 2008 01:53:23 -0500
Message-ID: <1200034403.27954.29.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51545 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYAKGxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jan 2008 01:53:32 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m0B6rVwA021675
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jan 2008 22:53:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Enhance debugfs to dump HBA SLIM as well as Host SLIM

Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-11-09 15:54:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-01-11 01:28:11.000000000 -0500
@@ -43,6 +43,7 @@
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
+#include "lpfc_compat.h"
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_LPFC_DEBUG_FS
@@ -75,18 +76,18 @@ module_param(lpfc_debugfs_enable, int, 0
 MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
 
 /* This MUST be a power of 2 */
-static int lpfc_debugfs_max_disc_trc = 0;
+static int lpfc_debugfs_max_disc_trc;
 module_param(lpfc_debugfs_max_disc_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_max_disc_trc,
 	"Set debugfs discovery trace depth");
 
 /* This MUST be a power of 2 */
-static int lpfc_debugfs_max_slow_ring_trc = 0;
+static int lpfc_debugfs_max_slow_ring_trc;
 module_param(lpfc_debugfs_max_slow_ring_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_max_slow_ring_trc,
 	"Set debugfs slow ring trace depth");
 
-static int lpfc_debugfs_mask_disc_trc = 0;
+int lpfc_debugfs_mask_disc_trc;
 module_param(lpfc_debugfs_mask_disc_trc, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
 	"Set debugfs discovery trace mask");
@@ -100,8 +101,11 @@ MODULE_PARM_DESC(lpfc_debugfs_mask_disc_
 #define LPFC_NODELIST_SIZE 8192
 #define LPFC_NODELIST_ENTRY_SIZE 120
 
-/* dumpslim output buffer size */
-#define LPFC_DUMPSLIM_SIZE 4096
+/* dumpHBASlim output buffer size */
+#define LPFC_DUMPHBASLIM_SIZE 4096
+
+/* dumpHostSlim output buffer size */
+#define LPFC_DUMPHOSTSLIM_SIZE 4096
 
 /* hbqinfo output buffer size */
 #define LPFC_HBQINFO_SIZE 8192
@@ -298,18 +302,58 @@ skipit:
 	return len;
 }
 
+static int lpfc_debugfs_last_hba_slim_off;
+
+static int
+lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
+{
+	int len = 0;
+	int i, off;
+	uint32_t *ptr;
+	char buffer[1024];
+
+	off = 0;
+	spin_lock_irq(&phba->hbalock);
+
+	len +=  snprintf(buf+len, size-len, "HBA SLIM\n");
+	lpfc_memcpy_from_slim(buffer,
+		((uint8_t *)phba->MBslimaddr) + lpfc_debugfs_last_hba_slim_off,
+		1024);
+
+	ptr = (uint32_t *)&buffer[0];
+	off = lpfc_debugfs_last_hba_slim_off;
+
+	/* Set it up for the next time */
+	lpfc_debugfs_last_hba_slim_off += 1024;
+	if (lpfc_debugfs_last_hba_slim_off >= 4096)
+		lpfc_debugfs_last_hba_slim_off = 0;
+
+	i = 1024;
+	while (i > 0) {
+		len +=  snprintf(buf+len, size-len,
+		"%08x: %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		off, *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4),
+		*(ptr+5), *(ptr+6), *(ptr+7));
+		ptr += 8;
+		i -= (8 * sizeof(uint32_t));
+		off += (8 * sizeof(uint32_t));
+	}
+
+	spin_unlock_irq(&phba->hbalock);
+	return len;
+}
+
 static int
-lpfc_debugfs_dumpslim_data(struct lpfc_hba *phba, char *buf, int size)
+lpfc_debugfs_dumpHostSlim_data(struct lpfc_hba *phba, char *buf, int size)
 {
 	int len = 0;
-	int cnt, i, off;
+	int i, off;
 	uint32_t word0, word1, word2, word3;
 	uint32_t *ptr;
 	struct lpfc_pgp *pgpp;
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring *pring;
 
-	cnt = LPFC_DUMPSLIM_SIZE;
 	off = 0;
 	spin_lock_irq(&phba->hbalock);
 
@@ -621,7 +665,34 @@ out:
 }
 
 static int
-lpfc_debugfs_dumpslim_open(struct inode *inode, struct file *file)
+lpfc_debugfs_dumpHBASlim_open(struct inode *inode, struct file *file)
+{
+	struct lpfc_hba *phba = inode->i_private;
+	struct lpfc_debug *debug;
+	int rc = -ENOMEM;
+
+	debug = kmalloc(sizeof(*debug), GFP_KERNEL);
+	if (!debug)
+		goto out;
+
+	/* Round to page boundry */
+	debug->buffer = kmalloc(LPFC_DUMPHBASLIM_SIZE, GFP_KERNEL);
+	if (!debug->buffer) {
+		kfree(debug);
+		goto out;
+	}
+
+	debug->len = lpfc_debugfs_dumpHBASlim_data(phba, debug->buffer,
+		LPFC_DUMPHBASLIM_SIZE);
+	file->private_data = debug;
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int
+lpfc_debugfs_dumpHostSlim_open(struct inode *inode, struct file *file)
 {
 	struct lpfc_hba *phba = inode->i_private;
 	struct lpfc_debug *debug;
@@ -632,14 +703,14 @@ lpfc_debugfs_dumpslim_open(struct inode 
 		goto out;
 
 	/* Round to page boundry */
-	debug->buffer = kmalloc(LPFC_DUMPSLIM_SIZE, GFP_KERNEL);
+	debug->buffer = kmalloc(LPFC_DUMPHOSTSLIM_SIZE, GFP_KERNEL);
 	if (!debug->buffer) {
 		kfree(debug);
 		goto out;
 	}
 
-	debug->len = lpfc_debugfs_dumpslim_data(phba, debug->buffer,
-		LPFC_DUMPSLIM_SIZE);
+	debug->len = lpfc_debugfs_dumpHostSlim_data(phba, debug->buffer,
+		LPFC_DUMPHOSTSLIM_SIZE);
 	file->private_data = debug;
 
 	rc = 0;
@@ -742,10 +813,19 @@ static struct file_operations lpfc_debug
 	.release =      lpfc_debugfs_release,
 };
 
-#undef lpfc_debugfs_op_dumpslim
-static struct file_operations lpfc_debugfs_op_dumpslim = {
+#undef lpfc_debugfs_op_dumpHBASlim
+static struct file_operations lpfc_debugfs_op_dumpHBASlim = {
 	.owner =        THIS_MODULE,
-	.open =         lpfc_debugfs_dumpslim_open,
+	.open =         lpfc_debugfs_dumpHBASlim_open,
+	.llseek =       lpfc_debugfs_lseek,
+	.read =         lpfc_debugfs_read,
+	.release =      lpfc_debugfs_release,
+};
+
+#undef lpfc_debugfs_op_dumpHostSlim
+static struct file_operations lpfc_debugfs_op_dumpHostSlim = {
+	.owner =        THIS_MODULE,
+	.open =         lpfc_debugfs_dumpHostSlim_open,
 	.llseek =       lpfc_debugfs_lseek,
 	.read =         lpfc_debugfs_read,
 	.release =      lpfc_debugfs_release,
@@ -813,15 +893,27 @@ lpfc_debugfs_initialize(struct lpfc_vpor
 			goto debug_failed;
 		}
 
-		/* Setup dumpslim */
-		snprintf(name, sizeof(name), "dumpslim");
-		phba->debug_dumpslim =
+		/* Setup dumpHBASlim */
+		snprintf(name, sizeof(name), "dumpHBASlim");
+		phba->debug_dumpHBASlim =
+			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
+				 phba->hba_debugfs_root,
+				 phba, &lpfc_debugfs_op_dumpHBASlim);
+		if (!phba->debug_dumpHBASlim) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				"0409 Cannot create debugfs dumpHBASlim\n");
+			goto debug_failed;
+		}
+
+		/* Setup dumpHostSlim */
+		snprintf(name, sizeof(name), "dumpHostSlim");
+		phba->debug_dumpHostSlim =
 			debugfs_create_file(name, S_IFREG|S_IRUGO|S_IWUSR,
 				 phba->hba_debugfs_root,
-				 phba, &lpfc_debugfs_op_dumpslim);
-		if (!phba->debug_dumpslim) {
+				 phba, &lpfc_debugfs_op_dumpHostSlim);
+		if (!phba->debug_dumpHostSlim) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
-				"0409 Cannot create debugfs dumpslim\n");
+				"0409 Cannot create debugfs dumpHostSlim\n");
 			goto debug_failed;
 		}
 
@@ -971,9 +1063,13 @@ lpfc_debugfs_terminate(struct lpfc_vport
 			debugfs_remove(phba->debug_hbqinfo); /* hbqinfo */
 			phba->debug_hbqinfo = NULL;
 		}
-		if (phba->debug_dumpslim) {
-			debugfs_remove(phba->debug_dumpslim); /* dumpslim */
-			phba->debug_dumpslim = NULL;
+		if (phba->debug_dumpHBASlim) {
+			debugfs_remove(phba->debug_dumpHBASlim); /* HBASlim */
+			phba->debug_dumpHBASlim = NULL;
+		}
+		if (phba->debug_dumpHostSlim) {
+			debugfs_remove(phba->debug_dumpHostSlim); /* HostSlim */
+			phba->debug_dumpHostSlim = NULL;
 		}
 		if (phba->slow_ring_trc) {
 			kfree(phba->slow_ring_trc);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-01-11 01:23:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2008-01-11 01:28:11.000000000 -0500
@@ -578,7 +578,8 @@ struct lpfc_hba {
 	struct dentry *hba_debugfs_root;
 	atomic_t debugfs_vport_count;
 	struct dentry *debug_hbqinfo;
-	struct dentry *debug_dumpslim;
+	struct dentry *debug_dumpHostSlim;
+	struct dentry *debug_dumpHBASlim;
 	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
 	atomic_t slow_ring_trc_cnt;


