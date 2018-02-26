From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: qedi: fix build regression
Date: Mon, 26 Feb 2018 10:44:14 +0100
Message-ID: <20180226094422.2607574-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Manish Rangankar <Manish.Rangankar@cavium.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A bugfix I did caused a build regression in some other randconfig
builds in a rare combination of options:

In file included from drivers/scsi/qedi/qedi_fw.c:16:
drivers/scsi/qedi/qedi_gbl.h:26:38: error: array type has incomplete element type 'struct qedi_debugfs_ops'
 extern const struct qedi_debugfs_ops qedi_debugfs_ops[];
                                      ^~~~~~~~~~~~~~~~

This removes the useless #ifdef around the declarations in qedi_dbg.h
to make it always build.

Fixes: 779936faf4f1 ("scsi: qedi: fix building with LTO")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qedi/qedi_dbg.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_dbg.h b/drivers/scsi/qedi/qedi_dbg.h
index 358f40567849..0bc9c31d5a4f 100644
--- a/drivers/scsi/qedi/qedi_dbg.h
+++ b/drivers/scsi/qedi/qedi_dbg.h
@@ -103,7 +103,6 @@ int qedi_create_sysfs_attr(struct Scsi_Host *shost,
 void qedi_remove_sysfs_attr(struct Scsi_Host *shost,
 			    struct sysfs_bin_attrs *iter);
 
-#ifdef CONFIG_DEBUG_FS
 /* DebugFS related code */
 struct qedi_list_of_funcs {
 	char *oper_str;
@@ -139,6 +138,5 @@ void qedi_dbg_host_init(struct qedi_dbg_ctx *qedi,
 void qedi_dbg_host_exit(struct qedi_dbg_ctx *qedi);
 void qedi_dbg_init(char *drv_name);
 void qedi_dbg_exit(void);
-#endif /* CONFIG_DEBUG_FS */
 
 #endif /* _QEDI_DBG_H_ */
-- 
2.9.0
