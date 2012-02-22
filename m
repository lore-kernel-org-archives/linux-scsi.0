From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 03/34] scsi proc_ops: convert drivers/scsi/nsp32.c
Date: Wed, 22 Feb 2012 22:45:54 +0300
Message-ID: <1329939985-26793-3-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab2BVTqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:38 -0500
Received: by bkcjm19 with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:37 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/nsp32.c |   50 +++++++++++++++++++-------------------------------
 1 files changed, 19 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0029249..5ea29a6 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -33,6 +33,8 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/dma-mapping.h>
@@ -193,7 +195,7 @@ static int  __init    init_nsp32  (void);
 static void __exit    exit_nsp32  (void);
 
 /* struct struct scsi_host_template */
-static int         nsp32_proc_info   (struct Scsi_Host *, char *, char **, off_t, int, int);
+static const struct file_operations nsp32_proc_ops;
 
 static int         nsp32_detect      (struct pci_dev *pdev);
 static int         nsp32_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
@@ -269,7 +271,7 @@ static void nsp32_dmessage(const char *, int, int,    char *, ...);
 static struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
-	.proc_info			= nsp32_proc_info,
+	.proc_ops			= &nsp32_proc_ops,
 	.info				= nsp32_info,
 	.queuecommand			= nsp32_queuecommand,
 	.can_queue			= 1,
@@ -1444,18 +1446,11 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 
 #undef SPRINTF
 #define SPRINTF(args...) \
-	do { \
-		if(length > (pos - buffer)) { \
-			pos += snprintf(pos, length - (pos - buffer) + 1, ## args); \
-			nsp32_dbg(NSP32_DEBUG_PROC, "buffer=0x%p pos=0x%p length=%d %d\n", buffer, pos, length,  length - (pos - buffer));\
-		} \
-	} while(0)
-
-static int nsp32_proc_info(struct Scsi_Host *host, char *buffer, char **start,
-			   off_t offset, int length, int inout)
+	seq_printf(m, ## args)
+
+static int nsp32_proc_show(struct seq_file *m, void *v)
 {
-	char             *pos = buffer;
-	int               thislength;
+	struct Scsi_Host *host = m->private;
 	unsigned long     flags;
 	nsp32_hw_data    *data;
 	int               hostno;
@@ -1464,11 +1459,6 @@ static int nsp32_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 	int               id, speed;
 	long              model;
 
-	/* Write is not supported, just return. */
-	if (inout == TRUE) {
-		return -EINVAL;
-	}
-
 	hostno = host->host_no;
 	data = (nsp32_hw_data *)host->hostdata;
 	base = host->io_port;
@@ -1529,23 +1519,21 @@ static int nsp32_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 		SPRINTF("\n");
 	}
 
-
-	thislength = pos - (buffer + offset);
-
-	if(thislength < 0) {
-		*start = NULL;
-                return 0;
-        }
-
-
-	thislength = min(thislength, length);
-	*start = buffer + offset;
-
-	return thislength;
+	return 0;
 }
 #undef SPRINTF
 
+static int nsp32_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nsp32_proc_show, PDE(inode)->data);
+}
 
+static const struct file_operations nsp32_proc_ops = {
+	.open		= nsp32_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 /*
  * Reset parameters and call scsi_done for data->cur_lunt.
-- 
1.7.3.4

