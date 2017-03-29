From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: qedi,qedf: Use designated initializers
Date: Wed, 29 Mar 2017 13:59:23 -0700
Message-ID: <20170329205923.GA39690@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

For these cases, terminate the list with { }, which will be zero-filled,
instead of undesignated NULLs.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/qedf/qedf_debugfs.c | 2 +-
 drivers/scsi/qedi/qedi_debugfs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index cb08b625c594..00a1d6405ebe 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -449,7 +449,7 @@ const struct file_operations qedf_dbg_fops[] = {
 	qedf_dbg_fileops(qedf, clear_stats),
 	qedf_dbg_fileops_seq(qedf, offload_stats),
 	/* This must be last */
-	{ NULL, NULL },
+	{ },
 };
 
 #else /* CONFIG_DEBUG_FS */
diff --git a/drivers/scsi/qedi/qedi_debugfs.c b/drivers/scsi/qedi/qedi_debugfs.c
index 59417199bf36..39d77818a677 100644
--- a/drivers/scsi/qedi/qedi_debugfs.c
+++ b/drivers/scsi/qedi/qedi_debugfs.c
@@ -240,5 +240,5 @@ const struct file_operations qedi_dbg_fops[] = {
 	qedi_dbg_fileops_seq(qedi, gbl_ctx),
 	qedi_dbg_fileops(qedi, do_not_recover),
 	qedi_dbg_fileops_seq(qedi, io_trace),
-	{ NULL, NULL },
+	{ },
 };
-- 
2.7.4


-- 
Kees Cook
Pixel Security
