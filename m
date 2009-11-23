From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 04/27] scsi proc_fops: convert nsp32
Date: Mon, 23 Nov 2009 04:32:32 +0300
Message-ID: <20091123013232.GD31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:44479 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZKWBds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:33:48 -0500
Received: by ey-out-2122.google.com with SMTP id 4so885718eyf.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:33:54 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/nsp32.c |   52 +++++++++++++++++++--------------------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -34,6 +34,8 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
 #include <linux/dma-mapping.h>
@@ -194,7 +196,7 @@ static int  __init    init_nsp32  (void);
 static void __exit    exit_nsp32  (void);
 
 /* struct struct scsi_host_template */
-static int         nsp32_proc_info   (struct Scsi_Host *, char *, char **, off_t, int, int);
+static const struct file_operations nsp32_proc_fops;
 
 static int         nsp32_detect      (struct pci_dev *pdev);
 static int         nsp32_queuecommand(struct scsi_cmnd *,
@@ -271,7 +273,7 @@ static void nsp32_dmessage(const char *, int, int,    char *, ...);
 static struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
-	.proc_info			= nsp32_proc_info,
+	.proc_fops			= &nsp32_proc_fops,
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
@@ -1529,23 +1519,22 @@ static int nsp32_proc_info(struct Scsi_Host *host, char *buffer, char **start,
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
 
+static const struct file_operations nsp32_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nsp32_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 
 /*
  * Reset parameters and call scsi_done for data->cur_lunt.
-- 
1.6.5.2

