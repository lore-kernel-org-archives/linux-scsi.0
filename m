From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 29/34] scsi proc_ops: convert drivers/ata/sata_svw.c
Date: Wed, 22 Feb 2012 22:46:20 +0300
Message-ID: <1329939985-26793-29-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2BVTrZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:25 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:25 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/ata/sata_svw.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index c646118..05838bf 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -289,23 +289,12 @@ static u8 k2_stat_check_status(struct ata_port *ap)
 }
 
 #ifdef CONFIG_PPC_OF
-/*
- * k2_sata_proc_info
- * inout : decides on the direction of the dataflow and the meaning of the
- *	   variables
- * buffer: If inout==FALSE data is being written to it else read from it
- * *start: If inout==FALSE start of the valid data in the buffer
- * offset: If inout==FALSE offset from the beginning of the imaginary file
- *	   from which we start writing into the buffer
- * length: If inout==FALSE max number of bytes to be written into the buffer
- *	   else number of bytes in the buffer
- */
-static int k2_sata_proc_info(struct Scsi_Host *shost, char *page, char **start,
-			     off_t offset, int count, int inout)
+static int k2_sata_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *shost = m->private;
 	struct ata_port *ap;
 	struct device_node *np;
-	int len, index;
+	int index;
 
 	/* Find  the ata_port */
 	ap = ata_shost_to_port(shost);
@@ -329,17 +318,28 @@ static int k2_sata_proc_info(struct Scsi_Host *shost, char *page, char **start,
 	if (np == NULL)
 		return 0;
 
-	len = sprintf(page, "devspec: %s\n", np->full_name);
+	seq_printf(m, "devspec: %s\n", np->full_name);
+	return 0;
+}
 
-	return len;
+static int k2_sata_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, k2_sata_proc_show, PDE(inode)->data);
 }
+
+static const struct file_operations k2_sata_proc_ops = {
+	.open		= k2_sata_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif /* CONFIG_PPC_OF */
 
 
 static struct scsi_host_template k2_sata_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 #ifdef CONFIG_PPC_OF
-	.proc_info		= k2_sata_proc_info,
+	.proc_ops		= &k2_sata_proc_ops,
 #endif
 };
 
-- 
1.7.3.4

