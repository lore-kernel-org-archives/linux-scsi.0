From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 10/34] scsi proc_ops: convert drivers/scsi/pcmcia/nsp_cs.c
Date: Wed, 22 Feb 2012 22:46:01 +0300
Message-ID: <1329939985-26793-10-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab2BVTqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:46:51 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:46:50 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/pcmcia/nsp_cs.c |   48 +++++++++++++++++------------------------
 drivers/scsi/pcmcia/nsp_cs.h |    8 +------
 2 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index b61a753..9eb0df6 100644
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
@@ -76,7 +78,7 @@ MODULE_PARM_DESC(free_ports, "Release IO ports after configuration? (default: 0
 
 static struct scsi_host_template nsp_driver_template = {
 	.proc_name	         = "nsp_cs",
-	.proc_info		 = nsp_proc_info,
+	.proc_ops		 = &nsp_proc_ops,
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
 
@@ -1459,21 +1450,22 @@ static int nsp_proc_info(struct Scsi_Host *host, char *buffer, char **start,
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
+static const struct file_operations nsp_proc_ops = {
+	.open		= nsp_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*---------------------------------------------------------------*/
 /* error handler                                                 */
 /*---------------------------------------------------------------*/
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 7fc9a9d..f3ced4c 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -292,13 +292,7 @@ static int        nsp_cs_config (struct pcmcia_device *link);
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
+static const struct file_operations nsp_proc_ops;
 static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
 
 /* Error handler */
-- 
1.7.3.4

