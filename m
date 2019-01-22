From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6/7] scsi: qlogic: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:09:05 +0100
Message-ID: <20190122150906.12470-7-gregkh@linuxfoundation.org>
References: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122150906.12470-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, QLogic-Storage-Upstream@cavium.com
List-Id: linux-scsi@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: QLogic-Storage-Upstream@cavium.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 18 ++----------------
 drivers/scsi/qedi/qedi_debugfs.c | 17 ++---------------
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index c29c162a494f..a32d8ee4666e 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -27,30 +27,19 @@ qedf_dbg_host_init(struct qedf_dbg_ctx *qedf,
 		    const struct file_operations *fops)
 {
 	char host_dirname[32];
-	struct dentry *file_dentry = NULL;
 
 	QEDF_INFO(qedf, QEDF_LOG_DEBUGFS, "Creating debugfs host node\n");
 	/* create pf dir */
 	sprintf(host_dirname, "host%u", qedf->host_no);
 	qedf->bdf_dentry = debugfs_create_dir(host_dirname, qedf_dbg_root);
-	if (!qedf->bdf_dentry)
-		return;
 
 	/* create debugfs files */
 	while (dops) {
 		if (!(dops->name))
 			break;
 
-		file_dentry = debugfs_create_file(dops->name, 0600,
-						  qedf->bdf_dentry, qedf,
-						  fops);
-		if (!file_dentry) {
-			QEDF_INFO(qedf, QEDF_LOG_DEBUGFS,
-				   "Debugfs entry %s creation failed\n",
-				   dops->name);
-			debugfs_remove_recursive(qedf->bdf_dentry);
-			return;
-		}
+		debugfs_create_file(dops->name, 0600, qedf->bdf_dentry, qedf,
+				    fops);
 		dops++;
 		fops++;
 	}
@@ -80,9 +69,6 @@ qedf_dbg_init(char *drv_name)
 
 	/* create qed dir in root of debugfs. NULL means debugfs root */
 	qedf_dbg_root = debugfs_create_dir(drv_name, NULL);
-	if (!qedf_dbg_root)
-		QEDF_INFO(NULL, QEDF_LOG_DEBUGFS, "Init of debugfs "
-			   "failed\n");
 }
 
 /**
diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index fd914ca4149a..5667e4752e2e 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -23,27 +23,16 @@ qedi_dbg_host_init(struct qedi_dbg_ctx *qedi,
 		   const struct file_operations *fops)
 {
 	char host_dirname[32];
-	struct dentry *file_dentry = NULL;
 
 	sprintf(host_dirname, "host%u", qedi->host_no);
 	qedi->bdf_dentry = debugfs_create_dir(host_dirname, qedi_dbg_root);
-	if (!qedi->bdf_dentry)
-		return;
 
 	while (dops) {
 		if (!(dops->name))
 			break;
 
-		file_dentry = debugfs_create_file(dops->name, 0600,
-						  qedi->bdf_dentry, qedi,
-						  fops);
-		if (!file_dentry) {
-			QEDI_INFO(qedi, QEDI_LOG_DEBUGFS,
-				  "Debugfs entry %s creation failed\n",
-				  dops->name);
-			debugfs_remove_recursive(qedi->bdf_dentry);
-			return;
-		}
+		debugfs_create_file(dops->name, 0600, qedi->bdf_dentry, qedi,
+				    fops);
 		dops++;
 		fops++;
 	}
@@ -60,8 +49,6 @@ void
 qedi_dbg_init(char *drv_name)
 {
 	qedi_dbg_root = debugfs_create_dir(drv_name, NULL);
-	if (!qedi_dbg_root)
-		QEDI_INFO(NULL, QEDI_LOG_DEBUGFS, "Init of debugfs failed\n");
 }
 
 void
-- 
2.20.1
