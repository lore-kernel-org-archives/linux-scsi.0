From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 11/27] scsi proc_fops: convert nsp_cs
Date: Mon, 23 Nov 2009 04:36:24 +0300
Message-ID: <20091123013624.GK31711@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:27816 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbZKWBhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2009 20:37:40 -0500
Received: by ey-out-2122.google.com with SMTP id 4so886035eyf.19
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2009 17:37:46 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/pcmcia/nsp_cs.c |   49 ++++++++++++++++++-------------------------
 drivers/scsi/pcmcia/nsp_cs.h |    9 -------
 2 files changed, 22 insertions(+), 36 deletions(-)

--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -36,6 +36,8 @@
 #include <linux/interrupt.h>
 #include <linux/major.h>
 #include <linux/blkdev.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/stat.h>
 
 #include <asm/io.h>
@@ -78,7 +80,7 @@ MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0
 
 static struct scsi_host_template nsp_driver_template = {
 	.proc_name	         = "nsp_cs",
-	.proc_info		 = nsp_proc_info,
+	.proc_fops		 = &nsp_proc_fops,
 	.name			 = "WorkBit NinjaSCSI-3/32Bi(16bit)",
 	.info			 = nsp_info,
 	.queuecommand		 = nsp_queuecommand,
@@ -1366,28 +1368,17 @@ static const char *nsp_info(struct Scsi_Host *shpnt)
 
 #undef SPRINTF
 #define SPRINTF(args...) \
-        do { \
-		if(length > (pos - buffer)) { \
-			pos += snprintf(pos, length - (pos - buffer) + 1, ## args); \
-			nsp_dbg(NSP_DEBUG_PROC, "buffer=0x%p pos=0x%p length=%d %d\n", buffer, pos, length,  length - (pos - buffer));\
-		} \
-	} while(0)
-
-static int nsp_proc_info(struct Scsi_Host *host, char *buffer, char **start,
-			 off_t offset, int length, int inout)
+	seq_printf(m, ## args)
+
+static int nsp_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *host = m->private;
 	int id;
-	char *pos = buffer;
-	int thislength;
 	int speed;
 	unsigned long flags;
 	nsp_hw_data *data;
 	int hostno;
 
-	if (inout) {
-		return -EINVAL;
-	}
-
 	hostno = host->host_no;
 	data = (nsp_hw_data *)host->hostdata;
 
@@ -1459,21 +1450,23 @@ static int nsp_proc_info(struct Scsi_Host *host, char *buffer, char **start,
 		SPRINTF("\n");
 	}
 
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
 
+static int nsp_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nsp_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations nsp_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nsp_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*---------------------------------------------------------------*/
 /* error handler                                                 */
 /*---------------------------------------------------------------*/
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -293,13 +293,7 @@ static int        nsp_cs_config (struct pcmcia_device *link);
 /* Linux SCSI subsystem specific functions */
 static struct Scsi_Host *nsp_detect     (struct scsi_host_template *sht);
 static const  char      *nsp_info       (struct Scsi_Host *shpnt);
-static        int        nsp_proc_info  (
-	                                 struct Scsi_Host *host,
-					 char   *buffer,
-					 char  **start,
-					 off_t   offset,
-					 int     length,
-					 int     inout);
+static const struct file_operations nsp_proc_fops;
 static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 			    void (* done)(struct scsi_cmnd *SCpnt));
 
-- 
1.6.5.2

