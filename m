From: Jes Sorensen <jes@wildopensource.com>
Subject: qla1280 v 3.23.35
Date: Thu, 14 Aug 2003 11:41:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <16187.44479.878515.830263@trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trained-monkey.org ([209.217.122.11]:14610 "EHLO
	trained-monkey.org") by vger.kernel.org with ESMTP id S272397AbTHNPmF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Aug 2003 11:42:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com, Christoph Hellwig <hch@lst.de>

Hi,

This patch might make the qla1280 driver build again in Linus' bk
tree. I don't have those sources here so I made the changes relative to
2.6.0-test2 and I am out of space on my laptop

Only compile tested, but if it works it works ;-)

Cheers,
Jes

--- drivers/scsi/qla1280.c~	Wed Jul 23 13:06:31 2003
+++ drivers/scsi/qla1280.c	Thu Aug 14 11:34:19 2003
@@ -16,9 +16,11 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.23.34"
+#define QLA1280_VERSION      "3.23.35"
 /*****************************************************************************
     Revision History:
+    Rev  3.23.35 August 14, 2003, Jes Sorensen
+	- Build against 2.6
     Rev  3.23.34 July 23, 2003, Jes Sorensen
 	- Remove pointless TRUE/FALSE macros
 	- Clean up vchan handling
@@ -296,14 +298,12 @@
 #include <linux/sched.h>
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
-#include <linux/blk.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
 #include <linux/pci_ids.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 
-
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -312,7 +312,10 @@
 #include <asm/system.h>
 
 #if LINUX_VERSION_CODE < 0x020545
+#include <linux/blk.h>
 #include "sd.h"
+#else
+#include <scsi/scsi_host.h>
 #endif
 #include "scsi.h"
 #include "hosts.h"
@@ -646,11 +649,14 @@
  *************************************************************************/
 #define	PROC_BUF	&qla1280_buffer[len]
 
-int
-qla1280_proc_info(char *buffer, char **start, off_t offset, int length,
-		  int hostno, int inout)
+#if LINUX_VERSION_CODE < 0x020600
+int qla1280_proc_info(char *buffer, char **start, off_t offset, int length,
+		      int hostno, int inout)
+#else
+int qla1280_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+		      off_t offset, int length, int inout)
+#endif
 {
-	struct Scsi_Host *host;
 	struct scsi_qla_host *ha;
 	int size = 0;
 	int len = 0;
@@ -659,7 +665,10 @@
 	struct scsi_lu *up;
 	uint32_t b, t, l;
 #endif
-
+#if LINUX_VERSION_CODE >= 0x020600
+	ha = (struct scsi_qla_host *)host->hostdata;
+#else
+	struct Scsi_Host *host;
 	/* Find the host that was specified */
 	for (ha = qla1280_hostlist; (ha != NULL)
 		     && ha->host->host_no != hostno; ha = ha->next) ;
@@ -676,6 +685,7 @@
 	}
 
 	host = ha->host;
+#endif
 
 	if (inout)
 		return -ENOSYS;
@@ -1026,11 +1036,6 @@
 		qla1280_setup(qla1280);
 #endif
 
-	if (!pci_present()) {
-		printk(KERN_INFO "scsi: PCI not present\n");
-		return 0;
-	}
-
 	bdp = &ql1280_board_tbl[0];
 	qla1280_hostlist = NULL;
 	template->proc_name = "qla1280";
@@ -1845,7 +1850,7 @@
 		CMD_HANDLE(sp->cmd) = (unsigned char *)INVALID_HANDLE;
 		ha->actthreads--;
 
-#if LINUX_KERNEL_VERSION < 0x020500
+#if LINUX_VERSION_CODE < 0x020500
 		if (cmd->cmnd[0] == INQUIRY)
 			qla1280_get_target_options(cmd, ha);
 #endif
@@ -4514,7 +4519,7 @@
 }
 
 
-#if LINUX_KERNEL_VERSION < 0x020500
+#if LINUX_VERSION_CODE < 0x020500
 /*
  *
  */
--- drivers/scsi/qla1280.h~	Wed Jul 23 12:39:47 2003
+++ drivers/scsi/qla1280.h	Thu Aug 14 11:29:39 2003
@@ -1111,7 +1111,11 @@
 /*
  *  Linux - SCSI Driver Interface Function Prototypes.
  */
+#if LINUX_VERSION_CODE < 0x020600
 int qla1280_proc_info(char *, char **, off_t, int, int, int);
+#else
+int qla1280_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
+#endif
 const char *qla1280_info(struct Scsi_Host *host);
 int qla1280_detect(Scsi_Host_Template *);
 int qla1280_release(struct Scsi_Host *);
@@ -1147,8 +1151,6 @@
 	.detect = qla1280_detect,				\
 	.release = qla1280_release,				\
 	.info = qla1280_info,					\
-	.ioctl = NULL,						\
-	.command = NULL,					\
 	.queuecommand = qla1280_queuecommand,			\
 	.eh_strategy_handler = NULL,				\
 	.eh_abort_handler = qla1280_eh_abort,			\
